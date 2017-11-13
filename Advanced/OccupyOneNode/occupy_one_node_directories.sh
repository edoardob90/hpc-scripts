#!/bin/bash -l
#SBATCH --nodes 1
#SBATCH --time 1-00:00:00
#
# The two following parameters can be changed to run on machines which
# don't have 24 cores and 60GB of memory (Eltanin) or if the memory
# requirements are different:
#SBATCH --ntasks 24
#SBATCH --mem-per-cpu 2500


# README
# ===================================================================
# In this example a list of directories in the INPUT directory are
# processed independently. The directories are named after the year
# and quarter they refer to: YYYYQQ.
# The output (stdout) of processing each file is stored in a separate
# file in the current directory.
# The script in this example takes as parameters the year and quarter.
# ===================================================================


module purge
module load gcc
module load python

INPUT="/scratch/user/input_files"

script="/home/user/code/process_quarter.py"

# Counter for output files indexing
i=1

# Loop over the entries (directories) in the INPUT folder
for quarter in $(ls ${INPUT})
do
    echo "Triggering processing for quarter ${quarter}"
    qyear=${quarter:0:4}
    qtrim=${quarter:4:2}

    # Define the command and the output file for this task
    COMMAND="python ${script} ${qyear} ${qtrim}"
    OUTPUT_FILE="${SLURM_SUBMIT_DIR}/slurm-${SLURM_JOBID}.${i}.${quarter}.out"
    
    # Trigger tasks
    # each one is put into the background (by starting them with '&')
    # the output of the srun and command are redirected to a specific file
    srun --exclusive --ntasks 1 ${COMMAND} > ${OUTPUT_FILE} 2>&1 &

    # Increase counter
    let i+=1
    sleep 1 
done

# Important!
# Makes the main job script wait for all the background srun commands
wait

echo "Finished!"
