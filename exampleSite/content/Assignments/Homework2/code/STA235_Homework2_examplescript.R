
##############################################################
### Title: Homework 2
### Course: STA 235
### Semester: Spring 2021
### Name: [YOUR NAME HERE]
##############################################################

# Clears memory
rm(list = ls())
# Clears console
cat("\014")

### Load libraries (load any package you might need)
library(tidyverse)
library(ggplot2)
library(estimatr)

### Task 1:

# Load rewards data
d <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Assignments/Homework2/data/rewards.csv")



### Task 2:

sample_rct <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Assignments/Homework2/data/nsw_dehejia_wahba_ps.csv")

sample_all <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Assignments/Homework2/data/nsw_dehejia_wahba_psid.csv")


### Task 3:

pilot_mc <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Assignments/Homework2/data/user_app_installed_mccombs_small.csv")

full_mc <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Assignments/Homework2/data/user_app_installed_mccombs_large.csv")

data_ut <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Assignments/Homework2/data/user_app_installed_UT_large.csv")