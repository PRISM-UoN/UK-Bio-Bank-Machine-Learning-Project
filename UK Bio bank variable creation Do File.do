************This do file will create all the necessary variables and label them for the analysis************


*Gender*
rename n_31_0_0 gender

*Age*
rename n_21022_0_0 baselineage

*Years of Birth*
rename n_34_0_0 birthyear

*Month of Birth*
rename n_52_0_0 birthmonth

*Qualification*
rename n_6138_0_0 education
recode education -7=0 -3=7 .=7
label define educationL 0 "none" 1 "College/University" 2 "A/AS Levels/Equivalent" 3 "O Levels/GCSEs/Equivalent" 4 "CSEs/Equivalent" 5 "NVQ/HND/HNC/Equivalent" 6 "Other professional qual" 7 "Unknown"
label values education educationL

*Deprivation*
rename n_189_0_0 townsend

*Baseline Cohort Start Date*
rename ts_53_0_0 startdate

*Death Date*
gen deathdate = ts_40000_0_0 
replace deathdate =  ts_40000_1_0 if deathdate ==.
replace deathdate = ts_40000_2_0 if deathdate ==.
format deathdate %d
label var deathdate "date of death"

*Ethnicity*
gen ethnicity = 1 if inlist(n_21000_0_0,1,1001,1002,1003) 
replace ethnicity = 2 if inlist(n_21000_0_0,3,3001,3002,3003,3004)
replace ethnicity = 3 if inlist(n_21000_0_0,5)
replace ethnicity = 4 if inlist(n_21000_0_0,4,4001,4002,4003)
replace ethnicity = 5 if inlist(n_21000_0_0,2,6,2001,2002,2003,2004)
replace ethnicity = 6 if ethnicity ==.

label var ethnicity "ethnic group"
label define ethnicityL 1 "white" 2 "south asian" 3 "east asian" 4 "black" 5 "other/mixed" 6 "unknown"
label values ethnicity ethnicityL


*Family history of....*

*Breast Cancer*
gen famhistBC = 1 if n_20110_0_0 == 5 | n_20111_0_0 == 5
replace famhistBC = 0 if famhistBC == . 
label var famhistBC "1st degree relative ever had breast cancer"
label define famhistL 0 "no" 1 "yes"
label values famhistBC famhistL

*Prostate Cancer*
gen famhistPC = 1 if n_20107_0_0 == 13 | n_20111_0_0 == 13
replace famhistPC = 0 if famhistPC ==.
label var famhistPC "1st degree relative had prostate cancer"
label values famhistPC famhistL 

*Lung Cancer*
gen famhistLC = 1 if n_20110_0_0 == 3 | n_20107_0_0 == 3 | n_20111_0_0 == 3
replace famhistLC = 0 if famhistLC ==.
label var famhistLC "1st degree relative ever had lung cancer"
label values famhistLC famhistL

*Colorectal/Bowel Cancer*
gen famhistCC = 1 if n_20110_0_0 == 4 | n_20107_0_0 == 4 | n_20111_0_0 == 4
replace famhistCC = 0 if famhistCC ==.
label var famhistCC "1st degree relative ever had colorectal cancer"
label values famhistCC famhistL

*Specifically Mother Had Breast Cancer*
gen famhistMBC = 1 if n_20110_0_0 == 5 
replace famhistMBC = 0 if famhistBC == . 
label var famhistMBC "mother had breast cancer"
label values famhistMBC famhistL

*Biometrics*
*Weight*
rename n_21002_0_0 weight
label var weight "weight in kilograms" //missing values exist - consider imputation

*Height*
rename n_50_0_0 height
label var height "height in cm" //missing values exist - consider imputation

*Body Mass Index*
rename n_21001_0_0 bmi
label var bmi "body mass index kg/m^2" //missing values exist - consider imputation

*Waist Girth*
rename n_48_0_0 waist
label var waist "waist circumference cm" //missing values exist - consider imputation

*Body Fast Percentage*
rename n_23099_0_0 bodyfat //missing values exist - consider imputation
label var bodyfat "body fat %"

*Blood Pressure*

*Diastolic Blood Pressure*
rename n_4079_0_0 diabp //missing values exist - consider imputation
label var diabp "diastolic blood pressure mm HG"

*Systolic Blood Pressure*
rename n_4080_0_0 sysbp  //missing values exist - consider imputation
label var sysbp "systolic blood pressure mm HG"

*Forced Expiratory"
rename n_3063_0_0 fev1 //missing values exist - consider imputation
label var fev1 "forced expiratory volume L/1 sec"

*Lifestyle*

*Physical activity - use the IPAQ scoring guidelines*

*Walking MET-min/week - use median time of each category*
gen walkperday = 7.5 if n_981_0_0 == 1
replace walkperday = 22.5 if n_981_0_0 == 2
replace walkperday = 45 if n_981_0_0 == 3
replace walkperday = 75 if n_981_0_0 == 4
replace walkperday = 105 if n_981_0_0 == 5
replace walkperday = 150 if n_981_0_0 == 6
replace walkperday = 210 if n_981_0_0 == 7
label var walkperday "walking minutes per day"

*Frequency of Walking (no days per week) - use median time of each category*
gen walkperweek = 0.25 if n_971_0_0 == 1
replace walkperweek = 0.625 if n_971_0_0 == 2
replace walkperweek = 1 if n_971_0_0 == 3
replace walkperweek = 2.5 if n_971_0_0 == 4
replace walkperweek = 4.5 if n_971_0_0 == 5
replace walkperweek = 7 if n_971_0_0 == 6
label var walkperweek "walking days per week"

*Calculate walking MET-min/week*
gen walkMETmin = 3.3 * walkperday * walkperweek
label var walkMETmin "MET-min per week walking"

*Moderate exercise MET-min/week*
gen modperday = n_894_0_0 if n_894_0_0 >= 0
label var modperday "moderate exercise minutes per day"

*Frequency of moderate exercise (no days per week)*
gen modperweek =  n_884_0_0 if  n_884_0_0 >= 0
label var modperweek "moderate exercise days per week"

*Calculate moderate exercise MET-min/week*
gen modMETmin = 4.0 * modperday * modperweek
label var modMETmin "MET-min per week moderate exercise"

*Vigorous exercise MET-min/week*
gen vigperday = n_914_0_0 if n_914_0_0 >= 0
label var vigperday "vigorous exercise minutes per day"

*Frequency of vigorous exercise (no days per week)*
gen vigperweek = n_904_0_0 if n_904_0_0 >= 0
label var vigperweek "vigorous exercise days per week"

