#!/bin/bash

#SBATCH --workdir /scratch/scitas-ge/rezzonic/Examples/MatlabArray
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 1
#SBATCH --mem 1096
#SBATCH --time 00:10:00

#SBATCH --array=1-729

module load matlab/R2014b

sleep 20

matlab -nodesktop -singleCompThread -nodisplay -nosplash -r "onejob(${SLURM_ARRAY_TASK_ID})"
