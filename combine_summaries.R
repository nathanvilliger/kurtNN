# Combine all summary files from individual simulations into one large csv
# Also compute mean and sd of the relevant variables, to be used when 
# un-standardizing model predictions
suppressMessages(library(tidyverse))

d0 <-  'training_data/'
files <- Sys.glob(str_c(d0, 'summary*.txt'))
print(sprintf('Combining %d files', length(files)))

dfs <- lapply(files, read_csv, col_types=cols())
bound <- bind_rows(dfs) %>% arrange(idx)

outname <- str_c(d0, 'combined_summary.csv')
write_csv(bound, outname)

summary <- bound %>% 
  summarize(avg_mean_distance = mean(mean_distance),
            sd_mean_distance = sd(mean_distance),
            avg_sd_distance = mean(sd_distance),
            sd_sd_distance = sd(sd_distance))

summary_outname <- str_c(d0, 'summary_stats.csv')
write_csv(summary, summary_outname)