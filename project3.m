%% generating incident signal on the tumor
clc
clear all;
close all;

inc_amplitude = 1;
inc_frequency = 500;
tstep = 0.00001;
t = 0:tstep:0.01;
incident_sig = inc_amplitude* sin (2*pi*inc_frequency*t);
figure
plot (t, incident_sig)

%% generating signal output after passing through the tumor
out_amplitude = 0.01;
out_frequency = 1500;
output_sig = out_amplitude*sin(2*pi*out_frequency*t);
figure
plot(t,output_sig)

%% adding noise to the output signal
SNR = 10;
Sig_Power = 15;
Noisy_Signal = awgn(output_sig , SNR , Sig_Power);
figure
plot (t, Noisy_Signal)

%% performing correlation 
sig_correlation = xcorr (incident_sig,Noisy_Signal);
sig_correlation = sig_correlation / max(sig_correlation);
x_new = tstep* (-length(t)+1:length(t)-1);
plot (x_new,sig_correlation)

rms_correlation = sqrt(sum(sig_correlation.^2)/ length(sig_correlation));
disp(rms_correlation)