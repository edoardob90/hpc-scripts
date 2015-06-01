/*
 *  pi.c
 *  
 *  Computation of pi by a "montecarlo" method:
 *  Every thread computes a number of points in the unit square
 *  and returns the number of hits in the inscribed circle
 *  pi is  #hits/#total * 4
 *        
 *  usage:
 *  	pi <total number of points> <number of threads>
*/

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <pthread.h>

long   mytotal;                     /* number of points per thread */

int main(int argc, char *argv[])
{
    int        i;
    int        nthreads;          /* number of threads */
    long       total;             /* total number of points */
    pthread_t  thread_id[200];    /* ids of all threads */
    long       totalhits = 0;     /* total number of hits */
    double     pi;                /* result */
    void *     myhits_p;
    void *     calc(void *);      /* calculation */

    if (argc != 3) {
	printf("Usage: %s <number of points> <number of threads>\n", argv[0]);
	exit(1);
    }
    total = 1000 * atol(argv[1]);
    nthreads = atoi(argv[2]);

    mytotal = (long) ceil(total/nthreads);
    total = nthreads * mytotal; /* correct total */

    /* start worker threads */
    for (i=0; i<nthreads; i++)
	pthread_create(&thread_id[i], NULL, calc, NULL);

    /*  wait for worker threads and combine partial results */
    for (i=0; i<nthreads; i++) {
	pthread_join(thread_id[i], &myhits_p);
	totalhits +=  *(long *)myhits_p;
    }
   
    /* compute final result */
    pi = totalhits/(double)total*4;
    printf("PI = %lf\n", pi);

    return 0;
}

void *calc(void *args)
{
   /* 
    * Compute total random points in the unit square
    * and return the number of hits in the sector (x*x + y*y < 1)
    *
    * Uses global 'mytotal'
    */
    double  x, y;                     /* random coordinates */
    long *  hits_p;                   /* pointer to number of hits */
    int     seed;                     /* seed for random generator */
    long    i;
   
    /* get memory for return value */
    hits_p = (long *) calloc(1, sizeof(long));        /* initialized  to 0 */

    /* initialize random generator (otherwise all return the same result!) */
    seed = (int) pthread_self();  /* !! ERROR, if pthread_t is a struct */
    for(i=0; i<mytotal; i++) {
	x = ((double) rand_r(&seed))/RAND_MAX;
	y = ((double) rand_r(&seed))/RAND_MAX;
      
	if (x*x + y*y <= 1.0)
	    (*hits_p)++;
    }

    return(hits_p); 
}
