function [cipher]= encrypt(sa,key)

e=dec2bin(sa,32);
oba=size(e);
key=dec2bin(key,16);
key=int16(key);
k=oba(1,1);
tempmatrix=zeros(k,32);
tempmatrix=char(tempmatrix);
Leftmatrix=zeros(k,16);
Rightmatrix=zeros(k,16);
Leftmatrix=char(Leftmatrix);
Rightmatrix=char(Rightmatrix);
for j=1:k
    for i=4:32
        b(j,(i-3))=e(j,i);
    end
    for i=1:3
        b(j,(i+29))=e(j,i);
    end
end

for j=1:k
    for i=1:16
        Leftmatrix(j,i)=b(j,i);
    end
    for i=17:32
        Rightmatrix(j,i-16)=b(j,i);
    end
end
%disp(Rightmatrix)
Rightmatrix=int16(Rightmatrix);
%disp(Leftmatrix)
xoroperation=ones(k,16);
for j=1:k
    for i=1:16
xoroperation(j,i)=bitxor(key(1,i),Rightmatrix(j,i));
    end
end
%disp(xoroperation)
Rightmatrix2=Leftmatrix;
xorcolumn=size(xoroperation,2);
xorrow=size(xoroperation,1);
s=ones(xorrow,xorcolumn);
s=char(s);
d=char(zeros(xorrow,xorcolumn));
Leftmatrix2=ones(xorrow,xorcolumn);
Leftmatrix2=char(Leftmatrix2);
for j=1:xorrow
for i=1:xorcolumn
s(i,j)=dec2bin(xoroperation(j,i));
s(j,i)=s(i,j);
end
for i=1:xorcolumn
    Leftmatrix2(j,i)=s(j,i);
end
s=d;
end

%disp(Leftmatrix2)
for j=1:k
    for i=1:16
        tempmatrix(j,i)=Leftmatrix2(j,i);
    end
end
for j=1:k
    for i=17:32
        tempmatrix(j,i)=Rightmatrix2(j,i-16);
    end
end
%tempmatrix
b2=ones(k,32);
b2=char(b2);
for j=1:k
    for i=4:32
        b2(j,(i-3))=tempmatrix(j,i);
    end
    for i=1:3
        b2(j,(i+29))=tempmatrix(j,i);
    end
end
%disp(b2)
cipher=bin2dec(b2);
%disp(cipher)
%cipher= str2num (cipher)
%cipher=dec2bin(cipher,32)
