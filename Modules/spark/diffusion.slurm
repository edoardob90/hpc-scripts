#!/bin/bash
# author: gilles fourestey (EPFL)
#
#SBATCH --nodes=2
#  ntasks per node MUST be one, because multiple slaves per work doesn't
#  work well with slurm + spark in this script (they would need increasing
#  ports among other things)
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=24
#SBATCH --mem=8192
#  Beware! $HOME will not be expanded and invalid paths will result Slurm jobs
#  hanging indefinitely with status CG (completing) when calling scancel!
#SBATCH --time=00:30:00

module load spark

echo "---- starting $0 on $HOSTNAME"
echo
#
MASTER_NODE=""
start-spark.sh


echo "configuration done..."
set -x
MASTER_IP=$(cat ${SLURM_JOBID}_spark_master)
echo $MASTER_IP

time time spark-submit \
--executor-memory 5G \
--master $MASTER_IP \
./diffusion.py


stop-spark.sh



