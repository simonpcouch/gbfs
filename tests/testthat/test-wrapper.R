context("wrapper")

# grab the feed for portland's biketown... these feeds
# change regularly, so test failures might result from
# changes in the operation model of biketown rather than
# failure of the software

biketown <- tryCatch(
  get_gbfs("biketown_pdx"),
  error = function(e) {e}
)

if (inherits(biketown, "error")) {
  skip("no internet connection or deprecated bikeshare system")
}

bike_itau <- tryCatch(
  get_gbfs("santiago"),
  error = function(e) {e}
)

if (inherits(bike_itau, "error")) {
  skip("no internet connection or deprecated bikeshare system")
}

chicago_url <- "https://gbfs.divvybikes.com/gbfs/2.3/gbfs.json"

if (url_exists(chicago_url)) {
  chicago <- tryCatch(
    get_gbfs(chicago_url),
    error = function(e) {e}
  )
  
  if (inherits(chicago, "error")) {
    skip("deprecated bikeshare system")
  }
} else {
  skip("no internet connection")
}

test_that("main wrapper works", {
 
  skip_if_offline(host = "r-project.org")
  
  expect_equal(class(biketown), "list")
  expect_equal(class(bike_itau), "list")
  expect_equal(class(chicago), "list")
  
})

test_that("argument checking works", {

  skip_if_offline(host = "r-project.org")
  
  # no directory supplied but user wants to save
  expect_error(get_gbfs("biketown_pdx", 
                        output = "save"),
               "The argument to output suggests")
  
})
