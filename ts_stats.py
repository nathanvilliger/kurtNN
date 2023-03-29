'''
Compute pop gen statistics from tree sequences; append values to pre-existing
summary data frame.

This is mostly copy/pasted from data_generation.py, with the following implicit
ASSUMPTIONS:
- I have recapitated trees, named as follows, but those trees need mutations
- Using 5000 SNPs, as I did for every model I've trained thus far
- Mutation rate begins set to 1e-8, as I did for every model I've trained thus far
- num_reps is 1, as I did for every model I've trained thus far
'''

import numpy as np
import pandas as pd
import tskit
import msprime

mu = 1e-8
total_snps = 5000
seed = 12345

df = pd.read_csv('training_data/combined_summary.csv')
df['pi'] = np.nan
df['Tajimas_D'] = np.nan
for idx in df.idx:
    ts = tskit.load(f'training_data/tree{idx}_recap.trees')

    ts = msprime.sim_mutations(
        ts,
        rate=mu,
        random_seed=seed,
        model=msprime.SLiMMutationModel(type=0),
        keep=True,
    )
    # counter = 0
    while ts.num_sites < (total_snps * 2): # extra SNPs because a few are likely  non-biallelic
        # counter += 1
        mu *= 10
        ts = msprime.sim_mutations(
            ts,
            rate=mu,
            random_seed=seed,
            model=msprime.SLiMMutationModel(type=0),
            keep=True,
        )

    df.loc[df.idx == idx, 'pi'] = ts.diversity()
    df.loc[df.idx == idx, 'Tajimas_D'] = ts.Tajimas_D()

df.to_csv('training_data/combined_summary_wstats.csv', index=False)
