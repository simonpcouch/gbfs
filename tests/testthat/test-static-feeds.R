context("static feeds")


test_that("static feeds work", {
  
  get_station_information("portland")
  
  get_system_alerts("portland")
  
  get_system_calendar("portland")
  
  get_system_hours("portland")
  
  get_system_information("portland")
  
  get_system_pricing_plans("portland")
  
  get_system_regions("portland")

})