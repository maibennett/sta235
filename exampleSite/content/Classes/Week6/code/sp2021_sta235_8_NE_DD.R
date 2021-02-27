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
library(bacondecomp) # for goodman-bacon decomposition

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
d_12m_aug <- d_12m_aug %>% mutate(weights = returned_12m/.fitted + (1-returned_12m)/(1-.fitted))



#### Let's analyze some results! (Question: What are the assumptions we need to rely on for weights to be enough to yield a causal treatment effect?)

# Have any insurance:
summary(estimatr::lm_robust(ins_any_12m ~ treatment, data = d_12m_aug, weights = weights))

# Got all needed medical care in the last 6 months (or didn't need any)
summary(estimatr::lm_robust(needmet_med_cor_12m ~ treatment, data = d_12m_aug, weights = weights))

# Current smoker
summary(estimatr::lm_robust(smk_curr_12m ~ treatment, data = d_12m_aug, weights = weights))




#####################################################################

############## Candles reviews before and after COVID 

# Source: Data from Kate Petrova (https://github.com/kateptrv/Candles)

# We are going to be looking at a random sample of reviews for the top 3(5) scented and unscented candles before and after COVID, to see how the pandemic affected this product.
scented <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week6/data/Scented_all.csv")
unscented <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week6/data/Unscented_all.csv")

# Scented candles
s <- scented %>%
  mutate(Date = as.Date(Date, format = "%d-%b-%y")) %>% # We transform this character variable into date (look at the as.Date() function. You need to be careful with this and give it the right format your date is in)
  arrange(Date) %>% # We order the dataset by date
  filter(Date >= "2017-01-01") %>% # We just keep data from 2017 to 2020
  filter(CandleID <= 3) %>% # Let's keep only the top 3
  group_by(Date) %>% # Group all this by date and get the mean rating by date
  summarise(Rating=mean(Rating))

# Unscented candles
us <- unscented %>%
  mutate(Date = as.Date(Date, format = "%d-%b-%y")) %>%
  arrange(Date) %>%
  filter(Date >= "2017-01-01") %>%
  group_by(Date) %>%
  summarise(Rating = mean(Rating))


# Let's look at the data
ggplot(s, aes(x = Date, y = Rating)) + # We first use the scented dataset.
  geom_vline(xintercept = as.numeric(as.Date("2020-01-20")), colour = "#E16462", lty = 2, lwd = 1.3)+ # We include a vertical line to mark the first COVID case in the US (line is dashed, and instead of 2 you can use "dashed"; I also increase the width of the line (lwd))
  geom_smooth(method = "loess", size = 1.5, colour = "#900DA4", fill = "#900DA4") + # We will generate a smooth function to see how our data behaves (loess is a local polynomial regression fit for our data)
  geom_point(alpha = 0.2, colour = "#900DA4")+
  # Now, we include uscented candles
  geom_smooth(data = us, aes(x = (as.Date(Date, format = "%d-%b-%y")), y = Rating), method = "loess", size = 1.5, colour = "#F89441", fill = "#F89441") +
  geom_point(data = us, aes(x = (as.Date(Date, format = "%d-%b-%y")), y = Rating), alpha = 0.2, colour = "#F89441")+
  
  labs(x = "Date", y = "Average daily rating (1-5)", title = "Top 3 scented and unscented candles Amazon reviews 2017-2020")+
  theme_bw()+
  theme(plot.title = element_text(size=16))+
  scale_x_date(date_labels = "%m-%Y", date_breaks = "6 month")

#Question: Do you think pre-trends look parallel? Generate the same plot but only for 2018-2020

#### What if we only look at the pre-intervention period?

ggplot(s, aes(x = Date, y = Rating)) + # We first use the scented dataset.
  geom_vline(xintercept = as.numeric(as.Date("2020-01-20")), colour = "#E16462", lty = 2, lwd = 1.3)+ # We include a vertical line to mark the first COVID case in the US (line is dashed, and instead of 2 you can use "dashed"; I also increase the width of the line (lwd))
  
  geom_smooth(data = s[s$Date<as.numeric(as.Date("2020-01-20")),], aes(x = Date, y = Rating), method = "loess", size = 1.5, colour = "#900DA4", fill = "#900DA4") + # We will generate a smooth function for the pre-pandemic era
  geom_point(alpha = 0.2, colour = "#900DA4")+
  
  # Now, we include uscented candles
  geom_smooth(data = us[us$Date<as.numeric(as.Date("2020-01-20")),], aes(x = (as.Date(Date, format = "%d-%b-%y")), y = Rating), method = "loess", size = 1.5, colour = "#F89441", fill = "#F89441") +
  geom_point(data = us, aes(x = (as.Date(Date, format = "%d-%b-%y")), y = Rating), alpha = 0.2, colour = "#F89441")+
  
  labs(x = "Date", y = "Average daily rating (1-5)", title = "Top 3 scented and unscented candles Amazon reviews 2017-2020")+
  theme_bw()+
  theme(plot.title = element_text(size=16))+
  scale_x_date(date_labels = "%m-%Y", date_breaks = "6 month")
####################

# Let's only use data for 2018 to 2020:

