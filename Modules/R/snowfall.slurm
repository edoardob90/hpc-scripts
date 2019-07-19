#!/bin/bash -l

#SBATCH --nodes 1-1
#SBATCH --exclusive
#SBATCH --mem 60000
#SBATCH --time 00:05:00
 
echo STARTING AT `date`

module purge 
module load gcc openblas/0.3.6-openmp
module load r
srun R CMD BATCH ./snowfall.R

srun env
 
echo FINISHED at `date`
