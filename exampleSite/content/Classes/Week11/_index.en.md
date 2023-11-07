---
title: Week 11 - 10/30
weight: 55
disableToc: true
---

## Date: Oct 30th - Nov 1st

## What we will cover

This week we will be talking about model selection and regularization. In particular, lasso and ridge regression.

## Recommended readings/videos

- James, G. et al. (2021). "An Introduction to Statistical Learning with Applications in R" (ISLR). *Chapter 6.2 (pg. 237-242)*. *Note: For ISLR readings, don't get caught up in the math.*

- Josh Starmer. (2018). "Regularization Part 1: Ridge (L2) Regression". *Video materials from StatQuest. Note: I usually watch his videos at x1.5 speed*.

{{< youtube src="https://www.youtube.com/embed/Q81RR3yKn30" >}}

- Josh Starmer. (2018). "Regularization Part 2: Lasso (L1) Regression". *Video materials from StatQuest. Note: I usually watch his videos at x1.5 speed*.

{{< youtube src="https://www.youtube.com/embed/NGf0voTMlcs" >}}



## Slides

{{% button href="https://sta235.com/Classes/Week11/1_Shrinkage/f2023_sta235h_11_Shrinkage.html" icon="fas fa-external-link-alt" icon-position="right" %}}New window{{% /button %}} {{% button href="https://sta235.com/Classes/Week11/1_Shrinkage/f2023_sta235h_11_Shrinkage.pdf" icon="fas fa-file-pdf" icon-position="right" %}}Download{{% /button %}} 

{{< slides src="https://sta235.com/Classes/Week11/1_Shrinkage/f2023_sta235h_11_Shrinkage.html" >}}


## Code

Here is the R code we will review in class, with many additional questions! Remember to review it in detail after class <script>let date = Date.now();</script> <a onclick="gtag('event','code11', {'event_category': 'code','event_label': 'code11', 'event_action': date, 'debug_mode':true });" href="https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week11/1_Shrinkage/code/f2023_sta235h_11_prediction2.R" target="_blank" class="btn btn-default">Download<i class="fas fa-code"></i></a>


Check out the in-class activity we did for this week <a onclick="gtag('event','code11_inclass', {'event_category': 'code','event_label': 'code11_inclass', 'event_action': date, 'debug_mode':true });" href="https://sta235.com/InClassExercises/STA235H_Week11.html" target="_blank" class="btn btn-default">Download<i class="fas fa-code"></i></a>

(The answers for this are here: <a onclick="gtag('event','code11Answers', {'event_category': 'code','event_label': 'code11Answers', 'event_action': date, 'debug_mode':true });" href="https://sta235.com/InClassExercises/STA235H_Week11Answers.html" target="_blank" class="btn btn-default">Download<i class="fas fa-code"></i></a>)



## FAQ

Here, I provide a simple example to understand why this happens. Let's think about the simplest scenario with just one data point and one predictor (we won't take the intercept into account, because it doesn't affect the prediction). As seen in class, the objective function that ridge regression is trying to minizime is the following:

$$F_r = \min_{\beta}(y - \beta x)^2 + \lambda\beta^2$$

Then, to find the optimal $\beta$'s , we need to set the first order conditions (FOC) for this objective function:

$$\frac{\partial F_r}{\partial \beta} = -2(y - \beta x)x + 2\lambda\beta = 0$$
$$\beta(2\lambda + 2x^2) = 2xy$$
$$\beta = \frac{xy}{x^2 + \lambda}$$

In this case, for non-zero values of $x$ and $y$, then $\beta$ cannot be shrunk to exactly 0, because the numerator will always be different from 0. However, if $\lambda \rightarrow \infty$, then $\beta \rightarrow 0$.

In the case of lasso, now, assuming a positive value for $\beta$ (though it works the same if $\beta<0$), we have the following objective function and FOC:

 $$F_l = \min_{\beta}(y - \beta x)^2 + \lambda |\beta|$$

The first order conditions (FOC) for this objective function:

$$\frac{\partial F_l}{\partial \beta} = -2(y - \beta x)x + \lambda = 0$$
$$2\beta x^2 = 2xy - \lambda$$
$$\beta = \frac{2xy - \lambda}{2x^2}$$

Now, we can actually set $\beta=0$ if $\lambda = 2xy$, with multiple values that can achieve that equality. 
