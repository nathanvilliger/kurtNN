# kurtNNtests

## Initial idea

Can we train disperseNN-like networks to learn:

1. What is the typical dispersal distance?

2. How much variability is there in dispersal distances?

3. Is there long-range dispersal in the population?

*without* assuming any particular jump kernel during the training process? Original disperseNN assumed Gaussian jump kernels, NV later showed that similar models can accurately estimate the exponent of power law jump kernels when trained to do so. Perhaps a nice next step would be to estimate dispersal parameters without assuming any specific jump kernel. 

## The approach

Generally: follow disperseNN as closely as possible. I may be slightly curt here at times; consider first checking the [disperseNN documentation](https://github.com/kr-colab/disperseNN) if anything written in this document is unclear. That being said, I will make an effort to highlight new things we do here that are not part of original disperseNN.

Simulations may use either Gaussian or power law jump kernels. Our approach was to focus on the dispersal distances of everyone alive during the final time step of simulations. We trained models to estimate the sample mean and standard deviation of those dispersal distances for questions 1 and 2. For question 3, we initially thought we might use the sample excess kurtosis of the dispersal distances to draw a boundary between the yes and no classifications, hence the semi-sarcastic software name kurtNN ("curtain"); however, the excess kurtosis values in our training data were well separated, so we just tried to classify between Gaussian and power law jump kernels. 

**New**: the kernel exponent is referred to as $\alpha$ in this project; its usual label of $\mu$ was already taken by the mutation rate.

### Running individual simulations

Use `simulate.slim` to run individual simulations. It's ready to go for individual simulations in the GUI. All important variables are defined at the top of the `initialize()` event within the `if (exists('slimgui'))` block of code. Simulations can be run from the command line if you set values for each of those variables using the `-d` flag. Simulations generate three output files:

1. a text file containing the dispersal distances of everyone alive in the final simulation time step

2. a single-row CSV summary file containing parameter values and statistics on the dispersal distances of everyone alive in the final simulation time step

3. the tree sequence showing the ancestry of everyone alive in the final simulation time step

The script was written using SLiM 3.7. Syntax changed a tiny bit with SLiM 4 but the GUI should automatically suggest any necessary changes if you try to run this in the GUI but have version 4 rather than 3.7 installed. 

### Running batches of simulations

We generated training data by running `submit_job.sh`, which submitted a big array of jobs that each called `run_some_sims.py` to run one simulation. `run_some_sims.py` randomly drew the values of sigma and the kernel exponent from the range specified at the top of the file, set parameter values and output file names, and called `simulate.slim`. 

For later convenience we combined all the single-row summary files into one large CSV file using `combine_summaries.R`.

### Training networks

Use `train_network.sh`, which submits a job that runs `disperseNN.py` using the `--train` option.

**New**: the `--MDS_sorting` option sorts individuals by spatial location when assembling the genotype matrix (original disperseNN was random/unsorted). It uses a dimensionality reduction technique called multidimensional scaling to project individuals' positions onto a 1D landscape while preserving distances between individuals as well as possible. MDS sorting led to a 50% reduction in validation loss in the models we trained! Evidently knowing who is close to whom gives the model useful information about how dispersal is driving spatial mixing across the landscape.

### Predicting using trained networks

Use `predict.sh`, which submits a job that runs `disperseNN.py` using the `--predict` option.

**New**: be sure to use `--MDS_sorting` here too if it was used during training.

### Computing statistics on tree sequences

**New**: Use `compute_ts_stats.sh`, which submits a job that runs `disperseNN.py` using the `--compute_stats` option. This option computes summary statistics on each tree sequence in the training data, then appends statistics to the appropriate row of the pre-existing combined summary file that was generated earlier using `combine_summaries.R`. It could be useful to e.g. compute some summaries on all the tree sequences and then explore for signals of differences depending on which jump kernel was used. The entire `--compute_stats` option is new and required changes to `disperseNN.py` and `data_generation.py` that are not present in the original software.