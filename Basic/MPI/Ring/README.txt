To compile the ring.* source files:

  source /ssoft/spack/bin/slmodules.sh

Then, either:

  module load intel intelmpi

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

> module load intel intelmpi

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


STARTING AT ven. juil. 1 13:09:27 CEST 2016


Currently Loaded Modules:
  1) intel/16.0.3   2) intelmpi/5.1.3


--> EXECUTABLE = ./ring_c

--> ./ring_c depends on the following dynamic libraries:
	linux-vdso.so.1 =>  (0x00007fff07bff000)
	libmpifort.so.12 => /ssoft/spack/external/intel/2016/compilers_and_libraries_2016.3.210/linux/mpi/intel64/lib/libmpifort.so.12 (0x00007f8313a24000)
	libmpi.so.12 => /ssoft/spack/external/intel/2016/compilers_and_libraries_2016.3.210/linux/mpi/intel64/lib/release_mt/libmpi.so.12 (0x00007f8313255000)
	libdl.so.2 => /lib64/libdl.so.2 (0x0000003be3e00000)
	librt.so.1 => /lib64/librt.so.1 (0x0000003be4200000)
	libpthread.so.0 => /lib64/libpthread.so.0 (0x0000003be3a00000)
	libm.so.6 => /lib64/libm.so.6 (0x0000003968600000)
	libgcc_s.so.1 => /ssoft/spack/lafnetscha/opt/spack/x86_E5v1_IntelIB/gcc-4.4.7/gcc-4.9.3-2gys3tu6lq35ge6woeixfo4tfz5nnvzn/lib64/libgcc_s.so.1 (0x00007f831302f000)
	libc.so.6 => /lib64/libc.so.6 (0x0000003be3600000)
	/lib64/ld-linux-x86-64.so.2 (0x0000003be3200000)

Hello, my rank is 0 among 4 tasks on machine b181, with my_var = 0 initially
Hello, my rank is 1 among 4 tasks on machine b181, with my_var = 10 initially
Hello, my rank is 2 among 4 tasks on machine b181, with my_var = 20 initially
Hello, my rank is 3 among 4 tasks on machine b181, with my_var = 30 initially
--- BARRIER! ---
b181: rank 1 sends to 2 and receives from 0, my_var = 10
b181: rank 2 sends to 3 and receives from 1, my_var = 20
b181: rank 3 sends to 0 and receives from 2, my_var = 30
b181: rank 0 sends to 1 and receives from 3, my_var = 0
--- BARRIER! ---
Hello, my rank is 0 among 4 tasks on machine b181, with my_var = 30 finally
Hello, my rank is 1 among 4 tasks on machine b181, with my_var = 0 finally
Hello, my rank is 2 among 4 tasks on machine b181, with my_var = 10 finally
Hello, my rank is 3 among 4 tasks on machine b181, with my_var = 20 finally

FINISHED at ven. juil. 1 13:09:29 CEST 2016

