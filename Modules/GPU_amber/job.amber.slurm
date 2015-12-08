#!/bin/bash -l
#SBATCH -J amber
#SBATCH --mem=32000
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --ntasks-per-core=1
#SBATCH --partition=gpu
#SBATCH --qos=gpu
#SBATCH --gres=gpu:1
#SBATCH --time=0:05:00
module load amber/14/intel-14.0.1_cuda
export SLURM_TMPDIR=/tmp/${SLURM_JOBID}.slurm
export WORKDIR=$PWD
mkdir $SLURM_TMPDIR
rsync -a . $SLURM_TMPDIR/
cd $SLURM_TMPDIR
pmemd.cuda_SPFP -O -i md.in -o md.out -p AAAT.top -c AAAT_ini.rst -r AAAT.1.rst -x AAAT.1.trj -e AAAT.1.ene
rsync -a . $WORKDIR/
cd $WORKDIR
rm -rf $SLURM_TMPDIR
