#' Save the station_information feed.
#' 
#' \code{get_station_information} saves the station_information feed for a given city as a .rds object.
#' 
#' @param city A character string or a url to an active gbfs.json feed.
#' @param directory The name of an existing folder or folder to be created, where the feed will
#'   will be saved.
#' @param file The name of the file to be saved. Must end in .rds.
#' @return A .rds object generated from the current station_information feed.
#' @examples
#' get_station_information(city = "http://biketownpdx.socialbicycles.com/opendata/station_information.json")
#' get_station_information(city = "Battle Creek")
#' @export

get_station_information <- function(city, directory = "data", file = "station_information.rds") {

  url <- city_to_url(city)
  
  if (url != city) {
    gbfs <- fromJSON(txt = url)
    gbfs_feeds <- gbfs$data$en$feeds
    station_information_feed <- gbfs_feeds %>%
      select(url) %>%
      filter(str_detect(url, "station_information")) %>%
      as.character()
  }
  else {
    station_information_feed <- url
  }

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
  
  # create directory
  if (!dir.exists(directory)) {
    dir.create(directory)
  }

  #save() results in a smaller file size and allows for easier `rbind`ing than write_csv()
  #write_csv(x = station_information_data, path = "data-raw/station_information.csv")
  saveRDS(station_information_data, file = paste(directory, file, sep = "/"))
}

#' Save the system_alerts feed.
#' 
#' \code{get_system_alerts} saves the system_alerts feed for a given city as a .rds object.
#' 
#' @param city A character string or a url to an active gbfs.json feed.
#' @param directory The name of an existing folder or folder to be created, where the feed will
#'   will be saved.
#' @param file The name of the file to be saved. Must end in .rds.
#' @return A .rds object generated from the current system_alerts feed.
#' @examples
#' get_system_alerts(city = "http://biketownpdx.socialbicycles.com/opendata/system_alerts.json")
#' get_system_alerts(city = "Santa Monica")
#' @export

get_system_alerts <- function (city, directory = "data", file = "system_alerts.rds") {

  url <- city_to_url(city)
  
  if (url != city) {
    gbfs <- fromJSON(txt = url)
    gbfs_feeds <- gbfs$data$en$feeds
    if ("system_alerts" %in% gbfs_feeds$name) {
      system_alerts_feed <- gbfs_feeds %>%
        select(url) %>%
        filter(str_detect(url, "system_alerts")) %>%
        as.character()
    }
  }
  else {
    system_alerts_feed <- url
  }

  # save feed
  system_alerts <- fromJSON(txt = system_alerts_feed)

  # extract data, convert to df
  system_alerts_data <- system_alerts$data$alerts

  # extract last_updated, convert POSIX timestamp to date
  system_alerts_last_updated <- system_alerts$last_updated %>%
    as.POSIXct(., origin = "1970-01-01")
  
  # create directory
  if (!dir.exists(directory)) {
    dir.create(directory)
  }

  saveRDS(system_alerts_data, file = paste(directory, file, sep = "/"))

}

#' Save the system_calendar feed.
#' 
#' \code{get_system_calendar} saves the system_calendar feed for a given city as a .rds object.
#' 
#' @param city A character string or a url to an active gbfs.json feed.
#' @param directory The name of an existing folder or folder to be created, where the feed will
#'   will be saved.
#' @param file The name of the file to be saved. Must end in .rds.
#' @return A .rds object generated from the current system_calendar feed.
#' @examples
#' get_system_calendar(city = "http://biketownpdx.socialbicycles.com/opendata/system_calendar.json")
#' get_system_calendar(city = "Tampa")
#' @export

get_system_calendar <- function (city, directory = "data", file = "system_calendar.rds") {

  url <- city_to_url(city)
  
  if (url != city) {
    gbfs <- fromJSON(txt = url)
    gbfs_feeds <- gbfs$data$en$feeds
    if ("system_calendar" %in% gbfs_feeds$name) {
      system_calendar_feed <- gbfs_feeds %>%
        select(url) %>%
        filter(str_detect(url, "system_calendar")) %>%
        as.character()
    }
  }
  else {
    system_calendar_feed <- url
  }

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
  
  # create directory
  if (!dir.exists(directory)) {
    dir.create(directory)
  }

  saveRDS(system_calendar_data, file = paste(directory, file, sep = "/"))

}

#' Save the system_hours feed.
#' 
#' \code{get_system_hours} saves the system_hours feed for a given city as a .rds object.
#' 
#' @param city A character string or a url to an active gbfs.json feed.
#' @param directory The name of an existing folder or folder to be created, where the feed will
#'   will be saved.
#' @param file The name of the file to be saved. Must end in .rds.
#' @return A .rds object generated from the current system_hours feed.
#' @examples
#' get_system_hours(city = "http://biketownpdx.socialbicycles.com/opendata/system_hours.json")
#' get_system_hours(city = "Phoenix")
#' @export

get_system_hours <- function (city, directory = "data", file = "system_hours.rds") {

  url <- city_to_url(city)
  
  if (url != city) {
    gbfs <- fromJSON(txt = url)
    gbfs_feeds <- gbfs$data$en$feeds
    if ("system_hours" %in% gbfs_feeds$name) {
      system_hours_feed <- gbfs_feeds %>%
        select(url) %>%
        filter(str_detect(url, "system_hours")) %>%
        as.character()
    }
  }
  else {
    system_hours_feed <- url
  }

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

  # create directory
  if (!dir.exists(directory)) {
    dir.create(directory)
  }
  
  saveRDS(system_hours_data, file = paste(directory, file, sep = "/"))

}

