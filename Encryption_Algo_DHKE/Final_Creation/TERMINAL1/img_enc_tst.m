
im=imread ('test2.jpg');
dim = size (im);
count= 1 ;
fprintf (t,num2str(dim(1,1)) );
while 1
    if t.bytesAvailable > 0 
        state= str2num(fscanf(t));
        if max(size(state))~= 0 && state == 1
        %disp('dim(1,1) sent ')
        break;
        end
    end
end
fprintf (t,num2str(dim(1,2)) );
while 1
    if t.bytesAvailable > 0 
        state= str2num(fscanf(t));
        if max(size(state))~= 0 && state == 1
        %disp('dim(1,2) sent ')
        break;
        end
    end
end
fprintf (t,num2str(dim(1,3)) );
while 1
    if t.bytesAvailable > 0 
        state= str2num(fscanf(t));
        if max(size(state))~= 0 && state == 1
        %disp('dim(1,3) sent ')
        break;
        end
    end
end
%%
for k =1:dim(1,3)
    for j=1:dim(1,2)
        for i=1:dim(1,1)
            fprintf (t, num2str(encrypt (num2str(im(i,j,k)),Sec_key)));
            while 1
               if t.bytesAvailable > 0 
                   state= str2num(fscanf(t));
                   if max(size(state))~= 0 && state == 1
                       count=count+1;
                       percent = count *100/(dim(1,1)*dim (1,2)*dim(1,3));
                       fprintf ('%f percent sent \n',percent);
                       break;
                   end
               end
            end
        end
    end
end
 disp ('transmission complete');