## NE S. balanoides reproduction vs temperature
## Date created: 04.11.23
## Date updated: 11.07.24


library(chron)
library(zoo)
library(lubridate)
library(ggplot2)
library(reshape2)
library(Rmisc)
library(dplyr)
library(tidyr)
library(forcats)
library(viridis)


## LOAD/PROCESS TEMP DATA, CALCULATE TEMP AVG'S
#####
source("scripts/phenology.R")
source("scripts/NOAH_load_filtd.R")

release_est$brood_temp = NA      #avg filt. intert. temp from eggs_0.5 to rel_0.5
release_est$fall_avgT = NA       #Sept 22 - Nov 22
release_est$egg50date = NA
release_est$rel50date = NA
release_est$fall_year = NA
release_est$colddays_count = NA  #for proportion of filtered temp conditions below 0°C

for(i in 1:length(release_est$site)){
  eggsyear = strsplit(release_est$survey_year[i],"-")[[1]][1]
  relyear = ifelse(release_est$rel_0.5[i] < 0,
                   yes = strsplit(release_est$survey_year[i],"-")[[1]][1],
                   no = paste("20",strsplit(release_est$survey_year[i],"-")[[1]][2],sep=""))
  
  eggs50 = as.Date(release_est$eggs_0.5[i] + 365, 
                   origin = paste(as.character(as.numeric(eggsyear) - 1),"12-31",sep="-"))
  rel50 = as.Date(ifelse(release_est$rel_0.5[i] < 0,
                         yes = release_est$rel_0.5[i] + 365,
                         no = release_est$rel_0.5[i]),
                  origin = paste(as.character(as.numeric(relyear) - 1),"12-31",sep="-"))
  
  release_est$egg50date[i] = as.Date(eggs50)
  release_est$rel50date[i] = as.Date(rel50)
  release_est$fall_year[i] = eggsyear

  Nov20 = as.POSIXct(paste(as.character(as.numeric(eggsyear)),"11-20",sep="-"))
  fallstart = as.POSIXct(paste(as.character(as.numeric(eggsyear)),"09-22",sep="-")) #START OF FALL
  fallend = as.POSIXct(paste(as.character(as.numeric(eggsyear)),"12-22",sep="-")) #Nov-22 INCLUDES ALL 50% FERT DATES

  if(release_est$site[i] == "Halifax"){
    release_est$brood_temp[i] = mean(NOAH_Hal_filtd$filtT[NOAH_Hal_filtd$date > eggs50 & 
                                                            NOAH_Hal_filtd$date < rel50])
    release_est$fall_avgT[i] = mean(NOAH_Hal_filtd$filtT[NOAH_Hal_filtd$date >= fallstart & 
                                                           NOAH_Hal_filtd$date <= fallend])
    
    release_est$colddays_count[i] = length(subset(NOAH_Hal_filtd$filtT[NOAH_Hal_filtd$date >= fallstart &
                                                                         NOAH_Hal_filtd$date <= Nov20],
                                                  NOAH_Hal_filtd$filtT[NOAH_Hal_filtd$date >= fallstart &
                                                                         NOAH_Hal_filtd$date <= Nov20] < 0)) / 
      length(NOAH_Hal_filtd$filtT[NOAH_Hal_filtd$date >= fallstart & NOAH_Hal_filtd$date <= Nov20])
  }
  if(release_est$site[i] == "Falmouth"){
    release_est$brood_temp[i] = mean(NOAH_Fal_filtd$filtT[NOAH_Fal_filtd$date > eggs50 & 
                                                            NOAH_Fal_filtd$date < rel50])
    release_est$fall_avgT[i] = mean(NOAH_Fal_filtd$filtT[NOAH_Fal_filtd$date >= fallstart & 
                                                           NOAH_Fal_filtd$date <= fallend])
    
    release_est$colddays_count[i] = length(subset(NOAH_Fal_filtd$filtT[NOAH_Fal_filtd$date >= fallstart &
                                                                         NOAH_Fal_filtd$date <= Nov20],
                                                  NOAH_Fal_filtd$filtT[NOAH_Fal_filtd$date >= fallstart &
                                                                         NOAH_Fal_filtd$date <= Nov20] < 0)) / 
      length(NOAH_Fal_filtd$filtT[NOAH_Fal_filtd$date >= fallstart & NOAH_Fal_filtd$date <= Nov20])
  }
  if(release_est$site[i] == "Nahant"){
    release_est$brood_temp[i] = mean(NOAH_Nh_filtd$filtT[NOAH_Nh_filtd$date > eggs50 & 
                                                           NOAH_Nh_filtd$date < rel50])
    release_est$fall_avgT[i] = mean(NOAH_Nh_filtd$filtT[NOAH_Nh_filtd$date >= fallstart & 
                                                          NOAH_Nh_filtd$date <= fallend])
    
    release_est$colddays_count[i] = length(subset(NOAH_Nh_filtd$filtT[NOAH_Nh_filtd$date >= fallstart &
                                                                        NOAH_Nh_filtd$date <= Nov20],
                                                  NOAH_Nh_filtd$filtT[NOAH_Nh_filtd$date >= fallstart &
                                                                        NOAH_Nh_filtd$date <= Nov20] < 0)) / 
      length(NOAH_Nh_filtd$filtT[NOAH_Nh_filtd$date >= fallstart & NOAH_Nh_filtd$date <= Nov20])
  }
  if(release_est$site[i] == "Newagen"){
    release_est$brood_temp[i] = mean(NOAH_Nw_filtd$filtT[NOAH_Nw_filtd$date > eggs50 & 
                                                           NOAH_Nw_filtd$date < rel50])
    release_est$fall_avgT[i] = mean(NOAH_Nw_filtd$filtT[NOAH_Nw_filtd$date >= fallstart & 
                                                          NOAH_Nw_filtd$date <= fallend])
    
    release_est$colddays_count[i] = length(subset(NOAH_Nw_filtd$filtT[NOAH_Nw_filtd$date >= fallstart &
                                                                        NOAH_Nw_filtd$date <= Nov20],
                                                  NOAH_Nw_filtd$filtT[NOAH_Nw_filtd$date >= fallstart &
                                                                        NOAH_Nw_filtd$date <= Nov20] < 0)) / 
      length(NOAH_Nw_filtd$filtT[NOAH_Nw_filtd$date >= fallstart & NOAH_Nw_filtd$date <= Nov20])
  }
  if(release_est$site[i] == "DMC"){
    release_est$brood_temp[i] = mean(NOAH_DMC_filtd$filtT[NOAH_DMC_filtd$date > eggs50 & 
                                                            NOAH_DMC_filtd$date < rel50])
    
    release_est$fall_avgT[i] = mean(NOAH_DMC_filtd$filtT[NOAH_DMC_filtd$date >= fallstart & 
                                                           NOAH_DMC_filtd$date <= fallend])
    
    release_est$colddays_count[i] = length(subset(NOAH_DMC_filtd$filtT[NOAH_DMC_filtd$date >= fallstart &
                                                                         NOAH_DMC_filtd$date <= Nov20],
                                                  NOAH_DMC_filtd$filtT[NOAH_DMC_filtd$date >= fallstart &
                                                                         NOAH_DMC_filtd$date <= Nov20] < 0)) / 
      length(NOAH_DMC_filtd$filtT[NOAH_DMC_filtd$date >= fallstart & NOAH_DMC_filtd$date <= Nov20])
  }
  if(release_est$site[i] == "Oak Bluffs"){
    release_est$brood_temp[i] = mean(NOAH_OB_filtd$filtT[NOAH_OB_filtd$date > eggs50 & 
                                                           NOAH_OB_filtd$date < rel50])
    release_est$fall_avgT[i] = mean(NOAH_OB_filtd$filtT[NOAH_OB_filtd$date >= fallstart & 
                                                          NOAH_OB_filtd$date <= fallend])
    
    release_est$colddays_count[i] = length(subset(NOAH_OB_filtd$filtT[NOAH_OB_filtd$date >= fallstart &
                                                                        NOAH_OB_filtd$date <= Nov20],
                                                  NOAH_OB_filtd$filtT[NOAH_OB_filtd$date >= fallstart &
                                                                        NOAH_OB_filtd$date <= Nov20] < 0)) / 
      length(NOAH_OB_filtd$filtT[NOAH_OB_filtd$date >= fallstart & NOAH_OB_filtd$date <= Nov20])
  }
  if(release_est$site[i] == "Mt Hope"){
    release_est$brood_temp[i] = mean(NOAH_MH_filtd$filtT[NOAH_MH_filtd$date > eggs50 & 
                                                           NOAH_MH_filtd$date < rel50])
    release_est$fall_avgT[i] = mean(NOAH_MH_filtd$filtT[NOAH_MH_filtd$date >= fallstart & 
                                                          NOAH_MH_filtd$date <= fallend])
    
    release_est$colddays_count[i] = length(subset(NOAH_MH_filtd$filtT[NOAH_MH_filtd$date >= fallstart &
                                                                        NOAH_MH_filtd$date <= Nov20],
                                                  NOAH_MH_filtd$filtT[NOAH_MH_filtd$date >= fallstart &
                                                                        NOAH_MH_filtd$date <= Nov20] < 0)) / 
      length(NOAH_MH_filtd$filtT[NOAH_MH_filtd$date >= fallstart & NOAH_MH_filtd$date <= Nov20])
  }
  if(release_est$site[i] == "Noyes Neck"){
    release_est$brood_temp[i] = mean(NOAH_NN_filtd$filtT[NOAH_NN_filtd$date > eggs50 & 
                                                           NOAH_NN_filtd$date < rel50])
    release_est$fall_avgT[i] = mean(NOAH_NN_filtd$filtT[NOAH_NN_filtd$date >= fallstart & 
                                                          NOAH_NN_filtd$date <= fallend])
    
    release_est$colddays_count[i] = length(subset(NOAH_NN_filtd$filtT[NOAH_NN_filtd$date >= fallstart &
                                                                        NOAH_NN_filtd$date <= Nov20],
                                                  NOAH_NN_filtd$filtT[NOAH_NN_filtd$date >= fallstart &
                                                                        NOAH_NN_filtd$date <= Nov20] < 0)) / 
      length(NOAH_NN_filtd$filtT[NOAH_NN_filtd$date >= fallstart & NOAH_NN_filtd$date <= Nov20])
  }
}

