#' Grab the station_information feed.
#' 
#' \code{get_station_information} grabs and tidies the station_information feed for a given city. 
#' This dataset contains locations, capacity, and other information about bikeshare stations.
#' Go to `https://github.com/NABSA/gbfs/blob/master/gbfs.md` to see metadata for this dataset.
#' 
#' @param city A character string that can be matched to a city or a url to an active 
#' gbfs .json feed. See \code{get_gbfs_cities} for a current list of available cities.
#' @param directory The name of an existing folder or folder to be created, where 
#' the feed will will be saved. This argument is not required if \code{output = "return"}.
#' @param file The name of the file to be saved (if \code{output} is set to \code{"save"} 
#' or \code{"both"}), as a character string. Must end in \code{".rds"}.
#' @param output The type of output method. If \code{output = "save"}, the object 
#' will be saved as an .rds object at the given path. If \code{output = "return"}, 
#' the output will be returned as a dataframe object. Setting 
#' \code{output = "both"} will do both.
#' @return The output of this function depends on argument to \code{output}. 
#' Either a saved .rds object generated from the current station_information 
#' feed, a dataframe object, or both.
#' @examples
#' # we can grab the station information feed for portland, 
#' # oregon in one of several ways! first, supply the `city` 
#' # argument as a URL, and save to file by leaving output 
#' # set to it's default. usually, we would supply a character 
#' # string (like "pdx", maybe,) for the `directory` argument 
#' # instead of `tempdir`.
#' \donttest{get_station_information(city = "http://biketownpdx.socialbicycles.com/opendata/system_alerts.json",  
#'                         directory = tempdir())}
#'                     
#' # or, instead, just supply the name of 
#' # the city as a string. 
#'\donttest{get_station_information(city = "portland",
#'                         directory = tempdir())}
#'                     
#' # instead of saving the output as a file, we can 
#' # just return the output as a dataframe
#' \donttest{get_station_information(city = "portland",  
#'                         output = "return")}
#' @export
get_station_information <- function(city, directory = NULL, file = "station_information.rds", output = NULL) {

  check_return_arguments(directory_ = directory,
                         file_ = file,
                         output_ = output)
  
  if (is.null(output)) {
    output <- "null"
  }
  
  url <- city_to_url(city)
  
  if (url != city) {
    gbfs <- jsonlite::fromJSON(txt = url)
    gbfs_feeds <- gbfs$data$en$feeds
    station_information_feed <- gbfs_feeds %>%
      dplyr::select(url) %>%
      dplyr::filter(stringr::str_detect(url, "station_information")) %>%
      as.character()
  }
  else {
    station_information_feed <- url
  }

  #save feed
  station_information <- jsonlite::fromJSON(txt = station_information_feed)

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
  
  if (output %in% c("save", "both")) {
  # create directory
  if (!dir.exists(directory)) {
    dir.create(directory)
  }

  #save() results in a smaller file size and allows for easier `rbind`ing than write_csv()
  #write_csv(x = station_information_data, path = "data-raw/station_information.csv")
  saveRDS(station_information_data, file = paste(directory, file, sep = "/"))
  } 
  
  if (output %in% c("return", "both", "null")) {
    station_information_data
  }
}

