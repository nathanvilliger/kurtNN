#!/bin/bash
#SBATCH --partition=kern,short,preempt
#SBATCH --job-name=stats
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

D0=training_data
NUM=100
python disperseNN.py \
  --compute_stats \
  --tree_list ${D0}/tree_list.txt \
  --target_csv ${D0}/combined_summary.csv \
  --recapitate False \
  --mutate True \
  --mu 1e-8 \
  --num_snps 5000 \
  --min_n ${NUM} \
  --max_n ${NUM} \
  --edge_width 3 \
  --sampling_width 1 \
  --seed 1234 \
  --out None \
  --MDS_sorting
