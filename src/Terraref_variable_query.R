library(dplyr)

bety_src <- src_postgres(dbname = "bety", 
                         password = 'bety', 
                         host = 'terra-bety.default', 
                         user = 'bety', 
                         port = 5432)

variables <- tbl(bety_src, "variables") %>%
  group_by(name) %>%
  collect()

saveRDS(variables, file='data/variables.rds')