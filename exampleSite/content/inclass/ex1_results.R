################################################################################
### Title: "Week 11 In-Class Exercise - KNN"
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
#### K-Nearest Neighbor
############################################

d <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week11/1_KNN/data/Placement_Data_Full_Class.csv")

# Task: We want to predict whether a student is placed or not (status) according to their characteristics.
#       Run a KNN using 10-fold CV and whatever tuneLength you see fit. 
#       What is the optimal K and the accuracy of the prediction?

# Notes: `sl_no` is a serial number identifying students and should not be used for prediction. 
#        `salary` is an outcome for those placed, so it should also be left out (not used as a predictor)


