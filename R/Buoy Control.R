
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
deploy=  as.POSIXct('06/11/2021 22:00',tz='UTC','%m/%d/%Y %H:%M')
retrieve=as.POSIXct('11/08/2021 10:00',tz='UTC','%m/%d/%Y %H:%M')

#Set sensor depths
depth.temp=NULL
depth.do=45
depth.light=75
depth.light2=225

depth.chla=NULL
depth.co2=NULL

#set lake ID for temp string
lake_ID="CB"

#Set output file name
file_name="CB_2021.csv"

#Set Files, if no data present set to NULL
lake_file=  'Y:/GLEON/BuoyData/CrystalBog/2021'
do_file=paste(lake_file,"DO/CB_2021_do.txt",sep="/")
temp_file=paste(lake_file,"Temp/063327_20201028_1708/063327_20201028_1708_data.txt",sep="/")
light_file=paste(lake_file,"Light/CB_50cm.csv",sep="/")
light_file2=paste(lake_file,"Light/CB_2m.csv",sep="/")

chla_file=  NULL
co2_file=   NULL



#Run buoy run--Shouldn't need to change

data.do=pme_do(do_file,depth.do,deploy,retrieve)
data.temp=rbr_temp(lake_ID,temp_file,depth.temp,deploy,retrieve)
data.light=hobo_light(light_file,depth.light,deploy,retrieve)
data.light2=hobo_light(light_file2,depth.light2,deploy,retrieve)

data.chla=pme_chla(chla_file,depth.chla,deploy,retrieve)
data.co2=pro_co2(co2_file,depth.co2,deploy,retrieve)



##Needs automation for merging...

#get dataframes that have "data." pattern
#param_list=ls(envir = .GlobalEnv)[grep(pattern = "data.",x=ls(envir = .GlobalEnv))]


data=merge(data.do,data.temp,by.x="date_time_UTC",by.y="date_time_UTC",all=T)
data=merge(data,data.light,by.x="date_time_UTC",by.y="date_time_UTC",all = T)

data=merge(data,data.co2,by.x="date_time_UTC",by.y="date_time_UTC",all = TRUE)


#QC Check for date times duplicates...all other QC is done within functions
if (anyDuplicated(data$date_time_UTC)!=0){stop("Duplicated Dates/Times")}

#Write Data
write.csv(data,paste(lake_file,file_name,sep="/"),row.names = FALSE)
