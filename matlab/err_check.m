clear
clc

data_acq;

error_matrix=abs(R)-abs(res);

for i=1:TestVectorNum
    for j=MatrixRow
        for k=MatrixCol
            error_vector(k+(j-1)*MatrixRow+(i-1)*MatrixSize)=error_matrix(j,k,i);
        end
    end
end

plot(error_vector)
