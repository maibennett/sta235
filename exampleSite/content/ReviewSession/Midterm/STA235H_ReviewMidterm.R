################################################################################
### Title: "Midterm Review"
### Course: STA 235H
### Semester: Fall 2023
### Professor: Magdalena Bennett
################################################################################

# Clears memory
rm(list = ls())
# Clears console
cat("\014")

### Load libraries
library(tidyverse)
library(modelsummary)
library(MatchIt)

# RCT

barrels_rct = read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/ReviewSession/Midterm/data/barrels_rct.csv")

# We transform this to binary so we are sure which one is the treatment and which one the control.
barrels_rct = barrels_rct %>% mutate(barrel = ifelse(barrel == "Barrel", 1, 0))

summary(lm(water_bill ~ barrel, data = barrels_rct))


# Selection on Observables

barrels_obs = read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/ReviewSession/Midterm/data/barrels_observational.csv")

barrels_obs = barrels_obs %>% mutate(barrel = ifelse(barrel == "Barrel", 1, 0))

# We match on all potential confounders
matched = matchit(barrel ~ yard_size + home_garden + attitude_env + temperature, data = barrels_obs)

barrels_matched = match.data(matched)

summary(lm(water_bill ~ barrel, data = barrels_matched))


# Diff-in-Diff

barrels_dd = read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/ReviewSession/Midterm/data/barrels_dd.csv")

barrels_dd = barrels_dd %>% mutate(post = ifelse(year == 2019, 1, 0),
                                   treat = ifelse(county=="Bexar", 1, 0))

summary(lm(water_bill ~ treat*post, data = barrels_dd))


# RDD

barrels_rd = read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/ReviewSession/Midterm/data/barrels_rd.csv")

# We create the variable dist in such way that the treated individuals have positive values,
# and the control group has a negative value
barrels_rd = barrels_rd %>% mutate(treat = ifelse(income<50000, 1, 0),
                                   dist = 50000 - income)

summary(lm(water_bill ~ treat*dist, data = barrels_rd))


