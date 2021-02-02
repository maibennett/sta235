
##############################################################
### Title: Homework 1
### Course: STA 235
### Semester: Spring 2021
### Name: [YOUR NAME HERE]
##############################################################

# Clears memory
rm(list = ls())
# Clears console
cat("\014")

### Load libraries (load any package you might need)
library(tidyverse)
library(ggplot2)
library(estimatr)

# Load insurance data
insurance <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Assignments/Homework1/data/insurance.csv")


## Exploratory analysis
  
ggplot(data = insurance, 
       aes(x = age, y = charges)) +
  geom_point(color = "dark orange", fill = alpha("dark orange", 0.5), size = 3, pch = 21) +
  theme_bw()

### Question 1.1: 
#Describe the relationship between age and charges based on the previous plot.

### Question 1.2: 
#Make a new plot that colors these points by whether a person is a smoker or not. What can you tell about the relationship between age and charges?
  
### Question 1.3: 
#Now, show a new plot with the relationship between BMI and charges. What can you say about that relationship? Does the relationship look linear?
  

## Let's build some models
  
### Question 1.4: 
#Using the previous information, build a regression using age, body mass index, smoker category, and sex as covariates, and charges as the dependent variable. 
#Use any variable transformation that you believe appropriate (and justify it). Interpret the coefficients for this model.
  
  
#Finally, let's add region to the previous regression. 

### Question 1.5: 
#If we wanted to predict an individual's insurance charges, which model do you think would be better and why? Show your results.
  
  
# Task 2: Models with binary outcomes
  
nba <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Assignments/Homework1/data/nba.csv")


## Fitting some models
  
### Question 2.1: 
#Interpret the coefficient for games played and 3-point percentage in this setting (SE are in parenthesis)
  
lm2.1 <- estimatr::lm_robust(TARGET_5Yrs ~ GP + PTS + X3PP + REB + AST, data = nba)

summary(lm2.1)


#Now, fit the same model using a logistic regression.

### Question 2.2: 
#Interpret the same coefficients for this model (games played and 3-point percentage) in your logistic regression. How do they compare to the linear probability model?
  
  
## Predictions
  
rookies <- data.frame(Name = c("Smith Roberts","Tyler Stevens"),
                      GP = c(91,15),
                      PTS = c(28,42),
                      X3PP = c(66.1,75.5),
                      REB = c(2,5.1),
                      AST = c(1.5,2))

### Question 2.3: 
#Compare the predictions given by the Linear Probability Model and the Logistic Regression. Which model would you use and why?
  
  
# Task 3: Introduction to Causal Inference
  
# Load all insurance data
insurance_all <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Assignments/Homework1/data/insurance_all.csv")


### Question 3.1: 
#What is the relationship between being insured and BMI? and what about smoking? Draw some figures and fit some simple models! Comment on your results.


####

lm3.1 <- lm(bmi ~ insured + factor(smoker) + age + factor(sex) + factor(region), data = insurance_all)

summary(lm3.1)

### Question 3.2: 
#Why is the coefficient on `insured` different in the simple regression model than in your colleagues model? Explain.


### Question 3.3: 
#Can we identify the effect of being insured on BMI with your colleagues' model? Why or why not? Can you see a potential collider problem?
  
  
## Design your own study:
  
#Imagine now that you've been hired by an insurance company to identify the causal effect of being insured on BMI, so they can assess potential "Moral Hazard".

### Question 3.4: 
#If you wanted to identify the causal effect of being insured on BMI, how would you do it? Would you need additional data? Give the details of your study design.

# Task 4: Let's bring everything together

#[Banerjee, Chandrasekhar, Duflo, and Jackson (2013)](https://web.stanford.edu/~jacksonm/Banerjee-Chandrasekhar-Duflo-Jackson-DiffusionOfMicrofinance-Science-2013.pdf) wanted to 
#measure how centrality within a network (e.g. how "well-connected" people are) affected the diffusion of information related to a micro-finance intervention (a loan) in India. 
#The idea of this study was to inform influential people in each village about the availability of a loan, and analyze the diffusion of that information relative to network connections. 
#The authors collected data in several villages in India related to connectivity of each household in the following *simplified* dataset:
  
## data on 8622 households
hh <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Assignments/Homework1/data/microfi_edit.csv")

### Question 4.1:
#Write down the potential outcome model for estimating the effect of connectiveness on whether a household took out a loan or not. Note: You don't need data for this!

### Question 4.2: 
#What model would you fit to estimate the effect of centrality on whether a household took out a loan or not using this data? Estimate it!

### Question 4.3: 
#Interpret the coefficient of `degree_z` on `loan`

### Question 4.4: 
#Is the previous effect causal? Why or why not? Write down your assumptions.

### Questions 4.5:
#Write down at least two potential threats to causality in this context.

