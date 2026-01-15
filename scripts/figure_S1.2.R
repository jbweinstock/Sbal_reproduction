## NE Atlantic Semibalanus balanoides Supp. figure S1.2
## Date created: 10.01.24
## Date updated: 01.14.26


library(chron)
library(zoo)
library(lubridate)
library(ggplot2)


## LOAD DATA
NOAH_Nw_45 = read.csv("C:/Users/Jane/Desktop/Macbook/WHOI/Research/NE_Data/nearshore-temps/procd_NOAH_temps/Newagen2002-04.csv")
NOAH_Nw_filtd <- read.csv("data/NOAH_filt_temps/Newagen2002-04.csv")
Nw_raw_int = read.csv("data/temps_Nw_int.csv")
Nw_raw_sub = read.csv("data/temps_Nw_sub.csv")
Nw_filt_int = read.csv("data/NOAH_filt_temps/temps_Nw_int_filt.csv")
Nw_filt_sub = read.csv("data/NOAH_filt_temps/temps_Nw_sub_filt.csv")
Hal_filt_int = read.csv("R/water_temps/temps_Hal_int_filt.csv") #get filtered logger temps
PS04_filt_int = read.csv("R/water_temps/temps_PS04_int_filt.csv") #get filtered logger temps
PS22_filt_int = read.csv("R/water_temps/temps_PS22_int_filt.csv") #get filtered logger temps

## PLOTS
raw <- ggplot() + ylab("Temperature (°C)") + 
  geom_hline(yintercept = 0,col="black",linetype="dotted") +
  scale_x_datetime(limits=c(as.POSIXct("2003-11-03"),
                            as.POSIXct("2004-01-15")),
                   date_breaks = "2 weeks",
                   date_labels = "%b %d",
                   name="Date") + 
  ylim(-17,28) + 
  geom_line(data=Nw_raw_int, aes(x=as.POSIXct(datetime),y=tempC),
            col="cornflowerblue") + 
  geom_line(data=Nw_raw_sub, aes(x=as.POSIXct(datetime),y=tempC),
            col="blue",lwd=0.8) + 
  geom_line(data=NOAH_Nw_45, aes(x=as.POSIXct(datetime),y=body_temp),
            col="black",lwd=0.8) + 
  theme_classic() + 
  theme(axis.text= element_text(size=14),
        axis.title= element_text(size=18),
        plot.title = element_text(size = 20,hjust = 0.5)) +
  ggtitle(label = "Newagen (2003): hourly data")


filtered <- ggplot() + ylab("Temperature (°C)") + 
  geom_hline(yintercept = 0,col="black",linetype="dotted") +
  scale_x_datetime(limits=c(as.POSIXct("2003-11-03"),
                            as.POSIXct("2004-01-15")),
                   date_breaks = "2 weeks",
                   date_labels = "%b %d",
                   name="Date") + 
  ylim(-17,28) + 
  geom_line(data=Nw_filt_int, aes(x=as.POSIXct(datetime),y=filtT),
            col="cornflowerblue",lwd=0.65) + 
  geom_line(data=Nw_filt_sub, aes(x=as.POSIXct(datetime),y=filtT),
            col="blue",lwd=0.8) + 
  geom_line(data=NOAH_Nw_filtd, aes(x=as.POSIXct(datetime),y=filtT),
            col="black",lwd=0.8) + 
  theme_classic() + 
  theme(axis.text= element_text(size=14),
        axis.title= element_text(size=18),
        plot.title = element_text(size = 20,hjust = 0.5)) +
  ggtitle(label = "Newagen (2003): filtered data")

ggarrange(raw,filtered,
          ncol=2,
          align = "hv",
          labels=c("a","b"),
          label.x = 0.15,
          label.y = 0.9)


## Assess fall model output against logger data via MS and RMSE

# Newagen...
Nw_filt_int_fall = subset(Nw_filt_int, Nw_filt_int$date >= as.Date("2003-09-22") & 
                            Nw_filt_int$date <= as.Date("2003-12-22"))

Nw_filt_int_fall_mini = as.data.frame(Nw_filt_int_fall$datetime)
colnames(Nw_filt_int_fall_mini) = "datetime_round"
Nw_filt_int_fall_mini$datetime_round = floor_date(as.POSIXct(Nw_filt_int_fall_mini$datetime_round),unit ="hour")
Nw_filt_int_fall_mini$filt_log_tempC = Nw_filt_int_fall$filtT

NOAH_Nw_filtd_fall = subset(NOAH_Nw_filtd, NOAH_Nw_filtd$date >= as.Date("2003-09-22")&
                              NOAH_Nw_filtd$date <= as.Date("2003-12-22"))
NOAH_Nw_filtd_fall$datetime_round = floor_date(NOAH_Nw_filtd_fall$datetime, unit ="hour")

Nw_filtd_fall = left_join(NOAH_Nw_filtd_fall, Nw_filt_int_fall_mini, by = "datetime_round")

