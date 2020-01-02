context("wrapper")

# grab the feed for portland's biketown... these feeds
# change regularly, so test failures might result from
# changes in the operation model of biketown rather than
# failure of the software
biketown <- get_gbfs("portland")


test_that("main wrapper works", {
 
  expect_equal(class(biketown), "list")
  
})

test_that("argument checking works", {

  # no directory supplied but user wants to save
  expect_error(get_gbfs("portland", 
                        output = "save"),
               "The argument to output suggests")
  
})