*Calculate vigorous exercise MET-min/week*
gen vigMETmin = 8.0 * vigperday * vigperweek
label var vigMETmin "MET-min per week vigorous exercise"

****Calculate TOTAL MET-min per week*******
order modMETmin, before(vigMETmin)
order walkMETmin, before(modMETmin)
egen METmin = rowtotal(walkMETmin-vigMETmin)
label var METmin "MET-min per week total exercise" // missing values exist - consider imputation

*Current Smoking Status*
gen smoking = 0 if  n_1239_0_0 == 0 | n_1239_0_0 == -3
replace smoking = 1 if n_22507_0_0 != . 
replace smoking = 2 if n_1239_0_0 == 1 | n_1239_0_0 == 2
label var smoking "current smoking status"
label define smokingL 0 "never smoker" 1 "ex-smoker" 2 "current smoker"
label values smoking smokingL
recode smoking .=0

*Cigarettes Per Day*
gen cigperday = n_3456_0_0 if smoking == 2    //missing values exist - consider imputation
replace cigperday = 0 if smoking == 0 | smoking == 1
replace cigperday = . if cigperday < 0
label var cigperday "if smoking, number of cig per day"

*Aged Stopped Smoking Cigarettes*
gen stopsmoke = baselineage - n_22507_0_0 
label var stopsmoke "intermediate var: baseline age - age stopped smoking"
gen agestop = 1 if stopsmoke < 5
replace agestop = 2 if stopsmoke >= 5 & stopsmoke <= 10
replace agestop = 3 if stopsmoke > 10 & stopsmoke !=.
label var agestop "how long ago did you quit smoking in years"
label define stopL 1 "< 5 years" 2 " between 5-10 years" 3 "> 10 years"
label values agestop stopL  

*Combine Current Smoking with Ex-smoking duration for protective effects*
gen smokingstatus = 0 if smoking == 2
replace smokingstatus = agestop if smokingstatus ==.
replace smokingstatus = 4 if smoking == 0
label var smokingstatus "complete smoking status"
label define statusL 0 "current smoker" 1 "ex-smoker < 5 years" 2 "ex-smoker between 5-10 years" 3 "ex-smoker > 10 years" 4 "never smoker"
label values smokingstatus statusL
recode smokingstatus .=4

*Environmental tobacco smoke*
replace n_1279_0_0 = . if n_1279_0_0 < 0
replace n_1269_0_0  = . if n_1269_0_0 < 0
order n_1279_0_0, after(n_1269_0_0)
egen ets = rowtotal(n_1269_0_0-n_1279_0_0)
gen etsdummy = ets
recode etsdummy 0=. 1=.
xtile etsmoke = etsdummy, nq(4)
recode etsmoke 1=2 2=3 3=4 4=5
replace etsmoke = 1 if ets == 1
replace etsmoke = 0 if ets == 0 
label var etsmoke "environmental tobacco exposures"
label define etsL 0 "never" 1 "rarely" 2 "ocassionally" 3 "most days" 4 "one of twice a day" 5 "frequently through the day"
label values etsmoke etsL

label var ets "intermediate var: environmental tobacco smoke combined"
label var etsdummy "intermediate var: dummy variable for ets" 

*Beta-Carotene*
gen carotene = 0
forval i=0/29 {
replace carotene = 1 if n_20003_0_`i' == 1140911728
}
label var carotene "currently taking beta-carotene"
label define caroteneL 0 "no" 1 "yes"
label values carotene caroteneL


*Vitamins and supplements*
rename n_6155_0_0 vitamin
recode vitamin -3=9 -7=9 .=9 7 = 8
label define noneL 0 "none" 1 "Vit A" 2 "Vit B" 3 "Vit C" 4 "Vit D" 5 "Vit E" 6 "Vit B9 (Folic Acid)" 7 "Calcium" 8 "Multivitamins/minerals" 9 "unknown"
label values vitamin noneL
label var vitamin "daily vitamins intake"

*Calcium*
gen calcium = 0
forval i=0/29 {
replace calcium = 1 if n_20003_0_`i' == 1140852948
}
label var calcium "currently taking calcium supplements"
label define calciumL 0 "no" 1 "yes"
label values calcium calciumL

*Combine calcium with vitamins field*
replace vitamin = 7 if calcium == 1


*Alcohol intake*
gen alcohol = 0 if  n_1558_0_0 == 6
replace alcohol = 1 if  n_1558_0_0 == 5
replace alcohol = 2 if  n_1558_0_0 == 4
replace alcohol = 3 if  n_1558_0_0 == 3
replace alcohol = 4 if  n_1558_0_0 == 2
replace alcohol = 5 if  n_1558_0_0 == 1
replace alcohol = 6 if  n_1558_0_0 == -3
replace alcohol = 6 if  n_1558_0_0 ==.
label var alcohol "alcohol intake frequency"
label define alcoholL 0 "never" 1 "special occasions only" 2 "1-3 times per month" 3 "1-3 times per week" 4 "3-4 times per week" 5 "daily or almost daily" 6 "unknown"
label values alcohol alcoholL

*Night shift work*
gen nights = 5 if n_3426_0_0 == -3 | n_3426_0_0 == -1 
replace nights = 0 if n_3426_0_0 == .
replace nights = 1 if n_3426_0_0 == 1
replace nights = 2 if n_3426_0_0 == 2
replace nights = 3 if n_3426_0_0 == 3
replace nights = 4 if n_3426_0_0 == 4
label var nights "job requires night shift work"
label define nightsL 0 "never" 1 "rarely" 2 "sometimes" 3 "usually" 4 "always" 5 "unknown"
label values nights nightsL

*Diet*
*Fruit*
gen dried = n_1319_0_0
gen fresh = n_1309_0_0
recode dried -10 = 0.5 -3=. -1=.
recode fresh -10 = 0.5 -3=. -1=.
egen fruitpieces = rowtotal(dried-fresh)
replace fruitpieces = . if fruitpieces == 0
xtile fruit = fruitpieces, nq(3)
recode fruit .= 0 if n_1319_0_0 == 0 & n_1309_0_0 == 0
recode fruit .=4
label var fruit "portions of fruit per day"
label define portionL 0 "never/rarely" 1 "1-2 portions" 2 "3-4 portions" 3 "5 or more portions" 4 "unknown"
label values fruit portionL

