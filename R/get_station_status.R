library(jsonlite)
library(tidyverse)
library(lubridate)

get_station_status <- function(url, filepath) {

#get url
station_status_feed <- url

#save feed
station_status <- fromJSON(txt = station_status_feed)

#extract data, convert to df
station_status_data <- station_status$data$stations

#classcolumns of station_status_data
station_status_data$last_reported <- as.POSIXct(station_status_data$last_reported, 
                                               origin = "1970-01-01")
station_status_data$num_bikes_disabled <- as.numeric(station_status_data$num_bikes_disabled)
station_status_data$is_installed <- as.logical(station_status_data$is_installed)
station_status_data$is_renting <- as.logical(station_status_data$is_renting)
station_status_data$is_returning <- as.logical(station_status_data$is_returning)

#rename last_reported to last_updated for consistency between datasets
station_status_data <- rename(station_status_data, last_updated = last_reported)

#mutate more useful columns from last_updated
station_status_data <- station_status_data %>%
  mutate(year = lubridate::year(last_updated),
         month = lubridate::month(last_updated),
         day = lubridate::day(last_updated),
         hour = lubridate::hour(last_updated),
         minute = lubridate::minute(last_updated))

#extract time til next update (in seconds), convert to numeric
station_status_ttl <- station_status$ttl %>%
  as.numeric()

update_ss <- function(filepath) {
  ss <- readRDS(filepath)
  ss_update <- rbind(station_status_data, ss)
  saveRDS(ss_update, file = filepath)
}

ifelse(file.exists(filepath), 
       update_ss(filepath),
       saveRDS(station_status_data, file = filepath))
}
