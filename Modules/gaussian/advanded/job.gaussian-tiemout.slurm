#!/bin/bash
#SBATCH -J gaussian
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --mem=8000
#SBATCH --time=00:10:00
##SBATCH --signal=B:USR1@120

module purge
slmodules -r deprecated
module load gaussian/g09/D.01

trap 'kill -s USR1 $PID' SIGUSR1

g09_run test.inp > test.out &
PID=$!

wait ${PID}
wait ${PID}