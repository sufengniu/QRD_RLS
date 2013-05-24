clear
clc

load test_vector.dat;

ElementNum = test_vector(1);
MatrixCol = test_vector(2);
MatrixRow = test_vector(3);
MatrixSize = MatrixCol*MatrixRow;
TestVectorNum = ElementNum / MatrixSize;

for i=1:TestVectorNum
    for k=1:MatrixRow
        for j=1:MatrixCol
            A(k,j,i) = test_vector(3+(i-1)*MatrixCol*MatrixRow+(k-1)*MatrixRow+j);
        end
    end
end

tic

for i=1:TestVectorNum
	[Q(:,:,i), R(:,:,i)]=qr(A(:,:,i));
end

toc