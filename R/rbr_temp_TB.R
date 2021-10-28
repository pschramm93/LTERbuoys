#Function to read RBR temperature string data for TB
#written by PJS-9/2020
#update 10/2021--see new rbr_temp function, combined all lakes into one function
#                for less function loading and easier QC checks

rbr_temp_TB<-function(temp_file,depth.temp,deploy,retrieve){
  #read in temperatures
  temp=read.table(temp_file,sep=",",skip=1)
  #set names
  names(temp)=c("time_UTC","d1","d2","d3","d4","d5","d6","d7","d8","d9","d10","d11","d12","d13","d14","d15","d16","d17","d18","d19","d20")
  #Declare time as Posix
  temp$time_UTC=as.POSIXct(temp$time_UTC,tz="America/Chicago",'%Y-%m-%d %H:%M:%OS')
  attributes(temp$time_UTC)$tzone<-"UTC"
  #Reverse order of temps, since RBR thinks we want the bottom temps first...
  temp2=temp[,c(1,21,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2)]

  #Set names of columns based on depth of sensors(build depth vector,add tempC_z_cm to names,set names)
  names_temp=c(depth.temp+0,depth.temp+25,depth.temp+50,depth.temp+75,depth.temp+100,depth.temp+125,depth.temp+150,depth.temp+175,depth.temp+200,depth.temp+225,depth.temp+250,depth.temp+275,depth.temp+325,
               depth.temp+375,depth.temp+425,depth.temp+475,depth.temp+525,depth.temp+575,depth.temp+625,depth.temp+675)
  names_temp=paste('tempC_',names_temp,'_cm',sep='')
  names(temp2)=c("date_time_UTC",names_temp)

  #Subset data to deployment interval
  temp2=subset(temp2,date_time_UTC>=deploy &
                 date_time_UTC<=retrieve)


  #Rename dataframe
  #Should probably get rid of this after some testing...
  rbr_temp=temp2

  #Send datatable out
  return(rbr_temp)
}
