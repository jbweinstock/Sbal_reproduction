## NE Atlantic Semibalanus balanoides reproduction summaries
## Date created: 04.06.23
## Date updated: 11.06.24


library(chron) #as.Date function
library(zoo)
library(lubridate) #yday function


# LOAD DATA
#####
data_2000s = read.csv("data/DataLog_2000s_Falm2019.csv",
                      na.strings = c("NA",""), 
                      fileEncoding="UTF-8-BOM") #prevents first colname from getting ï character
data_log <- read.csv("data/DataLog_2020_21.csv",
                     na.strings = c("NA",""), fileEncoding="UTF-8-BOM")
data_log_2022 <- read.csv("data/DataLog_2021_22.csv",
                          na.strings = c("NA",""), fileEncoding="UTF-8-BOM")
data_log_2023 <- read.csv("data/DataLog_2022_23.csv",
                          na.strings = c("NA",""), fileEncoding="UTF-8-BOM")
data_log_2024 <- read.csv("data/DataLog_2023_24.csv",
                          na.strings = c("NA",""), fileEncoding="UTF-8-BOM")

# POSTPROCESSING + STANDARDIZING
#####
data_2000s$date = as.Date(data_2000s$date,"%m/%d/%Y")
data_2000s$month = format(data_2000s$date,"%b")
data_2000s$DOY = yday(data_2000s$date)
data_2000s$DOY_shifted = ifelse(data_2000s$DOY > 200, #to center around reproduction (which spans New Year)
                                yes = data_2000s$DOY - 365,
                                no = data_2000s$DOY)

data_2000s$survey_year = ifelse(format(data_2000s$date,"%Y")=="2002",
                                yes = "2002-03",
                                no = ifelse(format(data_2000s$date,"%Y")=="2004",
                                            yes = "2003-04",
                                            no = ifelse(format(data_2000s$date,"%Y")=="2019" | 
                                                          format(data_2000s$date,"%Y")=="2020",
                                                        yes = "2019-20",
                                                        no = ifelse(format(data_2000s$date,"%Y")=="2003" &
                                                                      data_2000s$DOY < 200,
                                                                    yes = "2002-03",
                                                                    no = "2003-04"))))

data_log$perc_repr = data_log$perc_early + data_log$perc_late
data_log$date = as.Date(data_log$date_collected, "%m/%d/%Y")
data_log$survey_year = "2020-21"
data_log$DOY = yday(data_log$date)
data_log$DOY_shifted = ifelse(data_log$DOY > 200,
                              yes = data_log$DOY - 365,
                              no = data_log$DOY)

data_log_2022$perc_repr = data_log_2022$perc_early + data_log_2022$perc_late
data_log_2022$date = as.Date(data_log_2022$date_collected, "%m/%d/%Y")
data_log_2022$survey_year = "2021-22"
data_log_2022$DOY = yday(data_log_2022$date)
data_log_2022$DOY_shifted = ifelse(data_log_2022$DOY > 200,
                                   yes = data_log_2022$DOY - 365,
                                   no = data_log_2022$DOY)

data_log_2023$perc_repr = data_log_2023$perc_early + data_log_2023$perc_late
data_log_2023$date = as.Date(data_log_2023$date_collected, "%m/%d/%Y")
data_log_2023$survey_year = "2022-23"
data_log_2023$DOY = yday(data_log_2023$date)
data_log_2023$DOY_shifted = ifelse(data_log_2023$DOY > 200,
                                   yes = data_log_2023$DOY - 365,
                                   no = data_log_2023$DOY)

data_log_2024$perc_repr = data_log_2024$perc_early + data_log_2024$perc_late
data_log_2024$date = as.Date(data_log_2024$date_collected, "%m/%d/%Y")
data_log_2024$survey_year = "2023-24"
data_log_2024$DOY = yday(data_log_2024$date)
data_log_2024$DOY_shifted = ifelse(data_log_2024$DOY > 200,
                                   yes = data_log_2024$DOY - 365,
                                   no = data_log_2024$DOY)

# SEPARATE BY SITE
#####
WH_2003_04 = subset(data_2000s, data_2000s$site == "Falmouth")
PS_2020 = subset(data_2000s, data_2000s$survey_year == "2019-20")
PS_2021 = subset(data_log, data_log$site == "Falmouth")
PS_2022 = subset(data_log_2022, data_log_2022$site == "Falmouth")
PS_2023 = subset(data_log_2023, data_log_2023$site == "Falmouth")
PS_2024 = subset(data_log_2024, data_log_2024$site == "Falmouth")


Nh_2003_04 = subset(data_2000s, data_2000s$site == "Nahant")
Nh_2021 = subset(data_log, data_log$site == "Nahant")
Nh_2022 = subset(data_log_2022, data_log_2022$site == "Nahant")
Nh_2023 = subset(data_log_2023, data_log_2023$site == "Nahant")


Nw_2003_04 = subset(data_2000s, data_2000s$site == "Newagen")
Nw_2021 = subset(data_log, data_log$site == "Newagen")
Nw_2022 = subset(data_log_2022, data_log_2022$site == "Newagen")
Nw_2023 = subset(data_log_2023, data_log_2023$site == "Newagen")


Hal_2003_04 = subset(data_2000s, data_2000s$site == "Halifax")
Hal_2021 = subset(data_log, data_log$site == "Halifax")
Hal_2022 = subset(data_log_2022, data_log_2022$site == "Halifax")
Hal_2023 = subset(data_log_2023, data_log_2023$site == "Halifax")


NN_2003_04 = subset(data_2000s, data_2000s$site == "Noyes Neck")
MH_2003_04 = subset(data_2000s, data_2000s$site == "Mt Hope")
OB_2003_04 = subset(data_2000s, data_2000s$site == "Oak Bluffs")
DMC_2003_04 = subset(data_2000s, data_2000s$site == "DMC")


