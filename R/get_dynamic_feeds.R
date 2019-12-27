#' Grab the free_bike_status feed.
#' 
#' Grab a dataframe giving the geographic location and other metadata of
#' bikeshare bikes not parked at bikeshare stations. Metadata for this dataset
#' can be found at: \url{https://github.com/NABSA/gbfs/blob/master/gbfs.md}
#' 
#' @inheritParams get_station_information
#' 
#' @return The output of this function depends on argument to \code{output}
#' and \code{directory}. Either a saved .rds object generated from the current 
#' station_information feed, a dataframe object, or both. If a saved feed of
#' the same type already exists at the filepath, the feed will be appended to
#' rather than overwritten.
#' 
#' @examples
#' # we can grab the free bike status feed for portland, 
#' # oregon's bikeshare program in  several ways! the most 
#' # straightforward way is just to supply the `city` argument
#' # as a string:
#' \donttest{get_free_bike_status(city = "portland")}
#' 
#' # the `city` argument can also be supplied as an
#' # actual URL to an active .json feed
#' #' \donttest{get_free_bike_status(city = 
#' "http://biketownpdx.socialbicycles.com/opendata/free_bike_status.json",  
#'                      directory = tempdir())}
#' 
#' # if you'd like to save the output to file, supply a 
#' # `directory` argument. usually, though, we would supply a 
#' # character string (like "pdx", maybe,) for the `directory` 
#' # argument instead of `tempdir`.
#' \donttest{get_free_bike_status(city = "portland",  
#'                      directory = tempdir())}
#'                      
#' # the output argument can control whether the file is
#' # saved and/or returned explicitly
#' \donttest{get_free_bike_status(city = "portland",  
#'                      directory = tempdir(),
#'                      output = "both")}                     
#' 
#' @export
get_free_bike_status <- function(city, directory = NULL, file = "free_bike_status.rds", output = NULL) {

  get_gbfs_dataset_(city, directory, file, output, feed = "free_bike_status")
  
}

#' Grab the station_status feed.
#' 
#' Grab a dataframe giving the geographic location and other metadata of
#' bikeshare bikes parked at bikeshare stations. Metadata for this dataset
#' can be found at: \url{https://github.com/NABSA/gbfs/blob/master/gbfs.md}
#' 
#' @inheritParams get_station_information
#' 
#' @return The output of this function depends on argument to `output`: Either 
#' a saved .rds object generated from the current station_information feed, 
#' a dataframe object, or both.
#' 
#' @examples
#' # we can grab the station status feed for portland, 
#' # oregon's bikeshare program in  several ways! the most 
#' # straightforward way is just to supply the `city` argument
#' # as a string:
#' \donttest{get_station_status(city = "portland")}
#' 
#' # the `city` argument can also be supplied as an
#' # actual URL to an active .json feed
#' #' \donttest{get_station_status(city = 
#' "http://biketownpdx.socialbicycles.com/opendata/station_status.json",  
#'                      directory = tempdir())}
#' 
#' # if you'd like to save the output to file, supply a 
#' # `directory` argument. usually, though, we would supply a 
#' # character string (like "pdx", maybe,) for the `directory` 
#' # argument instead of `tempdir`.
#' \donttest{get_station_status(city = "portland",  
#'                      directory = tempdir())}
#'                      
#' # the output argument can control whether the file is
#' # saved and/or returned explicitly
#' \donttest{get_station_status(city = "portland",  
#'                      directory = tempdir(),
#'                      output = "both")} 
#' @export
get_station_status <- function(city, directory = NULL, file = "station_status.rds", output = NULL) {

  get_gbfs_dataset_(city, directory, file, output, feed = "station_status")
  
}
