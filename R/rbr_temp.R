##Function for reading in RBR temperature data for all NTL lakes
##Written by PJS 10/2021

##this is an update from the individual lake functions written 9/2020 (see rbr_temp_xxlakeid.R)

##Update  1/14/2022 PJS--added QC checks for temps above 30c
##                     --added QC check comparing surface mean to bottom mean, to make sure data not reversed

##Future additions
##                --make sure deploy/retrieve is posix
##
##                --QC to check if quick temp change indicating removed/placed in lake after subsetting


rbr_temp=function(lake,temp_file,depth.temp,deploy,retrieve){

  #Check if all args are present
  if (is.null(temp_file)){stop("No rbr Temp file")}
  if (missing(lake)){stop("Please provide NTL lake ID")}
  if(lake %in% c("TB","CB","SP","TR","ME")){
        #Good job you entered a valid lake ID
  } else{
    stop("Please provide valid NTL lake ID (CB,TB,SP,TR,ME)")
  }

  if (missing(temp_file)){stop("Please provide file path for RBR temperature data")}
  if (missing(depth.temp)){stop("Please provide depth of first temp node")}


  if (lake=="TB"){
    #do TB stuff
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


  } else if (lake=="CB"){
    #do CB stuff
    #read in temperatures
    temp=read.table(temp_file,sep=",",skip=1)
    #set names
    names(temp)=c("time_UTC","d1","d2","d3","d4","d5","d6","d7","d8","d9")
    #Declare time as Posix
    temp$time_UTC=as.POSIXct(temp$time_UTC,tz="America/Chicago",'%Y-%m-%d %H:%M:%OS')
    attributes(temp$time_UTC)$tzone<-"UTC"
    #Reverse order of temps, since RBR thinks we want the bottom temps first...
    temp2=temp[,c(1,10,9,8,7,6,5,4,3,2)]

    #Set names of columns based on depth of sensors(build depth vector,add tempC_z_cm to names,set names)
    names_temp=c(depth.temp+0,depth.temp+25,depth.temp+50,depth.temp+75,depth.temp+100,
                 depth.temp+125,depth.temp+150,depth.temp+175,depth.temp+200)
    names_temp=paste('tempC_',names_temp,'_cm',sep='')
    names(temp2)=c("date_time_UTC",names_temp)


  } else if (lake=="SP"){
    #do SP stuff
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




  } else if (lake=="TR"){
    #do TR stuff
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
    names_temp=c(depth.temp+0,depth.temp+25,depth.temp+50,depth.temp+75,depth.temp+125,depth.temp+175,depth.temp+225,depth.temp+275,depth.temp+325,depth.temp+375,depth.temp+475,depth.temp+575,depth.temp+675,
                 depth.temp+775,depth.temp+875,depth.temp+975,depth.temp+1075,depth.temp+1175,depth.temp+1275,depth.temp+1375,depth.temp+1575,depth.temp+1975,depth.temp+2475,depth.temp+2975)
    names_temp=paste('tempC_',names_temp,'_cm',sep='')
    names(temp2)=c("date_time_UTC",names_temp)



  }else if (lake=="ME") {
    message("Lake Mendota isn't quite done yet...")
  }else{
    #not valid lake
    #If should never get here but just in case
    message("Please enter a valid NTL lake ID (CB,TB,SP,TR,ME)")
  }

  if (missing(deploy)||missing(retrieve)){
    #proceed to return the data
    message("No deployment or retrieval times given, data not subseted")
  } else{
    #Subset data to deployment interval
    temp2=subset(temp2,date_time_UTC>=deploy &
                    date_time_UTC<=retrieve)
         #Message if temp data is less than -30, indicating string not attached
         #Only do if subsetting data
          if (min(temp2[,2])<0){
             message("Temperate is less than -20, temp string likely not attached")
            }
  }

  if(any(temp2[grep("tempC_",names(temp2))][,1]>30)=="TRUE"){message("Temperature above 30c")}
  if(mean(temp2[grep("tempC_",names(temp2))][,1]) <
     mean(temp2[grep("tempC_",names(temp2))][,length(temp2[grep("tempC_",names(temp2))])])){message("Surface mean less than bottom mean")}


  rbr_temps=temp2

  #Send data table out
  return(rbr_temps)
}
