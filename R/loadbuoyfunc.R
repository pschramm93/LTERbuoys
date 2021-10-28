##Function to load all of the NTL buoy functions
##Written by PJS 10/2021

##Won't need this function after published as package, just for testing...


loadbuoyfunc<-function(wd){
  setwd(wd)
  source("hobo_light.R")
  source("pme_chla.R")
  source("pme_do.R")
  source( "pro_co2.R")
  source("rbr_temp_CB.R")
  source("rbr_temp_SP.R")
  source("rbr_temp_TB.R")
  source("rbr_temp_TR.R" )
  source("rbr_temp.R")
}
