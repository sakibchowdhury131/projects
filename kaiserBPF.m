clear all, close all, clc

wp = 2.2;
ws = 1.8;
wc = 2.0;
dp = 0.05;
ds = 0.005;

DFT_PTS = 1024; %number of DFT point

d = min(dp,ds);
A = -20*log10(d);
N = ceil(1+ (A-8)/(2.285*(abs(ws-wp))));
if A>50
    B = 0.1102*(A-8.7);
elseif A>=21 & A<=50
    B = 0.5842*(A-21)^0.4 + 0.07886*(A-21);
else
    B = 0;
end

w = kaiser(N,B);
W = abs(fftshift(fft(w,DFT_PTS)));
W = W(DFT_PTS/2+1:end);
W_dB = 20*log10(W);

n = 0:N-1; %sample no
fn = pi/(DFT_PTS/2):pi/(DFT_PTS/2):pi;

hc = sinc((n-(N-1)/2)) - wc/pi*sinc(wc/pi*(n-(N-1)/2));
Hc = abs(fftshift(fft(hc,DFT_PTS)));
Hc = Hc(DFT_PTS/2+1:end);
Hc_dB = 20*log10(Hc);

h = hc.*w';
H = abs(fftshift(fft(h,DFT_PTS)));
H = H(DFT_PTS/2+1:end);
H_dB = 20*log10(H);

figure(1)
subplot(331), stem(n,hc)
subplot(332), plot(fn, Hc), title('sinc filter')
subplot(333), plot(fn, Hc_dB)

subplot(334), stem(n,w)
subplot(335), plot(fn, W), title('Kaiser Window')
subplot(336), plot(fn, W_dB)

subplot(337), stem(n,h)
subplot(338), plot(fn, H), title('final FIR Filter')
subplot(339), plot(fn, H_dB)


%% find cutoff, passband, stopband
[cutoff,idx_cutoff] = min(abs(H-2^-0.5));
idx_stop = idx_cutoff;
idx_pass = idx_cutoff;

prev_error = abs(H(idx_cutoff)-1); % find ws
for k = idx_cutoff + 1 : DFT_PTS/2
    error = abs(H(k)-1);
    if error < prev_error
        idx_stop = k;
        prev_error = error;
    else
        break;
    end
end

prev_error = abs(H(idx_cutoff)); % find wp
for k = idx_cutoff - 1 : -1 : 1
    error = abs(H(k));
    if error < prev_error
        idx_pass = k;
        prev_error = error;
    else
        break;
    end
end

Y = [-100,100];
X_pass = [fn(idx_pass), fn(idx_pass)];
X_stop = [fn(idx_stop), fn(idx_stop)];

passband_freq = fn(idx_pass)
stopband_freq = fn(idx_stop)
cutoff_freq = fn(idx_cutoff)

figure(2)
%show entire filter
plot(fn, H), hold on
plot(fn(idx_cutoff),2^-0.5,'o'), hold on
plot(X_pass,Y,'k'), hold on
plot(X_stop,Y,'k'), hold off
title('DFT of filter')
xlabel('Omega'), ylabel('Gain');
xlim([0,pi]),ylim([min(H)-0.1,max(H)+0.1]);
txt1 = '\leftarrow Stopband\rightarrow';
text(X_pass(1),0.5,txt1,'HorizontalAlignment','right');
txt2 = '\leftarrow Passband\rightarrow';
text(X_stop(1),0.5,txt2);
