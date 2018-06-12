#!/bin/bash
#SBATCH -N 2
#SBATCH -t 00:10:00

#SBATCH --constraint=E5v4

set -x
 
module load spark
 
MASTER=$(hostname)
echo $MASTER
export SPARK_LOCAL_DIRS=$(mktemp -d)
export SPARK_WORKER_DIR=$(mktemp -d)
export SPARK_LOG_DIR="spark-logs"
mkdir -p $SPARK_LOG_DIR
 
 
srun ./start-cluster.sh $MASTER &
 
sleep 60 #give the cluster some time to start
 
#submit your job
$SPARK_ROOT/bin/spark-submit \
    --master spark://$MASTER:7077 \
    pi.py
 
$SPARK_ROOT/sbin/stop-master.sh spark://$MASTER:7077
