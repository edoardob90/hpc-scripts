#!/bin/bash -l 
#SBATCH -J molpro_test
#SBATCH --mem=32000
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --time=0:10:00

source /ssoft/spack/bin/slmodules.sh -r deprecated

module load intel intel-mpi mkl molpro
molpro test_big.inp
joberror=$?

exit $joberror
