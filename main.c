#include <stdio.h>
#include <string.h>
#include <math.h>
#include <time.h>
//#include <gsl/gsl_linalg.h>

int main(int argc, char **argv)
{
	int i, N;
	clock_t start, end;
	char *file_name;
	
	int matrix_num, matrix_col, matrix_row, matrix_size;
	double *data_in, *data_buff, *data_out;
		
	FILE *file;
	
	if (argc == 1){
		printf("no input data file\n");
		return 0;
	}
	
	for(i = 1; i < argc; i++){
		int j, k;
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
		data_buff = (double *)malloc(matrix_size * sizeof(double));  // unit matrix size            
		data_out = (double *)malloc(matrix_size * matrix_num * sizeof(double));		

		N = matrix_num * matrix_size;
		
		for (k = 0; k < N; k++){
			if(fscanf(file, "%lf", data_in + k) == EOF)
				break;
		}

		printf("data reading done\n");
		fclose(file);
		printf("\tComputing QR decomposition...\n");
		
		// start computing
		start = clock();
		for (k = 0; k < matrix_num; k++){
			/*for (j = 0; j < matrix_size; j++){
				data_buff[j] = data_in[j+k*matrix_size];
			}
			
			// gsl library based method
			
			// Givens Rotation algorithm
			givens_rotation(data_buff);
			*/
		
			data_out = data_in;
		}
		end = clock();
		printf("done in %lf second\n", (double)((end-start)/CLOCKS_PER_SEC));
		
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
		free(data_buff);
		//free(data_out);
		printf("done.\n");
	}
	
	return 0;
}
