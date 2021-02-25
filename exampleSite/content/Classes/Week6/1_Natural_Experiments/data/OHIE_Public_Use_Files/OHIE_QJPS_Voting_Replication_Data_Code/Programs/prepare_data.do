    use Data/oregon_voting_vars.dta, clear

    gen vote_preperiod = ///
        election_5_16_2006_2_w_cancelled == 1 | election_11_7_2006_2_w_cancelled == 1 | ///
        election_5_15_2007_2_w_cancelled == 1 | election_11_6_2007_2_w_cancelled == 1
    label var vote_preperiod "Any vote in the preperiod (cancelled voter file included)"

    gen vote_presidential_2008_either = 0
    replace vote_presidential_2008_either = 1 if ///
        election_11_4_2008_1_w_cancelled == 1 | election_11_4_2008_2_w_cancelled == 1
    label var vote_presidential_2008_either ///
        "Voted in the 2008 Presidential Election - either data pull (cancelled voters included)"
    gen vote_presidential_2008_1 = 0
    replace vote_presidential_2008_1 = 1 if election_11_4_2008_1_w_cancelled == 1
    label var vote_presidential_2008_1 ///
        "Voted in the 2008 Presidential Election - data pull 1 (cancelled voters included)"
    gen vote_presidential_2008_2 = 0
    replace vote_presidential_2008_2 = 1 if election_11_4_2008_2_w_cancelled == 1
    label var vote_presidential_2008_2 ///
        "Voted in the 2008 Presidential Election - data pull 2 (cancelled voters included)"
    gen vote_midterm_2010_2 = election_11_2_2010_2_w_cancelled ==1
    label var vote_midterm_2010_2 "Voted in 2010 Midterm Election (cancelled voters included)"

    gen vote_other_postlottery_1 = ///
        election_5_27_2008_1==1  | election_7_15_2008_1==1  | election_9_16_2008_1==1 | ///
        election_10_7_2008_1==1  | election_11_18_2008_1==1 | ///
        election_3_10_2009_1==1  | election_5_5_2009_1==1   | ///
        election_5_19_2009_1_w_cancelled==1 | ///
        election_6_23_2009_1==1  | election_8_11_2009_1==1  | election_9_15_2009_1==1 | ///
        election_9_29_2009_1==1  | election_10_13_2009_1==1 | ///
        election_11_4_2009_1_w_cancelled==1 | ///
        election_11_17_2009_1==1 | election_12_8_2009_1==1  | election_12_15_2009_1==1 | ///
        election_12_29_2009_1==1 | ///
        election_1_26_2010_1_w_cancelled==1 | election_3_9_2010_1==1 | ///
        election_5_18_2010_1_w_cancelled==1 | election_6_1_2010_1==1
    label var vote_other_postlottery_1 ///
        "Voted in an election other than the 2008 gen. elect and 2010 midt-data pull 1"
    gen vote_other_postlottery_2 = ///
        election_5_20_2008_2_w_cancelled==1 | election_5_19_2009_2_w_cancelled==1 | ///
        election_11_4_2009_2_w_cancelled==1 | election_1_26_2010_2_w_cancelled==1 | ///
        election_5_18_2010_2_w_cancelled==1
    label var vote_other_postlottery_2 ///
        "Voted in an election other than the 2008 gen. elect and 2010 midt-data pull 2"

    gen registered_1 = status_code_1 == "A"
    label var registered_1 "Registered to vote in 2010 (in active file in 2010)"
    gen registered_2 = status_code_2 == "A"
    label var registered_2 "Registered to vote in 2013 (in active file in 2013)"
    forv i = 1/2 {
        gen dem_`i' = party_code_`i' == "DEM" & status_code_`i' == "A"
        label var dem_`i' "Registered as a democrat - data pull `i'"
        gen rep_`i' = party_code_`i' == "REP" & status_code_`i' == "A"
        label var rep_`i' "Registered as a republican - data pull `i'"
        gen na_`i'  = party_code_`i' == "NA" & status_code_`i' == "A"
        label var na_`i'  "Registered as a non affiliated voter - data pull `i'"
        gen other_`i' = ///
            inlist(party_code_`i', "AME", "CON", "IND", "LBT", "OTH", "PAC", "PRG", "WFP") & ///
            status_code_`i' == "A"
        label var other_`i' "Registered as another political party - data pull `i'"
    }

    foreach var of varlist vote_* registered_* data_pull_* dem_* rep_* na_* other_* {
        replace `var' = 0 if `var' == .
    }

    *Variables for sample selection analysis
    forv i=1/2 {
        gen status_`i'=.
        replace status_`i'=1 if data_pull_`i'==0
        replace status_`i'=2 if data_pull_`i'==1 & election_11_4_2008_`i'==.
        replace status_`i'=3 if data_pull_`i'==1 & election_11_4_2008_`i'==0
        replace status_`i'=4 if data_pull_`i'==1 & election_11_4_2008_`i'==1
    }
    gen entry = data_pull_1==0 & data_pull_2==1 & data_pull_3 == 0
    gen exit  = data_pull_1==1 & data_pull_2==0 & data_pull_3 == 0
    gen status_2006_w_cancelled = election_11_7_2006_2_w_cancelled == 1
    gen status_2007_w_cancelled = election_11_6_2007_2_w_cancelled == 1

    local i = 0
    foreach data in 2010 2013 cancelled {
        local ++i
        foreach e_date in 11_4_2008 11_2_2010 {
            gen     voting_`data'_`e_date' = 1 if data_pull_`i' == 0
            cap replace voting_`data'_`e_date'= 2 if data_pull_`i'== 1 & election_`e_date'_`i'== .
            cap replace voting_`data'_`e_date'= 3 if data_pull_`i'== 1 & election_`e_date'_`i'== 0
            cap replace voting_`data'_`e_date'= 4 if data_pull_`i'== 1 & election_`e_date'_`i'== 1
            lab define voting_`data'_`e_date' ///
                1 "Not Matched in `data' Data" ///
                2 "Missing `e_date' Voting Data" ///
                3 "Did Not Vote in `e_date'" ///
                4 "Voted in `e_date'"
            lab val voting_`data'_`e_date' voting_`data'_`e_date'
        }
    }

    xi, prefix(nnn) i.numhh_list
    gen all        = 1 
    label var all "Value of 1 for everybody - used for heterogeneity analysis"
    gen female     = (female_list == 1)
    gen male       = (female_list == 0)
    gen young      = (age_list >= 19 & age_list <= 49)
    gen old        = (age_list > 49  & age_list <= 64)
    gen english    = (english_list == 1)
    gen nonenglish = (english_list == 0)
    gen prevote    = (vote_preperiod == 1)
	
	drop election_*_w_cancelled election_*_1 election_*_2 election_*_3
	drop voting_2010_11_2_2010 voting_2013_11_4_2008 
	
	la var female "Indic: female"
	la var male "Indic: male"
	la var young "Indic: ages 19-49"
	la var old "Indic: ages 50-64"
	la var english "Indic: English-language lottery materials"
	la var nonenglish "Indic: non-English language lottery materials"
	la var prevote "Indic: voted in any 2006 or 2007 election"
	la var dem_08 "Indic: zip in a Democratic county (2008)"
	la var status_1 "status of Nov 2008 voting records in 2010 data"
	la var status_2 "status of Nov 2008 voting records in 2013 data"
	la var voting_2010_11_4_2008 "status of Nov 2008 voting records in 2010 data"
	la var voting_cancelled_11_4_2008 "status of Nov 2008 voting records in cancelled voter data"
	la var voting_2013_11_2_2010 "status of Nov 2010 voting records in 2013 data"
	la var voting_cancelled_11_2_2010 "status of Nov 2010 voting records in cancelled voter data"
	
	la var status_2006_w_cancelled "Indic: voted in Nov 2006 election"
	la var status_2007_w_cancelled "Indic: voted in Nov 2007 election"
	la var entry "Indic: entry from data"
	la var exit "Indic: exit from data"
	
	la var weight_jun2010 "June 2010 weights"
	la var weight_nov2010 "November 2010 weights"

    save Data/individual_voting_data.dta, replace
