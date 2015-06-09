To compile the ex5.* source files:

jmenu@castor:~/COURS > module load intelmpi/4.1.3

  mpiicc -o ex5_c ex5.c
  mpiicpc -o ex5_cxx ex5.cxx
  mpiifort -o ex5_f90 ex5.f90

--

To run them on the front-end:
  ./ex5_c
and so on with ex5_cxx and ex5_f90

--

To run them in an interactive SLURM session:

jmenu@castor:~/COURS > salloc -n 4
salloc: Granted job allocation 43196

jmenu@castor:~/COURS > module load intelmpi/4.1.3

jmenu@castor:~/COURS > srun ./ex5_c
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
jmenu@castor:~/COURS > 

--

To run them in batch mode:

Set the EXECUTABLE to be run in ex5.run, and then:

jmenu@castor:~/COURS > sbatch ex5.run
Submitted batch job 43314

jmenu@castor:~/COURS > cat slurm-43314.out

STARTING AT Thu Jun 19 12:20:26 CEST 2014

Currently Loaded Modulefiles:
  1) intel/14.0.1     2) intelmpi/4.1.3

--> LAUNCH_DIR = /home/jmenu/COURS
--> EXECUTABLE = ./ex5_f90

--> ./ex5_f90 depends on the following dynamic libraries:
	linux-vdso.so.1 =>  (0x00007fff0b502000)
	libmpigf.so.4 => /opt/software/intel/14.0.1/lib64/libmpigf.so.4 (0x00007fb7faa74000)
	libmpi.so.4 => /opt/software/intel/14.0.1/lib64/libmpi.so.4 (0x00007fb7fa409000)
	libdl.so.2 => /lib64/libdl.so.2 (0x0000003ed0000000)
	librt.so.1 => /lib64/librt.so.1 (0x0000003ed0c00000)
	libpthread.so.0 => /lib64/libpthread.so.0 (0x0000003ed0800000)
	libm.so.6 => /lib64/libm.so.6 (0x0000003ed1000000)
	libc.so.6 => /lib64/libc.so.6 (0x0000003ed0400000)
	libgcc_s.so.1 => /lib64/libgcc_s.so.1 (0x0000003467c00000)
	/lib64/ld-linux-x86-64.so.2 (0x0000003ecfc00000)

Hello, my rank is     3 among     4 tasks on machine c03 with my_var =    30 initially
Hello, my rank is     0 among     4 tasks on machine c03 with my_var =     0 initially
Hello, my rank is     2 among     4 tasks on machine c03 with my_var =    20 initially
Hello, my rank is     1 among     4 tasks on machine c03 with my_var =    10 initially
--- BARRIER! ---
c03                             : rank 20 sends to  0 and receives from =  2, my_var = 20
c03                             : rank 30 sends to  1 and receives from =  3, my_var = 30
c03                             : rank  0 sends to  2 and receives from =  0, my_var =  0
c03                             : rank 10 sends to  3 and receives from =  1, my_var = 10
Hello, my rank is     2 among     4 tasks on machine c03 with my_var =    10 finally
Hello, my rank is     3 among     4 tasks on machine c03 with my_var =    20 finally
Hello, my rank is     1 among     4 tasks on machine c03 with my_var =     0 finally
--- BARRIER! ---
Hello, my rank is     0 among     4 tasks on machine c03 with my_var =    30 finally

FINISHED at Thu Jun 19 12:20:26 CEST 2014

jmenu@castor:~/COURS > 
