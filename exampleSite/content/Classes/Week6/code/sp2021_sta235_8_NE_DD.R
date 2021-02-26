##############################################################
### Title: "Week 6 - Natural Experiments and Diff-in-Diff"
### Course: STA 235
### Semester: Spring 2021
### Professor: Magdalena Bennett
##############################################################

# Clears memory
rm(list = ls())
# Clears console
cat("\014")

### Load libraries
# If you don't have one of these packages installed already, you will need to run install.packages() line
library(tidyverse)
library(ggplot2)
library(generics)
library(estimatr)
library(designmatch)
library(MatchIt)
library(broom)
library(vtable) #Useful package to visualize data
library(cobalt)
library(bacondecomp)

#####################################################################

################ Oregon Insurance Plan example

d <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week6/data/oregonhie_simplified.csv") #Load the data (almost 75k obs)

# This is data from the Oregon Health Insurance Experiment (publicly available at NBER)
# These are two datasets combined: Variables that end in *_list are from the individuals that applied to the lottery. Variables ending in *_12m are from a survey sent out to a subsample 12 months later.
# You can read more documentation about the variables and the data here: https://github.com/maibennett/sta235/tree/main/exampleSite/content/Classes/Week6/data/OHIE_docs

#First, always inspect the data:

table(d$treatment)

table(d$treatment, d$applied_app)

vtable(d) #This is also good to look at all your data

#Note that variables ending in _list come from one dataset and variables ending in _1m come from another dataset (12 month survey)

## Let's look at the balance

d_covs <- d %>% dplyr::select(birthyear_list, have_phone_list, english_list, female_list, week_list, zip_msa_list, pobox_list)

meantab(d_covs, d$treatment, which(d$treatment==1), which(d$treatment==0))

# Question: Statistically significant differences. What can we do?


#### Let's look at a subsample (the ones that were surveyed 12months later)

d_12m <- d %>% dplyr::filter(sample_12m==1)

d_12m_covs <- d_12m %>% dplyr::select(birthyear_list, have_phone_list, english_list, female_list, week_list, zip_msa_list, pobox_list)

meantab(d_12m_covs, d_12m$treatment, which(d_12m$treatment==1), which(d_12m$treatment==0))



#### What about survey responses?

table(d_12m$treatment,d_12m$returned_12m) #Look at responses by treatment status

#That was not very clear.. let's use the tidyverse!

d_12m %>% group_by(treatment) %>% summarise(mean_response = mean(returned_12m, na.rm = TRUE))

summary(estimatr::lm_robust(returned_12m ~ treatment, data = d_12m)) #The difference in non-response is significant.

# Question: What is this nonresponse called? (as we saw in the context of RCTs)



#### Let's use weights to approximate response:

m1 <- glm(returned_12m ~ birthyear_list + have_phone_list + english_list + female_list + week_list + zip_msa_list + pobox_list,
          data = d_12m, family = binomial(link = "logit")) # Fit a response model

#Notice that we need to use the "newdata" because we can't estimate all probabilities (there's one observation where we can't predict a probability)
d_12m_aug <- broom::augment(m1, newdata = d_12m, type.predict = "response")

# Create the weights: We want the responders to look more like the whole sample. Which weight should we use?
d_12m_aug <- d_12m_aug %>% mutate(weights = returned_12m/prob_response + (1-returned_12m)/(1-prob_response))



#### Let's analyze some results! (Question: What are the assumptions we need to rely on for weights to be enough to yield a causal treatment effect?)

# Have any insurance:
summary(estimatr::lm_robust(ins_any_12m ~ treatment, data = d_12m_aug, weights = weights))

# Got all needed medical care in the last 6 months (or didn't need any)
summary(estimatr::lm_robust(needmet_med_cor_12m ~ treatment, data = d_12m_aug, weights = weights))

# Current smoker
summary(estimatr::lm_robust(smk_curr_12m ~ treatment, data = d_12m_aug, weights = weights))




#####################################################################

################ Look what Taylor Swift made me do

# Create simulated data from Google Trends
d1 <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week6/data/taylorswift.csv")
d2 <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week6/data/taylorswift_time.csv")

d1 <- d1 %>% mutate(Category..All.categories = as.numeric(Category..All.categories)) %>%
  filter(!is.na(Category..All.categories))

d2 <- d2 %>% mutate(Category..All.categories = as.numeric(Category..All.categories)) %>%
  filter(!is.na(Category..All.categories))

states <- sort(rownames(d1)[-1])

for(s in 1:length(states)){
  
  set.seed(s)
  
  state <- states[s]
  m_state <- d1[rownames(d1)==state,1]/100*d2$Category..All.categories
  
  S_matrix <- diag(10, nrow = 52, ncol = 52) 
  
  pop_s <- mvrnorm(n=1,m_state,S_matrix)
  
  if(s==1){
    dates <- rownames(d2)
    
    swift <- data.frame("state" = state,
                        "dates" = dates,
                        "popularity" = pop_s)
    
  }
  
  if(s>1){
    
    dates <- rownames(d2)
    
    swift <- swift %>% add_row(data.frame("state" = state,
                                          "dates" = dates,
                                          "popularity" = pop_s))
    
  }
  
  
}


# July 19 there's a new release
west_coast <- c("California","Oregon","Washington","Nevada")

swift$west_coast <- as.numeric(swift$state %in% west_coast)

swift$new_album <- 0
swift$new_album[swift$dates=="2020-07-19" & swift$west_coast==1] <- 1
swift$new_album[swift$dates=="2020-07-26" & swift$west_coast==0] <- 1


swift %>% group_by(dates, west_coast) %>% summarize(mean_pop = mean(pop_s)) %>% 
  ggplot(data = ., aes(x = as.factor(dates), y = pop_s, color = west_coast)) +
  geom_line()