#THIS WORKS###
source(paste(coderoot,"RCode_Output/read_thermo_function.R",sep=""))
source(paste(coderoot,"RCode_Output/admaxmin_function.R",sep=""))
admaxmin_plots_layer<-function(yyyymmdd,site,height,slope,aspect,albedo,layer)
{
        if(0)
        {
                site<-"Palmeira"
                yyyymmdd<-20160101
                height<-1
                slope<-50
                aspect<-180
                layer<-0
                albedo<-0.2
                sitename<-paste(site,"_",height,sep="")
                
        }
        #yyyymmdd<-20080101
        #compressedname<-gsub("[ ,.:\'()]","",sitename)
        
        thermoname<-paste(site,"_",height,"_",slope,"_",aspect,"_",albedo,sep="")
        y1<-yyyymmdd%/%10000
        
        print(paste("ht=",height,"sl=",slope,"asp=",aspect,"alb=",albedo,"fn=",thermoname))
        {a<-read_thermo(yyyymmdd,thermoname);ADM<-admaxmin(a,yyyymmdd);}
        ADM<-ADM[do.call(order,list(ADM$unixtime)),]
        ADM$date<-as.POSIXct(ADM$unixtime,origin="1970-01-01")
        if(layer==0)
        {
                layer_val<-as.vector(unlist(a[grep("Tskin",colnames(a))]))
                layer_admax<-as.vector(unlist(ADM[grep(paste("max.Tskin",sep=""),colnames(ADM))]))
                layer_admin<-as.vector(unlist(ADM[grep(paste("min.Tskin",sep=""),colnames(ADM))]))
        }
        if(layer>0)
        {
                layer_val<-as.vector(unlist(a[grep(paste("X",layer,sep=""),colnames(a))[2]]))
                layer_admax<-as.vector(unlist(ADM[grep(paste("max.X",layer,sep=""),colnames(ADM))]))
                layer_admin<-as.vector(unlist(ADM[grep(paste("min.X",layer,sep=""),colnames(ADM))]))
        }
        max_x<-max(layer_admax,na.rm=T)-273
        min_x<-min(layer_admin,na.rm=T)-273
        
        png(file = paste(coderoot,"/model_plots/ADM_",site,"_",y1,"_",height,"_",slope,"_",aspect,"_",albedo,"_X",layer,".png",sep=""),
            width=500, height=768
        )
        
        oldpar<-par()
        par(mfrow=c(2,1))
        plot(ADM$date,layer_admax-273,type="l",ylab="Body Temperature",xlab="Average Daily Max and Min",ylim=c(-15,45))
        title(paste(yyyymmdd,site,"slope",slope,"az",aspect))
        lines(ADM$date,layer_admin-273,col="red")
        abline(h=20)
        
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
        
        datadf <- as.data.frame(cbind(as.data.frame(as.Date(paste(y1,a$jday, hours, minutes),
                                                            "%Y %j %H %M",
                                                            tz="UTC")),
                                      as.data.frame(format(as.POSIXct(date), 
                                                           format = "%H:%M"), 
                                                    tz = "UTC"),
                                      as.data.frame(a$X3-273)))
        colnames(datadf) = c("date","time","body_temp")
        
        write.csv(datadf, file = paste(coderoot,"/model_data/NOAH_",site,"_",y1,"_",height,"_",slope,"_",aspect,"_",albedo,"_X",layer,".csv",sep=""))
        
        plot(date,layer_val-273,type="l",ylab="Body Temperature", xlab="Date",ylim=c(-20,50))
        abline(h=20)
        #title(paste(yyyymmdd,"CFS Forecast",sitename," MSL"))
        
        dev.off()
        par(oldpar)
}