## NE Atlantic Semibalanus balanoides reproduction phenology analysis
## Date created: 08.29.23
## Date updated: 11.06.24


library(chron)
library(zoo)

source("scripts/data_load_proc.R")


## GATHER DATA INTO LISTS + SET UP LOGISTIC FUNCTION
reprod_list_23col = list(subset(NN_2003_04, NN_2003_04$survey_year == "2002-03"),
                         subset(NN_2003_04, NN_2003_04$survey_year == "2003-04"),
                         subset(MH_2003_04, MH_2003_04$survey_year == "2002-03"),
                         subset(MH_2003_04, MH_2003_04$survey_year == "2003-04"),
                         subset(OB_2003_04, OB_2003_04$survey_year == "2002-03"),
                         subset(OB_2003_04, OB_2003_04$survey_year == "2003-04"),
                         subset(WH_2003_04, WH_2003_04$survey_year == "2002-03"),
                         subset(WH_2003_04, WH_2003_04$survey_year == "2003-04"),
                         PS_2020,
                         subset(Nh_2003_04, Nh_2003_04$survey_year == "2002-03"),
                         subset(Nh_2003_04, Nh_2003_04$survey_year == "2003-04"),
                         subset(DMC_2003_04, DMC_2003_04$survey_year == "2002-03"),
                         subset(DMC_2003_04, DMC_2003_04$survey_year == "2003-04"),
                         subset(Nw_2003_04, Nw_2003_04$survey_year == "2002-03"),
                         subset(Nw_2003_04, Nw_2003_04$survey_year == "2003-04"),
                         subset(Hal_2003_04, Hal_2003_04$survey_year == "2002-03"),
                         subset(Hal_2003_04, Hal_2003_04$survey_year == "2003-04"))

reprod_list_34col = list(Nh_2021, Nw_2021, PS_2021, Hal_2021,
                         Hal_2022, Nh_2022, Nw_2022, PS_2022,
                         Hal_2023, Nh_2023, Nw_2023, PS_2023,PS_2024)


logistic_reg = function(Data, Trials, Time){
  model = glm(Trials ~ Time, 
              data = Data, 
              family = quasibinomial(link = "logit")
  )
  DOY_50 = (log(0.50/(1-0.50)) - coef(model)[1])/coef(model)[2]
  return(DOY_50)
}


## PULLING OUT DATES OF 50% FERTILIZATION + LARVAL REASE
release_est = as.data.frame(matrix(0L, ncol = 4,
                                   nrow = (length(reprod_list_23col) + length(reprod_list_34col))))
colnames(release_est) = c("site","survey_year","eggs_0.5","rel_0.5")

