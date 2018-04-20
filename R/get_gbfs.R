get_gbfs <- function(city, feeds = "all") {
  
  library(jsonlite)
  library(tidyverse)
  library(stringr)
  
#  source("get_gbfs_feeds.R")
#  source("get_station_information.R")
#  source("get_system_information.R")
#  source("get_system_hours.R")
#  source("get_system_calendar.R")
#  source("get_system_regions.R")
#  source("get_system_pricing_plans.R")
#  source("get_system_alerts.R")
#  source("get_station_status.R")
#  source("get_free_bike_status.R")
  
  # change this to a fuzzy match with systems.csv later
  url <- city
  
  gbfs <- fromJSON(txt = url)
  
  gbfs_feeds <- gbfs$data$en$feeds

# get feeds 
  stat_info_feed <- gbfs_feeds %>%
    select(url) %>%
    filter(str_detect(url, "station_information")) %>%
    as.character()
  
  sys_info_feed <- gbfs_feeds %>%
    select(url) %>%
    filter(str_detect(url, "system_information")) %>%
    as.character()
  
  stat_status_feed <- gbfs_feeds %>%
    select(url) %>%
    filter(str_detect(url, "station_status")) %>%
    as.character()
  
  if ("free_bike_status" %in% gbfs_feeds$name) {
    fbs_feed <- gbfs_feeds %>%
      select(url) %>%
      filter(str_detect(url, "free_bike_status")) %>%
      as.character()
  }
  
  if ("system_hours" %in% gbfs_feeds$name) {
    sys_hours_feed <- gbfs_feeds %>%
      select(url) %>%
      filter(str_detect(url, "system_hours")) %>%
      as.character()
  }
  
  if ("system_calendar" %in% gbfs_feeds$name) {
    sys_cal_feed <- gbfs_feeds %>%
      select(url) %>%
      filter(str_detect(url, "system_calendar")) %>%
      as.character()
  }
  
  if ("system_regions" %in% gbfs_feeds$name) {
    sys_reg_feed <- gbfs_feeds %>%
      select(url) %>%
      filter(str_detect(url, "system_regions")) %>%
      as.character()
  }
  
  if ("system_pricing_plans" %in% gbfs_feeds$name) {
    sys_price_feed <- gbfs_feeds %>%
      select(url) %>%
      filter(str_detect(url, "system_pricing_plans")) %>%
      as.character()
  }
  
  if ("system_alerts" %in% gbfs_feeds$name) {
    sys_alerts_feed <- gbfs_feeds %>%
      select(url) %>%
      filter(str_detect(url, "system_alerts")) %>%
      as.character()
  }
  
# call functions
  if (feeds == "all" | feeds == "static") {
    get_station_information(stat_info_feed)
    get_system_information(sys_info_feed)
    if (exists("sys_hours_feed")) {
      get_system_hours(sys_hours_feed)
    }
    if (exists("sys_cal_feed")) {
      get_system_calendar(sys_cal_feed)
    }
    if (exists("sys_reg_feed")) {
      get_system_regions(sys_reg_feed)
    }
    if (exists("sys_price_feed")) {
      get_system_pricing_plans(sys_price_feed)
    }
    if (exists("sys_alerts_feed")) {
      get_system_alerts(sys_alerts_feed)
    }
  }
  
  if (feeds == "all" | feeds == "dynamic") {
    get_station_status(stat_status_feed)
    if (exists("fbs_feed")) {
      get_free_bike_status(fbs_feed)
    }
  }
  
}
