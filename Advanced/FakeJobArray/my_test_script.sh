task=$1

echo "Start ${task} $(date) on $(hostname)"
echo "I'm am fake task ${task} from JOB_ID ${SLURM_JOBID} - ${SLURM_ARRAY_TASK_ID}"


sleep 600
echo "End ${task} $(date)"
