#!/bin/bash
#SBATCH --partition=kern,short,preempt
#SBATCH --job-name=pred
#SBATCH --output=%x.txt
#SBATCH --error=%x.txt
#SBATCH --time=0-01:00:00
#SBATCH --mem=2G
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --account=kernlab
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=nvillig2@uoregon.edu
#SBATCH --requeue

module load miniconda
conda activate jupyterlab-tf-plus-20220915

D0=training_data
NUM=10
OUTNAME=N${NUM}
python disperseNN.py \
  --predict \
  --load_weights ${D0}/${OUTNAME}_model.hdf5 \
  --training_params ${D0}/summary_stats.csv \
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
  --seed 12345 \
  --keras_verbose 2 \
  --out ${D0}/${OUTNAME}
