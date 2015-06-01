// one shoule include mpi.h before stdio.h with recent versions of Intel compilers
#include <mpi.h>

#include <cstdlib> // for "getenv"
#include <iostream>

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


  std::cout <<
    "Hello, my rank is " <<
    my_rank <<
    " among " <<
    tasks_number <<
    " tasks on machine " <<
    machine_name <<
    std::endl;
  std::cout.flush ();


  // Let's wait until all the tasks have reached this point
  // ------------------------------------------------------

  // MPI_Barrier (MPI_COMM_WORLD);

  if ( my_rank == 0 ) {
    std::cout <<
      "--- BARRIER! ---" <<
      std::endl;
    std::cout.flush ();
    }


  // ...and we should terminate by...
  // --------------------------------

  MPI_Finalize ();
  
  return 0;
  }
