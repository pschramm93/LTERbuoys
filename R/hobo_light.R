#Function to read HOBO light and temp pendant data
#Written by PJS 9/2020

##updates  1/14/2022 PJS  --Added QC for duplicated dates and times--I think this is where an issue came from at one point...

#It's a bit of a mess and very specific to formatting, needs fixing but low on priority list

hobo_light=function(light_file,depth.light,deploy,retrieve){
  if (is.null(light_file)){stop("No light file")}
  if (missing(light_file)){stop("Please provide file path for Hobo light sensor CSV")}
  if (missing(depth.light)){stop("Please provide depth of Light sensor")}


  light=read.table(light_file,skip=1,sep = ',',header = T) #Read in data
  names(light)=c("rec_num",'date_cdt','temp',paste('lux_',depth.light,'cm',sep=""))   #set names
  #light$date_cdt=as.POSIXct(light$date_cdt,tz='America/Chicago','%m/%d/%y %H:%M:%S')  #make times POSIX format
  light$date_cdt=as.POSIXct(light$date_cdt,tz='America/Chicago','%m/%d/%y %I:%M:%S %p')  #make times POSIX format, AM/PM

  light$date_time_UTC=format(light$date_cdt,tz="UTC",usetz=T)                             #make UTC column
  light$date_time_UTC=as.POSIXct(light$date_time_UTC,tz="UTC",'%Y-%m-%d %H:%M:%S')

  #untested, seems to work tho...
  light$date_time_UTC=round(light$date_time_UTC,"mins")                   #round time stamps to minute
  light$date_time_UTC=as.POSIXct(light$date_time_UTC)                                 #convert back to POSIX

#remove unwanted columns
  light=within(light,rm(list=c('rec_num','date_cdt')))

  #Subset data to deployment interval
  if (missing(deploy)||missing(retrieve)){
    #proceed to return the data
    message("No deployment or retrieval times given, data not subseted")
  } else{
    #Subset data to deployment interval
    light=subset(light,date_time_UTC>=deploy &
                   date_time_UTC<=retrieve)
  }

  #Check for duplicated time stamps
  if (anyDuplicated(light$date_time_UTC)!=0){stop("Duplicated Dates/Times")}
  plot(light$date_time_UTC,light[,1],xlab = "Month",ylab="Lux")

  return(light)
}