release_est$egg50date = as.Date(release_est$egg50date)
release_est$rel50date = as.Date(release_est$rel50date)
release_est$egg50_doy = release_est$eggs_0.5 + 365

release_est$survey_years = ifelse(release_est$survey_year == "2002-03" | 
                                    release_est$survey_year == "2003-04",
                                  yes = "2002-04",
                                  no = "2019-23")

release_est$fall_year = format(as.Date(release_est$fall_year,"%Y"),"%Y")


modern_phenology = subset(release_est,release_est$site == "Halifax"|
                            release_est$site=="Newagen"|
                            release_est$site=="Nahant"|
                            release_est$site=="Falmouth")

fall_avgs = aggregate(fall_avgT ~ site, FUN = mean, data = subset(modern_phenology,
                                                                  is.na(modern_phenology$eggs_0.5)==FALSE))
F50_avgs = aggregate(eggs_0.5 ~ site, FUN = mean, data = subset(modern_phenology,
                                                                is.na(modern_phenology$eggs_0.5)==FALSE))

fall_avgs$F50 = F50_avgs$eggs_0.5


## CODE FOR FIGURE 4
delay_df = modern_phenology[,1:2]
delay_df$egg_0.5 = modern_phenology$eggs_0.5
delay_df$rel_0.5 = modern_phenology$rel_0.5
delay_df$fall_avgT = modern_phenology$fall_avgT
delay_df$freezing = modern_phenology$colddays_count
delay_df$F50_delay = NA
delay_df$fall_warming = NA

