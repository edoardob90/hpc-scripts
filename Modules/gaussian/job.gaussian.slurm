#!/bin/bash -l
#SBATCH -J gaussian
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --mem=8000
#SBATCH --time=00:10:00

module purge
module load gaussian

g09_run test.inp > test.out
