---
title: Prediction Project
weight: 25
chapter: false
---

# Objective

The objective of this project is for you to **tackle a prediction task (or two) using real world data**. This will mean that you will need to download data, filter it, clean it, and analyze it. 

In this case, we will be using **[HMDA data](https://ffiec.cfpb.gov/data-browser/)** for Travis County to predict (1) whether someone gets a loan denied or not and (2) the loan amount. You will need to filter and download a dataset, potentially select variables you want, and build prediction models that are as accurate as possible.

Any prediction method is game. You can use what we have seen in class or include other methods that you might find. Be sure though that you can explain what is happening and the decision that you make along the way.

# Evaluation

Your models will be tested on a hold-out dataset that only the instruction team will have access to (that way is truly <u>unseen data</u>)... **and this will be a competition!** Groups that perform better in terms of prediction (for both the regression and classification task) will receive a higher grade than those that have worse predictive models in their "accuracy" item. Projects will be evaluated as following:

- **Data manipulation (15 points)**: Downloaded data is appropriate and cleaned in a way that allows to run prediction models.

- **Classification task (40 points)**: The team runs an appropriate (and preferred) prediction model and contrasts their results with one additional method. The group explains their results and provides support (e.g. plots and/or tables) for their findings. They show appropriate measures of accuracy for the model.

- **Regression task (40 points)**: The team runs an appropriate (and preferred) prediction model and contrasts their results with one additional method. The group explains their results and provides support (e.g. plots and/or tables) for their findings. They show appropriate measures of accuracy (RMSE) for the model.

- **Accuracy (5 points)**: According to their average ranking in terms of accuracy (both for the classification and regression task), students will receive a <u>bonus between 0 and 5 points</u>. If the code is not replicable (e.g. the instruction team cannot replicate their results), the group automatically will have the lowest ranking.

# Instructions

1. **Form a team**: Within your section, select a team of 3 or 4 students. Students can choose their own teammates, but whether you are able to form a team of 3 or 4 will depend on the slots available (each section has between 0 and 2 groups of 3 depending on the number of students). If you don't have enough people for a team, feel free to post on the Canvas discussion board to look for additional students!
	
	- The instruction team will send out an announcement when its time to choose your group.

2. **Download and clean the data**: You can start with this straight away (and I recommend it given the amount of deadlines at the end of the semester). 
	
	- You will need to go to the [HMDA data](https://ffiec.cfpb.gov/data-browser/) and <u>download data exclusively for Travis county</u> for 2020. If you want, you can select specific variables, but remember that the outcomes we will want to predict are whether the loan was denied or not (`action_taken`) and the loan amount (`loan_amount`). **Do not filter your data at this stage**. You can find the codebook for the different variables [here](https://ffiec.cfpb.gov/documentation/2021/lar-data-fields/).

	- Given the size of the dataset and to avoid crashing your computers, we will only use 1,000 observations from this dataset (and everyone will use the same ones). You need to **run the [following code](https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Assignments/Project/code/STA235H_f2021_prediction_project.R) to select the 1,000 observations you will need**.

	- Feel free to transform any data you might want, but remember that <u>everything you do to your data needs to be contained in your R script</u>!

3. **Predict the outcome for being denied a loan or not**: Play around with models and choose the best one (i.e. the one most accurate) for predicting if someone gets their loan denied or not (`action_taken` is the variable you will need). You will need to compare it with at least one other method (e.g. if you choose to do a classification tree, you can compare their performance to KNN). Make sure you explain your results and show the appropriate plots/tables (e.g. if pertinent, show how you chose a parameter, a plot or list of the most important variables, etc.)
	- Note: Remember that the outcome is whether someone got the loan denied or not. <u>You cannot use the decision of why that loan got denied as a predictor</u>.

4. **Predict the outcome for amount of the loan**: Play around with models and choose the best one (i.e. the one most accurate) for predicting the amount of the loan *for those that got a loan approved* (`loan_amount` is the variable you will need). You will need to compare it with at least one other method (e.g. if you choose to do a regression tree, you can compare their performance to KNN). Make sure you explain your results and show the appropriate plots/tables (e.g. if pertinent, show how you chose a parameter, a plot or list of the most important variables, etc.)

5. **Cite all your references**: If you use any outside resources, be sure to include them in your references. Any unacknowledged contribution could be considered plagiarism, so err on the side of caution when attributing work accordingly.

6. **Do not include code in your write-up**: Unlike homework assignments, think of this report as something that you will give to your boss. Include all relevant tables and plots, but do not include lines of code. Make sure that your tables have an appropriate format and are not just a screenshot of the R console.

7. **Save <u>all</u> your files under the following name:** "STA235H_SectionX_GroupY", where X is your section number (1: Tue 10-12, 2: Tue 12-2, 3: Thu 10-12, 4: Thu 12-2) and Y is your group number (check Canvas for this).

8. **Submit a write-up, your Rcode, and a .RData file**: You will need to submit a write-up with your answers (e.g. showing plots and tables, and explaining your models, as well as the results of your tests), an R script (in .R extension; needs to be fully reproducible), and a .Rdata file, with your prediction object for both your classification task as well as your regression task. See the examples posted below to guide you.


## Examples

<a onclick="ga('send', 'event', 'External-Link','click','writeup_template','0','Link');" href="https://sta235.netlify.app/assignments/project/STA235H_SectionX_GroupY.docx" target="_blank" class="btn btn-default"> Write-up Template <i class="fas fa-external-link-alt"></i></a>

<a onclick="ga('send', 'event', 'External-Link','click','code_template','0','Link');" href="https://sta235.netlify.app/assignments/project/STA235H_SectionX_GroupY.R" target="_blank" class="btn btn-default"> Code Template <i class="fas fa-external-link-alt"></i></a>

