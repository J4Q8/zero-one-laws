#!/bin/bash
#SBATCH --time=00:01:00
#SBATCH --mem=1G
#SBATCH --job-name=zero-one-laws-sim

module purge
module load Julia/1.7.2-linux-x86_64
julia testExperiment.jl