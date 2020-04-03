%% connecting to server
clear
clc
t = tcpip('0.0.0.0', 30000, 'NetworkRole', 'server');%connection to terminal1

t1 = tcpip('192.168.1.35', 300, 'NetworkRole', 'server');%connection to terminal2
disp ('waiting for client response');
tts ('waiting for client response')
fopen(t);
disp('connected to terminal 1');
fopen (t1);
disp('connected to terminal 2' );
%%
while 1
if t.bytesAvailable > 0 
data= fscanf(t);
fprintf(t1,data);
disp(data)
end
if t1.bytesAvailable > 0 
data= fscanf(t1);
fprintf(t,data);
disp(data)
end
end