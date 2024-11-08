## NE Atlantic Semibalanus balanoides figures 2 & S2.1
## Date created: 10.01.24
## Date updated: 11.07.24


library(reshape2)
source("scripts/temp_vs_repr.R")


## FIGURE 2
# FALMOUTH
Falm_2021_long <- melt(reprod_list_34col[[8]], 
                       id.vars = subset(colnames(reprod_list_34col[[8]]), 
                                        colnames(reprod_list_34col[[8]]) != "nonrep_scaled" & 
                                          colnames(reprod_list_34col[[8]]) != "early_scaled" & 
                                          colnames(reprod_list_34col[[8]]) != "late_scaled"), 
                       variable.name = "embr_stage")
Falm_2021_long$embr_stage = factor(Falm_2021_long$embr_stage,
                                   levels = c("nonrep_scaled","early_scaled","late_scaled"))

PS_plotr <- ggplot() + 
  scale_x_date(limits=c(as.Date("2021-10-15"),as.Date("2022-05-01")),
               date_breaks = "1 month",
               date_labels = "%b",
               name="") + 
  geom_bar(data = subset(Falm_2021_long, Falm_2021_long$embr_stage != "nonrep_scaled"),
           aes(x = date, y=value,fill=embr_stage),
           stat = "identity",col="black",size=0.7) +
  scale_fill_grey(start=0.9,end=0.4,
                  labels=c("Early-stage","Late-stage")) +
  theme_classic(base_size = 14) + 
  geom_smooth(data = subset(reprod_list_34col[[8]], 
                            reprod_list_34col[[8]]$date <= reprod_list_34col[[8]]$date[round(mean(which(reprod_list_34col[[8]]$fertilized > 0.96)))]),
              col = "blue",size=1.7,
              aes(x = date, y=fertilized),
              method = "glm", se = FALSE,
              method.args = list(family = "binomial")) + 
  geom_smooth(data = subset(reprod_list_34col[[8]], 
                            reprod_list_34col[[8]]$date >= reprod_list_34col[[8]]$date[round(mean(which(reprod_list_34col[[8]]$fertilized > 0.96)))]),
              col = "green",size=1.7,
              aes(x = date, y=fertilized),
              method = "glm", se = FALSE,
              method.args = list(family = "binomial")) + 
  geom_point(data = reprod_list_34col[[8]],
             aes(x = date, y=fertilized),
             size=2) + 
  ggtitle(label = "Falmouth 2021-22") + 
  geom_vline(xintercept = (subset(release_est, release_est$site == "Falmouth" & release_est$survey_year=="2021-22")$egg50date),
             linetype="dashed",size=1) + 
  geom_vline(xintercept = (subset(release_est, release_est$site == "Falmouth" & release_est$survey_year=="2021-22")$rel50date),
             linetype="dashed",size=1) +
  theme(axis.text=element_text(size=14),
        axis.title=element_text(size=18),
        plot.title = element_text(size = 20)) + 
  labs(fill = "Embryonic development")


## HALIFAX
Hal_2021_long <- melt(reprod_list_34col[[5]], 
                      id.vars = subset(colnames(reprod_list_34col[[5]]), 
                                       colnames(reprod_list_34col[[5]]) != "nonrep_scaled" & 
                                         colnames(reprod_list_34col[[5]]) != "early_scaled" & 
                                         colnames(reprod_list_34col[[5]]) != "late_scaled"), 
                      variable.name = "embr_stage")
Hal_2021_long$embr_stage = factor(Hal_2021_long$embr_stage,
                                  levels = c("nonrep_scaled","early_scaled","late_scaled"))

