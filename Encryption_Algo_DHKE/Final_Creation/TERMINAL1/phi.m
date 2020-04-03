function W = phi(k)
%This function takes an integer input and calculates the Phi of that number
%(Euler's Phi function)
k = abs(k);
if k > 1 && rem(k,1)==0
for i = 1:k
    if gcd(i,k) == 1
        y(i) = 1;
    else
        y(i) = 0;
    end
end
W = sum(y);
else
    disp('Make sure k is an integer and greater than 1');
end
end