#!/bin/bash 
#SBATCH --job-name maple
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 1
#SBATCH --mem 4000
#SBATCH --time 00:10:00
 
module purge
module load maple

srun maple -q simple_test.mpl
