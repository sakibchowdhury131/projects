
[Fs,y] = audioread('Recording.m4a');
dim = size (Fs);
count= 1;
fprintf (t,num2str(dim(1,1)) );
while 1
    if t.bytesAvailable > 0 
        state= str2num(fscanf(t));
        if max(size(state))~= 0 && state == 1
        disp('dim(1,1) sent ')
        break;
        end
    end
end
fprintf (t,num2str(dim(1,2)) );
while 1
    if t.bytesAvailable > 0 
        state= str2num(fscanf(t));
        if max(size(state))~= 0 && state == 1
        disp('dim(1,2) sent ')
        break;
        end
    end
end

%%

    for j=1:dim(1,2)
        for i=1:dim(1,1)
            fprintf (t, num2str(encrypt (num2str(Fs(i,j)),Sec_key)));
            while 1
               if t.bytesAvailable > 0 
                   state= str2num(fscanf(t));
                   if max(size(state))~= 0 && state == 1
                       count=count+1;
                       percent = count *100/(dim(1,1)*dim (1,2));
                       fprintf ('%f percent sent \n',percent);
                       break;
                   end
               end
            end
        end
    end
fprintf (t,num2str(y));
while 1
if t.bytesAvailable > 0 
state= str2num(fscanf(t));
if max(size(state))~= 0 && state == 1
   disp('q sent')
   break;
end
end
end
 disp ('transmission complete');