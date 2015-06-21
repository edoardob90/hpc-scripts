#!/bin/bash
#SBATCH -J adf
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --mem=19000
#SBATCH --time=0:20:00
module load adf/2014.4/intel
adf < test.inp > test.out
