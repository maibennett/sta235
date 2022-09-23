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

dating <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Assignments/Homework/HW3/data/SpeedDatingData.csv")

# Let's do a little bit of data-wrangling:

dating <- dating %>% mutate(income = as.numeric(gsub(",","",income)),
                            race = factor(race, 
                                          labels = c("Black/AA", "White", "Latino", 
                                                     "AAPI","Other")),
                            race_o = factor(race_o, labels = c("Black/AA", "White", 
                                                               "Latino", "AAPI","Other"))) %>%
  rename(female = gender)

