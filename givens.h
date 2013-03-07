#ifndef GIVENS_H
#define GIVENS_H

#include <math.h>

struct boundcell {
	double c, s;
}

void givens_rotation(double *data_in, double *data_out int matrix_col, int matrix_row);
void rotate(double a1, double a2, boundcell rotator);
void matrix_trans(boundcell rotator, double *data_in, double *data_out, int interval);

#endif /* givens.h */

