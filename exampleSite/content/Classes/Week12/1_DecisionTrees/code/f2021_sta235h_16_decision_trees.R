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
library(caret)
library(rpart) #We'll need to load it to run a few things
library(rattle) # This is to make pretty tree plots with the caret package.
library(modelr)

############################################
#### Classification Trees
############################################

# Load the data for this exercise
disney <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week12/1_DecisionTrees/data/disney2.csv")

# For simplicity, we are going to make dummy covariates into factor variables
disney <- disney %>% mutate(mandalorian = factor(ifelse(mandalorian==0,"No","Yes")),
                            city = factor(ifelse(city==0,"No","Yes")))

# I already provide a training dataset (identified by train==1)
disney.train <- disney %>% filter(train==1)
disney.test <- disney %>% filter(train==0)

# Exercise: Ignore the variable train, and create your own train and testing dataset! Do you get the same results?

# Let's create 2x2 table for subscribers and unsubscribers:

disney.train %>% filter(unsubscribe==0) %>% select(city, mandalorian) %>% table #data for subscribers
disney.train %>% filter(unsubscribe==1) %>% select(city, mandalorian) %>% table #data for unsubscribers

# Exercise: Recreate the calculations we made in class. Can you calculate the Gini Index to build a classification tree?

# Let's create a dataset only with few variables so it's easy to see (you can recreate this with all the variable too!)
d.train <- disney.train %>% select(female, city, logins, mandalorian, unsubscribe)

set.seed(100)

# Let's use the caret package to run a classification tree
ct <- train(
  unsubscribe ~ ., data = d.train,
  method = "rpart", # The method is called rpart (Recursive Partitioning And Regression Trees)
  trControl = trainControl("cv", number = 10), # cross-validation with 10 fold
  tuneLength = 15 # Play around with this parameter: Is the granularity for the search of the best complexity parameter
)
## NOTICE: IF UNALTERED, THE OUTPUT HERE IS NOT RIGHT.
# Question: Notice the warning here. What can we do? Fix this code so that is runs as a classification task.

# We can plot the complexity parameter against accuracy:
plot(ct)
# Question: Just looking at the graph, which cp would you choose? Confirm your answer with the appropriate object within ct

# Let's now see the tree (you need all lines of code to get the labels):
par(xpd = NA) # Avoid clipping the text in some device
plot(ct$finalModel)
text(ct$finalModel)

# Pretty ugly, uh? Let's use this other function from the `rattle` package
fancyRpartPlot(ct$finalModel, caption = "Disney+ example - Simple classification tree",
               palettes = c("Purples","Greens")) #caption and palettes are optional arguments (no need to include them)

# Question: What do the numbers here mean? And the colors?

# Let's play around with the tuning parameter and other parameters for rpart:
ct <- train(
  factor(unsubscribe) ~., data = disney.train,
  method = "rpart",
  trControl = trainControl("cv", number = 10),
  tuneGrid = expand.grid(cp = seq(0, 3, by = 0.02)), # Let's use tuneGrid to provide exact values that we want to try (the hyper-parameter is now called `cp`)
  control = rpart.control(minsplit = 1) #Check out the options in ?rpart.control (part of the rpart package)
)

#Can you interpret the plot?
plot(ct)

#Question: Before running the following line, what numbers would you expect to see?
ct$results$cp

# Let's see now our optimal tree:
fancyRpartPlot(ct$finalModel, caption = "Disney+ example - Simple classification tree",
               palettes = c("Purples","Greens"))


# We can also see the final model here:
ct$finalModel
# Note that it shows you every split in order (the indentation shows you the levels!)
# Terminal nodes are indicated by an asterisk *

#Let's now look on whether we did a good job with prediction or not

pred.class <- ct %>% predict(disney.test)
disney.test <- disney.test %>% mutate(prediction = pred.class)

mean(factor(disney.test$unsubscribe) == disney.test$prediction)

#####################################################
########## Regression Tree
#####################################################

#Let's predict logins now.

set.seed(100)

rt <- train(
  logins ~. - unsubscribe, data = disney.train, # We give it our model and data (look that I use -unsubscribe so I don't use it as a predictor!)
  method = "rpart", #Method is rpart (any decision tree will use rpart)
  trControl = trainControl("cv", number = 10), # We want cross-validation with 10 fold
  tuneLength = 50 #That basically gives the number of values that will search for cp
)

plot(rt)

# Exercise: We saw in class that we can also give the train() function an explicit grid for it to search cp. Can you recreate that code here?

# Question: Look at the final model. Can you interpret it from this table?
rt$finalModel

# Let's predict the RMSE

rmse(rt, disney.test)

# Question: How would you interpret that RMSE?

# Let's plot this tree now:
fancyRpartPlot(rt$finalModel)

