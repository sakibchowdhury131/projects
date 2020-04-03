clear all;
close all;

%% Window
% N = 500;
% w = window(@blackmanharris,N);
% w1 = window(@hamming,N); 
% w2 = window(@gausswin,N,2.5); 
% wvtool(w,w1,w2)vb 

%% kaiser
delp = 0.05;
dels = 0.005;
del = min(delp,dels);
ws = 2.2;
wp = 1.8;
A = -20*log10(del);
M = ceil(1+ (A-8)/(2.285*(ws - wp)));
if A>50
    beta = 0.1102*(A-8.7);
elseif 21<=A<=50
    beta = 0.5842*((A-21)^0.4)+0.07886*(A-21);
else
    beta = 0;
end
w_kaiser= kaiser(M,beta);
wvtool(w_kaiser)

%% sinc function 
wc = 2.1;
n = 0: M-1;
hc = (wc/pi)*sinc((wc/pi)*(n-(M-1)/2));
plot (n,hc);

%% filter
fir_filter = hc.*w_kaiser';
plot (fftshift(abs(fft((fir_filter)))))
