##############################################################
### Title: "Week 3 - Introduction to Causal Inference"
### Course: STA 235H
### Semester: Fall 2021
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
#install.packages("modelsummary")
library(modelsummary)

################################################################################
### Beauty in the classroom
################################################################################

# Data for student's evaluations (at the professor level) for UT Austin

profs <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week3/2_PotentialOutcomes/data/profs.csv",
                  stringsAsFactors = TRUE)

head(profs)

#Estimate a simple linear model (with robust standard errors)
lm1 <- lm(eval ~ beauty, data=profs)

summary(lm1)

# We will transform factor variables into binary (numeric) variables. Remember to always check what the base category is!!
profs <- profs %>% mutate(treat = as.numeric(beauty > 0),
                          female = 2 - as.numeric(gender), # Notice that gender has two levels: (1) female and (2) male. First, we transform it to numeric, and then substract it from 2 (notice that now we will get a binary variable with 1 for female and 0 for male)
                          single_credit = as.numeric(credits)-1,
                          upper_div = as.numeric(division)-1,
                          native = as.numeric(native)-1,
                          tenure = as.numeric(tenure)-1,
                          minority = as.numeric(minority)-1) 


covs <- profs %>% #Task: Create a new dataframe only with the previous covariates and the treatment

# datasummary_balance() is a function from the `modelsummary` package, which creates a balance table between the treatment and control group for the selected covariates
# fmt: if integer, gives you the number of decimal points.
# dinm_statistic: If not included, it returns the SE. If we use "p.value", we get the p-value for the table
datasummary_balance(~ treat, data = covs, title = "Balance table", fmt=2, dinm_statistic = "p.value")

# Let's look at the same data, but now graphically

# This loads a user-written function (I adapted it from the loveplot function from designmatch()). You can go to that URL and play with
# it too, if you want to customize it.
source("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week3/2_PotentialOutcomes/code/loveplot_balance.R")

# For loveplot_balance(), the arguments you will need are:
# - Dataframe with the covariates (they must be numeric! It will not accept factor variables)
# - Index (row number) of the variables that are in the treatment group
# - Index (row number) of the variables that are in the control group
# - v-line is a vertical line that we usually use as reference (default is 0.05 SD)
# - format takes values TRUE or FALSE. If you want to copy the format I use in class (format=TRUE), you
# will need to install additional packages(library(hrbrthemes) and library(firasans))
# or you can also add additional formatting to the output `gg`.

treat_id <- profs %>% mutate(id = seq(1, nrow(profs))) %>% filter(treat==1) %>% pull(-1)
control_id <- profs %>% mutate(id = seq(1, nrow(profs))) %>% filter(treat==0) %>% pull(-1)

gg <- loveplot_balance(covs, treat_id, control_id, v_line = 0.05, format = FALSE)

gg

# Question: The previous love plot also shows the treatment in the y-axis. How would you remove that variable?

# Let's compare now two models! A simple linear model and a model with all the other covariates:
lm1 <- lm(eval ~ beauty, data = profs)
lm2 <- lm(eval ~ beauty + minority + age + gender + division + native + tenure + allstudents, data = profs)

# You can use modelsummary() to get a prettier table in your Viewer pane. If not, you can just
# run summary(lm1) and summary(lm2)
modelsummary(list(lm1, lm2), stars = TRUE, gof_omit = 'DF|Deviance|AIC|BIC|Log.Lik.')  #stars=TRUE include stars for p-values, and gof_omit is just to omit some of the overall regression statistics (which we won't be using)

# Question: How would you say these two models compare?

# The problem with self-esteem

# We don't have self-esteem data, so I'm just simulating it for this purpose
set.seed(100) # I set a seed, so the random draws of rnorm() can be replicated later (rnorm() simulates a vector that distributes normal with mean = 0 and sd = 1, by default)

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

# Question: Describes the relationship between self-esteem and beauty? Include now self-esteem in your regression. Do your results qualitatively change?
