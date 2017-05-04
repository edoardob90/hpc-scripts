#!/bin/bash -l

#SBATCH --nodes 1 
#SBATCH --ntasks 1 
#SBATCH --cpus-per-task 1
#SBATCH --mem 60000
#SBATCH --time 00:05:00
 
echo STARTING AT `date`

module purge 
module load intel mkl
module load R
srun R CMD BATCH ./easyscript.R
 
echo FINISHED at `date`
