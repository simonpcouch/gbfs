library(jsonlite)
library(tidyverse)
library(lubridate)

get_system_calendar <- function (url, filepath) {

system_calendar_feed <- url    

# save feed
system_calendar <- fromJSON(txt = system_calendar_feed)
  
# extract data, convert to df
system_calendar_data <- system_calendar$data$calendars

# extract last_updated, convert POSIX timestamp to date
system_calendar_last_updated <- system_calendar$last_updated %>%
  as.POSIXct(., origin = "1970-01-01")

# extract time til next update (in seconds), convert to numeric
system_calendar_ttl <- system_calendar$ttl %>%
  as.numeric()

saveRDS(system_calendar_data, file = filepath)
  
}
