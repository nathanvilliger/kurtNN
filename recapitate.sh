#!/bin/bash
#SBATCH --partition=kern,short
#SBATCH --job-name=recap
#SBATCH --output=%x.txt
#SBATCH --error=%x.txt
#SBATCH --time=1-00:00:00
#SBATCH --mem=10G
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=16
#SBATCH --account=kernlab
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=nvillig2@uoregon.edu

module load easybuild icc/2017.1.132-GCC-6.3.0-2.27 impi/2017.1.132 parallel/20160622
module load miniconda
conda activate jupyterlab-tf-plus-20220915

DIR=training_data
rm ${DIR}/recap_commands.txt
rm ${DIR}/tree_list.txt

for i in {1..2000}; do
  if test -f "${DIR}/tree$i.trees"; then
        echo "python recap.py ${DIR}/tree$i 1e-8 $i" >> ${DIR}/recap_commands.txt
        echo ${DIR}/tree$i"_"recap.trees >> ${DIR}/tree_list.txt
  fi
done
parallel -j ${SLURM_CPUS_PER_TASK} < ${DIR}/recap_commands.txt
