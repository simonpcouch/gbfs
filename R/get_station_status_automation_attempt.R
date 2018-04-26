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

#save the new data, method depending on cumulative argument
if (cumulative == TRUE) {
    if (!file.exists(filepath)) {
      #save the initial file
      saveRDS(station_status_data, file = filepath)
      #add a cron job or task schedule, depending on os
        if (.Platform$OS.type == "windows") {
        #code for taskscheduleR
        return("Automation functionality has not yet been implemented for Windows machines.")
      } else {
        x <- system.file("R", "update_ss.R", package="gbfs")
        arg1 <- paste0("station_status_feed = ", station_status_feed)
        arg2 <- paste0("filepath = ", filepath)
        #code for cronR
        cmd <- cron_rscript(rscript = '~/R/update_ss.R', 
                            rscript_args = c(arg1, arg2))
        cron_add(command = cmd, 
                 frequency = 'minutely', 
                 id = 'get_station_status', 
                 description = 'Grabs every minute.')   
      
    } else {
    #append rows
    ss <- readRDS(filepath)
    ss_update <- rbind(station_status_data, ss)
    saveRDS(ss_update, file = filepath)
  }} else {
    #code for when cumulative is false: just save the file
    saveRDS(station_status_data, file = filepath)
  }}
}
