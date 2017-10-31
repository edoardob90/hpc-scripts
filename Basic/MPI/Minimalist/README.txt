To compile the hello_mpi.c source file:

  source /ssoft/spack/bin/slmodules.sh

  module load intel intel-mpi

  mpiicc hello_mpi.c -o hello_mpi


To run the executable file in batch mode:

  sbatch hello.run
