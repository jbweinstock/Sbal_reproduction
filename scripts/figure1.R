## NE Atlantic Semibalanus balanoides figure 1
## Date created: 06.12.24
## Date updated: 11.07.24

# Goal = Generate seasonal averages using OSTIA, NARR satellite data:
# 1. load data from 2001-2005
# 2. Subset data into Fall / Winter
#       - Fall = Oct 01 - Dec 31
#       - Winter = Jan 01 - Mar 31
# 3. Calculate average value for each season (per pixel)
# 4. Repeat for 2019 - 2023
# 5. Create figure mapping each seasonal avg


require(ncdf4)
require(rnaturalearth)
require(lubridate)
require(abind)

Sys.setenv(TZ="UTC") #times in UTC; otherwise R converts times to local CPU clock

locs <- read.csv("data/site_locations.csv", 
                 fileEncoding="UTF-8-BOM")
locs$Site_name_full = factor(locs$Site_name_full,
                             levels = c("Halifax",
                                        "DMC","Newagen",
                                        "Nahant",
                                        "Oak Bluffs","Falmouth",
                                        "Mt Hope","Noyes Neck"))
sites_lat = aggregate(Latitude ~ Site_name_full, FUN = "mean", data = locs)
sites_lat$Longitude = aggregate(Longitude ~ Site_name_full, FUN = "mean", data = locs)$Longitude
sites_lat$modern = c("Y","N","Y","Y","N","Y","N","N")

coderoot<-"NOAH_IntertidalModel/"
SSTroot = paste(coderoot,"SST/OSTIA",sep="")
NARRroot = paste(coderoot,"MetData/NARR",sep="")
fl = dir(SSTroot, full.names = TRUE)
flN = dir(NARRroot, full.names = TRUE)

seasons_start = c(274,1)
seasons_end = c(365,90)
seasons = c("fall","winter")


## HISTORICAL SSTs
for(f in 2:6){  # manually call files (double-check #'s before re-running)
  nc <- nc_open(fl[f])
  SST <- ncvar_get(nc,"analysed_sst") - 273 #convert from Kelvins
  lons <- nc$dim$lon$vals
  lats <- nc$dim$lat$vals
  dates <- as.POSIXct(nc$dim$time$vals, origin = "1981-01-01 00:00:00") #refer to nc$dim$time$units
  doys <- yday(dates)
  
  for(t in 1:2){
    start = which.max(doys >= seasons_start[t]) #gets index of specific date
    stop = which(doys == seasons_end[t])
    season_slice = SST[,,start:stop]
    season_slice_avg = apply(season_slice,c(1,2),FUN="mean")
    
    file = sapply(strsplit(fl[f],"/"), tail, 1)
    file_year_nc = sapply(strsplit(file,"_"), tail, 1)
    file_year = sapply(strsplit(file_year_nc,".",fixed=TRUE), head, 1)
    
    data_name = paste(file_year,seasons[t],sep="_")
    assign(data_name,season_slice_avg)
  }
}

hist_fall_temps = array(c(`2001_fall`,`2002_fall`,`2003_fall`,`2004_fall`,`2005_fall`),
                        dim=c(300,140,5))
hist_fall_temps = apply(hist_fall_temps,c(1,2),FUN="mean")
hist_winter_temps = array(c(`2001_winter`,`2002_winter`,`2003_winter`,`2004_winter`,`2005_winter`),
                          dim=c(300,140,5))
hist_winter_temps = apply(hist_winter_temps,c(1,2),FUN="mean")


## MODERN SSTs
for(f in 20:24){  # manually call files (double-check #'s before re-running)
  nc <- nc_open(fl[f])
  SST <- ncvar_get(nc,"analysed_sst") - 273 #convert from Kelvins
  dates <- as.POSIXct(nc$dim$time$vals, origin = "1981-01-01 00:00:00") #refer to nc$dim$time$units
  doys <- yday(dates)
  
  for(t in 1:2){
    start = which.max(doys >= seasons_start[t]) #gets index of specific date
    stop = max(which(doys <= seasons_end[t]))
    season_slice = SST[,,start:stop]
    season_slice_avg = apply(season_slice,c(1,2),FUN="mean")
    
    file = sapply(strsplit(fl[f],"/"), tail, 1)
    file_year_nc = sapply(strsplit(file,"_"), tail, 1)
    file_year = sapply(strsplit(file_year_nc,".",fixed=TRUE), head, 1)
    
    data_name = paste(file_year,seasons[t],sep="_")
    assign(data_name,season_slice_avg)
  }
}