*Vegetables*
gen salad = n_1299_0_0
gen cooked = n_1289_0_0
recode salad  -10 = 0.5 -3=. -1=.
recode cooked  -10 = 0.5 -3=. -1=.
egen vegpieces = rowtotal(salad-cooked)
replace vegpieces = . if vegpieces == 0
xtile veg = vegpieces, nq(3)
recode veg .=0 if n_1299_0_0 == 0 & n_1289_0_0 ==0
recode veg .=4
label var veg "portions of vegetables per day"
label values veg portionL

*Tomatoes*
gen live = 0.5 if n_104340_0_0 == 555
replace live = 0.25 if n_104340_0_0 == 444
replace live = 3 if n_104340_0_0 == 300
replace live = 2 if  n_104340_0_0 == 2
replace live = 1 if  n_104340_0_0 == 1

gen tin = 0.5 if n_104350_0_0 == 555
replace tin = 0.25 if n_104350_0_0 == 444
replace tin = 3 if n_104350_0_0 == 300
replace tin = 2 if n_104350_0_0 == 2
replace tin = 1 if n_104350_0_0 == 1

egen dailytomato = rowtotal(live-tin)
replace dailytomato =. if dailytomato == 0
xtile tomato = dailytomato, nq(5)
recode tomato .=0
label var tomato "portions of tomato intake"
label define dietL 0 "never" 1 "less than once per week" 2 "once a week" 3 "2-4 times per week" 4 "5-6 times per week" 5 "once or more daily" 6 "unknown"
label values tomato dietL

*Red Meat*
gen beef = n_1369_0_0 
replace beef = . if n_1369_0_0 < 0

gen pork = n_1389_0_0 
replace pork = . if n_1389_0_0 < 0

gen redmeat = 0 if pork == 0 & beef == 0
replace redmeat = 1 if pork == 1 | beef == 1
replace redmeat = 2 if pork == 2 | beef == 2
replace redmeat = 3 if pork == 3 | beef == 3
replace redmeat = 4 if pork == 4 | beef == 4
replace redmeat = 5 if pork == 5 | beef == 5
replace redmeat = 6 if redmeat ==.
label var redmeat "portions of red meat"
label values redmeat dietL

*Processed Meat*
gen processmeat =  n_1349_0_0 
replace processmeat = 6 if  n_1349_0_0 < 0
replace processmeat = 6 if  n_1349_0_0 ==.
label var processmeat "portions of processed meat"
label values processmeat dietL

*Fibre - use cereals to proxy*
gen cereal = n_1458_0_0
recode cereal -10 = 0.5 -3=. -1=.
replace cereal =. if cereal == 0
xtile fibre = cereal, nq(5)
recode fibre .=0 if n_1458_0_0 == 0
recode fibre .=6
label var fibre "portions of fibre intake"
label values fibre dietL

*Unhealthy fats - use cheese as proxy as contains high saturated fats*
gen cheese =  n_1408_0_0
recode cheese -3=6 -1=6 .=6
label var cheese "portions of cheese (proxy for unheathy saturated fats)"
label values cheese dietL

*Salt (added to food)*
gen salt = n_1478_0_0
recode salt -3 = 5
recode salt .=5
label var salt "how often salt added to food"
label define saltL 1 "never/rarely" 2 "sometimes" 3 "usually" 4 "always" 5 "unknown"
label values salt saltL 

*Calcium sources - food and drinks (proxy with type of milk used)*
gen milk = 0 if n_1418_0_0 == 6
replace milk = 1 if n_1418_0_0 == 5
replace milk = 2 if n_1418_0_0 == 4
replace milk = 3 if n_1418_0_0 == 3
replace milk = 4 if n_1418_0_0 == 2
replace milk = 5 if n_1418_0_0 == 1
replace milk = 6 if n_1418_0_0 == -1 | n_1418_0_0 == -3 | n_1418_0_0 ==.
label var milk "milk type used (proxy for calcium)"
label define milkL 0 "never/rarely used milk" 1 "other types of milk" 2 "soya" 3 "skimmed" 4 "semi-skimmed" 5 "full cream" 6 "unknown"
label values milk milkL

*Vitamin D consumption (use oily fish to proxy)*
gen fish = n_1329_0_0
recode fish -3=6 -1=6 .=6
label var fish "portions of fish (proxy for Vit D)"
label values fish dietL


*Sunburn History*
gen burn = n_1737_0_0 
replace burn = . if burn <= 0
xtile sunburn = burn, nq(5)
replace sunburn = 0 if n_1737_0_0 == 0
replace sunburn = 6 if n_1737_0_0  == -3 | n_1737_0_0  == -1 
replace sunburn = 6 if sunburn ==.
label var sunburn "history of sunburn"
label define sunburnL 0 "never" 1 "rarely" 2 "occasionally mildy" 3 "occasionally significant" 4 "frequent mildly" 5 "frequently significant" 6 "unknown"
label values sunburn sunburnL

*Sunscreen use*
gen sunscreen = n_2267_0_0 
recode sunscreen 5=1 -3=5 -1=5 .=5
label var sunscreen "use of sun/uv protection"
label values sunscreen saltL

*Tanning device*
gen tanning = n_2277_0_0
recode tanning -10= 1 1/2 = 1 3/5 = 2 6/10 = 3 11/15 = 4 16/20 = 5 21/max = 6 -3=7 -1=7 .=7
label var tanning "use of tanning device/sunbed"
label define tanningL 0 "never" 1 "1-2 twice a year" 2 "3-5 times a year" 3 "6-10 times a year" 4 "11-15 times a year" 5 "16-20 times a year" 6 "> 20 times a year" 7 "unknown"
label values tanning tanningL

*Air Pollution (air pollution ppm)*
xtile pollution = n_24005_0_0, nq(5)
recode pollution .=6
label var pollution "air pollution (quintiles of PPM)"
label define pollutionL 1 "low" 2 "low-moderate" 3 "moderate" 4 "moderate-high" 5 "high" 6 "unknown"
label values pollution pollutionL

*High altitude exposure (aircraft crew)*
gen altitude = 1 if n_22617_0_0 == 3512 | n_22617_0_0 == 6214 | n_22617_0_0 == 3311
replace altitude = 0 if altitude ==.
label var altitude "high altitude exposure from work (aircraft crew)"
label define altitudeL 0 "no/unknown" 1 "yes"
label values altitude altitudeL

*Occupational exposures*
* n_22612_0_0 - asbestos*
* n_22609_0_0 - workplace dust*
* n_22610_0_0 - chemicals/fumes*
* n_22615_0_0 - diesel exhaust*
* n_22613_0_0 - paint/thinners*
* n_22614_0_0 - pesticides*

