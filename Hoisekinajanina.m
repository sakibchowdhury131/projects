clc; clear all; close all;

%% declaration 

Fs = 300; % not sure yet . ask sir. 
dt = 1/Fs;
tolerance = 5;




load ('0023_8min.mat')
x = signal.pleth.y(1:10001,1); 
DFT_points = length(signal.pleth.y(1:10001,1));
t = 0:length(x)-1;
plot (t,x)
title ('input signal')
xlabel('sample number')
ylabel ('Amplitude')
n_bef = linspace(-Fs*60/2,Fs*60/2,DFT_points); % converting frequency to bpm
x_bef_fil = fft(x,DFT_points);


figure
stem (n_bef , fftshift(abs(x_bef_fil)))% magnitude spectrum before filtering
title('Frequency spectrum before filtering')
xlabel('BPM')
ylabel('Amplitude')
%% Highpass
wcH_bpm = 30;  % lower cutoff of the filter in BPM 


wpH=((wcH_bpm-tolerance)/60)/Fs*2*pi;
wcH=(wcH_bpm/60)/Fs*2*pi;
wsH=((wcH_bpm+tolerance)/60)/Fs*2*pi;
dpH=.05;
dsH=.005;
dH=min(dpH,dsH);
AH=-20*log10(dH);
if AH>50
    BH=.1102*(AH-8.7);
elseif (AH<=50 && AH>=21)
    BH=.5842*(AH-21)^.4+.07886*(AH-21);
else
    BH=0;
end


MH=ceil(1+(AH-8)/2.285/abs(wsH-wpH));
nH = 0:MH-1;
wH=linspace(-Fs*60/2,Fs*60/2,DFT_points);
hc_h = sinc((nH-(MH-1)/2)) - wcH/pi*sinc(wcH/pi*(nH-(MH-1)/2));
ksH=kaiser(MH,BH);


figure 
plot(nH,ksH)
title ('Kaiser Window');
xlabel('Sample Number')
ylabel('Amplitude')



yH=ksH'.*hc_h;


figure
plot(nH,yH)
title(' High Pass Filter')
xlabel('Sample Number')
ylabel('Amplitude')

YH=fft(yH,DFT_points);
yH_mag=fftshift(abs(YH));
figure
plot(wH,yH_mag)
title ('Filter Frequency Response')
xlabel('BPM')
ylabel ('Amplitude')

%% highpass filtered
filtered_sigH = filter (yH,1,x);


figure
plot (linspace(-Fs*60/2,Fs*60/2,DFT_points),fftshift(abs(fft(filtered_sigH,DFT_points))))
title ('Frequency response of filtered signal')
xlabel ('BPM')
ylabel ('Amplitude')

%% Lowpass 
wcL_bpm = 200;


wpL=((wcL_bpm-tolerance)/60)/Fs*2*pi;
wcL=(wcL_bpm/60)/Fs*2*pi;
wsL=((wcL_bpm+tolerance)/60)/Fs*2*pi;
dpL=.05;
dsL=.005;
dL=min(dpL,dsL);
AL=-20*log10(dL);
if AL>50
    BL=.1102*(AL-8.7);
elseif (AL<=50 && AL>=21)
   BL=.5842*(AL-21)^.4+.07886*(AL-21);
else
   BL=0;
end


ML=ceil(1+(AL-8)/2.285/(wsL-wpL));
nL = 0:ML-1;
wL=linspace(-Fs*60/2,Fs*60/2,DFT_points);
ksL=kaiser(ML,BL);

figure
plot(nL,ksL)
title ('Kaiser window for lowpass')
xlabel ('Sample Number')
ylabel ('Amplitude')


hL = wcL/pi*sinc(wcL/pi*(nL-(ML-1)/2));
yL=ksL'.*hL;


figure
plot(nL,yL)
title ('Low pass Filter')
xlabel ('sample Number')
ylabel ('Amplitude')

YL=fft(yL,DFT_points);
yL_mag=fftshift(abs(YL));

figure
plot(wL,yL_mag)
title ('Frequency Response of Low Pass Filter')
xlabel('BPM')
ylabel('Amplitude')


%% low pass filtered

filtered_sigL = filter (yL,1,filtered_sigH);

figure
plot (linspace(-Fs*60/2,Fs*60/2,DFT_points),fftshift(abs(fft(filtered_sigL,DFT_points))))
title ('Final Frequency response')
xlabel('BPM')
ylabel('Amplitude')


figure
plot (t,filtered_sigL);
title ('Filtered Signal')
xlabel('sample number')
ylabel ('Amplitude')


%% verification using Autocorrelation
x_axis = (-length(x)+1:length(x)-1)*3.33*10^-3;
x_x = xcorr(x)';
figure
plot (x_axis,x_x)
