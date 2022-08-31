
library(tidyverse)

set.seed(100)

data  = data.frame(gender = c(rep("F",5), rep("M",3)),
                   age = round(runif(8,18,60)),
                   income = round(runif(8,25000,150000)),
                   married = sample(c(0,1), 8, replace = TRUE, prob = c(0.65,0.35)))

# Create a dataset with only married females:
data_mf = data %>% filter(married == 1 & gender == "F")

# Married people with income > 40,000
data_m40 = data %>% filter(married == 1 & income>40000)

# Generate an indicator variable that captures people with income over 100,000 and under:

ifelse(data$income > 100000, 1, 0)

data = data %>% mutate(income100 = ifelse(income > 100000, 1, 0))

data

data = data %>% mutate(income100 = income > 100000)

data 

data = data %>% mutate(income100 = as.numeric(income > 100000))

data
