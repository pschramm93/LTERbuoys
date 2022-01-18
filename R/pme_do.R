##Function to read DO values from the concatenated file output PME miniDOT sensors
##Written by PJS
##Original function written 9/2020
##update 10/2021    PJS--added warnings and stops if the inputs not met
##                     --added option to not have the deploy and retrieve times
##update 1/14/2022  PJS--added QC check for values less than 0 and greater than 15
##                     --added QC check for Q values
##                     --added QC check for battery voltage (probably not needed)
##                     --added QC plot
##Future additions
##                --check to make sure deploy and retrieve in posixct format
##                --QC to check if quick temp change indicating removed/placed in lake after subsetting
##                --add do flag when Q is less than 0.7
##                  data$do_flag=ifelse(data$DO_Qfactor<0.7,"V",NA)


pme_do<-function(do_file,depth.do,deploy,retrieve) {
  if (is.null(do_file)){stop("No DO file")}
  if (missing(do_file)){stop("Please provide file path for concatenated PME do file")}
  if (missing(depth.do)){stop("Please provide depth of PME do sensor")}

  #Read in text file
  do_pme=read.table(do_file,sep=",",skip=9)
  #rename variables
  names(do_pme)=c("timestamp","date_time_UTC","time_cen","batt_v","temp_minidot_c",paste("do_mgl_",depth.do,'cm',sep=''),paste("do_sat_",depth.do,'cm',sep=''),"Q")
  #Convert time vector to posix
  do_pme$date_time_UTC=as.POSIXct(do_pme$date_time_UTC,tz='UTC','%Y-%m-%d %H:%M:%S')

  #QC check on the Q value and battery

  if(any((do_pme$Q<0.9)=="TRUE")){print("Q factor less than 0.9")}
  if(any((do_pme$Q<0.75)=="TRUE")){{do_pme$do_flag=ifelse(do_pme$Q<0.7,"V",NA)}}

  if(any((do_pme$Q>1.15)=="TRUE")){print("Q factor greater tha 1.15, not sure if this is bad...")}
  if(any((do_pme$batt_v<2.5)=="TRUE")){print("Battery less than 2.5V")}

  #remove extra variables
  do_pme=within(do_pme,rm(list=c("time_cen","timestamp","batt_v")))

  if (missing(deploy)||missing(retrieve)){
    #proceed to return the data
    message("No deployment or retrieval times given")
  } else{
  #Subset data to deployment interval
  do_pme=subset(do_pme,date_time_UTC>=deploy &
                 date_time_UTC<=retrieve)
  }

  #QC

 if(any(do_pme[grep("do_mgl",names(do_pme))]<0)=="TRUE") {stop("DO less than 0")}
 if(any(do_pme[grep("do_mgl",names(do_pme))]>15)=="TRUE"){stop("DO greater than 15mg/L")}

plot(do_pme$date_time_UTC,do_pme[,grep("do_mgl",names(do_pme))])

  return(do_pme)
}