Newagen03 <- ggplot() + ylab("Temperature (°C)") + 
  geom_hline(yintercept = 0,col="black",linetype="dotted") +
  scale_x_datetime(limits=c(as.POSIXct("2003-09-22"),
                            as.POSIXct("2003-12-22")),
                   date_breaks = "2 weeks",
                   date_labels = "%b %d",
                   name="Date") + 
  ylim(-17,28) + 
  geom_line(data=Nw_filt_int, aes(x=as.POSIXct(datetime),y=filtT),
            col="cornflowerblue",lwd=0.65) + 
  geom_line(data=NOAH_Nw_filtd, aes(x=as.POSIXct(datetime),y=filtT),
            col="black",lwd=0.8) + 
  theme_classic() + 
  theme(axis.text= element_text(size=14),
        axis.title= element_text(size=18),
        plot.title = element_text(size = 20,hjust = 0.5)) +
  ggtitle(label = "Newagen (2003)")

Nw_filtd_fall$ME_i = Nw_filtd_fall$filt_log_tempC - Nw_filtd_fall$filtT
Nw_filtd_fall$ME_i_sq = Nw_filtd_fall$ME_i * Nw_filtd_fall$ME_i

sqrt(sum(Nw_filtd_fall$ME_i_sq,na.rm=TRUE)/length(na.omit(Nw_filtd_fall$ME_i_sq))) #RMSE
(sum(Nw_filtd_fall$ME_i,na.rm=TRUE)/length(na.omit(Nw_filtd_fall$ME_i))) #ME


# Halifax... 
Hal_filt_int_fall = subset(Hal_filt_int, Hal_filt_int$date >= as.Date("2003-09-22") & 
                             Hal_filt_int$date <= as.Date("2003-12-22"))

Hal_filt_int_fall_mini = as.data.frame(Hal_filt_int_fall$datetime)
colnames(Hal_filt_int_fall_mini) = "datetime_round"
Hal_filt_int_fall_mini$datetime_round = floor_date(as.POSIXct(Hal_filt_int_fall_mini$datetime_round),unit ="hour")
Hal_filt_int_fall_mini$filt_log_tempC = Hal_filt_int_fall$filtT

NOAH_Hal_filtd_fall = subset(NOAH_Hal_filtd, NOAH_Hal_filtd$date >= as.Date("2003-09-22")&
                               NOAH_Hal_filtd$date <= as.Date("2003-12-22"))
NOAH_Hal_filtd_fall$datetime_round = floor_date(NOAH_Hal_filtd_fall$datetime, unit ="hour")

Hal_filtd_fall = left_join(NOAH_Hal_filtd_fall, Hal_filt_int_fall_mini, by = "datetime_round")

Halifax03 <- ggplot() + ylab("Temperature (°C)") + 
  geom_hline(yintercept = 0,col="black",linetype="dotted") +
  scale_x_datetime(limits=c(as.POSIXct("2003-09-22"),
                            as.POSIXct("2003-12-22")),
                   date_breaks = "2 weeks",
                   date_labels = "%b %d",
                   name="Date") + 
  ylim(-17,28) + 
  geom_line(data=Hal_filt_int_fall, aes(x=as.POSIXct(datetime),y=filtT),
            col="cornflowerblue",lwd=0.65) + 
  geom_line(data=NOAH_Hal_filtd_fall, aes(x=as.POSIXct(datetime),y=filtT),
            col="black",lwd=0.8) + 
  theme_classic() + 
  theme(axis.text= element_text(size=14),
        axis.title= element_text(size=18),
        plot.title = element_text(size = 20,hjust = 0.5)) +
  ggtitle(label = "Halifax (2003)")

Hal_filtd_fall$ME_i = Hal_filtd_fall$filt_log_tempC - Hal_filtd_fall$filtT
Hal_filtd_fall$ME_i_sq = Hal_filtd_fall$ME_i * Hal_filtd_fall$ME_i

sqrt(sum(Hal_filtd_fall$ME_i_sq,na.rm=TRUE)/length(na.omit(Hal_filtd_fall$ME_i_sq))) #RMSE
(sum(Hal_filtd_fall$ME_i,na.rm=TRUE)/length(na.omit(Hal_filtd_fall$ME_i))) #ME


# Park St (2004)
PS04_filt_int_fall = subset(PS04_filt_int, PS04_filt_int$date >= as.Date("2004-09-22") & 
                              PS04_filt_int$date <= as.Date("2004-12-22"))

PS04_filt_int_fall_mini = as.data.frame(PS04_filt_int_fall$datetime)
colnames(PS04_filt_int_fall_mini) = "datetime_round"
PS04_filt_int_fall_mini$datetime_round = floor_date(as.POSIXct(PS04_filt_int_fall_mini$datetime_round),unit ="hour")
PS04_filt_int_fall_mini$filt_log_tempC = PS04_filt_int_fall$filtT

