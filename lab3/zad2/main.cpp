#include <iostream>
#include <stdio.h>
#include <gsl/gsl_sf_bessel.h>
#include <gsl/gsl_ieee_utils.h>
#include <gsl/gsl_vector.h>
#include <gsl/gsl_matrix.h>
#include <gsl/gsl_blas.h>
#include <math.h>
#include <time.h>

gsl_matrix *generate_matrix(size_t size) {
    gsl_matrix *matrix = gsl_matrix_alloc(size, size);
    for (size_t i = 0; i < size; i++) {
        for (size_t j = 0; j < size; ++j) {
            double r = (double) rand();
            gsl_matrix_set(matrix, i, j, r);
        }
    }
    return matrix;
}

double blas_matrix_multiplication_time(gsl_matrix *A, gsl_matrix *B, gsl_matrix *result) {
    clock_t matrix_multiplication_start = clock();
    gsl_blas_dgemm(CblasNoTrans, CblasNoTrans, 1, A, B, 1, result);
    clock_t matrix_multiplication_end = clock();
    double cpu_time_used_M = ((double) (matrix_multiplication_end - matrix_multiplication_start)) / CLOCKS_PER_SEC;
    gsl_matrix_set_zero(result);
    return cpu_time_used_M;

}

double better_matrix_multiplication_time(gsl_matrix *A, gsl_matrix *B, gsl_matrix *result) {
    clock_t matrix_multiplication_start = clock();
    for (int row = 0; row < A->size1; row++) {
        for (int col = 0; col < B->size1; col++) {
            for (int k = 0; k < A->size2; k++) {
                gsl_matrix_set(result, row, col, gsl_matrix_get(A, row, k) + gsl_matrix_get(A, k, col));
            }
        }
    }
    clock_t matrix_multiplication_end = clock();
    double cpu_time_used_M = ((double) (matrix_multiplication_end - matrix_multiplication_start)) / CLOCKS_PER_SEC;
    gsl_matrix_set_zero(result);
    return cpu_time_used_M;
}

double naive_matrix_multiplication_time(gsl_matrix *A, gsl_matrix *B, gsl_matrix *result) {
    clock_t matrix_multiplication_start = clock();
    for (int col = 0; col < B->size1; col++) {
        for (int row = 0; row < A->size1; row++) {
            for (int k = 0; k < A->size2; k++) {
                gsl_matrix_set(result, row, col, gsl_matrix_get(A, row, k) + gsl_matrix_get(A, k, col));
            }
        }
    }
    clock_t matrix_multiplication_end = clock();
    double cpu_time_used_M = ((double) (matrix_multiplication_end - matrix_multiplication_start)) / CLOCKS_PER_SEC;
    gsl_matrix_set_zero(result);
    return cpu_time_used_M;
}


int main() {
    int size;
    FILE * fp;
    fp = fopen("result.csv", "w");
    fprintf(fp, "try, size, time_Naive, time_Better, time_Blas\n");
    double naive_time;
    double better_time;
    double blas_time;
    for(int i =1; i<=10; i++){
        size = i*10;
        for(int j = 1; j<=10; j++){
            gsl_matrix *result = gsl_matrix_alloc(size, size);
            gsl_matrix_set_zero(result);
            gsl_matrix *A = generate_matrix(size);
            gsl_matrix *B = generate_matrix(size);
            naive_time = naive_matrix_multiplication_time(A, B, result);
            better_time = better_matrix_multiplication_time(A, B, result);
            blas_time = blas_matrix_multiplication_time(A, B, result);
            fprintf(fp, "%i, %i, %lf, %lf,  %lf\n", j, size, naive_time, better_time, blas_time);
        }
    }
    return 0;
}