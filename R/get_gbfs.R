#' Get table of all cities releasing GBFS feeds
#'
#' @return A \code{data.frame} of all cities issuing GBFS feeds. The `Auto-Discovery URL`
#' column supplies the relevant .json feeds, while the entries in the `URL` column 
#' take the user to the public-facing webpage of the programs.
#' @source North American Bikeshare Association, General Bikeshare Feed Specification
#'  \url{https://raw.githubusercontent.com/NABSA/gbfs/master/systems.csv}
#' @export
  get_gbfs_cities <- function() {
  systems_cols <- readr::cols(
    `Country Code` = readr::col_character(),
    "Name" = readr::col_character(),
    "Location" = readr::col_character(),
    `System ID` = readr::col_character(),
    `URL` = readr::col_character(),
    `Auto-Discovery URL` = readr::col_character()
  )
  
  readr::read_csv("https://raw.githubusercontent.com/NABSA/gbfs/master/systems.csv",
                  col_types = systems_cols)
}

get_gbfs_feeds <- function(url) {

  gbfs <- jsonlite::fromJSON(txt = url)

  feeds <- gbfs$data$en$feeds

  stat_info_feed <- feeds %>%
    dplyr::select(url) %>%
    dplyr::filter(stringr::str_detect(url, "station_information")) %>%
    as.character()

  sys_info_feed <- feeds %>%
    dplyr::select(url) %>%
    dplyr::filter(stringr::str_detect(url, "system_information")) %>%
    as.character()

  stat_status_feed <- feeds %>%
    dplyr::select(url) %>%
    dplyr::filter(stringr::str_detect(url, "station_status")) %>%
    as.character()

  if ("free_bike_status" %in% feeds$name) {
    fbs_feed <- feeds %>%
      dplyr::select(url) %>%
      dplyr::filter(stringr::str_detect(url, "free_bike_status")) %>%
      as.character()
  }

  if ("system_hours" %in% feeds$name) {
    sys_hours_feed <- feeds %>%
      dplyr::select(url) %>%
      dplyr::filter(stringr::str_detect(url, "system_hours")) %>%
      as.character()
  }

  if ("system_calendar" %in% feeds$name) {
    sys_cal_feed <- feeds %>%
      dplyr::select(url) %>%
      dplyr::filter(stringr::str_detect(url, "system_calendar")) %>%
      as.character()
  }

  if ("system_regions" %in% feeds$name) {
    sys_reg_feed <- feeds %>%
      dplyr::select(url) %>%
      dplyr::filter(stringr::str_detect(url, "system_regions")) %>%
      as.character()
  }

  if ("system_pricing_plans" %in% feeds$name) {
    sys_price_feed <- feeds %>%
      dplyr::select(url) %>%
      dplyr::filter(stringr::str_detect(url, "system_pricing_plans")) %>%
      as.character()
  }

  if ("system_alerts" %in% feeds$name) {
    sys_alerts_feed <- feeds %>%
      dplyr::select(url) %>%
      dplyr::filter(stringr::str_detect(url, "system_alerts")) %>%
      as.character()
  }

}

#' Save gbfs feeds.
#' 
#' \code{get_gbfs} checks for the existence of General Bikeshare Specification
#' feeds for a given city and saves the feeds as .rds objects in a directory that
#' can be specified by the user. Metadata for each dataset can be found at:
#' `https://github.com/NABSA/gbfs/blob/master/gbfs.md`
#' 
#' @param city A character string that can be matched to a city or a url to an 
#' active gbfs.json feed. See \code{get_gbfs_cities} for a current list of available cities.
#' @param feeds A character string specifying which feeds should be saved. Options are
#'   \code{"all"}, \code{"static"}, and \code{"dynamic"}.
#' @param directory The name of an existing folder or folder to be created, where the feeds
#'   will be saved.
#' @return A folder containing the specified feeds saved as .rds objects.
#' 
#' @examples
#' # to grab all of the feeds released by portland, oregon's
#' # bikeshare program "biketown",
#' \donttest{get_gbfs(city = "portland", directory = tempdir())}
#' 
#' # note that, usually, we'd supply a character string 
#' # (like "pdx", maybe,) to the directory argument 
#' # instead of `tempdir()`. 
#' 
#' # if we're having trouble specifying the correct feed,
#' # we can also supply the actual URL to the feed
#' \donttest{get_gbfs(city = "http://biketownpdx.socialbicycles.com/opendata/gbfs.json", 
#'          directory = tempdir())}
#'                    
#' # the examples above grab every feed that portland releases.
#' # if, instead, we just wanted the dynamic feeds,
#' \donttest{get_gbfs(city = "portland", 
#'          directory = tempdir(),
#'          feeds = "dynamic")}
#' @export

