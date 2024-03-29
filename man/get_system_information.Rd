% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_static_feeds.R
\name{get_system_information}
\alias{get_system_information}
\title{Grab the system_information feed.}
\usage{
get_system_information(
  city,
  directory = NULL,
  file = "system_information.rds",
  output = NULL
)
}
\arguments{
\item{city}{A character string that can be matched to a gbfs feed. The recommended
argument is a system ID supplied in the output of [get_gbfs_cities()], but will
also attempt to match to the URL of an active .json feed or city name.}

\item{directory}{Optional. Path to a folder (or folder to be 
created) where the feed will be saved.}

\item{file}{Optional. The name of the file to be saved (if \code{output} 
is set to \code{"save"} or \code{"both"}), as a character string. 
Must end in \code{".rds"}.}

\item{output}{Optional. The type of output method. If left as default, this
argument is inferred from the \code{directory} argument. If 
\code{output = "save"}, the object will be saved as an .rds object at 
# the given path. If \code{output = "return"}, the output will be returned 
as a dataframe object. Setting \code{output = "both"} will do both.}
}
\value{
The output of this function depends on argument to \code{output}
and \code{directory}. Either a saved .rds object generated from the current 
feed, a dataframe object, or both.
}
\description{
\code{get_system_information} grabs and tidies the system_information 
feed for a given city. Metadata for this dataset can be found at: 
\url{https://github.com/MobilityData/gbfs/blob/master/gbfs.md}
}
\examples{
# we can grab the free bike status feed for portland, 
# oregon's bikeshare program in  several ways! first, supply the `city` 
# argument as a URL, and save to file by leaving output 
# set to it's default. usually, we would supply a character 
# string (like "pdx", maybe,) for the `directory` argument 
# instead of `tempdir`.
\donttest{get_system_information(city = 
"https://gbfs.lyft.com/gbfs/1.1/pdx/en/system_information.json",  
                       directory = tempdir())}
                    
# or, instead, just supply the name of 
# the city as a string and return the output as a dataframe
\donttest{get_system_information(city = "biketown_pdx",  
                       output = "return")}
}
\seealso{
[get_gbfs()] for a wrapper to call each of the \code{get_feed}
functions, [get_gbfs_cities()] for a dataframe of cities releasing gbfs
functions, and [get_which_gbfs_feeds()] for a dataframe of which feeds
are released by a given city.
}
