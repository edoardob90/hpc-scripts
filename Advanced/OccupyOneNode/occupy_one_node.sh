#!/bin/bash -l
#SBATCH --nodes 1
#SBATCH --time 00:10:00
#SBATCH --ntasks-per-node 16


for i in $(seq 1 ${SLURM_TASKS_PER_NODE})
do

    echo "${i} ${SLURM_JOBID} -> $TASK_ID"
    #determine a new output file for the fake_task
    OUTPUT_FILE=${SLURM_SUBMIT_DIR}/slurm-${SLURM_JOBID}_${i}.out

    ### Add you script here with ${TASK_ID} as an argument
    ### the & at the end is important !!!

    ./my_test_script.sh ${i}   > ${OUTPUT_FILE} 2>&1 &

    #stores the pids for the wait at the end
    PIDs[$i]=$!
done

wait ${PIDs[*]}

