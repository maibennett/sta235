################################################################################
### Title: "Week 12 In-Class Exercise - Decision Trees"
### Course: STA 235H
### Semester: Fall 2021
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
library(caret)
library(modelr)

############################################
#### Decision Trees
############################################

d <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week12/1_DecisionTrees/data/Placement_Data_Full_Class.csv")

# Task: We want to predict whether a student is placed or not (status) according to their characteristics.
#       1) Run a random forest to predict the status. Play with the tuneGrid parameter (specifically, mtry).
#          How many variables should we use?
#       2) Show a plot for the most important variables. Which one has the most predictive power?
#       3) What's the accuracy for your model?

# Notes: `sl_no` is a serial number identifying students and should not be used for prediction. 
#        `salary` is an outcome for those placed, so it should also be left out (not used as a predictor)

d <- d %>% select(-c(sl_no, salary))

### INSERT CODE HERE (be sure to show your answers for optimal K and accuracy)

# When you are done, you can submit it on Canvas.

set.seed(100)

n <- nrow(d)

train.row <- sample(1:n, 0.8*n) # Same thing as before. We need to divide our data

test.data <- d %>% slice(-train.row)
train.data <- d %>% slice(train.row)


tuneGrid <- expand.grid(
  mtry = , # COMPLETE
  splitrule = "gini", # Split rule (for regressions use "variance", for classification use "gini")
  min.node.size = 5
)

rfcv <- train() #COMPLETE
