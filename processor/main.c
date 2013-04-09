// Engineer: Sufeng Niu <sufengniu@gmail.com>
// License: GPLv3

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
//#include <gsl/gsl_linalg.h>

#include "givens.h"
#include "backsub.h"

#define	BILLION	1000000000L;

int main(int argc, char **argv)
{
	int i, N;
	
	// clock_t start, end;
	struct timespec start, stop;
	double accum;
	
	char *matrix_file_name, *de_signal_file_name;
	
	int matrix_num, matrix_size, de_signal_num;
	double *data_in, *data_in_buff, *data_out_buff, *data_out;
		
	FILE *matrix_file, *de_signal_file;
	
	if (argc == 1){
		printf("no input data file\n");
		return 0;
	}
	
	int j, k, iter;
	// load input file
	matrix_file_name = argv[1];
	de_signal_file_name = argv[2];
		
	printf("===========================");
	printf("Matrix file is: %s\n", matrix_file_name);
	printf("desired signal file is: %s\n", de_signal_file_name);
	printf("Reading input data files...\n");
		
	matrix_file = fopen(matrix_file_name, "r");
	de_signal_file = fopen(de_signal_file_name, "r");

	if(matrix_file == NULL)
	{
		printf("matrix file is empty! \n");
		continue;
	}
	
	if(de_signal_file == NULL)
	{
		printf("desired input file is empty! \n");
		continue;
	}
	
	if(fscanf(matrix_file, "%d\n", &matrix_num) == EOF){
		printf("no data inside \n");
		continue;
	}
	
	if(fscanf(de_signal_file, "%d\n", &de_signal_num == EOF){
		printf("no data inside \n");
		continue;
	}
	
	if(de_signal_num != matrix_num){
		fprintf(stderr, "matrix number and desired signal number is not matched!\n");
		exit(EXIT_FAILURE);
	}
	
	fscanf(matrix_file, "%d %d\n", &matrix_col, &matrix_row);
	printf("matrix col is %d, matrix row is %d\n", matrix_col, matrix_row);
		
	matrix_size = matrix_row * matrix_col;
	
	data_in = (double *)malloc(matrix_size * matrix_num * sizeof(double));
	data_in_buff = (double *)malloc(matrix_size * sizeof(double));  // unit matrix size            
	data_out_buff = (double *)malloc(matrix_size * sizeof(double));
	data_out = (double *)malloc(matrix_size * matrix_num * sizeof(double));		
	weight_buff = (double *)malloc(matrix_row * sizeof(double));
	weight = (double *)malloc(matrix_row * matrix_num * sizeof(double));
	N = matrix_num * matrix_size;
	printf("total element number is %d, matrix_size is %d\n", N, matrix_size);
	
	// loading input matrix file
	for (k = 0; k < N; k++){
		if(fscanf(matrix_file, "%lf", data_in + k) == EOF)
			break;
	}
	
	// loading desired signal vector file
	for (k = 0; k < de_signal_num * matrix_row; k++){
		if(fscanf(de_signal_file, "%lf", weight + k) == EOF)
			break;
	}
	
	printf("data reading done\n");
	fclose(matrix_file);
	fclose(de_signal_file);
	printf("\tComputing QR decomposition...\n");
		
	// start computing
	//start = clock();
	clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &start);
				
	// for(iter = 0; iter < 500; iter++){  // add more iterations to improve time mesasurements
	for (k = 0; k < matrix_num; k++){
		// load matrix stream into buffer
		for (j = 0; j < matrix_size; j++){
			data_in_buff[j] = data_in[j+k*matrix_size];
		}		
		//loading desired signal into buffer
		for (j = 0; j < matrix_row; j++){
			weight_buff[j] = weight[j+k*matrix_row];
		}

		// gsl library based method
			
		// Givens Rotation algorithm
		givens_rotation(data_in_buff, data_out_buff);	
		
		// back substitution operation
		back_substitution(data_out_buff, weight_buff, matrix_row);

		// output to data_out mem space
		for(j = 0; j < matrix_size; j++){
			data_out[j+k*matrix_size] = data_out_buff[j];
		}
		// export weights
		for(j = 0; j < matrix_row; j++){
			weight[j+k*matrix_row] = weight_buff[j];
		}
	}
	//}

	// end = clock();
	clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &stop);
			
	// printf("done in %lf second\n", ((double)(end-start))/CLOCKS_PER_SEC);
	accum = (stop.tv_sec - start.tv_sec)+(double)(stop.tv_nsec-start.tv_nsec)/(double)BILLION;
	printf("done in %lf second\n", accum);
			
	// writing result to an output file
	printf("writing results in res_vector.dat\n", file_name);
	matrix_file = fopen("res_vector.dat", "w");
	
	fprintf(matrix_file, "%d\n", N);
	fprintf(matrix_file, "%d\n", matrix_col);
	fprintf(matrix_file, "%d\n", matrix_row);
	
	for(k = 0; k < N; k++){
		fprintf(matrix_file, "%lf\n", *(data_out + k));
	}
			
	fclose(matrix_file);

	printf("freeing mem...\n");
	free(data_in);
	free(data_in_buff);
	free(data_out_buff);
	free(data_out);
	free(weight);
	free(weight_buff);
	printf("done.\n");
	
	return 0;
}
