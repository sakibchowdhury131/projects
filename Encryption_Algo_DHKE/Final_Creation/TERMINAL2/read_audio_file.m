clear
clc

[y,Fs] = audioread('Recording.m4a');
plot (y)
sound (y,Fs);
filename = 'handel.wav';
audiowrite(filename,y,Fs);
