
General Bikeshare Feed Specification - R Package
================================================

[![Travis-CI Build Status](https://travis-ci.org/ds-civic-data/gbfs.svg?branch=master)](https://travis-ci.org/ds-civic-data/gbfs)

The `gbfs` package supplies a set of functions to interface with General Bikeshare Feed Specification .json feeds in R, allowing users to save and accumulate tidy .rds datasets for specified cities/bikeshare programs.

**Features**

-   Get bikeshare data by specifying city or supplying url of feed
-   All feeds for a city can be saved with a single function
-   New information from dynamic feeds can be appended to existing dataset

Installation
------------

You can install gbfs from github with:

``` r
# install.packages("devtools")
devtools::install_github("ds-civic-data/gbfs")
```

Example
-------

Here the function `get_gbfs()` is used to create a folder and save all existing gbfs .json feeds for Portland. Then `get_station_status()` is used to append the most recent version of the station status .json feed to the station status .rds dataset.

``` r
get_gbfs(city = "Portland", feeds = "all", directory = "pdx_gbfs")
list.files("pdx_gbfs")
#> [1] "free_bike_status.rds"     "station_information.rds" 
#> [3] "station_status.rds"       "system_alerts.rds"       
#> [5] "system_calendar.rds"      "system_hours.rds"        
#> [7] "system_information.rds"   "system_pricing_plans.rds"
#> [9] "system_regions.rds"
station_status <- readRDS("pdx_gbfs/station_status.rds")
head(station_status)
#>   station_id num_bikes_available num_bikes_disabled num_docks_available
#> 1   hub_1512                  13                  0                   3
#> 2   hub_1513                   3                  0                  15
#> 3   hub_1514                   1                  0                  17
#> 4   hub_1515                   9                  0                   9
#> 5   hub_1516                  14                  0                   0
#> 6   hub_1517                   4                  0                  10
#>   is_installed is_renting is_returning        last_updated year month day
#> 1         TRUE       TRUE         TRUE 2018-05-07 13:53:10 2018     5   7
#> 2         TRUE       TRUE         TRUE 2018-05-07 13:53:10 2018     5   7
#> 3         TRUE       TRUE         TRUE 2018-05-07 13:53:10 2018     5   7
#> 4         TRUE       TRUE         TRUE 2018-05-07 13:53:10 2018     5   7
#> 5         TRUE       TRUE         TRUE 2018-05-07 13:53:10 2018     5   7
#> 6         TRUE       TRUE         TRUE 2018-05-07 13:53:10 2018     5   7
#>   hour minute
#> 1   13     53
#> 2   13     53
#> 3   13     53
#> 4   13     53
#> 5   13     53
#> 6   13     53
nrow(station_status)
#> [1] 369
get_station_status(city = "Portland", directory = "pdx_gbfs", file = "station_status.rds")
station_status <- readRDS("pdx_gbfs/station_status.rds")
nrow(station_status)
#> [1] 492
```
