library(jsonlite)
library(tidyverse)

#get url
feed <- "http://biketownpdx.socialbicycles.com/opendata/station_status.json"

#save feed
station_status <- fromJSON(txt = feed)

#extract data, convert to df
station_status_data <- station_status$data$stations

#extract last_updated, convert POSIX timestamp to date
station_status_last_updated <- station_status$last_updated %>%
  as.POSIXct(., origin = "1970-01-01")

#extract time til next update (in seconds), convert to numeric
station_status_ttl <- station_status$ttl %>%
  as.numeric()

