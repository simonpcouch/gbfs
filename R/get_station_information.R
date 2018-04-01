library(jsonlite)
library(tidyverse)
library(lubridate)

#get url
station_information_feed <- "http://biketownpdx.socialbicycles.com/opendata/station_information.json"

#save feed
station_information <- fromJSON(txt = station_information_feed)

#extract data, convert to df
station_information_data <- station_information$data$stations

#class columns
station_information_data$rental_methods <- as.character(station_information_data$rental_methods)

#extract last_updated, convert POSIX timestamp to date
station_information_last_updated <- station_information$last_updated %>%
  as.POSIXct(., origin = "1970-01-01")

#extract time til next update (in seconds), convert to numeric
station_information_ttl <- station_information$ttl %>%
  as.numeric()

