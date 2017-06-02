library(traits)
library(dplyr)
library(readr)
library(RPostgreSQL)
library(DBI)

options(#betydb_key = readLines('~/.betykey', warn = FALSE),
  betydb_url = "https://betydb.org",
  betydb_api_version = 'beta')

#Gather species data:
if (!file.exists('data/species.rds')) {
  species <- betydb_query(table = 'species', limit = 'none') %>% 
  mutate(specie_id = id)
  saveRDS(species, 'data/species.rds')
} else {
  species <- readRDS('data/species.rds')
}

#Gather sites data:
if (!file.exists('data/sites.rds')) {
  sites <- betydb_query(table = 'sites', limit = 'none') %>% 
  mutate(site_id = id)
  saveRDS(sites,'data/sites.rds')
} else {
  sites <- readRDS('data/sites.rds')
}

#Gather yields data:
if (!file.exists('data/yields.rds')) {
  yields <- betydb_query(table = 'yields', limit = 'none') %>%
  mutate(yields_id = id)
  saveRDS(yields, file='data/yields.rds')
} else {
  yields <- readRDS('data/yields.rds')
}

#Load managements and managements_treatments from csv
#(Data not available through betydb_query() command)
m <- read_csv('data/managements.csv') 
mt <- read_csv('data/managements_treatments.csv')

#Extract planting data from managements
colnames(m) <- tolower(colnames(m))
planting <- m %>% filter(mgmttype %in% c('planting', 'planting (plants / m2)', 'seeding', 'thinning')) %>% 
  filter(!is.na(level)) %>% 
  filter(grepl('m-2', units)) %>% 
  select(management_id = id, planting_density = level, planting_date = date)
saveRDS(planting, 'data/planting.rds')

#Use managements_treatments to join planting data to yield data
#(Plan to move to separate script file)
colnames(mt) <- tolower(colnames(mt))
yieldVersusDensity <- left_join(yields,left_join(planting,mt,by='management_id'),by='treatment_id')
saveRDS(yieldVersusDensity, file='data/yieldVersusDensity.rds')

#Join species,sites data to certain subfields of yields
#yieldsSpecSites <- select(yields, id, date, mean, n, statname, stat, site_id, specie_id, treatment_id, citation_id, cultivar_id) %>% 
#  left_join(species, by = 'specie_id') %>%
#  left_join(sites, by = 'site_id')