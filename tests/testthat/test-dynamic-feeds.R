context("dynamic feeds")


test_that("dynamic feeds work", {
  
  get_station_status("portland")
  
  get_free_bike_status("portland")
  
})

test_that("file saving and overwriting works", {
  
  # make a temporary directory
  dir <- tempdir(check = TRUE)
  
  # save the file to a subdirectory of it
  get_station_status("portland", paste0(dir, "/test"))
  
  # ...and then append to it
  get_station_status("portland", paste0(dir, "/test"))
  
})

test_that("row binding checks work", {
  
  # make a temporary directory
  dir <- tempdir(check = TRUE)
  
  # grab some data to work with
  pdx_status <- get_station_status("portland", dir, output = "both")
  
  # try to overwrite it, but...
  
  # ... with a column pulled off
  pdx_status_ <- pdx_status %>%
    dplyr::select(-station_id)
  
  expect_error(datasets_can_be_row_binded(
    pdx_status_, 
    paste0(dir, "/station_status.Rds")),
    "columns, while")
  
  # ... or a column name changed
  pdx_status_ <- pdx_status %>%
    dplyr::rename(stationId = station_id)
  
  expect_error(datasets_can_be_row_binded(
    pdx_status_, 
    paste0(dir, "/station_status.Rds")),
    "has different column names")
  
  # ... or different column types
  pdx_status_ <- pdx_status %>%
    dplyr::mutate(station_id = as.factor(station_id))
  
  expect_error(datasets_can_be_row_binded(
    pdx_status_, 
    paste0(dir, "/station_status.Rds")),
    "has different column types")  
  
})