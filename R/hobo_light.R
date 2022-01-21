#Function to read HOBO light and temp pendant data
#Written by PJS 9/2020

##updates  1/14/2022 PJS  --Added QC for duplicated dates and times--I think this is where an issue came from at one point...
##                        --Added QC plot for LUX
##          1/21/22 PJS   --changed date format to lubridate

#It's a bit of a mess and very specific to formatting, needs fixing but low on priority list

hobo_light=function(light_file,depth.light,time_offset,deploy,retrieve){
  require(lubridate)
  if (is.null(light_file)){stop("No light file")}
  if (missing(light_file)){stop("Please provide file path for Hobo light sensor CSV")}
  if (missing(depth.light)){stop("Please provide depth of Light sensor")}
  if (missing(time_offset)){stop("Please provide time offset, UTC-x")}

  light=read.table(light_file,skip=1,sep = ',',header = T) #Read in data
  names(light)=c("rec_num",'date_time_UTC',paste('temp_hobo_',depth.light,'cm',sep=""),paste('lux_',depth.light,'cm',sep=""))   #set names
  light$date_time_UTC=mdy_hms(paste(light$date,"-0",time_offset,"00",sep=""))
  light$date_time_UTC=round_date(light$date_time_UTC,"minute")


#remove unwanted columns
  light=within(light,rm(list=c('rec_num')))

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
  plot(light$date_time_UTC,light[,grep("lux",names(light))],xlab = "Month",ylab="Lux")

  return(light)
}
