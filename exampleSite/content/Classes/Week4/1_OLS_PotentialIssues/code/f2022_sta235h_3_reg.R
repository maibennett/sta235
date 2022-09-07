######################################################################
### Title: "Week 3 - Outliers and Mulyicollinearity"
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
library(estimatr)

################################################################################
### In-class exercises
################################################################################

###################### OUTLIERS ################################################

### HMDA Example

# This is the data from 2017 HMDA for Bastrop county (https://www.consumerfinance.gov/data-research/hmda/historic-data/?geo=tx&records=first-lien-owner-occupied-1-4-family-records&field_descriptions=labels)
# (you can also find the whole dataset for Austin by changing the name of the file to hmda_2017_austin.csv)

hmda <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week3/2_OLS_Issues/data/hmda_2017_austin_bastrop.csv", stringsAsFactors = FALSE)

# You can find information about the variables here: https://files.consumerfinance.gov/hmda-historic-data-dictionaries/lar_record_codes.pdf

# Let's look at loans that were approved (action taken = 1) for home purchase (loan_purpose = 1) (hint: you will need to subset your data)

hmda <- hmda %>% ... #complete this

# Q: How could we see if we have outliers?

ggplot(data = hmda, aes(x = loan_amount_000s)) +
  geom_histogram(color = "skyblue3", fill = "skyblue", lwd = 1.1) +
  xlab("Loan amount (1,000 US$)") +
  theme_minimal()

# Show a scatter plot of loan amount vs applicant's income:

ggplot(data = hmda, aes(x = applicant_income_000s, y = loan_amount_000s)) +
  geom_point(color = "skyblue3") +
  theme_minimal() +
  xlab("Applicant's income (M US$)") + ylab("Loan Amount (M US$)")  

# Fit a regression line to the previous plot:

ggplot(data = hmda, aes(x = applicant_income_000s, y = loan_amount_000s)) +
  geom_point(color = "skyblue3") +
  theme_minimal() +
  xlab("Applicant's income (M US$)") + ylab("Loan Amount (M US$)") +
  geom_smooth(method = "lm", se = FALSE, color = "blue", lwd = 1.1)

# Fit a regression line but *excluding* the clear outliers

## Exclude both income outliers 
hmda_without_outliers <- hmda %>% filter(applicant_income_000s<700)

ggplot(data = hmda, aes(x = applicant_income_000s, y = loan_amount_000s)) +
  geom_point(color = "skyblue3") +
  theme_minimal() +
  xlab("Applicant's income (M US$)") + ylab("Loan Amount (M US$)") +
  geom_smooth(method = "lm", se = FALSE, color = "blue", lwd = 1.1) +
  geom_smooth(data = hmda_without_outliers,
              aes(x = applicant_income_000s, y = loan_amount_000s),
              method = "lm",
              se = FALSE,
              color = "purple")

## Exclude only loan outlier
hmda_without_outliers <- hmda %>% filter(loan_amount_000s<750)

ggplot(data = hmda, aes(x = applicant_income_000s, y = loan_amount_000s)) +
  geom_point(color = "skyblue") +
  theme_minimal() +
  xlab("Applicant's income (1,000 US$)") + ylab("Loan Amount (1,000 US$)") +
  geom_smooth(method = "lm", se = FALSE, color = "blue", lwd = 1.1) +
  geom_smooth(data = hmda_without_outliers,
              aes(x = applicant_income_000s, y = loan_amount_000s),
              method = "lm",
              se = FALSE,
              color = "purple")


### Tip: If you want to add labels to your smooth lines, you can add "color" as an aes() feature (use whatever names you want!)

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


###################### MULTICOLLINEARTITY ######################################

## Ames Housing dataset: Data for the housing market in Ames, Iowa.
## You can check the codebook here: https://sta235.netlify.app/Classes/Week3/1_OLS_Issues/data/ames_codebook.csv

housing <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week3/1_OLS_Issues/data/AmesHousing.csv")

# Only keep single family housing: (Bldg.Type)

housing <- housing %>% filter(Bldg.Type=="1Fam")

# Run a regression of Sale Price on total number of rooms, living area, garage (cars), fireplace, total area of the basement, and lot area.  

lm_full <- lm(SalePrice ~ TotRms.AbvGrd + Gr.Liv.Area + Garage.Cars + Fireplaces + Total.Bsmt.SF, data = housing)

summary(lm_full)

# Q: Total number of rooms is not statistically significant. 

# Run the same regression as before, but only include total number of rooms and living area as covariates:

lm_size <- lm(SalePrice ~ TotRms.AbvGrd + Gr.Liv.Area , data = housing)

summary(lm_size)


# Plot number of rooms against living area:

ggplot(data = housing, aes(x = TotRms.AbvGrd, y = Gr.Liv.Area)) +
  geom_point(color = "skyblue") +
  geom_smooth(color = "purple", fill = alpha("purple", 0.2), method = "lm") +
  theme_minimal() +
  xlab("Total Number of Rooms") + ylab("Living Area (Sq Ft)")

summary(lm(Gr.Liv.Area ~ TotRms.AbvGrd, data = housing))

# Q: Look at the R^2. Does it look high?

# Get the correlation between number of rooms and living area:

housing %>% select(Gr.Liv.Area, TotRms.AbvGrd) %>% cor(.)


###################### BINARY RESPONSE #########################################

data("HMDA")

# To know what the variables are, you can type ?HMDA on the console
hmda <- data.frame(HMDA)

head(hmda)

#Let's transform the variable deny into a 0-1 variable:
hmda <- hmda %>% mutate(deny = as.numeric(deny) - 1)

## Linear Probability Model

# Let's run a simple model:
summary(lm(deny ~ pirat, data = hmda))

# Let's look at the fitted regression line and the data:
ggplot(data = hmda, aes(x = pirat, y = deny)) + 
  #"pch=21" selects a marker with a different outline (circle), "color" changes the outline of the marker, "fill" changes the fill color (alpha changes transparency)
  geom_point(color = "#5601A4", fill = alpha("#5601A4",0.4), pch=21, size = 3) +
  
  #geom_smooth (with method "lm") adds a regression line (play around with the options! what happens if se = TRUE?)
  geom_smooth(method = "lm", color = "#BF3984", se = FALSE, lty = 1, lwd = 1.3) +
  
  # Adds horizontal lines (hlines) to show where 0 and 1 are.
  geom_hline(aes(yintercept = 0), color="dark grey", lty = 2, lwd=1)+
  geom_hline(aes(yintercept = 1), color="dark grey", lty = 2, lwd=1)+
  
  theme_bw()+
  xlab("Payment/Income ratio") + ylab("Deny")

# Let's run robust standard errors now

model2 <- lm_robust(deny ~ pirat, data = hmda)

summary(model2)

# We can add more variables too:
model3 <- estimatr::lm_robust(deny ~ pirat + factor(afam), data = hmda)
summary(model3)

# Q: How do these standard errors compare to the same LPM WITHOUT robust standar errors? Are they larger or smaller?
