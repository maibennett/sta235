library(ISLR)
data("Carseats")

head(Carseats)


library(rpart)
library(rpart.plot)

set.seed(100)

train.id <- sample(1:nrow(Carseats), 0.8*nrow(Carseats))

carseats.train <- Carseats[train.id,]
carseats.test <- Carseats[-train.id,]

rp <- rpart(Sales ~., data = carseats.train, method = "anova", 
            control = rpart.control(cp = 0.01))

rpart.plot(rp)

rpp <- prune(rp, cp = 0.05)

rpart.plot(rpp)

library(caret)
library(rattle)

mcv <- train(Sales ~., data = carseats.train, method = "rpart",
             trControl = trainControl("cv", number = 10), tuneLength = 50)

plot(mcv)

tuneGrid <- expand.grid(cp = seq(0, 0.01, 0.0001))

mcv <- train(Sales ~., data = carseats.train, method = "rpart", 
             trControl = trainControl("cv", number = 10), tuneGrid = tuneGrid)

plot(mcv)

fancyRpartPlot(mcv$finalModel)


rp.predict <- rp %>% predict(carseats.test)
rpp.predict <- rpp %>% predict(carseats.test)
mcv.predict <- mcv %>% predict(carseats.test)

#Rpart (no pruning)
RMSE(rp.predict, carseats.test$Sales)

#Rpart (pruned)
RMSE(rpp.predict, carseats.test$Sales)

#Cross-validation
RMSE(mcv.predict, carseats.test$Sales)