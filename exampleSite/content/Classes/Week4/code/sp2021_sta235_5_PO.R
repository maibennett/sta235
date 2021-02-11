##############################################################
### Title: "Week 3 - Introduction to Causal Inference"
### Course: STA 235
### Semester: Spring 2021
### Professor: Magdalena Bennett
##############################################################

# Clears memory
rm(list = ls())
# Clears console
cat("\014")

### Load libraries
# If you don't have one of these packages installed already, you will need to run install.packages() line
library(tidyverse)
library(ggplot2)
library(generics)
library(estimatr)
library(modelsummary)
library(gridExtra)

################################################################################
### Beauty in the classroom
################################################################################

# Data for student's evaluations (at the professor level) for UT Austin

profs <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week3/1_PotentialOutcomes/data/profs.csv",
                  stringsAsFactors = TRUE)

head(profs)

#Estimate a simple linear model (with robust standard errors)
lm1 <- estimatr::lm_robust(eval ~ beauty, data=profs)

summary(lm1)

# Now, let's look at the residuals
profs.fitted <- augment(lm(eval ~ beauty, data=profs))
resid <- profs.fitted$.std.resid

# We plot it against an omitted variable from the model:
ggplot(data = profs, aes(x = allstudents, y = resid)) + 
  geom_point(pch = 21, size = 3, color = "#F89441", fill=alpha("#F89441",4)) +
  geom_smooth(method = "lm", color = "dark grey", lty = 2, lwd = 1.2, se = FALSE) +
  theme_bw()+
  theme_ipsum_fsc(plot_title_face = "bold",plot_title_size = 24) + #plain 
  xlab("All Students (N)") + ylab("resid(Evaluations | Beauty)")+#ggtitle("How comfortable are you with R?")+
  theme(plot.margin=unit(c(1,1,1.5,1.2),"cm"),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank(),
        axis.line = element_line(colour = "dark grey"))+
  theme(axis.title.x = element_text(size=18),#margin = margin(t = 10, r = 0, b = 0, l = 0)),
        axis.text.x = element_text(size=14),
        axis.title.y = element_text(size=18),#margin = margin(t = 0, r = 10, b = 0, l = 0)),
        axis.text.y = element_text(size=14),legend.position=c(0.9,0.15),
        legend.title = element_blank(),
        legend.text = element_text(size=12),
        legend.background = element_rect(fill="white",colour ="white"),
        title = element_text(size=14))

# We will transform factor variables into binary (numeric) variables. Remember to always check what the base category is!!
profs <- profs %>% mutate(treat = as.numeric(beauty > 0),
                          female = 2 - as.numeric(gender),
                          single_credit = as.numeric(credits)-1,
                          upper_div = as.numeric(division)-1,
                          native = as.numeric(native)-1,
                          tenure = as.numeric(tenure)-1,
                          minority = as.numeric(minority)-1) 

library(designmatch) #<- This package has some great functions to look at data (we will use it a bit more when we look at matching)

covs <- profs %>% dplyr::select(minority, age, female, single_credit, upper_div, 
                                native, tenure, students, allstudents) # Create a new dataframe only with the covariates

# Meantab will give me the difference in means (in standard deviations, so they are comparable)
# The arguments for this are: 
# - A matrix or dataframe with the covariates,
# - A dummy variable for the treatment
# - Index (row number) for the treated units,
# - Index for the control units.
meantab(covs, profs$treat, which(profs$treat==1), which(profs$treat==0))

# Let's look at the same data, but now graphically

# This loads a user-written function (I adapted it from the loveplot function from designmatch()). You can go to that URL and play with
# it too, if you want to customize it.
source("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week3/1_PotentialOutcomes/code/loveplot_balance.R")

