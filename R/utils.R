# a function to check the different arguments provided about how
# to return the resulting data.
check_return_arguments <- function(directory_, file_, output_) {
  
  if (is.null(directory_)) {
    directory_ <- "null"
  }
  
  if (is.null(output_)) {
    output_ <- "null"
  }
  
  # check whether the output argument matches one of the options... (if left
  # as default, the output is "save")
  if (!output_ %in% c("save", "return", "both", "null")) {
    stop(sprintf(c("Please supply one of \"save\", \"return\", or \"both\" ",
                   "as arguments to `output`.")))
  }
  
  # if the output type indicates the object should be returned, by there's
  # no directory argument, trigger an error
  if (directory_ == "null" & output_ %in% c("save", "both")) {
    stop(sprintf(c("You have not supplied a folder to save the resulting file",
                   " in, but the argument to `output` indicates that you'd like",
                   " to save the dataframe. Please supply a `directory`",
                   " argument or set `output = \"return\".`")))
  }  
  
  
  # message when the user doesn't supply a `dir` argument but the output
  # argument is left as default. so as not to break functionality from v1.0.0, 
  # the package still defaults to returning output as .rds files. instead of 
  # requiring users to switch their argument to `output`, though, they can just
  # not supply a `dir` argument.
  if (directory_ == "null" & output_ == "null") {
    message(c("Message: Returning the output data as an object, rather than",
              " saving it, since the `directory` argument was not specified. ",
              "Setting `output = \"return\"` will silence this message."))
  }
}

# this function checks the `city` argument, and converts the names of
# cities to their appropriate URL
city_to_url <- function(city_, feed_) {
  
  # first, check if the city argument is the desired feed. if so, return it!
  if (stringr::str_detect(city_, paste0(feed_, ".json"))) {
    if (url_exists(city_)) {
      return(city_)
    } else {
      stop(sprintf(c("The supplied argument for \"city\" looks like a URL, ",
                     "but the webpage doesn't seem to exist. Please check ",
                     "the URL provided or provide the city name as a string.")))
    }
  }
  
  # next, check if the city argument is the top-level gbfs.json feed
  if (stringr::str_detect(city_, "gbfs.json")) {
    
    if (feed_ != "gbfs") {
      # try to construct the link from the top-level one
      city_ <- find_feed_from_top_level(city_, feed_)
    }
    
    return(city_)
    
    # the argument might actually be a valid json url without an explicit
    # gbfs .json extension
  } else if (url_exists(city_)) {
    
    is_top_level_json <- tryCatch(expr = {
      
        # check if the columns in the data match the spec
        colnames_match <- TRUE %in% (
          jsonlite::fromJSON(city_)[["data"]][[1]][[1]] %>%
          colnames() == c("name", "url"))
        },
                                  error = function(e) {FALSE}
      )
    
    if (is_top_level_json) {
      return(city_)
    }
    
  }
  
  # try to match the string to the system ID
  cities <- get_gbfs_cities() %>%
    dplyr::select(Name, Location, `Auto-Discovery URL`, `System ID`)
   
  system_index <- stringr::str_detect(string = tolower(cities$`System ID`), 
                                      pattern = tolower(city_)) %>%
    which()

  system_res <- find_feed_from_index(system_index, cities, feed_)
  
  if (inherits(system_res, "character")) {
    return(system_res)
  }
  
  # and then try to match ind(ex/ices) of cities matching the supplied string
  city_index <- stringr::str_detect(string = tolower(cities$Location), 
                                    pattern = tolower(city_)) %>%
                which()
  
  city_res <- find_feed_from_index(city_index, cities, feed_)
  
  if (inherits(city_res, "character")) {
    return(city_res)
  }
  # otherwise, the string didn't match any cities... 
  stop(sprintf(c("No supported cities matched the string supplied. Consider ", 
               "using `get_gbfs_cities()` to find the desired .json URL.")))
}

# takes in a (multi)index and returns the relevant URL
find_feed_from_index <- function(index_, cities_, feed_) {
  # grab data each of the relevant indices
  url <- as.data.frame((cities_)[index_, 'Auto-Discovery URL'])
  
  # if there's just one url, return the relevant feed
  if (nrow(url) == 1) { 
    if (feed_ == "gbfs") {
      return(dplyr::pull(url))
    } else {
      return(find_feed_from_top_level(dplyr::pull(url), feed_))
    }
  }
  
  # if more than one city matched the supplied one...
  if (nrow(url) > 1) {
    stop(sprintf(c("Several cities matched the supplied string. Please ",
                   "consider supplying a .json URL to specify your city of ",
                   "interest. The .json ",
                   "URLs for the cities matching the string are: \n    ",
                   paste0(dplyr::pull(url), sep = " \n    "))))
  }
}
  
