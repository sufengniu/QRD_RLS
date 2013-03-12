clear
clc

IntegerBit=1;
FractionBit=14;
TestVectorNum=10000;
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
fprintf(fid, '%d\n', MatrixCol);
fprintf(fid, '%d\n', MatrixRow);

for i=1:TestVectorNum
	for j = 1:MatrixRow
		for k = 1:MatrixCol
    			fprintf(fid, '%f\n', A(j,k,i));
		end
	end
end

fclose(fid);
