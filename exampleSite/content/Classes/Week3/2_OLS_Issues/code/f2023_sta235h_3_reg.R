######################################################################
### Title: "Week 3 - Outliers and Linear Probability Models"
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
library(AER) #package that includes some interesting data
library(estimatr) #package to run linear regressions with robust SE

###################### OUTLIERS ################################################

### HMDA Example

# This is the data from 2017 HMDA for Bastrop county (https://www.consumerfinance.gov/data-research/hmda/historic-data/?geo=tx&records=first-lien-owner-occupied-1-4-family-records&field_descriptions=labels)
# (you can also find the whole dataset for Austin by changing the name of the file to hmda_2017_austin.csv)

loans <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week3/2_OLS_Issues/data/hmda_2017_austin_bastrop.csv", stringsAsFactors = FALSE)

# You can find information about the variables here: https://files.consumerfinance.gov/hmda-historic-data-dictionaries/lar_record_codes.pdf

# Let's look at loans that were approved (action_taken = 1) for home purchase (loan_purpose = 1) (hint: you will need to subset your data)

loans <- loans %>% filter(action_taken==1 & loan_purpose==1)

# Q: How could we see if we have outliers?

ggplot(data = loans, aes(x = loan_amount_000s)) +
  geom_histogram(color = "skyblue3", fill = "skyblue", lwd = 1.1) +
  xlab("Loan amount (1,000 US$)") +
  theme_minimal()

# Show a scatter plot of loan amount vs applicant's income:

ggplot(data = loans, aes(x = applicant_income_000s, y = loan_amount_000s)) +
  geom_point(color = "skyblue3") +
  theme_minimal() +
  xlab("Applicant's income (M US$)") + ylab("Loan Amount (M US$)")  

# Fit a regression line to the previous plot:

ggplot(data = loans, aes(x = applicant_income_000s, y = loan_amount_000s)) +
  geom_point(color = "skyblue3") +
  theme_minimal() +
  xlab("Applicant's income (M US$)") + ylab("Loan Amount (M US$)") +
  geom_smooth(method = "lm", se = FALSE, color = "blue", lwd = 1.1)
# geom_smooth() fits a smooth function for our data!
# method="lm" fits a linear regression of loan_amount ~ income
# se = FALSE is to turn off the shade for standard errors (set se = TRUE and see what happens!)
# color = "blue" sets the color of the regression line
# lwd = 1.1 sets the width of the line


# Fit a regression line but *excluding* the clear outliers

## Create new dataset excluding both income outliers 
loans_without_outliers_income <- loans %>% filter(applicant_income_000s<700)

ggplot(data = loans, aes(x = applicant_income_000s, y = loan_amount_000s)) +
  geom_point(color = "skyblue3") +
  theme_minimal() +
  xlab("Applicant's income (M US$)") + ylab("Loan Amount (M US$)") +
  geom_smooth(method = "lm", se = FALSE, color = "blue", lwd = 1.1) +
  #same plot as before, but we add a new layer, which is a linear regression but for the NEW dataset we created!
  geom_smooth(data = loans_without_outliers_income,
              aes(x = applicant_income_000s, y = loan_amount_000s),
              method = "lm",
              se = FALSE,
              color = "purple")


## Create new dataset excluding both loan outliers 
loans_without_outliers_loan <- loans %>% filter(loan_amount_000s<750)

ggplot(data = loans, aes(x = applicant_income_000s, y = loan_amount_000s)) +
  geom_point(color = "skyblue") +
  theme_minimal() +
  xlab("Applicant's income (1,000 US$)") + ylab("Loan Amount (1,000 US$)") +
  geom_smooth(method = "lm", se = FALSE, color = "blue", lwd = 1.1) +
  #same plot as before, but we add a new layer, which is a linear regression but for the NEW dataset we created!
  geom_smooth(data = loans_without_outliers_loan,
              aes(x = applicant_income_000s, y = loan_amount_000s),
              method = "lm",
              se = FALSE,
              color = "purple")


### Tip: If you want to add labels to your smooth lines, you can add "color" as an aes() feature (use whatever names you want!)

