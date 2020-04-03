function[Roots]= PR(k)
%This function finds all Primitive Roots of a number.
%We begin by taking a user input (integer greater than 1) and then
%finding all of its primitive roots
if k > 1 && rem(k,1)==0
FEE = phi(k);
%We calculate the Phi(input) = Euler's Totient
for ii = 1:FEE
    if rem(FEE,ii)==0
    DivisorsFEE(ii) = ii;
    else
    DivisorsFEE(ii) = 0;
    end
%Store the divisors of phi(k) into a vector
end
DivisorsFEE = DivisorsFEE(DivisorsFEE~=0);
%Remove all zeroes from the vector so it shows the divsors of use
for m = 1:k-1
    PossiblePrim(1) = m;
%Main Part: going to test every number from 1 to our input-1 to see if it is a primitive root
%For numbers greater than 1, testing if a number is a primitive root of
%itself is pointless because it wont work (email me for a proof).
 for ll = 1:DivisorsFEE(end-1)-1
    PossiblePrim(ll+1) = mod(PossiblePrim(ll)*m,k);
    %Doing modulated multiplication up to the second to last divisor
    if PossiblePrim(ll+1) == 1
        %Checking if any raised exponent gave us 1 after modulation
       CurrentDivisor(ll) = 1;
    else
       CurrentDivisor(ll) = 0;
    end
 end
End_result = PossiblePrim(end);
CurrentDivisor=[CurrentDivisor,mod(End_result^2,k)];
%As line (23) suggests, we didn't actually loop the last divisor, but we know
%What the answer will be ahead of time, thus we appendage it here on line
%(34)
TestPrim = sum(CurrentDivisor);
CurrentDivisor=[];
%Truth is, if our m is a primitive root, the only time it is congruent to 1
%(mod k) was when it was raised to the very last divisor ==> only one 1
%should be inside our CurrentDivisor vector
if TestPrim-1 == 0
%Like we just said, if it contains just one 1, then the sum of the
%vector (1) - 1 should be 0 verfiying m is a primitive root
Proot(m) = m;
%Recording the m-value if it passed line's (43) test, else we throw it out
%on line (64)
else
Proot(m) = 0;
end
end
%Proot will only contain primitive roots or 0's
Roots = Proot(Proot~=0);
%We want to display our Primitive Roots vector (has our answers), but don't
%want the 0's of course.
NumOfRoots = numel(Roots);
%disp(Roots);
if NumOfRoots ~= 0
    %Checking to see if our user input actually got any primitive roots
%disp([num2str(k) ' has ' num2str(NumOfRoots) ' Primitive Roots']);
else
disp('No Primitive Roots');
end
else
disp('Please make sure your input is an integer greater than 1');
end
end