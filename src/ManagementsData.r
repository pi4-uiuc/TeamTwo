library(traits)
library(dplyr)
library(RPostgreSQL)
library(DBI)

options(#betydb_key = readLines('~/.betykey', warn = FALSE),
  betydb_url = "https://betydb.org",
  betydb_api_version = 'beta')

species <- betydb_query(table = 'species', limit = 'none') %>% 
  mutate(specie_id = id)

sites <- betydb_query(table = 'sites', limit = 'none') %>% 
  mutate(site_id = id)

yields <- betydb_query(table = 'yields', limit = 'none') %>%
  select(id, date, mean, n, statname, stat, site_id, specie_id, treatment_id, citation_id, cultivar_id) %>% 
  left_join(species, by = 'specie_id') %>%
  left_join(sites, by = 'site_id') 

saveRDS(species, file='data/species.rds')
saveRDS(sites, file='data/sites.rds')
saveRDS(yields, file='data/yields.rds')