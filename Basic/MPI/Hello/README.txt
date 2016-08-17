To compile the hello_*.* source files:

  source /ssoft/spack/bin/slmodules.sh

Then, either:

  module load intel intelmpi

  mpiicc -o hello_c hello.c
  mpiicpc -o hello_cxx hello.cxx
  mpiifort -o hello_f90 hello.f90

or:

  module load gcc mvapich2

  mpicc -o hello_c hello.c
  mpicxx -o hello_cxx hello.cxx
  mpifort -o hello_f90 hello.f90

or:

  module load gcc openmpi

  mpicc -o hello_c hello.c
  mpicxx -o hello_cxx hello.cxx
  mpifort -o hello_f90 hello.f90

according to the desired compiler and MPI variant

--

To run them on the front-end:
  ./hello_c
and so on with hello_cxx and hello_f90

--

To run them in an interactive SLURM session:

> salloc -n 4
salloc: Granted job allocation 43196

> source /ssoft/spack/bin/slmodules.sh

> module load intel intelmpi

# or
# module load gcc mvapich2
# module load gcc openmpi

> srun ./hello_c
Hello, my rank is 2 among 4 tasks on machine c07
Hello, my rank is 0 among 4 tasks on machine c07
Hello, my rank is 3 among 4 tasks on machine c07
Hello, my rank is 1 among 4 tasks on machine c07
--- BARRIER! ---

> exit
exit
salloc: Relinquishing job allocation 43196
salloc: Job allocation 43196 has been revoked.
> 

--

To run them in batch mode:

> sbatch hello.run
Submitted batch job 43198

The result should be something similar to

> cat slurm-43198.out 

Currently Loaded Modules:
  1) intel/16.0.3   2) intelmpi/5.1.3


*** C ***
Hello, my rank is     2 among     4 tasks on machine c07
Hello, my rank is     3 among     4 tasks on machine c07
Hello, my rank is     0 among     4 tasks on machine c07
Hello, my rank is     1 among     4 tasks on machine c07

etc.
