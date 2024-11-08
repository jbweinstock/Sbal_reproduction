read_narr_nc<-function(latitude,longitude,filename,varname, year)
{
  #require(udunits)
  require(ncdf4)
  require(udunits2)
  #require(ncvar)
  #latitude<-36.6
  #longitude<- -121.8
  #filename<-paste("/Volumes/Ecklonia/NARRdata/dswrf/dswrf.1985.nc")
  #filename<-paste("D:/NARR/dswrf.2006.nc")
  #varname<-"dswrf"
  
  paste (filename)
  nc<-nc_open(filename)
  
  
  
  lats<-ncvar_get(nc,nc$var[[1]])
  #print(lats[1,])
  lons<-ncvar_get(nc,nc$var[[2]])
  #print(lons[1,])
  lt<-abs(lons-longitude)
  ll<-abs(lats-latitude)
  distance<-sqrt(lt^2+ll^2)
  mindist<-min(distance)
  pt<-which(mindist==distance,arr.ind=TRUE)
  
  #This finds the variable in the ncdf file that contains the right information 
  n<-nc$nvars
  k<-1
  for(i in 1:n)
  {
    exists<-which(nc$var[[k]]==varname)
    if(length(exists)==1) break
    k<-k+1
  }
  
  ncv3<-(nc$var[[k]])
  print(paste("Variable: ",varname,ncv3$longname))
  ##print(ncv3)
  xdim<-ncv3$size[1]
  print(paste("xdim",xdim))
  
  tdim<-ncv3$size[3]
  print(paste("tdim",tdim))
  
  #xx<-pt%%xdim
  #yy<-pt%/%xdim+1
  
  xx<-pt[1]
  yy<-pt[2]
  
  print(paste("latitude requested:",latitude,  " retrieved:",round(lats[xx,yy],4)))
  
  print(paste("longitude requested:",longitude," retrieved:",round(lons[xx,yy],4)))
  start<-c(xx,yy,1)
  print ("start")
  print(start)
  count<-c(1,1,tdim)
  print("count")
  print(count)
  vals<-ncvar_get(nc,nc$var[[k]],start=start,count=count)
  timevals<-nc$dim$time$vals
  tunits<-nc$dim$time$units
  #utinit()
  #u<-utScan(tunits)
  #dates<-utCalendar(timevals,u)
  unix_units<-"seconds since 1970-1-1 00:00:0.0"
  unix_date<-as.POSIXct(ud.convert(timevals,tunits,unix_units),origin="1970-01-01")
  jday<-as.numeric(strftime(unix_date,"%j"))
  unix_date<-as.numeric(unix_date)
  
  if(varname=="dswrf")
  {vals<-round(vals, digits=3)}
  if(varname=="3-hourly air temperature at Surface"){varname<-"tmpsfc"}
  df<-data.frame(unix_date,jday, vals)
  colnames(df)<-c("unix_date", "jday", varname)
  nc_close(nc)
  return(df)
}