Hal_plotr <- ggplot() + 
  scale_x_date(limits=c(as.Date("2021-10-15"),as.Date("2022-05-01")),
               date_breaks = "1 month",
               date_labels = "%b",
               name="") + 
  geom_bar(data = subset(Hal_2021_long, Hal_2021_long$embr_stage != "nonrep_scaled"),
           aes(x = date, 
               y=value,fill=embr_stage),
           stat = "identity",col="black",size=0.7) +
  scale_fill_grey(start=0.9,end=0.4,
                  labels = c("Early-stage","Late-stage")) +
  theme_classic(base_size = 14) + 
  geom_smooth(data = subset(reprod_list_34col[[5]], 
                            reprod_list_34col[[5]]$date <= reprod_list_34col[[5]]$date[round(mean(which(reprod_list_34col[[5]]$fertilized > 0.96)))]),
              col = "blue",size=1.7,
              aes(x = date, y=fertilized),
              method = "glm", se = FALSE,
              method.args = list(family = "binomial")) + 
  geom_smooth(data = subset(reprod_list_34col[[5]], 
                            reprod_list_34col[[5]]$date >= reprod_list_34col[[5]]$date[round(mean(which(reprod_list_34col[[5]]$fertilized > 0.96)))]),
              col = "green",size=1.7,
              aes(x = date, y=fertilized),
              method = "glm", se = FALSE,
              method.args = list(family = "binomial")) + 
  geom_point(data = reprod_list_34col[[5]],
             aes(x = date, y=fertilized),
             size=2) + 
  ggtitle(label = "Halifax 2021-22") + 
  geom_vline(xintercept = (subset(release_est, 
                                  release_est$site == "Halifax" & release_est$survey_year=="2021-22")$egg50date),
             linetype="dashed",size=1) + 
  geom_vline(xintercept = (subset(release_est, release_est$site == "Halifax" & release_est$survey_year=="2021-22")$rel50date),
             linetype="dashed",size=1) +
  theme(axis.text=element_text(size=14),
        axis.title=element_text(size=18),
        plot.title = element_text(size = 20)) + 
  labs(fill = "Embryonic development")


ggarrange(Hal_plotr,PS_plotr,Hal_temps_plot,PS_temps_plot,
          ncol=2,nrow=2,
          heights = c(0.8,1),
          align="hv")


## FIGURE S2.1
# NAHANT
Nh_2021_long2 <- melt(reprod_list_34col[[1]], 
                      id.vars = subset(colnames(reprod_list_34col[[1]]), colnames(reprod_list_34col[[1]]) != "nonrep_scaled" & 
                                         colnames(reprod_list_34col[[1]]) != "early_scaled" & 
                                         colnames(reprod_list_34col[[1]]) != "late_scaled"), 
                      variable.name = "embr_stage")
Nh_2021_long2$embr_stage = factor(Nh_2021_long2$embr_stage,
                                  levels = c("nonrep_scaled","early_scaled","late_scaled"))

Nah_plotr <- ggplot() + 
  scale_x_date(limits=c(as.Date("2020-10-15"),as.Date("2021-05-01")),
               date_breaks = "1 month",
               date_labels = "%b",
               name="") + 
  geom_bar(data = subset(Nh_2021_long2, Nh_2021_long2$embr_stage != "nonrep_scaled"),
           aes(x = date, y=value,fill=embr_stage),
           stat = "identity",col="black",size=0.7) +
  scale_fill_grey(start=0.9,end=0.4,
                  labels=c("early","late")) +
  theme_classic() + 
  geom_smooth(data = subset(reprod_list_34col[[1]], 
                            reprod_list_34col[[1]]$date <= reprod_list_34col[[1]]$date[round(mean(which(reprod_list_34col[[1]]$fertilized > 0.96)))]),
              col = "blue",size=1.7,linetype="dotted",
              aes(x = date, y=fertilized),
              method = "glm", se = FALSE,
              method.args = list(family = "binomial")) + 
  geom_smooth(data = subset(reprod_list_34col[[1]], 
                            reprod_list_34col[[1]]$v < as.Date("2020-12-05")),
              col = "blue",size=1.7,
              aes(x = date, y=fertilized),
              method = "glm", se = FALSE,
              method.args = list(family = "binomial")) + 
  geom_smooth(data = subset(reprod_list_34col[[1]], 
                            reprod_list_34col[[1]]$date >= reprod_list_34col[[1]]$date[round(mean(which(reprod_list_34col[[1]]$fertilized > 0.96)))]),
              col = "green",size=1.7,linetype="dotted",
              aes(x = date, y=fertilized),
              method = "glm", se = FALSE,
              method.args = list(family = "binomial")) + 
  geom_smooth(data = subset(reprod_list_34col[[1]], 
                            reprod_list_34col[[1]]$date > as.Date("2021-01-26")),
              col = "green",size=1.7,
              aes(x = date, y=fertilized),
              method = "glm", se = FALSE,
              method.args = list(family = "binomial")) + 
  geom_point(data = reprod_list_34col[[1]],
             aes(x = date, y=fertilized),
             size=2) + 
  scale_y_continuous(name="",limits = c(0,1),expand = c(0,0)) +
  coord_cartesian(clip="off") +
  ggtitle(label = "Nahant MA 2020-21") + 
  geom_vline(xintercept = (subset(release_est, release_est$site == "Nahant" & release_est$era=="2020-21")$egg50date),
             linetype="dashed",size=1) + 
  geom_vline(xintercept = (subset(release_est, release_est$site == "Nahant" & release_est$era=="2020-21")$rel50date),
             linetype="dashed",size=1) +
  theme(axis.text=element_text(size=14),
        axis.title=element_text(size=18),
        plot.title = element_text(size = 20)) + 
  labs(fill = "Embryonic development")


