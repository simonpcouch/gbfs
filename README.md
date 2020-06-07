
# General Bikeshare Feed Specification - R Package <a href='https://gbfs.netlify.com'><img src='https://raw.githubusercontent.com/simonpcouch/gbfs/master/figures/hex.png' align="right" height="200" /></a>

[![CRAN
status](https://www.r-pkg.org/badges/version/gbfs)](https://cran.r-project.org/package=gbfs)
[![Travis-CI Build
Status](https://travis-ci.org/simonpcouch/gbfs.svg?branch=master)](https://travis-ci.org/simonpcouch/gbfs)
[![Testing
Coverage](https://codecov.io/gh/simonpcouch/gbfs/branch/master/graph/badge.svg)](https://codecov.io/gh/simonpcouch/gbfs?branch=master)
[![CRAN
Downloads](https://cranlogs.r-pkg.org/badges/grand-total/gbfs)](https://cran.r-project.org/package=gbfs)

The `gbfs` package supplies a set of functions to interface with General
Bikeshare Feed Specification .json feeds in R, allowing users to save
and accumulate tidy .rds datasets for specified cities/bikeshare
programs. The North American Bikeshare Association’s
[gbfs](https://github.com/NABSA/gbfs) is a standardized data release
format for live information on the status of bikeshare programs, as well
as metadata, including counts of bikes at stations, ridership costs, and
geographic locations of stations and parked bikes.

**Features**

  - Get bikeshare data by specifying city name or supplying url of feed
  - All feeds for a city can be saved with a single function
  - New information from dynamic feeds can be appended to existing
    datasets

## Installation

We’re on CRAN\! Install the latest release with:

``` r
install.packages("gbfs")
library(gbfs)
```

You can install the developmental version of `gbfs` from GitHub with:

``` r
# install.packages("devtools")
devtools::install_github("simonpcouch/gbfs")
```

## Background

The `gbfs` is a standardized data feed describing the current status of
a bikeshare program.

Although all of the data is live, only a few of the datasets change
often:

  - `station_status`: Supplies the number of available bikes and docks
    at each station as well as station availability
  - `free_bike_status`: Gives the coordinates and metadata on available
    bikes that are parked, but not at a station.

In this package, these two datasets are considered “dynamic”, and can be
specified as desired datasets by setting `feeds = "dynamic"` in the main
wrapper function in the package, `get_gbfs`.

Much of the data supplied in this specification can be considered
static. If you want to grab all of these for a given city, set `feeds =
"static'` when calling `get_gbfs`. Static feeds include:

  - `system_information`: Basic metadata about the bikeshare program
  - `station_information`: Information on the capacity and coordinates
    of stations
  - Several optional feeds: `system_hours`, `system_calendar`,
    `system_regions`, `system_pricing_plans`, and `system_alerts`

Each of the above feeds can be queried with the `get_suffix` function,
where `suffix` is replaced with the name of the relevant feed.

For more details on the official `gbfs` spec, see [this
document](https://github.com/NABSA/gbfs/blob/master/gbfs.md).

## Example

In this example, we’ll grab data from Portland, Oregon’s Biketown
bikeshare program and visualize some of the different datasets.

``` r
# load necessary packages
library(tidyverse)
```

First, we’ll grab some information on the stations.

``` r
# grab portland station information and return it as a dataframe
pdx_station_info <- get_station_information("portland")
#> Message: Returning the output data as an object, rather than saving it, since the `directory` argument was not specified. Setting `output = "return"` will silence this message.

# check it out!
glimpse(pdx_station_info)
#> Observations: 158
#> Variables: 7
#> $ station_id     <chr> "hub_1512", "hub_1513", "hub_1514", "hub_1515", "hub_1…
#> $ name           <chr> "SW 10th at Harvey Milk ", "SE Gideon at 12th Ave MAX …
#> $ region_id      <chr> "region_241", "region_241", "region_241", "region_241"…
#> $ lon            <dbl> -122.6811, -122.6535, -122.6395, -122.6534, -122.6663,…
#> $ lat            <dbl> 45.52175, 45.50281, 45.50357, 45.50513, 45.51148, 45.5…
#> $ address        <chr> "404 Southwest 10th Avenue, Portland", "1201-1241 Sout…
#> $ rental_methods <list> [<"KEY", "APPLEPAY", "ANDROIDPAY", "TRANSITCARD", "AC…
```

…as well as the number of bikes at each station.

``` r
# grab current capacity at each station and return it as a dataframe
pdx_station_status <- get_station_status("portland")
#> Message: Returning the output data as an object, rather than saving it, since the `directory` argument was not specified. Setting `output = "return"` will silence this message.

# check it out!
glimpse(pdx_station_status)
#> Observations: 158
#> Variables: 14
#> $ station_id          <chr> "hub_1512", "hub_1513", "hub_1514", "hub_1515", "…
#> $ num_bikes_available <int> 3, 8, 8, 5, 9, 4, 8, 4, 6, 0, 9, 6, 1, 8, 6, 5, 0…
#> $ num_bikes_disabled  <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0…
#> $ num_docks_available <int> 14, 2, 4, 13, 7, 10, 8, 13, 12, 12, 8, 6, 7, 8, 6…
#> $ is_installed        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…
#> $ is_renting          <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…
#> $ is_returning        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…
#> $ last_reported       <int> 1585251497, 1585251497, 1585251497, 1585251497, 1…
#> $ last_updated        <dttm> 2020-03-26 12:38:17, 2020-03-26 12:38:17, 2020-0…
#> $ year                <dbl> 2020, 2020, 2020, 2020, 2020, 2020, 2020, 2020, 2…
#> $ month               <dbl> 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3…
#> $ day                 <int> 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 2…
#> $ hour                <int> 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 1…
#> $ minute              <int> 38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 3…
```

Just like that, we have two tidy datasets containing information about
Portland’s bikeshare program.

Joining these datasets, we can get the capacity at each station, along
with each station’s metadata.

``` r
# full join these two datasets on station_id and select a few columns
pdx_stations <- full_join(pdx_station_info, 
                          pdx_station_status, 
                          by = "station_id") %>%
  # just select columns we're interested in visualizing
  select(id = station_id, 
         lon, 
         lat, 
         num_bikes_available, 
         num_docks_available) %>%
  mutate(type = "docked")
```

Finally, before we plot, lets grab the locations of the bikes parked in
Portland that are not docked at a station,

``` r
# grab data on free bike status and save it as a dataframe
pdx_free_bikes <- get_free_bike_status("portland", output = "return") %>%
  # just select columns we're interested in visualizing
  select(id = bike_id, lon, lat) %>%
  # make columns analogous to station_status for row binding
  mutate(num_bikes_available = 1,
         num_docks_available = NA,
         type = "free")
```

…and bind these dataframes together\!

``` r
# row bind stationed and free bike info
pdx_full <- bind_rows(pdx_stations, pdx_free_bikes)
```

Now, plotting,

``` r
# filter out stations with 0 available bikes
pdx_plot <- pdx_full %>%
  filter(num_bikes_available > 0) %>%
  # plot the geospatial distribution of bike counts
  ggplot() + 
  aes(x = lon, 
      y = lat, 
      size = num_bikes_available, 
      col = type) +
  geom_point() +
  # make aesthetics slightly more cozy
  theme_minimal() +
  scale_color_brewer(type = "qual")
```

``` r
pdx_plot
```

<a href='https://github.com/simonpcouch/gbfs'><img src='https://raw.githubusercontent.com/simonpcouch/gbfs/master/figures/plot-1.png' height="500" /></a>

Folks who have spent a significant amount of time in Portland might be
able to pick out the Willamette River running Northwest/Southeast
through the city. With a few lines of `gbfs`, `dplyr`, and `ggplot2`, we
can put together a meaningful visualization to help us better understand
how bikeshare bikes are distributed throughout Portland.

Some other features worth playing around with in `gbfs` that weren’t
touched on in this example:

  - The main wrapper function in the package, `get_gbfs`, will grab
    every dataset for a given city. (We call the functions to grab
    individual datasets above for clarity.)
  - In the above lines, we output the datasets as returned dataframes.
    If you’d rather save the output to your local files, check out the
    `directory` and `return` arguments.
  - When the `output` argument is left as default in
    `get_free_bike_status` and `get_station_status` (the functions for
    the `dynamic` dataframes,) and a dataframe already exists at the
    given path, `gbfs` will row bind the dataframes, allowing for the
    capability to accumulate large datasets over time.
  - If you’re not sure if your city supplies `gbfs` feeds, you might
    find the `get_gbfs_cities` and `get_which_gbfs_feeds` functions
    useful.

## Contributing

Please note that the `gbfs` R package is released with a [Contributor
Code of Conduct](CONTRIBUTING.md). By contributing to this project, you
agree to abide by its terms.
