#!/bin/bash -l
#SBATCH --job-name fluent_test
#SBATCH --nodes 1
#SBATCH --ntasks 16
#SBATCH --cpus-per-task 1
#SBATCH --ntasks-per-node 16
#SBATCH --mem 4000
#SBATCH --time 00:10:00

module load ansys

echo "================================================================"
date
echo "================================================================"
echo ""

# run Fluent 3d double precision without GUI on 1 node using 16 processors
fluent 3ddp -g -t${SLURM_NTASKS} -ssh -i fluent-test.jou

STATUS=$?

echo "================================================================"
date
echo "================================================================"
echo ""

echo "STATUS = $STATUS"
echo ""