#' Save the system_information feed.
#' 
#' \code{get_system_information} saves the system_information feed for a given city as a .rds object.
#' 
#' @param city A character string or a url to an active gbfs.json feed.
#' @param directory The name of an existing folder or folder to be created, where the feed will
#'   will be saved.
#' @param file The name of the file to be saved. Must end in .rds.
#' @return A .rds object generated from the current system_information feed.
#' @examples
#' get_system_information(city = "http://biketownpdx.socialbicycles.com/opendata/system_information.json")
#' get_system_information(city = "Omaha")
#' @export

get_system_information <- function(city, directory = "data", file = "system_information.rds"){

  url <- city_to_url(city)
  
  if (url != city) {
    gbfs <- fromJSON(txt = url)
    gbfs_feeds <- gbfs$data$en$feeds
    system_information_feed <- gbfs_feeds %>%
      select(url) %>%
      filter(str_detect(url, "system_information")) %>%
      as.character()
  }
  else {
    system_information_feed <- url
  }

  # save feed
  system_information <- fromJSON(txt = system_information_feed)

  # extract data, convert to df
  system_information_data <- as.data.frame(system_information$data)

  # extract last_updated, convert POSIX timestamp to date
  system_information_last_updated <- system_information$last_updated %>%
    as.POSIXct(., origin = "1970-01-01")

  # create directory
  if (!dir.exists(directory)) {
    dir.create(directory)
  }

  saveRDS(system_information_data, file = paste(directory, file, sep = "/"))

}

#' Save the system_pricing_plans feed.
#' 
#' \code{get_system_pricing_plans} saves the system_pricing_plans feed for a given city as a .rds object.
#' 
#' @param city A character string or a url to an active gbfs.json feed.
#' @param directory The name of an existing folder or folder to be created, where the feed will
#'   will be saved.
#' @param file The name of the file to be saved. Must end in .rds.
#' @return A .rds object generated from the current system_pricing_plans feed.
#' @examples
#' get_system_pricing_plans(city = "http://biketownpdx.socialbicycles.com/opendata/system_pricing_plans.json")
#' get_system_pricing_plans(city = "Houston")
#' @export

get_system_pricing_plans <- function(city, directory = "data", file = "system_pricing_plans.rds") {

  url <- city_to_url(city)
  
  if (url != city) {
    gbfs <- fromJSON(txt = url)
    gbfs_feeds <- gbfs$data$en$feeds
    if ("system_pricing_plans" %in% gbfs_feeds$name) {
      system_pricing_plans_feed <- gbfs_feeds %>%
        select(url) %>%
        filter(str_detect(url, "system_pricing_plans")) %>%
        as.character()
    }
  }
  else {
    system_pricing_plans_feed <- url
  }

  # save feed
  system_pricing_plans <- fromJSON(txt = system_pricing_plans_feed)

  # extract data, convert to df
  system_pricing_plans_data <- system_pricing_plans$data$plans

  # class columns
  system_pricing_plans_data$is_taxable <- as.logical(system_pricing_plans_data$is_taxable)

  # extract last_updated, convert POSIX timestamp to date
  system_pricing_plans_last_updated <- system_pricing_plans$last_updated %>%
    as.POSIXct(., origin = "1970-01-01")

  # create directory
  if (!dir.exists(directory)) {
    dir.create(directory)
  }

  saveRDS(system_pricing_plans_data, file = paste(directory, file, sep = "/"))

}

#' Save the system_regions feed.
#' 
#' \code{get_system_regions} saves the system_regions feed for a given city as a .rds object.
#' 
#' @param city A character string or a url to an active gbfs.json feed.
#' @param directory The name of an existing folder or folder to be created, where the feed will
#'   will be saved.
#' @param file The name of the file to be saved. Must end in .rds.
#' @return A .rds object generated from the current system_regions feed.
#' @examples
#' get_system_regions(city = "http://biketownpdx.socialbicycles.com/opendata/system_regions.json")
#' get_system_regions(city = "Boston")
#' @export

get_system_regions <- function (city, directory = "data", file = "system_regions.rds") {

  url <- city_to_url(city)
  
  if (url != city) {
    gbfs <- fromJSON(txt = url)
    gbfs_feeds <- gbfs$data$en$feeds
    if ("system_regions" %in% gbfs_feeds$name) {
      system_regions_feed <- gbfs_feeds %>%
        select(url) %>%
        filter(str_detect(url, "system_regions")) %>%
        as.character()
    }
  }
  else {
    system_regions_feed <- url
  }

  # save feed
  system_regions <- fromJSON(txt = system_regions_feed)

  # extract data, convert to df
  system_regions_data <- system_regions$data$regions

  # extract last_updated, convert POSIX timestamp to date
  system_regions_last_updated <- system_regions$last_updated %>%
    as.POSIXct(., origin = "1970-01-01")

  # create directory
  if (!dir.exists(directory)) {
    dir.create(directory)
  }

  saveRDS(system_regions_data, file = paste(directory, file, sep = "/"))

}
