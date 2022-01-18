
###ll this junk below was to import seperate hobo files for temp string
##Brute force need to get sh*t done method
##Probably should make a hobo temp string function using the lapply stuff below, got tired so did it manually for escanaba

es_temp_files=list.files(paste(lake_file,"/Temp",sep=""))
es_temp_files=paste(lake_file,"Temp",es_temp_files,sep="/")

es_temp=lapply(es_temp_files,read.csv,skip=2,header=T)
es_temp=lapply(es_temp,setNames, nm =c("date_time_cen","tempC","lux"))

es_temp2=lapply(es_temp,function(x) as.POSIXct(es_temp$date_time_cen,tz="America/Chicago",format="%m/%d/%Y %H:%M"))
es_temp2=lapply(es_temp$)


es_temp2=lapply(es_temp,subset,date_time_UTC>=deploy &
                                date_time_UTC<=retrieve))



temp_1=read.csv(es_temp_files[1],skip=2,header = T,col.names=c("date_time_utc","tempC_16cm","lux_16cm"))
  temp_1$date_time_utc=as.POSIXct(temp_1$date_time_utc,tz="America/Chicago",format="%m/%d/%Y %H:%M")
  attributes(temp_1$date_time_utc)$tzone<-"UTC"
temp_2=read.csv(es_temp_files[2],skip=2,header = T,col.names=c("date_time_utc","tempC_99cm","lux_99cm"))
  temp_2$date_time_utc=as.POSIXct(temp_2$date_time_utc,tz="America/Chicago",format="%m/%d/%Y %H:%M")
  attributes(temp_2$date_time_utc)$tzone<-"UTC"
temp_3=read.csv(es_temp_files[3],skip=2,header = T,col.names=c("date_time_utc","tempC_199cm","lux_199cm"))
  temp_3$date_time_utc=as.POSIXct(temp_3$date_time_utc,tz="America/Chicago",format="%m/%d/%Y %H:%M")
  attributes(temp_3$date_time_utc)$tzone<-"UTC"
temp_4=read.csv(es_temp_files[4],skip=2,header = T,col.names=c("date_time_utc","tempC_299cm","lux_299cm"))
  temp_4$date_time_utc=as.POSIXct(temp_4$date_time_utc,tz="America/Chicago",format="%m/%d/%Y %H:%M")
  attributes(temp_4$date_time_utc)$tzone<-"UTC"
temp_5=read.csv(es_temp_files[5],skip=2,header = T,col.names=c("date_time_utc","tempC_399cm","lux_399cm"))
  temp_5$date_time_utc=as.POSIXct(temp_5$date_time_utc,tz="America/Chicago",format="%m/%d/%Y %H:%M")
  attributes(temp_5$date_time_utc)$tzone<-"UTC"
temp_6=read.csv(es_temp_files[6],skip=2,header = T,col.names=c("date_time_utc","tempC_499cm","lux_499cm"))
  temp_6$date_time_utc=as.POSIXct(temp_6$date_time_utc,tz="America/Chicago",format="%m/%d/%Y %H:%M")
  attributes(temp_6$date_time_utc)$tzone<-"UTC"
temp_7=read.csv(es_temp_files[7],skip=2,header = T,col.names=c("date_time_utc","tempC_599cm","lux_599cm"))
  temp_7$date_time_utc=as.POSIXct(temp_7$date_time_utc,tz="America/Chicago",format="%m/%d/%Y %H:%M")
  attributes(temp_7$date_time_utc)$tzone<-"UTC"
temp_8=read.csv(es_temp_files[8],skip=2,header = T,col.names=c("date_time_utc","tempC_699cm","lux_699cm"))
  temp_8$date_time_utc=as.POSIXct(temp_8$date_time_utc,tz="America/Chicago",format="%m/%d/%Y %H:%M")
  attributes(temp_8$date_time_utc)$tzone<-"UTC"

  es_temp=merge(temp_1,temp_2,by.x = "date_time_utc",by.y = "date_time_utc",all=T)
    es_temp=es_temp[!duplicated(es_temp$date_time_utc),]
  es_temp=merge(es_temp,temp_3,by.x = "date_time_utc",by.y = "date_time_utc",all=T)
  es_temp=merge(es_temp,temp_4,by.x = "date_time_utc",by.y = "date_time_utc",all=T)
  es_temp=merge(es_temp,temp_5,by.x = "date_time_utc",by.y = "date_time_utc",all=T)
  es_temp=merge(es_temp,temp_6,by.x = "date_time_utc",by.y = "date_time_utc",all=T)
  es_temp=merge(es_temp,temp_7,by.x = "date_time_utc",by.y = "date_time_utc",all=T)
  es_temp=merge(es_temp,temp_8,by.x = "date_time_utc",by.y = "date_time_utc",all=T)

  es_data=merge(es_temp,data.do,by.x = "date_time_utc",by.y="date_time_UTC",all=T)

  es_data=subset(es_data,date_time_utc>=deploy & date_time_utc<=retrieve)
    es_data=es_data[!duplicated(es_data$date_time_utc),]

  write.csv(es_data,paste(lake_file,file_name,sep="/"),row.names = F)


