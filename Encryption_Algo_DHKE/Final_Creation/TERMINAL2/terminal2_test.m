%%
clear
clc
t1 = tcpip('0.0.0.0', 300, 'NetworkRole', 'client');
fopen(t1);
disp ('terminal 2 is connected to server');
tts ('terminal 2 is connected to server');
%% this part will generate and modulate keys

while 1
if t1.bytesAvailable > 0 
qq= str2num(fscanf(t1));
if max(size(qq))~= 0 
   q=qq;
   fprintf (t1,'1');
   disp('q received')
   break;
end
end
end

while 1
if t1.bytesAvailable > 0 
pp= str2num(fscanf(t1));
if max(size(pp))~= 0 
   p=pp;
   fprintf (t1,'1');
   disp('p received')
   break;
end
end
end
%%
while 1
if t1.bytesAvailable > 0 
AAA= str2num(fscanf(t1));
if max(size(AAA))~= 0 
   Aa=AAA;
   fprintf (t1,'1');
   disp('Aa received')
   break;
end
end
end
%%
b=randi ([1,q-1],1,1);% primary secret key 
Bb=Mod(p,b,q);  %modulated key with public keys
BBB=num2str(Bb);
fprintf (t1, BBB);
while 1
if t1.bytesAvailable > 0 
state= str2num(fscanf(t1));
if max(size(state))~= 0 && state == 1
   disp('Bb sent')
   break;
end
end
end
%%
Sec_key=Mod(Aa,b,q);
disp ('connection successfull')
disp (Sec_key)
%% 
while 1
    message = input('message>>');
enc_msg=num2str(encrypt (message,Sec_key));
    fprintf (t,enc_msg);
    while 1
      if t1.bytesAvailable > 0 
         raw_data= fscanf(t1);
         if max(size(raw_data))>5 
         enc_msg=raw_data;
         %fprintf (t1,'1');
         disp('message received')
         break;
         end
      end
     end

%%
     dim=length (enc_msg);
     col = 9;
      row = (dim-1)/col;
      n=1;
     data= zeros (row,col);
      for j=1:col 
         for i = 1:row 
         data (i,j)= str2num(enc_msg (1,n));
          n=n+1;
         end
      end
%%
    Pro_data=zeros (row ,1);
       for i = 1:row
           for j= 1:9
             Pro_data(i ,1)= Pro_data (i ,1)+ data (i,j)*10^(9-j);
           end
       end
       %disp ('done')
     decrypt (Pro_data,row,Sec_key)
end