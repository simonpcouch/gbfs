
General Bikeshare Feed Specification - R Package
================================================

*Developed by Kaelyn M. Rosenberg (author) and Simon P. Couch (author, maintainer)*

![CRAN Badge](http://www.r-pkg.org/badges/version/%7Bgbfs%7D) [![Build Status](https://travis-ci.org/ds-civic-data/gbfs.svg?branch=master)](https://travis-ci.org/ds-civic-data/gbfs)

The `gbfs` package supplies a set of functions to interface with General Bikeshare Feed Specification .json feeds in R, allowing users to save and accumulate tidy .rds datasets for specified cities/bikeshare programs.

**Features**

-   Get bikeshare data by specifying city or supplying url of feed
-   All feeds for a city can be saved with a single function
-   New information from dynamic feeds can be appended to existing datasets

Installation
------------

We're now on CRAN! Install the latest release, 1.1.0, with:

``` r
install.packages("gbfs")
library("gbfs")
```

You can install the development version of `gbfs` from github with:

``` r
# install.packages("devtools")
devtools::install_github("ds-civic-data/gbfs")
```

Example
-------

Here the function `get_gbfs()` is used to create a folder and save all existing gbfs .json feeds for Portland. Then `get_station_status()` is used to append the most recent version of the station status .json feed to the station status .rds dataset.

Note: Throughout this example I use a temporary directory by calling `withr::with_dir(tempdir(), ...)` as the codes are examples. In real life, we would skip the temporary directory stuff; just focus on the `...` for the purpose of this tutorial.

``` r
withr::with_dir(tempdir(), get_gbfs(city = "Portland", feeds = "all", directory = "pdx_gbfs"))
withr::with_dir(tempdir(), list.files("pdx_gbfs"))
#> [1] "free_bike_status.rds"     "station_information.rds" 
#> [3] "station_status.rds"       "system_alerts.rds"       
#> [5] "system_calendar.rds"      "system_hours.rds"        
#> [7] "system_information.rds"   "system_pricing_plans.rds"
#> [9] "system_regions.rds"
station_status <- withr::with_dir(tempdir(), readRDS("pdx_gbfs/station_status.rds"))
head(station_status)
#>   station_id num_bikes_available num_bikes_disabled num_docks_available
#> 1   hub_1512                   2                  0                  14
#> 2   hub_1513                   8                  0                   9
#> 3   hub_1514                   5                  0                  12
#> 4   hub_1515                   4                  0                  12
#> 5   hub_1516                  11                  0                   3
#> 6   hub_1517                   7                  0                   6
#>   is_installed is_renting is_returning        last_updated year month day
#> 1         TRUE       TRUE         TRUE 2018-09-21 10:13:23 2018     9  21
#> 2         TRUE       TRUE         TRUE 2018-09-21 10:13:23 2018     9  21
#> 3         TRUE       TRUE         TRUE 2018-09-21 10:13:23 2018     9  21
#> 4         TRUE       TRUE         TRUE 2018-09-21 10:13:23 2018     9  21
#> 5         TRUE       TRUE         TRUE 2018-09-21 10:13:23 2018     9  21
#> 6         TRUE       TRUE         TRUE 2018-09-21 10:13:23 2018     9  21
#>   hour minute
#> 1   10     13
#> 2   10     13
#> 3   10     13
#> 4   10     13
#> 5   10     13
#> 6   10     13
nrow(station_status)
#> [1] 144
withr::with_dir(tempdir(), get_station_status(city = "Portland", directory = "pdx_gbfs", file = "station_status.rds"))
station_status <- withr::with_dir(tempdir(), readRDS("pdx_gbfs/station_status.rds"))
nrow(station_status)
#> [1] 288
```
