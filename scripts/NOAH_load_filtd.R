## Load + combine filtered NOAH output files
## Date created: 05.15.24
## Date updated: 11.07.24

library(zoo)
library(dplyr)
Sys.setenv(TZ="UTC") #times in UTC

## LOAD DATA AND ADD DESCRIPTIVE COLUMNS
NOAH_LST_wd = "data/NOAH_filt_temps/"

NOAH_Hal_filtd = rbind(read.csv(paste(NOAH_LST_wd,"Halifax2002-04.csv",sep=""),
                                na.strings = c("NA","","NaN","NaT")),
                       read.csv(paste(NOAH_LST_wd,"Halifax2019-23.csv",sep=""),
                                na.strings = c("NA","","NaN","NaT")))

NOAH_Hal_filtd$datetime = as.POSIXct(NOAH_Hal_filtd$datetime,
                                     "%Y-%m-%d %H:%M", tz = "UTC")
NOAH_Hal_filtd$date <- as.Date(format(NOAH_Hal_filtd$datetime,"%Y-%m-%d"))
NOAH_Hal_filtd$year = format(NOAH_Hal_filtd$date,"%Y")


NOAH_DMC_filtd = read.csv(paste(NOAH_LST_wd,"DamDMC2002-04.csv",sep=""),
                          na.strings = c("NA","","NaN","NaT"))

NOAH_DMC_filtd$datetime = as.POSIXct(NOAH_DMC_filtd$datetime,
                                     "%Y-%m-%d %H:%M", tz = "UTC")
NOAH_DMC_filtd$date <- as.Date(format(NOAH_DMC_filtd$datetime,"%Y-%m-%d"))
NOAH_DMC_filtd$year = format(NOAH_DMC_filtd$date,"%Y")


NOAH_Nw_filtd = rbind(read.csv(paste(NOAH_LST_wd,"Newagen2002-04.csv",sep=""),
                               na.strings = c("NA","","NaN","NaT")),
                      read.csv(paste(NOAH_LST_wd,"Newagen2019-23.csv",sep=""),
                               na.strings = c("NA","","NaN","NaT")))

NOAH_Nw_filtd$datetime = as.POSIXct(NOAH_Nw_filtd$datetime,
                                    "%Y-%m-%d %H:%M", tz = "UTC")
NOAH_Nw_filtd$date <- as.Date(format(NOAH_Nw_filtd$datetime,"%Y-%m-%d"))
NOAH_Nw_filtd$year = format(NOAH_Nw_filtd$date,"%Y")


NOAH_Nh_filtd = rbind(read.csv(paste(NOAH_LST_wd,"Nahant2002-04.csv",sep=""),
                               na.strings = c("NA","","NaN","NaT")),
                      read.csv(paste(NOAH_LST_wd,"Nahant2019-23.csv",sep=""),
                               na.strings = c("NA","","NaN","NaT")))

NOAH_Nh_filtd$datetime = as.POSIXct(NOAH_Nh_filtd$datetime,
                                    "%Y-%m-%d %H:%M", tz = "UTC")
NOAH_Nh_filtd$date <- as.Date(format(NOAH_Nh_filtd$datetime,"%Y-%m-%d"))
NOAH_Nh_filtd$year = format(NOAH_Nh_filtd$date,"%Y")


NOAH_Fal_filtd = rbind(read.csv(paste(NOAH_LST_wd,"Falmouth2002-04.csv",sep=""),
                                na.strings = c("NA","","NaN","NaT")),
                       read.csv(paste(NOAH_LST_wd,"Falmouth2019-23.csv",sep=""),
                                na.strings = c("NA","","NaN","NaT")))

NOAH_Fal_filtd$datetime = as.POSIXct(NOAH_Fal_filtd$datetime,
                                     "%Y-%m-%d %H:%M", tz = "UTC")
NOAH_Fal_filtd$date <- as.Date(format(NOAH_Fal_filtd$datetime,"%Y-%m-%d"))
NOAH_Fal_filtd$year = format(NOAH_Fal_filtd$date,"%Y")


NOAH_OB_filtd = read.csv(paste(NOAH_LST_wd,"OakBluffs2002-04.csv",sep=""),
                         na.strings = c("NA","","NaN","NaT"))

NOAH_OB_filtd$datetime = as.POSIXct(NOAH_OB_filtd$datetime,
                                    "%Y-%m-%d %H:%M", tz = "UTC")
NOAH_OB_filtd$date <- as.Date(format(NOAH_OB_filtd$datetime,"%Y-%m-%d"))
NOAH_OB_filtd$year = format(NOAH_OB_filtd$date,"%Y")


NOAH_NN_filtd = read.csv(paste(NOAH_LST_wd,"NoyesNeck2002-04.csv",sep=""),
                         na.strings = c("NA","","NaN","NaT"))

NOAH_NN_filtd$datetime = as.POSIXct(NOAH_NN_filtd$datetime,
                                    "%Y-%m-%d %H:%M", tz = "UTC")
NOAH_NN_filtd$date <- as.Date(format(NOAH_NN_filtd$datetime,"%Y-%m-%d"))
NOAH_NN_filtd$year = format(NOAH_NN_filtd$date,"%Y")


NOAH_MH_filtd = read.csv(paste(NOAH_LST_wd,"MtHope2002-04.csv",sep=""),
                         na.strings = c("NA","","NaN","NaT"))

NOAH_MH_filtd$datetime = as.POSIXct(NOAH_MH_filtd$datetime,
                                    "%Y-%m-%d %H:%M", tz = "UTC")
NOAH_MH_filtd$date <- as.Date(format(NOAH_MH_filtd$datetime,"%Y-%m-%d"))
NOAH_MH_filtd$year = format(NOAH_MH_filtd$date,"%Y")