gen jobexp = 1 if n_22612_0_0 == 0 & n_22609_0_0 == 0 & n_22610_0_0  == 0 & n_22615_0_0 == 0 & n_22613_0_0 == 0 & n_22614_0_0 == 0
replace jobexp = 4 if n_22612_0_0 == -121 & n_22609_0_0 == -121 & n_22610_0_0  == -121 & n_22615_0_0 == -121 & n_22613_0_0 == -121 & n_22614_0_0 == -121
replace jobexp = 2 if n_22612_0_0 == -131 | n_22609_0_0 == -131 | n_22610_0_0  == -131 | n_22615_0_0 == -131 | n_22613_0_0 == -131 | n_22614_0_0 == -131
replace jobexp = 3 if n_22612_0_0 == -141 | n_22609_0_0 == -141 | n_22610_0_0  == -141 | n_22615_0_0 == -141 | n_22613_0_0 == -141 | n_22614_0_0 == -141
replace jobexp = 0 if jobexp ==.
label var jobexp "job exposure to various hazardous materials"
label define jobexpL 0 "non hazardous occupation" 1 "never/rarely" 2 "sometimes" 3 "often" 4 "unknown"
label values jobexp jobexpL

*Skin Colour*
gen skin = n_1717_0_0 
recode skin -3=7 -1=7 .=7
label var skin "skin colour/tone"
label define skinL 1 "very fair" 2 "fair" 3 "light olive" 4 "dark olive" 5 "brown" 6 "black" 7 "unknown"
label values skin skinL

*Ease of Skin Tanning*
gen darken =  n_1727_0_0 
recode darken -3=5 -1=5 .=5
label var darken "ease of skin tanning"
label define darkenL 1 "get very tanned" 2 "get moderately tanned" 3 "get mildly or occasionally tanned" 4 "never tan, only burn" 5 "unknown"
label values darken darkenL

*H. Pylori Infection*
gen hpylori = 0
forval i=0/28 {
replace hpylori = 1 if n_20002_0_`i' == 1442
}  
label var hpylori "previously had h. pylori infection"
label define hpyloriL 0 "no" 1 "yes"
label values hpylori hpyloriL

*Aspirin*
gen aspirin = 0
forval i=0/29 {
replace aspirin = 1 if n_20003_0_`i' == 1140868226 
}
label var aspirin "currently taking aspirin"
label define aspirinL 0 "no" 1 "yes"
label values aspirin aspirinL

*Warfarin*
gen warfarin = 0
forval i=0/29 {
replace warfarin = 1 if  n_20003_0_`i' == 1140888266
}
label var warfarin "currently taking warfarin"
label values warfarin aspirinL

*Digoxin*
gen digoxin = 0
forval i=0/29 {
replace digoxin = 1 if  n_20003_0_`i' == 2038459814
}
label var digoxin "currently taking digoxin"
label values digoxin aspirinL

*Metformin*
gen metformin = 0
forval i=0/29 {
replace metformin = 1 if  n_20003_0_`i' == 1140884600
}
label var metformin "currently taking metformin"
label values metformin aspirinL

*Radiotherapy*
gen radiotherapy = 0 
forval i = 0/31 {
replace radiotherapy = 1 if n_20004_0_`i' == 1228
}

label var radiotherapy "thyroid radioablation therapy"
label define radiotherapyL 0 "no" 1 "yes"
label values radiotherapy radiotherapyL

*Menopause*
gen menopause = 0
forval i = 0/31 {
replace menopause = 1 if n_20004_0_`i' == 1665
}

label var menopause "menopause/menopausal symptoms"
label define menopauseL 0 "no" 1 "yes"
label values menopause menopauseL


*Oral contraceptive*
gen contra = 1 if n_6153_0_0 == 5
replace contra = 0 if contra ==.
label var contra "currently on oral contraceptive pill"
label values contra aspirinL

*Hormone replacement therapy*
gen hrt = 1 if n_6153_0_0 == 4
replace hrt = 0 if hrt ==.
label var hrt "currently on hormone replacement therapy"
label values hrt aspirinL

*Lipid Lowering Drugs*
gen statins = 1 if n_6153_0_0 == 1
replace statins = 0 if statins ==.
label var statins "currently taking statins"
label values statins aspirinL

*Blood Pressure Treatment*
gen bptreat = 1 if n_6153_0_0 == 2
replace bptreat = 0 if bptreat ==.
label var bptreat "currently on anti-hypertensives"
label values bptreat aspirinL

*Co-mordities*
*Breast Disease (non-cancer)*
gen brdisease = 0
forval i=0/28 {
replace brdisease = 1 if n_20002_0_`i' == 1364
}  
label var brdisease "previously diagnosed breast disease"
label values brdisease aspirinL

*Hyperplasia*
gen plasia = 0 
forval i=0/28 {
replace plasia = 1 if n_20002_0_`i' == 1554 | n_20002_0_`i' == 1230
}  
label var plasia "previouly diagnosed atypical hyperplasia"
label values plasia aspirinL

*Coeliac disease*
gen coeliac = 0
forval i=0/28 {
replace coeliac = 1 if n_20002_0_`i' == 1456
}  
label var coeliac "previously diagnosed coeliac disease"
label values coeliac aspirinL

*Thyroiditis*
gen thyroid = 0 
forval i=0/28 {
replace thyroid = 1 if n_20002_0_`i' == 1428
}  
label var thyroid "previously diagnosed thyroiditis"
label values thyroid aspirinL

*Diabetes*
gen diabetes = n_2443_0_0
recode diabetes -3 = 0 -1 =0
label var diabetes "previously diagnosed with diabetes"
label values diabetes aspirinL

*Polyps*
gen polyps = 0 
forval i=0/28 {
replace polyps = 1 if n_20002_0_`i' == 1352 | n_20002_0_`i' == 1460 |   n_20002_0_`i' == 1555
}  
label var polyps "previously diagnosed with polyps"
label values polyps aspirinL

*Ulcerative collitis or Crohns*
gen crohns = 0
forval i=0/28 {
replace crohns = 1 if n_20002_0_`i' == 1463 | n_20002_0_`i' == 1462
}  
label var crohns "previously diagnosed with crohns/ulcerative colitis"
label values crohns aspirinL

*Acid reflux*
gen reflux = 0 
forval i=0/28 {
replace reflux = 1 if n_20002_0_`i' == 1138
}  
label var reflux "previously diagnosed with gastro reflux"
label values reflux aspirinL

*Prostatitis*
gen prostate = 0
forval i=0/28 {
replace prostate = 1 if n_20002_0_`i' == 1517 | n_20002_0_`i' == 1396
}  
label var prostate "previously diagnosed with prostatitis"
label values prostate aspirinL


