#!/bin/bash -l
#SBATCH --job-name tutor
#SBATCH --nodes 1
#SBATCH --ntasks 28
#SBATCH --cpus-per-task 1
#SBATCH --mem 4000
#SBATCH --time 01:00:00
 
module purge
module load ansys
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/ssoft/spack/external/ansys/17.1/v171/Electronics/Linux64/defer:/ssoft/spack/external/ansys/17.1/v171/commonfiles/MainWin/linx64/mw/lib-amd64_linux/X11SLES
echo $LD_LIBRARY_PATH
# unset SLURM_GTIDS

echo "================================================================"
echo "Started at `date`"
echo "================================================================"
echo ""

ansys171 -dis -b -np ${SLURM_NTASKS} -j ${SLURM_JOB_NAME} -i tutor1_carrier_linux.inp -o results.out

STATUS=$?

echo "================================================================"
echo "Finished at `date`"
echo "================================================================"
echo ""

echo "STATUS = ${STATUS}"
echo ""
