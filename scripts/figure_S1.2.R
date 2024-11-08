## NE Atlantic Semibalanus balanoides Supp. figure S1.2
## Date created: 10.01.24
## Date updated: 11.07.24


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



