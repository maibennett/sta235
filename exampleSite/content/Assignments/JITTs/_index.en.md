---
title: JITTs
weight: 10
chapter: false
---

Weekly assignments submitted via **Canvas**

### JITT 1

- On average, the price of a car made in 1970, with 0 mileage, and a rating of 0 is $44,000.

### JITT 2

- On average, a 1-inch increase in height is associated with a 1.4% increase in salary, holding education and experience constant.

### JITT 3

- On average, a one-year increase in age in women with two or more children is associated with a 1.3 percentage point increase in the probability of being employed, holding whether they have two or more kids and race constant.


### JITT 4

- The average change in GPA of increasing study hours from 10 to 11 hours is $\beta_{stud} + 2\times\beta_{stud^2}\times10 = 0.126$, holding other variables in the model constant.

### JITT 5

- See alternatives and feedback on Canvas

### JITT 6

- See alternatives and feedback on Canvas

### JITT 7

- The `treat` coefficient is capturing the differences between treated and control states **before** the policy was set in place. The interpretation of the coefficient would be as follows: "On average, NY and CA had an average subscription rate that was 5.4 percentage points higher than other states prior to the implementation of the policy / in April 2022." Or, you could also say: "On average, a person in NY and CA has a probability of subscription that is 5.4 percentage points higher than a person in another state, before the implementation of the policy / in April 2022"

### JITT 8

- "On average, for individuals with exactly 21 years of age, being legally able to drink increases the total number of arrests by 409.1, compared to not being legally able to drink." See slides in Week 10 for a more detailed response.

### JITT 9

- See alternatives and feedback on Canvas

### JITT 10

- See alternatives and feedback on Canvas

### JITT 11

    set.seed(100)
    
    ct = train(factor(unsubscribe) ~ . - id, data = train.data,
               method = "rpart", 
               tuneGrid = expand.grid(cp = seq(0,0.015, length = 50)),
               trControl = trainControl(method = "cv", number = 10))
    
    ct$bestTune
    
    pred.values = ct %>% predict(test.data)
    mean(pred.values == test.data$unsubscribe)

  `ct` = 0.007 and accuracy is 63.9%


### JITT 12

Change `tuneGrid` according to specifications:

    tuneGrid = expand.grid(
       mtry = 3:11,
       splitrule = "variance",
       min.node.size = 1
    )

Run RF:

    rfcv = train(Sales ~ ., data = carseats.train,
                 method = "ranger",
                 trControl = trainControl("cv", number = 10),
                 importance = "permutation",
                 tuneGrid = tuneGrid)

Get best tuning parameter (10 in Windows):

    rfcv$bestTune

Get appropriate measure of performance (RMSE = 1.48):

    rmse(rfcv, carseats.test)