label define diagL 0 "no" 1 "yes"



label var dried "intermediate variable"
label var fresh "intermediate variable"
label var salad "intermediate variable"
label var cooked "intermediate variable"
label var vegpieces "intermdiate variable"
label var fruitpieces "intermediate variable"
label var live "intermdiate variable"
label var tin "intermediate variable"
label var dailytomato "intermediate variable"
label var beef "intermediate var: beef consumed"
label var pork "intermediate var: pork consumed"
label var cereal "intermediate variable"
label var burn "intermediate variable"


*Determine earliest age of cancer diagnosis* 
 egen minagecancer = rowmin(n_40008_0_0-n_40008_31_0)
 label var minagecancer "earliest age of any cancer diagnosis"
 gen priorcancer = 1 if minagecancer < baselineage & minagecancer !=.
 recode priorcancer .=0
 label var priorcancer "individuals with prior history of cancer - these will need to be dropped for the morbidity models (keep for mortality model as basline var)"
 label define priorL 0 "none" 1 "had disease before cohort start date"
 label values priorcancer priorL
 
 
*Determine earliest age of previous disease*
forval i = 0/2 {
*angina*
replace n_3627_`i'_0  = . if  n_3627_`i'_0 < 0
*heart attack*
replace n_3894_`i'_0 = . if n_3894_`i'_0 < 0
*stroke*
replace n_4056_`i'_0 = . if n_4056_`i'_0 < 0
*diabetes*
replace n_2976_`i'_0 = . if n_2976_`i'_0 < 0
*copd*
replace n_3992_`i'_0 = . if n_3992_`i'_0 < 0
}

*prior heart disease*
order n_3894_0_0, after(n_3627_2_0)
order n_3894_2_0, after(n_3894_0_0)
egen minagechd = rowmin(n_3627_0_0-n_3894_2_0)
gen priorchd = 1 if minagechd < baselineage & minagechd !=.
recode priorchd .=0
label var priorchd "individuals with prior history of chd - will need dropping for morbidity models (keep for mortality model)"
label values priorchd priorL

*prior stroke*
egen minagestroke = rowmin(n_4056_0_0-n_4056_2_0)
gen priorstroke = 1 if minagestroke < baselineage & minagestroke !=.
recode priorstroke .=0
label var priorstroke "individuals with prior history of stroke - will need dropping for morbidity models (keep for mortality model)"
label values priorstroke priorL

*diabetes*
egen minagediabetes = rowmin(n_2976_0_0-n_2976_2_0)
gen priordiabetes = 1 if minagediabetes < baselineage & minagediabetes !=.
recode priordiabetes .=0
label var priordiabetes "individuals with prior history of diabetes - will need dropping for morbidity models (keep for mortality model)"
label values priordiabetes priorL

*copd*
egen minagecopd = rowmin(n_3992_0_0-n_3992_2_0)
gen priorcopd = 1 if minagecopd < baselineage & minagecopd !=.
recode priorcopd .=0
label var priorcopd "individuals with prior history of diabetes - will need dropping for morbidity models (keep for mortality model)"
label values priorcopd priorL



*prior dementia*
forval i = 0/28 {
replace n_20009_0_`i' = . if n_20009_0_`i' < 0
}

