#!/bin/bash
#SBATCH -J cmpd
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --mem=20000
#SBATCH --time=00:05:00
module load cpmd/3.15.3/intel-15.0.0
srun $CPMD test.inp &> test.out
