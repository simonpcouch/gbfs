#' Grab the free_bike_status feed.
#' 
#' If the specified file does not exist, \code{get_free_bike_status} saves the free_bike_status
#' feed for a given city as a .rds object. If the specified file does exist, \code{get_free_bike_status}
#' appends the current free_bike_status feed to the existing file. The resulting dataframe can
#' alternatively be returned (rather than saved) using the `output` argument. Go to 
#' `https://github.com/NABSA/gbfs/blob/master/gbfs.md` to see metadata for this dataset.
#' 
#' @param city A character string or a url to an active gbfs.json feed. See \code{get_gbfs_cities}
#' for a current list of available cities.
#' @param directory The name of an existing folder or folder to be created, where the feed will
#'   will be saved. This argument is only required if `output = "save"` (the default option.)
#'   If `output = "return"`, this argument will be ignored.
#' @param file Name of an existing file or a new file to be saved. Must end in .rds.
#'   This argument will be ignored if `output = "return"`.
#' @param output The type of output method. If `output = "save"`, the object will be saved as
#' an .rds object at the given path. If `output = "return"`, the output will be returned
#' as a dataframe object. Setting `output = "both"` will do both.
#' @return The output of the function depends on argument to `output`: Either a 
#' saved .rds object generated from the current station_information feed, a 
#' dataframe object, or both.
#' @examples
#' # we can grab the free bike status feed for portland, 
#' # oregon in one of several ways! first, supply the `city` 
#' # argument as a URL, and save to file by leaving output 
#' # set to it's default. usually, we would supply a character 
#' # string (like "pdx", maybe,) for the `directory` argument 
#' # instead of `tempdir`.
#' \donttest{get_free_bike_status(city = "http://biketownpdx.socialbicycles.com/opendata/free_bike_status.json",  
#'                      directory = tempdir())}
#'                     
#' # or, instead, just supply the name of 
#' # the city as a string. 
#'\donttest{get_free_bike_status(city = "portland",
#'                      directory = tempdir())}
#'                     
#' # instead of saving the output as a file, we can 
#' # just return the output as a dataframe
#' \donttest{get_free_bike_status(city = "portland",  
#'                      output = "return")}
#' @export
get_free_bike_status <- function(city, directory = NULL, file = "free_bike_status.rds", output = NULL) {

  get_gbfs_dataset_(city, directory, file, output, feed = "free_bike_status")
  
}

#' Grab the station_status feed.
#' 
#' If the specified file does not exist, \code{get_station_status} saves the station_status
#' feed for a given city as a .rds object. If the specified file does exist, \code{get_station_status}
#' appends the new rows from the current station_status feed to the existing file. Go to 
#' `https://github.com/NABSA/gbfs/blob/master/gbfs.md` to see metadata for this dataset.
#' 
#' @param city A character string or a url to an active gbfs.json feed. See \code{get_gbfs_cities}
#' for a current list of available cities.
#' @param directory The name of an existing folder or folder to be created, where the feed will
#'   will be saved. This argument is only required if `output = "save"` (the default option.)
#'   This argument will be ignored, if `output = "return"`
#' @param file Name of an existing file or a new file to be saved. Must end in .rds.
#'   This argument will be ignored if `output = "return"`.
#' @param output The type of output method. If `output = "save"`, the object will be saved as
#' an .rds object at the given path. If `output = "return"`, the output will be returned
#' as a dataframe object. Setting `output = "both"` will do both.
#' @return The output of this function depends on argument to `output`: Either 
#' a saved .rds object generated from the current station_information feed, 
#' a dataframe object, or both.
#' @examples
#' # we can grab the station status feed for portland, 
#' # oregon in one of several ways! first, supply the `city` 
#' # argument as a URL, and save to file by leaving output 
#' # set to it's default. usually, we would supply a character 
#' # string (like "pdx", maybe,) for the `directory` argument 
#' # instead of `tempdir`.
#' \donttest{get_station_status(city = "http://biketownpdx.socialbicycles.com/opendata/station_status.json",  
#'                    directory = tempdir())}
#'                     
#' # or, instead, just supply the name of 
#' # the city as a string. 
#'\donttest{get_station_status(city = "portland",
#'                    directory = tempdir())}
#'                     
#' # instead of saving the output as a file, we can 
#' # just return the output as a dataframe
#' \donttest{get_station_status(city = "portland",  
#'                    output = "return")}
#' @export
get_station_status <- function(city, directory = NULL, file = "station_status.rds", output = NULL) {

  get_gbfs_dataset_(city, directory, file, output, feed = "station_status")
  
}
