#' Save the free_bike_status feed.
#' 
#' If the specified file does not exist, \code{get_free_bike_status} saves the free_bike_status
#' feed for a given city as a .rds object. If the specified file does exist, \code{get_free_bike_status}
#' appends the current free_bike_status feed to the existing file. Go to 
#' `https://github.com/NABSA/gbfs/blob/master/gbfs.md` to see metadata for this dataset.
#' 
#' @param city A character string or a url to an active gbfs.json feed.
#' @param directory The name of an existing folder or folder to be created, where the feed will
#'   will be saved.
#' @param file The name of an existing file or new file to be saved. Must end in .rds.
#' @return A .rds object generated from the current free_bike_status feed.
#' @examples
#' \donttest{get_free_bike_status(city = 
#' "http://biketownpdx.socialbicycles.com/opendata/free_bike_status.json")}
#' \donttest{get_free_bike_status(city = "Melbourne")}
#' @export

get_free_bike_status <- function(city, directory = "data", file = "free_bike_status.rds") {

  url <- city_to_url(city)
  
  if (url != city) {
    gbfs <- jsonlite::fromJSON(txt = url)
    gbfs_feeds <- gbfs$data$en$feeds
    if ("free_bike_status" %in% gbfs_feeds$name) {
      free_bike_status_feed <- gbfs_feeds %>%
        dplyr::select(url) %>%
        dplyr::filter(stringr::str_detect(url, "free_bike_status")) %>%
        as.character()
    }
  }
  else {
    free_bike_status_feed <- url
  }

  #save feed
  free_bike_status <- jsonlite::fromJSON(txt = free_bike_status_feed)

  #extract data, convert to df
  free_bike_status_data <- free_bike_status$data$bikes

  #class columns
  free_bike_status_data$is_reserved <- as.logical(free_bike_status_data$is_reserved)
  free_bike_status_data$is_disabled <- as.logical(free_bike_status_data$is_disabled)

  #extract last_updated, convert POSIX timestamp to date
  free_bike_status_last_updated <- free_bike_status$last_updated %>%
    as.POSIXct(., origin = "1970-01-01")

  #mutate columns for time of observation
  if (class(free_bike_status_data) == "data.frame") {
    free_bike_status_data <- free_bike_status_data %>%
      dplyr::mutate(last_updated = free_bike_status_last_updated) %>%
      dplyr::mutate(year = lubridate::year(last_updated),
             month = lubridate::month(last_updated),
             day = lubridate::day(last_updated),
             hour = lubridate::hour(last_updated),
             minute = lubridate::minute(last_updated))
  }

  # create directory
  if (!dir.exists(directory)) {
    dir.create(directory)
  }

  update_fbs <- function(filepath) {
    fbs <- readRDS(filepath)
    fbs_update <- rbind(free_bike_status_data, fbs)
    saveRDS(fbs_update, file = filepath)
  }

  if (file.exists(paste(directory, file, sep = "/"))) {
    update_fbs(paste(directory, file, sep = "/"))
  }

  else {
    saveRDS(free_bike_status_data, file = paste(directory, file, sep = "/"))
  }

}

#' Save the station_status feed.
#' 
#' If the specified file does not exist, \code{get_station_status} saves the station_status
#' feed for a given city as a .rds object. If the specified file does exist, \code{get_station_status}
#' appends the current station_status feed to the existing file. Go to 
#' `https://github.com/NABSA/gbfs/blob/master/gbfs.md` to see metadata for this dataset.
#' 
#' @param city A character string or a url to an active gbfs.json feed.
#' @param directory The name of an existing folder or folder to be created, where the feed will
#'   will be saved.
#' @param file The name of an existing file or new file to be saved. Must end in .rds.
#' @return A .rds object generated from the current station_status feed.
#' @examples
#' \donttest{get_station_status(city = 
#' "http://biketownpdx.socialbicycles.com/opendata/station_status.json")}
#' \donttest{get_station_status(city = "kansas city", directory = "kc_gbfs")}
#' @export

get_station_status <- function(city, directory = "data", file = "station_status.rds") {

  url <- city_to_url(city)
  
  if (url != city) {
    gbfs <- jsonlite::fromJSON(txt = url)
    gbfs_feeds <- gbfs$data$en$feeds
    station_status_feed <- gbfs_feeds %>%
      dplyr::select(url) %>%
      dplyr::filter(stringr::str_detect(url, "station_status")) %>%
      as.character()
  }
  else {
    station_status_feed <- url
  }

  #save feed
  station_status <- jsonlite::fromJSON(txt = station_status_feed)

  #extract data, convert to df
  station_status_data <- station_status$data$stations

  #class columns of station_status_data
  station_status_data$last_reported <- as.POSIXct(station_status_data$last_reported,
                                                  origin = "1970-01-01")
  if ("num_bikes_disabled" %in% colnames(station_status_data)) {
    station_status_data$num_bikes_disabled <- as.numeric(station_status_data$num_bikes_disabled)
  }
  if ("num_docks_disabled" %in% colnames(station_status_data)) {
    station_status_data$num_docks_disabled <- as.numeric(station_status_data$num_docks_disabled)
  }
  station_status_data$is_installed <- as.logical(station_status_data$is_installed)
  station_status_data$is_renting <- as.logical(station_status_data$is_renting)
  station_status_data$is_returning <- as.logical(station_status_data$is_returning)

  #rename last_reported to last_updated for consistency between datasets
  station_status_data <- station_status_data %>%
    dplyr::rename(last_updated = last_reported)

  #mutate more useful columns from last_updated
  station_status_data <- station_status_data %>%
    dplyr::mutate(year = lubridate::year(last_updated),
           month = lubridate::month(last_updated),
           day = lubridate::day(last_updated),
           hour = lubridate::hour(last_updated),
           minute = lubridate::minute(last_updated))

  # create directory
  if (!dir.exists(directory)) {
    dir.create(directory)
  }

  update_ss <- function(filepath) {
    ss <- readRDS(filepath)
    ss_update <- rbind(station_status_data, ss)
    saveRDS(ss_update, file = filepath)
  }

  if (file.exists(paste(directory, file, sep = "/"))) {
    update_ss(paste(directory, file, sep = "/"))
  }

  else {
    saveRDS(station_status_data, file = paste(directory, file, sep = "/"))
  }

}
