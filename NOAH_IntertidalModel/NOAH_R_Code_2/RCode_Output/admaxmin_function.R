admaxmin<-function(a,yyyymmdd)
{
        #require(udunits)
        #utInit()
        #require(RNetCDF)
        #utinit.nc()
        
        y1<-yyyymmdd%/%10000
        m1<-(yyyymmdd%%10000)%/%100
        d1<-yyyymmdd%%100
        
        #jday_unitstr<-paste("days since ",y1,"-",m1,"-",d1," 00:00:0.0",sep="")
        #print(jday_unitstr)
        #day<-utCalendar(a$jday-1,jday_unitstr)
        
        hours<-floor(a$hhmm/100)
        minutes<-a$hhmm%%100
        seconds<-hours*3600+minutes*60
        
        date<-strptime(paste(y1,a$jday, hours, minutes),"%Y %j %H %M")
        unixtime<-as.numeric(date)
        #unix_units<-"seconds since 1970-1-1 00:00:0.0"
        # unixtime<-floor(utInvCalendar(day,unix_units))+seconds
        # date<-utCalendar(unixtime,unix_units)
        # month_units<-paste("months since ",y1,"-",m1,"-",d1," 00:00:0.0",sep="")
        #   months<-floor(round(utInvCalendar(day,month_units),digits=3)+1)
        months<-as.numeric(strftime(date,"%m"))
        
        Mussel_Temps<-data.frame(a$jday,a$year,months,unixtime,a$Tskin,a$X1,a$X2,a$X3,a$X4,a$X5,a$X6,a$X7,a$X8,a$X9,
                                 a$X10,a$X11,a$X12,a$X13,a$X14,a$X15,a$X16,a$X17,a$X18,a$X19)
        
        monthly_max<-aggregate(Mussel_Temps,list(Mussel_Temps$months),max)
        daily_max<-aggregate(Mussel_Temps,list(Mussel_Temps$a.jday),max)
        admax<-aggregate(daily_max,list(daily_max$month),mean)
        colnames(admax)<-sub("a.","max.",colnames(admax))
        
        monthly_min<-aggregate(Mussel_Temps,list(Mussel_Temps$months),min)
        daily_min<-aggregate(Mussel_Temps,list(Mussel_Temps$a.jday),min)
        admin<-aggregate(daily_min,list(daily_max$month),mean)
        colnames(admin)<-sub("a.","min.",colnames(admin))
        
        admaxmin<-data.frame(admax,admin)
        
        return(admaxmin)
}