## HALIFAX 2003
Hal_2003_long2 <- melt(reprod_list_23col[[17]], 
                       id.vars = subset(colnames(reprod_list_23col[[17]]), 
                                        colnames(reprod_list_23col[[17]]) != "nonrep_scaled" & 
                                          colnames(reprod_list_23col[[17]]) != "early_scaled" & 
                                          colnames(reprod_list_23col[[17]]) != "late_scaled"), 
                       variable.name = "embr_stage")
Hal_2003_long2$embr_stage = factor(Hal_2003_long2$embr_stage,
                                   levels = c("nonrep_scaled","early_scaled","late_scaled"))

ggplot(data = Hal_2003_long2, aes(x=date,y=value,fill=embr_stage)) + 
  geom_bar(stat="identity") + 
  scale_fill_viridis_d() + 
  theme_bw()

# these data got a smidge wonky from rounding; changed the fertilization cut-off so as
#  to re-include the second fert peak (=0.959 here, instead of 0.965 in OG data)
Hal_2003_plotr <- ggplot() + 
  scale_x_date(limits=c(as.Date("2003-10-01"),as.Date("2004-05-01")),
               date_breaks = "1 month",
               date_labels = "%b",
               name="") + 
  geom_bar(data = subset(Hal_2003_long2, Hal_2003_long2$embr_stage != "nonrep_scaled"),
           aes(x = date, y=value,fill=embr_stage),
           stat = "identity",col="black",size=0.7) +
  scale_fill_grey(start=0.9,end=0.4,
                  labels=c("early","late")) +
  theme_classic() + 
  geom_smooth(data = subset(reprod_list_23col[[17]], 
                            reprod_list_23col[[17]]$date <= reprod_list_23col[[17]]$date[round(mean(which(reprod_list_23col[[17]]$fertilized > 0.95)))]),
              col = "blue",size=1.7,
              aes(x = date, y=fertilized),
              method = "glm", se = FALSE,
              method.args = list(family = "binomial")) + 
  geom_smooth(data = subset(reprod_list_23col[[17]], 
                            reprod_list_23col[[17]]$date >= reprod_list_23col[[17]]$date[round(mean(which(reprod_list_23col[[17]]$fertilized > 0.95)))]),
              col = "green",size=1.7,linetype="dotted",
              aes(x = date, y=fertilized),
              method = "glm", se = FALSE,
              method.args = list(family = "binomial")) + 
  geom_smooth(data = subset(reprod_list_23col[[17]], 
                            reprod_list_23col[[17]]$date  > as.Date("2004-01-20")),
              col = "green",size=1.7,
              aes(x = date, y=fertilized),
              method = "glm", se = FALSE,
              method.args = list(family = "binomial")) + 
  geom_point(data = reprod_list_23col[[17]],
             aes(x = date, y=fertilized),
             size=2) + 
  scale_y_continuous(name="",limits = c(0,1),expand = c(0,0)) +
  coord_cartesian(clip="off") +
  ggtitle(label = "Halifax, NS 2003-04") + 
  geom_vline(xintercept = (subset(release_est, release_est$site == "Halifax" & release_est$survey_year=="2003-04")$egg50date),
             linetype="dashed",size=1) + 
  geom_vline(xintercept = (subset(release_est, release_est$site == "Halifax" & release_est$survey_year=="2003-04")$rel50date),
             linetype="dashed",size=1) +
  theme(axis.text=element_text(size=14),
        axis.title=element_text(size=18),
        plot.title = element_text(size = 20)) + 
  labs(fill = "Embryonic development")


