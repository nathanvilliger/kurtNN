#!/bin/bash
#SBATCH --partition=kern,long
#SBATCH --job-name=karr
#SBATCH --output=%x.txt
#SBATCH --error=%x.txt
#SBATCH --open-mode=append
#SBATCH --time=3-00:00:00
#SBATCH --mem=2G
#SBATCH --array=151-2000
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --account=kernlab
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=nvillig2@uoregon.edu

OUTDIR=training_data
mkdir -p ${OUTDIR}

module load python3
python3 run_some_sims.py ${SLURM_ARRAY_TASK_ID} ${OUTDIR}
