#include <stdio.h>
#include <mpi.h>

// A minimal MPI program
// ---------------------

int main (int argc, char * argv [])
  {
    
  // Each task owns its private set of the following variables
  // ---------------------------------------------------------     

  int    my_rank, tasks_number;
  char   machine_name [512];
  int    name_length;


  // We should start with...
  // -----------------------

  MPI_Init (& argc, & argv);


  // Getting information about the MPI environnement
  // -----------------------------------------------

  MPI_Comm_size (MPI_COMM_WORLD, & tasks_number);
  MPI_Comm_rank (MPI_COMM_WORLD, & my_rank);
  MPI_Get_processor_name (machine_name, & name_length);


  printf (
    "Hello, my rank is %d among %d tasks on machine %s\n",
    my_rank, tasks_number, machine_name
    );
  fflush (stdout);


  // Let's wait until all the tasks have reached this point
  // ------------------------------------------------------

  MPI_Barrier (MPI_COMM_WORLD);

  if ( my_rank == 0 ) {
    printf ("--- BARRIER! ---\n");
    fflush (stdout);
    }
    

  // ...and we should terminate by...
  // --------------------------------

  MPI_Finalize ();
  
  return 0;
  }