ggplot(data = loans, aes(x = applicant_income_000s, y = loan_amount_000s)) +
  geom_point(color = "skyblue") +
  theme_minimal() +
  xlab("Applicant's income (1,000 US$)") + ylab("Loan Amount (1,000 US$)") +
  geom_smooth(aes(color = "linear fit"), method = "lm", se = FALSE, lwd = 1.1) +
  geom_smooth(data = loans_without_outliers_loan,
              aes(x = applicant_income_000s, y = loan_amount_000s,
                  color = "linear fit w/o outliers"),
              method = "lm",
              se = FALSE) +
  scale_color_manual(values = c("blue", "purple"), name = "Regression lines") #Then, you can set your preferred colors using scale_color_manual()


# Q: For your original data, create a dummy variable if the observation is an outlier
# in terms of income (1) or (0) in another case. How many outliers do you have?

loans = loans %>% mutate(outlier = ifelse(applicant_income_000s>700, 1, 0))

loans %>% select(outlier) %>% table(.)

# Q: Run a regression with and without outliers. Do your results change qualitatively?

lm_all = lm(loan_amount_000s ~ applicant_income_000s, data = loans)

lm_wo_outliers = lm(loan_amount_000s ~ applicant_income_000s, data = loans_without_outliers_income)

summary(lm_all)
summary(lm_wo_outliers)


###################### LINEAR PROBABILITY MODELS ###############################

data(HMDA) # This dataset is loaded from the AER package

# To know what the variables are, you can type ?HMDA on the console
head(HMDA)

# Let's look at the variable `deny`, which captures whether someone gets the loan
# denied ("yes") or not ("no"). Q: How many people get the loan denied?
HMDA %>% select(deny) %>% table()

# `deny` is a factor (categorical) variable, and we want to transform it to numeric.
# We can do this in different ways:

#1) Use ifelse to set it to 1 if deny is "yes" and 0 in another case
HMDA = HMDA %>% mutate(deny_num = ifelse(deny=="yes", 1, 0))
# Check numbers are right
HMDA %>% select(deny_num) %>% table()

#2) Notice that deny is a factor that takes two numeric values: 1 if it's "no" and 2 if it's "yes".
# We can transform it to numeric (1,2) and then substract 1:
HMDA = HMDA %>% mutate(deny_num = as.numeric(deny) - 1)
# Check numbers are right
HMDA %>% select(deny_num) %>% table()


## Linear Probability Model

# Let's run a simple model:
summary(lm(deny_num ~ pirat, data = HMDA))

# Let's look at the fitted regression line and the data:
ggplot(data = HMDA, aes(x = pirat, y = deny_num)) + 
  #"pch=21" selects a marker with a different outline (circle), "color" changes the outline of the marker, "fill" changes the fill color (alpha changes transparency)
  geom_point(color = "#5601A4", fill = alpha("#5601A4",0.4), pch=21, size = 3) +
  
  #geom_smooth (with method "lm") adds a regression line
  geom_smooth(method = "lm", color = "#BF3984", se = FALSE, lty = 1, lwd = 1.3) + #lty defines the line type (1 is solid line, 2 is dashed line)
  
  # Adds horizontal lines (hlines) to show where 0 and 1 are.
  geom_hline(aes(yintercept = 0), color="dark grey", lty = 2, lwd=1)+
  geom_hline(aes(yintercept = 1), color="dark grey", lty = 2, lwd=1)+
  
  theme_minimal()+
  xlab("Payment/Income ratio") + ylab("Deny")

# Let's run robust standard errors now
model2 = lm_robust(deny_num ~ pirat, data = HMDA) #lm_robust() is only available after loading the estimatr package!

summary(model2)
#Q: How do the point estimates (beta hats) and standard errors compare for the same model with lm()?

# We can add more variables too:
model3 = lm_robust(deny_num ~ pirat + afam, data = HMDA)
summary(model3)

# Q: Interpret the coefficient for pirat (payment to income ratio) and the coefficient for afam (African American == Yes).
# Q: How do these standard errors compare to the same LPM WITHOUT robust standard errors? Are they larger or smaller?
