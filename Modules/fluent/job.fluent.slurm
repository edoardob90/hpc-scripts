#!/bin/bash
#SBATCH --job-name fluent_test
#SBATCH --nodes 1
#SBATCH --ntasks 16
#SBATCH --cpus-per-task 1
#SBATCH --ntasks-per-node 16
#SBATCH --mem 4000
#SBATCH --time 00:10:00

module load ansys/15.0.7

echo "================================================================"
date
echo "================================================================"
echo ""

# run Fluent 3d double precision without GUI using 16 processors   
if [ -f fluent-test.log ]; then
   rm -f fluent-test.log
fi
fluent 3ddp -g -t16 -ssh -i fluent-test.jou > fluent-test.log 2>&1

STATUS=$?

echo "================================================================"
date
echo "================================================================"
echo ""

echo "STATUS = $STATUS"
echo ""
