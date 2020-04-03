function [ flag ] = PRI_ROOT( x,a )
%PRI_ROOT Summary of this function goes here
%   Detailed explanation goes here
flag=true;
  for i =  1:x-1
      data (i)= mod((a^i),x);
  end
  data = sort (data);
  for i=1:x-1
      if data (i)~=i
          flag=false ; 
          
      end
  end

end

