---
---

<style>
.invisible-text {
    display: none;
}

.btn-editor {
    font-weight: bold !important;
    font-size: 30px !important;
    color: rgba(132, 81, 161,1) !important;
}

.stackedit-button-wrapper {
    text-align: center;
    font-weight: bold;
    font-weight: bold;
    display: table;
    border-width: thick;
    border: 5px solid rgba(132, 81, 161,1);
    font-family: "Work Sans";
    border-radius: 15px;
    margin: 0em auto;
    overflow: hidden;
    padding: 0.4em 0.4em;
}
</style>

# Notation Cheat Sheet

### Some basic notation for causal inference

<table>
<colgroup>
<col width="20%" />
<col width="60%" />
</colgroup>
<thead>
<tr class="header">
<th>Math stuff..</th>
<th>… in words</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>$Y$</td>
<td><p>In this class, we will be seeing it as the outcome variable (observed)</td>
</tr>
<tr class="even">
<td>$X$</td>
<td>Covariate, independentent variable, etc. These variables are also observed in our data.</td>
</tr>
<tr class="odd">
<td>$\beta$</td>
<td>A population parameter (coefficient in the model); can refer to a treatment effect or <u>causal estimand</u> (if it's for the treatment variable!). It's <u>not observed</u> (but we can estimate it!)</td>
</tr>
<tr class="even">
<td>$\hat{\beta}$</td>
<td>Estimated coefficient for the true $\beta$ (really, anything with a hat $\hat{.}$ is an estimate). This is obtained from our data (observed), and you can see it in R output!</td>
</tr>
<tr class="odd">
<td>$Y(z)$</td>
<td>Potential outcomes under treatment $Z=z$. Meaning, what would your outcome be if you were under treatment ($z=1$) or under control ($z=0)$. This can <u>only be observed</u> if your <u>actual</u> treatment assignment is also $Z=z$ (and you can observe at most one of them). One important distinction: All units have <u>all potential outcomes</u>, but, again, you can at most observe only one of them.</td>
</tr>
<tr class="even">
<td>$E[Y]$</td>
<td>Expected value of the observed outcome $Y$. This is observed in our data, and you can estimate it by just taking a sample mean of the outcome.</td>
</tr>
<tr class="odd">
<td>$E[Y|Z=1]$</td>
<td>Expected value of the observed outcomes <i>for individuals in the treatment group</i>. This is also obsereved in our data, and you can estimate it by taking the sample mean of the outcome for our treatment group.</td>
</tr>
<tr class="even">
<td>$E[Y(0)]$</td>
<td>Expected value of the potential outcomes under control. Again, this is not observed for everyone (only for the control group)</td>
</tr>
<tr class="odd">
<td>$E[Y(0)|Z=1]$</td>
<td>Expected value of the potential outcomes under control <i>for individuals in the treatment group</i>. This is <u>not observed</u>! (It would be, in fact, the counterfactual for the treatment group).</td>
</tr>
<tr class="even">
<td>$E[Y(0)|Z=0]$</td>
<td>Expected value of the potential outcomes under control <i>for individuals in the control group</i>. This is <u>observed</u>, and we can estimate it (again, think of $\hat{.}$) by taking the mean of the observed outcomes for the control group.</td>
</tr>
<tr class="odd">
<td>$ATE = E[Y(1) - Y(0)]$</td>
<td>Average Treatment Effect (the average effect that an intervention has on a population). As you can see, this is the expected value for the Individual Causal Effect (ICE).This is <u>not observed</u> (but we can estimate it under certain assumptions!).</td>
</tr>
<tr class="even">
<td>$ATT = E[Y(1) - Y(0)|Z=1]$</td>
<td>Average Treatment Effect on the Treated (the average effect that an intervention has on the treatment group). This is the expected value for the ICE, but only for the treated group. This is <u>not observed</u> (but we can estimate it under certain assumptions!).</td>
</tr>
</tbody>
</table>