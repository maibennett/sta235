---
title: Homework 6
weight: 25
chapter: false
---


## Objective

- Carry out a full prediction project by applying what we have learned about prediction in this class.

	- Note: You can only use methods/packages that we have covered in this course.

## How this works

- You will choose a dataset out of the three (3) available ones, and compete with other students that have chosen the same one.

- For each dataset, you will have to predict 2 outcomes: one continuous outcome and one binary outcome. You will use two (2) methods for each, and state which of the two is your preferred one.

- Using each preferred method, the instruction team will run your code on a testing dataset with the same structure as the data provided and obtain the appropriate measures for accuracy.

- For each outcome, we will rank the performance of the model for each student, and average their ranking. This will determine their score in the "performance" aspect (see evaluation below).

## What you need to submit

- A 2-page report (without counting images/tables) about your project with the following sections:

	1) **Data description:** Brief description of the data (e.g. what is the data about, main variables you have, how many observations and variables; if you cleaned/changed the data: how did you do it and how did it change from the original dataset?). Give the reader an idea of the data that you started with, and if you cleaned it, the data that you ended up with, so we know what you are working with.
	2) **Task 1 - Continuous outcome:** Describe the two models you chose. Include a <u>brief</u> explanation of what each model does, and the main parameters you used for training the model (if you iterated through these, no need to describe the process, just the final parameters chosen). Show the appropriate results (e.g. tuning parameters, plots, measures of accuracy, etc.). <u>Be clear about which of the two is your preferred model</u>.
	3) **Task 2 - Binary outcome:** Describe the two models you chose. Include a <u>brief</u> explanation of what each model does (if you didn't describe it in the previous section), and the main parameters you used for training the model (if you iterated through these, no need to describe the process, just the final parameters chosen). Show the appropriate results (e.g. tuning parameters, plots, measures of accuracy, etc.). <u>Be clear about which of the two is your preferred model</u>.

- The report needs to have a title (you can keep it classic or be creative) and clearly indicate the different sections/subsections. All tables and plots need to be placed at the end of the document (they don't count towards the 2-page limit), and have appropriate descriptive captions (numbered so you can reference them in the text).

- Use standard margins and a font size of at least 11pt.

- You will also need to submit an R script with the code and an RData file with your model.

	- Make sure that your code runs. If it doesn't, you will be assigned the last place in the ranking.

## Evaluation

- Homework assignments will be graded according to the following items:

	- **Style**: The report follows the styling guidelines (keep it professional -- e.g. don't include screenshots of code, make sure anything you present is readable, include appropriate captions and references for tables/plots, etc.).
	- **Clarity**: Descriptions and explanations are clear and accurate.
	- **Model training**: Training parameters are appropriate for the task at hand.
	- **Results**: Presentation of results.
	- **Model evaluation**: Selection of the best performing model.
	- **Code**: Whether the code is correct or not for the task.
	- **Model performance**: Average ranking of the performance.

- <u>Without considering performance</u>, the maximum grade is 94 points. The last 6 points will be awarded based on performance, where the student with the best performing models (on average) will receive 6 points, and the student with the lowest performance model (or a code that doesn't allow estimating the performance) will receive 0 points. We will use average rankings for students that achieve the same performance.

## Datasets available

- **NBA performance**: In this dataset, you will have information about players characteristics and performance between the 2020-2021 and 2022-2023 NBA season. You will have to predict salaries, and who is the top 25% of best-paid players. The data has approximately 1,600 observations and 74 variables.

- **Student dropout**: This dataset contains information about several students characteristics, including some demographic and socioeconomic variables, as well as their performance in college. Using these characteristics, you will have to predict a student's score and also their probability of dropping out. The dataset has approximately 2,500 observations and 34 variables.

- **Housing prices**: This is a real dataset (slightly cleaned) from the Home Mortgage Disclosure Act for housing purchasing loans throughout the US in 2017. It contains information about the individual's application, and you will have to predict whether the person gets approved or not, and the amount of the loan. The data has approximately 2,800 observations and 34 variables.

{{% notice info %}}
Make your selection of dataset on Canvas by Thursday 11/16 (check announcement)
{{% /notice %}} 



