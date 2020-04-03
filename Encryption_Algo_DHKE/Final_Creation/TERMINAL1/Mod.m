function d =Mod(m,p,n)
% m^p mod n
b = de2bi(p);
l = length(b);
d = 1;
for i=l:-1:1
    if b(i) == 0
        d = d^2;
        d = mod(d,n);
    end
    
    if b(i) == 1
        d = d^2;
        d = mod(d,n);
        d = d*m;
        d = mod(d,n);
    end
end
end