#!/bin/bash -l
#SBATCH --job-name ansys-tutor
#SBATCH --nodes 2
#SBATCH --ntasks 56
#SBATCH --cpus-per-task 1
#SBATCH --mem 4000
#SBATCH --time 01:00:00
 
module purge
module load ansys

# unset SLURM_GTIDS

echo "================================================================"
echo "Started at `date`"
echo "================================================================"
echo ""

ansys192 -dis -b -np ${SLURM_NTASKS} -j ${SLURM_JOB_NAME} -i tutor1_carrier_linux.inp -o results.out

STATUS=$?

echo "================================================================"
echo "Finished at `date`"
echo "================================================================"
echo ""

echo "STATUS = ${STATUS}"
echo ""
