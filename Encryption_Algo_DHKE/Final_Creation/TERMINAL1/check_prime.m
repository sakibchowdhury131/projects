function [ res ] = check_prime(n )
%CHECK_PRIME Summary of this function goes here
%   Detailed explanation goes here
res=true;
for i=2:n-1
    if mod (n,i)==0
        res=false;
    end

end

