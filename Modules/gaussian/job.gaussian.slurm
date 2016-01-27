#!/bin/bash -l
#SBATCH -J gaussian
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --mem=8000
#SBATCH --time=0:10:00
module load gaussian/g09/D.01
g09_run test.inp > test.out
