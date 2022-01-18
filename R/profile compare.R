profile_data=read.table("Y:/GLEON/Profile Data/CB_2019.txt",sep=",",header=T)

profile_data=reshape(profile_data,idvar="SAMPLEDATE",timevar = "DEPTH",direction = "wide")

names(profile_data)=c("sampledate","lakeid","temp_0m","flag_temp_0m","do_0m","flag_do_0m","lakeid2",
                      "temp_1m","flag_tmep_1m","do_1m","flag_do_1m","lakeid3","temp_2m","flag_temp_2m",
                      "do_2m","flag_do_2m")
profile_data$sampledate=as.POSIXct(profile_data$sampledate,tz='GMT','%m/%d/%Y')
profile_data$sampledate=profile_data$sampledate+(17*60*60)

plot(data$date_time_UTC,data$tempC_90_cm)
points(profile_data$sampledate,profile_data$temp_1m,col="magenta",pch=2)

plot(data$date_time_UTC,data$tempC_215_cm)
points(profile_data$sampledate,profile_data$temp_2m,col="magenta",pch=2)
points(data$date_time_UTC,data$tempC_215_cm,col="blue")

plot(data$date_time_UTC,data$tempC_15_cm)
points(profile_data$sampledate,profile_data$temp_0m,col="magenta",pch=2)

plot(data$date_time_UTC,data$lux_15cm)
