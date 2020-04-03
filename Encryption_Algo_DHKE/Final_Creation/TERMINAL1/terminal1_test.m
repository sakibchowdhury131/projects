clear
clc

t = tcpip('0.0.0.0', 30000, 'NetworkRole', 'client');

fopen(t);
disp('terminal 1 is connected to server');
tts('terminal 1 is connected to server');
%%
[q,p]=generate_public_key();
qq=num2str(q);
fprintf (t, qq);
while 1
if t.bytesAvailable > 0 
state= str2num(fscanf(t));
if max(size(state))~= 0 && state == 1
   disp('q sent')
   break;
end
end
end

pp=num2str(p);
fprintf (t, pp);
while 1
   if t.bytesAvailable > 0 
     state= str2num(fscanf(t));
     if max(size(state))~= 0 && state == 1
        disp('p sent')
        break;
     end
   end
end

%% 
a=randi ([1,q-1],1,1);% primary secret key 
Aa=Mod(p,a,q);  %modulated key with public keys
AAA=num2str(Aa);
fprintf (t, AAA);
while 1
    if t.bytesAvailable > 0 
        state= str2num(fscanf(t));
        if max(size(state))~= 0 && state == 1
        disp('Aa sent')
        break;
        end
    end
end
%%
while 1
    if t.bytesAvailable > 0 
       BBB= str2num(fscanf(t));
       if max(size(BBB))~= 0 
         Bb=BBB;
         fprintf (t,'1');
         disp('Bb received')
         break;
       end
    end
end
%%
Sec_key=Mod(Bb,a,q);
disp ('connection successfull')
disp (Sec_key)
%% 
while 1
    message = input ('message>>' , 's');
    enc_msg=num2str(encrypt (message,Sec_key));
    fprintf (t,enc_msg);
end
    