# a function that takes in a top-level gbfs.json URL, the name of the desired 
# feed and tries to find the desired feed stored inside of it
find_feed_from_top_level <- function(top_level_, feed_) {
  
  # if the supplied feed is the top-level feed, then just return it
  if (feed_ == "gbfs" & url_exists(top_level_)) {
    return(top_level_)
  }
  
  # grab the gbfs.json feed
  gbfs <- tryCatch(jsonlite::fromJSON(txt = top_level_),
                   error = message_connection_issue)
  
  # pull out the names of the supplied sub-feeds
  gbfs_feeds <- gbfs$data$en$feeds
  
  # if the sub-feed is provided by the program, return its URL
  if (feed_ %in% gbfs_feeds$name) {
    gbfs_feeds %>%
      dplyr::filter(name == feed_) %>%
      dplyr::select(url) %>%
      dplyr::pull()
  } else {
    stop(sprintf(c("The supplied \"city\" argument looks like the top-level ",
                   "\"gbfs.json\" URL, but the webpage for the ",
                   paste(feed_, ".json"), " feed doesn't seem to exist. ",
                   "Please supply the actual URL or the name of the ",
                   "city as a string.")))
  }
}
 
# a function to supply a 2 length logical vector, where the first entry
# gives whether to save the output, and the second gives whether to output it
determine_output_types <- function(directory_, output_) {
  
  if (is.null(output_) & is.null(directory_)) {
    return(c(FALSE, TRUE))
  } else if (is.null(output_) & (!is.null(directory_))) {
    return(c(TRUE, FALSE))
  } else if (output_ == "both") {
    return(c(TRUE, TRUE))
  } else if (output_ == "return") {
    if (is.null(directory_)) {
      return(c(FALSE, TRUE))
    } else {
      message(c("The argument to \"output\" is \"return\", but a non-null",
                "\"directory\" argument has been supplied. Ignoring the",
                "\"directory\" argument and only returning the output."))
      return(c(FALSE, TRUE))
    }
  } else if (output_ == "save") {
    return(c(TRUE, FALSE))
  } else {
    stop(sprintf(c("The supplied \"output\" argument doesn't match any of",
                   " the available options. Please leave the argument as", 
                   " default or supply one of \"return\", \"save\",",
                   " or \"both\"")))
  }

}

# a function that grabs a gbfs formatted dataset
get_gbfs_dataset_ <- function(city, directory, file, output, feed) {
  
  # test internet connection
  if (!connected_to_internet()) {
    return(message_no_internet())
  }
  
  # check arguments to make sure the putput method makes sense
  check_return_arguments(directory_ = directory,
                         file_ = file,
                         output_ = output) 
  
  # find the appropriate url for the feed
  url <- city_to_url(city, 
                     feed)
  
  # save feed
  data_raw <- tryCatch(jsonlite::fromJSON(txt = url),
                       error = message_connection_issue)
  
  data <- data_raw[["data"]]
  
  last_updated_index <- names(data_raw) %>%
    tolower() %>%
    stringr::str_detect("last") %>%
    which()
  
  last_updated <- data_raw[[last_updated_index]] %>%
    as.POSIXct(., origin = "1970-01-01")
  
  # for some feeds, the data is nested one more level down
  if (length(data) == 1) {
    data <- data[[1]] %>%
      as.data.frame() %>%
      jsonlite::flatten()
  } else {
    data <- as.data.frame(data[!unlist(lapply(data, is.null))]) %>%
      jsonlite::flatten()
  }
  
  
  # some feeds have mutated columns to make working with datetimes easier
  if (feed %in% c("free_bike_status", "station_status")) {
    data <- data %>%
      dplyr::mutate(last_updated = last_updated) %>%
      dplyr::mutate(year = lubridate::year(last_updated),
                    month = lubridate::month(last_updated),
                    day = lubridate::day(last_updated),
                    hour = lubridate::hour(last_updated),
                    minute = lubridate::minute(last_updated))
  }
  
  # make a 2-length logical vector of whether to save and/or return
  output_types <- determine_output_types(directory, output)
  
  # if we should save the data...
  if (output_types[1]) {
    # create directory if it doesn't exist
    if (!dir.exists(directory)) {
      dir.create(directory, recursive = TRUE)
    } # and save the data...
    # if the feed is static, or feed isn't static but there's no
    # existing file, just save it
    if (!feed %in% c("station_status", "free_bike_status") |
        (feed %in% c("station_status", "free_bike_status") &
         (!file.exists(paste(directory, file, sep = "/")))
        )) {
      saveRDS(data, file = paste(directory, file, sep = "/"))
    } else if (feed %in% c("station_status", "free_bike_status") &
               file.exists(paste(directory, file, sep = "/"))) {
    # if the feed isn't static and there _is_ a file there,
    # append to it rather than overwriting it
      if (datasets_can_be_row_binded(data, paste(directory, file, sep = "/"))) {
        update_dynamic_feed(data, paste(directory, file, sep = "/"))
      }
    }
  }
  
  # if we should output the data...
  if (output_types[2]) {
    data
  }
}

