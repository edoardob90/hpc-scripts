#include <stdio.h>
#include <mpi.h>

// Rotate values clockwise on a ring with MPI
// ------------------------------------------

int main (int argc, char * argv [])
  {
    
  // Each task owns its private set of the following variables
  // ---------------------------------------------------------     

  int        my_rank, tasks_number;
  char       machine_name [512];
  int        name_length;
  int        my_var, left_neighbour, right_neighbour;
  MPI_Status status;

  
  // We should start with...
  // -----------------------

  MPI_Init (& argc, & argv);


  // Getting information about the MPI environnement
  // -----------------------------------------------

  MPI_Comm_size (MPI_COMM_WORLD, & tasks_number);
  MPI_Comm_rank (MPI_COMM_WORLD, & my_rank);
  MPI_Get_processor_name (machine_name, & name_length);


  // Initialization
  // --------------
  
  my_var = my_rank * 10;

  right_neighbour = (my_rank + 1) % tasks_number;
  left_neighbour =
    (my_rank-1 >= 0)
      ? my_rank-1
      : tasks_number-1; /* rank of the sender */


  // Show initial status
  // -------------------
  
  printf (
    "Hello, my rank is %d among %d tasks on machine %s, with my_var = %d initially\n",
    my_rank, tasks_number, machine_name, my_var
    );
  fflush (stdout);


  // Let's wait until all the tasks have reached this point
  // ------------------------------------------------------

  MPI_Barrier (MPI_COMM_WORLD);

  if (my_rank == 0){
    printf ("--- BARRIER! ---\n");
    fflush (stdout);
    }
    
  
  // Exchange values with the neighbours
  // -----------------------------------

  printf (
    "%s: rank %d sends to %d and receives from %d, my_var = %d\n",
    machine_name, my_rank, right_neighbour, left_neighbour, my_var );

  MPI_Sendrecv_replace (
    & my_var, 1, MPI_INT,
    right_neighbour, 0, left_neighbour, 0,
    MPI_COMM_WORLD, & status );


  // Let's wait until all the tasks have reached this point
  // ------------------------------------------------------

  MPI_Barrier (MPI_COMM_WORLD);

  if (my_rank == 0){
    printf ("--- BARRIER! ---\n");
    fflush (stdout);
    }
    

  // Show final status
  // -------------------
  
  printf (
    "Hello, my rank is %d among %d tasks on machine %s, with my_var = %d finally\n",
    my_rank, tasks_number, machine_name, my_var
    );
  fflush (stdout);


  // ...and we should terminate by...
  // --------------------------------

  MPI_Finalize ();
  
  return 0;
  }
