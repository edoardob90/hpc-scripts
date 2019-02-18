#!/bin/bash -l
#SBATCH --job-name oommf
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 1
#SBATCH --mem 4000
#SBATCH --time 00:10:00
 
module purge

export PATH=$PATH:/home/rezzonic/vickys_packaging/spack/opt/spack/linux-rhel7-x86_E5v2/gcc-4.8.5/oommf-2.0a0_20170929-syv4fa2dfoadtvnbpaqcgzywkvx24oxg/bin

export OOMMF_OUTDIR=$SLURM_SUBMIT_DIR

srun oommf.tcl batchsolve -cwd $SLURM_SUBMIT_DIR taskA.mif
#srun oommf.tcl batchmaster simpletask.tcl
