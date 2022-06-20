#!/bin/bash
#SBATCH --job-name=zero-one-laws-sim
#SBATCH --time=1-00:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=4gb
#SBATCH --array=1-18


module purge
module load Julia/1.7.2-linux-x86_64
julia selectedExperiment${SLURM_ARRAY_TASK_ID}.jl