---
title: Week 1
weight: 15
disableToc: true
---

## Date: Aug 31st - Sep 2nd

## What we will cover

In this session, we will review the syllabus in more detail: what you should expect from this class, requirements, grading, among others. We will also start covering material related to regression analysis: A quick overview of OLS regressions in R, data inspection, comparing effect sizes, and outliers.

## Recommended readings/videos

- [Healy, K. (2018). "Data Visualization: A Practical Introduction". Chapter 1 (section 1.1). *Princeton University Press*.](https://socviz.co/lookatdata.html)

- [Ismay, C. & A. Kim. (2021). "Statistical Inference via Data Science". Chapter 10 (sections 10.1 to 10.3)](https://moderndive.com/10-inference-for-regression.html)

## Slides

<!-- {{% button href="https://sta235.netlify.app/Classes/Week1/1_Intro/f2021_sta235h_1_intro.html" icon="fas fa-external-link-alt" icon-position="right" %}}New window{{% /button %}} {{% button href="https://sta235.netlify.app/Classes/Week1/1_Intro/f2021_sta235h_1_intro.pdf" icon="fas fa-file-pdf" icon-position="right" %}}Download{{% /button %}} 

{{< slides src="https://sta235.netlify.app/Classes/Week1/1_Intro/f2021_sta235h_1_intro.html" >}}

<br>

{{% button href="https://sta235.netlify.app/Classes/Week1/2_OLS/f2021_sta235h_2_reg.html" icon="fas fa-external-link-alt" icon-position="right" %}}New window{{% /button %}} {{% button href="https://sta235.netlify.app/Classes/Week1/2_OLS/f2021_sta235h_2_reg.pdf" icon="fas fa-file-pdf" icon-position="right" %}}Download{{% /button %}} 

{{< slides src="https://sta235.netlify.app/Classes/Week1/2_OLS/f2021_sta235h_2_reg.html" >}}

## Code

Here is the R code we will review in class, with some additional data and questions <a onclick="ga('send', 'event', 'External-Link','click','code1','0','Link');" href="https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week1/2_OLS/code/f2021_sta235h_2_reg.R" target="_blank" class="btn btn-default">Download<i class="fas fa-code"></i></a>

## Notes

- *How do I interpret log transformations of variables in a linear regression?*

**Answer**: A lot of the time, we want to transform our dependent variable `$ y $` to `$ \log(y) $`, so that it's normally distributed (e.g. income), or sometimes we could also have a covariates included in our model in a log form. How do we interpret the coefficients in a linear regression model under these transformations? As we saw in class, you can actually interpret them as percentage changes! Take a look at this article to see how to exactly interpret these coefficients, depending on whether your dependent or independent variable (or both!) are in log form. {{% button href="https://data.library.virginia.edu/interpreting-log-transformations-in-a-linear-model/" icon="fas fa-external-link-alt" icon-position="right" %}}Go to article{{% /button %}} -->