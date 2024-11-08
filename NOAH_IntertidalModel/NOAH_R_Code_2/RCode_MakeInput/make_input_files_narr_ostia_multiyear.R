#File to run WRF/MOHID barnacle simulations in Galicia
#DSWethey 20180604
#---------------------------------------------
#multi-year runs use initial conditions from NOAH_messages.txt created by previous year run.
#DSWethey 20181215
#---------------------------------------------
#Modified to run NARR/OSTIA simulations in New England
#DS Wethey 20240306
#---------------------------------------------
#Modified further to run NARR/OSTIA simulations in New England
#JBW 20241002

rm(list=ls())
Sys.setenv(TZ="UTC") #times in UTC

INSOL<-TRUE         #use insol function for solar rad angles
SST_SOURCE<-"OSTIA" #"WRF" #"MOHID"
coderoot<-"C:/Users/Jane/Desktop/Macbook/WHOI/Research/NE_Data/nearshore-temps/NOAH_IntertidalModel/NOAH_R_Code_2/"

source(paste(coderoot,"RCode_MakeInput/create_noah_input_narr_insol_function.R",sep=""))
source(paste(coderoot,"RCode_Output/admaxmin_function.R",sep=""))
source(paste(coderoot,"RCode_Output/admaxmin_plots_function.R",sep=""))
source(paste(coderoot,"RCode_Output/admaxmin_plots_layer_function.R",sep=""))
source(paste(coderoot,"RCode_MakeInput/read_narr_nc_function.R",sep=""))
#if(SST_SOURCE=="MOHID")source("c:/data/NOAH_R_Code_2/RCode_MakeInput/read_mohidsst_nc_function.R")
#if(SST_SOURCE=="MOHID")source("c:/data/NOAH_R_Code_2/RCode_MakeInput/read_mohid_tide_nc_function.R")
#if(SST_SOURCE=="WRF")source("c:/data/NOAH_R_Code_2/RCode_MakeInput/read_tide_function.R")
if(SST_SOURCE=="OSTIA"){
  source(paste(coderoot,"RCode_MakeInput/read_ostia_nc_function.R",sep=""))
  source(paste(coderoot,"RCode_MakeInput/read_tide_function.R",sep=""))
}
source(paste(coderoot,"RCode_MakeInput/make_control_file_function.R",sep=""))


#The functions need the information in the following order: (year, latitude, longitude, site, tidestation, height, slope, aspect, albedo, sst_lat, sst_lon,tanB)
run_noah<-function(year, latitude, longitude, site, region, height, slope, aspect, layer, albedo, sst_lat, sst_lon,tanB)
{
  create_noah_input_narr(year, latitude, longitude, site, region, height, slope, aspect,  albedo, sst_lat, sst_lon,tanB)
  yyyymmdd<-10000*year+101
  if(!file.exists(paste(coderoot,"NOAH_messages.txt",sep="")))
  {make_control_file(path=coderoot,template="controlfile.1.herrera.barnacle.sym",albedo=albedo)}
  if(file.exists(paste(coderoot,"NOAH_messages.txt",sep="")))
  {make_control_file(path=coderoot,template="controlfile.1.herrera.barnacle.top.sym",albedo=albedo,add_ic=TRUE)}
  
  #p<-paste("cd /data/NOAH_R_Code_2&copy controlfile.1.herrera.barnacle controlfile.1")
  #shell(p,"cmd",translate=TRUE)
  p<-paste("cd ",coderoot,"&NT191 1>NOAH_messages.txt")
  shell(p,"cmd",translate=T)
  p<-paste("cd ",coderoot,"/&copy THERMO.TXT THERMO_",yyyymmdd,"_",site,"_",height,"_",slope,"_",aspect,"_",albedo,".TXT",sep="")
  print(p)
  shell(p,"cmd",translate=T)
  #admaxmin_plots(yyyymmdd,paste(site,"_",height,sep=""),slope,aspect)
  admaxmin_plots_layer(yyyymmdd,site,height,slope,aspect,albedo,layer)
  #admaxmin_plots_layer<-function(yyyymmdd,sitename,height,slope,aspect,albedo,layer)
  
}

#setup 3cm bed of barnacles
namelistcmd<-paste("echo ",coderoot,"namelist_barnacle_3cm_bed.txt > ",coderoot,"namelist_filename.txt",sep="")
shell(cmd=namelistcmd,shell="cmd",translate=T)


alb<- 0.4 #best estimate of Semibalanus shell albedo, from Herrera et al. 2019
ht<-1.44
slope<-45                      #slope of rock surface
azimuth<-250                   #azimuth of rock surface
layer<-0                       #layer of model (0=shell temperature)


