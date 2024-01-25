#' Grab the station_information feed.
#' 
#' \code{get_station_information} grabs and tidies the station_information feed for a given city. 
#' This dataset contains locations, capacity, and other information about bikeshare stations.
#' Metadata for this dataset can be found at: 
#' \url{https://github.com/NABSA/gbfs/blob/master/gbfs.md}
#' 
#' @param city A character string that can be matched to a gbfs feed. The recommended
#' argument is a system ID supplied in the output of [get_gbfs_cities()], but will
#' also attempt to match to the URL of an active .json feed or city name.
#' @param directory Optional. Path to a folder (or folder to be 
#' created) where the feed will be saved.
#' @param file Optional. The name of the file to be saved (if \code{output} 
#' is set to \code{"save"} or \code{"both"}), as a character string. 
#' Must end in \code{".rds"}.
#' @param output Optional. The type of output method. If left as default, this
#' argument is inferred from the \code{directory} argument. If 
#' \code{output = "save"}, the object will be saved as an .rds object at 
#' # the given path. If \code{output = "return"}, the output will be returned 
#' as a dataframe object. Setting \code{output = "both"} will do both.
#' 
#' @return The output of this function depends on argument to \code{output}
#' and \code{directory}. Either a saved .rds object generated from the current 
#' feed, a dataframe object, or both.
#' 
#' @seealso [get_gbfs()] for a wrapper to call each of the \code{get_feed}
#' functions, [get_gbfs_cities()] for a dataframe of cities releasing gbfs
#' functions, and [get_which_gbfs_feeds()] for a dataframe of which feeds
#' are released by a given city.
#' 
#' @examples
#' # grab the free bike status feed for portland, oreoon's bikeshare program 
#' \donttest{get_station_information(city = 
#' "https://gbfs.lyft.com/gbfs/1.1/pdx/en/station_information.json",  
#'                         output = "return")}
#' 
#' @export
get_station_information <- function(city, directory = NULL, file = "station_information.rds", output = NULL) {

  get_gbfs_dataset_(city, directory, file, output, feed = "station_information")
  
}

#' Grab the system_alerts feed.
#' 
#' \code{get_system_alerts} grabs and tidies the system_alerts feed for a given city. 
#' This feed informs users about changes to normal operation. Metadata for this 
#' dataset can be found at: \url{https://github.com/NABSA/gbfs/blob/master/gbfs.md}
#' 
#' @inherit get_station_information params return seealso 
#' 
#' @examples
#' # grab the system alerts feed for portland, oregon
#' \donttest{get_system_alerts(city = 
#' "https://gbfs.lyft.com/gbfs/1.1/pdx/en/system_alerts.json",  
#'                   output = "return")}
#'  
#' @export

get_system_alerts <- function (city, directory = NULL, file = "system_alerts.rds", output = NULL) {

  get_gbfs_dataset_(city, directory, file, output, feed = "system_alerts")
  
}

#' Grab the system_calendar feed.
#' 
#' \code{get_system_calendar} grabs and tidies the system_calendar feed 
#' for a given city. Metadata for this dataset can be found at: 
#' \url{https://github.com/NABSA/gbfs/blob/master/gbfs.md}
#' 
#' @inherit get_station_information params return seealso 
#' 
#' @examples
#' # grab the system calendar feed for portland, oregon
#' \donttest{get_system_calendar(city = 
#' "https://gbfs.lyft.com/gbfs/1.1/pdx/en/system_calendar.json",  
#'                     output = "return")}
#' 
#' 
#' @export

get_system_calendar <- function (city, directory = NULL, file = "system_calendar.rds", output = NULL) {

  get_gbfs_dataset_(city, directory, file, output, feed = "system_calendar")
  
}

#' Grab the system_hours feed.
#' 
#' \code{get_system_hours} grabs and tidies the system_hours 
#' feed for a given city. Metadata for this 
#' dataset can be found at: 
#' \url{https://github.com/NABSA/gbfs/blob/master/gbfs.md}
#' 
#' @inherit get_station_information params return seealso 
#' 
#' @examples
#' # grab the system hours feed for portland, oregon
#' \donttest{get_system_hours(city = 
#' "https://gbfs.lyft.com/gbfs/1.1/pdx/en/system_hours.json",  
#'                  output = "return")}
#' 
#' @export

get_system_hours <- function (city, directory = NULL, file = "system_hours.rds", output = NULL) {

  get_gbfs_dataset_(city, directory, file, output, feed = "system_hours")
  
}

#' Grab the system_information feed.
#' 
#' \code{get_system_information} grabs and tidies the system_information 
#' feed for a given city. Metadata for this dataset can be found at: 
#' \url{https://github.com/NABSA/gbfs/blob/master/gbfs.md}
#' 
#' @inherit get_station_information params return seealso 
#' 
#' @examples
#' # we can grab the free bike status feed for portland, 
#' # oregon's bikeshare program in  several ways! first, supply the `city` 
#' # argument as a URL, and save to file by leaving output 
#' # set to it's default. usually, we would supply a character 
#' # string (like "pdx", maybe,) for the `directory` argument 
#' # instead of `tempdir`.
#' \donttest{get_system_information(city = 
#' "https://gbfs.lyft.com/gbfs/1.1/pdx/en/system_information.json",  
#'                        directory = tempdir())}
#'                     
#' # or, instead, just supply the name of 
#' # the city as a string and return the output as a dataframe
#'\donttest{get_system_information(city = "biketown_pdx",  
#'                        output = "return")}
#' @export

get_system_information <- function(city, directory = NULL, file = "system_information.rds", output = NULL){

  get_gbfs_dataset_(city, directory, file, output, feed = "system_information")
    
}

#' Grab the system_pricing_plans feed.
#' 
#' \code{get_system_pricing_plans} grabs and tidies the system_pricing_plans 
#' feed for a given city. Metadata for this dataset can be found at: 
#' \url{https://github.com/NABSA/gbfs/blob/master/gbfs.md}
#' 
#' @inherit get_station_information params return seealso 
#' 
#' @export

get_system_pricing_plans <- function(city, directory = NULL, file = "system_pricing_plans.rds", output = NULL) {

  get_gbfs_dataset_(city, directory, file, output, feed = "system_pricing_plans")
  
}

#' Grab the system_regions feed.
#' 
#' \code{get_system_regions} grabs and tidies the system_regions feed for 
#' a given city.  Metadata for this dataset can be found at: 
#' \url{https://github.com/NABSA/gbfs/blob/master/gbfs.md}
#' 
#' @inherit get_station_information params return seealso 
#' 
#' @examples
#' # we can grab the system regions feed for portland, 
#' # oregon in one of several ways! first, supply the `city` 
#' # argument as a URL, and save to file by leaving output 
#' # set to it's default. usually, we would supply a character 
#' # string (like "pdx", maybe,) for the `directory` argument 
#' # instead of `tempdir`.
#' \donttest{get_system_regions(city = 
#' "https://gbfs.lyft.com/gbfs/1.1/pdx/en/system_regions.json",  
#'                    directory = tempdir())}
#'                     
#' # or, instead, just supply the name of 
#' # the city as a string and return the output
#' # as a dataframe
#'\donttest{get_system_regions(city = "biketown_pdx",  
#'                    output = "return")}
#' @export
get_system_regions <- function(city, directory = NULL, file = "system_regions.rds", output = NULL) {
  
  get_gbfs_dataset_(city, directory, file, output, feed = "system_regions")
  
}
