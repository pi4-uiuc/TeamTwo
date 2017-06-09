# Loads data from betydb.org if possible; if not possible,
# loads data from CSV file in data/ directory.

library(traits)
library(readr)

options(#betydb_key = readLines('~/.betykey', warn = FALSE),
  betydb_url = "https://betydb.org",
  betydb_api_version = 'beta')

setwd('~/TeamTwo')

betydbQuerySlick <- function(tableName,idName) {
  # Given tableName, returns data from <tableName> at betydb.org,
  # and both loads data into environment and saves file to RDS.
  # If RDS already exists, loads from RDS instead of querying
  # database. Renames key column 'id' with idName.
  if (!file.exists(paste0('data/',tableName,'.rds'))) {
    tableData <- betydb_query(table = tableName, limit = 'none')
    names(tableData)[names(tableData)=='id'] <- idName
    saveRDS(tableData, paste0('data/',tableName,'.rds'))
  } else {
    tableData <- readRDS(paste0('data/',tableName,'.rds'))
  }
  return(tableData)
}

csvLoadSlick <- function(tableName) {
  # Given tableName, loads <tableName>.csv from data/, loads
  # into memory, and saves to RDS. If RDS already exists, loads
  # from RDS instead of loading from CSV. Sets all column names
  # to lower case.
  if (!file.exists(paste0('data/',tableName,'.rds'))) {
    tableData <- read_csv(paste0('data/',tableName,'.csv'))
    colnames(tableData) <- tolower(colnames(tableData))
    saveRDS(tableData,paste0('data/',tableName,'.rds'))
  } else {
    tableData <- readRDS(paste0('data/',tableName,'.rds'))
  }
  return(tableData)
}

#Gather species data:
species <- betydbQuerySlick(tableName = 'species', idName = 'specie_id')

#Gather sites data:
# sites <- betydbQuerySlick(tableName = 'sites', idName = 'site_id')

#Gather traits data:
traits <- betydbQuerySlick(tableName = 'traits', idName = 'traits_id')

#Gather variables data:
variables <- betydbQuerySlick(tableName = 'variables', idName = 'variable_id')

#Gather yields data:
yields <- betydbQuerySlick(tableName = 'yields', idName = 'yields_id')

#Load managements and managements_treatments from CSV
# m <- csvLoadSlick('managements')
# mt <- csvLoadSlick('managements_treatments')