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

#' Grab bikeshare data
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
get_gbfs <- function(city, feeds = "all", directory = NULL, output = NULL) {

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

  # if there aren't any feeds left, raise an error
  if (length(relevant_feeds) == 0) {
    stop(sprintf(c("Couldn't find any feeds that match the specified",
                   " criteria. Try setting feeds = \"all\".")))
  }
  
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

