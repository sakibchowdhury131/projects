flag=true;
x=11;
a=3;

  for i =  1:x-1
      data (i)= mod((a^i),x);
  end
  data = sort (data);
  for i=1:x-1
      if data (i)~=i
          flag=false ; 
          
      end
  end
