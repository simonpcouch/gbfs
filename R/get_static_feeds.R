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

  get_gbfs_dataset_(city, directory, file, output, feed = "station_information")
  
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

  get_gbfs_dataset_(city, directory, file, output, feed = "system_alerts")
  
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

  get_gbfs_dataset_(city, directory, file, output, feed = "system_calendar")
  
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

  get_gbfs_dataset_(city, directory, file, output, feed = "system_hours")
  
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

  get_gbfs_dataset_(city, directory, file, output, feed = "system_information")
    
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

  get_gbfs_dataset_(city, directory, file, output, feed = "system_pricing_plans")
  
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
get_system_regions <- function(city, directory = NULL, file = "system_regions.rds", output = NULL) {
  
  get_gbfs_dataset_(city, directory, file, output, feed = "system_regions")
  
}