mod_fall_temps = array(c(`2019_fall`,`2020_fall`,`2021_fall`,`2022_fall`,`2023_fall`),
                       dim=c(300,140,5))
mod_fall_temps = apply(mod_fall_temps,c(1,2),FUN="mean")
mod_winter_temps = array(c(`2019_winter`,`2020_winter`,`2021_winter`,`2022_winter`,`2023_winter`),
                         dim=c(300,140,5))
mod_winter_temps = apply(mod_winter_temps,c(1,2),FUN="mean")

fall_warming = mod_fall_temps - hist_fall_temps
winter_warming = mod_winter_temps - hist_winter_temps


## HISTORICAL AIR TEMPS
for(f in 2:6){  # manually call files (double-check #'s before re-running)
  nc <- nc_open(flN[f])
  airT <- ncvar_get(nc,"air") - 273 #convert from Kelvins
  airlons <- ncvar_get(nc,"lon")
  airlats <- ncvar_get(nc,"lat")
  dates <- as.POSIXct(nc$dim$time$vals*3600, origin = "1800-01-01 00:00:00") #refer to nc$dim$time$units
  doys <- yday(dates)
  
  for(t in 1:2){
    start = which.max(doys >= seasons_start[t]) #gets index of specific date
    stop = which.max(doys == seasons_end[t])
    season_slice = airT[,,start:stop]
    season_slice_avg = apply(season_slice,c(1,2),FUN="mean")
    
    file = sapply(strsplit(flN[f],"/"), tail, 1)
    file_year = sapply(strsplit(file,"[.]"), tail, 2)[1]
    
    data_name = paste(file_year,seasons[t],sep="_")
    assign(data_name,season_slice_avg)
  }
}

hist_fall_air = array(c(`2001_fall`,`2002_fall`,`2003_fall`,`2004_fall`,`2005_fall`),
                      dim=c(349,277,5))
hist_fall_air = apply(hist_fall_air,c(1,2),FUN="mean")
hist_winter_air = array(c(`2001_winter`,`2002_winter`,`2003_winter`,`2004_winter`,`2005_winter`),
                        dim=c(349,277,5))
hist_winter_air = apply(hist_winter_air,c(1,2),FUN="mean")


## MODERN AIR TEMPS
for(f in 7:11){  # manually call files (double-check #'s before re-running)
  nc <- nc_open(flN[f])
  airT <- ncvar_get(nc,"air") - 273 #convert from Kelvins
  airlons <- ncvar_get(nc,"lon")
  airlats <- ncvar_get(nc,"lat")
  dates <- as.POSIXct(nc$dim$time$vals*3600, origin = "1800-01-01 00:00:00") #refer to nc$dim$time$units
  doys <- yday(dates)
  
  for(t in 1:2){
    start = which.max(doys >= seasons_start[t]) #gets index of specific date
    stop = max(which(doys <= seasons_end[t]))
    season_slice = airT[,,start:stop]
    season_slice_avg = apply(season_slice,c(1,2),FUN="mean")
    
    file = sapply(strsplit(flN[f],"/"), tail, 1)
    file_year = sapply(strsplit(file,"[.]"), tail, 2)[1]
    #file_year = sapply(strsplit(file_year_nc,".",fixed=TRUE), head, 1)
    
    data_name = paste(file_year,seasons[t],sep="_")
    assign(data_name,season_slice_avg)
  }
}

mod_fall_air = array(c(`2019_fall`,`2020_fall`,`2021_fall`,`2022_fall`,`2023_fall`),
                     dim=c(349,277,5))
mod_fall_air = apply(mod_fall_air,c(1,2),FUN="mean")
mod_winter_air = array(c(`2019_winter`,`2020_winter`,`2021_winter`,`2022_winter`,`2023_winter`),
                       dim=c(349,277,5))
mod_winter_air = apply(mod_winter_air,c(1,2),FUN="mean")

fall_air_warming = mod_fall_air - hist_fall_air
winter_air_warming = mod_winter_air - hist_winter_air


## PLOTS

breakpoints <- c(seq(from = -0.8, to = 0, by = 0.1), c(seq(from = 0.1, to = 4, by = 0.1)))
colors <- c(hcl.colors(9, "Blues"), hcl.colors(39, "Reds",rev=T))

# Modern fall water temps
fields::image.plot(mod_fall_temps,x=lons,y=lats,xlim=c(-73,-62),ylim=c(40.4,46.2),zlim=c(6,21),
                   xlab="",ylab="",yaxt = "n",
                   legend.args = list(text="Temp. \n(ºC)", side = 3, line = 0.4),
                   legend.shrink=0.65) #,zlim=c(-3,20))
