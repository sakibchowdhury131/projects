while 1
if t1.bytesAvailable > 0 
temp= str2num(fscanf(t1));
if max(size(temp))~= 0 
   dim_img(1,1)=temp;
   fprintf (t1,'1');
   disp('dim(1,1) received')
   break;
end
end
end
while 1
if t1.bytesAvailable > 0 
temp= str2num(fscanf(t1));
if max(size(temp))~= 0 
   dim_img(1,2)=temp;
   fprintf (t1,'1');
   disp('dim(1,2) received')
   break;
end
end
end
while 1
if t1.bytesAvailable > 0 
temp= str2num(fscanf(t1));
if max(size(temp))~= 0 
   dim_img(1,3)=temp;
   fprintf (t1,'1');
   disp('dim(1,3) received')
   break;
end
end
end

%% 
count=0;
for w =1:dim_img(1,3)
    for y=1:dim_img(1,2)
        for z=1:dim_img(1,1)
         while 1
           if t1.bytesAvailable > 0 
              raw_data= fscanf(t1);
              if max(size(raw_data))>5 
                enc_msg=raw_data;
                %fprintf (t1,'1');
                %disp('message received')
                break;
              end
           end
         end


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
    Pro_data=zeros (row ,1);
       for i = 1:row
           for j= 1:9
             Pro_data(i ,1)= Pro_data (i ,1)+ data (i,j)*10^(9-j);
           end
       end
       %disp ('done')
     im(z,y,w)=uint8(str2num(decrypt (Pro_data,row,Sec_key)));
     count=count+1;
     percent = count *100/(dim_img(1,1)*dim_img (1,2)*dim_img(1,3));
     fprintf ('%f percent received \n',percent);
     fprintf (t1,'1');
     %disp(im(z,y,w))
        end
    end
end
disp('receive complete')
imshow (im)
imwrite (im,'test2copy.jpg');