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
	- **Data wrangling**: Data wrangling/cleaning is appropriate for the task.
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


## Submission structure

For this assignment, you will have to submit three different files:

1) **Written report**: This is the 2-page PDF file (without counting images and tables) that you need to submit. See instruction above for sections, stlyling, etc. You should name your report as following "EID_LastnameFirstLetter_report.pdf" (e.g. mc72574_BennettM_report.pdf). 

2) **R Script**: This is a full, clean script that should replicate your results. It should have a section for the regression task and for the classification task, and both should be clearly delimited. Same thing for the different methods you use within each task. Follow the structure of the [following template](https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Assignments/Homework/Homework6/template/mc72574_BennettM_script.R) to make sure you are submitting an appropriate file. You should name your script as following "EID_LastnameFirstletter_script.R" (e.g. mc72574_BennettM_script.R). 

	- Remember that this script should run without glitches! Comment out **anything** that is not code, and make sure you don't include unecessary things (e.g. packages you are not using, code lines like `install.packages()`, etc.). These things will be evaluated as well.

3) **Final Models (RData)**: To facilitate replication, you will also have to submit an **RData file with your two preferred models**. Do not submit anything else in this file. You should name your file as following "EID_LastnameFirstLetter_models.RData" (e.g. mc72574_BennettM_models.RData). Follow the instructions in [the homework template](https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Assignments/Homework/Homework6/template/mc72574_BennettM_script.R) to make sure you are submitting everything correctly. **Make sure that your regression task model is named "reg.model" and your classification task model is named "class.model"** to make evaluation easier.


## Some tips

- You will most likely need to do some data cleaning before fitting any models. Make sure you do this to your entire dataset before you do anything else (see the previous template to guide you in the structure of your script). Pay special attention to the different variables you might encounter (e.g. Are they categorical? Should I transform them? Are there variables that are not predictors?). 

- Depending on your dataset, it might make sense to aggregate some categories in categorical variables or mutate certain variables to be able to use the information they provide. Remember that <u>you need to have the same categories in your training and testing dataset</u>, so if you have too many categories (or one category with too few observations), you might run into issues.

- You will also run into missing values. How you handle these is up to you. Some common alternatives are (1) drop observations with missing values (caveat: depending on missingness, this might be a bad idea if you are losing a lot of data), (2) not use variables with a lot of missing values (caveat: again, depending on the level of missing values, you might be losing important information), (3) impute average values to missing observations (caveat: you are introducing some noise in the variable). As a note, imputation should only be done for predictors, and not outcome variables. 

- You can wrangle your data in an easy way, dropping a lot of data and variables, or spend a little more time in this part to be sure to preserve more information. This will have an impact on the accuracy of your prediction (remember that, usually, more info is better than less!). The decision is yours &#128512;


## Rubric

<table border="1">
<thead>
<tr><th>Category</th><th>Total Points</th><th>Item</th></tr>
</thead>
<tbody>
<tr><td>Style</td><td>10.0</td><td>Right length and font size, titles, etc.</td></tr>
<tr><td>Images and tables (e.g. readable, axis labels, appropriate captions, no screenshots)</td></tr>
<tr><td>Right naming structure</td></tr>
<tr><td rowspan="3">Style</td><td>Clarity</td><td rowspan="3">10.0</td><td>23.0</td><td>Data description</td></tr>
<tr><td>Data wrangling explanation (only clarity; whether is right or not is evaluated in the the next section)</td></tr>
<tr><td>Models' Explanation: Regression (precise/no incorrect info)</td></tr>
<tr><td>Models' Explanation: Classification (precise/no incorrect info)</td></tr>
<tr><td rowspan="4">Clarity</td><td>Data wrangling</td><td rowspan="4">23.0</td><td>10.0</td><td>Manage missing values/categorical variables</td></tr>
<tr><td>Model training</td><td>32.0</td><td>Models are appropriate for the task (Regression) - conceptual and code</td></tr>
<tr><td>Models are appropriate for the task (Classification) - conceptual and code</td></tr>
<tr><td>Tuning parameters are appropriate (Regression)</td></tr>
<tr><td>Tuning parameters are appropriate (Classification)</td></tr>
<tr><td rowspan="4">Model training</td><td>Results</td><td rowspan="4">32.0</td><td>10.0</td><td>Presentation of results (appropriate performance measures, tuning grid and opt parameters): Regression</td></tr>
<tr><td>Presentation of results (appropriate performance measures, tuning grid and opt parameters): Classification</td></tr>
<tr><td rowspan="2">Results</td><td>Model evaluation</td><td rowspan="2">10.0</td><td>4.0</td><td>Chooses the right model (Regression)</td></tr>
<tr><td>Chooses the right model (Classification)</td></tr>
<tr><td rowspan="2">Model evaluation</td><td>Code</td><td rowspan="2">4.0</td><td>15.0</td><td>Code runs with no issues</td></tr>
<tr><td>Code runs with no issues on testing data</td></tr>
<tr><td rowspan="2">Code</td><td>Model performance</td><td rowspan="2">15.0</td><td>6.0</td><td>Average ranking </td></tr>
<tr><td>TOTAL</td><td>100.0</td><td></td></tr>
</tbody>
</table>



