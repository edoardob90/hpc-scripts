To compile the ring.* source files:

  source /ssoft/spack/bin/slmodules.sh

Then, either:

  module load intel intel-mpi

  mpiicc -o ring_c ring.c
  mpiicpc -o ring_cxx ring.cxx
  mpiifort -o ring_f90 ring.f90

or:

  module load gcc mvapich2

  mpicc -o ring_c ring.c
  mpicxx -o ring_cxx ring.cxx
  mpifort -o ring_f90 ring.f90

or:

  module load gcc openmpi

  mpicc -o ring_c ring.c
  mpicxx -o ring_cxx ring.cxx
  mpifort -o ring_f90 ring.f90

according to the desired compiler and MPI variant

--

To run them on the front-end:
  ./ring_c
and so on with ring_cxx and ring_f90

--

To run them in an interactive SLURM session:

> salloc -n 4
salloc: Granted job allocation 43196

> source /ssoft/spack/bin/slmodules.sh

> module load intel intel-mpi

# or
# module load gcc mvapich2
# module load gcc openmpi

> srun ./ring_c
Hello, my rank is 2 among 4 tasks on machine c03, with my_var = 20 initially
Hello, my rank is 1 among 4 tasks on machine c03, with my_var = 10 initially
Hello, my rank is 3 among 4 tasks on machine c03, with my_var = 30 initially
Hello, my rank is 0 among 4 tasks on machine c03, with my_var = 0 initially
c03: rank 1 sends to 2 and receives from 0, my_var = 10
c03: rank 2 sends to 3 and receives from 1, my_var = 20
--- BARRIER! ---
c03: rank 0 sends to 1 and receives from 3, my_var = 0
c03: rank 3 sends to 0 and receives from 2, my_var = 30
Hello, my rank is 1 among 4 tasks on machine c03, with my_var = 0 finally
--- BARRIER! ---
Hello, my rank is 0 among 4 tasks on machine c03, with my_var = 30 finally
Hello, my rank is 3 among 4 tasks on machine c03, with my_var = 20 finally
Hello, my rank is 2 among 4 tasks on machine c03, with my_var = 10 finally
> 

--

To run them in batch mode:

Set the EXECUTABLE to be run in ring.run, and then:

> sbatch ring.run
Submitted batch job 1028026

result on slurm-1028026.out file should look like this:


STARTING AT jeu. oct. 12 16:04:54 CEST 2017


Currently Loaded Modules:
  1) intel/17.0.2   2) intel-mpi/2017.2.174

 


--> EXECUTABLE = ./ring_c

--> ./ring_c depends on the following dynamic libraries:
	linux-vdso.so.1 =>  (0x00007ffde7a72000)
	libmpifort.so.12 => /ssoft/spack/external/intel/2017/impi/2017.2.174/lib64/libmpifort.so.12 (0x00007f6ca6e64000)
	libmpi.so.12 => /ssoft/spack/external/intel/2017/impi/2017.2.174/lib64/libmpi.so.12 (0x00007f6ca6154000)
	libdl.so.2 => /usr/lib64/libdl.so.2 (0x00007f6ca5f3e000)
	librt.so.1 => /usr/lib64/librt.so.1 (0x00007f6ca5d36000)
	libpthread.so.0 => /usr/lib64/libpthread.so.0 (0x00007f6ca5b1a000)
	libm.so.6 => /usr/lib64/libm.so.6 (0x00007f6ca5817000)
	libgcc_s.so.1 => /ssoft/spack/cornalin/rc1/opt/spack/linux-rhel6-x86_E5v1_IntelIB/gcc-4.4.7/gcc-5.4.0-m2dusvculeorwfjrpouxaiha4v2nkusq/lib64/libgcc_s.so.1 (0x00007f6ca5600000)
	libc.so.6 => /usr/lib64/libc.so.6 (0x00007f6ca523f000)
	/lib64/ld-linux-x86-64.so.2 (0x00007f6ca720f000)

Hello, my rank is 0 among 4 tasks on machine f174, with my_var = 0 initially
Hello, my rank is 2 among 4 tasks on machine f174, with my_var = 20 initially
Hello, my rank is 1 among 4 tasks on machine f174, with my_var = 10 initially
Hello, my rank is 3 among 4 tasks on machine f174, with my_var = 30 initially
--- BARRIER! ---
f174: rank 0 sends to 1 and receives from 3, my_var = 0
f174: rank 2 sends to 3 and receives from 1, my_var = 20
f174: rank 1 sends to 2 and receives from 0, my_var = 10
f174: rank 3 sends to 0 and receives from 2, my_var = 30
--- BARRIER! ---
Hello, my rank is 0 among 4 tasks on machine f174, with my_var = 30 finally
Hello, my rank is 1 among 4 tasks on machine f174, with my_var = 0 finally
Hello, my rank is 2 among 4 tasks on machine f174, with my_var = 10 finally
Hello, my rank is 3 among 4 tasks on machine f174, with my_var = 20 finally

FINISHED at jeu. oct. 12 16:04:56 CEST 2017