gen dem = 0
gen agedem = .
forval i=0/28 {
replace dem = 1 if n_20002_0_`i' == 1263
	forval k=0/28 {
	replace agedem = n_20009_0_`k' if dem == 1 & n_20009_0_`k' < n_20009_0_`k-1'
	}
}

drop dem 
gen priordem = 1 if agedem < baselineage 
recode priordem .=0 
label var priordem "individuals with prior history of dementia"
label values priordem priorL





*****Morbidity***

*Primary diagnoses - ICD 10*

*heart disease
gen hd_diag=.
local namelist "morbidity"
        foreach name of local namelist { 
             forval s1=0/379 {
					if "`name'"=="morbidity" {
							recode hd_diag .=1 if strpos(s_41202_0_`s1', "I20") | strpos(s_41202_0_`s1', "I21") ///
							| strpos(s_41202_0_`s1', "I22") | strpos(s_41202_0_`s1', "I23") ///
							| strpos(s_41202_0_`s1', "I24") | strpos(s_41202_0_`s1', "I25") ///

							
}
}              
}


recode hd_diag .=0
label var hd_diag "primary - coronary heart disease"
label values hd_diag diagL


*cerebrovascular diseases*
gen stroke_diag=.
local namelist "morbidity"
        foreach name of local namelist { 
             forval s1=0/379 {
					if "`name'"=="morbidity" {
							recode stroke_diag .=1 if strpos(s_41202_0_`s1', "I60") | strpos(s_41202_0_`s1', "I61") ///
							| strpos(s_41202_0_`s1', "I62") | strpos(s_41202_0_`s1', "I63") ///
							| strpos(s_41202_0_`s1', "I64") | strpos(s_41202_0_`s1', "I65") ///
							| strpos(s_41202_0_`s1', "I66") | strpos(s_41202_0_`s1', "I67") ///
							| strpos(s_41202_0_`s1', "I68") | strpos(s_41202_0_`s1', "I69")

							
}
}              
}

recode stroke_diag .=0
label var stroke_diag "primary - cerebrovascular disease"
label values stroke_diag diagL



*diabetes
gen dia_diag=.
local namelist "morbidity"
        foreach name of local namelist { 
             forval s1=0/379 {
					if "`name'"=="morbidity" {
							recode dia_diag .=1 if strpos(s_41202_0_`s1', "E10") | strpos(s_41202_0_`s1', "E11") ///
							| strpos(s_41202_0_`s1', "E12") | strpos(s_41202_0_`s1', "E13") ///
							| strpos(s_41202_0_`s1', "E14")
}
}              
}

recode dia_diag .=0
label var dia_diag "primary - diabetes"
label values dia_diag diagL

*respiratory disease
gen res_diag=.
local namelist "morbidity"
        foreach name of local namelist { 
             forval s1=0/379 {
					if "`name'"=="morbidity" {
							recode res_diag .=1 if strpos(s_41202_0_`s1', "J40") | strpos(s_41202_0_`s1', "J41") ///
							| strpos(s_41202_0_`s1', "J42") | strpos(s_41202_0_`s1', "J43") ///
							| strpos(s_41202_0_`s1', "J44") | strpos(s_41202_0_`s1', "J45") ///
							| strpos(s_41202_0_`s1', "J46") | strpos(s_41202_0_`s1', "J47")
}
}              
}

recode res_diag .=0
label var res_diag "primary - respiratory disease (chronic)"
label values res_diag diagL



*dementia
gen dem_diag=.
local namelist "morbidity"
        foreach name of local namelist { 
             forval s1=0/379 {
					if "`name'"=="morbidity" {
							recode dem_diag .=1 if strpos(s_41202_0_`s1', "F00") | strpos(s_41202_0_`s1', "F01") ///
							| strpos(s_41202_0_`s1', "F02")
}
}              
}

recode dem_diag .=0
label var dem_diag "primary - dementia"
label values dem_diag diagL


*cancer - prostate
gen can_pros_diag=.
local namelist "morbidity"
        foreach name of local namelist { 
             forval s1=0/379 {
					if "`name'"=="morbidity" {
							recode can_pros_diag .=1 if strpos(s_41202_0_`s1', "C61")
}
}              
}

recode can_pros_diag .=0
label var can_pros_diag "primary - prostate cancer"
label values can_pros_diag  diagL



*cancer - breast
gen can_br_diag=.
local namelist "morbidity"
        foreach name of local namelist { 
             forval s1=0/379 {
					if "`name'"=="morbidity" {
							recode can_br_diag .=1 if strpos(s_41202_0_`s1', "C50")
}
}              
}

recode can_br_diag .=0
label var can_br_diag "primary - breast cancer"
label values can_br_diag diagL


*cancer - lung
gen can_lung_diag=.
local namelist "morbidity"
        foreach name of local namelist { 
             forval s1=0/379 {
					if "`name'"=="morbidity" {
							recode can_lung_diag .=1 if strpos(s_41202_0_`s1', "C34")
}
}              
}

recode can_lung_diag .=0
label var can_lung_diag "primary - lung cancer"
label values can_lung_diag diagL


*cancer - colorectal
gen can_colo_diag=.
local namelist "morbidity"
        foreach name of local namelist { 
             forval s1=0/379 {
					if "`name'"=="morbidity" {
							recode can_colo_diag .=1 if strpos(s_41202_0_`s1', "C18") | strpos(s_41202_0_`s1', "C19") ///
							| strpos(s_41202_0_`s1', "C20") | strpos(s_41202_0_`s1', "C21")
}
}              
}

recode can_colo_diag .=0
label var can_colo_diag "primary - colorectal cancer"
label values can_colo_diag diagL

*cancer - stomach
gen can_sto_diag=.
local namelist "morbidity"
        foreach name of local namelist { 
             forval s1=0/379 {
					if "`name'"=="morbidity" {
							recode can_sto_diag .=1 if strpos(s_41202_0_`s1', "C16")
}
}              
}

recode can_sto_diag .=0
label var can_sto_diag "primary - stomach cancer"
label values can_sto_diag diagL

*cancer - skin
gen can_skin_diag=.
local namelist "morbidity"
        foreach name of local namelist { 
             forval s1=0/379 {
					if "`name'"=="morbidity" {
							recode can_skin_diag .=1 if strpos(s_41202_0_`s1', "C43") | strpos(s_41202_0_`s1', "C44")
}
}              
}

recode can_skin_diag .=0
label var can_skin_diag "primary - skin cancer"
label values can_skin_diag diagL




*secondary diagnoses - ICD 10*

*heart disease
gen hd2_diag=.
local namelist "morbidity"
        foreach name of local namelist { 
             forval s1=0/434 {
					if "`name'"=="morbidity" {
							recode hd2_diag .=1 if strpos(s_41204_0_`s1', "I20") | strpos(s_41204_0_`s1', "I21") ///
							| strpos(s_41204_0_`s1', "I22") | strpos(s_41204_0_`s1', "I23") ///
							| strpos(s_41204_0_`s1', "I24") | strpos(s_41204_0_`s1', "I25") ///

							
}
}              
}

recode hd2_diag .=0
label var hd2_diag "secondary - coronary heart disease"
label values hd2_diag diagL


*cerebrovascular diseases*
gen stroke2_diag=.
local namelist "morbidity"
        foreach name of local namelist { 
             forval s1=0/434 {
					if "`name'"=="morbidity" {
							recode stroke2_diag .=1 if strpos(s_41204_0_`s1', "I60") | strpos(s_41204_0_`s1', "I61") ///
							| strpos(s_41204_0_`s1', "I62") | strpos(s_41204_0_`s1', "I63") ///
							| strpos(s_41204_0_`s1', "I64") | strpos(s_41204_0_`s1', "I65") ///
							| strpos(s_41204_0_`s1', "I66") | strpos(s_41204_0_`s1', "I67") ///
							| strpos(s_41204_0_`s1', "I68") | strpos(s_41204_0_`s1', "I69")

							
}
}              
}

recode stroke2_diag .=0
label var stroke2_diag "secondary - cerebrovascular disease"
label values stroke2_diag diagL


*diabetes
gen dia2_diag=.
local namelist "morbidity"
        foreach name of local namelist { 
             forval s1=0/434 {
					if "`name'"=="morbidity" {
							recode dia2_diag .=1 if strpos(s_41204_0_`s1', "E10") | strpos(s_41204_0_`s1', "E11") ///
							| strpos(s_41204_0_`s1', "E12") | strpos(s_41204_0_`s1', "E13") ///
							| strpos(s_41204_0_`s1', "E14")
}
}              
}

recode dia2_diag .=0
label var dia2_diag "secondary - diabetes"
label values dia2_diag diagL


*respiratory disease
gen res2_diag=.
local namelist "morbidity"
        foreach name of local namelist { 
             forval s1=0/434 {
					if "`name'"=="morbidity" {
							recode res2_diag .=1 if strpos(s_41204_0_`s1', "J40") | strpos(s_41204_0_`s1', "J41") ///
							| strpos(s_41204_0_`s1', "J42") | strpos(s_41204_0_`s1', "J43") ///
							| strpos(s_41204_0_`s1', "J44") | strpos(s_41204_0_`s1', "J45") ///
							| strpos(s_41204_0_`s1', "J46") | strpos(s_41204_0_`s1', "J47")
}
}              
}

recode res2_diag .=0
label var res2_diag "secondary - respiratory disease (chronic)"
label values res2_diag diagL

*dementia
gen dem2_diag=.
local namelist "morbidity"
        foreach name of local namelist { 
             forval s1=0/434 {
					if "`name'"=="morbidity" {
							recode dem2_diag .=1 if strpos(s_41204_0_`s1', "F00") | strpos(s_41204_0_`s1', "F01") ///
							| strpos(s_41204_0_`s1', "F02")
}
}              
}

recode dem2_diag .=0
label var dem_diag "secondary - dementia"
label values dem_diag diagL

*cancer - prostate
gen can2_pros_diag=.
local namelist "morbidity"
        foreach name of local namelist { 
             forval s1=0/434 {
					if "`name'"=="morbidity" {
							recode can2_pros_diag .=1 if strpos(s_41204_0_`s1', "C61")
}
}              
}

recode can2_pros_diag .=0
label var can_pros_diag "secondary - prostate cancer"
label values can_pros_diag  diagL



*cancer - breast
gen can2_br_diag=.
local namelist "morbidity"
        foreach name of local namelist { 
             forval s1=0/434 {
					if "`name'"=="morbidity" {
							recode can_br_diag .=1 if strpos(s_41204_0_`s1', "C50")
}
}              
}

recode can2_br_diag .=0
label var can_br_diag "secondary - breast cancer"
label values can_br_diag diagL

*cancer - lung
gen can2_lung_diag=.
local namelist "morbidity"
        foreach name of local namelist { 
             forval s1=0/434 {
					if "`name'"=="morbidity" {
							recode can2_lung_diag .=1 if strpos(s_41204_0_`s1', "C34")
}
}              
}

recode can2_lung_diag .=0
label var can_lung_diag "secondary - lung cancer"
label values can_lung_diag diagL

*cancer - colorectal
gen can2_colo_diag=.
local namelist "morbidity"
        foreach name of local namelist { 
             forval s1=0/434 {
					if "`name'"=="morbidity" {
							recode can2_colo_diag .=1 if strpos(s_41204_0_`s1', "C18") | strpos(s_41204_0_`s1', "C19") ///
							| strpos(s_41204_0_`s1', "C20") | strpos(s_41204_0_`s1', "C21")
}
}              
}


recode can2_colo_diag .=0
label var can_colo_diag "secondary - colorectal cancer"
label values can_colo_diag diagL

*cancer - stomach
gen can2_sto_diag=.
local namelist "morbidity"
        foreach name of local namelist { 
             forval s1=0/434 {
					if "`name'"=="morbidity" {
							recode can2_sto_diag .=1 if strpos(s_41204_0_`s1', "C16")
}
}              
}

recode can2_sto_diag .=0
label var can_sto_diag "secondary - stomach cancer"
label values can_sto_diag diagL

*cancer - skin
gen can2_skin_diag=.
local namelist "morbidity"
        foreach name of local namelist { 
             forval s1=0/434 {
					if "`name'"=="morbidity" {
							recode can2_skin_diag .=1 if strpos(s_41204_0_`s1', "C43") | strpos(s_41204_0_`s1', "C44")
}
}              
}

recode can2_skin_diag .=0
label var can_skin_diag "secondary - skin cancer"
label values can_skin_diag diagL



*From Cancer Registry*

rename s_40006_30_0 s_40006_29_0 
rename s_40006_31_0 s_40006_30_0

*cancer - prostate
gen can3_pros_diag=.
local namelist "morbidity"
        foreach name of local namelist { 
             forval s1=0/30 {
					if "`name'"=="morbidity" {
							recode can3_pros_diag .=1 if strpos(s_40006_`s1'_0, "C61")
}
}              
}


recode can3_pros_diag .=0
label var can_pros_diag "cancer registry - prostate cancer"
label values can_pros_diag  diagL

*cancer - breast
gen can3_br_diag=.
local namelist "morbidity"
        foreach name of local namelist { 
             forval s1=0/30 {
					if "`name'"=="morbidity" {
							recode can3_br_diag .=1 if strpos(s_40006_`s1'_0, "C50")
}
}              
}

recode can3_br_diag .=0
label var can_br_diag "cancer registry - breast cancer"
label values can_br_diag diagL

*cancer - lung
gen can3_lung_diag=.
local namelist "morbidity"
        foreach name of local namelist { 
             forval s1=0/30 {
					if "`name'"=="morbidity" {
							recode can3_lung_diag .=1 if strpos(s_40006_`s1'_0, "C34")
}
}              
}

recode can3_lung_diag .=0
label var can_lung_diag "cancer registry - lung cancer"
label values can_lung_diag diagL

*cancer - colorectal
gen can3_colo_diag=.
local namelist "morbidity"
        foreach name of local namelist { 
             forval s1=0/30 {
					if "`name'"=="morbidity" {
							recode can3_colo_diag .=1 if strpos(s_40006_`s1'_0, "C18") | strpos(s_40006_`s1'_0, "C19") ///
							| strpos(s_40006_`s1'_0, "C20") | strpos(s_40006_`s1'_0, "C21")
}
}              
}

recode can3_colo_diag .=0
label var can_colo_diag "cancer registry - colorectal cancer"
label values can_colo_diag diagL

*cancer - stomach
gen can3_sto_diag=.
local namelist "morbidity"
        foreach name of local namelist { 
             forval s1=0/30 {
					if "`name'"=="morbidity" {
							recode can3_sto_diag .=1 if strpos(s_40006_`s1'_0, "C16")
}
}              
}

recode can3_sto_diag .=0
label var can_sto_diag "cancer registry - stomach cancer"
label values can_sto_diag diagL


*cancer - skin
gen can3_skin_diag=.
local namelist "morbidity"
        foreach name of local namelist { 
             forval s1=0/30 {
					if "`name'"=="morbidity" {
							recode can3_skin_diag .=1 if strpos(s_40006_`s1'_0, "C43") | strpos(s_40006_`s1'_0, "C44")
}
}              
}

recode can3_skin_diag .=0
label var can_skin_diag "cancer registry - skin cancer"
label values can_skin_diag diagL


*By cause*

*By disease*

*heart disease*
gen chd_diag = 1 if hd_diag == 1 | hd2_diag == 1 
recode chd_diag .=0
label var chd_diag "all coronary heart disease"
label values chd_diag diagL

*stroke*
gen cva_diag = 1 if stroke_diag == 1 | stroke2_diag == 1 
recode cva_diag .=0
label var cva_diag "all stroke"
label values cva_diag diagL

*diabetes mellitus*
gen dm_diag = 1 if dia_diag == 1 | dia2_diag == 1 
recode dm_diag .=0
label var dm_diag "all diabetes mellitus"
label values dm_diag diagL

*copd*
gen copd_diag = 1 if res_diag == 1 | res2_diag == 1 
recode copd_diag .=0
label var copd_diag "all chronic respiratory disease (copd)"
label values copd_diag diagL

*dementia*
gen dementia_diag = 1 if dem_diag == 1 | dem2_diag == 1 
recode dementia_diag .=0
label var dementia_diag "all dementia"
label values dementia_diag diagL
 
*prostate Cancer*
gen pros_cancer = 1 if can_pros_diag == 1 | can2_pros_diag == 1 | can3_pros_diag == 1 
recode pros_cancer .=0
label var pros_cancer "prostate cancer"
label values pros_cancer diagL

*breast Cancer*
gen br_cancer = 1 if can_br_diag == 1 | can2_br_diag == 1 | can3_br_diag == 1 
recode br_cancer .=0
label var br_cancer "breast cancer"
label values br_cancer diagL

*lung Cancer*
gen lung_cancer = 1 if can_lung_diag == 1 | can2_lung_diag == 1 | can3_lung_diag == 1 
recode lung_cancer .=0
label var lung_cancer "lung cancer"
label values lung_cancer diagL

*colorectal Cancer*
gen colo_cancer = 1 if can_colo_diag == 1 | can2_colo_diag == 1 | can3_colo_diag == 1 
recode colo_cancer .=0
label var colo_cancer "colorectal cancer"
label values colo_cancer diagL

*stomach Cancer*
gen sto_cancer = 1 if can_sto_diag == 1 | can2_sto_diag == 1 | can3_sto_diag == 1 
recode sto_cancer .=0
label var sto_cancer "stomach cancer"
label values sto_cancer diagL

*skin Cancer*
gen skin_cancer = 1 if can_skin_diag == 1 | can2_skin_diag == 1 | can3_skin_diag == 1 
recode skin_cancer .=0
label var skin_cancer "skin cancer"
label values skin_cancer diagL


*combined diagnoses*

*combined primary non-cancer*
gen primary_noncancer = 1 if hd_diag == 1 | stroke_diag == 1 | dia_diag == 1 | res_diag == 1 | dem_diag == 1
recode primary_noncancer .=0
label var primary_noncancer "morbidity: primary non cancer"
label values primary_noncancer diagL

*combined primary cancer*
gen primary_cancer = 1 if can_pros_diag == 1 | can_br_diag == 1 | can_lung_diag == 1 | can_colo_diag == 1 | can_sto_diag == 1 | can_skin_diag == 1
recode primary_cancer .=0
label var primary_cancer "morbidity: primary cancer"
label values primary_cancer diagL

*combined primary all diagnoses*
gen primary_diag = 1 if primary_noncancer == 1 | primary_cancer == 1
recode primary_diag .=0
label var primary_diag "morbidity: all primary diagnoses"
label values primary_diag diagL

*combined secondary non-cancer*
gen secondary_noncancer = 1 if hd2_diag == 1 | stroke2_diag == 1 | dia2_diag == 1 | res2_diag == 1 | dem2_diag == 1
recode secondary_noncancer .=0
label var secondary_noncancer "morbidity: secondary non cancer"
label values secondary_noncancer diagL

*combined secondary cancer*
gen secondary_cancer = 1 if can2_pros_diag == 1 | can2_br_diag == 1 | can2_lung_diag == 1 | can2_colo_diag == 1 | can2_sto_diag == 1 | can2_skin_diag == 1
recode secondary_cancer .=0
label var secondary_cancer "morbidity: secondary cancer"
label values secondary_cancer diagL

*combined secondary all diagnoses*
gen secondary_diag = 1 if secondary_noncancer == 1 | secondary_cancer == 1
recode secondary_diag .=0
label var secondary_diag "morbidity: all primary diagnoses"
label values secondary_diag diagL

*cancer registry*
gen registry_cancer = 1 if can3_pros_diag == 1 | can3_br_diag == 1 | can3_lung_diag == 1 | can3_colo_diag == 1 | can3_sto_diag == 1 | can3_skin_diag == 1
recode registry_cancer .=0
label var registry_cancer "morbidity: cancer registry"
label values registry_cancer diagL


*combined all cancer*
gen cancer_diag = 1 if primary_cancer == 1 | secondary_cancer == 1 | registry_cancer == 1
recode cancer_diag .=0
label var cancer_diag "morbidity: all cancer diagnoses"
label values cancer_diag diagL


*COMBINED ALL-CAUSE CHRONIC DISEASE MORBIDITY*
gen all_diag = 1 if primary_diag == 1 | secondary_diag == 1 | registry_cancer == 1
recode all_diag .=0
label var all_diag "morbidity: combined all-cause chronic disease"
label values all_diag diagL


*Keep Variables for analysis*

keep deathdate ethnicity famhistBC famhistPC famhistLC famhistCC famhistMBC walkperday walkperweek modperday modperweek vigperday vigperweek walkMETmin modMETmin ///
vigMETmin METmin smoking cigperday stopsmoke agestop smokingstatus ets etsdummy etsmoke calcium alcohol nights dried fresh fruitpieces fruit salad cooked vegpieces ///
veg live tin dailytomato tomato beef pork redmeat processmeat cereal fibre salt burn sunburn sunscreen tanning pollution altitude jobexp skin darken hpylori aspirin ///
warfarin digoxin metformin radiotherapy contra hrt statins bptreat brdisease plasia coeliac thyroid diabetes polyps crohns reflux prostate hd_diag stroke_diag dia_diag res_diag ///
dem_diag can_pros_diag can_br_diag can_lung_diag can_colo_diag can_sto_diag can_skin_diag hd2_diag stroke2_diag dia2_diag res2_diag dem2_diag can2_pros_diag can2_br_diag ///
can2_lung_diag can2_colo_diag can2_sto_diag can2_skin_diag can3_pros_diag can3_br_diag can3_lung_diag can3_colo_diag can3_sto_diag can3_skin_diag primary_noncancer ///
primary_cancer primary_diag secondary_noncancer secondary_cancer secondary_diag registry_cancer all_diag cancer_diag pros_cancer br_cancer lung_cancer colo_cancer sto_cancer ///
skin_cancer chd_diag cva_diag dm_diag copd_diag dementia_diag n_eid gender baselineage birthyear waist height weight deathdate bmi bodyfat diabp sysbp fev1 vitamin carotene ///
menopause fish education townsend cheese milk priorcancer priorchd priorstroke priordiabetes priorcopd priordem startdate birthmonth

