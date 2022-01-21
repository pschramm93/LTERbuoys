##Function to read chlorophyll values from the concatenated file output PME cyclops sensors
##Written by PJS
##Original function written 9/2020
##update 10/2021   PJS--added warnings and stops if the inputs not met
##                    --added option to not have the deploy and retrieve times
##       1/21/2022 PJS--added plot QC plot
##                    --changed time format to lubridate


##Probably won't get anymore updates since we don't really use these anymore, not great sensors

pme_chla<-function(chla_file,depth.chla,deploy,retrieve) {
  require(lubridate)
  if (is.null(chla_file)){stop("No Chloro file")}
  if (missing(chla_file)){stop("Please provide file path for concatenated PME chloro file")}
  if (missing(depth.chla)){stop("Please provide depth of PME cyclops sensor")}

  #Read in text file
  chla_pme=read.table(chla_file,sep=",",skip=7)
  #rename variables
  names(chla_pme)=c("timestamp","date_time_UTC","time_cut","batt_v","temp_c7_c",paste("chla_",depth.chla,"cm_ppb",sep=''),"Gain")
  #Convert time vector to posix
  chla_pme$date_time_UTC=ymd_hms(chla_pme$date_time_UTC)

  #remove extra variables
  chla_pme=within(chla_pme,rm(list=c("time_cut","batt_v","temp_c7_c","timestamp")))

  if (missing(deploy)||missing(retrieve)){
    #proceed to return the data
    message("No deployment or retrieval times given")
  } else{
    #Subset data to deployment interval
    chla_pme=subset(chla_pme,date_time_UTC>=deploy &
                    date_time_UTC<=retrieve)
  }

  plot(chla_pme$date_time_UTC,chla_pme[,grep("chla_",names(chla_pme))])

  return(chla_pme)
}
