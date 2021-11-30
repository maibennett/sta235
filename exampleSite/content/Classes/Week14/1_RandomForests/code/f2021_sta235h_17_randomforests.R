################################################################################
### Title: "Week 14 - Bagging, Random Forests, and Boosting"
### Course: STA 235H
### Semester: Fall 2021
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
library(rpart)
library(ranger) # You will need this to run random forests
library(rattle)
library(rsample) #This helps us divide our data by strata 

# You will need to install xgboost. For that, you need to have RTools installed on your computer first if you use Windows. Check this out if you have Windows: https://www.rdocumentation.org/packages/installr/versions/0.22.0/topics/install.Rtools
# After that, install xgboost to R
#install.packages("xgboost")
# If installing it from CRAN fails, you can also install it by downloading the file and going to "Tools --> Install Packages" using the file downloaded from here: https://cran.r-project.org/src/contrib/Archive/xgboost/

####################
## Car seats sale
###################

library(ISLR)
data("Carseats") # Load the data from the ISLR package (this is the package for the book we are using!)

head(Carseats) # Explore the data

set.seed(100)

split <- initial_split(Carseats, prop = 0.7, strata = "Sales") # This will create a 70-30 split, with 4 strata (by default) of the outcome variable.

carseats.train  <- training(split)
carseats.test   <- testing(split)

# Let's start with a simple decision tree, no pruning (cp = 0.01)

rp <- rpart(Sales ~., data = carseats.train, method = "anova", # method identifies if it's a regression ("anova") or classification ("class") tree
            control = rpart.control(cp = 0.01))

fancyRpartPlot(rp)

# Now, let's prune it with a cp of 0.05!

rpp <- prune(rp, cp = 0.05)

fancyRpartPlot(rpp)

# Now, let's try to get cp through cross-validation

mcv <- train(Sales ~., data = carseats.train, method = "rpart",
             trControl = trainControl("cv", number = 10), tuneLength = 50)

plot(mcv) # Exercise: Check out the optimal cp that is found. How much is it?

tuneGrid <- expand.grid(cp = seq(0, 0.01, 0.0001)) # To improve the search for cp, we give the train function a grid to look for cp

mcv <- train(Sales ~., data = carseats.train, method = "rpart", 
             trControl = trainControl("cv", number = 10), tuneGrid = tuneGrid)

plot(mcv)

fancyRpartPlot(mcv$finalModel) #This is the best way to plot the tree out of the caret package


#### Bagging

# Let's look at our decision tree again (this will be the best pruned DT):

set.seed(100)

tuneGrid <- expand.grid(cp = seq(0.002, 0.004, 0.00001))

mcv <- train(Sales ~ ., data = carseats.train,
             method = "rpart", trControl = trainControl("cv", number = 10),
             tuneGrid = tuneGrid)

plot(mcv)

rmse(mcv, carseats.test) # We calculate the RMSE for this DT.

fancyRpartPlot(mcv$finalModel)

# We can also look at the most important covariates, based on that tree:
varImp(mcv, scale = TRUE)

plot(varImp(mcv, scale = TRUE))

# How do these compare to the importance of the covariates for the bagged trees? Let's see

set.seed(100)

# We now ran bagged trees using the caret package
bt <- train(Sales ~ ., data = carseats.train,
            method = "treebag", trControl = trainControl("cv", number = 10),
            nbagg = 100,  
            control = rpart.control(cp = 0))

plot(varImp(bt, scale = TRUE))


###### Random forests

set.seed(100)

rfcv <- train(Sales ~ ., data = carseats.train,
              method = "ranger",                       # We basically do the same thing, but change the method (you can also use "rf", but "ranger" should be faster).
              trControl = trainControl("cv", number = 10),
              tuneLength = 10) # By default, the parameter that it's trying to optimize is the number m (mtry) of covariates that it samples

plot(rfcv)

# Question: How many trees is this RF running? You can see it here:
rfcv$finalModel

# What if we want to change the number of trees?

rfcv <- train(Sales ~ ., data = carseats.train,
              method = "ranger", ntree = 200,         # We can change the number of trees here
              trControl = trainControl("cv", number = 10),
              tuneLength = 10)

rfcv$finalModel # See results here

# What if we want to know which number of trees is best? We can create a loop!

