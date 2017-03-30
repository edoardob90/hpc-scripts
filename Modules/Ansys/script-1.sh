#!/bin/bash 
#SBATCH --job-name tutor
#SBATCH --nodes 1
#SBATCH --ntasks 16
#SBATCH --cpus-per-task 1
#SBATCH --mem 4000
#SBATCH --time 01:00:00
 
module purge
module load ansys/17.1

echo "================================================================"
echo "Started at `date`"
echo "================================================================"
echo ""

ansys171 -dis -b -np ${SLURM_NTASKS} -j ${SLURM_JOB_NAME} -i tutor1_carrier_linux.inp -o h.out

STATUS=$?

echo "================================================================"
echo "Finished at `date`"
echo "================================================================"
echo ""

echo "STATUS = ${STATUS}"
echo ""
