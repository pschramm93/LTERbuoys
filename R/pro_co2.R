##Function to load data from ProOceanus CO2 sensors
##Written by PJS 9/2020

##updated 10/2021 PJS--added warnings and stops if the inputs not met
##                   --added option to not have the deploy and retrieve times

#

pro_co2=function(co2_file,depth.co2,deploy,retrieve){
  if (missing(co2_file)){stop("Please provide file path for concatenated ProOceanus co2 file")}
  if (missing(depth.co2)){stop("Please provide depth of ProOceanus sensor")}
  #Read in co2 file
  co2=read.table(co2_file,sep=",",header = T)

  #add leading 0's to time
  co2$Hour=formatC(co2$Hour,width = 2,format = "d",flag = "0")
  co2$Minute=formatC(co2$Minute,width = 2,format = "d",flag = "0")
  co2$Second=formatC(co2$Second,width = 2,format = "d",flag = "0")

  #Combine date and time to single element
  co2$date_time=paste(co2$Month,"/",co2$Day,"/",co2$Year," ",co2$Hour,":",co2$Minute,":",co2$Second,sep="")
  co2$date_time=as.POSIXct(co2$date_time,tz="America/Chicago",'%m/%d/%Y %H:%M:%S')
  attributes(co2$date_time)$tzone<-"UTC"

  #Remove excess variables
  co2=within(co2,rm(list=c("Measurement.type","Year","Month","Day","Hour","Minute","Second","Reference.A.D","Current.A.D","Pressure.sensor.temperature","IRGA.detector.temperature","Supply.voltage","Board.temperature.A.D","Analog.in.1.A.D","Analog.in.2.A.D")))
  #Change names
  names(co2)=c(paste('co2_ppm_raw_',depth.co2,'_cm',sep=""),paste('co2_ppm_corrected_',depth.co2,'_cm',sep=''),'pressure_co2','date_time_UTC')

  #Subset data to deployment interval
  if (missing(deploy|retrieve )){
    #proceed to return the data
    message("No deployment or retrieval times given")
  } else{
    #Subset data to deployment interval
    co2=subset(co2,date_time_UTC>=deploy &
                 date_time_UTC<=retrieve)
  }

  pro_co2=co2
  message("Data from ProOceanus CO2 sensors should be checked against calibration and corrected")
 return(pro_co2)

}
