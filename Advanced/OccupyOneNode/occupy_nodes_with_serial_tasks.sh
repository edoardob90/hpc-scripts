#!/bin/bash -l

#SBATCH --nodes 1
#SBATCH --cpus-per-task 1
#SBATCH --mem-per-cpu 4G

# README
# ===================================================================
# In this example an imaginary chemistry code is executed. It will 
# process 300 files: myinput.001 to myinput.300, and will produce the
# corresponding output files. The output (stdout) of the command is
# captured into a corresponding file under the submission directory.
# 
# Slurm parameters:
#   * --nodes 1
#     as srun is used to launch the tasks this can be any number
#   * --mem-per-cpu 4G
#     this needs to be set for the '--exclusive' parameter of srun to
#     work as expected. It should be adapted to each use case.
#   * --cpus-per-task 1
#     this can be adjusted to run (non-MPI) multithreaded code
#  
# Note: This example differs from the accompanying ones in particular
# because xargs is used to manage the "queue" of tasks to execute. As
# such there is no need to 'wait' for any task as they are never sent
# into the background.
# ===================================================================

echo started at `date`
 
module purge
module load intel intel-mpi
module load chem2020
 
# calculate how many tasks can we run simultaneously
# (i.e. how many cores are available)
NR_TASKS=$(echo $SLURM_TASKS_PER_NODE | sed 's/\([0-9]\+\)(x\([0-9]\+\))/\1*\2/' | bc)

# execute the 300 tasks, NR_TASKS tasks at a time, redirecting the
# output to a 
cat <(seq -w 1 300) | \
    xargs -I{} -max-procs=$NR_TASKS \
    bash -c "srun -N 1 -n 1 --exclusive chem2020.x -in myinput.{} -out myout.{} > ${SLURM_SUBMIT_DIR}/slurm-${SLURM_JOBID}.{}.out 2>&1"

echo finished at `date`
