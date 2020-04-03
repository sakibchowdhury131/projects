clc; clear all; close all;
%% filter
wp=1.8;
wc=0.2;
ws=2.2;
dp=.05;
ds=.005;
d=min(dp,ds);
A=-20*log10(d);
if A>50
    B=.1102*(A-8.7);
elseif (A<=50 && A>=21)
    B=.5842*(A-21)^.4+.07886*(A-21);
else
    B=0;
end


M=ceil(1+(A-8)/2.285/(ws-wp));
w=linspace(-3*pi,3*pi,101);
H=zeros(1,length(w));
H(abs(w)<wc)=1;
plot(w,H)

h=ifftshift(ifft(H));
n=linspace(-length(w)/2+0.5,length(w)/2-0.5,length(w));
figure(2)
plot(n,h)
ks=kaiser(M,B);
k=zeros(1,length(h));
k(abs(n)<=(M-1)/2)=ks;
figure(3)
plot(n,k)

n = 0: M-1;
hc = (wc/pi)*sinc((wc/pi)*(n-(M-1)/2));
plot (n,hc);
y=k.*hc;
figure(4)
plot(n,y)

Y=fft(y);
figure(5)
plot(w,abs(Y))

%% loading dataset 
ppg_data = load('1.mat');
ppg = ppg_data.sig;
ppg1 = ppg(1,:);
filtered_sig=conv (ppg1,y);
plot(filtered_sig)