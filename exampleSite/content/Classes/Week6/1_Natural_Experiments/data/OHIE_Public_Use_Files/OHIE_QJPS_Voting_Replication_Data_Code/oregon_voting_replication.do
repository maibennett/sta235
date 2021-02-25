version 15 // remove this line if running on earlier versions of Stata
clear all
program drop _all
set more off
cap log close
cap mkdir Output
adopath + Programs/
adopath + Programs/Subprograms

log using oregon_voting_replication.log, text replace

program main
	** Prepare Data
	do Programs/prepare_data.do
	
	** Table 1: November 2008 Voter Turnout
	** Table A2: November 2008 Voter Turnout  (Using 2013 Data)
    tab_08_vote, table(Table1) table_alt(TableA2) 
	
	** Table 2: Registered to Vote (as of June 22, 2010)      
    tab_registration, table(Table2) 
	
	** Table 3: Voter Turnout - Other Post-Lottery Elections
    tab_other_vote, table(Table3)
	
	** Table A1: Treatment-Control Balance
    tab_balance, table(TableA1) 
	
	** Table A4: 2010 and 2013 Data Files
    tab_data_quality, tabvar(status_1 status_2) table(TableA4)
	
	** Table A5: November 2008 Voting Records in the Cancelled Voter File and in the 2010 Data
    tab_data_quality, tabvar(voting_2010_11_4_2008 voting_cancelled_11_4_2008) table(TableA5) 
		
	** Table A6: November 2010 Voting Records in the Cancelled Voter File and in the 2013 Data
	tab_data_quality, tabvar(voting_2013_11_2_2010 voting_cancelled_11_2_2010) table(TableA6) 
		
	** Table A7: Tests of Balance for Sample Selection
    tab_balance_selection, table(TableA7) 
	
	** Table A8: Distribution of the Weights
    tab_weights, table(TableA8) 

end

