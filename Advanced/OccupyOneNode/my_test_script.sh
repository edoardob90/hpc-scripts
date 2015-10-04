task=$1

echo "Start ${task} $(date) on $(hostname)"
echo "I'm task ${task} from JOB_ID ${SLURM_JOBID}"


sleep 600
echo "End ${task} $(date)"
