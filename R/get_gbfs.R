city_to_url <- function(city) {
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


get_gbfs_feeds <- function(url) {

  #test url: "http://biketownpdx.socialbicycles.com/opendata/gbfs.json"
  gbfs <- fromJSON(txt = url)

  feeds <- gbfs$data$en$feeds

  stat_info_feed <<- feeds %>%
    select(url) %>%
    filter(str_detect(url, "station_information")) %>%
    as.character()

  sys_info_feed <<- feeds %>%
    select(url) %>%
    filter(str_detect(url, "system_information")) %>%
    as.character()

  stat_status_feed <<- feeds %>%
    select(url) %>%
    filter(str_detect(url, "station_status")) %>%
    as.character()

  if ("free_bike_status" %in% feeds$name) {
    fbs_feed <<- feeds %>%
      select(url) %>%
      filter(str_detect(url, "free_bike_status")) %>%
      as.character()
  }

  if ("system_hours" %in% feeds$name) {
    sys_hours_feed <<- feeds %>%
      select(url) %>%
      filter(str_detect(url, "system_hours")) %>%
      as.character()
  }

  if ("system_calendar" %in% feeds$name) {
    sys_cal_feed <<- feeds %>%
      select(url) %>%
      filter(str_detect(url, "system_calendar")) %>%
      as.character()
  }

  if ("system_regions" %in% feeds$name) {
    sys_reg_feed <<- feeds %>%
      select(url) %>%
      filter(str_detect(url, "system_regions")) %>%
      as.character()
  }

  if ("system_pricing_plans" %in% feeds$name) {
    sys_price_feed <<- feeds %>%
      select(url) %>%
      filter(str_detect(url, "system_pricing_plans")) %>%
      as.character()
  }

  if ("system_alerts" %in% feeds$name) {
    sys_alerts_feed <<- feeds %>%
      select(url) %>%
      filter(str_detect(url, "system_alerts")) %>%
      as.character()
  }

}

get_gbfs <- function(city, feeds = "all", directory = "gbfs_data") {

  city_to_url(city = city)

  gbfs <- fromJSON(txt = url)

  gbfs_feeds <- gbfs$data$en$feeds

# get feeds
  stat_info_feed <- gbfs_feeds %>%
    select(url) %>%
    filter(str_detect(url, "station_information")) %>%
    as.character()

  sys_info_feed <- gbfs_feeds %>%
    select(url) %>%
    filter(str_detect(url, "system_information")) %>%
    as.character()

  stat_status_feed <- gbfs_feeds %>%
    select(url) %>%
    filter(str_detect(url, "station_status")) %>%
    as.character()

  if ("free_bike_status" %in% gbfs_feeds$name) {
    fbs_feed <- gbfs_feeds %>%
      select(url) %>%
      filter(str_detect(url, "free_bike_status")) %>%
      as.character()
  }

  if ("system_hours" %in% gbfs_feeds$name) {
    sys_hours_feed <- gbfs_feeds %>%
      select(url) %>%
      filter(str_detect(url, "system_hours")) %>%
      as.character()
  }

  if ("system_calendar" %in% gbfs_feeds$name) {
    sys_cal_feed <- gbfs_feeds %>%
      select(url) %>%
      filter(str_detect(url, "system_calendar")) %>%
      as.character()
  }

  if ("system_regions" %in% gbfs_feeds$name) {
    sys_reg_feed <- gbfs_feeds %>%
      select(url) %>%
      filter(str_detect(url, "system_regions")) %>%
      as.character()
  }

  if ("system_pricing_plans" %in% gbfs_feeds$name) {
    sys_price_feed <- gbfs_feeds %>%
      select(url) %>%
      filter(str_detect(url, "system_pricing_plans")) %>%
      as.character()
  }

  if ("system_alerts" %in% gbfs_feeds$name) {
    sys_alerts_feed <- gbfs_feeds %>%
      select(url) %>%
      filter(str_detect(url, "system_alerts")) %>%
      as.character()
  }

# create directory
if (!dir.exists(directory)) {
  dir.create(directory)
}

# call functions
  if (feeds == "all" | feeds == "static") {
    get_station_information(stat_info_feed, paste(directory, "/station_information.rds", sep = ""))
    get_system_information(sys_info_feed, paste(directory, "/system_information.rds", sep = ""))
    if (exists("sys_hours_feed")) {
      get_system_hours(sys_hours_feed, paste(directory, "/system_hours.rds", sep = ""))
    }
    if (exists("sys_cal_feed")) {
      get_system_calendar(sys_cal_feed, paste(directory, "/system_calendar.rds", sep = ""))
    }
    if (exists("sys_reg_feed")) {
      get_system_regions(sys_reg_feed, paste(directory, "/system_regions.rds", sep = ""))
    }
    if (exists("sys_price_feed")) {
      get_system_pricing_plans(sys_price_feed, paste(directory, "/system_pricing_plans.rds", sep = ""))
    }
    if (exists("sys_alerts_feed")) {
      get_system_alerts(sys_alerts_feed, paste(directory, "/system_alerts.rds", sep = ""))
    }
  }

  if (feeds == "all" | feeds == "dynamic") {
    get_station_status(stat_status_feed, paste(directory, "/station_status.rds", sep = ""))
    if (exists("fbs_feed")) {
      get_free_bike_status(fbs_feed, paste(directory, "/free_bike_status.rds", sep = ""))
    }
  }

}



