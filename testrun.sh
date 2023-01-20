#!/bin/bash
#SBATCH --partition=short
#SBATCH --job-name=karr
#SBATCH --output=%x.txt
#SBATCH --error=%x.txt
#SBATCH --open-mode=append
#SBATCH --time=0-00:05:00
#SBATCH --mem=3G
#SBATCH --array=0-599
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --account=softmatter
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=nvillig2@uoregon.edu

OUTDIR=test_runs
mkdir -p ${OUTDIR}

module load python3
python3 run_some_sims.py ${SLURM_ARRAY_TASK_ID} ${OUTDIR}
