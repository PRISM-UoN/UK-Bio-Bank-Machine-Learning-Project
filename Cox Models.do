use "C:\Users\mczsfw\OneDrive - The University of Nottingham\UK Bio Bank\Machine Learning\DerivationCohort_research.dta", clear

*Derivation Cohort*
gen cohort = 0

append using "C:\Users\mczsfw\OneDrive - The University of Nottingham\UK Bio Bank\Machine Learning\ValidationCohort_research.dta"

*Validation Cohort*
replace cohort = 1 if cohort ==. 

*Generate exit date*
gen dox = deathdate if death !=.
replace dox = d(17feb2016) if dox ==.
format dox %d


*Generate follow-up time*
gen time = dox - startdate
gen timeyrs = time/365.25
label var time "follow up time in days"
label var timeyrs "follow up time in years"

*Full models 
*stcox
stset timeyrs, failure(death==1) id(n_eid)

gen logage = ln(baselineage)

*Mortality men
stcox logage i.ethnicity i.priorcancer i.priorchd i.priordiabetes i.priorcopd i.smoking logdiabp logsysbp logtownsend logbmi logMET if gender==1 & cohort==0
predict xbmo_men, xb
*gen probmort_men = 1 - (0.9618^exp(xbmo_men)) if cohort == 1 //need to generate betamean here

*Mortality women
stcox logage i.ethnicity i.priorcancer i.priorchd i.priordiabetes i.priorcopd i.smoking logdiabp logsysbp logtownsend logbmi logMET if gender == 0 & cohort==0
predict xbmo_wom, xb 
*gen probmort_wom = 1- (0.9793^exp(xbmo_wom)) if cohort == 1 //need to generate betamean here


*combined model with gender adjusted*
stcox gender logage i.education i.ethnicity i.priorcancer i.priorchd i.priordiabetes i.priorcopd i.smoking logdiabp logsysbp logtownsend logbmi logMET if cohort==0
est sto cv
estout cv using "C:\Users\mczsfw\OneDrive - The University of Nottingham\UK Bio Bank\Machine Learning\hazardmodel.txt", append cells("b p ci_l ci_u _star") eform label

stcox gender logage i.education i.ethnicity i.priorcancer i.priorchd i.priordiabetes i.priorcopd i.smoking logdiabp logsysbp logtownsend logbmi logMET if cohort==0, nohr
predict xb_all, xb

*with smoking as dichotomised variable*
*combined model with gender adjusted*
gen smoke2 = smoking 
recode smoke2 0=1

stcox gender logage i.education i.ethnicity i.priorcancer i.priorchd i.priordiabetes i.priorcopd i.smoke2 logdiabp logsysbp logtownsend logbmi logMET logfev if cohort==0
est sto cv
estout cv using "C:\Users\mczsfw\OneDrive - The University of Nottingham\UK Bio Bank\Machine Learning\hazardmodel2.txt", append cells("b p ci_l ci_u _star") eform label

*untransformed*
stcox gender logage i.education i.ethnicity i.priorcancer i.priorchd i.priordiabetes i.priorcopd i.smoke2 logdiabp logsysbp logtownsend logbmi logMET logfev if cohort==0, nohr
est sto cv

*generate betamean
egen gendermean = mean(gender) 
gen genderbeta = 0.5848542*gendermean

egen agemean = mean(logage) 
gen agebeta = 4.292667*agemean 

egen educationmean = mean(education)
gen educationbeta = 0*educationmean if education == 0
replace educationbeta = -0.2615049*educationmean if education == 1
replace educationbeta = -0.1602926*educationmean if education == 2
replace educationbeta = -0.1973528*educationmean if education == 3
replace educationbeta = -0.1251086*educationmean if education == 4
replace educationbeta = -0.2111344*educationmean if education == 5
replace educationbeta = -0.2217273*educationmean if education == 6
replace educationbeta = -0.0387728*educationmean if education == 7

egen ethnicmean = mean(ethnicity)
gen ethnicbeta = 0*ethnicmean if ethnicity == 1
replace ethnicbeta = -0.3991133*ethnicmean if ethnicity == 2
replace ethnicbeta = -0.3049849*ethnicmean if ethnicity == 3 
replace ethnicbeta = -0.3544987*ethnicmean if ethnicity == 4
replace ethnicbeta = -0.1403931*ethnicmean if ethnicity == 5
replace ethnicbeta = 0.0721303*ethnicmean if ethnicity == 6


egen cancermean = mean(priorcancer)
gen cancerbeta =  0.9486906*cancermean 

egen chdmean = mean(priorchd)
gen chdbeta = 0.4877298*chdmean

egen dmmean = mean(priordiabetes)
gen dmbeta = 0.5634447*dmmean

egen copdmean = mean(priorcopd)
gen copdbeta = 0.7346502*copdmean

