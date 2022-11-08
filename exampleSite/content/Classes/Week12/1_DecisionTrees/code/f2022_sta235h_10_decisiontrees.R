################################################################################
### Title: "Week 12 - Decision Trees"
### Course: STA 235H
### Semester: Fall 2022
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
library(estimatr)
library(modelr)
library(caret)
library(rpart)
library(rattle)

################################################################################
################ Measuring churn ###############################################

hbo <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week12/1_DecisionTrees/data/hbomax2.csv")

head(hbo)

#In this case, I have already provided the training dataset:
train.data <- hbo %>% filter(train==1)
test.data <- hbo %>% filter(train==0)


###############################################################################
##### Classification tree
###############################################################################

set.seed(100)

train.control <- trainControl(method = "cv", number = 10) #set up a 10-fold cv

ct <- train(factor(unsubscribe) ~ . - id, data = train.data,
                    method = "rpart", 
                    tuneLength = 15, # This tells the model to choose 15 values of `cp` and test them (this is a good starting point, but tuneGrid is better!)
                    trControl = train.control)

# What is our best complexity parameter in this case?
ct$bestTune

# We can also see the plot here:
plot(ct)

# Let's see the final classification tree:
ct$finalModel

# Question: Which one is your most predictive covariate here?

#We can also plot this in a prettier way using the rattle package:
fancyRpartPlot(ct$finalModel, caption = "Classification Tree")

# Question: How would you classify someone who hasn't watched GoT and has more than one login in the previous week?

# Finally, we can also estimate the accuracy of this model, the same way we did it for our classification task in ridge or lasso:

pred.unsubscribe <- ct %>% predict(test.data)

mean(pred.unsubscribe == test.data$unsubscribe)

# Exercise: Instead of using tuneLength = 15, use tuneGrid = expand.grid(cp = seq(0,0.015, length = 50)) and see what you get!

############################################
#### Regression Tree
############################################

# Let's now complete the same task as before, but using logins as our outcome. Also, let's add some more stuff!
set.seed(100)

train.control <- trainControl(method = "cv", number = 10) #set up a 10-fold cv

rt <- train(logins ~ . - unsubscribe - id, data = train.data,
            method = "rpart", 
            tuneGrid = expand.grid(cp = seq(0, 0.01, length = 50)), # This tells the model to test 50 (equally-spaced) values of cp between 0 and 0.01
            trControl = train.control)

# What is our best complexity parameter in this case?
rt$bestTune

# We can also see the plot here:
plot(rt)

# Let's see our regression tree
fancyRpartPlot(rt$finalModel, caption = "Regression Tree")

# Now, we can estimate the RMSE of this model as well:

rmse(rt, test.data)

# Exercise: Compare this model with lasso or ridge regression from the previous class. Which one does better?

# Finally, we can also add other stopping conditions to make sure our leaves don't get too small:

set.seed(100)

rt <- train(logins ~ . - unsubscribe - id, data = train.data,
            method = "rpart", 
            tuneGrid = expand.grid(cp = seq(0, 0.01, length = 70)), # Just for fun, I changed the length of this vector to 70
            trControl = train.control,
            control = rpart.control(minsplit = 15)) # This tells the model that there needs to be at least 15 observations in each leave for it to attempt a split!

# What is our best complexity parameter in this case?
rt$bestTune