#' Grab the system_alerts feed.
#' 
#' \code{get_system_alerts} grabs and tidies the system_alerts feed for a given city. 
#' This feed informs users about changes to normal operation. Go to 
#' `https://github.com/NABSA/gbfs/blob/master/gbfs.md` to see metadata for this dataset.
#' 
#' @param city A character string that can be matched to a city or a url to an 
#' active gbfs .json feed. See \code{get_gbfs_cities} for a current list of available cities.
#' @param directory The name of an existing folder or folder to be created, where the feed will
#'   will be saved. This argument is ignored if \code{output = "return"}.
#' @param file The name of the file to be saved (if \code{output} is set to \code{"save"} 
#' or \code{"both"}), as a character string. Must end in \code{".rds"}. 
#' @param output The type of output method. If \code{output = "save"}, the object will be saved as
#' an .rds object at the given path. If \code{output = "return"}, the output will be returned
#' as a dataframe object. Setting \code{output = "both"} will do both.
#' @return Depends on argument to \code{output}: Either a saved .rds object generated from the 
#' current system_alerts feed, a dataframe object, or both.
#' @examples
#' # we can grab the system alerts feed for portland, 
#' # oregon in one of several ways! first, supply the `city` 
#' # argument as a URL, and save to file by leaving output 
#' # set to it's default. usually, we would supply a character 
#' # string (like "pdx", maybe,) for the `directory` argument 
#' # instead of `tempdir`.
#' \donttest{get_system_alerts(city = "http://biketownpdx.socialbicycles.com/opendata/system_alerts.json",  
#'                   directory = tempdir())}
#'                     
#' # or, instead, just supply the name of 
#' # the city as a string. 
#'\donttest{get_system_alerts(city = "portland",
#'                   directory = tempdir())}
#'                     
#' # instead of saving the output as a file, we can 
#' # just return the output as a dataframe
#' \donttest{get_system_alerts(city = "portland",  
#'                   output = "return")}
#' @export

get_system_alerts <- function (city, directory = NULL, file = "system_alerts.rds", output = NULL) {

  check_return_arguments(directory_ = directory,
                         file_ = file,
                         output_ = output)
  
  if (is.null(output)) {
    output <- "null"
  }
  
  url <- city_to_url(city)
  
  if (url != city) {
    gbfs <- jsonlite::fromJSON(txt = url)
    gbfs_feeds <- gbfs$data$en$feeds
    if ("system_alerts" %in% gbfs_feeds$name) {
      system_alerts_feed <- gbfs_feeds %>%
        dplyr::select(url) %>%
        dplyr::filter(stringr::str_detect(url, "system_alerts")) %>%
        as.character()
    }
  }
  else {
    system_alerts_feed <- url
  }

  # save feed
  system_alerts <- jsonlite::fromJSON(txt = system_alerts_feed)

  # extract data, convert to df
  system_alerts_data <- system_alerts$data$alerts

  # extract last_updated, convert POSIX timestamp to date
  system_alerts_last_updated <- system_alerts$last_updated %>%
    as.POSIXct(., origin = "1970-01-01")
  
  
  if (output %in% c("save", "both")) {
  # create directory
  if (!dir.exists(directory)) {
    dir.create(directory)
  }

  saveRDS(system_alerts_data, file = paste(directory, file, sep = "/"))
  }
  if (output %in% c("return", "both", "null")) {
    system_alerts_data
  }
}

#' Grab the system_calendar feed.
#' 
#' \code{get_system_calendar} grabs and tidies the system_calendar feed for a given city. See
#' `https://github.com/NABSA/gbfs/blob/master/gbfs.md` to see metadata for this dataset.
#' 
#' @param city A character string that can be matched to a city or a url to an 
#' active gbfs .json feed. See \code{get_gbfs_cities} for a current list of available cities.
#' @param directory The name of an existing folder or folder to be created, where the feed will
#'   will be saved. This argument is ignored if \code{output = "return"}.
#' @param file The name of the file to be saved (if \code{output} is set to \code{"save"} 
#' or \code{"both"}), as a character string. Must end in \code{".rds"}.
#' @param output The type of output method. If `output = "save"`, the object will be saved as
#' an .rds object at the given path. If `output = "return"`, the output will be returned
#' as a dataframe object. Setting `output = "both"` will do both.
#' @return The output of this function depends on the argument to `output`: 
#' Either a saved .rds object generated from the 
#' current system_calendar feed, a dataframe object, or both
#' @examples
#' # we can grab the system calendar feed for portland, 
#' # oregon in one of several ways! first, supply the `city` 
#' # argument as a URL, and save to file by leaving output 
#' # set to it's default. usually, we would supply a character 
#' # string (like "pdx", maybe,) for the `directory` argument 
#' # instead of `tempdir`.
#' \donttest{get_system_calendar(city = "http://biketownpdx.socialbicycles.com/opendata/system_calendar.json",  
#'                     directory = tempdir())}
#'                     
#' # or, instead, just supply the name of 
#' # the city as a string. 
#'\donttest{get_system_calendar(city = "portland",
#'                     directory = tempdir())}
#'                     
#' # instead of saving the output as a file, we can 
#' # just return the output as a dataframe
#' \donttest{get_system_calendar(city = "portland",  
#'                     output = "return")}
#' @export

