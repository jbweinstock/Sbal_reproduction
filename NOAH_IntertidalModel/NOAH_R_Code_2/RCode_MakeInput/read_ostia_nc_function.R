read_ostia_nc<-function(latitude,longitude,filename, year)
{
  debug<-F
  require(udunits2)
  require(ncdf4)
  
  #require(ncvar)
  if(debug)
  {
    Sys.setenv(TZ="UTC")
    latitude<-41.92
    longitude<- -70.53
    year<-2000
    filename<-paste("P:/SST/OSTIA/OSTIA_US_NEast_",year,".nc",sep="")
  }
  varname<-"analysed_sst"
  nc<-nc_open(filename)
  
  lats<-nc$dim$lat$vals
  #print(lats[1,])
  lons<-nc$dim$lon$vals
  if (longitude<min(lons)){longitude<-longitude+360}
  #print(lons[1,])
  lt<-abs(lons-longitude)
  ll<-abs(lats-latitude)
  xx<-which.min(lt)
  yy<-which.min(ll)
  
  print(paste("Variable: ",varname,nc$var[[1]]$longname))
  ##print(ncv3)
  xdim<-nc$dim$lon$len
  print(paste("xdim",xdim))
  
  tdim<-nc$dim$time$len
  print(paste("tdim",tdim))
  
  print(paste("latitude requested:",latitude,  " retrieved:",round(lats[yy],4)))
  
  print(paste("longitude requested:",longitude," retrieved:",round(lons[xx],4)))
  timevals<-nc$dim$time$vals
  tunits<-nc$dim$time$units
  unix_units<-"seconds since 1970-1-1 00:00:0.0"
  unix_time<-as.POSIXct(ud.convert(timevals,tunits,unix_units),origin="1970-01-01")
  #unix_date<-utInvCalendar(dates,unix_units)
  first<-as.Date(as.POSIXct(paste(year,"-01-01",sep=""),format="%Y-%m-%d",tz="UTC"))
  last<-as.Date(as.POSIXct(paste(year,"-12-31",sep=""),format="%Y-%m-%d"),tz="UTC")
  unix_date<-as.Date(unix_time)
  firstdiff<-unix_date-first
  first_index<-which.min(abs(firstdiff))
  lastdiff<-unix_date-last
  last_index<-which.min(abs(lastdiff))
  ndays<-last_index-first_index+1
  start<-c(xx,yy,first_index)
  print ("start")
  print(start)
  count<-c(1,1,ndays)
  print("count")
  print(count)
  vals<-ncvar_get(nc,"analysed_sst",start=start,count=count)
  
  jday<-as.numeric(strftime(unix_date,"%j"))
  
  unix_date<-as.numeric(unix_time)
  df<-data.frame(unix_date[first_index:last_index],jday, vals)
  colnames(df)<-c("unix_date", "jday", "sst")
  nc_close(nc)
  return(df)
}