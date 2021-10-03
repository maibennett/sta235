#Clear memory
rm(list = ls())

#Clear the console
cat("\014")

library(ggplot2)
library(firasans)
library(hrbrthemes)
library(extrafont)
library("RColorBrewer")
library(viridis)

d <- read.csv(file.choose())

ggplot(data = d, aes(How.comfortable.are.you.with.coding.in.R.)) + 
  geom_histogram(color="#900DA4", fill = alpha("#900DA4",0.5), lwd=1.5, stat="count") +
  scale_x_discrete(name="x", breaks=seq(1,10,1), labels = c("1\nVery uncomfortable","2","3","4","5","6","7","8","9","10\nSuper comfortable"), limits = c(1,2,3,4,5,6,7,8,9,10)) +
  theme_bw()+
  theme_ipsum_fsc(plot_title_face = "bold",plot_title_size = 24) + #plain 
  xlab("") + ylab("Count")+ggtitle("How comfortable are you with R?")+
  ylim(0,5)+
  theme(plot.margin=unit(c(1,1,1.5,1.2),"cm"),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank(),
        axis.line = element_line(colour = "dark grey"))+
  theme(axis.title.x = element_text(size=18),#margin = margin(t = 10, r = 0, b = 0, l = 0)),
        axis.text.x = element_text(size=14),
        axis.title.y = element_text(size=18),#margin = margin(t = 0, r = 10, b = 0, l = 0)),
        axis.text.y = element_text(size=14),legend.position="none",
        legend.title = element_blank(),
        legend.text = element_text(size=15),
        legend.background = element_rect(fill="white",colour ="white"),
        title = element_text(size=14))


d$grades = factor(d$Thinking.forward.to.the.end.of.the.semester..what.grade.do.you.think.you.will.get.in.this.course.,
                  levels = c("A","A-","B+","B","B-","C+","C","C-","D","F"))

d2 = as.data.frame(cbind(table(d$grades),rownames(table(d$grades))))
names(d2) = c("value","Grades")

d2$Grades = factor(d2$Grades, levels = c("A","A-","B+","B","B-","C+","C","C-","D","F"))

cols = c("#0D0887","#5601A4","#900DA4","#BF3984","#900DA4","#E16462","#F89441","#f5c542","#FCCE25","#f5dc7f")

ggplot(data = d2, aes(x="",y=as.numeric(value),fill=Grades)) + 
  geom_bar(lwd=1.5, stat="identity", color="white") +
  coord_polar("y",start = 0)+
  scale_fill_manual(values=cols) + 
  #scale_x_discrete(name="x", breaks=seq(1,10,1), labels = c("1\nVery uncomfortable","2","3","4","5","6","7","8","9","10\nSuper comfortable"), limits = c(1,2,3,4,5,6,7,8,9,10)) +
  theme_void()+
  theme_ipsum_fsc(plot_title_face = "bold",plot_title_size = 24) + #plain 
  ggtitle("How comfortable are you with R?")+
  #ylim(0,5)+
  theme(plot.margin=unit(c(1,1,1.5,1.2),"cm"),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank(),
        axis.line = element_blank())+
  theme(axis.title.x = element_blank(),#margin = margin(t = 10, r = 0, b = 0, l = 0)),
        axis.text.x = element_blank(),
        axis.title.y = element_blank(),#margin = margin(t = 0, r = 10, b = 0, l = 0)),
        axis.text.y = element_blank(),legend.position="right",
        legend.title = element_text(size=15),
        legend.text = element_text(size=12),
        legend.background = element_rect(fill="white",colour ="white"),
        title = element_text(size=14))