get_system_calendar <- function (city, directory = NULL, file = "system_calendar.rds", output = NULL) {

  check_return_arguments(directory_ = directory,
                         file_ = file,
                         output_ = output)
  
  if (is.null(output)) {
    output <- "null"
  }
  
  url <- city_to_url(city)
  
  if (url != city) {
    gbfs <- jsonlite::fromJSON(txt = url)
    gbfs_feeds <- gbfs$data$en$feeds
    if ("system_calendar" %in% gbfs_feeds$name) {
      system_calendar_feed <- gbfs_feeds %>%
        dplyr::select(url) %>%
        dplyr::filter(stringr::str_detect(url, "system_calendar")) %>%
        as.character()
    }
  }
  else {
    system_calendar_feed <- url
  }

  # save feed
  system_calendar <- jsonlite::fromJSON(txt = system_calendar_feed)

  # extract data, convert to df
  system_calendar_data <- system_calendar$data$calendars

  # extract last_updated, convert POSIX timestamp to date
  system_calendar_last_updated <- system_calendar$last_updated %>%
    as.POSIXct(., origin = "1970-01-01")

  # extract time til next update (in seconds), convert to numeric
  system_calendar_ttl <- system_calendar$ttl %>%
    as.numeric()
  
  if (output %in% c("save", "both")) {
  # create directory
  if (!dir.exists(directory)) {
    dir.create(directory)
  }

  saveRDS(system_calendar_data, file = paste(directory, file, sep = "/"))
  }
  
  if (output %in% c("return", "both", "null")) {
    system_calendar_data
  }
}

#' Grab the system_hours feed.
#' 
#' \code{get_system_hours} grabs and tidies the system_hours feed for a given city. Go to 
#' `https://github.com/NABSA/gbfs/blob/master/gbfs.md` to see metadata for this dataset.
#' 
#' @param city A character string that can be matched to a city or a url to an 
#' active gbfs .json feed. See \code{get_gbfs_cities} for a current list of available cities.
#' @param directory The name of an existing folder or folder to be created, where the feed will
#'   will be saved. This argument will be ignored if \code{output = "return"}. 
#' @param file The name of the file to be saved (if \code{output} is set to \code{"save"} 
#' or \code{"both"}), as a character string. Must end in \code{".rds"}. 
#' @param output The type of output method. If \code{output = "save"}, the object will be saved as
#' an .rds object at the given path. If \code{output = "return"}, the output will be returned
#' as a dataframe object. Setting \code{output = "both"} will do both.
#' @return Depends on argument to \code{output}: Either a saved .rds object generated from the 
#' current system_hours feed, a dataframe object, or both.
#' @examples
#' # we can grab the system hours feed for portland, 
#' # oregon in one of several ways! first, supply the `city` 
#' # argument as a URL, and save to file by leaving output 
#' # set to it's default. usually, we would supply a character 
#' # string (like "pdx", maybe,) for the `directory` argument 
#' # instead of `tempdir`.
#' \donttest{get_system_hours(city = "http://biketownpdx.socialbicycles.com/opendata/system_hours.json",  
#'                  directory = tempdir())}
#'                     
#' # or, instead, just supply the name of 
#' # the city as a string. 
#'\donttest{get_system_hours(city = "portland",
#'                  directory = tempdir())}
#'                     
#' # instead of saving the output as a file, we can 
#' # just return the output as a dataframe
#' \donttest{get_system_hours(city = "portland",  
#'                  output = "return")}
#' @export

get_system_hours <- function (city, directory = NULL, file = "system_hours.rds", output = NULL) {

  check_return_arguments(directory_ = directory,
                         file_ = file,
                         output_ = output)
  
  if (is.null(output)) {
    output <- "null"
  }
  
  url <- city_to_url(city)
  
  if (url != city) {
    gbfs <- jsonlite::fromJSON(txt = url)
    gbfs_feeds <- gbfs$data$en$feeds
    if ("system_hours" %in% gbfs_feeds$name) {
      system_hours_feed <- gbfs_feeds %>%
        dplyr::select(url) %>%
        dplyr::filter(stringr::str_detect(url, "system_hours")) %>%
        as.character()
    }
  }
  else {
    system_hours_feed <- url
  }

  # save feed
  system_hours <- jsonlite::fromJSON(txt = system_hours_feed)

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

  
  if (output %in% c("save", "both")) {
  # create directory
  if (!dir.exists(directory)) {
    dir.create(directory)
  }
  
  saveRDS(system_hours_data, file = paste(directory, file, sep = "/"))
  }
  
  if (output %in% c("return", "both", "null")) {
   system_hours_data 
  }
  
}

#' Grab the system_information feed.
#' 
#' \code{get_system_information} grabs and tidies the system_information feed for a given city. Go to 
#' `https://github.com/NABSA/gbfs/blob/master/gbfs.md` to see metadata for this dataset.
#' 
#' @param city A character string that can be matched to a city or a url to an 
#' active gbfs .json feed. See \code{get_gbfs_cities} for a current list of available cities.
#' @param directory The name of an existing folder or folder to be created, where the feed will
#'   will be saved. This argument will be ignored if \code{output = "return"}. 
#' @param file The name of the file to be saved (if \code{output} is set to \code{"save"} 
#' or \code{"both"}), as a character string. Must end in \code{".rds"}.
#' @param output The type of output method. If \code{output = "save"}, the object will be saved as
#' an .rds object at the given path. If \code{output = "return"}, the output will be returned
#' as a dataframe object. Setting \code{output = "both"} will do both.
#' @return Depends on argument to \code{output}: Either a saved .rds object generated from the 
#' current system_infromation feed, a dataframe object, or both.
#' @examples
#' # we can grab the system information feed for portland, 
#' # oregon in one of several ways! first, supply the `city` 
#' # argument as a URL, and save to file by leaving output 
#' # set to it's default. usually, we would supply a character 
#' # string (like "pdx", maybe,) for the `directory` argument 
#' # instead of `tempdir`.
#' \donttest{get_system_information(city = "http://biketownpdx.socialbicycles.com/opendata/system_information.json",  
#'                        directory = tempdir())}
#'                     
#' # or, instead, just supply the name of 
#' # the city as a string. 
#'\donttest{get_system_information(city = "portland",
#'                        directory = tempdir())}
#'                     
#' # instead of saving the output as a file, we can 
#' # just return the output as a dataframe
#' \donttest{get_system_information(city = "portland",  
#'                        output = "return")}
#' @export

