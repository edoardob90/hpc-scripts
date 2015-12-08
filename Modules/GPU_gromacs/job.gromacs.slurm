#!/bin/bash -l
#SBATCH -J Gromacs
#SBATCH -N 1
#SBATCH --cpus-per-task=1
#SBATCH --ntasks-per-core=1
#SBATCH --partition=gpu
#SBATCH --qos=gpu
#SBATCH --gres=gpu:1
#SBATCH --mem 32000
#SBATCH --time 0:05:00
module load gromacs/5.0.5/gcc-4.4.7_cuda
srun mdrun_mpi
