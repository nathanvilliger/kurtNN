'''
Simulate expansions at the extremes of sigma (for Gaussian dispersal) and alpha
(for power law dispersal). What do the kurtosis values look like?
Command line arguments:
  - SLURM_ARRAY_TASK_ID is fed in at the command line, gets read in as sys.argv[1].
    Manually set the range of array indices in the Slurm job file, then match the
    necessary values here in the line of if-else statements.
  - Output directory OUTDIR comes next, read in as sys.argv[2].

This is messy but intended just as a quick and dirty prototype for now.
'''

import numpy as np
import subprocess, sys

# dispersal parameters
sigma_range = (0.2, 2)
alpha_range = (2, 5)
sigma, alpha = np.random.uniform(*sigma_range), np.random.uniform(*alpha_range)
PL = str(np.random.uniform() > 0.5)[0] # will be T or F for SLiM

# mutation and recombination
mutrate = 0
recomb = 1e-8

# simulation options
cap = 10
width = 50
maxgens = 1e5
record_dists = True

i = int(sys.argv[1])
command = ['./slim_3.7', '-l', '0',
           '-d', f'idx={i}',
           '-d', f'sigma={sigma}',
           '-d', f'alpha={alpha}',
           '-d', f'PL_dispersal={PL}',
           '-d', f'mu={mutrate}',
           '-d', f'r={recomb}',
           '-d', f'K={cap}',
           '-d', f'W={width}',
           '-d', f'maxgens={maxgens}',
           '-d', f'OUTDIR="{sys.argv[2]}"',
           '-d', f'summary_fname="summary{i}.txt"',
           '-d', f'record_dists={"T" if record_dists else "F"}',
           '-d', f'dist_fname="dists{i}.txt"',
           '-d', f'tree_fname="tree{i}.trees"',
           'simulate.slim']
subprocess.run(command)

if PL == 'T': disprint = f'PL dispersal with sigma = {sigma:.2f} and alpha = {alpha:.2f}'
else: disprint = f'Gaussian dispersal with sigma = {sigma:.2f}'
print(f'run {i} done --', disprint, flush=True)
