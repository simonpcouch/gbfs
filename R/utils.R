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
    message(c("Returning the output data as an object, rather than saving it, ",
              "since the `dir` argument was not specified. Setting ",
              "output = \"return\" will silence this message."))
  }
}

# this is a function that, if the user supplies a URL ending in "gbfs.json"
# to a function that is supposed to grab a specific feed, finds the URL
# of the actual relevant feed
grab_subfeed <- function(url_, feed_) {
  main_gbfs <- jsonlite::fromJSON(txt = url_)
  feeds <- main_gbfs$data$en$feeds
  if (feed_ %in% gbfs_feeds$name) {
    free_bike_status_feed <- gbfs_feeds %>%
      dplyr::select(url) %>%
      dplyr::filter(stringr::str_detect(url, feed_)) %>%
      as.character()
  }
}

# this function checks the `city` argument, and converts the names of
# cities to their appropriate URL
city_to_url <- function(city_, feed_) {
  
  # first, check if the city argument is the desired feed. if so, return it!
  if (stringr::str_detect(city_, paste0(feed_, ".json"))) {
    if (RCurl::url.exists(city_)) {
      return(city_)
    } else {
      stop(sprintf(c("The supplied argument for \"city\" looks like a URL, ",
                     "but the webpage doesn't seem to exist. Please check",
                     "the URL provided or provide the city name as a string.")))
    }
  }
  
  # next, check if the city argument is the top-level gbfs.json feed
  if (stringr::str_detect(city_, "gbfs.json")) {
    
    # if the supplied string contains gbfs.json, check that it exists
    if (RCurl::url.exists(city_)) {
      # try to construct the link from the top-level one
      city_ <- find_feed_from_top_level(city_, feed_)
    } else {
      sprintf(c("The supplied URL doesn't seem to exist. Please consider ",
                "using `get_gbfs_cities()` to find the desired .json URL."))
    }
    
    # then, if it exists, return it
    if (RCurl::url.exists(city_)) {
      return(city_)
    } else {
      stop(sprintf(c("The supplied \"city\" argument looks like the top-level",
                     "\"gbfs.json\" URL, but the webpage for the",
                     paste(feed_, ".json"), "feed doesn't seem to exist.",
                     "Please supply the actual URL or the name of the",
                     "city as a string.")))
    }
  }
  
  # lastly, then, try to match the string argument to a cities URL...
  # grab the most current gbfs_cities dataframe
  cities <- get_gbfs_cities() %>%
    dplyr::select(Name, Location, 'Auto-Discovery URL')
    
  # find the indi(x/ces) of cities matched the supplied string
  city_index <- as.numeric(agrep(x = cities$Location, 
                                 pattern = city_), 
                           ignore.case = TRUE)
    
  # grab data each of the relevant indices
  url <- as.data.frame((cities)[city_index, 'Auto-Discovery URL'])
  
  # if there's just one url, return the relevant sub-feed
  if (nrow(url) == 1) { 
    return(find_feed_from_top_level(dplyr::pull(url), feed_))
  }
  
  # if more than one city matched the supplied one...
  if (nrow(url) > 1) {
    stop(sprintf(c("Several cities matched the string supplied. Consider ",
                    "using `get_gbfs_cities()` to find the desired .json URL.")))
  }
  
  # otherwise, the string didn't match any cities... 
  stop(sprintf(c("No supported cities matched the string supplied. Consider ", 
               "using `get_gbfs_cities()` to find the desired .json URL.")))
}
  
# a function that takes in a top-level gbfs.json URL, the name of the desired 
# feed and tries to find the desired feed stored inside of it
find_feed_from_top_level <- function(top_level_, feed_) {
  
  # grab the gbfs.json feed
  gbfs <- jsonlite::fromJSON(txt = top_level_)
  
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
    return(c(FALSE, TRUE))
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
  
  # check arguments to make sure the putput method makes sense
  check_return_arguments(directory_ = directory,
                         file_ = file,
                         output_ = output) 
  
  # find the appropriate url for the feed
  url <- city_to_url(city, 
                     feed)
  
  # save feed
  data <- jsonlite::fromJSON(txt = url)[[3]]
  
  # for some feeds, the data is nested one more level down
  if (length(data) == 1) {
    data <- data[[1]]
  } else {
    data <- as.data.frame(data)
  }
  
  # make a 2-length logical vector of whether to save and/or return
  output_types <- determine_output_types(directory, output)
  
  # if we should save the data...
  if (output_types[1]) {
    # create directory if it doesn't exist
    if (!dir.exists(directory)) {
      dir.create(directory)
    } # and save the data
    saveRDS(data, file = paste(directory, file, sep = "/"))
  }
  
  # if we should output the data...
  if (output_types[2]) {
    data
  }
}

# a function to identify the feeds supplied by a city
get_which_gbfs_feeds <- function(city) {
  
  url <- city_to_url(city, "gbfs")
  
  gbfs <- jsonlite::fromJSON(txt = url)
  
  gbfs_feeds <- gbfs[[3]][[1]][[1]]
  
  return(gbfs_feeds)
  
}

# a tibble containing each possible feed that can be released by a city and
# the type of feed that it is
all_feeds <- tibble(name = c("system_information", "station_information", 
                             "station_status", "free_bike_status", 
                             "system_hours", "system_calendar",
                             "system_regions", "system_pricing_plans", 
                             "system_alerts"),
                    type = c(rep("static", 2),
                             rep("dynamic", 2),
                             rep("static", 5)))



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
