################################################################################
### Title: "Week 7 - Regression Discontinuity I"
### Course: STA 235
### Semester: Spring 2021
### Professor: Magdalena Bennett
################################################################################

# Clears memory
rm(list = ls())
# Clears console
cat("\014")

### Load libraries
# If you don't have one of these packages installed already, you will need to 
#run install.packages() line
library(tidyverse)
library(ggplot2)
library(estimatr)
library(broom)

################################################################################
################ In class examples #############################################
################ Discount by time of arrival ###################################


######################
## Group 1 ###########
######################

# You receive the sales data for the sales example we saw a couple of weeks ago

sales <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week7/data/sales.csv")

# Check out the data
head(sales)

# id: identification for each person
# time: time of arrival, since the store opened
# age: age of the person
# female: whether the customer is female or not
# income: average income for the customer
# sales: amount of the purchase
# treat: whether the person received a discount or not (e.g. was within the first 1,000 customers)

# Task 1) Create a plot with the running variable in the x-axis and the treatment variable in the y-axis.
# Questions to answer: 
# i) What is the running variable? Can you obtain the cutoff for treatment assignment?
# ii) What does this plot tells you?

# Task 2) Identify your cutoff score and assign it to c <-
# Add to your previous plot a fitted smooth line for each side of the cutoff adding to your previous code the following:
# geom_smooth(data = filter(sales, time>c), method = "loess", se=TRUE, color = "red", fill = "red")
# and geom_smooth(data = filter(sales, time<=c), method = "loess", se=TRUE, color = "blue", fill = "blue")

# This is the plot you had to do
ggplot(data = sales, aes(x = time, y = treat)) +
  geom_point() +
  geom_smooth(data = filter(sales, time>c), method = "loess", se=TRUE, color = "red", fill = "red") +
  geom_smooth(data = filter(sales, time<=c), method = "loess", se=TRUE, color = "blue", fill = "blue") +
  theme_bw()

# If you don't want all markers to be aligned in the same line (it can be difficult to observe),
# you can add a random jitter (move them slightly up and down), so you can see more of the data.
# This is a good trick for any time you have data on the same line.

sales <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week7/data/sales.csv")
c = max(sales$time[sales$treat==1])

pos = position_jitter(width = 0, height = 0.1, seed = 1234) #I only move them slightly (0.1) up and down. I set a seed so it's reproducible.

ggplot(data = sales, aes(x = time, y = treat)) +
  geom_point(data = filter(sales, time<=c), size = 5, pch = 21, color = "white", fill="#900DA4", position = pos) + #I filter the data so I can color units below and above the cutoff
  geom_point(data = filter(sales, time>c), size = 5, pch = 21, color = "white", fill="#F89441", position = pos) +
  theme_bw()

# Question: If you don't want to use the filter function, can you create this same plot using other techniques we have seen?


######################
## Group 2 ###########
######################

# Task 1) Create a plot with the running variable in the x-axis and sales in the y-axis.
# Questions to answer: 
# i) What is the running variable? Can you obtain the cutoff for treatment assignment from your data?
# ii) What does this plot tells you?

# Task 2) Identify your cutoff score and assign it to c <-
# Add to your previous plot a fitted smooth line for each side of the cutoff adding to your previous code the following:
# geom_smooth(data = filter(sales, time>c), method = "loess", se=TRUE, color = "red", fill = "red")
# and geom_smooth(data = filter(sales, time<=c), method = "loess", se=TRUE, color = "blue", fill = "blue")

# This is the plot that was asked
ggplot(data = sales, aes(x = time, y = sales)) +
  geom_point() +
  geom_smooth(data = filter(sales, time>c), method = "loess", se=TRUE, color = "red", fill = "red") +
  geom_smooth(data = filter(sales, time<=c), method = "loess", se=TRUE, color = "blue", fill = "blue") +
  theme_bw()

ggplot(data = sales, aes(x = time, y = sales)) +
  geom_point(size = 5, pch = 21, color = "white", fill="grey") + # I use a grey color for the observations and color the fitted functions two different colors
  geom_smooth(data = filter(sales, time>c), method = "loess", se=TRUE, color = "#F89441", fill = "#F89441") +
  geom_smooth(data = filter(sales, time<=c), method = "loess", se=TRUE, color = "#900DA4", fill = "#900DA4") +
  theme_bw()

######################
## Group 3 ###########
######################

# Task 1) Create a plot with the running variable in the x-axis and income in the y-axis.
# Questions to answer: 
# i) What is the running variable? Can you obtain the cutoff for treatment assignment from your data?
# ii) What does this plot tells you?

# Task 2) Identify your cutoff score and assign it to c <-
# Add to your previous plot a fitted smooth line for each side of the cutoff adding to your previous code the following:
# geom_smooth(data = filter(sales, time>c), method = "loess", se=TRUE, color = "red", fill = "red")
# and geom_smooth(data = filter(sales, time<=c), method = "loess", se=TRUE, color = "blue", fill = "blue")


