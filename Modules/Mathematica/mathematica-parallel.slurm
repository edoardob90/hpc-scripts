#!/bin/bash 
#SBATCH --job-name mathematica
#SBATCH --nodes 1
#SBATCH --ntasks-per-node 4
#SBATCH --cpus-per-task 1
#SBATCH --mem 4000
#SBATCH --time 00:10:00
 
module purge
module load mathematica

srun math -noprompt -run '<<pi-parallel.m'

