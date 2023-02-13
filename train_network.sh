#!/bin/bash
#SBATCH --partition=kern,long
#SBATCH --job-name=highn
#SBATCH --output=%x.txt
#SBATCH --error=%x.txt
#SBATCH --time=14-00:00:00
#SBATCH --mem=10G
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=20
#SBATCH --account=kernlab
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=nvillig2@uoregon.edu

module load miniconda
conda activate jupyterlab-tf-plus-20220915

D0=training_data
NUM=100
OUTNAME=N${NUM}
python disperseNN.py \
  --train \
  --validation_split 0.2 \
  --tree_list ${D0}/tree_list.txt \
  --target_csv ${D0}/combined_summary.csv \
  --recapitate False \
  --mutate True \
  --mu 1e-8 \
  --min_n ${NUM} \
  --max_n ${NUM} \
  --edge_width 3 \
  --sampling_width 1 \
  --num_snps 5000 \
  --repeated_samples 50 \
  --batch_size 50 \
  --threads ${SLURM_CPUS_PER_TASK} \
  --max_epochs 100 \
  --seed 12345 \
  --out ${D0}/${OUTNAME}
