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
library(MatchIt)
library(vtable)

###############################################################################
################ Look what Taylor Swift made me do
###############################################################################

# This is simulated data using real Google trends of popularity for Taylor Swift.

# this shows popularity over time, including the release of one of her albums (on the week of 07/19/2020 for the west coast, and 08/09/2020 for the rest).
swift <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week7/2_DD/data/swift.csv")

# Data shows for each state and week of the year (past 12 months), a popularity index, whether the state belongs to the "west coast" glitch or not, and the week the album was released in each place.
head(swift)

# Let's look at the states
table(swift$state)

# Let's create some additional variables:

swift <- swift %>% mutate(post1 = ifelse(dates >= as.Date("2020-07-19"), 1, 0), #This is when the glitch happen
                          post2 = ifelse(dates >= as.Date("2020-08-09"), 1, 0)) #The the album became available for almost everyone

# Let's assume that "treatment" is having the album available. Then,

swift <- swift %>% mutate(treat = ifelse(west_coast==1 & post1==1, 1,
                                         ifelse(west_coast==0 & post2==1 & controls == 0, 1, 0)),# Look closely at this condition! What is does is: 1) If the state is in the west coast and it's after 07/19, treat = 1, then if west_coast = 0 and it's after 08/09, treat = 1. It will be 0 in all other cases. 
                          period = factor(ifelse(post1==0 & post2==0, 0, ifelse(post1==1 & post2==0, 1, 2))), #Time 0 is before the album was available to anyone, time 1 is after it was available for the 1st group but not the 2nd, time 2 is when it's available for everyone.
                          group = factor(ifelse(controls==1,0,ifelse(west_coast==1,1,2))), # Group 0 is the ones that never receive it, group 1 is the ones that receive it early, group 2 the ones that receive it late.
                          date_num = as.numeric(as.Date(dates))) 

# Let's plot the data!

swift %>% dplyr::select(group, dates, popularity) %>% 
  group_by(group, dates) %>% summarise_all(mean) %>% # We first group our data (an summarize it) by date and whether the state was part of the glitch or not
  ggplot(data = ., aes(x = as.Date(dates), y = popularity, color = factor(group), group = factor(group))) + # Then we plot the data
  geom_line(lwd = 1.3) +
  
  scale_color_manual(values = c("#FCCE25","#900DA4","#F89441"), name = "Group", label = c("0" = "Weird", "1" = "West Coast", "2" = "Non west coast") ) + # We include personalized colors (to not use the default ones)
  
  geom_vline(aes(xintercept=as.Date("2020-07-19")), lty = 2, lwd=1.1, color = "#5601A4") + #Release of the album in the west coast
  geom_vline(aes(xintercept=as.Date("2020-08-09")), lty = 2, lwd=1.1, color = "#E16462") + #Release of the album everywhere else
  
  labs(x = "Date", y = "Popularity Index", title = "Taylor Swift's popularity in the past 12 months")+
  theme_bw()+
  theme(plot.title = element_text(size=16))+
  scale_x_date(date_labels = "%m-%Y", date_breaks = "2 month")



# Let's look at two states, like CA and PA: (uncomment to run)

#swift %>% filter(state == "California") # Variable treat looks food
#swift %>% filter(state == "Pennsylvania") # Variable treat looks food

## What if we just ran the TWFE model?

summary(lm(popularity ~ factor(group) + factor(period) + treat, data = swift))

###############################

## Ok, let's do the Goodman-Bacon Decomposition:
df_bacon <- bacon(popularity ~ treat, data = swift, id_var = "state", time_var = "date_num") # Make sure the time_var is numeric

df_bacon # Question: Can you interpret these effects looking at the popularity plot?

coef_bacon <- sum(df_bacon$estimate * df_bacon$weight)
print(paste("Weighted sum of decomposition =", round(coef_bacon, 4))) #It's the same as the TWFE model!