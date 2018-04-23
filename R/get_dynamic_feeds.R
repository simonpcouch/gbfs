get_free_bike_status <- function(url, filepath = "data/free_bike_status.rds") {

  library(jsonlite)
  library(tidyverse)
  library(lubridate)

  #get url
  # url for testing: "http://biketownpdx.socialbicycles.com/opendata/free_bike_status.json"
  free_bike_status_feed <- url

  #save feed
  free_bike_status <- fromJSON(txt = free_bike_status_feed)

  #extract data, convert to df
  free_bike_status_data <- free_bike_status$data$bikes

  #class columns
  free_bike_status_data$is_reserved <- as.logical(free_bike_status_data$is_reserved)
  free_bike_status_data$is_disabled <- as.logical(free_bike_status_data$is_disabled)

  #extract last_updated, convert POSIX timestamp to date
  free_bike_status_last_updated <- free_bike_status$last_updated %>%
    as.POSIXct(., origin = "1970-01-01")

  #mutate columns for time of observation
  free_bike_status_data <- free_bike_status_data %>%
    mutate(last_updated = free_bike_status_last_updated,
           year = lubridate::year(last_updated),
           month = lubridate::month(last_updated),
           day = lubridate::day(last_updated),
           hour = lubridate::hour(last_updated),
           minute = lubridate::minute(last_updated))


  #extract time til next update (in seconds), convert to numeric
  free_bike_status_ttl <- free_bike_status$ttl %>%
    as.numeric()

  update_fbs <- function(filepath) {
    fbs <- readRDS(filepath)
    fbs_update <- rbind(free_bike_status_data, fbs)
    saveRDS(fbs_update, file = filepath)
  }

  if (file.exists(filepath)) {
    update_fbs(filepath)
  }

  else {
    saveRDS(free_bike_status_data, file = filepath)
  }

}


get_station_status <- function(url, filepath = "data/station_status.rds") {

  library(jsonlite)
  library(tidyverse)
  library(lubridate)

  #get url
  station_status_feed <- url

  #save feed
  station_status <- fromJSON(txt = station_status_feed)

  #extract data, convert to df
  station_status_data <- station_status$data$stations

  #classcolumns of station_status_data
  station_status_data$last_reported <- as.POSIXct(station_status_data$last_reported,
                                                  origin = "1970-01-01")
  if ("num_bikes_disabled" %in% colnames(station_status_data)) {
    station_status_data$num_bikes_disabled <- as.numeric(station_status_data$num_bikes_disabled)
  }
  if ("num_docks_disabled" %in% colnames(station_status_data)) {
    station_status_data$num_docks_disabled <- as.numeric(station_status_data$num_docks_disabled)
  }
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

  if (file.exists(filepath)) {
    update_ss(filepath)
  }

  else {
    saveRDS(station_status_data, file = filepath)
  }

}
