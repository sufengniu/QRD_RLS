#ifndef GIVENS_H_
#define GIVENS_H_

#include <math.h>

int matrix_col, matrix_row;

struct boundcell {
	double c, s;
};

void givens_rotation(double *data_in, double *data_out);
struct boundcell rotate(double a1, double a2);
void matrix_trans(struct boundcell rotator, double *data_in, double *data_out, int interval);

#endif /* givens.h */

