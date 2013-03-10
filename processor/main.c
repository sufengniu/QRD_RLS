#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
//#include <gsl/gsl_linalg.h>

#include "givens.h"

int main(int argc, char **argv)
{
	int i, N;
	clock_t start, end;
	char *file_name;
	
	int matrix_num, matrix_size;
	double *data_in, *data_in_buff, *data_out_buff, *data_out;
		
	FILE *file;
	
	if (argc == 1){
		printf("no input data file\n");
		return 0;
	}
	
	for(i = 1; i < argc; i++){
		int j, k, iter;
		// load input file
		file_name = argv[i];

		printf("Data file: %s\n", file_name);
		printf("\tReading input data file...\n");
		file = fopen(file_name, "r");
		if(file == NULL)
		{
			printf("file non-existing \n");
			continue;
		}
		
		if(fscanf(file, "%d\n", &matrix_num) == EOF){
			printf("no data inside \n");
			continue;
		}
		
		fscanf(file, "%d %d\n", &matrix_col, &matrix_row);
                printf("matrix col is %d, matrix row is %d\n", matrix_col, matrix_row);
			
		matrix_size = matrix_row * matrix_col;
		
		data_in = (double *)malloc(matrix_size * matrix_num * sizeof(double));
		data_in_buff = (double *)malloc(matrix_size * sizeof(double));  // unit matrix size            
		data_out_buff = (double *)malloc(matrix_size * sizeof(double));
		data_out = (double *)malloc(matrix_size * matrix_num * sizeof(double));		

		N = matrix_num * matrix_size;

		printf("total element number is %d, matrix_size is %d\n", N, matrix_size);
	
		for (k = 0; k < N; k++){
			if(fscanf(file, "%lf", data_in + k) == EOF)
				break;
		}

		printf("data reading done\n");
		fclose(file);
		printf("\tComputing QR decomposition...\n");
		
		// start computing
		start = clock();
		for(iter = 0; iter < 500; iter++){  // add more iterations to improve time mesasurements
		for (k = 0; k < matrix_num; k++){
			// load matrix stream into buffer
			for (j = 0; j < matrix_size; j++){
				data_in_buff[j] = data_in[j+k*matrix_size];
			}

			// gsl library based method
			
			// Givens Rotation algorithm
			givens_rotation(data_in_buff, data_out_buff);	
			
			// output to data_out mem space
			for(j = 0; j < matrix_size; j++){
				data_out[j+k*matrix_size] = data_out_buff[j];
			}
			
		}
		}
		end = clock();

		printf("done in %lf second\n", ((double)(end-start))/CLOCKS_PER_SEC);
		
		// writing result to an output file
		printf("writing results in res_vector.dat\n", file_name);
		file = fopen("res_vector.dat", "w");
		
		fprintf(file, "%d\n", N);
		
		for(k = 0; k < N; k++){
			if ((k+1)%matrix_col == 0)
				fprintf(file, "%lf\n", *(data_out + k));
			else
				fprintf(file, "%lf\t", *(data_out + k));
		}		
		fclose(file);

		printf("freeing mem...\n");
		free(data_in);
		free(data_in_buff);
		free(data_out_buff);
		free(data_out);
		printf("done.\n");
	}
	
	return 0;
}
