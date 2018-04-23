string_to_url <- function(city) {
  if (1 == length(agrep(x = as.character(city), pattern = ".json"))) {
    #return the city argument as 'url'
    url <- city
    url
  } else {
    #match string with a url
    cities <- read_csv("https://raw.githubusercontent.com/NABSA/gbfs/master/systems.csv") %>%
      select(Name, Location, 'Auto-Discovery URL')
    city_index <- as.numeric(agrep(x = cities$Location, pattern = city), ignore.case = TRUE)
    url <- as.data.frame((cities)[city_index, 'Auto-Discovery URL'])
    if (nrow(url) == 1) {
      as.character(url)
    } else {
      stop(sprintf("Several cities matched the string supplied. Consider supplying a url ending in gbfs.json"))
    }
  }
}
