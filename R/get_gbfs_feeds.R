get_gbfs_feeds <- function(url) {

library(jsonlite)
library(tidyverse)
library(stringr)

#test url: "http://biketownpdx.socialbicycles.com/opendata/gbfs.json"
gbfs <- fromJSON(txt = url)

feeds <- gbfs$data$en$feeds

stat_info_feed <<- feeds %>%
  select(url) %>%
  filter(str_detect(url, "station_information")) %>%
  as.character()

sys_info_feed <<- feeds %>%
  select(url) %>%
  filter(str_detect(url, "system_information")) %>%
  as.character()

stat_status_feed <<- feeds %>%
  select(url) %>%
  filter(str_detect(url, "station_status")) %>%
  as.character()

if ("free_bike_status" %in% feeds$name) {
fbs_feed <<- feeds %>%
  select(url) %>%
  filter(str_detect(url, "free_bike_status")) %>%
  as.character()
}

if ("system_hours" %in% feeds$name) {
sys_hours_feed <<- feeds %>%
  select(url) %>%
  filter(str_detect(url, "system_hours")) %>%
  as.character()
}

if ("system_calendar" %in% feeds$name) {
sys_cal_feed <<- feeds %>%
  select(url) %>%
  filter(str_detect(url, "system_calendar")) %>%
  as.character()
}

if ("system_regions" %in% feeds$name) {
sys_reg_feed <<- feeds %>%
  select(url) %>%
  filter(str_detect(url, "system_regions")) %>%
  as.character()
}

if ("system_pricing_plans" %in% feeds$name) {
sys_price_feed <<- feeds %>%
  select(url) %>%
  filter(str_detect(url, "system_pricing_plans")) %>%
  as.character()
}

if ("system_alerts" %in% feeds$name) {
sys_alerts_feed <<- feeds %>%
  select(url) %>%
  filter(str_detect(url, "system_alerts")) %>%
  as.character()
}

}