for(n in 1:length(reprod_list_23col)){
  reprod_list_23col[[n]]$nonrep_scaled = 
    (reprod_list_23col[[n]]$perc_nonrep - min(reprod_list_23col[[n]]$perc_nonrep)) / 
    (1 - min(reprod_list_23col[[n]]$perc_nonrep))
  reprod_list_23col[[n]]$fertilized = 1 - reprod_list_23col[[n]]$nonrep_scaled
  
  reprod_list_23col[[n]]$early_scaled = 
    (reprod_list_23col[[n]]$perc_early) / 
    (1 - min(reprod_list_23col[[n]]$perc_nonrep))
  reprod_list_23col[[n]]$late_scaled = 
    (reprod_list_23col[[n]]$perc_late) /
    (1 - min(reprod_list_23col[[n]]$perc_nonrep))
  
  reprod_list_23col[[n]]$FLAG = (reprod_list_23col[[n]]$nonrep_scaled + 
                                   reprod_list_23col[[n]]$early_scaled + 
                                   reprod_list_23col[[n]]$late_scaled) #should all = 1
  
  data_subset = subset(reprod_list_23col[[n]], 
                       reprod_list_23col[[n]]$date >= reprod_list_23col[[n]]$date[round(mean(which(reprod_list_23col[[n]]$fertilized > 0.95)))])
  
  Trials = cbind(data_subset$nonrep_scaled, (1-data_subset$nonrep_scaled))
  Time = data_subset$DOY_shifted
  model = glm(Trials ~ Time, 
              data = data_subset, 
              family = quasibinomial(link = "logit"))
  DOY_50 = (log(0.50/(1-0.50)) - coef(model)[1])/coef(model)[2]
  
  release_est$site[n] = data_subset$site[1]
  release_est$survey_year[n] = data_subset$survey_year[1]
  release_est$rel_0.5[n] = DOY_50
  
  data_subset_eggs = subset(reprod_list_23col[[n]], 
                            reprod_list_23col[[n]]$date <= reprod_list_23col[[n]]$date[round(mean(which(reprod_list_23col[[n]]$fertilized > 0.95)))])
  
  Trials_eggs = cbind((data_subset_eggs$fertilized), 
                      (1-(data_subset_eggs$fertilized)))
  Time_eggs = data_subset_eggs$DOY_shifted
  model_eggs = glm(Trials_eggs ~ Time_eggs, 
                   data = data_subset_eggs, 
                   family = quasibinomial(link = "logit"))
  DOY_eggs_50 = (log(0.50/(1-0.50)) - coef(model_eggs)[1])/coef(model_eggs)[2]
  
  release_est$eggs_0.5[n] = ifelse(reprod_list_23col[[n]]$fertilized[1] < 0.6,
                                   no = NA,
                                   yes = DOY_eggs_50)
}

for(n in 1:length(reprod_list_34col)){
   reprod_list_34col[[n]]$nonrep_scaled = 
    (reprod_list_34col[[n]]$perc_nonrep - min(reprod_list_34col[[n]]$perc_nonrep)) / 
    (1 - min(reprod_list_34col[[n]]$perc_nonrep))
  
   reprod_list_34col[[n]]$fertilized = 1 - reprod_list_34col[[n]]$nonrep_scaled
  
  reprod_list_34col[[n]]$early_scaled = 
    (reprod_list_34col[[n]]$perc_early) / 
    (1 - min(reprod_list_34col[[n]]$perc_nonrep))
  reprod_list_34col[[n]]$late_scaled = 
    (reprod_list_34col[[n]]$perc_late) / 
    (1 - min(reprod_list_34col[[n]]$perc_nonrep))
  
  reprod_list_34col[[n]]$FLAG = (reprod_list_34col[[n]]$nonrep_scaled + 
                                   reprod_list_34col[[n]]$early_scaled + 
                                   reprod_list_34col[[n]]$late_scaled)
  
  data_subset = subset(reprod_list_34col[[n]], 
                       reprod_list_34col[[n]]$date >= reprod_list_34col[[n]]$date[round(mean(which(reprod_list_34col[[n]]$fertilized > 0.96)))])
  
  Trials = cbind(data_subset$nonrep_scaled, (1-data_subset$nonrep_scaled))
  Time = data_subset$DOY_shifted
  model = glm(Trials ~ Time, 
              data = data_subset, 
              family = quasibinomial(link = "logit"))
  DOY_50 = (log(0.50/(1-0.50)) - coef(model)[1])/coef(model)[2]
  
  release_est$site[n + length(reprod_list_23col)] = data_subset$site[1]
  release_est$survey_year[n + length(reprod_list_23col)] = data_subset$survey_year[1]
  release_est$rel_0.5[n + length(reprod_list_23col)] = DOY_50
  
  data_subset_eggs = subset(reprod_list_34col[[n]], 
                            reprod_list_34col[[n]]$date <= reprod_list_34col[[n]]$date[round(mean(which(reprod_list_34col[[n]]$fertilized > 0.96)))])
  
  Trials_eggs = cbind((data_subset_eggs$fertilized), 
                      (1-(data_subset_eggs$fertilized)))
  Time_eggs = data_subset_eggs$DOY_shifted
  model_eggs = glm(Trials_eggs ~ Time_eggs, 
                   data = data_subset_eggs, 
                   family = quasibinomial(link = "logit"))
  DOY_eggs_50 = (log(0.50/(1-0.50)) - coef(model_eggs)[1])/coef(model_eggs)[2]
  
  release_est$eggs_0.5[n + length(reprod_list_23col)] = ifelse(reprod_list_34col[[n]]$fertilized[1] < .6,
                                                               no = NA,
                                                               yes = DOY_eggs_50)
}


