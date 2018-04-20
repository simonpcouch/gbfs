library(jsonlite)
library(tidyverse)
library(lubridate)
library(stringr)

get_station_information <- function(url, filepath = "data/station_information.rds") {

#get url
station_information_feed <- url

#save feed
station_information <- fromJSON(txt = station_information_feed)

#extract data, convert to df
station_information_data <- station_information$data$stations

#class columns
if ("rental_methods" %in% colnames(station_information_data)) {
  for (i in 1:nrow(station_information_data)) {
  station_information_data$rental_methods[i] <- paste(unlist(station_information_data$rental_methods[i]), collapse = ", ")
  }
}

#extract last_updated, convert POSIX timestamp to date
station_information_last_updated <- station_information$last_updated %>%
  as.POSIXct(., origin = "1970-01-01")

#extract time til next update (in seconds), convert to numeric
station_information_ttl <- station_information$ttl %>%
  as.numeric()

#save() results in a smaller file size and allows for easier `rbind`ing than write_csv()
#write_csv(x = station_information_data, path = "data-raw/station_information.csv")
saveRDS(station_information_data, file = filepath)
}

