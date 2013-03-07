clear
clc

IntegerBit=1;
FractionBit=14;
TestVectorNum=50;
MatrixRow=4;
MatrixCol=4;

for i=1:TestVectorNum
    A(:,:,i)=rand(MatrixRow, MatrixCol);
    
    [Q(:,:,i),R(:,:,i)]=qr(A(:,:,i));
    
end 

f=fullfile('test_vector.dat');

if(exist(f, 'file')~=0)
    delete('test_vector.dat')
end

fid=fopen('test_vector.dat','a+');
fprintf(fid, '%d\n', TestVectorNum);
fprintf(fid, '%d\t%d\t\n', MatrixCol, MatrixRow);

for i=1:TestVectorNum
    fprintf(fid, '%f\t%f\t%f\t%f\n', A(:,:,i));
end

fclose(fid);