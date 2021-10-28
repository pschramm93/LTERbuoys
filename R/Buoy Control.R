
#Buoy control
#Initial way to run buoy functions for testing pre-package
#Paul Schramm-NTL LTER
#9/14/2020- Ver 1.0

##future updates
##  -change set files to generic names (light, temp, do, etc... to be able to paste into buoy functions)
##  -functions to generate auto QC plots
##  -function to load LTER base crew data for QC checks
##  -function to merge data


##Very Very future updates
##  -Publish internal package (probably not useful to rest of world)
##  -R shiny for setting deploy/retrieve times and file sources...


rm(list=ls())

#Set your working dir and load functions, won't need after published as package
wd=c("C:/Users/Paul/Dropbox/LTER_R/NTLbuoys/R")
source(paste(wd,"/loadbuoyfunc.R",sep=""))
loadbuoyfunc(wd)

#Enter deployment and Retrieval times in UTC
deploy=  as.POSIXct('06/22/2019 08:00',tz='UTC','%m/%d/%Y %H:%M')
retrieve=as.POSIXct('10/31/2019 02:00',tz='UTC','%m/%d/%Y %H:%M')

#Set sensor depths
depth.temp=93
depth.do=153
depth.light=93
depth.chla=158
#depth.co2=185

#set lake ID
lake_ID="CB"

#Set Files, if no data present set to NULL
light= NULL
temp=  'Y:/GLEON/BuoyData/CrystalBog/2019/Temp/063327_20191031_1338/063327_20191031_1338_data.txt'
do=    'B:/BuoyData/TroutBog/2019-2020_underice_TB/DO/TB_do_2019_underice.TXT'
chla=  NULL
co2=   NULL


#Run buoy run
data.do=pme_do(do,depth.do,deploy,retrieve)
data.temp=rbr_temp(lake_ID,temp,depth.temp,deploy,retrieve)
data.light=hobo_light(light,depth.light,deploy,retrieve)
data.chla=pme_chla(chla,depth.chla,deploy,retrieve)
data.co2=pro_co2(co2,depth.co2,deploy,retrieve)


#Round any of those pesky hobo time stamps...
#do this in light function
TB.light$date_time_UTC=round.POSIXt(TB.light$date_time_UTC,unit="mins")
TB.light$date_time_UTC=as.POSIXct(TB.light$date_time_UTC)


#Combine Data
#make function
TB_2019_underice=merge(TB.do,TB.temp,by.x="date_time_UTC",by.y="date_time_UTC",all=T)
TB_2019_underice=merge(TB_2019_underice,TB.light,by.x="date_time_UTC",by.y="date_time_UTC",all = TRUE)
TB_2019_underice=merge(TB_2019_underice,TB.chla,by.x="date_time_UTC",by.y="date_time_UTC",all = TRUE)

#TB_2019_underice=merge(TB_2019_underice,TB.co2,by.x="date_time_UTC",by.y="date_time_UTC",all=TRUE)


#Write Data
write.csv(TB_2019_underice,"B:/BuoyData/TroutBog/2019-2020_underice_TB/TB_2019_underice_chla.csv",row.names = FALSE)
