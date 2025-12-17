#!/bin/bash

#SBATCH --job-name=ritme_optimization
#SBATCH --time=03:59:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --mem-per-cpu=10G
#SBATCH --tmp=100G
#SBATCH --output=slurm-%j.out
#SBATCH --error=slurm-%j.err

## BROKEN!

module load eth_proxy

start_time=$(date +%s)

echo "SLURM_CPUS_PER_TASK: $SLURM_CPUS_PER_TASK"
echo "SLURM_GPUS: $SLURM_GPUS"

ulimit -u 60000
ulimit -n 524288

source $HOME/.bashrc 
conda activate ritme

# Run the python script - Ray will be started by ritme with address=None (patched)
# The environment variables above disable the dashboard agent
python -u scripts/05-3_ritme.py
exit_code=$?

# Check if the script executed successfully
if [ $exit_code -eq 0 ]; then
    echo "Job completed successfully."
else
    echo "Job failed with exit code $exit_code"
fi

end_time=$(date +%s)
duration=$((end_time - start_time))
echo "Total execution time: $(date -u -d @${duration} +%H:%M:%S)"
