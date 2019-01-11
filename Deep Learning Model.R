#Install ggplot2
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
install.packages("tidyr")

#Download pcaGoPromoter
source("https://bioconductor.org/biocLite.R")
biocLite("pcaGoPromoter")

#load libraries
library(splines)
require(stats); require(graphics)
library(magrittr)
library(plyr)
library(dplyr)
library(ggplot2)
library(ggrepel)


#Set the working directory to the one drive - remember to change the name before running
setwd("insert your working directory here") 

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

#Convert response variable to factor 
training$death <- factor(training$death)
validation$death <- factor(validation$death)

#Convert predictor variables to factor
cols = c(2,11,12,19,23,35,42,43,44,53,54,55,57:71,73:139,151:161)
training[,cols] = lapply(training[,cols], as.factor)
validation[,cols] = lapply(validation[,cols], as.factor)

#Build Deep Learning Models
library(h2o)
localH2O <- h2o.init() #initialize the h20 cluster - note you need to have JAVA installed


###########################Deep Learning Model########################################## 

#generate data frames for deep learning models including all variables
train_dl <- as.data.frame(training[,c(2,11,12,15,20:23,35,41:44,48,52:71,73:80,82:91,140:150,162)]) 
valid_dl <- as.data.frame(validation[,c(2,11,12,15,20:23,35,41:44,48,52:71,73:80,82:91,140:150,162)]) 

#View matrices - check matrices
View(train_dl)
View(valid_dl)

#First, let's look at principal components analysis for visualisation
#Visualize through principle components analysis (2 principle components)
library(pcaGoPromoter)

pca_func <- function(pcaOutput2, group_name){
  centroids <- aggregate(cbind(PC1, PC2) ~ groups, pcaOutput2, mean)
  conf.rgn  <- do.call(rbind, lapply(unique(pcaOutput2$groups), function(t)
    data.frame(groups = as.character(t),
               ellipse(cov(pcaOutput2[pcaOutput2$groups == t, 1:2]),
                       centre = as.matrix(centroids[centroids$groups == t, 2:3]),
                       level = 0.95),
               stringsAsFactors = FALSE)))
  
  plot <- ggplot(data = pcaOutput2, aes(x = PC1, y = PC2, group = groups, color = groups)) + 
    geom_polygon(data = conf.rgn, aes(fill = groups), alpha = 0.2) +
    geom_point(size = 2, alpha = 0.5) + 
    labs(color = paste(group_name),
         fill = paste(group_name),
         x = paste0("PC1: ", round(pcaOutput$pov[1], digits = 2) * 100, "% variance"),
         y = paste0("PC2: ", round(pcaOutput$pov[2], digits = 2) * 100, "% variance")) +
    my_theme()
  
  return(plot)
}

#for principle components analysis - requires all factors as numeric
training[,cols] = lapply(training[,cols], as.numeric)
train2 <- as.data.frame(training[,c(2,11,12,15,20:23,35,41:44,48,52:71,73:80,82:91,140:150,162)])

pcaOutput <- pca(t(train2[-c(64)]), printDropped = FALSE, scale = TRUE, center = TRUE)
pcaOutput2 <- as.data.frame(pcaOutput$scores)

pcaOutput2$groups <- train2$death
p2 <- pca_func(pcaOutput2, group_name = "Mortality")

p2 


#Obtain variance within features 
library(matrixStats)

colvars <- data.frame(feature = colnames(train2[-c(64)]),
                      variance = colVars(as.matrix(train2[-c(64)])))

subset(colvars, variance > 0) %>%
  mutate(feature = factor(feature, levels = colnames(train2[-c(64)]))) %>%
  ggplot(aes(x = feature, y = variance)) +
  geom_bar(stat = "identity", fill = "navy", alpha = 0.7) +
  my_theme() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))


#Now let's build the deep learning 
#Load data into an h2o data frame

train_dl <- as.h2o(train_dl) 
test_dl <- as.h2o(valid_dl)

#split training dataset for training/validation internally 70% split/30% internal cross-validation
splits <- h2o.splitFrame(train_dl, 
                         ratios = c(0.7), 
                         seed = 1)

