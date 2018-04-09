get_gbfs_feeds <- function(url) {

library(jsonlite)
library(tidyverse)
library(stringr)

#test url: "http://biketownpdx.socialbicycles.com/opendata/gbfs.json"
gbfs <- fromJSON(txt = url)

feeds <- gbfs$data$en$feeds

stat_info_feed <- feeds %>%
  select(url) %>%
  filter(str_detect(url, "station_information")) %>%
  as.character()

sys_info_feed <- feeds %>%
  select(url) %>%
  filter(str_detect(url, "system_information")) %>%
  as.character()

stat_status_feed <- feeds %>%
  select(url) %>%
  filter(str_detect(url, "station_status")) %>%
  as.character()

fbs_feed <- feeds %>%
  select(url) %>%
  filter(str_detect(url, "free_bike_status")) %>%
  as.character()

sys_hours_feed <- feeds %>%
  select(url) %>%
  filter(str_detect(url, "system_hours")) %>%
  as.character()

sys_cal_feed <- feeds %>%
  select(url) %>%
  filter(str_detect(url, "system_calendar")) %>%
  as.character()

sys_reg_feed <- feeds %>%
  select(url) %>%
  filter(str_detect(url, "system_regions")) %>%
  as.character()

sys_price_feed <- feeds %>%
  select(url) %>%
  filter(str_detect(url, "system_pricing_plans")) %>%
  as.character()

sys_alerts_feed <- feeds %>%
  select(url) %>%
  filter(str_detect(url, "system_alerts")) %>%
  as.character()

}