get_system_information <- function(city, directory = NULL, file = "system_information.rds", output = NULL){

  check_return_arguments(directory_ = directory,
                         file_ = file,
                         output_ = output)
  
  if (is.null(output)) {
    output <- "null"
  }
  
  url <- city_to_url(city)
  
  if (url != city) {
    gbfs <- jsonlite::fromJSON(txt = url)
    gbfs_feeds <- gbfs$data$en$feeds
    system_information_feed <- gbfs_feeds %>%
      dplyr::select(url) %>%
      dplyr::filter(stringr::str_detect(url, "system_information")) %>%
      as.character()
  } else {
    system_information_feed <- url
  }

  # save feed
  system_information <- jsonlite::fromJSON(txt = system_information_feed)

  # some systems leave purchase URL null rather than missing
  if (is.null(system_information$data$purchase_url)) {
    system_information$data$purchase_url <- NA
  }
  
  # extract data, convert to df
  system_information_data <- as.data.frame(system_information$data)

  # extract last_updated, convert POSIX timestamp to date
  system_information_last_updated <- system_information$last_updated %>%
    as.POSIXct(., origin = "1970-01-01")

  if (output %in% c("save", "both")) {
  # create directory
  if (!dir.exists(directory)) {
    dir.create(directory)
  }

  saveRDS(system_information_data, file = paste(directory, file, sep = "/"))
  }
  
  if (output %in% c("return", "both", "null")) {
    system_information_data
  }
    
}

#' Grab the system_pricing_plans feed.
#' 
#' \code{get_system_pricing_plans} grabs and tidies the system_pricing_plans feed for a given city. Go to 
#' `https://github.com/NABSA/gbfs/blob/master/gbfs.md` to see metadata for this dataset.
#' 
#' @param city A character string that can be matched to a city or a url to an 
#' active gbfs .json feed. See \code{get_gbfs_cities} for a current list of available cities.
#' @param directory The name of an existing folder or folder to be created, where the feed will
#'   will be saved. This argument will be ignored if \code{output = "return"}.
#' @param file The name of the file to be saved (if \code{output} is set to \code{"save"} 
#' or \code{"both"}), as a character string. Must end in \code{".rds"}.
#' @param output The type of output method. If \code{output = "save"}, the object will be saved as
#' an .rds object at the given path. If \code{output = "return"}, the output will be returned
#' as a dataframe object. Setting \code{output = "both"} will do both.
#' @return The output of this function depends on the argument to `output`: 
#' Either a saved .rds object generated from the 
#' current system_pricing_plans feed, a dataframe object, or both.
#' @examples
#' # we can grab the system pricing plans feed for portland, 
#' # oregon in one of several ways! first, supply the `city` 
#' # argument as a URL, and save to file by leaving output 
#' # set to it's default. usually, we would supply a character 
#' # string (like "pdx", maybe,) for the `directory` argument 
#' # instead of `tempdir`.
#' \donttest{get_system_pricing_plans(city = "http://biketownpdx.socialbicycles.com/opendata/system_pricing_plans.json",  
#'                          directory = tempdir())}
#'                     
#' # or, instead, just supply the name of 
#' # the city as a string. 
#'\donttest{get_system_pricing_plans(city = "portland",
#'                          directory = tempdir())}
#'                     
#' # instead of saving the output as a file, we can 
#' # just return the output as a dataframe
#' \donttest{get_system_pricing_plans(city = "portland",  
#'                          output = "return")}
#' @export

get_system_pricing_plans <- function(city, directory = NULL, file = "system_pricing_plans.rds", output = NULL) {

  check_return_arguments(directory_ = directory,
                         file_ = file,
                         output_ = output) 
  
  if (is.null(output)) {
    output <- "null"
  }
  
  url <- city_to_url(city)
  
  if (url != city) {
    gbfs <- jsonlite::fromJSON(txt = url)
    gbfs_feeds <- gbfs$data$en$feeds
    if ("system_pricing_plans" %in% gbfs_feeds$name) {
      system_pricing_plans_feed <- gbfs_feeds %>%
        dplyr::select(url) %>%
        dplyr::filter(stringr::str_detect(url, "system_pricing_plans")) %>%
        as.character()
    }
  }
  else {
    system_pricing_plans_feed <- url
  }

  # save feed
  system_pricing_plans <- jsonlite::fromJSON(txt = system_pricing_plans_feed)

  # extract data, convert to df
  system_pricing_plans_data <- system_pricing_plans$data$plans

  # class columns
  system_pricing_plans_data$is_taxable <- as.logical(system_pricing_plans_data$is_taxable)

  # extract last_updated, convert POSIX timestamp to date
  system_pricing_plans_last_updated <- system_pricing_plans$last_updated %>%
    as.POSIXct(., origin = "1970-01-01")

  if (output %in% c("save", "both")) {
  # create directory
  if (!dir.exists(directory)) {
    dir.create(directory)
  }

  saveRDS(system_pricing_plans_data, file = paste(directory, file, sep = "/"))
  }
  
  if (output %in% c("return", "both", "null")) {
    system_pricing_plans_data 
  }
}

