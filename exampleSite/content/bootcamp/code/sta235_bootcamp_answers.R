##############################################################
### Title: Bootcamp example code
### Author: Magdalena Bennett
### Date Created: 08/23/2023
### Last edit: [08/23/2023] - Created code
##############################################################

#Clear memory
rm(list = ls())

#Clear the console
cat("\014")

#Turn off scientific notation (turn back on with 0)
options(scipen = 999)

# Load packages
library(tidyverse) #includes dplyr and ggplot2!

# If there is a package you don't have installed, you can use install.packages("tidyverse")
# Only run once! (no need to install packages every time you run your code)

# Load data (this is loading data directly from Github)
sales = read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/bootcamp/data/US_Regional_Sales_Data.csv")



## Inspecting your data

# Exercise 1: Let's explore the data. How many variables and observations do we have? What type of variables do we have?

## We can see in the environment pane that we have 7991 obs and 16 variables. Most of them are character variables (chr), but some are numeric (int and num).

# Exercise 2: Install the package vtable, load it, and run the code vtable(sales). What do you get? Use the ?vtable to see the options for this function.

#install.packages(vtable)
library(vtable)

?vtable

vtable(sales)



## Data wrangling

# Exercise 1: Unit cost and unit price should be numeric. Let's change this! (hint: you can use the function as.numeric() to transform a variable!).
## Keep the same names for the variables and the dataset.

sales = sales %>% mutate(unit_cost = as.numeric(unit_cost),
                         unit_price = as.numeric(unit_price))

# Exercise 2: What are the different values for the sales channel in this dataset? Use the function table() to see!
## Create a new dataset for in-store and online sales. Call it "sales_min". How many variables do we have?

sales %>% select(sales_channel) %>% table()

sales_min = sales %>% filter(sales_channel == "In-Store" | sales_channel == "Online")

# Exercise 3: Use the original dataset "sales", and create a new variable called "minority", 
## which takes the value of 1 if the sales channel is in-store or online, and 0 in another case.

sales = sales %>% mutate(minority = ifelse(sales_channel == "In-Store" | sales_channel == "Online", 1, 0))

# Exercise 4: What is the average price for sales made through a minority channel vs a non-minority channel?

sales %>% group_by(minority) %>% summarize(unit_price = mean(unit_price))



## Plotting data!

# Exercise 1: Create a scatter plot between unit cost (x axis) and unit price (y axis)

ggplot(data = sales, aes(x = unit_cost, y = unit_price)) + geom_point()

# Exercise 2: Now, let's make that plot pretty. Use theme_minimal() to get rid of the grey background. Color the points with the color "deepskyblue3",
## and change the axis titles to something more informative (e.g. Unit price ($)). This can be done with xlab() and ylab().

ggplot(data = sales, aes(x = unit_cost, y = unit_price)) + geom_point(color = "deepskyblue3") + theme_minimal() +
  xlab("Unit Cost ($)") + ylab("Unit Price ($)")

# Exercise 3: Using the same code as before, now we want to color observations from the minority sales channel in one color, and the non-minority in another color.
## Write some code that does that (e.g. you will need to change your aesthetics!)

ggplot(data = sales, aes(x = unit_cost, y = unit_price, color = factor(minority))) + geom_point() + theme_minimal() +
  xlab("Unit Cost ($)") + ylab("Unit Price ($)")

# Exercise 4: Finally, using the same code as in exercise 2, include a regression line in this plot using geom_smooth().

ggplot(data = sales, aes(x = unit_cost, y = unit_price)) + geom_point(color = "deepskyblue3") + theme_minimal() +
  xlab("Unit Cost ($)") + ylab("Unit Price ($)") + geom_smooth(method = "lm")



## Regressions

# Let's load a new dataset: The Gapminder

gapminder = read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/bootcamp/data/gapminder.csv")

# Exercise 1: What type of data do we have?

## You can see there is numeric data, but also factor (also referred to as categorical variables). 
## Factors are useful because they enter a regression as individual dummies