# if(file.exists("/data/NOAH_R_Code_2/NOAH_messages.txt")) 
# 	{p<-paste("cd /data/NOAH_R_Code_2&del NOAH_messages.txt")
# 	shell(p,"cmd",translate=TRUE)
# 	}
# for (y in c(2000)) run_noah(y,42.57,-8.96, "Palmeira",    "Villagarcia",   ht,  45, 180, 0, alb, 42.5, -8.95,1/150)


## TEST W/ MANOMET DATA

#use this before a multi-year run.  The NOAH_messages.txt file is used to define initial conditions for each year based on the 
#temperatures at each model level at the end of previous year
#!!!!!!!!!!!Be sure to run this before each new site is run  !!!!!!!!!!!!!!!!!!!
if(file.exists(paste(coderoot,"NOAH_messages.txt",sep=""))){
  p<-paste("cd ",coderoot,"&del NOAH_messages.txt")
  shell(p,"cmd",translate=TRUE)
}
#run_noah<-function(year, latitude, longitude, site, region, height, slope, aspect, layer, albedo, sst_lat, sst_lon,tanB)
#    sst_lat and sst_lon may be different from site location because of grid scale of SST data
#    tanB is beach slope (used if wave run-up is included)
for (y in c(2000)){
  run_noah(y, #years of interest
           41.93,-70.54, #site lat & lon
           "Manomet", #site name
           "Plymouth, Massachusetts", #nearest xtide station
           ht, #vertical height
           slope, #slope of rock surface
           azimuth, #azimuth of rock surface
           layer, #layer of model (0=shell temperature)
           alb, #best estimate of Galicia barnacle albedo
           41.93, -70.54, #SST pixel lat & lon
           NA) #tanB AKA beach slope (used if wave run-up is included)
}



## RUN FOR NE ATLANTIC STUDY SITES
locs <- read.csv("data/site_locations.csv", 
                 fileEncoding="UTF-8-BOM")
locs_modern <- subset(locs, locs$Modern_data == "Y")

for(i in 1:length(locs$Site)){
  #for(s in c(0,22.5,45,67.5,90)){
    for(y in c(2002,2003,2004)){
      if(file.exists(paste(coderoot,"NOAH_messages.txt",sep=""))){
        p<-paste("cd ",coderoot,"&del NOAH_messages.txt")
        shell(p,"cmd",translate=TRUE)
      }
      print(c(locs$Site[i],y))
      run_noah(year = y, #years of interest
               latitude = locs$Latitude[i], #site lat
               longitude = locs$Longitude[i], #site lon
               site = locs$Site[i], #site name (no spaces)
               region = locs$xtide_station_name[i], #nearest xtide station
               height = locs$height[i], #vertical height
               slope = locs$slope[i], #slope of rock surface
               aspect = locs$azimuth[i], #azimuth of rock surface
               layer = 0, #layer of model (0=shell temperature)
               albedo = 0.4, #best estimate of Galicia barnacle albedo
               sst_lat = locs$pixel_lat[i], #SST pixel lat & lon
               sst_lon = locs$pixel_lon[i], #SST pixel lat & lon
               tanB = NA) #tanB AKA beach slope (used if wave run-up is included)
    }
#  }
}

for(i in 1:length(locs_modern$Site)){
  #for(s in c(0,22.5,45,67.5,90)){\
    for(y in c(2019,2020,2021,2022,2023)){
      if(file.exists(paste(coderoot,"NOAH_messages.txt",sep=""))){
        p<-paste("cd ",coderoot,"&del NOAH_messages.txt")
        shell(p,"cmd",translate=TRUE)
      }
      print(c(locs_modern$Site[i],y))
      run_noah(year = y, #years of interest
               latitude = locs_modern$Latitude[i], #site lat
               longitude = locs_modern$Longitude[i], #site lon
               site = locs_modern$Site[i], #site name (no spaces)
               region = locs_modern$xtide_station_name[i], #nearest xtide station
               height = locs_modern$height[i], #vertical height
               slope = locs_modern$slope, #slope of rock surface
               aspect = locs_modern$azimuth[i], #azimuth of rock surface
               layer = 0, #layer of model (0=shell temperature)
               albedo = 0.4, #best estimate of Galicia barnacle albedo
               sst_lat = locs_modern$pixel_lat[i], #SST pixel lat & lon
               sst_lon = locs_modern$pixel_lon[i], #SST pixel lat & lon
               tanB = NA) #tanB AKA beach slope (used if wave run-up is included)
    }
#  }
}
