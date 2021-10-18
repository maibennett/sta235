---
title: Homework 3
weight: 30
chapter: false
---

## Instructions

- Submit your homework through Canvas before **Thursday October 14th 11:59 pm**. One submission per group.

- If you want to use your 24-hrs extension, complete **[this Google form](https://forms.gle/3HSsiZBAPSZ8rEYD7)** before the homework due date.

- Remember to submit your **write-up (only PDF extension) and your R script (.R or .Rmd)**. If both files are not submitted, the submission will be counted as incomplete until both files are received. *Note: Submit an R scrip in .R, not in PDF*

- Use the templates provided below to guide you on how your submissions should look like.

- **No need to write long answers**. Keep your answers short and precise, and address what is being asked (there are no additional points for answering something that is not being asked). Nonetheless, you need to be specific (e.g. it's not enough to say "there is a confounding problem"; you need to explain why you think that and give a specific example).

- Write a short paragraph at the end of the homework stating **each members' contribution to the assignment**. You can indicate, for example, if everyone participated in the overall discussion of the different questions, but also if one particular individual took the lead on a specific question.

## Assignment

You can find Homework 3 here: <a onclick="ga('send', 'event', 'External-Link','click','hw3','0','Link');" href="https://sta235.netlify.app/assignments/homework/homework3/STA235H_Fall21_Homework3.html" target="_blank" class="btn btn-default"> Open HW3 <i class="fas fa-external-link-alt"></i></a>

## Templates

<a onclick="ga('send', 'event', 'External-Link','click','hw3_doc','0','Link');" href="https://sta235.netlify.app/assignments/homework/homework3/STA235H_HW3_template.docx" target="_blank" class="btn btn-default"> Write-up Template <i class="fas fa-external-link-alt"></i></a> 
<br>

<a onclick="ga('send', 'event', 'External-Link','click','hw3_code','0','Link');" href="https://sta235.netlify.app/assignments/homework/homework3/STA235H_HW3_template.R" target="_blank" class="btn btn-default"> Rcode Template <i class="fas fa-external-link-alt"></i></a> 
<br>

<a onclick="ga('send', 'event', 'External-Link','click','hw3_rmd','0','Link');" href="https://sta235.netlify.app/assignments/homework/homework3/STA235H_HW3_template.Rmd" target="_blank" class="btn btn-default"> Rmarkdown Template <i class="fas fa-external-link-alt"></i></a>


## Answer Key

- You can find the answer key for Homework 2 here: <a onclick="ga('send', 'event', 'External-Link','click','hw3_key','0','Link');" href="https://sta235.netlify.app/assignments/homework/homework3/STA235H_Fall21_Homework3_AnswerKey.html" target="_blank" class="btn btn-default"> Open HW3 Answer Key <i class="fas fa-external-link-alt"></i></a>


## Things to look out for

- **Make sure your code runs!** (we do check those as well): Your code is part of your submission. Make sure that any package you need is loaded and don't include code you don't need (e.g. you only need to install packages once, no need to include that on your code!).

- **Make sure your answers match**: I found that in a few submissions, the code you present in your write-up doesn't necessarily match the output you present or the R script you submit. More so, if you code something in more than one way and the answers are contradictory, we will assume the first attempt is the one that counts and disregard the rest. That is to say: Clean your code. Anything that you tried but didn't end up using <u>should not be on your submission</u>. This is not a draft!

- **When a question is asking you to explain, you need to provide an actual explanation:** If the assignment is asking to explain the difference between A and B, it's not enough to say "A is greater than B". That's pretty trivial. What the assignment is asking is for you to give an explanation of *why A is greater than B*.

- **No need to add things that are not being asked**: In a few submissions, students go beyond the question and answer other things. This part of the answers do not give you extra points (but could eventually carry a discount if you have an important conceptual flaw). Keep it short and sweet.

- **Unbalance is not the same as confounding**: We had discussed this in class, but remember that unbalance does not necessarily mean confounding. This because: (1) not all variables are confounders and (2) if I can adjust for it (observed), then it's no longer causing a confounding problem either.

- **Be aware of what you are writing**: It's very usual to have a template in mind when interpreting coefficients (e.g. "estimated average association of X on Y, holding other variables constant"), but you <u>need to be aware of the context</u>. In a simple model, when you have one covariate, there's nothing to hold constant!

- **P-values are important**: When you are interpreting a coefficient and it's not statistically significant at conventional levels, <u>you need to say so</u>. If you are only interpreting the point estimate, you are only giving us half the information. We need to know if we can reject the null hypothesis or not!