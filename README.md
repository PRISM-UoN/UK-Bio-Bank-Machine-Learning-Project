# UK-Bio-Bank-Machine-Learning-Project

STATA do file and R Scripts for UKB All-Cause Mortality Prediction Project

The project files include:

1) Cox Models.do - STATA file for running Cox regression models, generating ROC curves and AUC for comparing the outputs of Cox models against Machine-learning models

2) Deep Learning Model.R - R Script for deep learning training, grid-search, hyper-parameter tuning/training, prediction outputs on validation cohort

3) Random Forest Model.R - R Script of training the random forest model, prediction outputs on validation cohort

4) LICENSE.md - General use lisence and copyright


R Packages required are specified in all the above code. For STATA, generation of c-statistics requires somersd package which can downloaded from using the command "findit somersd" and downloading the package SJ5-3 snp15_5 (Please visit for more information: https://www.stata-journal.com/article.html?article=snp15_6

Documentation on using h20, hyperparameter tuning ands selection can be found here: http://docs.h2o.ai/

Access to UK Bio Bank is governed by the UK Bio Bank access commitee at the University of Oxford. Applications are reviewed and approvals granted subject to meeting all ethical and research conditions set forth by the UK Bio Bank. Further information on data access can be found at https://www.ukbiobank.ac.uk/ 

The following data (replicated from Box 1 in the PLOS publication) are the predictor variables should be coded in the following structure:

	Participant anonymised ID
	Age (years)
	Gender (female; male)
	Educational qualifications (none; College/University; A/AS levels; O levels/GCSEs; CSEs; NVQ/HND/HNC; other professional qualifications; unknown) 
	Townsend deprivation index (continuous)
	Ethnicity (White; South Asian; East Asian; Black; other/mixed race; unknown)
	Height (m)
	Weight (kg)
	Waist circumference (cm)
	Body mass index (kg/m2)
	Body fat percentage (%)
	Forced expiratory volume 1 (L)
	Diastolic blood pressure (mm HG)
	Systolic blood pressure (mm HG)
	Skin tone (very fair; fair; light olive; dark olive; brown; black; unknown)
	Vitamins and supplements (none; vitamin A; vitamin B; vitamin C; vitamin D; vitamin B9; calcium; multi-vitamins)
	Family history of prostate cancer (no; yes)
	Family history of breast cancer (no; yes)
	Family history of colorectal cancer(no; yes)
	Family history of lung cancer (no; yes)
	Smoking status (non-smoker; current smoker)
	Environmental tobacco smoke (hours per week)
	Residential air pollution PM2.5 (quintiles of µg/m3)
	Physical activity (MET-min per week)
	Beta-carotene supplements (no; yes)
	Alcohol consumption (never, special occasions only; 1-3 times per month; 1-3 times per week; daily or almost daily, unknown)
	Fruit consumption (pieces per day)
	Vegetable consumption (pieces per day)
	Beef consumption (never; < one per week; one per week; 2-4 times per week; 5-6 times per week; once or more daily; unknown)
	Pork consumption (never; < one per week; one per week; 2-4 times per week; 5-6 times per week; once or more daily; unknown)
	Processed meat consumption (never; < one per week; one per week; 2-4 times per week; 5-6 times per week; once or more daily; unknown)
	Cereal consumption (bowls per week)
	Cheese consumption (never; < one per week; one per week; 2-4 times per week; 5-6 times per week; once or more daily; unknown)
	Salt added to food (never/rarely; sometimes; usually; always; unknown)
	Type of milk used (never/rarely; other types; soya; skimmed; semi-skimmed; full cream; unknown)
	Fish consumption (never; < one per week; one per week; 2-4 times per week; 5-6 times per week; once or more daily; unknown)
	Sunscreen usage (never/rarely; sometimes; usually; always; unknown)
	Ease of skin tanning (very tanned; moderately tanned; mildly/occasionally tanned; never tan/only burn; unknown)
	Job exposure to hazardous materials (none; rarely; sometimes; often; unknown)
	Aspirin prescribed (no; yes)
	Warfarin prescribed (no; yes)
	Digoxin prescribed (no; yes)
	Metformin prescribed (no; yes)
	Oral contraceptives prescribed (no; yes)
	Hormone replacement therapy prescribed (no; yes)
	Anti-hypertensive drugs prescribed (no; yes)
	Statins prescribed (no; yes)
	Previously diagnosed with h. pylori infection (no; yes)
	Previously had radiotherapy (no; yes)
	Previously diagnosed with bowel polyps (no; yes)
	Previously diagnosed with Coeliac disease (no; yes)
	Previously diagnosed with Crohn’s disease (no; yes)
	Previously diagnosed with thyroid disease (no; yes)
	Previously diagnosed with acid reflex (no; yes)
	Previously diagnosed with hyperplasia (no; yes)
	Previously diagnosed with prostate disease (no; yes)
	Previously diagnosed with cancer (no; yes)
	Previously diagnosed with coronary heart disease [CHD] (no; yes)
	Previously diagnosed with stroke/transient ischemic attack [TIA] (no; yes)
	Previously diagnosed with Type II diabetes [T2DM] (no; yes)
	Previously diagnosed with chronic obstructive pulmonary disease [COPD] (no; yes)


In all codes, file paths need to be changed to your local working directories. The code runs on the basis of creating two text tab delimited data files from the UK Bio Bank. The full cohort needs to be split randomly 75% and 25%. Remember when you conduct the random split - make sure to set your seed to be able to replicate the split. You should save these as .txt files and derivation cohort "derivation.txt" and validation cohort "validation.txt" and place these in your R working directory. You can elect to change your variable names but for maximise consistency with the codes, you can adopt the ones used in this project:

n_eid
gender
birthyear
waist
height
birthmonth
townsend
fev1
diabp
sysbp
education
vitamin
bmi
weight
baselineage
bodyfat
startdate
deathdate
ethnicity
famhistBC
famhistPC
famhistLC
famhistCC
famhistMBC
walkperday
walkperweek
modperday
modperweek
vigperday
vigperweek
walkMETmin
modMETmin
vigMETmin
METmin
smoking
cigperday
stopsmoke
agestop
smokingstatus
ets
etsmoke
carotene
calcium
alcohol
dried
fresh
fruitpieces
fruit
salad
cooked
vegpieces
veg
beef
pork
processmeat
cereal
cheese
salt
milk
fish
sunscreen
pollution
jobexp
skin
darken
hpylori
aspirin
warfarin
digoxin
metformin
radiotherapy
menopause
contra
hrt
statins
bptreat
brdisease
plasia
coeliac
thyroid
diabetes
polyps
crohns
reflux
prostate
priorcancer
priorchd
priorstroke
priordiabetes
priorcopd
priordem
hd_diag
stroke_diag
dia_diag
res_diag
dem_diag
can_pros_diag
can_br_diag
can_lung_diag
can_colo_diag
can_sto_diag
can_skin_diag
hd2_diag
stroke2_diag
dia2_diag
res2_diag
dem2_diag
can2_pros_diag
can2_br_diag
can2_lung_diag
can2_colo_diag
can2_sto_diag
can2_skin_diag
can3_pros_diag
can3_br_diag
can3_lung_diag
can3_colo_diag
can3_sto_diag
can3_skin_diag
chd_diag
cva_diag
dm_diag
copd_diag
dementia_diag
pros_cancer
br_cancer
lung_cancer
colo_cancer
sto_cancer
skin_cancer
primary_noncancer
primary_cancer
primary_diag
secondary_noncancer
secondary_cancer
secondary_diag
registry_cancer
cancer_diag
all_diag
logweight
logheight
logbmi
logwaist
logbf
logdiabp
logsysbp
logfev
logMET
logcig
logtownsend
missweight
missheight
missbmi
misswaist
missbf
missdiabp
misssysbp
missfev
missMET
misscig
misstown
death





