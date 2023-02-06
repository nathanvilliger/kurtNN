import sys, tskit, msprime

# inputs
prefix = sys.argv[1] # path to tree sequence without ".trees"
r = float(sys.argv[2]) # recombination rate
myseed = int(sys.argv[3]) # random number seed, e.g. the simulatoin id #                                                              

# load tree sequence
ts = tskit.load(prefix+".trees")


# count individuals
alive_inds = []
for i in ts.individuals():
    alive_inds.append(i.id)
Ne = len(alive_inds)

# simplify to get rid of extraneous populations; this should be cleaned up at some point to avoid the simplify
ts = ts.simplify(keep_input_roots=True) # keep_input_roots is required for recapitation

# check that intended population ID exists
print(f"Number of trees with only one root: {sum([t.num_roots == 1 for t in ts.trees()])}\n"
      f"Number with more than one root: {sum([t.num_roots > 1 for t in ts.trees()])}")
pop_id = None
for p in ts.populations():
    print(p)
    if p.metadata != None:
        slimid = p.metadata['slim_id']
        if slimid == 1: # either 0 or 1, depending on which of your slim recipes you used                                                    
            pop_id = int(p.id)
if pop_id == None:
    print("need to find the correct population ID")
    exit()

# recapitate
demography = msprime.Demography.from_tree_sequence(ts)
demography[pop_id].initial_size = Ne
ts = msprime.sim_ancestry(
        initial_state=ts,
        demography=demography,
        recombination_rate=r,
        random_seed=myseed,
)
print(f"Number of trees with only one root: {sum([t.num_roots == 1 for t in ts.trees()])}\n"
      f"Number with more than one root: {sum([t.num_roots > 1 for t in ts.trees()])}")

# output
ts.dump(prefix+"_recap.trees")
