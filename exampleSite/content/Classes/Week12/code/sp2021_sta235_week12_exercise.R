################################################################################
### Title: "Week 12 - Class Exercise"
### Course: STA 235
### Semester: Spring 2021
### Professor: Magdalena Bennett
################################################################################

# Clears memory
rm(list = ls())
# Clears console
cat("\014")

### Load libraries
# If you don't have one of these packages installed already, you will need to 
#run install.packages() line
library(tidyverse)
library(ggplot2)
library(broom)
library(caret)
library(rpart)
#install.packages("rpart.plot") #If you haven't installed it, un-comment this line
library(rpart.plot)

############################################
#### Classification Trees
############################################

# Load the data for this exercise
disney <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week12/1_DecisionTrees/data/disney2.csv")

# For simplicity, we are going to make dummy covariates into factor variables
disney <- disney %>% mutate(mandalorian = factor(ifelse(mandalorian==0,"No","Yes")),
                            city = factor(ifelse(city==0,"No","Yes")))

# I already provide a training dataset (identified by train==1)
disney.train <- disney %>% dplyr::filter(train==1)

set.seed(100) # Set a seed

mex <- rpart(unsubscribe ~., data = disney.train, method = "class", 
             control = rpart.control(cp = 0.01))


rpart.plot(mex)

###### Answer these questions and copy-paste them to: https://forms.gle/h5PkW7aZq2eam8u16

# Question 1: Play around with cp. What happens if you set it to 0? What happens if you set it to 5?

# Answer:

# Question 2: Set cp = 0.01. How many splits does the tree have? Interpret one of the leaves.

# Answer: