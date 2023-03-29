#!/bin/bash
#SBATCH --partition=kern,preempt
#SBATCH --job-name=ts
#SBATCH --output=%x.txt
#SBATCH --error=%x.txt
#SBATCH --time=0-04:00:00
#SBATCH --mem=2G
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --account=kernlab
#SBATCH --exclude=n244
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=nvillig2@uoregon.edu
#SBATCH --requeue

module load miniconda
conda activate jupyterlab-tf-plus-20220915

python ts_stats.py
