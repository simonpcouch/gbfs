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


get_system_calendar <- function (url, filepath = "data/system_calendar.rds") {

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