# manually re-calculating regressions for 3 special cases
Hal_subs = subset(reprod_list_23col[[17]], 
                  reprod_list_23col[[17]]$date > as.Date("2004-01-20"))

Hal_logist <- logistic_reg(Data = Hal_subs,
                           Trials = cbind(Hal_subs$nonrep_scaled,
                                          (1 - Hal_subs$nonrep_scaled)),
                           Time = Hal_subs$DOY_shifted)
release_est$rel_0.5[17] = Hal_logist

DMC_subs = subset(reprod_list_23col[[13]],
                  reprod_list_23col[[13]]$date < "2003-12-01")
DMC_log_reg <- logistic_reg(Data = DMC_subs,
                            Trials = cbind(DMC_subs$fertilized,
                                           (1 - DMC_subs$fertilized)),
                            Time = DMC_subs$DOY_shifted)

release_est$eggs_0.5[13] = DMC_log_reg


Nh_subs_20 = subset(reprod_list_34col[[1]], 
                    as.Date(reprod_list_34col[[1]]$date) < as.Date("2020-12-05"))
Nh_subs_21 = subset(reprod_list_34col[[1]], 
                    as.Date(reprod_list_34col[[1]]$date) > as.Date("2021-01-26"))

Nh_eggs <- logistic_reg(Data = Nh_subs_20,
                        Trials = cbind(Nh_subs_20$fertilized,
                                       (1 - Nh_subs_20$fertilized)),
                        Time = Nh_subs_20$DOY_shifted)
release_est$eggs_0.5[18] = Nh_eggs

Nh_LR <- logistic_reg(Data = Nh_subs_21,
                      Trials = cbind(Nh_subs_21$fertilized,
                                     (1 - Nh_subs_21$fertilized)),
                      Time = Nh_subs_21$DOY_shifted)
release_est$rel_0.5[18] = Nh_LR


release_est$brood = release_est$rel_0.5 - release_est$eggs_0.5


## ADD DESCRIPTIVE COLUMNS
sites <- read.csv("data/site_locations.csv", #load site lat/lon coordinates
                  fileEncoding="UTF-8-BOM")


release_est$site = factor(release_est$site,
                          levels = c("Halifax",
                                     "DMC","Newagen",
                                     "Nahant",
                                     "Falmouth","Oak Bluffs",
                                     "Mt Hope","Noyes Neck"))

sites$Site_name_full = factor(sites$Site_name_full,
                              levels = c("Halifax",
                                         "DMC","Newagen",
                                         "Nahant",
                                         "Falmouth","Oak Bluffs",
                                         "Mt Hope","Noyes Neck"))

sites_lat = aggregate(Latitude ~ Site_name_full, FUN = "mean", data = sites)

release_est$lat = NA
for(i in 1:length(release_est$site)){
  for(k in 1:length(sites_lat$Site_name_full)){
    if(release_est$site[i] == sites_lat$Site_name_full[k]){
      release_est$lat[i] = sites_lat$Latitude[k]
    }
  }
}

release_est$site_label = paste(release_est$site,
                               " (",round(release_est$lat,digits = 1),"°N)",
                               sep="")
release_est$site_label = factor(release_est$site_label,
                                levels=c("Noyes Neck (41.3°N)","Oak Bluffs (41.5°N)",
                                         "Mt Hope (41.6°N)","Falmouth (41.6°N)",
                                         "Nahant (42.4°N)","Newagen (43.8°N)",
                                         "DMC (43.9°N)","Halifax (44.6°N)"),
                                ordered = TRUE)



