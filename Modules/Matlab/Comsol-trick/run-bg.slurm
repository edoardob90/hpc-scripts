#!/bin/bash -l

#SBATCH --nodes 1
#SBATCH --ntasks 16
#SBATCH --cpus-per-task 1
#SBATCH --mem 24000
#SBATCH --time 00:10:00

module load matlab

sleep 20

matlab -nodesktop -singleCompThread -nodisplay -nosplash -r "onejob" &
matlab -nodesktop -singleCompThread -nodisplay -nosplash -r "onejob" &
matlab -nodesktop -singleCompThread -nodisplay -nosplash -r "onejob" &
matlab -nodesktop -singleCompThread -nodisplay -nosplash -r "onejob" &
matlab -nodesktop -singleCompThread -nodisplay -nosplash -r "onejob" &
matlab -nodesktop -singleCompThread -nodisplay -nosplash -r "onejob" &
matlab -nodesktop -singleCompThread -nodisplay -nosplash -r "onejob" &
matlab -nodesktop -singleCompThread -nodisplay -nosplash -r "onejob" &
matlab -nodesktop -singleCompThread -nodisplay -nosplash -r "onejob" &
matlab -nodesktop -singleCompThread -nodisplay -nosplash -r "onejob" &
matlab -nodesktop -singleCompThread -nodisplay -nosplash -r "onejob" &
matlab -nodesktop -singleCompThread -nodisplay -nosplash -r "onejob" &
matlab -nodesktop -singleCompThread -nodisplay -nosplash -r "onejob" &
matlab -nodesktop -singleCompThread -nodisplay -nosplash -r "onejob" &
matlab -nodesktop -singleCompThread -nodisplay -nosplash -r "onejob" &
matlab -nodesktop -singleCompThread -nodisplay -nosplash -r "onejob" &
wait