get_gbfs <- function(city, feeds = "all", directory) {

  url <- city_to_url(city, "gbfs")

  gbfs <- jsonlite::fromJSON(txt = url)

  gbfs_feeds <- gbfs$data$en$feeds

# get feeds
  stat_info_feed <- gbfs_feeds %>%
    dplyr::select(url) %>%
    dplyr::filter(stringr::str_detect(url, "station_information")) %>%
    as.character()

  sys_info_feed <- gbfs_feeds %>%
    dplyr::select(url) %>%
    dplyr::filter(stringr::str_detect(url, "system_information")) %>%
    as.character()

  stat_status_feed <- gbfs_feeds %>%
    dplyr::select(url) %>%
    dplyr::filter(stringr::str_detect(url, "station_status")) %>%
    as.character()

  if ("free_bike_status" %in% gbfs_feeds$name) {
    fbs_feed <- gbfs_feeds %>%
      dplyr::select(url) %>%
      dplyr::filter(stringr::str_detect(url, "free_bike_status")) %>%
      as.character()
  }

  if ("system_hours" %in% gbfs_feeds$name) {
    sys_hours_feed <- gbfs_feeds %>%
      dplyr::select(url) %>%
      dplyr::filter(stringr::str_detect(url, "system_hours")) %>%
      as.character()
  }

  if ("system_calendar" %in% gbfs_feeds$name) {
    sys_cal_feed <- gbfs_feeds %>%
      dplyr::select(url) %>%
      dplyr::filter(stringr::str_detect(url, "system_calendar")) %>%
      as.character()
  }

  if ("system_regions" %in% gbfs_feeds$name) {
    sys_reg_feed <- gbfs_feeds %>%
      dplyr::select(url) %>%
      dplyr::filter(stringr::str_detect(url, "system_regions")) %>%
      as.character()
  }

  if ("system_pricing_plans" %in% gbfs_feeds$name) {
    sys_price_feed <- gbfs_feeds %>%
      dplyr::select(url) %>%
      dplyr::filter(stringr::str_detect(url, "system_pricing_plans")) %>%
      as.character()
  }

  if ("system_alerts" %in% gbfs_feeds$name) {
    sys_alerts_feed <- gbfs_feeds %>%
      dplyr::select(url) %>%
      dplyr::filter(stringr::str_detect(url, "system_alerts")) %>%
      as.character()
  }
  
# create directory
if (!dir.exists(directory)) {
  dir.create(directory)
}

# call functions
  if (feeds == "all" | feeds == "static") {
    get_station_information(stat_info_feed, directory = directory)
    get_system_information(sys_info_feed, directory = directory)
    if (exists("sys_hours_feed")) {
      get_system_hours(sys_hours_feed, directory = directory)
    }
    if (exists("sys_cal_feed")) {
      get_system_calendar(sys_cal_feed, directory = directory)
    }
    if (exists("sys_reg_feed")) {
      get_system_regions(sys_reg_feed, directory = directory)
    }
    if (exists("sys_price_feed")) {
      get_system_pricing_plans(sys_price_feed, directory = directory)
    }
    if (exists("sys_alerts_feed")) {
      get_system_alerts(sys_alerts_feed, directory = directory)
    }
  }

  if (feeds == "all" | feeds == "dynamic") {
    get_station_status(stat_status_feed, directory = directory)
    if (exists("fbs_feed")) {
      get_free_bike_status(fbs_feed, directory = directory)
    }
  }

}