train_dl <- splits[[1]]
valid_dl <- splits[[2]]

train_dl <- as.h2o(train_dl) 
valid_dl <- as.h2o(valid_dl) 

#We should end up with three datasets: train, valid, and test 
train_dl #70% of training cohort
valid_dl #30% of training cohort
test_dl #100% validation cohort


y <- "death"
x <- setdiff(names(train_dl), y)



#Conduct grid search for hyperparameter tuning
hyper_params <- list(
  activation = c("Rectifier", "Maxout", "Tanh", "RectifierWithDropout", "MaxoutWithDropout", "TanhWithDropout"), 
  hidden = list(c(5, 5, 5, 5, 5), c(10, 10, 10, 10), c(50, 50, 50), c(100, 100, 100)),
  epochs = c(50, 100, 200),
  l1 = c(0, 0.00001, 0.0001), 
  l2 = c(0, 0.00001, 0.0001),
  rate = c(0, 01, 0.005, 0.001),
  rate_annealing = c(1e-8, 1e-7, 1e-6),
  rho = c(0.9, 0.95, 0.99, 0.999),
  epsilon = c(1e-10, 1e-8, 1e-6, 1e-4),
  momentum_start = c(0, 0.5),
  momentum_stable = c(0.99, 0.5, 0),
  input_dropout_ratio = c(0, 0.1, 0.2),
  max_w2 = c(10, 100, 1000, 3.4028235e+38))

search_criteria <- list(strategy = "RandomDiscrete", 
                        max_models = 100,
                        max_runtime_secs = 900,
                        stopping_tolerance = 0.001,
                        stopping_rounds = 15,
                        seed = 84)

dl_grid <- h2o.grid(algorithm = "deeplearning", 
                     x = x,
                     y = y,
                     grid_id = "dl_grid",
                     training_frame = train_dl,
                     validation_frame = valid_dl,
                     nfolds = 10,                           
                     fold_assignment = "Stratified",
                     hyper_params = hyper_params,
                     search_criteria = search_criteria,
                     seed = 84)


# performance metrics where smaller is better -> order with decreasing = FALSE
sort_options_1 <- c("mean_per_class_error", "mse", "err")

for (sort_by_1 in sort_options_1) {
  grid <- h2o.getGrid("dl_grid", sort_by = sort_by_1, decreasing = FALSE)
  model_ids <- grid@model_ids
  best_model <- h2o.getModel(model_ids[[1]])
  assign(paste0("best_model_", sort_by_1), best_model)
}


# performance metrics where bigger is better -> order with decreasing = TRUE
sort_options_2 <- c("auc", "precision", "accuracy", "recall", "specificity")

for (sort_by_2 in sort_options_2) {
  grid <- h2o.getGrid("dl_grid", sort_by = sort_by_2, decreasing = TRUE)
  model_ids <- grid@model_ids
  best_model <- h2o.getModel(model_ids[[1]])
  assign(paste0("best_model_", sort_by_2), best_model)
}

#mean class per error per each model in grid search
library(tibble)

sort_options <- c("mean_per_class_error", "mse", "err", "auc", "precision", "accuracy", "recall", "specificity")

for (sort_by in sort_options) {
  best_model <- get(paste0("best_model_", sort_by))
  errors <- h2o.mean_per_class_error(best_model, train = TRUE, valid = TRUE, xval = TRUE)
  errors_df <- data.frame(model_id = best_model@model_id, sort = sort_by, errors) %>%
    rownames_to_column(var = "rowname")
  
  if (sort_by == "mean_per_class_error") {
    errors_df_comb <- errors_df
  } 
  else {
    errors_df_comb <- rbind(errors_df_comb, errors_df)
  }
}

order <- subset(errors_df_comb, rowname == "xval") %>%
  arrange(errors)

errors_df_comb %>%
  mutate(sort = factor(sort, levels = order$sort)) %>%
  ggplot(aes(x = sort, y = errors, fill = model_id)) +
  facet_grid(rowname ~ ., scales = "free") +
  geom_bar(stat = "identity", alpha = 0.8) +
  scale_fill_brewer(palette = "Set1") +
  my_theme() +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1),
        plot.margin = unit(c(0.5, 0, 0, 1), "cm")) +
  labs(x = "")


