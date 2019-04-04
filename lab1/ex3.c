#include <stdio.h>
#include <gsl/gsl_sf_bessel.h>
#include <gsl/gsl_ieee_utils.h>
#include <math.h>


int main (void)
{   

    float x = 5;
    float y = 3;
    float z = 2;
    float tmp;
    int exp = 0;
    for(int i =0; i<100; i++){
        tmp = x/(pow(10,i));
        printf("i = %d", i);

        gsl_ieee_printf_float(&tmp);
        printf("\n");
    }




  //  double x = 15.0;
  //  double y = gsl_sf_bessel_J0 (x);
   // printf ("J0(%g) = %.18e/n", x, y);
    return 0;
}
