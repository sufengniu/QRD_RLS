load res_vector.dat;

ElementNum = res_vector(1);
MatrixCol = res_vector(2);
MatrixRow = res_vector(3);
TestVectorNum = ElementNum / (MatrixCol*MatrixRow);

for i=1:TestVectorNum
    for k=1:MatrixRow
        for j=1:MatrixCol
            res(k,j,i) = res_vector(3+(i-1)*MatrixCol*MatrixRow+(k-1)*MatrixRow+j);
        end
    end
end

load test_vector.dat;

for i=1:TestVectorNum
    for k=1:MatrixRow
        for j=1:MatrixCol
            test_data(k,j,i) = test_vector(3+(i-1)*MatrixCol*MatrixRow+(k-1)*MatrixRow+j);
        end
    end
end

