# Combine all summary files from individual simulations into one large csv
library(tidyverse)

d0 <-  'training_data/'
files <- Sys.glob(str_c(d0, 'summary*.txt'))
print(sprintf('Combining %d files', length(files)))

dfs <- lapply(files, read_csv, col_types=cols())
bound <- bind_rows(dfs)

outname <- str_c(d0, 'combined_summary.csv')
write_csv(bound, outname)