egen smokemean = mean(smoking)
gen smokebeta = 0*smokemean if smoking == 0
replace smokebeta = -3.135157*smokemean if smoking == 1
replace smokebeta = 0.6662167*smokemean if smoking == 2

egen diamean = mean(logdiabp)
gen diabeta = -0.3930821*diamean

egen sysmean = mean(logsysbp)
gen sysbeta = 0.2134852*sysmean

egen meantown = mean(logtownsend)
gen townbeta = 0.141563*meantown

egen meanbmi = mean(logbmi)
gen bmibeta = 0.19333923*meanbmi

egen meanMET = mean(logMET)
gen metbeta = -0.0664464*meanMET

gen xbmean = genderbeta + agebeta + educationbeta+ ethnicbeta + cancerbeta + chdbeta + dmbeta + copdbeta + smokebeta + diabeta + sysbeta + townbeta + bmibeta + metbeta 


gen prob_mort = 1 - (0.9713^exp(xb_all - xbmean)) if cohort == 1


*Create simple age gender model
stcox logage gender, nohr
predict xb_simple, xb


gen agebeta2 = agemean*4.87973
gen genderbeta2 = gendermean*0.5469726

gen xbmean2 = agebeta2+genderbeta2

gen prob_simple = 1 - (0.9713^exp(xb_simple - xbmean2)) if cohort == 1



drop if cohort == 0


merge 1:1 n_eid using "C:\Users\mczsfw\OneDrive - The University of Nottingham\UK Bio Bank\Machine Learning\rf_complete.dta"

drop _merge

merge 1:1 n_eid using "C:\Users\mczsfw\OneDrive - The University of Nottingham\UK Bio Bank\Machine Learning\dl_complete.dta"

save "C:\Users\mczsfw\OneDrive - The University of Nottingham\UK Bio Bank\Machine Learning\validation_cohort_fullpred.dta", replace


use "C:\Users\mczsfw\OneDrive - The University of Nottingham\UK Bio Bank\Machine Learning\validation_cohort_fullpred.dta", clear


*Testing over all predictive accuracy*
*Optimal Hazard Model*
somersd death  prob_mort, transf(c) tdist

*Optimal deep learning model
somersd death dl_prob, transf(c) tdist

*Optimal random forest model
somersd death rf_prob, transf(c) tdist

*Simple age/gender model
somersd death prob_simple, transf(c) tdist

*generate rocs no boot strap
quietly rocreg death rf_prob, nobootstrap
rename _roc_rf_prob roc_rf_prob 
rename _fpr_rf_prob fpr_rf_prob

*generate rocs no boot strap
quietly rocreg death dl_prob, nobootstrap
rename _roc_dl_prob roc_dl_prob 
rename _fpr_dl_prob fpr_dl_prob			

*generate rocs no boot strap
quietly rocreg death prob_mort, nobootstrap
rename _roc_prob_mort roc_prob_mort
rename _fpr_prob_mort fpr_prob_mort			

*generate rocs no boot strap
quietly rocreg death prob_simple, nobootstrap
rename _roc_prob_simple roc_prob_simple
rename _fpr_prob_simple fpr_prob_simple			

			
*Generate ROC curves for validation cohort
twoway (line roc_rf_prob fpr_rf_prob, sort lcolor(green) lwidth(thin)) ///
(function y = x, ra(roc_rf_prob) clpat(dash) lcolor(black) lwidth(thin)), ///
xline(0, lstyle(grid) lcolor(white)) xlabel(,labsize(small) grid glcolor(white)) ylabel(, labsize(small) angle(h) glcolor(white)) ///
plotregion(color(gs14)) graphregion(color(white)) xscale(lcolor(gs14)) yscale(lcolor(gs14)) ///
ytitle("True positive rate", size(small)) xtitle("False positive rate", size(small)) xsize(6) ysize(6) ///
legend(region(lwidth(none)) subtitle("Area Under ROC (c-statistic)", size(vsmall) style(bold)) col(1) order(1 "Random Forest = 0.783")  size(vsmall) ring(0) position(4))

*Generate ROC curves for validation cohort
twoway (line roc_rf_prob fpr_rf_prob, sort lcolor(green) lwidth(thin)) ///
(line roc_dl_prob fpr_dl_prob, sort lcolor(blue) lwidth(thin)) ///
(function y = x, ra(roc_rf_prob) clpat(dash) lcolor(black) lwidth(thin)), ///
xline(0, lstyle(grid) lcolor(white)) xlabel(,labsize(small) grid glcolor(white)) ylabel(, labsize(small) angle(h) glcolor(white)) ///
plotregion(color(gs14)) graphregion(color(white)) xscale(lcolor(gs14)) yscale(lcolor(gs14)) ///
ytitle("True positive rate", size(small)) xtitle("False positive rate", size(small)) xsize(6) ysize(6) ///
legend(region(lwidth(none)) subtitle("Area Under ROC (c-statistic)", size(vsmall) style(bold)) col(1) order(1 "Random Forest = 0.783" 2 "Deep Learning = 0.790")  size(vsmall) ring(0) position(4))

