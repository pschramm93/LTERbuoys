#Function to read RBR temperature string data for SP
#written by PJS-9/2020
#update 10/2021--see new rbr_temp function, combined all lakes into one function
#                for less function loading and easier QC checks

rbr_temp_SP<-function(temp_file,depth.temp,deploy,retrieve){
  #read in temperatures
  temp=read.table(temp_file,sep=",",skip=1)
  #set names
  names(temp)=c("time_UTC","d1","d2","d3","d4","d5","d6","d7","d8","d9","d10","d11","d12","d13","d14","d15","d16","d17","d18","d19","d20","d21","d22","d23","d24")
  #Declare time as Posix
  temp$time_UTC=as.POSIXct(temp$time_UTC,tz="America/Chicago",'%Y-%m-%d %H:%M:%OS')
  attributes(temp$time_UTC)$tzone<-"UTC"
  #Reverse order of temps, since RBR thinks we want the bottom temps first...
  temp2=temp[,c(1,25,24,23,22,21,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2)]

  #Set names of columns based on depth of sensors(build depth vector,add tempC_z_cm to names,set names)
  names_temp=c(depth+0,depth+25,depth+50,depth+75,depth+100,depth+125,depth+175,depth+225,depth+275,depth+325,depth+375,depth+425,depth+475,
               depth+575,depth+675,depth+775,depth+875,depth+975,depth+10275,depth+1175,depth+1275,depth+1375,depth+1575,depth+1775)
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
