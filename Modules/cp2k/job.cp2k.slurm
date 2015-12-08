#!/bin/bash -l 
#SBATCH -J cp2k
#SBATCH --mem=18000
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --time=00:05:00
module load cp2k/2.6.0/intel-15.0.0
srun $CP2K -i test.inp -o test.out
joberror=$?

exit $joberror
