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

################################################################################
### Quadratic model
################################################################################

## Let's look at data from the Current Population Survey (CPS) 1985
CPS1985 = read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week2/1_OLS/data/CPS1985_AER.csv")

## We can look at the variable descriptions using ?CPS1985

## Let's plot our outcome variable:

CPS1985 %>%
  ggplot(data = ., aes(x = wage)) + # The "." is a stand-in for whatever is piped before (in this case, the dataset). You can also just include `data = CPS1985` directly!
  geom_histogram(color = "#BF3984", fill = "white", lwd = 1.5, bins = 40) + 
  theme_minimal()+
  xlab("Wages (USD$/hr)") + ylab("Count")

## Combining pipes (%>%) and ggplot is useful, because you don't necessarily have to create new datasets
## Try it! Let's do the same histogram but only for females

CPS1985 %>% filter(gender == "female") %>%
  ggplot(data = ., aes(x = wage)) + # The "." is a stand-in for whatever is piped before (in this case, the dataset)
  geom_histogram(color = "#BF3984", fill = "white", lwd = 1.5, bins = 40) + 
  theme_minimal()+
  xlab("Wages (USD$/hr)") + ylab("Count")
  

## Going back to our original histogram, how would you describe the distribution?
## Let's plot log(wage) now
CPS1985 %>%
  ggplot(data = ., aes(x = log(wage))) + # The "." is a stand-in for whatever is piped before (in this case, the dataset)
  geom_histogram(color = "#BF3984", fill = "white", lwd = 1.5, bins = 40) + 
  theme_minimal()+
  xlab("log(Wages)") + ylab("Count")

## Let's run a regression:

CPS1985 <- CPS1985 %>% mutate(log_wage = log(wage)) #create a variable that is the log of wages (Note: Make sure all wages are >0!)

lm1 <- lm(log_wage ~ education + experience, data = CPS1985)

summary(lm1)

#### Q: Interpret the coefficient for education

## Let's plot the relationship between log(wage) and experience:

ggplot(data = CPS1985, aes(y = log_wage, x = experience)) +
  geom_point(fill = "white", color = "orange", size = 3, pch = 21) +
  theme_minimal()+
  xlab("Experience (Years)") + ylab("log(Wage)")

## What if we wanted to add the regression line for the model we fit in `lm1`?

## We will create a copy of our original dataset, but we will fix other variables (besides experience) to their mean.

CPS1985_fit <- CPS1985 %>% mutate(education = mean(education, na.rm=TRUE)) # What does na.rm do?

## Finally, we use the function "predict()" to get the fitted values for log(wages) based on our model lm1

CPS1985_fit <- CPS1985_fit %>% mutate(log_wage_hat_lm = predict(lm1, newdata = .))

## Now let's add this to the previous plot

ggplot(data = CPS1985_fit, aes(y = log_wage, x = experience)) +
  geom_point(fill = "white", color = "orange", size = 3, pch = 21) +
  geom_line(aes(x = experience, y = log_wage_hat_lm), color = "orange", lwd = 1.1) +
  theme_minimal()+
  xlab("Experience (Years)") + ylab("log(Wage)")

## This line doesn't look like it fits the data that well, so we want to include the Mincer equation:

lm_mincer <- lm(log_wage ~ education + experience + I(experience^2), data = CPS1985)

summary(lm_mincer)

## Note: To add a polynomial term we use I() and whatever exponent we want

## Let's repeat the same process as before to add the quadratic fit to the data

CPS1985_fit <- CPS1985_fit %>% mutate(log_wage_hat_lq = predict(lm_mincer, newdata = .))

## Now let's add this to the previous plot

ggplot(data = CPS1985_fit, aes(y = log_wage, x = experience)) +
  geom_point(fill = "white", color = "orange", size = 3, pch = 21) +
  geom_line(aes(x = experience, y = log_wage_hat_lq), color = "orange", lwd = 1.1) +
  theme_minimal()+
  xlab("Experience (Years)") + ylab("log(Wage)")

#### Q: Does it look like it fits better?

#### Q: After what point does the return to experience starts being negative instead of positive?
