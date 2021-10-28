
#Buoy control
#Initial way to run buoy functions for testing pre-package
#Paul Schramm-NTL LTER
#9/14/2020- Ver 1.0

##future updates
##  -change set files to generic names (light, temp, do, etc... to be able to paste into buoy functions)
##  -functions to generate auto QC plots
##  -function to load LTER base crew data for QC checks


##Very Very future updates
##  -Publish internal package (probably not useful to rest of world)
##  -R shiny for setting deploy/retrieve times and file sources...


rm(list=ls())

#Set your working dir, won't need after published as package
wd=c("C:/Users/Paul/Dropbox/LTER_R/NTLbuoys/R")

#Load functions, won't need after published as package
source(paste(wd,"/loadbuoyfunc.R",sep=""))
loadbuoyfunc(wd)

#Enter deployment and Retrieval times in UTC
deploy=as.POSIXct('11/02/2019 05:00',tz='GMT','%m/%d/%Y %H:%M')
retrieve=as.POSIXct('5/27/2020 05:00',tz='GMT','%m/%d/%Y %H:%M')


#Set Files
TB_2019_light='B:/BuoyData/TroutBog/2019-2020_underice_TB/Light/TB_underice_2020.csv'
TB_2019_temp= 'B:/BuoyData/TroutBog/2019-2020_underice_TB/Temp/062942_20200527_1253/062942_20200527_1253_data.txt'
TB_2019_do=   'B:/BuoyData/TroutBog/2019-2020_underice_TB/DO/TB_do_2019_underice.TXT'
TB_2019_chla= "B:/BuoyData/TroutBog/2019-2020_underice_TB/Chloro/TB_chla_2019_underice.txt"

#TB_2019_co2=  'D:/2019-2020_underice_TR/CO2/2019-2020_underice_TR_co2.txt'
#Set sensor depths
depth.temp=93
depth.do=153
depth.light=93
depth.chla=158
#depth.co2=185

#Run buoy run
##Paste name from set files here for less manual entry
TB.do=pme_do(TB_2019_do,depth.do,deploy,retrieve)
TB.temp=rbr_temp_TB(TB_2019_temp,depth.temp,deploy,retrieve)
TB.light=hobo_light(TB_2019_light,depth.light,deploy,retrieve)
TB.chla=pme_chla(TB_2019_chla,depth.chla,deploy,retrieve)
#TR.co2=pro_co2(TR_2019_co2,depth.co2,deploy,retrieve)

#Round any of those pesky hobo time stamps...
TB.light$date_time_UTC=round.POSIXt(TB.light$date_time_UTC,unit="mins")
TB.light$date_time_UTC=as.POSIXct(TB.light$date_time_UTC)

TB.temp$date_time_UTC=round.POSIXt(TB.temp$date_time_UTC,unit="mins")
TB.temp$date_time_UTC=as.POSIXct(TB.temp$date_time_UTC)

#Chlorophyll


#Combine Data
TB_2019_underice=merge(TB.do,TB.temp,by.x="date_time_UTC",by.y="date_time_UTC",all=T)
TB_2019_underice=merge(TB_2019_underice,TB.light,by.x="date_time_UTC",by.y="date_time_UTC",all = TRUE)
TB_2019_underice=merge(TB_2019_underice,TB.chla,by.x="date_time_UTC",by.y="date_time_UTC",all = TRUE)

#TB_2019_underice=merge(TB_2019_underice,TB.co2,by.x="date_time_UTC",by.y="date_time_UTC",all=TRUE)

#Plot Diagnostics
plot(TB.do$date_time_UTC,TB.do[,3])
plot(TB.temp$date_time_UTC,TB.temp[,2])
points(TB.temp$date_time_UTC,TB.temp[,length(TB.temp)],col="blue")
plot(TR.co2$date_time_UTC,TR.co2$pressure_co2)


#Write Data
write.csv(TB_2019_underice,"B:/BuoyData/TroutBog/2019-2020_underice_TB/TB_2019_underice_chla.csv",row.names = FALSE)
