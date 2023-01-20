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

sigma_range = (0.2, 2)
alpha_range = (1, 5)

# want 100 gaussian low sigma, 100 gaussian high sigma, 100 PL low alpha low sigma,
# 100 PL low alpha high sigma, 100 PL high alpha low sigma, 100 PL high alpha high sigma
# following adapted from original (bad) for-loop
i = int(sys.argv[1])
PL = 'F' if i < 200 else 'T'
if i < 100:
    sigma = np.min(sigma_range)
    alpha = np.min(alpha_range)
elif i >= 100 and i < 200:
    sigma = np.max(sigma_range)
    alpha = np.min(alpha_range)
elif i >= 200 and i < 300:
    sigma = np.min(sigma_range)
    alpha = np.min(alpha_range)
elif i >= 300 and i < 400:
    sigma = np.max(sigma_range)
    alpha = np.min(alpha_range)
elif i >= 400 and i < 500:
    sigma = np.min(sigma_range)
    alpha = np.max(alpha_range)
elif i >= 500:
    sigma = np.max(sigma_range)
    alpha = np.max(alpha_range)

command = ['./slim_3.7', '-l', '0',
           '-d', f'sigma={sigma}',
           '-d', f'alpha={alpha}',
           '-d', f'PL_dispersal={PL}',
           '-d', 'maxgens=50',
           '-d', f'OUTDIR="{sys.argv[2]}"',
           '-d', f'summary_fname="summary{i}.txt"',
           'test.slim']
subprocess.run(command)
