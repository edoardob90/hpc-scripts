To compile the ex4.* source files:

  module load intelmpi/4.1.3

  mpiicc -o ex4_c ex4.c
  mpiicpc -o ex4_cxx ex4.cxx
  mpiifort -o ex4_f90 ex4.f90

--

To run them on the front-end:
  ./ex4_c
and so on with ex4_cxx and ex4_f90

--

To run them in an interactive SLURM session:

> salloc -n 4
salloc: Granted job allocation 43196

> module load intelmpi/4.1.3

> srun ./ex4_c
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

> sbatch ex4.run
Submitted batch job 43198

The result should be

> cat slurm-43198.out 

STARTING AT Wed Jun 18 15:27:28 CEST 2014

Currently Loaded Modulefiles:
  1) intel/14.0.1     2) intelmpi/4.1.3

--> LAUNCH_DIR = /home/jmenu/COURS
--> EXECUTABLE = ./ex4_f90

Hello, my rank is     2 among     4 tasks on machine c07
Hello, my rank is     3 among     4 tasks on machine c07
Hello, my rank is     0 among     4 tasks on machine c07
Hello, my rank is     1 among     4 tasks on machine c07

FINISHED at Wed Jun 18 15:27:29 CEST 2014

