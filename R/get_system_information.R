library(jsonlite)
library(tidyverse)
library(lubridate)

get_system_information <- function(url, filepath = "data/system_information.rds"){
  
system_information_feed <- url

# save feed
system_information <- fromJSON(txt = system_information_feed)

# extract data, convert to df
system_information_data <- as.data.frame(system_information$data)

# extract last_updated, convert POSIX timestamp to date
system_information_last_updated <- system_information$last_updated %>%
  as.POSIXct(., origin = "1970-01-01")

# extract time til next update (in seconds), convert to numeric
system_information_ttl <- system_information$ttl %>%
  as.numeric()

saveRDS(system_information_data, file = filepath)

}