#Model performance
for (sort_by in sort_options) {
  best_model <- get(paste0("best_model_", sort_by))
  mse_auc_test <- data.frame(model_id = best_model@model_id,
                             sort = sort_by, 
                             mse = h2o.mse(h2o.performance(best_model, test_dl)),
                             auc = h2o.auc(h2o.performance(best_model, test_dl)))
  if (sort_by == "mean_per_class_error") {
    mse_auc_test_comb <- mse_auc_test
  } else {
    mse_auc_test_comb <- rbind(mse_auc_test_comb, mse_auc_test)
  }
}


library(tidyr)

mse_auc_test_comb %>%
  gather(x, y, mse:auc) %>%
  ggplot(aes(x = sort, y = y, fill = model_id)) +
  facet_grid(x ~ ., scales = "free") +
  geom_bar(stat = "identity", alpha = 0.8, position = "dodge") +
  scale_fill_brewer(palette = "Set1") +
  my_theme() +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1),
        plot.margin = unit(c(0.5, 0, 0, 1.5), "cm")) +
  labs(x = "", y = "value", fill = "")

#Best model from grid search
best_model@parameters


#Train deep learning model based on optimal hyperparameters after gridsearch
dl_model <- h2o.deeplearning(x = x,
                              y = y,
                              model_id = "dl_model",
                              training_frame = train_dl,
                              validation_frame = valid_dl,
                              nfolds = 10,                        # 10x cross validation
                              fold_assignment = "Stratified",
                              activation = "Tanh",
                              overwrite_with_best_model = FALSE,
                              keep_cross_validation_predictions = FALSE,
                              score_each_iteration = TRUE,
                              use_all_factor_levels = TRUE,
                              hidden = c(50,50,50),           # 3 hidden layers with 50 nodes each
                              epochs = 1.51386,
                              variable_importances = TRUE,
                              export_weights_and_biases = TRUE,
                              rho = 0.999,
                              epsilon = 1e-10,
                              input_dropout_ratio = 0.2,
                              momentum_stable = 0.5,
                              rate = 0.001,
                              rate_annealing = 1e-07,
                              stopping_rounds = 0,
                              l1 = 1e-05,
                              l2 = 1e-04,
                              max_w2 = 1000,
                              seed = 84)

h2o.saveModel(dl_model, path = "dl_model", force = TRUE) #save model because training can take some time

dl_model <- h2o.loadModel("dl_model/dl_model") #you can now load this model to make predictions anytime

#model performance - shows rankings of variable feature importance
summary(dl_model)

#the weights for connecting two adjacent layers and per-neuron biases 
w <- h2o.weights(dl_model, matrix_id = 1)
b <- h2o.biases(dl_model, vector_id = 1)
w
b

#variable/feature importance
dlimp <- h2o.varimp(dl_model)
dlimp <- as.data.frame(dlimp)


#export into stata file
library(foreign)
write.dta(dlimp, "C:/Users/mczsfw/OneDrive - The University of Nottingham/UK Bio Bank/Machine Learning/dl_varimp.dta")


#make predictions using dl h2o model
dlprob <- as.data.frame(h2o.predict(object = dl_model, newdata = test_dl))

#training scoring history
plot(dl_model,
     timestep = "epochs",
     metric = "classification_error")

plot(dl_model,
     timestep = "samples",
     metric = "classification_error")

plot(dl_model,
     timestep = "epochs",
     metric = "logloss")

plot(dl_model,
     timestep = "epochs",
     metric = "rmse")

#AUC 
perf <- h2o.performance(dl_model, test_dl)
perf
plot(perf)
h2o.auc(perf)
head(h2o.metric(perf))

#combine patid with predictions from dl2
dl_complete <- cbind(validation$n_eid, dlprob$p1)
dl_complete <- as.data.frame(dl_complete)
colnames(dl_complete) <- c("n_eid", "dl_prob")

#export into stata file
library(foreign)
write.dta(dl_complete, "insert file path and name of deep learning model outputs in your working directory")


