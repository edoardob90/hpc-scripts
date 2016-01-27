#!/bin/bash -l 
#SBATCH -J vasp-test
#SBATCH --mem=18000
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --time=0:30:00
module load vasp/4.6/intel-15.0.0
srun vasp
