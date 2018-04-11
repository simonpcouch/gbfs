library(jsonlite)
library(tidyverse)
library(lubridate)

get_system_regions <- function (url, filepath = "data/system_regions.rds") {
  
system_regions_feed <- url
  
# save feed
system_regions <- fromJSON(txt = system_regions_feed)
  
# extract data, convert to df
system_regions_data <- system_regions$data$regions

# extract last_updated, convert POSIX timestamp to date
system_regions_last_updated <- system_regions$last_updated %>%
  as.POSIXct(., origin = "1970-01-01")

# extract time til next update (in seconds), convert to numeric
system_regions_ttl <- system_regions$ttl %>%
  as.numeric()

saveRDS(system_regions_data, file = filepath)
  
}
