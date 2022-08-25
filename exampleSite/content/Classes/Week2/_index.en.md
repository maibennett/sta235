---
title: Week 2 - 08/29
weight: 20
disableToc: true
---

## Date: Aug 30th - Sep 1st

## What we will cover

In this class, we will go deepper into statistical adjustment, specifically when we have interactions. We will also dive into "nonlinear" models.

## Recommended readings/videos

- [Ismay, C. & A. Kim. (2021). "Statistical Inference via Data Science". Chapter 6 (section 6.1 and 6.2)](https://moderndive.com/6-multiple-regression.html)

- [Ismay, C. & A. Kim. (2021). "Statistical Inference via Data Science". Chapter 10 (sections 10.3)](https://moderndive.com/10-inference-for-regression.html)

- [Healy, K. (2018). "Data Visualization: A Practical Introduction". Chapter 1 (section 1.1). *Princeton University Press*.](https://socviz.co/lookatdata.html)



## Slides
<!-- 
{{% button href="https://sta235.netlify.app/Classes/Week2/1_OLS/f2022_sta235h_3_reg.html" icon="fas fa-external-link-alt" icon-position="right" %}}New window{{% /button %}} {{% button href="https://sta235.netlify.app/Classes/Week2/1_OLS/f2022_sta235h_3_reg.pdf" icon="fas fa-file-pdf" icon-position="right" %}}Download{{% /button %}} 

{{< slides src="https://sta235.netlify.app/Classes/Week2/1_OLS/f2022_sta235h_3_reg.html" >}}

-->
## Code
<!-- 
Here is the R script we will review in class, with some additional questions: 

<a onclick="ga('send', 'event', 'External-Link','click','code2','0','Link');" href="https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week2/1_OLS/code/f2022_sta235h_2_reg.R" target="_blank" class="btn btn-default">Download<i class="fas fa-code"></i></a> 
-->

<!-- 
## Notes

- *How do I interpret log transformations of variables in a linear regression?*

**Answer**: A lot of the time, we want to transform our dependent variable `$ y $` to `$ \log(y) $`, so that it's normally distributed (e.g. income), or sometimes we could also have a covariates included in our model in a log form. How do we interpret the coefficients in a linear regression model under these transformations? As we saw in class, you can actually interpret them as percentage changes! Take a look at this article to see how to exactly interpret these coefficients, depending on whether your dependent or independent variable (or both!) are in log form. {{% button href="https://data.library.virginia.edu/interpreting-log-transformations-in-a-linear-model/" icon="fas fa-external-link-alt" icon-position="right" %}}Go to article{{% /button %}}

- *Do we need to standardize binary covariates?*

**Answer**: As we saw in class, the main problem with standardizing binary variables is that the interpretation becomes more complicated (e.g. what does "1 standard deviation increase" of the Bechdel test variable mean?). One way to address this would be to not standardize coefficients for indicators (be careful here when comparing effect sizes, though), or standardize variables as suggested by [Andrew Gelman](https://statmodeling.stat.columbia.edu/2010/04/12/a_question_abou_9/), where you can [divide all numeric variables by two standard deviations](http://www.stat.columbia.edu/~gelman/research/published/standardizing7.pdf) to make them comparable to the coefficients of binary variables (Note: we won't be doing that in this class, but the information is here if someone is curious about this). -->