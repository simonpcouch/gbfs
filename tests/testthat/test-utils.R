context("utils")


test_that("argument checking works", {
  
  skip_if_offline(host = "r-project.org")
  
  # bad argument to `output`
  expect_error(check_return_arguments(directory_ = NULL,
                                      file_ = "gbfs.Rds",
                                      output_ = "bad"),
               "Please supply one of")
  
  # user wants to save, but not dir provided
  expect_error(check_return_arguments(directory_ = NULL,
                                      file_ = "gbfs.Rds",
                                      output_ = "save"),
               "You have not supplied a folder")
  
  # bad url
  expect_error(city_to_url(city_ = "beep_bop_station_information.json",
                           feed_ = "station_information"),
               "but the webpage doesn")
  
  # bad url for top-level
  expect_error(city_to_url(city_ = "beep_bop_gbfs.json",
                           feed_ = "gbfs"),
               "The supplied argument for")
  
  # no matching cities
  expect_error(city_to_url(city_ = "wldojglkwefpoimf",
                           feed_ = "gbfs"),
               "No supported cities matched") 
  
  # one matching city, non top-level feed
  # no matching cities
  expect_equal(city_to_url(city_ = "portland",
                           feed_ = "station_information"),
               "http://biketownpdx.socialbicycles.com/opendata/station_information.json") 
  
  # several matching cities
  expect_error(city_to_url(city_ = "buenos",
                           feed_ = "gbfs"),
               "Several cities matched") 
  
  # feeds argument is valid
  expect_error(process_feeds_argument("bop"),
               "argument is \"bop\", but it needs")
    
})

test_that("find feed from top level works", {
  
  skip_if_offline(host = "r-project.org")
  
  expect_equal(find_feed_from_top_level(
                 "http://biketownpdx.socialbicycles.com/opendata/gbfs.json",
                 "station_information"),
               "http://biketownpdx.socialbicycles.com/opendata/station_information.json")

  expect_error(find_feed_from_top_level(
      "http://biketownpdx.socialbicycles.com/opendata/gbfs.json",
      "weird_feed"),
    "webpage for the weird_feed .json")
  
  expect_equal(find_feed_from_top_level(
    "http://biketownpdx.socialbicycles.com/opendata/gbfs.json",
    "gbfs"),
    "http://biketownpdx.socialbicycles.com/opendata/gbfs.json")
  
})

test_that("determine output type works", {
  expect_equal(determine_output_types("pdx",
                                      "both"),
               c(TRUE, TRUE))
  
  expect_equal(determine_output_types("pdx",
                                      NULL),
               c(TRUE, FALSE))  
  
  expect_equal(determine_output_types(NULL,
                                      "return"),
               c(FALSE, TRUE)) 
  
  expect_message(determine_output_types("pdx",
                                      "return"),
                 "and only returning the output") 
  
  expect_error(determine_output_types("pdx",
                                      "bad"),
                 "argument doesn't match any of") 
  
})

test_that("no internet connection message works", {
  
  # "pretend" that the internet connection doesn't work
  with_mock("gbfs::connected_to_internet" = function() FALSE,
  
  # try it on all of the different functions that test internet connection
    expect_message(get_gbfs("portland")),
  
    expect_message(get_gbfs_dataset_("portland", 
                                   NULL, 
                                   NULL, 
                                   "return", 
                                   "station_information")),
  
    expect_message(get_which_gbfs_feeds("portland")),
  
    expect_message(get_gbfs_cities()),
  
    expect_equal(get_gbfs_cities(),
                 list())
  
  
  )
})