## DMC
DMC_2003_long2 <- melt(reprod_list_23col[[13]], 
                       id.vars = subset(colnames(reprod_list_23col[[13]]), 
                                        colnames(reprod_list_23col[[13]]) != "nonrep_scaled" & 
                                          colnames(reprod_list_23col[[13]]) != "early_scaled" & 
                                          colnames(reprod_list_23col[[13]]) != "late_scaled"), 
                       variable.name = "embr_stage")
DMC_2003_long2$embr_stage = factor(DMC_2003_long2$embr_stage,
                                   levels = c("nonrep_scaled","early_scaled","late_scaled"))

DMC_plotr <- ggplot() + 
  scale_x_date(limits=c(as.Date("2003-10-15"),as.Date("2004-05-01")),
               date_breaks = "1 month",
               date_labels = "%b",
               name="") + 
  geom_bar(data = subset(DMC_2003_long2, DMC_2003_long2$embr_stage != "nonrep_scaled"),
           aes(x = date, y=value,fill=embr_stage),
           stat = "identity",col="black",size=0.7) +
  scale_fill_grey(start=0.9,end=0.4,
                  labels=c("early","late")) +
  theme_classic() + 
  geom_smooth(data = subset(reprod_list_23col[[13]], 
                            reprod_list_23col[[13]]$date <= reprod_list_23col[[13]]$date[round(mean(which(reprod_list_23col[[13]]$fertilized > 0.96)))]),
              col = "blue",size=1.7,linetype="dotted",
              aes(x = date, y=fertilized),
              method = "glm", se = FALSE,
              method.args = list(family = "binomial")) + 
  geom_smooth(data = subset(reprod_list_23col[[13]], 
                            reprod_list_23col[[13]]$date < "2003-12-01"),
              col = "blue",size=1.7,
              aes(x = date, y=fertilized),
              method = "glm", se = FALSE,
              method.args = list(family = "binomial")) + 
  geom_smooth(data = subset(reprod_list_23col[[13]], 
                            reprod_list_23col[[13]]$date >= reprod_list_23col[[13]]$date[round(mean(which(reprod_list_23col[[13]]$fertilized > 0.96)))]),
              col = "green",size=1.7,
              aes(x = date, y=fertilized),
              method = "glm", se = FALSE,
              method.args = list(family = "binomial")) + 
  geom_point(data = reprod_list_23col[[13]],
             aes(x = date, y=fertilized),
             size=2) + 
  ggtitle(label = "DMC, ME 2003-04") + 
  geom_vline(xintercept = (subset(release_est, release_est$site == "DMC" & release_est$survey_year=="2003-04")$egg50date),
             linetype="dashed",size=1) + 
  geom_vline(xintercept = (subset(release_est, release_est$site == "DMC" & release_est$survey_year=="2003-04")$rel50date),
             linetype="dashed",size=1) +
  theme(axis.text=element_text(size=14),
        axis.title=element_text(size=18),
        plot.title = element_text(size = 20)) + 
  labs(fill = "Embryonic development")


