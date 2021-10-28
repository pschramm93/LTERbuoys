#Function to read HOBO light and temp pendant data
#Written by PJS 9/2020
#It's a bit of a mess and very specific to formatting, needs fixing but low on
#priority list

hobo_light=function(light_file,depth.light,deploy,retrieve){
  light=read.table(light_file,skip=1,sep = ',',header = T)
  names(light)=c("rec_num",'date_cdt','temp',paste('lux_',depth.light,'cm',sep=""))
  light$date_cdt=as.POSIXct(light$date_cdt,tz='America/Chicago','%m/%d/%y %H:%M:%S')
  attributes(light$date_cdt)$tzone<-"GMT"
  light$date_time_UTC=light$date_cdt

  light=within(light,rm(list=c('rec_num','date_cdt','temp')))

  #Subset data to deployment interval
  light=subset(light,date_time_UTC>=deploy &
                     date_time_UTC<=retrieve)

}