# Scented candles
s1820 <- scented %>%
  mutate(Date = as.Date(Date, format = "%d-%b-%y")) %>%
  arrange(Date) %>% 
  filter(Date >= "2018-01-01") %>% # Now we just keep data for 2018 to 2020
  filter(CandleID <= 3) %>%
  group_by(Date) %>% 
  summarise(Rating=mean(Rating))

# Unscented candles
us1820 <- unscented %>%
  mutate(Date = as.Date(Date, format = "%d-%b-%y")) %>%
  arrange(Date) %>%
  filter(Date >= "2018-01-01") %>%
  group_by(Date) %>%
  summarise(Rating = mean(Rating))

# Generate one dataframe with both datasets
candles <- s1820 %>% mutate(scented = 1) %>% #generate a "scented" variable to identify those reviews
  add_row(us1820) %>% #Append unscented dataset
  mutate(scented = replace(scented, is.na(scented), 0)) # Replace the missing values of the scented variable to 0 (because they are unscented)


## Let's run a diff-in-diff

#Create the dimension variables:

candles <- candles %>% mutate(post = 0, #Generaate a post variable = 0
                              post = replace(post, Date >= "2020-01-20", 1), #Since the first case of a COVID case in the US, change post to 1
                              treat = scented) # Treatment in this case will be whether the candle is scented or not.

# Let's fit the model:

summary(lm(Rating ~ treat + post + treat*post, data = candles))

# Question: Interpret each of the coefficients. Under the DD assumptions, what is the treatment effect?

##################
# Let's run a placebo test

candles <- candles %>% mutate(post_fake = 0, #I will assume a fake placebo date: 01/20/2019
                              post_fake = replace(post, Date >= "2019-01-20", 1))

# And now let's run the same model:

summary(lm(Rating ~ treat + post_fake + treat*post_fake, data = candles))

# Question: What can you say after seeing these results?


####################################
## Let's explore why could this be

#### NO SCENT FUNCTION #### --> A quick function that detects whether a review says anything about lack of scent 
no_scent <- function(x){
  case_when(
    str_detect(x, "[Nn]o scent") ~ "1", 
    str_detect(x, "[Nn]o smell") ~ "1",
    str_detect(x, "[Dd]oes not smell like") ~ "1",
    str_detect(x, "[Dd]oesn't smell like") ~ "1",
    str_detect(x, "[Cc]an't smell") ~ "1",
    str_detect(x, "[Cc]annot smell") ~ "1",
    str_detect(x, "[Ff]aint smell") ~ "1",
    str_detect(x, "[Ff]aint scent") ~ "1",
    str_detect(x, "[Dd]on't smell") ~ "1",
    str_detect(x, "[Ll]ike nothing") ~ "1",
    TRUE ~ x
  )
  
}

# Scented candles
s1920 <- scented %>%
  mutate(Date = as.Date(Date, format = "%d-%b-%y")) %>%
  arrange(Date) %>% 
  filter(Date >= "2019-01-01") %>% # Now we just keep data for 2019 to 2020
  filter(CandleID <= 3) %>%
  mutate(noscent = no_scent(Review)) %>% # Apply the no scent function we created before
  mutate(noscent = ifelse(noscent != 1, 0, 1)) %>%# Generate a dummy variable whether no_scent = TRUE
  mutate(month_year = reorder(format(Date, '%B-%Y'), Date)) %>% # I just want to keep data at the month level, so create a new variable
  group_by(month_year) %>%
  add_tally() %>%
  summarise(n =n, noscent = sum(noscent)) %>%
  mutate(nsprop = noscent/n) %>%
  mutate(se = sqrt((nsprop*(1-nsprop))/n)) %>%
  summarise(n=mean(n), se=mean(se), nsprop=mean(nsprop)) 


ggplot(s1920, aes(x=factor(month_year), y = nsprop, group = month_year))+
  geom_bar(stat = "identity", fill = alpha("#BF3984",0.5), col = "#BF3984", lwd=1.5)+
  geom_errorbar(aes(ymin = (nsprop-se), ymax = (nsprop+se)), width=0.2, colour = "gray30")+
  
  geom_vline(aes(xintercept = "January-2020"), color = "#5601A4", lty = 2, lwd = 1.3) + 
  
  labs(x = "Month", y = "Proportion of reviews", title = "Top 5 scented candles on Amazon: \nProportion of reviews mentioning lack of scent by month 2020")+
  theme_bw()+
  theme(plot.title = element_text(size=16),
        axis.text.x = element_text(size = 14, angle = 45)) + #Puts the x-labels in a 45 degree angle
  theme(panel.grid.major.x = element_blank(), # All this basically eliminate the gridlines and the border
        panel.grid.minor.x = element_blank(),
        panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank(),
        panel.border = element_blank(),
        axis.line = element_line(colour = "dark grey"))

# Question: Interpret the plot. Make sure to look at the seasonality in the reviews for 2019!


####################################################################################
################ Look what Taylor Swift made me do

# This is simulated data using real Google trends of popularity for Taylor Swift.

# this shows popularity over time, including the release of one of her albums (on the week of 07/19/2020 for the west coast, and 08/09/2020 for the rest).
swift <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week6/data/swift.csv")

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