modellist <- list() #   We create a list to save our results

#train with different ntree parameters
for (ntree in c(50,100,200,500, 1000)){
  
  set.seed(100)
  
  rfm <- train(Sales ~ ., data = carseats.train,
               method = "ranger", ntree = ntree,        # For each iteration, we are going to change ntree
               trControl = trainControl("cv", number = 10),
               tuneLength = 10)
  
  key <- toString(ntree) # We create a key so we can identify our results
  
  modellist[[key]] <- rfm # Then in the position of key, we store our model
}

#Compare results
results <- resamples(modellist) # This will just resample our results so we can get confidence intervals!
summary(results) # Look at these results.. pretty, no?

dotplot(results) # And we can plot them super easy. Can you interpret these plots? Which ntree would you choose?

#### Run faster

# One of the problems with random forests or other methods, is that they can be quite slow. Can we speed them up?

# Yes!

# We can parallelize some of the process. For that, we'll need a couple of new packages:
library(parallel)
library(doParallel)

cl <- makePSOCKcluster(detectCores() - 1) # detectCores() will detect the number of cores from your computer. convention to leave 1 core for OS
registerDoParallel(cl)

# Let's run our RF (and let's measure how long it takes!):

system.time(rfcv <- train(Sales ~ ., data = carseats.train,
                          method = "ranger",
                          trControl = trainControl("cv", number = 10, allowParallel = TRUE), # We need to include the allowParallel argument
                          tuneLength = 10)
)

stopCluster(cl) # We need to close the cluster once we are done

registerDoSEQ() # We also need to unregister the backend

# The parallel RF takes like 12s in my computer. Let's see how much it takes the original RF without parallelizing:

system.time(rfcv <- train(Sales ~ ., data = carseats.train,
                          method = "ranger",
                          trControl = trainControl("cv", number = 10),
                          tuneLength = 10)
)

# This takes around 30s, so using a parallel approach could save you a bunch of time!

#### Boosting

# Now, we are going to run some boosting
set.seed(100)

gbm <- train(Sales ~ ., data = carseats.train,
             method = "gbm",                          # We are using gradient boosting
             trControl = trainControl("cv", number = 10),
             tuneLength = 20) # Play around with this parameter!

# Final Model information
gbm$finalModel

# Best Tuning parameters?
gbm$bestTune

# You can also try extreme gradient boosting, which is more efficient
cl <- makePSOCKcluster(detectCores()-1)
registerDoParallel(cl)

set.seed(100)

xgbm <- train(Sales ~ ., data = carseats.train,
             method = 'xgbTree',                          # We are using extreme gradient boosting
             trControl = trainControl("cv", number = 10, allowParallel = TRUE)) # Play around with this parameter!

stopCluster(cl)
registerDoSEQ()

# Final Model information
xgbm$finalModel

# Best Tuning parameters?
xgbm$bestTune

# Exercise: Compare all the RMSE for the testing dataset with all the different models we have fit. Which one is better?


#########################################################################
#### Classification problem

## Exercise: repeat the same models as before, but now use `HighSales` as your outcome. What do you get?

Carseats$HighSales=ifelse(Carseats$Sales<=8, 0, 1) # Build a binary outcome

set.seed(100)

split <- initial_split(Carseats, prop = 0.7, strata = "Sales") #Create a new training and testing datasete

carseats.train  <- training(split)
carseats.test   <- testing(split)


# Exercise: 1) Find the best pruned model, 2) Run some bagged trees, 3) Run a random forest
# You can do all that adapting the code aboVe!


# I will help you with some boosting code: (this one can take a while)
set.seed(100)

ada <- train(factor(HighSales) ~ ., data = carseats.train,
             method = "ada",                                      #I'm using now adaptative boosting
             trControl = trainControl("cv", number = 10),
             tuneLength = 10)



gbm <- train(factor(HighSales) ~ ., data = carseats.train,
             method = "gbm",                                      #I'll also run gradient boosting
             trControl = trainControl("cv", number = 10),
             tuneLength = 10)

#Let's compare the results for these two boosting methods:

# Ada boosting
RMSE(ada %>% predict(carseats.test), carseats.test$Sales)

# Gradient boosting
RMSE(gbm %>% predict(carseats.test), carseats.test$Sales)
