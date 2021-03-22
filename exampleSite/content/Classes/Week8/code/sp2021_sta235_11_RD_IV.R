################################################################################
### Title: "Week 8 - Regression Discontinuity II and Instrumental Variables"
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
library(rdrobust)

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

## Covariate smoothness (robustness check to support potential outcomes smoothness assumption)

c = min(sales$time[sales$treat==0]) # cutoff time (we can use the max time for treated units or the min time for control units)

ggplot(data = sales, aes(x = time, y = income)) +
  geom_point() +
  geom_smooth(data = dplyr::filter(sales, time>c), method = "loess", se=TRUE, color = "red", fill = "red") +
  geom_smooth(data = dplyr::filter(sales, time<=c), method = "loess", se=TRUE, color = "blue", fill = "blue") +
  theme_bw()

# Question: Should we expect to see a significant jump? Why yes or why not?


## Check density smoothness (robustness check to support potential outcomes smoothness assumption)

# Let's look at the densities! We want to see if there's manipulation
library(rddensity) # We will be using this package a lot next class (the same with rdrobust)

rd <- rddensity(sales$time, c=c) # First we test the smoothness of the density function in the cutoff

summary(rd) # Look at the last column (P>|T|). Not significant at conventional values for any comparison. Question: What does this mean?

rdplotdensity(rd, sales$time) # we can plot this

# We can also check an histogram to see what's going on:

ggplot(data = sales, aes(x = time)) +
  geom_histogram(fill="grey", color = "white", bins = 70) + #This is giving the frequency of people arriving within each "bin" of time. I also set the histogram to have 60 bins (60 groups of time within our time period)
  geom_vline(aes(xintercept = 180), color = "#900DA4", lwt=2, lwd=1.4) +
  theme_bw()

  
###########################################
#### Different specifications #############
###########################################

# We will use the same example and check two different specifications:

sales <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week7/data/sales.csv")
c = min(sales$time[sales$treat==0])

sales <- sales %>% mutate(dist = c-time) # We are going to create a distance variable (distance to the cutoff)

lm1 <- lm(sales ~ dist + treat + dist*treat, data = sales) # Then we will fit a linear model, allowing for different intercept and slopes for the two groups.

sales_aug <- broom::augment(lm1, data = sales)

ggplot(data = sales_aug, aes(x = time, y = sales)) +
  geom_point(size = 5, pch = 21, color = "white", fill="grey") +
  geom_line(data = dplyr::filter(sales_aug, time>c), aes(x = time, y = .fitted), color = "#F89441", lwd = 2) +
  geom_line(data = dplyr::filter(sales_aug, time<=c), aes(x = time, y = .fitted), color = "#900DA4", lwd = 2) +
  theme_bw()


summary(lm1)

# Now let's fit a quadratic model!

lm2 <- lm(sales ~ dist + I(dist^2) + treat + dist*treat + treat*I(dist^2), data = sales) # Remember that we need to include both the linear and quadratic term of the running variable

sales_aug <- broom::augment(lm2, data = sales)

ggplot(data = sales_aug, aes(x = time, y = sales)) +
  geom_point(size = 5, pch = 21, color = "white", fill="grey") +
  geom_line(data = dplyr::filter(sales_aug, time>c), aes(x = time, y = .fitted), color = "#F89441", lwd = 2) +
  geom_line(data = dplyr::filter(sales_aug, time<=c), aes(x = time, y = .fitted), color = "#900DA4", lwd = 2) +
  theme_bw()

summary(lm2)

# Question: What differences do you see in both plots? Which one should you believe? 

# Now let's do the same but for a specific bandwidth [-100,100] in terms of distance to the cutoff.

sales_close <- sales %>% dplyr::filter(dist >= -100 & dist <= 100)

lm1_close <- lm(sales ~ dist + treat + dist*treat, data = sales_close) # let's fit the linear model... 

lm2_close <- lm(sales ~ dist + I(dist^2) + treat + dist*treat + treat*I(dist^2), data = sales_close) #... and the quadratic model using only data close to the cutoff.

