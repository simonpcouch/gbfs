get_station_status <- function(url, filepath = "data/station_status.rds", cumulative = FALSE) {

#test station_status_feed: "http://biketownpdx.socialbicycles.com/opendata/station_status.json"  
  
#get url
station_status_feed <- url

#save feed
station_status <- fromJSON(txt = station_status_feed)

#extract data, convert to df
station_status_data <- station_status$data$stations

#extract time til next update (in seconds), convert to numeric
station_status_ttl <- station_status$ttl %>%
  as.numeric()

update_ss <- function() {
  if (!file.exists(filepath)) {
    #save the initial file
    saveRDS(station_status_data, file = filepath)
    
    #add a cron job or task schedule, depending on os
    if (.Platform$OS.type == "windows") {
      #code for taskscheduleR
      return("windows :-(")
    } else {
      #code for cronR
      url_arg <- paste0("url = ", station_status_feed)
      cmd <- cron_rscript(rscript = '~/bikeshare-1/R/get_station_status.R', 
                          rscript_args = c(url_arg, "cumulative = TRUE"))
      cron_add(command = cmd, 
               frequency = 'minutely', 
               id = 'get_station_status', 
               description = 'Grabs every minute.')   
      
    }} else {
      #update the current file
      ss <- readRDS(filepath)
      ss_update <- rbind(station_status_data, ss)
      saveRDS(ss_update, file = filepath)
    }
}

#save the new data, method depending on cumulative argument
if (cumulative == TRUE) {
  #code for when cumulative is true: save if new or update if not
  update_ss()
  } else {
  #code for when cumulative is false: just save the file
  saveRDS(station_status_data, file = filepath)
}
}
