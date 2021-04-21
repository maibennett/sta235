################################################################################
### Title: "Week 12 - CART"
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
library(broom)
library(caret)
library(rpart)
library(rpart.plot)
library(rattle) # This is to make pretty tree plots with the caret package.

############################################
#### Classification Trees
############################################

# Load the data for this exercise
disney <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week12/1_DecisionTrees/data/disney2.csv")

# For simplicity, we are going to make dummy covariates into factor variables
disney <- disney %>% mutate(mandalorian = factor(ifelse(mandalorian==0,"No","Yes")),
                            city = factor(ifelse(city==0,"No","Yes")))

# I already provide a training dataset (identified by train==1)
disney.train <- disney %>% dplyr::filter(train==1)

# Exercise: Ignore the variable train, and create your own train and testing dataset! Do you get the same results?

# Let's create 2x2 table for subscribers and unsubscribers:

disney_subs <- disney.train %>% dplyr::filter(unsubscribe==0) #data for subscribers
disney_unsubs <- disney.train %>% dplyr::filter(unsubscribe==1) #data for unsubscribers

# Table for subscribers
table(disney_subs$city,disney_subs$mandalorian)

# Table for unsubscribers
table(disney_unsubs$city,disney_unsubs$mandalorian)

# Exercise: Recreate the calculations we made in class. Can you calculate the Gini Index to build regression trees?


# Let's create a smaller dataset that just has two binary covariates:
d.train <- disney.train %>% dplyr::select(mandalorian, city, unsubscribe)

set.seed(100)

# Remember to include the method "class" for a classification tree (you can also omit it, and use factor(unsubscribe) as a dependent variable) 
m1 <- rpart(unsubscribe ~., data = d.train, method = "class", cp=-1) # Why do we set cp=-1?

rpart.plot(m1) #Interpret this tree!

# Now, let's play with some parameters:

m1 <- rpart(unsubscribe ~., data = d.train, method = "class", 
            control = rpart.control(cp = 0.05, minsplit = 20)) #Let's use a cp of 0.05

# Question: What does this do? Change it around and see how your tree changes!

rpart.plot(m1)

# Exercise: Change minsplit = 1500. What happens now? Why? (You can use ?rpart.control to gain some insight)

m1 <- rpart(unsubscribe ~., data = d.train, method = "class", 
            control = rpart.control(minsplit = 20)) #Let's not fix any cp. What happens then?

m1$cptable #cptable gives you the value of CPs tested, the number of splits for each cp, the relative error (relative to no split), the mean error, and the std dev of that error.

plotcp(m1) # Question: Which cp would you choose? What does "size of tree" mean?

# Finally, let's test the accuracy of our model!

disney.test <- disney %>% dplyr::filter(train==0)

# We use cross-validation to find the cp parameter.
mclass <- train(
  factor(unsubscribe) ~., data = disney.train, 
  method = "rpart",
  trControl = trainControl("cv", number = 10),
  tuneLength = 50
)

pred.class <- mclass %>% predict(disney.test)

mean(pred.class==disney.test$unsubscribe) # This gives us the accuracy rate.

# This is how you plot the traditional models
plot(mclass$finalModel)
text(mclass$finalModel)

# But you can make it prettier!
fancyRpartPlot(mclass$finalModel)

#####################################################
########## Regression Tree
#####################################################

#Let's predict logins now.

set.seed(100)
r1 <- rpart(logins ~. - unsubscribe, data = disney.train,
            method = "anova")#<<

rpart.plot(r1)

# Question: What's the cp for r1? Can you find it?

# We might want to obtain our cp parameter through cross-validation. For that, we can use the caret package:
mcv <- train(
  logins ~. - unsubscribe, data = disney.train, # We give it our model and data (look that I use -unsubscribe so I don't use it as a predictor!)
  method = "rpart", #Method is rpart (any decision tree will use rpart)
  trControl = trainControl("cv", number = 10), # We want cross-validation with 10 fold
  tuneLength = 50 #That basically gives the number of values that will search for cp
)

plot(mcv)

# Exercise: We saw in class that we can also give the train() function an explicit grid for it to search cp. Can you recreate that code here?

# We can also plot the model
par(xpd = NA) # Avoid clipping the text in some device
plot(mcv$finalModel) # This will plot the tree
text(mcv$finalModel, digits = 3) # This will plot the labels!

# Question: Look at the final model. Can you interpret it from this table?
mcv$finalModel

# Let's predict the RMSE

pred.reg <- mcv %>% predict(disney.test)

RMSE(pred.reg, disney.test$logins)

# Question: How would you interpret that RMSE?

# Let's plot this tree now:
fancyRpartPlot(mcv$finalModel)

###########################################################
#### Additional exercises
###########################################################

