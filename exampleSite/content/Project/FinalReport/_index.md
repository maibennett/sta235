---
title: Final Report
weight: 40
chapter: true
---

## Final report

The final report should include everything that is included in the preliminary report (including the instructor's feedback), in addition to the finalyzed analysis. If you did not receive any feedback in the preliminary report, you do not need to change anything, and can just resubmit those sections as it is. **Do not include your analysis plan in this submission**. That section should be replaced with the actual analysis.

For projects tackling a causal question, the analysis portion should present your identification strategy (i.e. how are we identifying a causal effect here?), the main model you are running, assumptions for causality, and any robustness checks that are appropriate (e.g. balance tables, pre-parallel trends, discontinuity plots, etc.). Additionally, you will need a short section on potential limitations of your analysis (e.g. what are the threats to causality) and potential solutions you might have. For example, if you had access to additional data or are able to design an RCT, etc.

For project tackling prediction, the analysis portion should contain at least 2 (and no more than 3) prediction models you have tested. I would **<u>strongly</u>** suggest using one parametric approach (e.g. linear model or shrinkage model) and one non-parametric (e.g. random forests, boosting, etc.). Remember that the goal is to get the best predictive model you can! In this section you should discuss your tuning parameters (if appropriate), show appropriate plots for these selections, and discuss the interpretation of your models (e.g. what variables are more relevant), aside from actual performance metrics. You should also include a comparison between your predicted values and your actual observed values to assess how your models are performing.

All reports should conclude with the main takeaway points of this project (i.e. things that went well, things that didn't, etc.).

In terms of formatting, same guidelines apply as in the preliminary report: 11pt font, 1.15 spacing (min). The introduction and data description (text) cannot extend beyond 2 pages (same as the preliminary report), and the same goes for the analysis and conclusion (2 pages of text max). Any plots or tables do not count for the page count. You do not need to use all 4 pages of text if it is not necessary, but that is the maximum extension.


{{% notice grading %}}

**Introduction and data description:** This is the same that was evaluated in the preliminary report. You should only change things according to the feedback provided in the preliminary report. Extension should be kept the same.<br>
**Analysis:** Pertinent analysis of the data to answer the research question. Includes some robustness checks/ multiple models (if appropriate) and limitations.<br>
**Conclusions:** Main takeaway points of the project.<br>
**Peer assessment:** Students will be evaluated by their peers in terms of their contributions and responsiblity.

{{% /notice %}}

### Rubric

- Introduction and Data Description (15 points): Takes into account the incorporation of the preliminary report feedback.

- Analysis - Models (10 points): Models are pertinent for the task at hand.

- Analysis - Explanation (20 points): Explanation is sound and describes the models and analysis appropriately.

- Analysis - Plots and tables (15 points): Tables and plots are appropriate in formatting. Includes relevant plots/tables.

- Limitations/Robustness checks (15 points): Describes limitations accordingly. In causal inference, potential threats (e.g. confounders), and run appropriate robustness checks and/or describes how these can be overcome. In prediction, includes details about performance of the models beyond RMSE and accuracy (e.g. plots for predictions vs observed values, 2x2 tables for classification, etc.).

- Conclusions (10 points): Appropriate conclusions.

- R Script (15 points): R script is complete and reproduces the results. Provides sound code.