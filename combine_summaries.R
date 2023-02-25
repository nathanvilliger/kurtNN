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
  summarize(`avg of mean(actualized dispersal distances)` = mean(mean_distance),
            `sd of mean(actualized dispersal distances)` = sd(mean_distance),
            `avg of sd(actualized dispersal distances)` = mean(sd_distance),
            `sd of sd(actualized dispersal distances)` = sd(sd_distance))

summary_outname <- str_c(d0, 'summary_stats.csv')
write_csv(summary, summary_outname)