program tab_08_vote
    syntax, table(str) table_alt(str) 
    use Data/individual_voting_data, clear
    forval i = 1/2 {
        voting_heterogeneity_analysis vote_presidential_2008_`i', ///
        subpops(all) controls(nnn*) insurance(ohp_all_ever_nov2008) table(`table'_`i')
    }
    voting_heterogeneity_analysis vote_presidential_2008_2, ///
        subpops(all) controls(nnn* prevote) insurance(ohp_all_ever_nov2008) table(`table'_3)
    voting_heterogeneity_analysis vote_presidential_2008_1, subpops(male old english dem_08) ///
        controls(nnn*) insurance(ohp_all_ever_nov2008) table(`table'_4)
    matrix `table'= `table'_1\ `table'_2\ `table'_3\ `table'_4
    matrix list `table'
    oregon_table_export "`table'" 

    voting_heterogeneity_analysis vote_presidential_2008_2, subpops(all male old english dem_08) ///
        controls(nnn*) insurance(ohp_all_ever_nov2008) table(`table'_5)
    voting_heterogeneity_analysis vote_presidential_2008_2, subpops(all male old english dem_08) ///
        controls(nnn* prevote) insurance(ohp_all_ever_nov2008) table(`table'_6)
    matrix `table_alt' = `table'_1\ `table'_5\ `table'_6
    matrix list `table_alt'
    oregon_table_export "`table_alt'" 
end

program tab_registration
    syntax, table(str) 
    use Data/individual_voting_data, clear
    voting_main_analysis registered_1 dem_1 rep_1 other_1 na_1 [pw=weight_jun2010], controls(nnn*) ///
        insurance(ohp_all_ever_01jun2010) table(`table'_1)	
    voting_heterogeneity_analysis registered_1 [pw=weight_jun2010], controls(nnn*) ///
        subpops(male old english dem_08) insurance(ohp_all_ever_01jun2010) table(`table'_2)
    matrix `table'= `table'_1\ `table'_2
    matrix list `table'
    oregon_table_export "`table'" 
end

program tab_other_vote
    syntax, table(str) 
    use Data/individual_voting_data, clear
    voting_main_analysis vote_midterm_2010 [pw=weight_nov2010], ///
        controls(nnn*) insurance(ohp_all_ever_nov2010) table(`table'_1)
    voting_main_analysis vote_midterm_2010 [pw=weight_nov2010], ///
        controls(nnn* prevote) insurance(ohp_all_ever_nov2010) table(`table'_2)
    voting_main_analysis vote_other_postlottery_1 [pw=weight_jun2010], ///
        controls(nnn*) insurance(ohp_all_ever_01jun2010) table(`table'_3)
    matrix `table'= `table'_1\ `table'_2\ `table'_3
    matrix list `table'
    oregon_table_export "`table'" 
end

program tab_balance
    syntax, table(str) 
    local listvars ///
        "birthyear_list female_list english_list self_list first_day_list have_phone_list pobox_list zip_hh_inc_list"
    local i = 1
    foreach w in weight weight_jun2010 weight_nov2010 {
        local ++i
        use Data/individual_voting_data, clear
            gen weight = 1
        oregon_balance `listvars' prevote [pw=`w'], listvars(`listvars') ///
            preperiodvars(prevote) table(`table'`i')
        matrix colnames `table'`i' = c_mean`i' tc_diff`i' pval`i'
        matrix `table' = nullmat(`table'), `table'`i'
    }
    oregon_table_export "`table'" 
end

program tab_data_quality
    syntax, table(str)  tabvar(str)
    use Data/individual_voting_data, clear
    tab `tabvar', mi row matcell(`table')
    oregon_table_export "`table'" 
end

program tab_balance_selection
    syntax, table(str) 
    use Data/individual_voting_data, clear
    local listvars "status_2006_w_cancelled status_2007_w_cancelled prevote entry exit"
    oregon_balance `listvars', listvars(`listvars') table(`table')
    oregon_table_export "`table'" 
end

program tab_weights
    syntax, table(str) 
    use Data/individual_voting_data, clear
    foreach var in weight_jun2010 weight_nov2010 {
        oregon_var_sum `var', ///
            stat_list(r(mean) r(sd) r(min) r(p50) r(p75) r(p95) r(max) r(N)) table(table1`var')
        oregon_var_sum `var' if treatment==0, ///
            stat_list(r(mean) r(sd) r(min) r(p50) r(p75) r(p95) r(max) r(N)) table(table2`var')
        oregon_var_sum `var' if treatment==1, ///
            stat_list(r(mean) r(sd) r(min) r(p50) r(p75) r(p95) r(max) r(N)) table(table3`var')
        oregon_var_sum `var' if `var'!=0, ///
            stat_list(r(mean) r(sd) r(min) r(p50) r(p75) r(p95) r(max) r(N)) table(table4`var')
        oregon_var_sum `var' if `var'!=0 & treatment==0, ///
            stat_list(r(mean) r(sd) r(min) r(p50) r(p75) r(p95) r(max) r(N)) table(table5`var')
        oregon_var_sum `var' if `var'!=0 & treatment==1, ///
            stat_list(r(mean) r(sd) r(min) r(p50) r(p75) r(p95) r(max) r(N)) table(table6`var')
        matrix `var' = table1`var'\ table2`var'\ table3`var'\ table4`var'\ table5`var' ///
            \ table6`var'
        matrix rownames `var'= "full_sample_all" "full_sample_controls" "full_sample_treatments" ///
            "non_zero_weights_all" "non_zero_weights_controls" "non_zero_weights_treatments"	
    }
    matrix temp = weight_jun2010\ weight_nov2010
	matrix `table' = temp, ((1 - temp[4,8]/temp[1,8]) \ (1 - temp[5,8]/temp[2,8]) \ (1 - temp[6,8]/temp[3,8])\.\.\.\ ///
	(1 - temp[10,8]/temp[7,8])\ (1 - temp[11,8]/temp[8,8]) \ (1 - temp[12,8]/temp[9,8]) \.\.\. )
    oregon_table_export "`table'" 
end

** EXECUTE
main

log close
