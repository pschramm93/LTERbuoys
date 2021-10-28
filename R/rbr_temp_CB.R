#Function to read RBR temperature string data for CB
#written by PJS-9/2020
#update 10/2021--see new rbr_temp function, combined all lakes into one function
#                for less function loading and easier QC checks

rbr_temp_CB<-function(temp_file,depth.temp){
  #read in temperatures
  temp=read.table(temp_file,sep=",",skip=1)
  #set names
  names(temp)=c("time_UTC","d1","d2","d3","d4","d5","d6","d7","d8","d9","d10","d11")
  #Declare time as Posix
  temp$time_UTC=as.POSIXct(temp$time_UTC,tz="America/Chicago",'%Y-%m-%d %H:%M:%OS')
  attributes(temp$time_UTC)$tzone<-"UTC"
  #Reverse order of temps, since RBR thinks we want the bottom temps first...
  temp2=temp[,c(1,21,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2)]

  #Set names of columns based on depth of sensors(build depth vector,add tempC_z_cm to names,set names)
  names_temp=c(depth+0,depth+25,depth+50,depth+75,depth+100,depth+125,depth+150,depth+175,depth+200)
  names_temp=paste('tempC_',names_temp,'_cm',sep='')
  names(temp2)=c("date_time_UTC",names_temp)

  #Rename dataframe
  #Should probably get rid of this after some testing...
  rbr_temp=temp2

  #Send datatable out
  return(rbr_temp)
}
