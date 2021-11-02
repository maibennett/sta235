################################################################################
### Title: "Week 10 - Shrinkage"
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
library(modelr)

############################################
#### Shrinkage
############################################

#### Rigde regression

data <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week10/1_Shrinkage/data/purchases.csv") # Load data

set.seed(100) # Remember to set a seed!

n <- nrow(data)

train.row <- sample(1:n, 0.8*n) # We generate a random sample for the training data

test.data <- data %>% slice(-train.row) #Select testing data
train.data <- data %>% slice(train.row) #Select training data

## Exercise: Play around with the proportions. What happens if you hold-out just 10% of the sample? (i.e. use only 10% of the sample for testing). How do your results change?

lambda_seq <- c(0,10^seq(-3, 3, length = 100)) # Create a vector for different values of lambda (THIS WILL DEPEND ON YOUR EXAMPLE AND YOU NEED TO CHANGE IT ACCORDINGLY)

## Question: Why do we use an exponential vector?

ridge <- train(spend ~., data = train.data, # We give the function `train` the formula (`spend` regressed on everything else that's on the dataset). Note: If there are variables *you don't want to include* (e.g. an id variable), you can exclude it with a - sign (e.g. spend ~ . - id).
            method = "glmnet", # We will be using an "Elastic Net" method (which is basically the method family for ridge and lasso reg)
            preProcess = "scale", # Pre-process the data (remember that lasso and ridge are affected by scales! So this standardizes our covariates before doing anything)
            trControl = trainControl("cv", number = 10), # We are using a cross-validation method, with 10 folds. What happens if you change the number of folds?
            tuneGrid = expand.grid(alpha = 0, # alpha is the "mixing" parameter. All you need to know is that `alpha=0` is for ridge regression (and `alpha=1` is for lasso)
                                   lambda = lambda_seq) # values of lambda we are going to test out
)
# This might ask you to install the "glmnet" package (you just have to install it once, and do not need to load it independtly (caret will load it for you))

lambda <- ridge$results$lambda #We can extract the vector of tested lambdas here
rmse <- ridge$results$RMSE # We can extract the C-V RMSE for each of those lambdas!

## Exercise: What other important things do you see in the object `results`? Explore it!

# I create a new dataframe to be able to plot lambda against RMSE
# Here, I'm just creating a new dataframe with two variables: Lambda and RMSE.
cv_lambda <- data.frame("lambda" = lambda,
                        "rmse" = rmse)

# Plot lambda vs RMSE
ggplot(data = cv_lambda, aes(x = lambda, y = rmse)) + # x axis will be the parameter lambda and y axis will be RMSE
  geom_line(aes(color = "#BF3984"), lwd = 2) + # Let's create a line plot for lambda and RMSE (to see how it behaves)
  geom_vline(aes(xintercept = ridge$bestTune$lambda, color = "dark grey"), lty=2, lwd = 1.5) + # geom_vline adds a vertical line at a specific value of x (xintercept). In this case, we are providing the value for the best lambda in terms of RMSE
  scale_color_manual(values=c("#BF3984","dark grey"), # We want an appropriate legend, so we need to pass the different arguments so R knows what to do. First, we provide the colors we want for our different lines
                     labels = c("#BF3984" = "CV-RMSE","dark grey" = "Min \u03BB"), # After that, we provide labels associated with those colors! (the first one is the cross-validation RMSE, and the second one is the best lambda). Note that because lambda is a symbol, we use the HTML representation of it (you can also just write "lambda")
                     name = "") +
  theme_bw()+ # Black and white theme is always the best and looks clean
  xlab("\u03BB") + ylab("RMSE") # Finally, we label the axis!
 
## Exercise: Use the function `filter` on cv_lambda dataframe to zoom into lambda (e.g. filter lambda<10), and see the more interesting part.

# Check out `bestTune` in the cv object: That will have the lambda that yields the smallest RMSE!
ridge$bestTune$lambda

