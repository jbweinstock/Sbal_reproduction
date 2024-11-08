read_thermo<-function(year,location)
{
  #require(udunits)
  #lastyear<-year-1
  
  
  widths=list(jday=0,hhmm=0,f=0,RNETcalc=0,
              CH=0,CM=0,H=0,S=0,AET=0,RES=0,Fup=0,FLX1=0,
              FLX2=0,FLX3=0,Tskin=0,Q1=0,ETPS=0,
              X1=0,X2=0,X3=0,X4=0,X5=0,
              X6=0,X7=0,X8=0,X9=0,X10=0,
              X11=0,X12=0,X13=0,X14=0,X15=0,
              X16=0,X17=0,X18=0,X19=0,X20=0)
  a<-data.frame(scan(paste(coderoot,"THERMO_",year,"_",location,".TXT",sep=""),widths,multi.line=TRUE,na.strings="***************"))
  a$year<-year
  return(a)
}