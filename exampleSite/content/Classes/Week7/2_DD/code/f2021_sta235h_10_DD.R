################################################################################
### Title: "Week 7 - Diff-in-Diff"
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
library(estimatr)
library(modelsummary)
library(vtable)
library(did)

###############################################################################
################ Look what Taylor Swift made me do
###############################################################################

# This is simulated data using real Google trends of popularity for Taylor Swift.

# this shows popularity over time, including the release of one of her albums (on the week of 07/19/2020 for the west coast, and 08/09/2020 for the rest).
swift <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week7/2_DD/data/swift.csv")

# Data shows for each state and week of the year (past 12 months), a popularity index, whether the state belongs to the "west coast" glitch or not, and the week the album was released in each place.
head(swift)

# Let's look at the states
View(swift %>% group_by(state) %>% count())

# Let's create some additional variables:

# The glitch happened in "2020-07-19"
# The album became available for all US states in "2020-08-09"

# Let's focus first on the time period before the album was available everywhere:

swift_sub <- swift %>% filter(dates < as.Date("2020-08-09"))

# Let's create a variable post (1 if it's after the glitch, 0 in another case)

swift_sub <- swift_sub %>% mutate(post = ifelse(dates >= as.Date("2020-07-19"), 1, 0))

# Now, let's run a differences-in-differences model!

lm_dd <- lm(popularity ~ west_coast*post, data = swift_sub)

summary(lm_dd)

# Question: What is the coefficient of interest and how would you interpret it?

# Task: Run a placebo test using a fake date for the glitch (you can use "2020-06-21" for this placebo)
# Filter your dataset for dates before the glitch and run this placebo DD. What would you expect to see?

############################

# Now let's look at the whole data:

# We will be using the `att_gt()` function from the `did` package. It "computes an ATT in DID 
#setups where there are more than two periods of data and allowing from treatment to ocurr at different points in time(...)"

# First, we need a numeric variable that captures the different weeks. For this, we first transform character dates to actual dates (so R recognizes them as such)
# Then we format that into weeks, and the transform that to numeric (it now basically gives you a number)
swift <- swift %>% mutate(week = as.numeric(format(as.Date(dates), format = "%W")))

# We also transform our state variable into numeric:
swift <- swift %>% mutate(state_num = as.numeric(factor(state)))

# Now we need to create another variable that indicates when each state was treated:

# First, create a variable treat that will have the week that state was first treated:
swift <- swift %>% mutate(week.treat = ifelse(west_coast==1, as.numeric(format(as.Date("2020-07-19"), format = "%W")), 0))

# Then, we will transform that same variable treat, but now we are going to assign the weeh of 09/08 to those states 
# not in the west coast, after the album was available for everyone (if not, treat is going to be maintained the same)
swift <- swift %>% mutate(week.treat = ifelse(west_coast==0 & controls==0, as.numeric(format(as.Date("2020-08-09"), format = "%W")), week.treat))

# Now, let's implement the actual function

# - yname: The name of the outcome
# - tname: Name of the time variable (identifies before and after)
# - idname: The individual cross-sectional unit id name.
# - gname: The name of the variable in the data that contains the first period when a particular obs is treated.

dd <- att_gt(yname = "popularity", tname = "week", idname = "state_num",
             gname = "week.treat", data = swift)

# This gives us the ATT for each week in our data for the two different groups we have (first one treated on week 28 and 2nd one treated on week 31)
summary(dd)

# And let's look at this beautiful plot!
ggdid(dd)

# Question: Looking at the previous plot and table. Would you say the parallel trend assumption holds in the pre-intervention data?
