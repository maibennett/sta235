######################
## In-class exercise #
######################

# Data from entrance and exit exams for students

tutoring <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week8/2_IV/data/tutoring.csv")

# Check out the data
head(tutoring)

# id: identification for each student
# entrance_exam: score for each student for their entrance exam, before going into college.
# tutoring: whether the student received tutoring or not during the year.
# tutoring_text: character variable for "tutoring".
# exit_exam: score for each student for their exit exam, at the end of their first year.

# Context: If you remember, originally students below a score of 70 in their entrance exam where assigned tutors. However, other variables
# could also come into play, and other students also became eligible for tutoring (and other didn't take up the tutor offer).

# Task 1) Use rdplot() to create a plot with the treatment variable in the y-axis and the running variable in the x-axis.
# Questions to answer: 
# i) What is the take-up for the treatment for students below the cutoff? What about for students above the cutoff?
# Answer: [write your answer here]

library(rdrobust)
#[Write your code here]

# Task 2) Use summary(rdrobust()) to estimate a causal effect

# Questions to answer: 
# i) What is the estimand you are capturing in your model?
# Answer: [write your answer here]

#[Write your code here]