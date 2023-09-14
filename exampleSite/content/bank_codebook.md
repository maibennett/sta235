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

## Codebook for Bank data

| Field         | Description                                                                                                                               |
|---------------|-------------------------------------------------------------------------------------------------------------------------------------------|
| age           | Age (years)                                                                                                                               |
| job           | Type of job (categorical: 'admin.','blue-collar','entrepreneur','housemaid','management','retired','self-employed','services','student','technician','unemployed','unknown') |
| marital       | Marital status (categorical: 'divorced','married','single','unknown'; note: 'divorced' means divorced or widowed)                        |
| education     | Education (categorical: 'primary', 'secondary', 'tertiary', 'unknown')                                                                    |
| default       | has credit in default?                                                                                                                   |
| balance       | average yearly balance                                                                                                                   |
| housing       | has housing loan?                                                                                                                        |
| loan          | has personal loan?                                                                                                                       |
| contact       | contact communication type (categorical: 'cellular','telephone')                                                                          |
| day_of_week   | last contact day of the week                                                                                                             |
| month         | last contact month of year (categorical: 'jan', 'feb', 'mar', ..., 'nov', 'dec')                                                         |
| duration      | Last contact duration, in seconds (numeric).                                                                                              |
| campaign      | Number of contacts performed during this campaign and for this client (numeric, includes last contact)                                    |
| pdays         | Number of days that passed by after the client was last contacted from a previous campaign (numeric; -1 means client was not previously contacted) |
| previous      | Number of contacts performed before this campaign and for this client                                                                     |
| poutcome      | Outcome of the previous marketing campaign (categorical: 'failure','nonexistent','success')                                                |
| deposit       | Has the client subscribed a term deposit?                                                                                                |
