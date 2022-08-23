######################################################################
### Title: "Week 3 - Outliers and Collinearity"
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

################################################################################
### In-class exercises
################################################################################

# This is the data from 2017 HMDA for Bastrop county (https://www.consumerfinance.gov/data-research/hmda/historic-data/?geo=tx&records=first-lien-owner-occupied-1-4-family-records&field_descriptions=labels)
# (you can also find the whole dataset for Austin by changing the name of the file to hmda_2017_austin.csv)

hmda <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week3/1_OLS_Issues/data/hmda_2017_austin_bastrop.csv", stringsAsFactors = FALSE)

# You can find information about the variables here: https://files.consumerfinance.gov/hmda-historic-data-dictionaries/lar_record_codes.pdf

# Let's look at loans that were approved (action taken = 1) for home purchase (loan_purpose = 1)

hmda <- hmda %>% ... #complete this

# Q: How could we see if we have outliers?

ggplot(data = hmda, aes(x = loan_amount_000s)) +
  geom_histogram(color = "skyblue3", fill = "skyblue", lwd = 1.1) +
  xlab("Loan amount (1,000 US$)") +
  theme_minimal()

# Show a scatter plot of loan amount vs applicant's income:

ggplot(data = hmda, aes(x = applicant_income_000s, y = loan_amount_000s)) +
  geom_point(color = "skyblue") +
  theme_minimal() +
  xlab("Applicant's income (1,000 US$)") + ylab("Loan Amount (1,000 US$)")  

# Fit a regression line to the previous plot:

ggplot(data = hmda, aes(x = applicant_income_000s, y = loan_amount_000s)) +
  geom_point(color = "skyblue") +
  theme_minimal() +
  xlab("Applicant's income (1,000 US$)") + ylab("Loan Amount (1,000 US$)") +
  geom_smooth(method = "lm", se = FALSE, color = "blue", lwd = 1.1)

# Fit a regression line but *excluding* the clear outliers

## Exclude both income outliers 
ggplot(data = hmda, aes(x = applicant_income_000s, y = loan_amount_000s)) +
  geom_point(color = "skyblue") +
  theme_minimal() +
  xlab("Applicant's income (1,000 US$)") + ylab("Loan Amount (1,000 US$)") +
  geom_smooth(method = "lm", se = FALSE, color = "blue", lwd = 1.1) +
  geom_smooth(data = hmda %>% filter(applicant_income_000s<700),
              aes(x = applicant_income_000s, y = loan_amount_000s),
              method = "lm",
              se = FALSE,
              color = "purple")

## Exclude only loan outlier
ggplot(data = hmda, aes(x = applicant_income_000s, y = loan_amount_000s)) +
  geom_point(color = "skyblue") +
  theme_minimal() +
  xlab("Applicant's income (1,000 US$)") + ylab("Loan Amount (1,000 US$)") +
  geom_smooth(method = "lm", se = FALSE, color = "blue", lwd = 1.1) +
  geom_smooth(data = hmda %>% filter(loan_amount_000s<750),
              aes(x = applicant_income_000s, y = loan_amount_000s),
              method = "lm",
              se = FALSE,
              color = "purple")


### Tip: If you want to add labels to your smooth lines, you can add "color" as an aes() feature

ggplot(data = hmda, aes(x = applicant_income_000s, y = loan_amount_000s)) +
  geom_point(color = "skyblue") +
  theme_minimal() +
  xlab("Applicant's income (1,000 US$)") + ylab("Loan Amount (1,000 US$)") +
  geom_smooth(aes(color = "linear fit"), method = "lm", se = FALSE, lwd = 1.1) +
  geom_smooth(data = hmda %>% filter(loan_amount_000s<750),
              aes(x = applicant_income_000s, y = loan_amount_000s,
                  color = "linear fit w/o outliers"),
              method = "lm",
              se = FALSE) +
  scale_color_manual(values = c("blue", "purple"), name = "Regression lines")


# Q: Define outliers as you fit

hmda <- hmda %>% mutate(outlier = ifelse(loan_amount_000s>750, 1, 0))

hmda %>% select(outlier) %>% table(.)

# Q: Run a regression with and without outliers. Do your results change qualitatively?


###########################################
## Collinearity
###########################################

cars <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week2/1_OLS/data/SoCalCars.csv", stringsAsFactors = FALSE)

## Let's clean some data

## Select only cars from the year 1970 onwards, that are under $100k, and have less than 150k miles.

## Let's create new variables:

### luxury: dummy variable for luxury brands (in `luxury_brand` vector) (source: https://luxe.digital/business/digital-luxury-ranking/best-luxury-car-brands/)
### Transform price from dollars to thousands of dollars, and miles to thousands of miles.
### Transform year so that it's the number of years since 1970s

luxury_brands <- c("Audi", "BMW", "Cadillac", "Ferrari", "Jaguar", "Lamborghini", "Land Rover", "Lexus",
                   "Maserati", "Mercedes-Benz", "Porsche", "Rolls-Royce", "Tesla", "Volvo")

cars <- cars %>% filter(type != "new" & mileage >= 10000 & mileage <= 150000 & price < 100000 & year >= 1970) %>%
  mutate(luxury = ifelse(make %in% luxury_brands, 1, 0),
         price = price/1000,
         mileage = mileage/1000,
         year = year - 1970)

summary(lm(price ~ year + mileage + rating, data = cars))

cars <- cars %>% mutate(mileage_per_year = mileage/(2021-(1970+year)))

summary(lm(price ~ mileage_per_year + year + rating, data = cars))
