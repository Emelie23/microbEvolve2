#!/bin/bash

#SBATCH --job-name=microbEvolve_QC
#SBATCH --time=00:20:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=2G
#SBATCH --output=slurm-%j.out
#SBATCH --error=slurm-%j.err

start_time=$(date +%s)

source $HOME/.bashrc
conda activate microbEvolve

sh $HOME/microbEvolve2/scripts/src/quality_control.sh