# For loveplot_balance(), the arguments you will need are:
# - Matrix or dataframe with the covariates (they must be numeric)
# - Index (row number) of the variables that are in the treatment group
# - Index (row number) of the variables that are in the control group
# - v-line is a vertical line that we usually use as reference (default is 0.05 SD)
# - format takes values TRUE or FALSE. If you want to copy the format I use in class (format=TRUE), you
# will need to install additional packages(library(hrbrthemes) and library(firasans))
# or you can also add additional formatting to the output `gg`.
gg <- loveplot_balance(covs, which(profs$treat==1), which(profs$treat==0), v_line = 0.05, format = FALSE)

gg

# Let's compare now two models! A simple linear model and a model with all the other covariates:
lm1 <- estimatr::lm_robust(eval ~ beauty, data = profs)
lm2 <- estimatr::lm_robust(eval ~ beauty + minority + age + gender + division + native + tenure + students + allstudents, data = profs)

# You can use modelsummary() to get a prettier table in your Viewer pane. If not, you can just
# run summary(lm1) and summary(lm2)
modelsummary(list(lm1, lm2), stars = TRUE, gof_omit = 'DF|Deviance|AIC|BIC|Log.Lik.') 

# The problem with self-esteem

# We don't have self-esteem data, so I'm just simulating it for this purpose
set.seed(100) # I set a seed, so the random draws of rnorm() can be replicated later

# I create a variable self_esteem which is only correlated with beauty and beauty^2 (+ random noise)
profs <- profs %>% mutate(self_esteem = beauty + beauty^2 + rnorm(nrow(profs)))

cols = c("#FCCE25","#E16462") # These are the colors I want to use.

# This will plot beauty vs self-esteem (remember that there's a quadratic relationship!)
g1 <- ggplot(data = profs, aes(x = beauty, y = self_esteem, color = factor(treat), fill = factor(treat))) + 
  geom_point(pch = 21, size = 3) +
  scale_fill_manual(values=c(alpha(cols[1],0.4),alpha(cols[2],0.4)),labels = c("0"="Below avg","1"="Above avg")) + # These couple of lines are useful to get a nice legend
  scale_color_manual(values=cols, labels = c("0"="Below avg","1"="Above avg")) + 
  theme_bw()+
  xlab("Beauty") + ylab("Self-Esteem")+
  theme(plot.margin=unit(c(0.5,0.5,1,1),"cm"),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank(),
        axis.line = element_line(colour = "dark grey"))+
  theme(axis.title.x = element_text(size=18),
        axis.text.x = element_text(size=14),
        axis.title.y = element_text(size=18),
        axis.text.y = element_text(size=14),legend.position=c(0.9,0.15),
        legend.title = element_blank(),
        legend.text = element_text(size=12),
        legend.background = element_rect(fill="white",colour ="white"),
        title = element_text(size=14))

g1

# Now we plot the residuals of the simple model vs the new variable self-esteem
resid <- profs.fitted$.std.resid

g2 <- ggplot(data = profs, aes(x = self_esteem, y = resid, color = factor(treat), fill = factor(treat))) + 
  geom_point(pch = 21, size = 3) +
  scale_fill_manual(values=c(alpha(cols[1],0.4),alpha(cols[2],0.4)),labels = c("0"="Below avg","1"="Above avg")) +
  scale_color_manual(values=cols, labels = c("0"="Below avg","1"="Above avg")) + 
  theme_bw()+
  xlab("Self-Esteem") + ylab("resid(Evaluations | Beauty)")+
  theme(plot.margin=unit(c(0.5,0.5,1,1),"cm"),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank(),
        axis.line = element_line(colour = "dark grey"))+
  theme(axis.title.x = element_text(size=18),
        axis.text.x = element_text(size=14),
        axis.title.y = element_text(size=18),
        axis.text.y = element_text(size=14),legend.position=c(0.9,0.15),
        legend.title = element_blank(),
        legend.text = element_text(size=12),
        legend.background = element_rect(fill="white",colour ="white"),
        title = element_text(size=14))

g2

grid.arrange(g1,g2, ncol = 2) # This is not necessary, but if you want to see them side by side!

# Now let's look at some plots