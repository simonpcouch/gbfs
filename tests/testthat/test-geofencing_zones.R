test_that("geofencing_zones_to_sf converts simple geojson to sf", {
  skip_if_not_installed("sf")

  # create minimal geojson-like list with one polygon feature
  coords <- list(
    list(
      list(c(-122.68, 45.52), c(-122.68, 45.53), c(-122.67, 45.53), c(-122.67, 45.52))
    )
  )

  geojson <- list(
    type = "FeatureCollection",
    features = list(
      list(
        type = "Feature",
        properties = list(name = "test_zone"),
        geometry = list(type = "Polygon", coordinates = coords[[1]])
      )
    )
  )

  sf_obj <- geofencing_zones_to_sf(geojson)

  expect_s3_class(sf_obj, "sf")
  expect_true(nrow(sf_obj) == 1)
  expect_true("name" %in% colnames(sf_obj))
  expect_equal(sf_obj$name[1], "test_zone")
  expect_true(all(sf::st_geometry_type(sf_obj) %in% c("POLYGON", "MULTIPOLYGON")))
})

test_that("geofencing_zones_to_sf works on live Dott geofencing feed", {
#   skip_if_offline(host = "https://www.r-project.org/")
  skip_if_not_installed("sf")

  url <- "https://gbfs.api.ridedott.com/public/v2/dortmund/geofencing_zones.json"
  raw <- tryCatch(jsonlite::fromJSON(url, simplifyVector = FALSE), error = function(e) NULL)
  skip_if(is.null(raw), "Could not fetch live geofencing feed")

  # many GBFS providers nest the FeatureCollection under data$geofencing_zones
  if (!is.null(raw$data) && !is.null(raw$data$geofencing_zones)) {
    geo <- raw$data$geofencing_zones
  } else if (!is.null(raw$type) && raw$type == "FeatureCollection") {
    geo <- raw
  } else {
    skip("Unexpected JSON structure for live geofencing feed")
  }

  sf_obj <- geofencing_zones_to_sf(geo)
  expect_s3_class(sf_obj, "sf")
  expect_true(nrow(sf_obj) >= 1)
  sf_obj
  expect_true(all(sf::st_geometry_type(sf_obj) %in% c("POLYGON", "MULTIPOLYGON")))
})
