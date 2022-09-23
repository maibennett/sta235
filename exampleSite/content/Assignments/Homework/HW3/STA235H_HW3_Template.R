######################################################################
### Title: "Homework 3"
### Course: STA 235H
### Semester: Fall 2022
### Name: [INSERT YOUR NAME HERE]
#######################################################################

# Clears memory
rm(list = ls())
# Clears console
cat("\014")

### Load libraries
# [LOAD PACKAGES HERE]
library(tidyverse)

dating <- read.csv("C:/Users/mc72574/Dropbox/UT/Teaching/2022Fall_STA235H/homework/2022/homework3/data/SpeedDatingData.csv")

dating <- dating %>% mutate(income = as.numeric(gsub(",","",income)),
                            race = factor(race, 
                                          labels = c("Black/AA", "White", "Latino", 
                                                     "AAPI","Other")),
                            race_o = factor(race_o, labels = c("Black/AA", "White", 
                                                               "Latino", "AAPI","Other"))) %>%
  rename(female = gender)