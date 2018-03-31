library(jsonlite)
library(tidyverse)
library(lubridate)

#get url
feed <- "http://biketownpdx.socialbicycles.com/opendata/free_bike_status.json"

#save feed
free_bike_status <- fromJSON(txt = feed)

#extract data, convert to df
free_bike_status_data <- free_bike_status$data$bikes

#extract last_updated, convert POSIX timestamp to date
free_bike_status_last_updated <- free_bike_status$last_updated %>%
  as.POSIXct(., origin = "1970-01-01")

#extract time til next update (in seconds), convert to numeric
free_bike_status_ttl <- free_bike_status$ttl %>%
  as.numeric()