axis(side = 2,las = 2)
plot(ne_countries(country = "united states of america", scale = "large"),add=TRUE,
     scale = "large",col="grey80")
plot(ne_countries(country = "canada", scale = "large"),add=TRUE,
     scale = "large",col="grey80")
box()
points(y=sites_lat[sites_lat$modern=="N",]$Latitude,
       x=sites_lat[sites_lat$modern=="N",]$Longitude,
       pch=24,bg="white",col="black",cex=1.5,lwd=1.5)
points(y=sites_lat[sites_lat$modern=="Y",]$Latitude,
       x=sites_lat[sites_lat$modern=="Y",]$Longitude,
       pch=21,bg="white",col="black",cex=1.5,lwd=1.5)

# Modern fall air temps
fields::image.plot(mod_fall_air,x=airlons,
                   y=airlats,xlim=c(-72.6,-62),ylim=c(40.5,46),zlim=c(0,21),
                   legend.args = list(text="Air temp. \n(ºC)", side = 3, line = 0.4),
                   legend.shrink=0.65)
plot(ne_countries(country = "united states of america", scale = "large"),add=TRUE,
     col="NA")
plot(ne_countries(country = "canada", scale = "large"),add=TRUE,
     col="NA",xlim=c(-72,-62))
box()
points(y=sites_lat[sites_lat$modern=="N",]$Latitude,
       x=sites_lat[sites_lat$modern=="N",]$Longitude,
       pch=24,bg="white",col="black",cex=1.5,lwd=1.5)
points(y=sites_lat[sites_lat$modern=="Y",]$Latitude,
       x=sites_lat[sites_lat$modern=="Y",]$Longitude,
       pch=21,bg="white",col="black",cex=1.5,lwd=1.5)


# Fall warming
fields::image.plot(fall_air_warming,x=airlons,y=airlats,
                   xlim=c(-72.5,-62),ylim=c(40.4,46.2),zlim=c(-0.8,4),
                   xlab="",ylab="",yaxt = "n",
                   legend.args = list(text="ΔT (ºC)", side = 3, line = 0.4),
                   legend.shrink=0.65,
                   col=colors,breaks = breakpoints)
axis(side = 2,las = 2)
fields::image.plot(fall_warming,x=lons,y=lats,add=TRUE,
                   xlim=c(-72.5,-62),ylim=c(40.4,46.2),zlim=c(-0.8,4),
                   legend.args = list(text="ΔT (ºC)", side = 3, line = 0.4),
                   legend.shrink=0.65,
                   col=colors,breaks = breakpoints)
box()
plot(ne_countries(country = "united states of america", scale = "large"),add=TRUE,col="NA")
plot(ne_countries(country = "canada", scale = "large"),add=TRUE,col="NA")
points(y=sites_lat[sites_lat$modern=="N",]$Latitude,
       x=sites_lat[sites_lat$modern=="N",]$Longitude,
       pch=24,bg="white",col="black",cex=1.5,lwd=1.5)
points(y=sites_lat[sites_lat$modern=="Y",]$Latitude,
       x=sites_lat[sites_lat$modern=="Y",]$Longitude,
       pch=21,bg="white",col="black",cex=1.5,lwd=1.5)


# Winter warming
fields::image.plot(winter_air_warming,x=airlons,y=airlats,
                   xlim=c(-72.5,-62),ylim=c(40.4,46.2),zlim=c(-0.8,4),
                   xlab="",ylab="",yaxt = "n",
                   legend.args = list(text="ΔT (ºC)", side = 3, line = 0.4),
                   legend.shrink=0.65,
                   col=colors,breaks = breakpoints)
axis(side = 2,las = 2)
fields::image.plot(winter_warming,x=lons,y=lats,add=TRUE,xlim=c(-72.5,-62),zlim=c(-0.8,4),
                   legend.args = list(text="ΔT (ºC)", side = 3, line = 0.4),
                   legend.shrink=0.65,
                   col=colors,breaks = breakpoints)
plot(ne_countries(country = "united states of america", scale = "large"),add=TRUE,col="NA")
plot(ne_countries(country = "canada", scale = "large"),add=TRUE,col="NA")
box()
points(y=sites_lat[sites_lat$modern=="N",]$Latitude,
       x=sites_lat[sites_lat$modern=="N",]$Longitude,
       pch=24,bg="white",col="black",cex=1.5,lwd=1.5)
points(y=sites_lat[sites_lat$modern=="Y",]$Latitude,
       x=sites_lat[sites_lat$modern=="Y",]$Longitude,
       pch=21,bg="white",col="black",cex=1.5,lwd=1.5)


