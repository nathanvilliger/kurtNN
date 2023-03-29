# pivot the predictions data frame for more convenient automated plotting with
# e.g. seaborn or ggplot

suppressMessages(library(tidyverse))
setwd('~/Desktop/kurtNNtests/')

# pass *_predictions.csv output (from disperseNN.py --predict ...) as CL arg 1
args <- commandArgs(trailingOnly = TRUE)
fname <- ifelse(length(args) == 1, args[1], 'N100_tripM_predictions.csv')
preds <- read_csv(fname, col_types = cols())

# seems roundabout and bad but achieves the goal...? 
# pivot wider above first select leads to NA values for some reason
# second select is just for reordering columns
longer <- preds %>% 
  pivot_longer(cols=ends_with(c('mean_distance', 'sd_distance')), 
               names_to='name',
               values_to='value') %>%
  mutate(is_pred = str_detect(name, 'pred_'),
         type = ifelse(is_pred, 'predicted', 'true'),
         variable = str_remove(name, 'pred_')) %>% 
  select(idx, PL_dispersal, sigma, kernel_exponent, variable, type, value,
         LDD_class, prob_NO_LDD, prob_YES_LDD, pred_LDD_class) %>%
  pivot_wider(names_from=type, values_from=value) %>% 
  select(idx, PL_dispersal, sigma, kernel_exponent, variable, true, predicted,
         LDD_class, prob_NO_LDD, prob_YES_LDD, pred_LDD_class) %>% 
  mutate(RAE = abs(predicted - true) / true)

out_fname <- str_replace(fname, '.csv', '_longer.csv')
write_csv(longer, out_fname)
