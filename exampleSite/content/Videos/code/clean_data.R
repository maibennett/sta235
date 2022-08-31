
library(tidyverse)

set.seed(100)

data  = data.frame(gender = c(rep("F",5), rep("M",3)),
                   age = round(runif(8,18,60)),
                   income = round(runif(8,25000,150000)),
                   married = sample(c(0,1), 8, replace = TRUE, prob = c(0.65,0.35)))

# Create a dataset with only married females:

# Generate an indicator variable that captures people with income over 100,000 and under: