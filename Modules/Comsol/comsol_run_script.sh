#!/bin/bash -l

#SBATCH --nodes 2
#SBATCH --ntasks-per-node 2
#SBATCH --cpus-per-task 8

#SBATCH --time 01:00:00

#SBATCH --mem 10240

#SBATCH --output=slurm.%N.%j.out
#SBATCH --error=slurm.%N.%j.err

module purge

module load comsol

ulimit -s unlimited
ulimit -c unlimited

if [ -z "${SLURM_NTASKS_PER_NODE}" ]; then
    SLURM_NTASKS_PER_NODE=$(( $SLURM_NTASKS / $SLURM_NNODES ))
fi

echo " ****** START OF JOB ******"
echo $SLURM_NTASKS
echo $SLURM_NTASKS_PER_NODE
echo $SLURM_CPUS_PER_TASK

hostfile=hostlist-job${SLURM_JOB_ID}
srun hostname | sort > ${hostfile}

comsol batch -clustersimple -nn $SLURM_NTASKS -nnhost $SLURM_NTASKS_PER_NODE -np $SLURM_CPUS_PER_TASK -f ${hostfile} -mpifabrics shm:ofa -inputfile test.mph -outputfile testoutput.mph

echo " ****** END OF JOB ******"

STATUS=$status
echo ""
echo "==> Resulting STATUS = $STATUS"
echo

