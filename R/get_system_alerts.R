library(jsonlite)
library(tidyverse)
library(lubridate)

get_system_alerts <- function (url, filepath = "data/system_alerts.rds") {
  
  system_alerts_feed <- url
  
  # save feed
  system_alerts <- fromJSON(txt = system_alerts_feed)
  
  # extract data, convert to df
  system_alerts_data <- system_alerts$data$alerts
  
  # extract last_updated, convert POSIX timestamp to date
  system_alerts_last_updated <- system_alerts$last_updated %>%
    as.POSIXct(., origin = "1970-01-01")
  
  # extract time til next update (in seconds), convert to numeric
  system_alerts_ttl <- system_alerts$ttl %>%
    as.numeric()
  
  saveRDS(system_alerts_data, file = filepath)
  
}
