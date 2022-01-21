
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
library(lubridate)

rm(list=ls())

#Set your working dir and load functions, won't need after published as package
wd=c("C:/Users/Paul/Dropbox/LTER_R/NTLbuoys/R")
source(paste(wd,"/loadbuoyfunc.R",sep=""))
loadbuoyfunc(wd)


#Enter deployment and Retrieval times in UTC
deploy=  mdy_hm('06/22/2019 08:00')
retrieve=mdy_hm('10/31/2019 10:00')

#Set sensor depths
depth.temp=10
depth.do=75
depth.light=25
depth.chla=70
depth.co2=NULL

#set time offsets
rbr_timeoffset=6
hobo_timeoffset=5


#set lake ID for temp string
lake_ID="TB"

#Set output file name
file_name="TB_2019.csv"

#Set Files, if no data present set to NULL
lake_file=  'Y:/GLEON/BuoyData/TroutBog/2019'
do_file=paste(lake_file,"DO/TB_2019_DO.txt",sep="/")
temp_file=paste(lake_file,"Temp/062942_20191031_1439/062942_20191031_1439_data.txt",sep="/")
light_file=paste(lake_file,"Light/TB_underice_2019.csv",sep="/")
chla_file=paste(lake_file,"chloro/TB_chloro_2019.TXT",sep="/")

co2_file=   NULL



#Run buoy run--Shouldn't need to change

data.do=pme_do(do_file,depth.do,deploy,retrieve)
data.temp=rbr_temp(lake_ID,temp_file,time_offset=rbr_timeoffset,depth.temp,deploy,retrieve)
data.light=hobo_light(light_file,time_offset=hobo_timeoffset,depth.light,deploy,retrieve)
data.chla=pme_chla(chla_file,depth.chla,deploy,retrieve)

data.co2=pro_co2(co2_file,depth.co2,deploy,retrieve)



##Needs automation for merging...

#get dataframes that have "data." pattern
#param_list=ls(envir = .GlobalEnv)[grep(pattern = "data.",x=ls(envir = .GlobalEnv))]


data=merge(data.do,data.temp,by.x="date_time_UTC",by.y="date_time_UTC",all=T)
data=merge(data,data.light,by.x="date_time_UTC",by.y="date_time_UTC",all = T)

data=merge(data,data.chla,by.x="date_time_UTC",by.y="date_time_UTC",all = TRUE)


#QC Check for date times duplicates...all other QC is done within functions
if (anyDuplicated(data$date_time_UTC)!=0){stop("Duplicated Dates/Times")}

#Write Data
write.csv(data,paste(lake_file,file_name,sep="/"),row.names = FALSE)
