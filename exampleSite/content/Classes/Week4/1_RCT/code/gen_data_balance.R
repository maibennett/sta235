

N = 1000 #Sample size
p = 0.5 #proportion assigned to treatment

#Assign treatment:

id <- seq(1,N)

set.seed(100)

treat_id <- sample(id, N*p)
control_id <- id[!(id %in% treat_id)]

z <- rep(0, length(id)) #<<
z[treat_id] <- 1 #<<

d <- data.frame("id" = id,"z" = z)

# Generate covariates:
n_covs = 20

X = matrix(NA, ncol = n_covs, nrow = N)

for(j in 1:n_covs){
  
  set.seed(j)
  
  X[,j] = rnorm(N)

}

d <- as.data.frame(cbind(d,X))

names(d) <- c("id","z",paste0("x",seq(1,20)))

write.csv(d, file="covariates_example.csv")

# Check balance:

library(designmatch)

meantab(X, d$z, which(d$z==1), which(d$z==0))


#### Balance in expectation

library(ggplot2)
library(tidyverse)

sim = 100

# Diff for x1:

diff = rep(0,sim)

for (s in 1:sim){
  
  set.seed(s)
  
  treat_id <- sample(id, N*p)
  control_id <- id[!(id %in% treat_id)]
  
  z <- rep(0, length(id))
  z[treat_id] <- 1
  
  diff[s] = mean(X[z==1,1]) - mean(X[z==0,1])
  
}

data.frame("diff" = diff) %>% ggplot(aes(x = diff)) +
  geom_density(color = "darkorange", lwd=2) +
  theme_bw() + xlab("Diff T-C by simulation") + ylab("Density") +
  geom_vline(aes(xintercept = 0), lty = 2, color = "dark grey", lwd = 1.5)



library(hrbrthemes)
library(firasans)

data.frame("diff" = diff) %>% ggplot(aes(x = diff)) +
  geom_density(color = "darkorange", lwd=2) +
  theme_bw() + xlab("Diff T-C by simulation") + ylab("Density") +
  geom_vline(aes(xintercept = 0), lty = 2, color = "dark grey", lwd = 1.5) +

theme_ipsum_fsc(plot_title_face = "bold",plot_title_size = 24) + #plain 
  
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


## Get out the vote example

d <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week4/1_RCT/data/voters_covariates.csv")

# Drop variables with unlisted phone numbers
d_s1 <- d[!is.na(d$treat_real),]

# View balance
d_s1 %>% 
  group_by(state, competiv, treat_real) %>% 
  summarize_all(mean)

library(reactable)
library(estimatr)

summary(estimatr::lm_robust(vote02 ~ treat_real + factor(state)*factor(competiv), dat = d_s1))
