#THIS WORKS###
source(paste(coderoot,"RCode_Output/read_thermo_function.R",sep=""))
source(paste(coderoot,"RCode_Output/admaxmin_function.R",sep=""))
admaxmin_plots<-function(yyyymmdd,sitename,slope,aspect)
{
        #yyyymmdd<-20080101
        #compressedname<-gsub("[ ,.:\'()]","",sitename)
        compressedname<-sitename
        thermoname<-paste(compressedname,"_",slope,"_",aspect,sep="")
        y1<-yyyymmdd%/%10000
        
        {a<-read_thermo(yyyymmdd,thermoname);ADM<-admaxmin(a,yyyymmdd);}
        ADM<-ADM[do.call(order,list(ADM$unixtime)),]
        ADM$date<-as.POSIXct(ADM$unixtime,origin="1970-01-01")
        max_x3<-max(ADM$max.X3,na.rm=T)-273
        min_x3<-min(ADM$min.X3,na.rm=T)-273
        
        png(file = paste("/data/noah_r_code_2/ADM_",compressedname,"_",yyyymmdd,"_",slope,"_",aspect,"_X3.png",sep=""),
            width=500, height=768
        )
        
        oldpar<-par()
        par(mfrow=c(2,1))
        plot(ADM$date,ADM$max.X3-273,type="l",ylab="Body Temperature",xlab="Average Daily Max and Min",ylim=c(5,45))
        title(paste(yyyymmdd,sitename,"slope",slope,"az",aspect))
        lines(ADM$date,ADM$min.X3-273,col="red")
        abline(h=20)
        ADM_CrescentCity<-ADM
        
        #require(udunits)
        #utInit()
        
        y1<-yyyymmdd%/%10000
        m1<-(yyyymmdd%%10000)%/%100
        d1<-yyyymmdd%%100
        
        # jday_unitstr<-paste("days since ",y1,"-",m1,"-",d1," 00:00:0.0",sep="")
        #print(jday_unitstr)
        # day<-utCalendar(a$jday-1,jday_unitstr)
        
        hours<-floor(a$hhmm/100)
        minutes<-a$hhmm%%100
        seconds<-hours*3600+minutes*60
        
        date<-strptime(paste(y1,a$jday, hours, minutes),"%Y %j %H %M")
        unixtime<-as.numeric(date)
        
        
        
        plot(date,a$X3-273,type="l",ylab="Body Temperature", xlab="Date",ylim=c(0,50))
        abline(h=20)
        #title(paste(yyyymmdd,"CFS Forecast",sitename," MSL"))
        
        dev.off()
        par(oldpar)
}