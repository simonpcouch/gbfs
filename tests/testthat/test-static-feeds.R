context("static feeds")


test_that("static feeds work", {
  
  skip_if_offline(host = "r-project.org")
  
  get_station_information("https://gbfs.biketownpdx.com/gbfs/en/station_information.json")
  
  get_system_alerts("https://gbfs.biketownpdx.com/gbfs/en/system_alerts.json")
  
  get_system_calendar("https://gbfs.biketownpdx.com/gbfs/en/system_calendar.json")
  
  get_system_hours("https://gbfs.biketownpdx.com/gbfs/en/system_hours.json")
  
  get_system_information("https://gbfs.biketownpdx.com/gbfs/en/system_information.json")
  
  get_system_regions("https://gbfs.biketownpdx.com/gbfs/en/system_regions.json")
  
  get_system_pricing_plans("https://gbfs.bcycle.com/bcycle_greenville/system_pricing_plans.json")
})