library(modelsummary) #let's put everything in one table

modelsummary(list(lm1, lm2, lm1_close, lm2_close), stars = TRUE, gof_omit = 'DF|Deviance|R2|AIC|BIC|Log.Lik.') #Include all four previous models, include stars for significance, and omit certain GOF statistics to make the table less crowded.

#Question: Explain why these models return different results in terms of point estimates. Why do the last two models have so much larger Standard Errors (SE) compared to the first two?

###############################
# Let's use rdplot now to get see the RD

rdplot(y = sales$sales, x = sales$time, c = c, title = "RD plot",
       x.label = "time", y.label = "sales", col.dots = "#F89441", col.lines = "#900DA4") # We can change the colors of the markers and line.

# Question: What's the main difference with the previous models we were fitting for estimation?

# Let's get our estimate using rdrobust

summary(rdrobust(y = sales$sales, x = sales$time, c = c)) #To which previous model is this result more similar to?

# Question: By default, rdrobust uses a triangular kernel. What happens if we change it to uniform? Why?


##################################################################################
########## IV regressions ########################################################
#################################################################################

## Get out the vote example (from week 4)

d <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week4/1_RCT/data/voters_covariates.csv")

# Drop variables with unlisted phone numbers
d_s1 <- d[!is.na(d$treat_real),]

table(d_s1$treat_real, d_s1$contact) # Get a 2x2 table for who was assigned to treatment (rows) vs who actually was treated (columns)

d_s1 %>% group_by(treat_real) %>% summarise(contact = mean(contact)) #Get % of treated by treatment assignment status.


# Let's estimate the treatment effect!

# First stage: Regress the endogenous variable (whether someone was contacted or not) on our instrument (treatment assignment)
library(estimatr)

lm1 <- estimatr::lm_robust(contact ~ treat_real, data = d_s1)

summary(lm1)

d_s1$contact_fitted = lm1$fitted.values # We need to save the fitted values (this is our exogeneous variation of `contact`)

# Question: How would argue that the instrument is relevant? How would you argue is exogeneous?

# Second stage: Regress the fitted values (exogenous variation in contact) on our outcome

estimatr::lm_robust(vote02 ~ contact_fitted, data = d_s1) 

#Question: This effect is called a LATE. It's local to whom? Which individuals are not being captured in this effect?

# We can also estimat the intent to treat (ITT) effect (this is the effect of being *assigned* to treatment, which is different to the effect of *actually* being treated)
lm2 <- estimatr::lm_robust(vote02 ~ treat_real, data = d_s1)

summary(lm2)

lm2$coefficients[2]/lm1$coefficients[2] # Recover treatment effect by dividing ITT by compliance (first stage)

# Remember that your point-estimate is going to be right, but unless you adjust them, your SE are going to be wrong:

#You can use other packages for this, such as ivreg or the function iv_robust from estimatr package.
summary(iv_robust(vote02 ~ contact | treat_real, data = d_s1))


########## Fuzzy regression discontinuity design

read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week8/2_IV/data/tutoring.csv")

tutoring <- tutoring %>% mutate(distance = entrance_exam - 70,
                                below_cutoff = entrance_exam <= 70) # Create a distance variable and a treatment assignment variable (below_cutoff)

summary(iv_robust(exit_exam ~ distance + tutoring | distance + below_cutoff,
                  data = filter(tutoring, distance >= -10 & distance <= 10))) # Running a regression only in a bandwidth of [-10,10] away from the cutoff (in terms of distance)

summary(rdrobust(y = tutoring$exit_exam, x = tutoring$distance, c = 0, fuzzy = tutoring$tutoring)) #Now, let's do it nonparametrically with rdrobust.

# Question: Here, I am using distance as a running variable. Can you re-write the same function but using entrance_exam as your running variable? How would you change your other arguments of the function?
# do your estimated effect change?

# Question: We now want to estimate the Intention to Treat effect. How would you estimate that? 