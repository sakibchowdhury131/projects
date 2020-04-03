function [ q,p ] = generate_public_key( )
%GENERATE_PUBLIC_KEY Summary of this function goes here
%   Detailed explanation goes here
q=4;
j=1;
while check_prime (q)==false
    q= randi([2,100],1,1);
end

p=PR(q);
idx=randperm(length(p),1);
p=p(idx);
disp (' q and p generated');

end