#' Grab the system_regions feed.
#' 
#' \code{get_system_regions} grabs and tidies the system_regions feed for a given city. Go to 
#' `https://github.com/NABSA/gbfs/blob/master/gbfs.md` to see metadata for this dataset.
#' 
#' @param city A character string that can be matched to a city or a url to an 
#' active gbfs .json feed. See \code{get_gbfs_cities} for a current list of available cities.
#' @param directory The name of an existing folder or folder to be created, where the feed will
#'   will be saved. This argument is ignored if \code{output = "return"}
#' @param file The name of the file to be saved (if \code{output} is set to \code{"save"} 
#' or \code{"both"}), as a character string. Must end in \code{".rds"}.
#' @param output The type of output method. If \code{output = "save"}, the object will be saved as
#' an .rds object at the given path. If \code{output = "return"}, the output will be returned
#' as a dataframe object. Setting \code{output = "both"} will do both.
#' @return The output of this function depends on the argument to 
#' \code{output}: Either a saved .rds object generated from the 
#' current system_regions feed, a dataframe object, or both.
#' @examples
#' # we can grab the system regions feed for portland, 
#' # oregon in one of several ways! first, supply the `city` 
#' # argument as a URL, and save to file by leaving output 
#' # set to it's default. usually, we would supply a character 
#' # string (like "pdx", maybe,) for the `directory` argument 
#' # instead of `tempdir`.
#' \donttest{get_system_regions(city = "http://biketownpdx.socialbicycles.com/opendata/system_regions.json",  
#'                    directory = tempdir())}
#'                     
#' # or, instead, just supply the name of 
#' # the city as a string. 
#'\donttest{get_system_regions(city = "portland",
#'                    directory = tempdir())}
#'                     
#' # instead of saving the output as a file, we can 
#' # just return the output as a dataframe
#' \donttest{get_system_regions(city = "portland",  
#'                    output = "return")}
#' @export

get_system_regions <- function (city, directory = NULL, file = "system_regions.rds", output = NULL) {

  check_return_arguments(directory_ = directory,
                         file_ = file,
                         output_ = output) 
  
  if (is.null(output)) {
    output <- "null"
  }
  
  url <- city_to_url(city)
  
  if (url != city) {
    gbfs <- jsonlite::fromJSON(txt = url)
    gbfs_feeds <- gbfs$data$en$feeds
    if ("system_regions" %in% gbfs_feeds$name) {
      system_regions_feed <- gbfs_feeds %>%
        dplyr::select(url) %>%
        dplyr::filter(stringr::str_detect(url, "system_regions")) %>%
        as.character()
    }
  } else {
    system_regions_feed <- url
  }

  # save feed
  system_regions <- jsonlite::fromJSON(txt = system_regions_feed)

  # extract data, convert to df
  system_regions_data <- system_regions$data$regions

  # extract last_updated, convert POSIX timestamp to date
  system_regions_last_updated <- system_regions$last_updated %>%
    as.POSIXct(., origin = "1970-01-01")

  if (output %in% c("save", "both")) {
  # create directory
  if (!dir.exists(directory)) {
    dir.create(directory)
  }

  saveRDS(system_regions_data, file = paste(directory, file, sep = "/"))
  }
  
  if (output %in% c("return", "both", "null")) {
    system_regions_data 
  }
}
