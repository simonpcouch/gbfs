library(jsonlite)
library(tidyverse)
library(lubridate)

get_system_hours <- function (url, filepath = "data/system_hours.rds") {
  
system_hours_feed <- url

# save feed
system_hours <- fromJSON(txt = system_hours_feed)

# extract data, convert to df
system_hours_data <- system_hours$data$rental_hours

# class columns
for (i in 1:nrow(system_hours_data)) {
  system_hours_data$user_types[i] <- paste(unlist(system_hours_data$user_types[i]), collapse = ", ")
  system_hours_data$days[i] <- paste(unlist(system_hours_data$days[i]), collapse = ", ")
}

# extract last_updated, convert POSIX timestamp to date
system_hours_last_updated <- system_hours$last_updated %>%
  as.POSIXct(., origin = "1970-01-01")

# extract time til next update (in seconds), convert to numeric
system_hours_ttl <- system_hours$ttl %>%
  as.numeric()

saveRDS(system_hours_data, file = filepath)
  
}
