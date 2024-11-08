## NE Atlantic Semibalanus balanoides reproduction phenology figure 3
## Date created: 08.29.23
## Date updated: 11.07.24


library(ggpubr) # for ggarrange
library(ggplot2)
library(ggplotify) #for as.ggplot
library(ggridges) #for that one figure
library(viridis) #for nice color ramps
library(tidyr)

source("scripts/phenology.R")

## FIGURE 3, PANELS a-b
fert <- ggplot(data=release_est) +
  geom_point(aes(x=forcats::fct_rev(site_label),y=eggs_0.5,fill=survey_year),
             size=3,shape=22,alpha=0.8) + 
  theme_bw(base_size = 14) + 
  coord_flip() + 
  scale_y_continuous(limits=c(-80,-30),
                     breaks = c(-76,-60,-45,-29),
                     labels = c("Oct 15","Nov 1","Nov 15","Dec 1")) + 
  scale_x_discrete(limits = rev) + 
  scale_fill_viridis_d() + 
  ylab("Day of 50% fertilization") + 
  xlab("") + 
  guides(fill=guide_legend(title="Sampling year",reverse = TRUE))

release <- ggplot(data=release_est) +
  geom_point(aes(x=forcats::fct_rev(site_label),y=rel_0.5,fill=survey_year),
             size=3,shape=22,alpha=0.8) + 
  theme_bw(base_size = 14) + 
  coord_flip() + 
  scale_y_continuous(limits=c(-20,100),
                     breaks = c(-16,1,15,32,46,60,74,91),
                     labels = c("Dec 15","Jan 1","Jan 15","Feb 1","Feb 15",
                                "Mar 1","Mar 15","Apr 1")) + 
  scale_x_discrete(limits = rev) + 
  scale_fill_viridis_d() + 
  ylab("Day of 50% larval release") + 
  xlab("") + 
  guides(fill=guide_legend(title="Sampling year",reverse = TRUE))


# the code below combines the 2 plots above, so that the x-axis scales would match
# additional beautifying was done outside of R
midpoints <- ggplot(data=release_est) +
  geom_point(aes(x=forcats::fct_rev(site_label),y=eggs_0.5,fill=survey_year),
             size=3.5,shape=23,alpha=0.8,stroke=1.1) + 
  geom_point(aes(x=forcats::fct_rev(site_label),y=rel_0.5,fill=survey_year),
             size=3.5,shape=23,alpha=0.8,stroke=1.1) + 
  theme_bw(base_size = 18) + 
  coord_flip() + 
  scale_y_continuous(limits=c(-80,100),
                     breaks = c(-76,-60,-45,-29,-16,1,15,32,46,60,74,91),
                     labels = c("Oct 15","Nov 1","Nov 15","Dec 1",
                                "Dec 15","Jan 1","Jan 15","Feb 1",
                                "Feb 15","Mar 1","Mar 15","Apr 1")) + 
  scale_x_discrete(limits = rev) + 
  scale_fill_viridis_d() + 
  ylab("") + 
  xlab("") +
  theme(legend.position = "none")


## REARRANGE DATA FOR PANELS c-d
reprod_list_34col2 <- lapply(reprod_list_34col, function(x){
  x["date_collected"] <- NULL;
  x})
reprod_list_23col2 <- lapply(reprod_list_23col, function(x){
  x["notes"] <- NULL;
  x["month"] <- NULL;
  x})

modmerge = dplyr::bind_rows(reprod_list_34col2, .id = "column_label")
histmerge = dplyr::bind_rows(reprod_list_23col2, .id = "column_label")
rm(reprod_list_34col2); rm(reprod_list_23col2)

histmerge_clean = as.data.frame(histmerge[,2])
colnames(histmerge_clean) = c("date")
histmerge_clean$DOY_shifted = histmerge$DOY_shifted
histmerge_clean$fertilized = histmerge$fertilized
histmerge_clean$site = histmerge$site
histmerge_clean$survey_year = histmerge$survey_year

modmerge_clean = as.data.frame(modmerge[,7])
colnames(modmerge_clean) = c("date")
modmerge_clean$DOY_shifted = modmerge$DOY_shifted
modmerge_clean$fertilized = modmerge$fertilized
modmerge_clean$site = modmerge$site
modmerge_clean$survey_year = modmerge$survey_year

