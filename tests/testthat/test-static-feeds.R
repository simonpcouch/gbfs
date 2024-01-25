context("static feeds")


test_that("static feeds work", {
  
  skip_if_offline(host = "r-project.org")
  
  get_station_information("https://gbfs.lyft.com/gbfs/1.1/pdx/en/station_information.json")
  
  get_system_alerts("https://gbfs.lyft.com/gbfs/1.1/pdx/en/system_alerts.json")
  
  get_system_calendar("https://gbfs.lyft.com/gbfs/1.1/pdx/en/system_calendar.json")
  
  get_system_hours("https://gbfs.lyft.com/gbfs/1.1/pdx/en/system_hours.json")
  
  get_system_information("https://gbfs.lyft.com/gbfs/1.1/pdx/en/system_information.json")
  
  get_system_regions("https://gbfs.lyft.com/gbfs/1.1/pdx/en/system_regions.json")
})
