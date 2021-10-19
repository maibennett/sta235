################################################################################
### Title: "Week 8 - Binary Outcomes"
### Course: STA 235H
### Semester: Fall 2021
### Professor: Magdalena Bennett
################################################################################

# Clears memory
rm(list = ls())
# Clears console
cat("\014")

### Load libraries
# If you don't have one of these packages installed already, you will need to run install.packages() line
library(tidyverse)
library(ggplot2)
library(AER)
library(estimatr)

####### Binary outcomes

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
  geom_point(color = "#5601A4", fill = alpha("#5601A4",0.4), pch=21, size = 3)+
  geom_smooth(method = "lm", color = "#BF3984", se = FALSE, lty = 1, lwd = 1.3) +
  
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

## Logistic Regression (we will be using `glm()` function with family = binomial(link = "logit")), to indicate we are using a logistic regression)
logit1 <- glm(deny ~ pirat, family = binomial(link = "logit"),
              data = hmda)

prob <- predict(logit1, type = "response") # probabilities

# Let's plot the predicted probabilities using logit and the data that we have!
ggplot(data = hmda, aes(x = pirat, y = deny)) + 
  geom_point(color = "#5601A4", fill = alpha("#5601A4",0.4), pch=21, size = 3)+ # This is a scatter plot for the data
  geom_line(aes(x = pirat, y = prob), color = "#BF3984", lty = 1, lwd = 1.3) + #This are the fitted probabilities
  
  geom_hline(aes(yintercept = 0), color="dark grey", lty = 2, lwd=1)+
  geom_hline(aes(yintercept = 1), color="dark grey", lty = 2, lwd=1)+
  
  theme_bw()+
  xlab("Payment/Income ratio") + ylab("Deny")


# To interpret coefficients, we need to choose the values for the other variables (in this case,
# the mean for payments to income ratio)
logit2 <- glm(deny ~ pirat + factor(afam), family = binomial(link = "logit"),
              data = hmda) # This is the model we are fitting with two covariates

# We need to pass to predict: The model we fitted, the new data we want to fit our probabilities (if we leave blank, it uses the original hmda data)
# and we need to say type = "response" to get *probabilities* (and not odds, or log odds, or anything else)
predictions_afam <- predict(logit2, newdata = data.frame("afam" = c("no", "yes"),
                                                         "pirat" = c(mean(hmda$pirat), mean(hmda$pirat))),
                            type = "response") 

# These are the predictions for two observations with the same payment/income ratio (the mean of our data)
# and where one is african american and the other one is not.
predictions_afam

# Difference between both predictions
diff(predictions_afam)