all_merge = rbind(histmerge_clean,modmerge_clean)
all_merge$site = factor(all_merge$site,
                        levels = rev(c("Halifax",
                                       "DMC","Newagen",
                                       "Nahant",
                                       "Falmouth","Oak Bluffs",
                                       "Mt Hope","Noyes Neck")))

all_merge$site_label = ifelse(all_merge$site == "Halifax",
                              yes = "Halifax (44.6°N)",
                              no = ifelse(all_merge$site == "DMC",
                                          yes = "DMC (43.9°N)",
                                          no = ifelse(all_merge$site == "Newagen",
                                                      yes = "Newagen (43.8°N)",
                                                      no = ifelse(all_merge$site == "Nahant",
                                                                  yes = "Nahant (42.4°N)",
                                                                  no = ifelse(all_merge$site == "Falmouth",
                                                                              yes = "Falmouth (41.6°N)",
                                                                              no = ifelse(all_merge$site == "Mt Hope",
                                                                                          yes = "Mt Hope (41.6°N)",
                                                                                          no = ifelse(all_merge$site == "Oak Bluffs",
                                                                                                      yes = "Oak Bluffs (41.5°N)",
                                                                                                      no = "Noyes Neck (41.3°N)")))))))
all_merge$site_label = factor(all_merge$site_label,
                              levels = rev(c("Halifax (44.6°N)",
                                             "DMC (43.9°N)",
                                             "Newagen (43.8°N)",
                                             "Nahant (42.4°N)",
                                             "Falmouth (41.6°N)",
                                             "Oak Bluffs (41.5°N)",
                                             "Mt Hope (41.6°N)",
                                             "Noyes Neck (41.3°N)")))

all_merge$survey_year = factor(all_merge$survey_year,
                       levels = c("2002-03","2003-04","2019-20","2020-21",
                                  "2021-22","2022-23","2023-24"))


Falmouth_repr <- ggplot(subset(all_merge, all_merge$site=="Falmouth"), 
                        aes(x = DOY_shifted, height = fertilized,y=survey_year, fill = survey_year)) +
  geom_density_ridges(stat="identity",alpha=0.8) +
  theme_ridges(font_size = 16) + 
  scale_y_discrete(name = "Sampling year",
                   breaks=c("2002-03","2003-04","2019-20","2020-21",
                            "2021-22","2022-23","2023-24"),
                   drop=FALSE,na.translate = TRUE,
                   labels=unique(all_merge$survey_year)) + 
  scale_x_continuous(name = NULL,
                     limits = c(-100,130),
                     breaks=c(-91,-60,-30,1,32,60,91,121),
                     labels = c("Oct","Nov","Dec","Jan","Feb","Mar","Apr","May")) +
  theme(legend.position = "none",
        panel.border = element_rect(colour = "black", fill=NA, linewidth=1),
        axis.line = element_line(colour = "black"),
        axis.title.y = element_text(angle=90, hjust = 0.5,vjust=2)) + 
  scale_fill_manual(labels = unique(all_merge$survey_year),
                    values = c("#440154","#443983","#31688e",
                               "#21918c","#35b779","#90d743","#fde725")) + 
  ggtitle("Falmouth")


latitud_repr <- ggplot(subset(all_merge, all_merge$survey_year=="2003-04"), 
                       aes(x = DOY_shifted, height = fertilized,y=site_label, fill = site_label)) +
  geom_density_ridges(stat="identity",alpha=0.8) +
  theme_ridges(font_size = 16) + 
  scale_y_discrete(drop=FALSE,na.translate = TRUE) + 
  scale_x_continuous(name = NULL,
                     limits = c(-110,130),
                     breaks=c(-91,-60,-30,1,32,60,91,121),
                     labels = c("Oct","Nov","Dec","Jan","Feb","Mar","Apr","May")) +
  theme(legend.position = "none",
        panel.border = element_rect(colour = "black", fill=NA, linewidth=1),
        axis.line = element_line(colour = "black"),
        axis.title.y = element_text(angle=90, hjust = 0.5,vjust=2)) + 
  scale_fill_manual(labels = unique(all_merge$site_label),
                    values = rev(c("#000004","#221150","#5f187f","#982d80",
                                   "#d3436e","#f8765c","#febb81","#fcfdbf"))) + 
  ggtitle("Sampling year: 2003-04") + 
  ylab("")


ggarrange(midpoints,
          ggarrange(latitud_repr,Falmouth_repr,
                    ncol=2,
                    widths=c(1.2,1),
                    legend = NULL),
          nrow = 2,ncol=1,
          heights = c(1.5,2),
          align = "h")