NOAH_Fal_filtd_fall = subset(NOAH_Fal_filtd, NOAH_Fal_filtd$date >= as.Date("2004-09-22")&
                               NOAH_Fal_filtd$date <= as.Date("2004-12-22"))
NOAH_Fal_filtd_fall$datetime_round = floor_date(NOAH_Fal_filtd_fall$datetime, unit ="hour")

PS04_filtd_fall = left_join(NOAH_Fal_filtd_fall, PS04_filt_int_fall_mini, by = "datetime_round")

Falmouth04 <- ggplot() + ylab("Temperature (°C)") + 
  geom_hline(yintercept = 0,col="black",linetype="dotted") +
  scale_x_datetime(limits=c(as.POSIXct("2004-09-22"),
                            as.POSIXct("2004-12-22")),
                   date_breaks = "2 weeks",
                   date_labels = "%b %d",
                   name="Date") + 
  ylim(-17,28) + 
  geom_line(data=PS04_filt_int, aes(x=as.POSIXct(datetime),y=filtT),
            col="cornflowerblue",lwd=0.65) + 
  geom_line(data=NOAH_Fal_filtd_fall, aes(x=as.POSIXct(datetime),y=filtT),
            col="black",lwd=0.8) + 
  theme_classic() + 
  theme(axis.text= element_text(size=14),
        axis.title= element_text(size=18),
        plot.title = element_text(size = 20,hjust = 0.5)) +
  ggtitle(label = "Falmouth (2004)")

PS04_filtd_fall$ME_i = PS04_filtd_fall$filt_log_tempC - PS04_filtd_fall$filtT
PS04_filtd_fall$ME_i_sq = PS04_filtd_fall$ME_i * PS04_filtd_fall$ME_i

sqrt(sum(PS04_filtd_fall$ME_i_sq,na.rm=TRUE)/length(na.omit(PS04_filtd_fall$ME_i_sq))) #RMSE
(sum(PS04_filtd_fall$ME_i,na.rm=TRUE)/length(na.omit(PS04_filtd_fall$ME_i))) #ME


# Park St 2022
PS22_filt_int_fall = subset(PS22_filt_int, PS22_filt_int$date >= as.Date("2022-09-22") & 
                              PS22_filt_int$date <= as.Date("2022-12-22"))

PS22_filt_int_fall_mini = as.data.frame(PS22_filt_int_fall$datetime)
colnames(PS22_filt_int_fall_mini) = "datetime_round"
PS22_filt_int_fall_mini$datetime_round = floor_date(as.POSIXct(PS22_filt_int_fall_mini$datetime_round),unit ="hour")
PS22_filt_int_fall_mini$filt_log_tempC = PS22_filt_int_fall$filtT

NOAH_Fal_filtd_fall22 = subset(NOAH_Fal_filtd, NOAH_Fal_filtd$date >= as.Date("2022-09-22")&
                                 NOAH_Fal_filtd$date <= as.Date("2022-12-22"))
NOAH_Fal_filtd_fall22$datetime_round = floor_date(NOAH_Fal_filtd_fall22$datetime, unit ="hour")

PS22_filtd_fall = left_join(NOAH_Fal_filtd_fall22, PS22_filt_int_fall_mini, by = "datetime_round")

Falmouth22 <- ggplot() + ylab("Temperature (°C)") + 
  geom_hline(yintercept = 0,col="black",linetype="dotted") +
  scale_x_datetime(limits=c(as.POSIXct("2022-09-22"),
                            as.POSIXct("2022-12-22")),
                   date_breaks = "2 weeks",
                   date_labels = "%b %d",
                   name="Date") + 
  ylim(-17,28) + 
  geom_line(data=PS22_filt_int, aes(x=as.POSIXct(datetime),y=filtT),
            col="cornflowerblue",lwd=0.65) + 
  geom_line(data=NOAH_Fal_filtd_fall22, aes(x=as.POSIXct(datetime),y=filtT),
            col="black",lwd=0.8) + 
  theme_classic() + 
  theme(axis.text= element_text(size=14),
        axis.title= element_text(size=18),
        plot.title = element_text(size = 20,hjust = 0.5)) +
  ggtitle(label = "Falmouth (2022)")

PS22_filtd_fall$ME_i = PS22_filtd_fall$filt_log_tempC - PS22_filtd_fall$filtT
PS22_filtd_fall$ME_i_sq = PS22_filtd_fall$ME_i * PS22_filtd_fall$ME_i

sqrt(sum(PS22_filtd_fall$ME_i_sq,na.rm=TRUE)/length(na.omit(PS22_filtd_fall$ME_i_sq))) #RMSE
(sum(PS22_filtd_fall$ME_i,na.rm=TRUE)/length(na.omit(PS22_filtd_fall$ME_i))) #ME



ggpubr::ggarrange(Halifax03,Newagen03,Falmouth04,Falmouth22,
                  ncol=2,nrow=2,
                  align = "hv",
                  labels=c("a","b","c","d"),
                  label.x = 0.15,
                  label.y = 0.9)










