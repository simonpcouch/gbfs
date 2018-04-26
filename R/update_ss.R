  #needs to somehow be supplied station_status_feed and filepath from the crontab

  #test station_status_feed: "http://biketownpdx.socialbicycles.com/opendata/station_status.json"  
  
  #somehow get station_status feed
  station_status_feed
  
  #save feed
  station_status <- fromJSON(txt = station_status_feed)
  
  #extract data, convert to df
  station_status_data <- station_status$data$stations
  
  #extract time til next update (in seconds), convert to numeric
  station_status_ttl <- station_status$ttl %>%
    as.numeric()
  
  #append rows
  ss <- readRDS(filepath)
  ss_update <- rbind(station_status_data, ss)
  saveRDS(ss_update, file = filepath)