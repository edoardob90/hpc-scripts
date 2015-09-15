#!/bin/bash 
#SBATCH -J molpro_test
#SBATCH --mem=32000
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --time=0:10:00
module load molpro/2012.1.22/intel-15.0.2_intelmpi
molpro test_big.inp
joberror=$?

exit $joberror
