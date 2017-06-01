library(readr)
library(dplyr)

m <- read_csv('data/managements.csv') 

colnames(m) <- tolower(colnames(m))
planting <- m %>% filter(mgmttype %in% c('planting', 'planting (plants / m2)', 'seeding', 'thinning')) %>% 
  filter(!is.na(level)) %>% 
  filter(grepl('m-2', units)) %>% 
  select(management_id = id, planting_density = level, planting_date = date)