# a data frame containing each possible feed that can be 
# released by a city and the type of feed that it is
all_feeds <- data.frame(name = c("system_information", "station_information", 
                             "station_status", "free_bike_status", 
                             "system_hours", "system_calendar",
                             "system_regions", "system_pricing_plans", 
                             "system_alerts"),
                        type = c(rep("static", 2),
                                 rep("dynamic", 2),
                                 rep("static", 5)),
                        stringsAsFactors = FALSE)




# a function that ensures that the feeds argument (supplied
# to get_gbfs) is valid
process_feeds_argument <- function(arg_) {
  # check to make sure that it's one of the available options
  if (!arg_ %in% c("all", "static", "dynamic")) {
    stop(sprintf(c("The supplied \"feeds\" argument is \"", as.character(arg_),
                   "\", but it needs to be one of \"all\", \"static\",", 
                   " or \"dynamic\". See ?get_gbfs for more information."
                   )))
  }
  
  # if the argument is "all", return both types
  if (arg_ == "all") {
    arg_ <- c("static", "dynamic")
  }
  
  return(arg_)
}

# a function that takes in one of the dynamic dataframes,
# as well as a filepath to an already existing dataframe,
# row binds them, and then saves the result
update_dynamic_feed <- function(data, filepath) {
  old_data <- readRDS(filepath)
  updated_data <- rbind(data, old_data)
  saveRDS(updated_data, file = filepath)
}


# a function to check whether two dataframes can
# be row-binded... if not, diagnostic errors should give
# clues as to why. if so, return TRUE
datasets_can_be_row_binded <- function(data, filepath) {
  old_data <- readRDS(filepath)
  
  ncol_matches <- (ncol(data) == ncol(old_data))
  
  if (!ncol_matches) {
    stop(sprintf(c("The bikeshare data just pulled has ", 
                   ncol(data), " columns,",
                   " while the already stored bikeshare data, at file path ",
                   filepath, ", has ", ncol(old_data), 
                   " columns, so they can not be row-binded.")
                 )
         )
  }
  
  column_names_match <- (colnames(data) == colnames(old_data))

  if (FALSE %in% column_names_match) {
    stop(sprintf(c("The bikeshare data just pulled has different column names", 
                   " than the already stored bikeshare data at ", filepath,
                   ", so they can not be row-binded.")
                 )
         )
  }  
  
  new_column_types <- sapply(data, class) %>% 
                      unname() %>% 
                      as.character()
  old_column_types <- sapply(old_data, class) %>% 
                      unname() %>% 
                      as.character()
                             
  column_types_match <- (new_column_types == old_column_types)
  
  if (FALSE %in% column_types_match) {
    stop(sprintf(c("The bikeshare data just pulled has different column types", 
                   " than the already stored bikeshare data at ", filepath,
                   ", so they can not be row-binded.")
    )
    )
  }  
  
  return(TRUE)
  
}

# thank you to hrbrmstr on 
# https://stackoverflow.com/questions/52911812/check-if-url-exists-in-r
# for this function---more extensive url existence checking since
# json feeds seem to trip up RCurl::url.exists quite a bit
url_exists <- function(x, quiet = FALSE, ...) {

  capture_error <- function(code, otherwise = NULL, quiet = TRUE) {
    tryCatch(
      list(result = code, error = NULL),
      error = function(e) {
        list(result = otherwise, error = e)
      }
    )
  }
  
  safely <- function(.f, otherwise = NULL, quiet = TRUE) {
    function(...) capture_error(.f(...), otherwise, quiet)
  }
  
  sHEAD <- safely(httr::HEAD)
  sGET <- safely(httr::GET)
  
  if (!stringr::str_detect(x, "http")) {
    x <- paste0("https://", x)
  }
  
  res <- sHEAD(x, ...)
  
  if (is.null(res$result)) {
    
    res <- sGET(x, ...)
    
    if (is.null(res$result)) { 
      return(FALSE)
    }
  }
  
  return(TRUE)
  
}

# a function to alert the user of no internet connection in a
# more informative/helpful way
message_no_internet <- function() {
  message(c("You don't seem to have an active internet connection. Please", 
            "connect to the internet to use the gbfs package."))
  return(list())
}

message_connection_issue <- function(e) {
  message(c("There was an issue connecting with the given gbfs provider. ", 
            "The response is printed below: \n", e))
  return(list())
}

# a wrapper around has internet so that with_mock can be used in tests
connected_to_internet <- function() {
  curl::has_internet()
}