*Generate ROC curves for validation cohort
twoway (line roc_rf_prob fpr_rf_prob, sort lcolor(green) lwidth(thin)) ///
(line roc_dl_prob fpr_dl_prob, sort lcolor(blue) lwidth(thin)) ///
(line roc_prob_mort fpr_prob_mort, sort lcolor(orange) lwidth(thin)) ///
(function y = x, ra(roc_rf_prob) clpat(dash) lcolor(black) lwidth(thin)), ///
xline(0, lstyle(grid) lcolor(white)) xlabel(,labsize(small) grid glcolor(white)) ylabel(, labsize(small) angle(h) glcolor(white)) ///
plotregion(color(gs14)) graphregion(color(white)) xscale(lcolor(gs14)) yscale(lcolor(gs14)) ///
ytitle("True positive rate", size(small)) xtitle("False positive rate", size(small)) xsize(6) ysize(6) ///
legend(region(lwidth(none)) subtitle("Area Under ROC (c-statistic)", size(vsmall) style(bold)) col(1) order(1 "Random Forest = 0.783" 2 "Deep Learning = 0.790" 3 "Hazard Model = 0.751")  size(vsmall) ring(0) position(4))


*Generate ROC curves for validation cohort
twoway (line roc_rf_prob fpr_rf_prob, sort lcolor(green) lwidth(thin)) ///
(line roc_dl_prob fpr_dl_prob, sort lcolor(blue) lwidth(thin)) ///
(line roc_prob_mort fpr_prob_mort, sort lcolor(orange) lwidth(thin)) ///
(line roc_prob_simple fpr_prob_simple, sort lcolor(maroon) lwidth(thin)) ///
(function y = x, ra(roc_rf_prob) clpat(dash) lcolor(black) lwidth(thin)), ///
xline(0, lstyle(grid) lcolor(white)) xlabel(,labsize(small) grid glcolor(white)) ylabel(, labsize(small) angle(h) glcolor(white)) ///
plotregion(color(gs14)) graphregion(color(white)) xscale(lcolor(gs14)) yscale(lcolor(gs14)) ///
ytitle("True positive rate", size(small)) xtitle("False positive rate", size(small)) xsize(6) ysize(6) ///
legend(region(lwidth(none)) subtitle("Area Under ROC (c-statistic)", size(vsmall) style(bold)) col(1) order(1 "Random Forest = 0.783" 2 "Deep Learning = 0.790" 3 "Adjusted Cox Model = 0.751" 4 "Age/Gender Cox Model = 0.689")  size(vsmall) ring(0) position(4))

*Calibration*
logit death dl_prob
estat gof, g(20) table

logit death rf_prob
estat gof, g(20) table

logit death prob_mort
estat gof, g(20) table


*Sensitivity/Specificity Deep learning
xtile dl_cat = dl_prob, nq(4)
sort dl_cat
by dl_cat: sum dl_prob, detail

*probability greater than corresponds to 4th quantile
recode dl_cat 0/3 = 0 4=1
diagt death dl_cat


*Sensitivity/Specificity Random forest
xtile rf_cat = rf_prob, nq(4)
sort rf_cat
by rf_cat: sum rf_prob, detail

*probability greater than corresponds to 4th quantile
recode rf_cat 0/3 = 0 4=1
diagt death rf_cat



*Sensitivity/Specificity adjusted cox model
xtile prob_cat = prob_mort, nq(4)
sort prob_cat
by prob_cat: sum prob_mort, detail

*probability greater than corresponds to 4th quantile
recode prob_cat 0/3 = 0 4=1
diagt death prob_cat


*Sensitivity/Specificity adjusted cox model
xtile simple_cat = prob_simple, nq(4)
sort simple_cat
by simple_cat: sum prob_simple, detail

*probability greater than corresponds to 4th quantile
recode simple_cat 0/3 = 0 4=1
diagt death simple_cat



*Calibration plots

egen dl_5 = cut(dl_prob), at(0(0.05)1)
hl death dl_prob, q(dl_5) plot
graph save dl, replace

egen rf_5 = cut(rf_prob), at(0(0.05)1)
hl death rf_prob, q(rf_5) plot
graph save rf, replace

egen prob_5 = cut(prob_mort), at(0(0.05)1)
hl death prob_mort, q(prob_5) plot
graph save Cox_full, replace

egen simple_5 = cut(prob_simple), at(0(0.05)1)
hl death prob_simple, q(simple_5) plot
graph save Cox_simple, replace

graph combine dl.gph rf.gph Cox_full.gph Cox_simple.gph


*histogram plot

hist dl_prob
graph save dl_hist

hist rf_prob
graph save rf_hist

hist prob_mort
graph save mort_hist

hist prob_simple
graph save simple_hist

graph combine dl_hist.gph rf_hist.gph mort_hist.gph simple_hist.gph