delay_df$year = NA
for(i in 1:length(delay_df$site)){
  for(l in 1:length(fall_avgs$site)){
    if(delay_df$site[i] == fall_avgs$site[l]){
      delay_df$F50_delay[i] = delay_df$egg_0.5[i] - fall_avgs$F50[l]
      delay_df$fall_warming[i] = delay_df$fall_avgT[i] - fall_avgs$fall_avgT[l]
    }
  }
  delay_df$year[i] = strsplit(delay_df$survey_year[i],"-")[[1]][1]
}
delay_df$site = factor(delay_df$site,
                       levels = c("Halifax","Newagen","Nahant","Falmouth"))

summary(lm(F50_delay ~ fall_warming,
           data = subset(delay_df, delay_df$freezing == 0)))

anomalies <- ggplot(data = subset(delay_df, delay_df$freezing == 0), 
                    aes(x=year,y=fall_avgT,
                        fill = factor(site))) + 
  theme_bw(base_size = 18) + 
  geom_point(data = subset(delay_df, delay_df$freezing != 0), 
             aes(x=year,y=fall_avgT),
             pch=25,size=5,alpha=0.8,
             show.legend = FALSE) + 
  geom_point(size=5,pch=21,alpha=0.8) + 
  scale_fill_manual(values = (c("#000004", "#982d80","#5f187f",
                                "#d3436e")),
                    name = "Site") + 
  xlab("Survey year") + 
  ylab("Avg. fall intertidal temperature (°C)")

