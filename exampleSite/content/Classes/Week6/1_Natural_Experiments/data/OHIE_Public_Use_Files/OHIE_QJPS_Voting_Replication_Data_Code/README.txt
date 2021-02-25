Replication Package for "THE IMPACT OF MEDICAID EXPANSION ON VOTER PARTICIPATION: 
EVIDENCE FROM THE OREGON HEALTH INSURANCE EXPERIMENT" (Baicker and Finkelstein 2019)

**************************************
TABLE OF CONTENTS
**************************************
oregon_voting_replication.do (the master do-file) is the Stata do-file that replicates the tables. It runs on Stata 15, as well as Stata 12, 13 or 14.

/Data/ contains oregon_voting_vars.dta, a Stata .dta file that contains de-identified data needed for the replication.

/Programs/ contains the following files:
  - prepare_data.do creates, transforms and codes variables used in analysis. It creates individual_voting_data.dta, the data set for analysis, in /Data/.
  - all .ado files are programs written by the research team that the master do-file calls.
  - /Subprograms/ contains additional .ado files, which are add-on Stata programs.

/Output/ stores table output in .csv format, after the master do-file is run.

**************************************
LIST OF TABLES REPLICATED
**************************************
This replication package replicates all main and appendix tables except Table A3, which is a list of elections and is not produced from data analysis.

**************************************
BASE SOFTWARE DEPENDENCIES
**************************************
The replication code runs on Stata 15 (as well as Stata 12, 13 or 14). The .dta file can be read by Stata 12 or later.

**************************************
ADDITIONAL DEPENDENCIES
**************************************
The code requires Stata add-on svmat2, which is included in /Subprograms/, and loaded in the beginning of the do-file.
We use svmat2 1.2.2, obtained online from https://www.stata.com/stb/stb56/dm79/svmat2.ado.

**************************************
SEED LOCATION
**************************************
The replication code does not require seed setting.



