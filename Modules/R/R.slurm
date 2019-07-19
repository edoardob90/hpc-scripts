#!/bin/bash -l

#SBATCH --nodes 1 
#SBATCH --ntasks 1 
#SBATCH --cpus-per-task 1
#SBATCH --mem 60000
#SBATCH --time 00:05:00
 
echo STARTING AT `date`

module purge 
module load gcc openblas/0.3.6-openmp
module load r
srun R CMD BATCH ./easyscript.R
 
echo FINISHED at `date`
