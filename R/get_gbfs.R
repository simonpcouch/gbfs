#' Get table of all cities releasing GBFS feeds
#'
#' @return A \code{data.frame} of all cities issuing GBFS feeds. The `Auto-Discovery URL`
#' column supplies the relevant .json feeds, while the entries in the `URL` column 
#' take the user to the public-facing webpage of the programs.
#' @source North American Bikeshare Association, General Bikeshare Feed Specification
#'  \url{https://raw.githubusercontent.com/NABSA/gbfs/master/systems.csv}
#' @export
get_gbfs_cities <- function() {
  
  # test internet connection
  if (!connected_to_internet()) {
    return(message_no_internet())
  }
  
  # specify column types
  systems_cols <- readr::cols(
    `Country Code` = readr::col_character(),
    "Name" = readr::col_character(),
    "Location" = readr::col_character(),
    `System ID` = readr::col_character(),
    `URL` = readr::col_character(),
    `Auto-Discovery URL` = readr::col_character()
  )
  
  # grab the data
  readr::read_csv("https://raw.githubusercontent.com/NABSA/gbfs/master/systems.csv",
                  col_types = systems_cols)
}

  
  
#' Get dataframe of bikeshare feeds released by a city
#'
#' @description Of the different types of feeds supplied by the gbfs,
#' some are required, some are conditionally required, and some are
#' optional. This function grabs a list of each of the feeds supplied
#' by a given city, as well as the URLs to access them.
#' 
#' @param city A character string that can be matched to a gbfs feed. The recommended
#' argument is a system ID supplied in the output of [get_gbfs_cities()], but will
#' also attempt to match to the URL of an active .json feed or city name.
#'
#' @return A \code{data.frame} containing the feeds supplied by
#' a city. . The `feed` column supplies the name of the relevant .json feeds, 
#' while the entries in the `URL` column supply the feeds themselves.
#' 
#' @source North American Bikeshare Association, General Bikeshare Feed 
#' Specification \url{https://github.com/NABSA/gbfs/blob/master/gbfs.md}
#' 
#' @examples 
#' # grab all of the feeds released by portland
#' \donttest{get_which_gbfs_feeds(city = "biketown_pdx")}
#' 
#' @export
get_which_gbfs_feeds <- function(city) {
    
  # test internet connection
  if (!connected_to_internet()) {
    return(message_no_internet())
  }
  
  # convert the city argument to a URL
  url <- city_to_url(city, "gbfs")
    
  # grab the relevant data
  gbfs <- tryCatch(jsonlite::fromJSON(txt = url),
                   error = message_connection_issue)
  
  # pull out the dataset
  gbfs_feeds <- gbfs[["data"]][[1]][[1]]
    
  # ...and return it!
  return(gbfs_feeds)
    
}
  
#' Grab bikeshare data
#' 
#' \code{get_gbfs} grabs bikeshare data supplied in the General Bikeshare 
#' Feed Specification format for a given city. By default, the function returns
#' the results as a named list of dataframes, but to make accumulation of
#' datasets over time straightforward, the user can also save the results
#' as .Rds files that will be automatically row-binded.
#'  Metadata for each dataset can be found at:
#' \url{https://github.com/NABSA/gbfs/blob/master/gbfs.md}
#' 
#' @param city A character string that can be matched to a city or a url to an 
#' active gbfs.json feed. See \code{get_gbfs_cities} for a current list of available cities.
#' @param feeds Optional. A character string specifying which feeds should be saved. 
#' Options are \code{"all"}, \code{"static"}, and \code{"dynamic"}.
#' @param directory Optional. Path to a folder (or folder to be created) where 
#' the feed will will be saved. 
#' @param output Optional. The type of output method. By default, output method 
#' will be inferred from the \code{directory} argument. If \code{output = "save"}, 
#' the dataframes will be saved as .rds objects in the given folder. If 
#' \code{output = "return"}, the results will be returned as a named list of 
#' dataframes. Setting \code{output = "both"} will do both. If both are left
#' as NULL, the result will be returned and not saved to file.
#' @return The output of this function depends on the arguments supplied to 
#' \code{output} and \code{directory}. Either a folder of .rds dataframes saved
#' at the given path, a returned named list of dataframes, or both.
#' The function will raise an error if the \code{directory} and \code{output} 
#' arguments seem to conflict.
#' @examples
#' # grab all of the feeds released by portland's 
#' # bikeshare program and return them as a 
#' # named list of dataframes
#' \donttest{get_gbfs(city = "biketown_pdx")}
#' 
#' # if, rather than returning the data, we wanted to save it:
#' \donttest{get_gbfs(city = "biketown_pdx", directory = tempdir())}
#' 
#' # note that, usually, we'd supply a character string 
#' # (like "pdx", maybe,) to the directory argument 
#' # instead of `tempdir()`. 
#' 
#' # if we're having trouble specifying the correct feed,
#' # we can also supply the actual URL to the feed
#' \donttest{get_gbfs(city = "https://gbfs.biketownpdx.com/gbfs/gbfs.json")}
#'                    
#' # the examples above grab every feed that portland releases.
#' # if, instead, we just wanted the dynamic feeds
#' \donttest{get_gbfs(city = "biketown_pdx", feeds = "dynamic")}
#' @export
get_gbfs <- function(city, feeds = "all", directory = NULL, output = NULL) {

  # test internet connection
  if (!connected_to_internet()) {
    return(message_no_internet())
  }
  
  # check the "feeds" argument
  feeds <- process_feeds_argument(feeds)
  
  # figure out how to output the resulting object
  output_types <- determine_output_types(directory, output)
  
  # check that, if the user said to save the file, they also
  # supplied a directory
  if (output_types[1] & is.null(directory)) {
    stop(sprintf(c("The argument to output suggests that the resulting",
                   " data should be saved, but a directory to save the",
                   " outputs in hasn't been supplied. Please supply",
                   " an argument to directory or leave the output argument",
                   " as default.")))    
  }
  
  # convert the city argument to a top-level gbfs url
  url <- city_to_url(city, "gbfs")
  
  # figure out which feeds are available
  available_feeds <- get_which_gbfs_feeds(city = url)

  # ...and then figure out which of them to grab
  relevant_feeds <- available_feeds %>%
    dplyr::left_join(all_feeds, by = "name") %>%
    dplyr::filter(type %in% feeds) %>%
    dplyr::select(name) %>%
    dplyr::pull()
  
  # grab all of the relevant feeds! note that this will save each
  # of the datasets in the directory folder if directory is
  # something other than NULL
  data <- suppressMessages(
    purrr::map2(paste0(relevant_feeds, ".Rds"),
                relevant_feeds,
                get_gbfs_dataset_,
                city = url,
                directory = directory,
                output = NULL)
    )

  # name each of the elements so that they're more easily accessible
  names(data) <- relevant_feeds
  
  # output the datasets as desired :-)
  if (output_types[2]) {
    return(data)
  }
}

