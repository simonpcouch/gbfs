library(jsonlite)
library(tidyverse)
library(lubridate)

get_free_bike_status <- function(url) {

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

update_fbs <- function() {
fbs <- readRDS("~/bikeshare-1/data/fbs.rds")
fbs_update <- rbind(free_bike_status_data, fbs)
saveRDS(fbs_update, file = "~/bikeshare-1/data/fbs.rds")
}

ifelse(file.exists("~/bikeshare-1/data/fbs.rds"), 
       update_fbs(),
       saveRDS(free_bike_status_data, file = "~/bikeshare-1/data/fbs.rds"))
}

