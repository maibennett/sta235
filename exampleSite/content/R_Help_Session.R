######################################################################
### Title: "R Help Session"
### Course: STA 235H
### Semester: Fall 2022
### Professor: Magdalena Bennett
#######################################################################

# Clears memory
rm(list = ls())
# Clears console
cat("\014")
# scipen=999 removes scientific notation; scipen=0 turns it on.
options(scipen = 0)

### Load libraries
# If you don't have one of these packages installed already, you will need to run install.packages() line
library(tidyverse)
library(vtable)
library(AER)

# Data we will use
data("CPS1985")
cars <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week2/1_OLS/data/SoCalCars.csv", stringsAsFactors = FALSE)

x <- c(1,3,4)

ggplot(data = cars, aes(x = year, y = price)) +
  geom_point()

#select()
#filter()
#mutate()
#group_by()

# How to drop variables
cars <- cars %>% select(-certified)

cars <- cars %>% select(-c(make,model))

# How to keep specific variables
cars <- cars %>% select(year, price, mileage)

# How to identify missing values
x <- c(1,2,3,NA)

x == "NA"

is.na(x)

sports <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Assignments/Homework/HW1/data/sports.csv")

sports <- sports %>% filter(!is.na(rev_women))
  
# What does group_by() do?

cars_mean <- cars %>% group_by(make, year) %>% summarize(mean_price = mean(price))

