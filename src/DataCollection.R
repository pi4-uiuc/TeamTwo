library(traits)
library(dplyr)
library(readr)
library(DBI)
library(RPostgreSQL)

options(#betydb_key = readLines('~/.betykey', warn = FALSE),
  betydb_url = "https://betydb.org",
  betydb_api_version = 'beta')

setwd('~/TeamTwo')

#Gather species data:
if (!file.exists('data/species.rds')) {
  species <- betydb_query(table = 'species', limit = 'none')
  names(species)[names(species)=='id'] <- 'specie_id'
  saveRDS(species, 'data/species.rds')
} else {
  species <- readRDS('data/species.rds')
}

#Gather sites data:
if (!file.exists('data/sites.rds')) {
  sites <- betydb_query(table = 'sites', limit = 'none')
  names(sites)[names(sites)=='id'] <- 'sites_id'
  saveRDS(sites,'data/sites.rds')
} else {
  sites <- readRDS('data/sites.rds')
}

#Gather traits data:
if (!file.exists('data/traits.rds')) {
  traits <- betydb_query(table = 'traits', limit = 'none')
  names(traits)[names(traits)=='id'] <- 'traits_id'
  saveRDS(traits,'data/traits.rds')
} else {
  traits <- readRDS('data/traits.rds')
}

#Gather variables data:
if (!file.exists('data/variables.rds')) {
  variables <- betydb_query(table = 'variables', limit = 'none')
  names(variables)[names(variables)=='id'] <- 'variables_id'
  saveRDS(variables,'data/variables.rds')
} else {
  variables <- readRDS('data/variables.rds')
}

#Gather yields data:
if (!file.exists('data/yields.rds')) {
  yields <- betydb_query(table = 'yields', limit = 'none')
  names(yields)[names(yields)=='id'] <- 'yields_id'
  saveRDS(yields, file='data/yields.rds')
} else {
  yields <- readRDS('data/yields.rds')
}

#Load managements and managements_treatments from csv
#(Data not available through betydb_query() command)
m <- read_csv('data/managements.csv')
colnames(m) <- tolower(colnames(m))
if (!file.exists('data/managements.rds')) {saveRDS(m,'data/managements.rds')}
mt <- read_csv('data/managements_treatments.csv')
colnames(mt) <- tolower(colnames(mt))
if (!file.exists('data/managements_treatments.rds')) {saveRDS(mt,'data/managements_treatments.rds')}