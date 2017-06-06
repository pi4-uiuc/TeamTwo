library(traits)
library(dplyr)
library(readr)
library(DBI)
library(RPostgreSQL)

#Merging tables and extracting planting data
#Run DataCollection.R first

#Extract planting data from managements table
m <- readRDS('data/managements.rds')
planting <- m %>% filter(mgmttype %in% c('planting', 'planting (plants / m2)', 'seeding', 'thinning')) %>% 
  filter(!is.na(level)) %>% 
  filter(grepl('m-2', units)) %>% 
  select(management_id = id, planting_density = level, planting_date = date)
saveRDS(planting, 'data/planting.rds')

#Use managements_treatments to join planting data to yield data
mt <- readRDS('data/managements_treatments.rds')
yields <- readRDS('data/yields.rds')
yieldVersusDensity <- left_join(yields,left_join(planting,mt,by='management_id'),by='treatment_id')
saveRDS(yieldVersusDensity, file='data/yieldVersusDensity.rds')

#Join species,sites data to certain subfields of yields
#(This can be uncommented if species or sites data needs to be joined)
#yieldsSpecSites <- select(yields, id, date, mean, n, statname, stat, site_id, specie_id, treatment_id, citation_id, cultivar_id) %>% 
#  left_join(species, by = 'specie_id') %>%
#  left_join(sites, by = 'site_id')