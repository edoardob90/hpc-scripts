#!/bin/bash
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

module load spark/2.0.2
module load scala/2.11.11

# if not already there, get and untar examples
[ -f spark-2.0.2-bin-hadoop2.7.tgz ] || wget http://d3kbcqa49mib13.cloudfront.net/spark-2.0.2-bin-hadoop2.7.tgz
[ -d spark-2.0.2-bin-hadoop2.7 ] || tar -xvzf spark-2.0.2-bin-hadoop2.7.tgz

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
--class org.apache.spark.examples.SparkPi \
--master $MASTER_IP \
--executor-memory 512m \
spark-2.0.2-bin-hadoop2.7/examples/jars/spark-examples*.jar 48

stop-spark.sh
