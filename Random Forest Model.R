#Install packages
install.packages("ggplot2")
install.packages("plyr")
install.packages("dplyr")
install.packages("glmnet")
install.packages("randomForest")
install.packages("reshape2")
install.packages("h2o")
install.packages("pROC")
install.packages("magrittr")
install.packages("pROC")
install.packages("ggrepel")
install.packages("matrixStats")
install.packages("RCurl")
install.packages("prettyR")
install.packages("caret")
install.packages("e1071")

library(splines)
require(stats); require(graphics)
library(magrittr)
library(plyr)
library(dplyr)
library(ggplot2)
library(ggrepel)

#Set the working directory to the one drive - remember to change the name before running
setwd("insert filepath of local working directory") 

#Custom plotting theme
my_theme <- function(base_size = 12, base_family = "sans"){
  theme_minimal(base_size = base_size, base_family = base_family) +
    theme(
      axis.text = element_text(size = 12),
      axis.title = element_text(size = 14),
      panel.grid.major = element_line(color = "grey"),
      panel.grid.minor = element_blank(),
      panel.background = element_rect(fill = "aliceblue"),
      strip.background = element_rect(fill = "darkgrey", color = "grey", size = 1),
      strip.text = element_text(face = "bold", size = 12, color = "white"),
      legend.position = "right",
      legend.justification = "top", 
      panel.border = element_rect(color = "grey", fill = NA, size = 0.5)
    )
}

#Load Training datatset
training <- read.delim("derivation.txt", header=TRUE, sep = "\t")
View(training)


#Load Validation dataset
validation <- read.delim("validation.txt", head=TRUE, sep = "\t")
View(validation)

#fill in missing values with NA
training[training == ""] <- NA
validation[validation == ""] <- NA


#Convert predictor variables to factor
cols = c(2,11,12,19,23,35,42,43,44,53,54,55,57:71,73:139,151:161)
training[,cols] = lapply(training[,cols], as.factor)
validation[,cols] = lapply(validation[,cols], as.factor)

#Build Random Forest Algorithm
library(randomForest)
set.seed(123)

#for simplicity: create training and validation matrix of including only input/output variables 
train_rf <- as.data.frame(training[,c(2,11,12,15,20:23,35,41:44,48,52:71,73:80,82:90,140:150,162)]) 
valid_rf <- as.data.frame(validation[,c(2,11,12,15,20:23,35,41:44,48,52:71,73:80,82:90,140:150,162)]) 

#View matrices - check matrices
View(train_rf)
View(valid_rf)

# Create a random forest with 1000 trees for training dataset
rf1 <- randomForest(death ~ . , data = train_rf, importance = TRUE, ntree=200)

# Error rate plot
plot(rf1)

#Using the importance()  function to calculate the importance of each variable
imp1 <- as.data.frame(sort(importance(rf1)[,1],decreasing = TRUE),optional = T)
names(imp1) <- "Mean Decrease in Accuracy"
imp1

#Variable importance plot for random forest
varImpPlot(rf1)

#variable/feature importance
rfimp <- varImpPlot(rf1)
rfimp <- as.data.frame(rfimp)

#export into stata file
library(foreign)
write.dta(rfimp, "C:/Users/mczsfw/OneDrive - The University of Nottingham/UK Bio Bank/Machine Learning/rf_varimp.dta")

#Prediction to validation dataset
rfpredict1 <- predict(rf1, validation, type = "prob")

#Create data frame with actual vs predicted mortality
colnames(rfpredict1) <- c("alive", "died") 
rfpredict1 <- as.data.frame(rfpredict1)

#AUC graph 
library(pROC)
roc.rf1 <- roc(validation$death, rfpredict1$died)
plot(roc.rf1, asp = NA)
roc.rf1

#combine patid with predictions from rf2
rf1_complete <- cbind(validation$n_eid, rfpredict1$died)
rf1_complete <- as.data.frame(rf1_complete)
colnames(rf1_complete) <- c("n_eid", "rf_prob")

#export into stata file
library(foreign)
write.dta(rf1_complete, "insert filepath and name of your random forest prediction results")