ggplot(data = sales, aes(x = time, y = income)) +
  geom_point() +
  geom_smooth(data = filter(sales, time>c), method = "loess", se=TRUE, color = "red", fill = "red") +
  geom_smooth(data = filter(sales, time<=c), method = "loess", se=TRUE, color = "blue", fill = "blue") +
  theme_bw()

ggplot(data = sales, aes(x = time, y = income)) +
  geom_point(size = 5, pch = 21, color = "white", fill="grey") + # I use a grey color for the observations and color the fitted functions two different colors
  geom_smooth(data = filter(sales, time>c), method = "loess", se=TRUE, color = "#F89441", fill = "#F89441") +
  geom_smooth(data = filter(sales, time<=c), method = "loess", se=TRUE, color = "#900DA4", fill = "#900DA4") +
  theme_bw()

######################
## Group 4 ###########
######################

# You receive the sales data for the sales example we saw a couple of weeks ago

sales_mod <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week7/data/sales_mod.csv")

# The difference here is that the discount was given to all the customers that arrived before noon (the store opened at 9.00am)

c = 180

ggplot(data = sales_mod, aes(x = time, y = income)) +
  geom_point() +
  geom_smooth(data = filter(sales, time>c), method = "loess", se=TRUE, color = "red", fill = "red") +
  geom_smooth(data = filter(sales, time<=c), method = "loess", se=TRUE, color = "blue", fill = "blue") +
  theme_bw()

ggplot(data = sales, aes(x = time, y = income)) +
  geom_point(size = 5, pch = 21, color = "white", fill="grey") + # I use a grey color for the observations and color the fitted functions two different colors
  geom_smooth(data = filter(sales, time>c), method = "loess", se=TRUE, color = "#F89441", fill = "#F89441") +
  geom_smooth(data = filter(sales, time<=c), method = "loess", se=TRUE, color = "#900DA4", fill = "#900DA4") +
  theme_bw()

# Question: If there's a discontinuity here, is it a problem? Why?
# Question: Can you do the same thing for age? What do you find?


# Let's look at the densities! We want to see if there's manipulation
library(rddensity) # We will be using this package a lot next class (the same with rdrobust)

rd <- rddensity(sales_mod$time, c=180) # First we test the smoothness of the density function in the cutoff

rdplotdensity(rd, sales_mod$time) # we can plot this

# Let's look at the other example, to see if there's manipulation there:

rd <- rddensity(sales$time, c=max(sales$time[sales$treat==1]))

rdplotdensity(rd, sales$time)

# We can also check an histogram to see what's going on:

ggplot(data = sales_mod, aes(x = time)) +
  geom_histogram(fill="grey", color = "white", bins = 60) + #This is giving the frequency of people arriving within each "bin" of time. I also set the histogram to have 60 bins (60 groups of time within our time period)
  geom_vline(aes(xintercept = 180), color = "#900DA4", lwt=2, lwd=1.4)
  theme_bw()

# Question: What happens if you play around with the bins argument? Set it to 40 or 50.. What can you see?
  
###########################################
#### Checking different specifications ####
###########################################

# We will use the same example and check two different especifications:

sales <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week7/data/sales.csv")
c = max(sales$time[sales$treat==1])

sales <- sales %>% mutate(dist = c-time) # We are going to create a distance variable (distance to the cutoff)

lm1 <- lm(sales ~ dist + treat + dist*treat, data = sales) # Then we will fit a linear model, allowing for different intercept and slopes for the two groups.

sales_aug <- broom::augment(lm1, data = sales)

ggplot(data = sales_aug, aes(x = time, y = sales)) +
  geom_point(size = 5, pch = 21, color = "white", fill="grey") +
  geom_line(data = filter(sales_aug, time>c), aes(x = time, y = .fitted), color = "#F89441", lwd = 2) +
  geom_line(data = filter(sales_aug, time<=c), aes(x = time, y = .fitted), color = "#900DA4", lwd = 2) +
  theme_bw()


summary(lm1)

# Now let's fit a quadratic model!

lm2 <- lm(sales ~ dist + I(dist^2) + treat + dist*treat + treat*I(dist^2), data = sales) # Remember that we need to include both the linear and quadratic term of the running variable

sales_aug <- broom::augment(lm2, data = sales)

ggplot(data = sales_aug, aes(x = time, y = sales)) +
  geom_point(size = 5, pch = 21, color = "white", fill="grey") +
  geom_line(data = filter(sales_aug, time>c), aes(x = time, y = .fitted), color = "#F89441", lwd = 2) +
  geom_line(data = filter(sales_aug, time<=c), aes(x = time, y = .fitted), color = "#900DA4", lwd = 2) +
  theme_bw()

summary(lm2)

# Question: What differences do you see in both plots? Which one should you believe? 
# Task: Fit now a cubic model. What do you find?