# Finally, check out the final model:
## Exercise: What do these coefficients represent?
coef(ridge$finalModel, ridge$bestTune$lambda)

# Remember that predictions need to be made on testing data!
pred.ridge <- ridge %>% predict(test.data) #If we need this, this will store our predictions for the ridge model on the testing data.

# Model prediction performance
rmse(ridge, test.data)

# Let's compare it to OLS!

ols <- train(spend ~., data = train.data,
             method = ,### COMPLETE (which method do we use for a regression?),
             trControl = trainControl("cv", number = 10) # values of lambda we are going to test out
)

# Which one is better? (compare RMSE!)

#### Lasso

## Repeat the same steps for Lasso (remember that now `alpha=1`).

lasso <- train(spend ~., data = train.data, 
             method = "glmnet",
             preProcess = "scale",
             trControl = trainControl("cv", number = 10),
             tuneGrid = expand.grid(alpha = 1,
                                    lambda = lambda_seq)
)

# Exercise: Check out the coefficients for lasso (just adapt the code we used for ridge regression). What happened here?


### Another example: Repeat the same exercises as before, but now using the disney dataset we saw last time:

disney <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week9/2_ModelSelection/data/disney.csv")

# 1) Separate your data into a training and a testing dataset
# 2) Using the training dataset, fit a ridge regression, a lasso regression, and a OLS.
# 3) Compare their RMSE. Which one is better?#

# 1)
set.seed(100)

n <- nrow(disney)

train.row <- sample(1:n, 0.8*n) # We generate a random sample for the training data

test.data <- disney[-train.row,] #Select testing data
train.data <- disney[train.row,] #Select training data

# 2) a) Ridge regression

# Try it first with lambda_seq1 and get the plot. Do you think lambda_seq1 is more appropriate or would you use lambda_seq2?
lambda_seq1 <- c(0,10^seq(-3, 3, length = 100)) 
lambda_seq2 <- seq(0,3, by = 0.001) # We can choose a grid of whatever values you want, but *make sure they capture the best lambda*

ridge <- train(logins ~. - id - unsubscribe, data = train.data,
               method = "glmnet",
               preProcess = "scale",
               trControl = trainControl("cv", number = 10),
               tuneGrid = expand.grid(alpha = 0,
                                      lambda = lambda_seq1)
)

lambda <- ridge$results$lambda #We can extract the vector of tested lambdas here
rmse <- ridge$results$RMSE # We can extract the C-V RMSE for each of those lambdas!

## Exercise: What other important things do you see in the object `results`? Explore it!

# I create a new dataframe to be able to plot lambda against RMSE
# Here, I'm just creating a new dataframe with two variables: Lambda and RMSE.
cv_lambda <- data.frame("lambda" = lambda,
                        "rmse" = rmse)

# Plot lambda vs RMSE
ggplot(data = cv_lambda, aes(x = lambda, y = rmse)) + # x axis will be the parameter lambda and y axis will be RMSE
  geom_line(aes(color = "#BF3984"), lwd = 2) + # Let's create a line plot for lambda and RMSE (to see how it behaves)
  geom_vline(aes(xintercept = ridge$bestTune$lambda, color = "dark grey"), lty=2, lwd = 1.5) + # geom_vline adds a vertical line at a specific value of x (xintercept). In this case, we are providing the value for the best lambda in terms of RMSE
  scale_color_manual(values=c("#BF3984","dark grey"), # We want an appropriate legend, so we need to pass the different arguments so R knows what to do. First, we provide the colors we want for our different lines
                     labels = c("#BF3984" = "CV-RMSE","dark grey" = "Min \u03BB"), # After that, we provide labels associated with those colors! (the first one is the cross-validation RMSE, and the second one is the best lambda). Note that because lambda is a symbol, we use the HTML representation of it (you can also just write "lambda")
                     name = "") +
  theme_bw()+ # Black and white theme is always the best and looks clean
  xlab("\u03BB") + ylab("RMSE") # Finally, we label the axis!

