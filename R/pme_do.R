##Function to read DO values from the concatenated file output PME miniDOT sensors
##Written by PJS
##Original function written 9/2020
##update 10/2021 PJS--added warnings and stops if the inputs not met
##                  --added option to not have the deploy and retrieve times


##Future additions--check Q values to make sure data is good
##                --check DO values within reasonable range 0-12 mgl and 0-120(?)%
##                --check to make sure deploy and retrieve in posixct format
##                --QC to check if quick temp change indicating removed/placed in lake after subsetting

pme_do<-function(do_file,depth.do,deploy,retrieve) {

  if (missing(do_file)){stop("Please provide file path for concatenated PME do file")}
  if (missing(depth.do)){stop("Please provide depth of PME do sensor")}

  #Read in text file
  do_pme=read.table(do_file,sep=",",skip=9)
  #rename variables
  names(do_pme)=c("timestamp","date_time_UTC","time_cen","batt_v","temp_minidot_c",paste("do_mgl_",depth.do,'cm',sep=''),paste("do_sat_",depth.do,'cm',sep=''),"Q")
  #Convert time vector to posix
  do_pme$date_time_UTC=as.POSIXct(do_pme$date_time_UTC,tz='GMT','%Y-%m-%d %H:%M:%S')
  #remove extra variables
  do_pme=within(do_pme,rm(list=c("time_cen","Q","timestamp","batt_v")))

  if (missing(deploy|retrieve )){
    #proceed to return the data
    message("No deployment or retrieval times given")
  } else{
  #Subset data to deployment interval
  do_pme=subset(do_pme,date_time_UTC>=deploy &
                 date_time_UTC<=retrieve)
  }

  return(do_pme)
}
