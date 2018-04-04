library(jsonlite)
library(tidyverse)
library(lubridate)

get_station_status <- function() {

#get url
station_status_feed <- "http://biketownpdx.socialbicycles.com/opendata/station_status.json"

#save feed
station_status <- fromJSON(txt = station_status_feed)

#extract data, convert to df
station_status_data <- station_status$data$stations

#class columns of station_status_data
station_status_data$last_reported <- as.POSIXct(station_status_data$last_reported, 
                                               origin = "1970-01-01")
station_status_data$num_bikes_disabled <- as.numeric(station_status_data$num_bikes_disabled)
station_status_data$is_installed <- as.logical(station_status_data$is_installed)
station_status_data$is_renting <- as.logical(station_status_data$is_renting)
station_status_data$is_returning <- as.logical(station_status_data$is_returning)

#extract last_updated, convert POSIX timestamp to date
station_status_last_updated <- station_status$last_updated %>%
  as.POSIXct(., origin = "1970-01-01")

#mutate new last_updated column
station_status_data <- station_status_data %>%
  mutate(last_updated = station_status_last_updated)

#extract time til next update (in seconds), convert to numeric
station_status_ttl <- station_status$ttl %>%
  as.numeric()

#save() results in a smaller file size and allows for easier `rbind`ing than write_csv()
#write_csv(x = station_status_data, path = "data-raw/station_status.csv")
save(station_status_data, file = "~/bikeshare-1/data-raw/station_status_data.rda")
}
