#Function to read HOBO light and temp pendant data
#Written by PJS 9/2020
#It's a bit of a mess and very specific to formatting, needs fixing but low on
#priority list

hobo_light=function(light_file,depth.light,deploy,retrieve){
  if (is.null(light_file)){stop("No light file")}
  if (missing(light_file)){stop("Please provide file path for Hobo light sensor CSV")}
  if (missing(depth.light)){stop("Please provide depth of Light sensor")}


  light=read.table(light_file,skip=1,sep = ',',header = T) #Read in data
  names(light)=c("rec_num",'date_cdt','temp',paste('lux_',depth.light,'cm',sep=""))   #set names
  light$date_cdt=as.POSIXct(light$date_cdt,tz='America/Chicago','%m/%d/%y %H:%M:%S')  #make times POSIX format
  attributes(light$date_cdt)$tzone<-"UTC"                                             #Convert to UTC
  light$date_time_UTC=light$date_cdt                                                  #make UTC column

  #untested
  light$date_time_UTC=round.POSIXt(light$date_time_UTC,unit="mins")                   #round time stamps to minute
  light$date_time_UTC=as.POSIXct(light$date_time_UTC)                                 #convert back to POSIX

#remove unwanted columns
  light=within(light,rm(list=c('rec_num','date_cdt','temp')))

  #Subset data to deployment interval
  if (missing(deploy)||missing(retrieve)){
    #proceed to return the data
    message("No deployment or retrieval times given, data not subseted")
  } else{
    #Subset data to deployment interval
    light=subset(light,date_time_UTC>=deploy &
                   date_time_UTC<=retrieve)
  }
}
