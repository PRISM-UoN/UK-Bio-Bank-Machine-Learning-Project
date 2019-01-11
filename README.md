# UK-Bio-Bank-Machine-Learning-Project

STATA do file and R Scripts for UKB All-Cause Mortality Prediction Project

The project files include:

1) Cox Models.do - STATA file for running Cox regression models, generating ROC curves and AUC for comparing the outputs of Cox models against Machine-learning models

2) Deep Learning Model.R - R Script for deep learning training, grid-search, hyper-parameter tuning/training, prediction outputs on validation cohort

3) Random Forest Model.R - R Script of training the random forest model, prediction outputs on validation cohort

4) LICENSE.md - General use lisence and copyright


R Packages required are specified in all the above code. For STATA, generation of c-statistics requires somersd package which can downloaded from using the command "findit somersd" and downloading the package SJ5-3 snp15_5 (Please visit for more information: https://www.stata-journal.com/article.html?article=snp15_6

Documentation on using h20, hyperparameter tuning ands selection can be found here: http://docs.h2o.ai/

In all codes, file paths need to be changed to your local working directories


