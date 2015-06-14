// one shoule include mpi.h before stdio.h with recent versions of Intel compilers
#include <mpi.h>

#include <cstdlib> // for "getenv"
#include <iostream>

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

  MPI::Init (argc, argv);

  
  // Getting information about the MPI environnement
  // -----------------------------------------------

  tasks_number = MPI::COMM_WORLD.Get_size ();
  my_rank = MPI::COMM_WORLD.Get_rank ();
  MPI::Get_processor_name (machine_name, name_length);


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
  
  std::cout <<
    "Hello, my rank is " <<
    my_rank <<
    " among " <<
    tasks_number <<
    " tasks on machine " <<
    machine_name <<
    ", with my_var = " <<
    my_var <<
    " initially" <<
    std::endl;
  std::cout.flush ();


  // Let's wait until all the tasks have reached this point
  // ------------------------------------------------------

  MPI::COMM_WORLD.Barrier ();

  if ( my_rank == 0 ) {
    std::cout <<
      "--- BARRIER! ---" <<
      std::endl;
    std::cout.flush ();
    }


  // Exchange values with the neighbours
  // -----------------------------------

  printf (
    "%s: rank %d sends to %d and receives from %d, my_var = %d\n",
    machine_name, my_rank, right_neighbour, left_neighbour, my_var );

  MPI::COMM_WORLD.Sendrecv_replace (
    & my_var, 1, MPI_INT,
    right_neighbour, 0, left_neighbour, 0);


  // Let's wait until all the tasks have reached this point
  // ------------------------------------------------------

  MPI::COMM_WORLD.Barrier ();

  if ( my_rank == 0 ) {
    std::cout <<
      "--- BARRIER! ---" <<
      std::endl;
    std::cout.flush ();
    }


  // Show final status
  // -------------------
  
  std::cout <<
    "Hello, my rank is " <<
    my_rank <<
    " among " <<
    tasks_number <<
    " tasks on machine " <<
    machine_name <<
    ", with my_var = " <<
    my_var <<
    " finally" <<
    std::endl;
  std::cout.flush ();


  // ...and we sshould terminate by...
  // --------------------------------

  MPI::Finalize ();
  
  return 0;
  }
