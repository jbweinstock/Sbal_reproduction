create_noah_input_narr<-function(year, latitude, longitude, site, tidestation, height, slope, aspect, albedo, sst_lat, sst_lon, height_info)
{
  #create_noah_input_narr(y,34.555,-120.271, "Alegria", "Gaviota, California", 1.12, 45, 50, 0.6, 34.277, -120.211)
  #run_noah(y,46.908,-124.11, "Grays Harbor", "Westport, Point Chehalis", 1.12, 0, 0, 0.6, 46.908, -124.21,1/150)
  
  codepath<-"C:/Users/Jane/Desktop/Macbook/WHOI/Research/NE_Data/nearshore-temps/NOAH_IntertidalModel/NOAH_R_Code_2/"  
  
  debug<-F
  if(debug)
  {
    codepath<-"C:/Users/Jane/Desktop/Macbook/WHOI/Research/NE_Data/nearshore-temps/NOAH_IntertidalModel/NOAH_R_Code_2/"  
    source(paste(codepath,"RCode_MakeInput/read_narr_nc_function.R",sep=""))
    source(paste(codepath,"RCode_MakeInput/read_ostia_nc_function.R",sep=""))
    source(paste(codepath,"RCode_MakeInput/read_tide_function.R",sep=""))
    year<-2000
    latitude<-41.93
    longitude<- -70.54
    site<-"Manomet"
    tidestation<-"Plymouth, Massachusetts"
    height<-1.00
    slope<-0
    aspect<-0
    albedo<-0.6
    sst_lat<-41.93
    sst_lon<- -70.54
  }
  
  print(paste("site",site))
  print(paste("height ",height," slope ",slope," aspect ",aspect," albedo ",albedo))
  #print(slope)
  #print(aspect)
  #print(albedo)
  
  #narr_base<-paste("~/Desktop/NARR 2006/")
  #narr_base<-paste("/data1/NARR/")
  narr_base<-paste("C:/Users/Jane/Desktop/Macbook/WHOI/Research/NE_Data/nearshore-temps/NOAH_IntertidalModel/MetData/NARR/")
  sst_base<-paste("C:/Users/Jane/Desktop/Macbook/WHOI/Research/NE_Data/nearshore-temps/NOAH_IntertidalModel/SST/")
  narr_file<-paste(narr_base, "dswrf.",year,".nc",sep="")
  narr_solar<-read_narr_nc(latitude,longitude,narr_file,"dswrf", year)
  narr_file<-paste(narr_base, "dlwrf.",year,".nc",sep="")
  narr_lw<-read_narr_nc(latitude,longitude,narr_file,"dlwrf", year)
  narr_file<-paste(narr_base, "air.2m.",year,".nc",sep="")
  narr_air<-read_narr_nc(latitude,longitude,narr_file,"air", year)
  narr_file<-paste(narr_base, "rhum.2m.",year,".nc",sep="")
  narr_rh<-read_narr_nc(latitude,longitude,narr_file,"rhum", year)
  narr_file<-paste(narr_base, "uwnd.10m.",year,".nc",sep="")
  narr_uwnd<-read_narr_nc(latitude,longitude,narr_file,"uwnd", year)
  narr_file<-paste(narr_base, "vwnd.10m.",year,".nc",sep="")
  narr_vwnd<-read_narr_nc(latitude,longitude,narr_file,"vwnd", year)
  narr_file<-paste(narr_base, "prate.",year,".nc",sep="")
  narr_prate<-read_narr_nc(latitude,longitude,narr_file,"prate", year)
  narr_file<-paste(narr_base, "pres.sfc.",year,".nc",sep="")
  narr_press<-read_narr_nc(latitude,longitude,narr_file,"pres", year)
  narr_file<-paste(narr_base, "air.sfc.",year,".nc",sep="")
  #narr_sfc<-read_narr_nc(sst_lat,sst_lon,narr_file,"3-hourly air temperature at Surface", year)
  #narr_sfc<-read_oisst_nc(sst_lat,sst_lon,paste("/data1/sierra/OISST_USWest_",year,".nc",sep=""),year)
  narr_sst<-read_ostia_nc(sst_lat,sst_lon,paste(sst_base,"OSTIA/OSTIA_US_NEast_",year,".nc",sep=""),year)
  
  narr_wind<-data.frame(narr_uwnd$unix_date,sqrt(narr_uwnd$uwnd^2+narr_vwnd$vwnd^2))
  colnames(narr_wind)<-c("unix_date", "wind")
  
  narr_prate$prate<-narr_prate$prate*1800/25.4
  narr_press$pres<-narr_press$pres/100
  
  
  # totalhours<-max(narr_solar$jday)*24
  # hourly<-data.frame(matrix(NA, totalhours, 2))
  # hourly[,1]<-as.numeric(row.names(hourly))-1
  # hourly[,2]<-narr_solar[1,1]+hourly[,1]*60*60
  # colnames(hourly)<-c("index", "unix_date")
  # solardata<-merge(hourly, narr_solar, all=TRUE, sort=TRUE)
  # solardata<-solardata[,-2]
  # solardata$unix_date<-solardata$unix_date+60*60
  # x<-solardata$unix_date
  # y<-solardata$dswrf
  # store<-approx(x,y,x, method="linear",rule=2)
  # solardata$dswrf<-round(store$y,digits=3)
  # timestore<-(solardata[,1])
  # class(timestore)<-c("POSIXct")
  # solardata$Hour<-as.numeric(format(timestore, format="%H"))
  # solardata$date<-format(timestore, format="%Y-%m-%d")
  # solardata$year<-as.numeric(format(timestore, format="%Y"))
  # solardata$month<-as.numeric(format(timestore, format="%m"))
  # solardata$day<-as.numeric(format(timestore, format="%d"))
  # #DSW jday
  # #solardata$Jday<-as.numeric(format(timestore,format="%j"))
  # require(chron)
  # solardata$jday<-julian(solardata$month, solardata$day, solardata$year, origin. = c(month=1, day=1, year=year))+1
  # solardata<-solardata[,c(5,2,4,3)]
  # colnames(solardata)<-c("Date", "Jday", "Hour", "Global")
  # 
  # solar_slope<-solarslope(latitude, longitude, year, slope, aspect, albedo, solardata) 
  # 
  # timestore<-paste(solar_slope$Date, " ", solar_slope$hour, ":00", sep="")
  # timestore2<-strptime(timestore, "%Y-%m-%d %H:%M")
  # timestore3<-as.POSIXct(timestore2)
  # class(timestore3)<-("numeric")
  # solar_slope[,1]<-timestore3
  # solar_slope2<-data.frame(solar_slope$Date, solar_slope$jday, solar_slope$dswrf)
  # colnames(solar_slope2)<-c("unix_date", "jday", "dswrf")
  
  solar_times<-seq(as.POSIXct(narr_solar$unix_date[1],origin="1970-01-01"),as.POSIXct(narr_solar$unix_date[nrow(narr_solar)],origin="1970-01-01"),1800)  #30 min increments
  solar_interp<-approx(x=narr_solar$unix_date, y=narr_solar$dswrf,xo=solar_times)$y
  
  if(!INSOL){
    solar_POSIX<-as.POSIXlt(solar_times,origin="1970-01-01",tz="GMT")
    Jday<-solar_POSIX$yday+1
    Hour<-solar_POSIX$h[,1]
    Global<-solar_interp$y
    Date<-strftime(solar_POSIX,"%Y-%m-%d")
    solardata<-cbind(Date,Jday,Hour,Global)
    solar_slope<-solarslope(latitude, longitude, year, slope, aspect, albedo, solardata)
  }
  
  if(INSOL){
    require(insol)
    xo<-solar_times
    x<-narr_air$unix_date
    y<-narr_air$air
    af<-approx(x,y,xo, method="linear",rule=2)
    tK<-af$y                                            #air temperature in K for insol()
    y<-narr_rh$rh
    rf<-approx(x,y,xo, method="linear",rule=2)
    rh<-rf$y                                            #rh for insol()
    
    solar_jd<-JD(solar_times)
    sv<-sunvector(solar_jd,latitude,longitude,0)				#sun vectors for each time step in tz=0
    zenith_ang<-sunpos(sv)[,2]										      #zenith angles for each time step
    normal<-normalvector(slope,aspect)							    #normal vector to surface
    cos_inc_sfc<-sv %*% as.vector(normal)						    #cosine of angle of incidence to surface
    cos_inc_sfc[cos_inc_sfc<0]<-0								        #set to zero where no incident light
    I_dir_diff<-insolation(zenith=zenith_ang,solar_jd,height=0,visibility=20,RH=rh,tempK=tK,O3=0.002,alphag=albedo)	#insolation (beam + diffuse) at ht=0
    diff_frac<-I_dir_diff[,2]/rowSums(I_dir_diff)
    beam<-solar_interp*(1-diff_frac)
    diffuse<-solar_interp*diff_frac
    I<-beam*cos_inc_sfc + diffuse								        #	beam*cos(incidence) + diffuse
    hhmm<-as.numeric(strftime(as.POSIXct(solar_times,origin="1970-01-01",tz="GMT"),"%H%M",))
    solar_slope2<-data.frame(cbind(solar_times,hhmm,I,90-zenith_ang))
    colnames(solar_slope2)<-c("unix_date","hhmm","dswrf","sun_el")
    solar_slope2$dswrf[is.nan(solar_slope2$dswrf)]<-0
  }
  
  
  
  df_noah<-narr_lw
  df_noah<-merge(narr_air,df_noah, all=TRUE, sort=TRUE)
  df_noah<-merge(narr_rh,df_noah, all=TRUE, sort=TRUE)
  df_noah<-merge(narr_wind,df_noah, all=TRUE, sort=TRUE)
  df_noah<-merge(narr_prate,df_noah, all=TRUE, sort=TRUE)
  df_noah<-merge(narr_press,df_noah, all=TRUE, sort=TRUE)
  df_noah<-merge(narr_sst,df_noah, all=TRUE, sort=TRUE)
  #df_noah$unix_date<-df_noah$unix_date+60*60                 #not clear why this is necessary
  #solar_slope2$unix_date<-solar_slope2$unix_date+30*60       #ditto 
  df_noah<-merge(solar_slope2,df_noah, all=TRUE, sort=TRUE)
  df_noah<-df_noah[order(df_noah[,1]),]
  
  #eph<-read_eph(latitude,longitude,year,365)
  tide<-read_tide(latitude,longitude,year,paste(tidestation))
  
  # times<-eph$time
  # dates<-eph$date
  # hours<-floor(times)
  # minutes<-floor((times%%1)*60)
  # hhmm<-hours*100+minutes
  # x<-paste(dates," ",hours,":",minutes,sep="")
  # z<-strptime(x,"%Y-%m-%d %H:%M")
  # eph$realtime<-as.POSIXct(z)
  # 
  # eph$realtime<-as.numeric(eph$realtime)
  # eph$hhmm<-hhmm
  # 
  # eph_tide<-merge(eph,tide,by.x="realtime",by.y="realtime")
  # eph_tide<-eph_tide[,c(1,2,7,5,6,8)]
  # eph_tide$month<-as.numeric(strftime(as.POSIXlt(eph_tide$date),"%m"))
  # ##msl<-mean(eph_tide$height)
  # tideflag<-as.numeric(eph_tide$height<height)
  # eph_tide<-cbind(eph_tide,tideflag)
  
  #tide$realtime<-tide$unix_date
  times<-tide$realtime
  hhmm<-strftime(as.POSIXct(times,origin="1970-01-01"),"%H%M")
  
  ##msl<-mean(eph_tide$height)
  tide$tideflag<-as.numeric(tide$height<(mean(tide$height)+height))
  
  df2<-merge(tide,df_noah,by.x="realtime",by.y="unix_date",all.x=TRUE)
  df2_date<-as.POSIXct(df2$realtime,origin="1970-01-01")              
  df2$jday<-as.numeric(strftime(df2_date,"%j"))
  df2<-df2[!is.na(df2$hhmm),]
  df2<-df2[df2$jday>0,]
  df2<-df2[order(df2[,1]),]
  #df2<-df2[-1,]
  #df2<-df2[-1,]
  
  x<-df2$realtime
  
  y<-df2$air
  af<-approx(x,y,x, method="linear",rule=2)
  a2<-af$y-273
  
  y<-df2$rhum
  rf<-approx(x,y,x, method="linear",rule=2)
  r2<-rf$y
  
  y<-df2$pres
  pf<-approx(x,y,x, method="linear",rule=2)
  p2<-pf$y
  
  y<-df2$dswrf
  sf<-approx(x,y,x, method="linear",rule=2)
  s2<-sf$y
  dawndusk<-data.frame(df2$realtime, df2$sun_el, s2)
  dawndusk[,3]<-replace(dawndusk[,3], dawndusk[,2]<0, 0)
  s3<-dawndusk[,3]
  
  y<-df2$prate
  rf2<-approx(x,y,x, method="linear",rule=2)
  rn<-rf2$y
  
  y<-df2$dlwrf
  lf<-approx(x,y,x, method="linear",rule=2)
  l2<-lf$y
  
  y<-df2$wind
  uf<-approx(x,y,x, method="linear",rule=2)
  u2<-uf$y
  
  y<-df2$jday
  jf<-approx(x,y,x, method="constant",rule=2)
  j2<-jf$y
  
  y<-df2$sst
  sstf<-approx(x,y,x, method="linear",rule=2)
  sst2<-sstf$y
  
  
  d2<-data.frame(j2, df2$hhmm,u2,a2,r2,p2,s3,l2,rn,sst2,df2$tideflag,check.rows=TRUE)
  
  
  
  d3<-d2[-nrow(d2),]
  d3$u2<-round(d3$u2,2)
  d3$a2<-round(d3$a2,2)
  d3$r2<-round(d3$r2,0)
  d3$p2<-round(d3$p2,2)
  d3$s3<-round(d3$s3,1)
  d3$l2<-round(d3$l2,1)
  d3$rn<-round(d3$rn,3)
  d3$sst2<-round(d3$sst2,2)
  
  write.table(d3,paste(codepath,"/noah_",year,"_",gsub("[ ,]","",site),"_", height, ".in",sep=""),row.names=FALSE,col.names=FALSE,quote=FALSE)
  write.table(d3,paste(codepath,"/noah.in",sep=""),row.names=FALSE,col.names=FALSE,quote=FALSE)
  
} 