delay <- ggplot(data = subset(delay_df, delay_df$freezing == 0), 
                aes(x=fall_warming,y=F50_delay)) + 
  theme_bw(base_size = 18) + 
  geom_smooth(method="lm") + 
  geom_hline(yintercept = 0) + 
  geom_vline(xintercept = 0) + 
  #geom_abline(slope=1,intercept = 0,linetype = "dashed") + 
  geom_point(aes(fill=site),size=5,pch=21,alpha=0.8) + 
  geom_point(data = subset(delay_df, delay_df$freezing != 0), 
             aes(x=fall_warming,y=F50_delay,
                 fill=site),
             pch=25,size=5,alpha=0.8,
             show.legend = FALSE) +
  xlab("Fall intertidal temperature anomaly (°C)") + 
  ylab("Fertilization anomaly (days)") + 
  scale_fill_manual(values = (c("#000004", "#5f187f","#982d80",
                                "#d3436e")),
                    labels = c("Halifax","Newagen","Nahant","Falmouth"),
                    name = "Site")

ggarrange(anomalies, delay,
          nrow = 1,ncol=2,
          align="hv",
          common.legend = TRUE,
          legend = "right") 
      #legend is wrong, taken from panel a, but the data + colors 
      #  are right in the plots!


## CODE FOR FIGURE 5
summary(lm(log(release_est$brood) ~ release_est$brood_temp))

brood_v1 <- ggplot(subset(release_est, 
              is.na(release_est$brood_temp)==FALSE), 
       aes(x=brood_temp,y=brood)) + 
  geom_smooth(method="glm") + 
  geom_point(aes(fill=site,shape=survey_year),
             size=4,stroke=1,alpha=0.8) + 
  theme_bw(base_size = 16) + 
  scale_y_continuous(trans = scales::log_trans(),
                     breaks = c(30,60,90,120,150)) +
  scale_shape_manual(values=c(21,22,23,24,25),
                     labels = c("2003-04","2019-20","2020-21",
                                "2021-22","2022-23")) +
  scale_fill_viridis(option="A",
                     discrete=TRUE,
                     labels=c("Halifax","Damariscotta/DMC","Newagen",
                              "Nahant","Falmouth",
                              "Oak Bluffs","Mt Hope","Noyes Neck")) +
  xlab("Average temp. (°C) during brooding") + 
  ylab("Days brooding") + 
  guides(fill = guide_legend(override.aes = list(shape = 21),
                             title="Site"),
         shape=guide_legend(title="Sampling Year")) + 
  geom_label(label="Adj. R-squared = 0.612\n p << 0.001", 
             aes(x=3,y=50))


