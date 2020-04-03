function [text]= decrypt (encrpt_data , letter,key)


%letter=input('Number of letter:');
cipher=ones(letter,1);

    cipher=encrpt_data;

cipher = dec2bin(cipher,32);
b=ones(letter,32);
b=char(b);
for i=1:letter
    for j=1:29
        b(i,j+3)=cipher(i,j);
    end
    for j=30:32
        b(i,j-29)=cipher(i,j);
    end
end
%disp(b);
Leftmatrix=ones(letter,16);
Leftmatrix=char(Leftmatrix);
Rightmatrix=ones(letter,16);
Rightmatrix=char(Rightmatrix);
for i=1:letter
    for j=1:16
        Leftmatrix(i,j)=b(i,j+16);
    end
end
for i=1:letter
    for j=1:16
        Rightmatrix(i,j)=b(i,j);
    end
end
%disp(Leftmatrix)
%disp(Rightmatrix)
Rightmatrix=int16(Rightmatrix);
key=dec2bin(key,16);
key=int16(key);
xoroperation=ones(letter,16);
for j=1:letter
    for i=1:16
xoroperation(j,i)=bitxor(key(1,i),Rightmatrix(j,i));
    end
end
Leftmatrix2=Leftmatrix;
xorcolumn=size(xoroperation,2);
xorrow=size(xoroperation,1);
s=ones(xorrow,xorcolumn);
s=char(s);
d=char(zeros(xorrow,xorcolumn));
Rightmatrix2=ones(xorrow,xorcolumn);
Rightmatrix2=char(Rightmatrix2);
for j=1:xorrow
for i=1:xorcolumn
s(i,j)=dec2bin(xoroperation(j,i));
s(j,i)=s(i,j);
end

for i=1:xorcolumn
    Rightmatrix2(j,i)=s(j,i);
end
s=d;
end
%disp(Rightmatrix2);
tempmatrix=ones(letter,32);
tempmatrix=char(tempmatrix);

k=letter;
for i=1:k
    for j=1:16
        tempmatrix(i,j)=Leftmatrix2(i,j);
    end
    for j=1:16
        tempmatrix(i,j+16)=Rightmatrix2(i,j);
    end
end
finalmatrix=ones(k,32);
finalmatrix=char(finalmatrix);

for i=1:k
    for j=1:29
        finalmatrix(i,j+3)=tempmatrix(i,j);
    end
end
for i=1:letter
    for j=30:32
        finalmatrix(i,j-29)=tempmatrix(i,j);
    end
end
    %disp(finalmatrix)
    text=ones(letter,32);
    text=bin2dec(finalmatrix);
    text=char(text);
    text=text';