######################################################################
### Title: "Week 2 - Multiple Regression: Interactions & Other Issues"
### Course: STA 235H
### Semester: Fall 2023
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

# Cars, cars, cars ----

cars <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week2/1_OLS/data/SoCalCars.csv", stringsAsFactors = FALSE)

## Let's clean some data

## Select only cars from the year 1970 onwards, that are under $100k, and have less than 150k miles (and more than 10k).

## Let's create new variables:

### luxury: dummy variable for luxury brands (in `luxury_brand` vector) (source: https://luxe.digital/business/digital-luxury-ranking/best-luxury-car-brands/)
### Transform price from dollars to thousands of dollars, and miles to thousands of miles.
### Transform year so that it's the number of years since 1970s

luxury_brands <- c("Audi", "BMW", "Cadillac", "Ferrari", "Jaguar", "Lamborghini", "Land Rover", "Lexus",
                   "Maserati", "Mercedes-Benz", "Porsche", "Rolls-Royce", "Tesla", "Volvo")

cars <- cars %>% filter(type != "New" & mileage >= 10000 & mileage <= 150000 & price < 100000 & year >= 1970) %>%
  mutate(luxury = ifelse(make %in% luxury_brands, 1, 0),
         price = price/1000,
         mileage = mileage/1000,
         year = year - 1970)

# Scatter plot price vs mileage, by luxury status

ggplot(data = cars, aes(x = mileage, y = price, color = factor(luxury))) +
  geom_point() + xlab("Mileage (1,000 mi)") + ylab("Price (1,000 $)") +
  theme_minimal() +
  scale_color_manual("Is this car luxury?", values = c("skyblue","purple"),
                     labels = c("No","Yes")) +
  theme(legend.position = c(0.8, 0.9))