brood_v2 <- ggplot(subset(release_est, 
                       is.na(release_est$brood_temp)==FALSE), 
                aes(x=brood_temp,y=brood)) + 
  geom_smooth(method="glm") + 
  geom_point(aes(fill=site,shape=survey_years),
             size=4,stroke=1,alpha=0.8) + 
  theme_bw(base_size = 12) + 
  scale_y_continuous(trans = scales::log_trans(),
                     breaks = c(30,60,90,120,150)) +
  scale_shape_manual(values=c(24,21),
                     labels = c("2002-04","2019-23")) +
  scale_fill_viridis(option="A",
                     discrete=TRUE,
                     labels=c("Halifax","Damariscotta/DMC","Newagen",
                              "Nahant","Falmouth",
                              "Oak Bluffs","Mt Hope","Noyes Neck")) +
  xlab("Avg intertidal temp. (°C) during brooding") + 
  ylab("Days brooding") + 
  guides(shape = guide_legend(title="Sampling Years"),
         fill=guide_legend(override.aes = list(shape = 21),
                           title="Site")) + 
  geom_label(label="Adj. R-squared = 0.612\n p << 0.001", 
             aes(x=3,y=50))


## CODE FOR FIGURE 2, PANELS c & d
PS_temps_plot <- ggplot() + 
  geom_line(data = NOAH_Fal_filtd,
            aes(x=datetime,y=body_temp,col=body_temp),size=0.7) +
  geom_vline(xintercept = as.POSIXct("2022-01-20"),size=2,col="white") +
  scale_x_datetime(limits=c(as.POSIXct("2021-10-15"),as.POSIXct("2022-05-01")),
                   #as.POSIXct("2022-07-01")),
                   date_labels = "%b", date_breaks="1 month") + 
  scale_y_continuous(limits=c(-12.1,23),name="Intertidal temperature (°C)") +
  scale_color_viridis(option="turbo",limits = c(-12,25)) + 
  labs(col = "°C") + 
  geom_vline(xintercept = as.POSIXct(subset(release_est, release_est$site == "Falmouth")$egg50date),
             linetype="dashed",size=1) + 
  geom_vline(xintercept = as.POSIXct(subset(release_est, release_est$site == "Falmouth")$rel50date),
             linetype="dashed",size=1) + 
  geom_rect(aes(xmin = as.POSIXct("2021-11-16"), xmax = as.POSIXct("2022-01-20"), 
                ymin = -8, ymax = 15.8),fill=NA,col="black") + 
  theme_bw() + guides(col="none")  +
  theme(axis.text=element_text(size=14),
        axis.title=element_text(size=18))

Hal_temps_plot <- ggplot() + 
  geom_line(data = NOAH_Hal_filtd,
            aes(x=datetime,y=body_temp,col=body_temp),size=0.7) +
  geom_vline(xintercept = as.POSIXct("2022-03-10"),size=2,col="white") +
  scale_x_datetime(limits=c(as.POSIXct("2021-10-15"),as.POSIXct("2022-05-01")),
                   name="date", date_labels = "%b", date_breaks="1 month") + 
  scale_y_continuous(limits=c(-12.1,23),name="Intertidal temperature (°C)") +
  scale_color_viridis(option="turbo",limits = c(-12,25)) + 
  labs(col = "°C") + 
  geom_vline(xintercept = as.POSIXct(subset(release_est, release_est$site == "Halifax")$egg50date),
             linetype="dashed",size=1) + 
  geom_vline(xintercept = as.POSIXct(subset(release_est, release_est$site == "Halifax")$rel50date),
             linetype="dashed",size=1) + 
  geom_rect(aes(xmin = as.POSIXct("2021-11-18"), xmax = as.POSIXct("2022-03-09"), 
                ymin = -12, ymax = 15),fill=NA,col="black") + 
  geom_rect(aes(xmin = as.POSIXct("2022-03-11"), xmax = as.POSIXct("2022-05-14"), 
                ymin =0.5, ymax = 7),fill=NA,col="black") + 
  theme_bw() + guides(col="none") +
  theme(axis.text=element_text(size=14),
        axis.title=element_text(size=18))

temp_plots <- ggarrange(Hal_temps_plot,PS_temps_plot,
                        ncol=2,
                        align="hv",
                        common.legend = TRUE,
                        legend = "right")


