library(jsonlite)
library(tidyverse)
library(lubridate)

get_system_pricing_plans <- function(url, filepath = "data/system_pricing_plans.rds") {
  
  system_pricing_plans_feed <- url
  
  # save feed
  system_pricing_plans <- fromJSON(txt = system_pricing_plans_feed)
  
  # extract data, convert to df
  system_pricing_plans_data <- system_pricing_plans$data$plans
  
  # class columns
  system_pricing_plans_data$is_taxable <- as.logical(system_pricing_plans_data$is_taxable)
  
  # extract last_updated, convert POSIX timestamp to date
  system_pricing_plans_last_updated <- system_pricing_plans$last_updated %>%
    as.POSIXct(., origin = "1970-01-01")
  
  # extract time til next update (in seconds), convert to numeric
  system_pricing_plans_ttl <- system_pricing_plans$ttl %>%
    as.numeric()
  
  saveRDS(system_pricing_plans_data, file = filepath)
  
}
