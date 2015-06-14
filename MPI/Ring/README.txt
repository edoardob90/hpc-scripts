To compile the ring.* source files:

module load intel intelmpi

  mpiicc -o ring_c ring.c
  mpiicpc -o ring_cxx ring.cxx
  mpiifort -o ring_f90 ring.f90

--

To run them on the front-end:
  ./ring_c
and so on with ring_cxx and ring_f90

--

To run them in an interactive SLURM session:

> salloc -n 4
salloc: Granted job allocation 43196

> module load intel intelmpi

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
Submitted batch job 43314

result on slurm out file should look like this:

STARTING AT Sun Jun 14 18:54:33 CEST 2015

Currently Loaded Modulefiles:
  1) intel/15.0.2.164   2) intelmpi/5.0.1

--> EXECUTABLE = ./ring_c

--> ./ring_c depends on the following dynamic libraries:
	linux-vdso.so.1 =>  (0x00007fffb69ff000)
	libmpifort.so.12 => /ssoft/intelmpi/5.0.1/RH6/all/x86_E5v2/impi/5.0.1.035/lib64/libmpifort.so.12 (0x00007f52fb72b000)
	libmpi.so.12 => /ssoft/intelmpi/5.0.1/RH6/all/x86_E5v2/impi/5.0.1.035/lib64/libmpi.so.12 (0x00007f52faffa000)
	libdl.so.2 => /lib64/libdl.so.2 (0x0000003d3ae00000)
	librt.so.1 => /lib64/librt.so.1 (0x0000003538800000)
	libpthread.so.0 => /lib64/libpthread.so.0 (0x0000003deaa00000)
	libm.so.6 => /lib64/libm.so.6 (0x0000003d3be00000)
	libgcc_s.so.1 => /lib64/libgcc_s.so.1 (0x000000337e400000)
	libc.so.6 => /lib64/libc.so.6 (0x0000003d3b200000)
	/lib64/ld-linux-x86-64.so.2 (0x0000003d3aa00000)

Hello, my rank is 0 among 4 tasks on machine b093, with my_var = 0 initially
Hello, my rank is 1 among 4 tasks on machine b093, with my_var = 10 initially
Hello, my rank is 2 among 4 tasks on machine b093, with my_var = 20 initially
Hello, my rank is 3 among 4 tasks on machine b093, with my_var = 30 initially
--- BARRIER! ---
b093: rank 0 sends to 1 and receives from 3, my_var = 0
b093: rank 1 sends to 2 and receives from 0, my_var = 10
b093: rank 2 sends to 3 and receives from 1, my_var = 20
b093: rank 3 sends to 0 and receives from 2, my_var = 30
--- BARRIER! ---
Hello, my rank is 0 among 4 tasks on machine b093, with my_var = 30 finally
Hello, my rank is 1 among 4 tasks on machine b093, with my_var = 0 finally
Hello, my rank is 2 among 4 tasks on machine b093, with my_var = 10 finally
Hello, my rank is 3 among 4 tasks on machine b093, with my_var = 20 finally

FINISHED at Sun Jun 14 18:54:35 CEST 2015

