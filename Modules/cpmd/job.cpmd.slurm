#!/bin/bash -l
#SBATCH -J cmpd
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --mem=20000
#SBATCH --time=00:05:00

module purge
module load intel intel-mpi intel-mkl cpmd

# or alternatively:
# module load gcc mvapich2 openblas cpmd

srun cpmd.x test.inp &> test.out
