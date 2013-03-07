#include "givens.h"

// Givens Rotation algorithm
void givens_rotation(double *data_in, double *data_out, int matrix_col, int matrix_row){
	int i, j, interval;
	double a1, a2;
	boundcell rotator;
	double *data_in_start, *data_out_start;
	
	// i: column index, j: row index
	for(i = 0; i < matrix_col; i++){
		for(j = matrix_row; j > i+1; j--){
			
			a1 = data_in[i + (j-2)*matrix_col];
			a2 = data_in[i + (j-1)*matrix_col];
			// set breakpoint for debugging purpose, check a1, a2 value

			rotate(a1, a2, rotator); // rotate operation
			// set breakpoint, check rotator.c rotator.s value
			
			data_in_start = data_in + i + (j-2)*matrix_col;
			data_out_start = data_out + i +(j-2)*matrix_col;
			
			interval = matrix_col - i;
			matrix_trans(rotator, data_in_start, data_out_start, interval);
			// set breakpoint, verify data_in and data_out

			// copy to data_out space
			
		}
	}
}

//semih's matlab version
void rotate(double a1, double a2, boundcell rotator){
	double cotangent, tangent;
	if (a2 == 0){
		rotator.c = 1.0;
		rotator.s = 0.0;
	}
	else
	{
		if (fabs(a2) >= fabs(a1)){
			cotangent = a1/a2;
			rotator.s = 1/sqrt(1+pow(cotangent, 2.0));
			rotator.c = rotator.s * cotangent;
		}
		else
		{
			tangent = a2/a1;
			rotator.c = 1/sqrt(1+pow(tangent, 2.0));
			rotator.s = rotator.c * tangent;
		}
	}
}

void matrix_trans(boundcell rotator, double *data_in, double *data_out, int interval)
	int j;
	for(j = 0; j < interval; j++){
		data_out[j] = rotator.c * data_in[j] + rotator.s * data_in[j+matrix_col];
		data_out[j+matrix_col] = rotator.c * data_in[j+matrix_col] - rotator.s * data_in[j];
	}	
	
}


