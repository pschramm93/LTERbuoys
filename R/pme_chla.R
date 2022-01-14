##Function to read chlorophyll values from the concatenated file output PME cyclops sensors
##Written by PJS
##Original function written 9/2020
##update 10/2021--added warnings and stops if the inputs not met
##              --added option to not have the deploy and retrieve times


##Probably won't get anymore updates since we don't really use these anymore, not great sensors

pme_chla<-function(chla_file,depth.chla,deploy,retrieve) {
  if (is.null(chla_file)){stop("No DO file")}
  if (missing(chla_file)){stop("Please provide file path for concatenated PME chloro file")}
  if (missing(depth.chla)){stop("Please provide depth of PME cyclops sensor")}

  #Read in text file
  chla_pme=read.table(chla_file,sep=",",skip=7)
  #rename variables
  names(chla_pme)=c("timestamp","date_time_UTC","time_cen","batt_v","temp_c7_c",paste("chla_",depth.chla,"cm_ppb",sep=''),"Gain")
  #Convert time vector to posix
  chla_pme$date_time_UTC=as.POSIXct(chla_pme$date_time_UTC,tz='GMT','%Y-%m-%d %H:%M:%S')
  #remove extra variables
  chla_pme=within(chla_pme,rm(list=c("time_cen","batt_v","temp_c7_c","timestamp")))

  if (missing(deploy|retrieve )){
    #proceed to return the data
    message("No deployment or retrieval times given")
  } else{
    chla_pme=subset(chla_pme,date_time_UTC>=deploy &
                      date_time_UTC<=retrieve)
  }


  return(chla_pme)
}
