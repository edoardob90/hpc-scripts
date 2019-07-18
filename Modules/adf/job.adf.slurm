#!/bin/bash -l
#SBATCH -J adf
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --mem=19000
#SBATCH --time=0:20:00
module load adf
adf < test.inp > test.out
