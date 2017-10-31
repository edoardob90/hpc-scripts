#!/bin/bash -l 
#SBATCH -J cp2k
#SBATCH --mem=18000
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --time=00:05:00

module purge
module load intel intel-mpi intel-mkl cp2k

# or alternatively:
# module load gcc mvapich2 openblas cp2k

srun cp2k.popt -i test.inp -o test.out
joberror=$?

exit $joberror
