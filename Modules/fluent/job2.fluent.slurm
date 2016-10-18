#!/bin/bash -l
#SBATCH --job-name fluent_test
#SBATCH --nodes 2
#SBATCH --ntasks 32
#SBATCH --cpus-per-task 1
#SBATCH --ntasks-per-node 16
#SBATCH --mem 4000
#SBATCH --time 00:10:00

module load ansys/17.1

echo "================================================================"
date
echo "================================================================"
echo ""

HOSTS_FILE=hostlist-job${SLURM_JOB_ID}
srun hostname | sort > ${HOSTS_FILE}

# run Fluent 3d double precision without GUI on 2 nodes using 32 processors
fluent 3ddp -g -t${SLURM_NTASKS} -ssh -i fluent-test.jou -cnf=${HOSTS_FILE}

STATUS=$?

echo "================================================================"
date
echo "================================================================"
echo ""

echo "STATUS = $STATUS"
echo ""
