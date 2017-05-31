library(traits)
library(dplyr)
library(RPostgreSQL)
library(DBI)
bety_src <- src_postgres(dbname = "bety", 
                         password = 'bety', 
                         host = 'terra-bety.default', 
                         user = 'bety', 
                         port = 5432)
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

managements_treatments <- tbl(bety_src, 'managements_treatments') %>%
  select(treatment_id, management_id)

treatments <- tbl(bety_src, 'treatments') %>% 
  dplyr::mutate(treatment_id = id) %>% 
  dplyr::select(treatment_id, name, definition, control)

managements <- tbl(bety_src, 'managements') %>%
  filter(mgmttype %in% c('fertilizer_N', 'fertilizer_N_rate', 'planting', 'irrigation')) %>%
  dplyr::mutate(management_id = id) %>%
  dplyr::select(management_id, date, mgmttype, level, units) %>%
  left_join(managements_treatments, by = 'management_id') %>%
  left_join(treatments, by = 'treatment_id') 
