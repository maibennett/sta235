######################################################################
### Title: "Week 2 - Interactions Models, Colinearity, and Residuals"
### Course: STA 235H
### Semester: Fall 2021
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
library(ggplot2)
library(vtable)

################################################################################
### In-class exercises
################################################################################

cars <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week2/2_OLS_probs/data/SoCalCars.csv", stringsAsFactors = FALSE)

## Let's clean some data

# Select only cars from the year 1970 onwards, that are under $100k, and have less than 150k miles.

# Let's create new variables:

# luxury: dummy variable for luxury brands (in `luxury_brand` vector) (source: https://luxe.digital/business/digital-luxury-ranking/best-luxury-car-brands/)
# Transform price from dollars to thousands of dollars, and miles to thousands of miles.
# Transform year so that it's the number of years since 1970s

luxury_brands <- c("Audi", "BMW", "Cadillac", "Ferrari", "Jaguar", "Lamborghini", "Land Rover", "Lexus",
                   "Maserati", "Mercedes-Benz", "Porsche", "Rolls-Royce", "Tesla", "Volvo")

cars <- cars %>% filter(type != "new" & mileage >= 10000 & mileage <= 150000 & price < 100000 & year >= 1970) %>%
  mutate(luxury = ifelse(make %in% luxury_brands, 1, 0),
         price = price/1000,
         mileage = mileage/1000,
         year = year - 1970)


# Let's run a regression of price on mileage, year, and rating.

lm1 <- lm() #complete this function

summary(lm1) #Interpret the intercept

#How do we recover only coefficients?
coef(lm1) # vector of coefficients

summary(lm1)$coefficients #matrix of coefficients, SE, t-value and p-values

# Question: Are the signs of the coefficients what you expected?


# Let's run a regression of price on mileage, year, rating, and the interaction of mileage and year.
lm2 <- lm(price ~ rating + mileage + year*luxury, data = cars)

summary(lm2)

#Question: What's the change in price for one additional year for luxury-brand cars vs non-luxury-brand cars, holding other variables constant?
