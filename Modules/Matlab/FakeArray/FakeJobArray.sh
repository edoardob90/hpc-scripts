#!/bin/bash
#SBATCH --nodes 1
#SBATCH --time 00:10:00

#This number is the number of jobs per nodes
#SBATCH --ntasks-per-node 16

# The real job array is this times the number of tasks per node
#SBATCH --array=1-2

module load matlab

for i in $(seq 1 ${SLURM_TASKS_PER_NODE})
do
    #computes the new task_id
    TASK_ID=$(( ( ${SLURM_ARRAY_TASK_ID} - 1 ) * ${SLURM_TASKS_PER_NODE} + ${i} ))

    echo "${i} ${SLURM_ARRAY_TASK_ID} -> $TASK_ID"
    #determine a new output file for the fake_task
    OUTPUT_FILE=${SLURM_SUBMIT_DIR}/slurm-${SLURM_ARRAY_JOB_ID}_${SLURM_ARRAY_TASK_ID}__${TASK_ID}.out

    ### Add you script here with ${TASK_ID} as an argument
    ### the & at the end is important !!!

    ./launch_matlab.sh ${TASK_ID}   > ${OUTPUT_FILE} 2>&1 &

    #stores the pids for the wait at the end
    PIDs[$i]=$!
done

wait ${PIDs[*]}

