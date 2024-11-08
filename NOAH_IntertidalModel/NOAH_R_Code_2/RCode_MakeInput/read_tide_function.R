read_tide<-function(latitude,longitude,year,site)
{ptide<-sprintf("-b \"%d-01-01 00:00\" -e \"%d-12-31 23:59\" -l \"%s\" -s \"00:30\" -m r -u m -z",year,year,site)
print(ptide)
read.table(pipe(paste("C:/Users/Jane/Desktop/Macbook/WHOI/Research/NE_Data/nearshore-temps/NOAH_IntertidalModel/tide/tide.exe", ptide)), col.names=c("realtime","height"))
}
