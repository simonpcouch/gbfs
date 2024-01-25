#' Package: gbfs
#'
#' The \code{gbfs} package allows users to query tidy datasets about bikeshare 
#' programs around the world by supplying a set of functions to interface with 
#' .json feeds following the General Bikeshare Feed Specification, a standard 
#' data release format developed by the North American Bikeshare Association.
#'
#' @details 
#' 
#' The main function exported by this package is \code{get_gbfs()}, which
#' grabs every feed released by a city. Alternatively, the user can just
#' grab information on specific feeds (or groups of feeds).
#' 
#' Each of the feeds described below can be queried with the \code{get_suffix()} 
#' function, where \code{suffix} is replaced with the name of the relevant feed.
#' 
#' Although all of the feeds are livestreamed, only a few of the datasets 
#' change often:
#' 
#' \describe{
#'  \item{\code{station_status:}}{ Supplies the number of available bikes and 
#'  docks at each station as well as station availability}
#'  \item{\code{free_bike_status:}}{ Gives the coordinates and metadata on 
#'  available bikes that are parked, but not at a station.}
#' }
#' 
#' In this package, these two datasets are considered "dynamic", and can be 
#' specified as desired datasets by setting `\code{feeds = "dynamic"} in the 
#' main wrapper function in the package, \code{get_gbfs}.
#' 
#'  Much of the data supplied in this specification can be considered static. 
#'  If you want to grab all of these for a given city, set \code{feeds = "static"}
#'  when calling \code{get_gbfs}. Static feeds include:
#' 
#' \describe{
#'  \item{\code{system_information:}}{ Basic metadata about the bikeshare program}
#'  \item{\code{station_information:}}{ Information on the capacity and coordinates of stations}
#'  \item{Several optional feeds:}{ \code{system_hours}, \code{system_calendar}, 
#'  \code{system_regions}, \code{system_pricing_plans}, and \code{system_alerts}}
#' }
#' 
#'
#' @docType package
#' @name gbfs
#' @importFrom dplyr %>%
"_PACKAGE"

utils::globalVariables(
  c(".", "Location", "Name", "last_reported", "last_updated",
    "num_bikes_available", "num_bikes_disabled", "num_docks_available",
    "num_docks_disabled", "is_installed", "is_renting", "is_returning",
    "station_id", "city", "gbfs_feeds", "name", "type",
    "Auto-Discovery URL", "System ID"))
