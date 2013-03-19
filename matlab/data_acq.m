clear
clc

load res_vector.dat;

ElementNum = res_vector(1);
MatrixCol = res_vector(2);
MatrixRow = res_vector(3);
MatrixSize = MatrixCol*MatrixRow;
TestVectorNum = ElementNum / MatrixSize;

% export the C results
for i=1:TestVectorNum
    for k=1:MatrixRow
        for j=1:MatrixCol
            res(k,j,i) = res_vector(3+(i-1)*MatrixCol*MatrixRow+(k-1)*MatrixRow+j);
        end
    end
end

% import input data
load test_vector.dat;

for i=1:TestVectorNum
    for k=1:MatrixRow
        for j=1:MatrixCol
            A(k,j,i) = test_vector(3+(i-1)*MatrixCol*MatrixRow+(k-1)*MatrixRow+j);
        end
    end
end

% get the result from Matlab function
for i=1:TestVectorNum
	[Q(:,:,i), R(:,:,i)]=qr(A(:,:,i));
end



