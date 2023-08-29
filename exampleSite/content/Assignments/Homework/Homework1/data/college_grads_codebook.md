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

Variable | Description
---|---------
`Rank` | Rank by median earnings
`Major_code` | Major code, FO1DP in ACS PUMS
`Major` | Major description
`Major_category` | Category of major from Carnevale et al
`Total` | Total number of people with major
`Sample_size` | Sample size (unweighted) of full-time, year-round ONLY (used for earnings)
`Men` | Male graduates
`Women` | Female graduates
`Employed` | Number employed (ESR == 1 or 2)
`Full_time` | Employed 35 hours or more
`Part_time` | Employed less than 35 hours
`Full_time_year_round` | Employed at least 50 weeks (WKW == 1) and at least 35 hours (WKHP >= 35)
`Unemployed` | Number unemployed (ESR == 3)
`Unemployment_rate` | Unemployed / (Unemployed + Employed)
`Median` | Median earnings of full-time, year-round workers
`P25th` | 25th percentile of earnings
`P75th` | 75th percentile of earnings
`College_jobs` | Number with job requiring a college degree
`Non_college_jobs` | Number with job not requiring a college degree
`Low_wage_jobs` | Number in low-wage service jobs