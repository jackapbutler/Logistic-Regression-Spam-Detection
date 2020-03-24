library(kernlab)
library(dplyr)
options(scipen = 999)

data(spam)
head(spam)

# select predictor variables related to characters
spam <- select(spam, -c(1:48))
summary(spam)

# correlation between numerical features
library(corrplot)
num_vars_mat <- cor(select(spam, -c(type)))
pval_matrix <- cor.mtest(num_vars_mat)$p
par(mfrow = c(1,1))
corrplot(num_vars_mat, type="upper", order="hclust",
         # Add coefficient of correlation
         addCoef.col = "black", 
         #Text label color and rotation
         tl.col="black", tl.srt=45, 
         # Combine with significance level 0.1
         p.mat = pval_matrix, sig.level = 0.1, insig = "blank", 
         # hide correlation coefficient on the principal diagonal
         diag=FALSE)

head(spam)

# Fit a logistic regression model to the data
full_model <- glm(type ~ ., data = spam, family = "binomial") 
full_mod_summary <- summary(full_model)
full_mod_summary

# Visualise distribution of classes among sigmoid function
log_odds <- predict(full_model) 
actual_probs <- predict(full_model, type = "response")
head(actual_probs)

symb <- c(19, 17) 
col <- c("deepskyblue2", "red")
plot(log_odds, jitter(actual_probs, amount = 0.05), 
     pch = symb[spam$type], 
     col = adjustcolor(col[spam$type], 0.7), 
     cex = 0.7, xlim=c(-15,15),
     xlab = "Log-odds", ylab = "Probabilities")

# Does charDollar and charExclamation significantly affect probability of email being spam?
 # Yes, because they have significant p-values in our model summary 
 # (both are < 2x10^-16 which is basically zero)

# Take model coefficients and convert using inverse link function
mod_coeffs1 <- data.frame(coef(full_model))
mod_coeffs_odds <- exp(mod_coeffs1)

# What could be the inferential problems related to these two variables?
 # These variables are only examined relative to the other covariates. We can't accurately
 # infer the true relationship between each of these and the response variable.
 # It is purely a correlation apporach not necessarily causation.

# Extract the odds effect for these two variables
Dollar_odds_effect <- mod_coeffs_odds[6,]
Exclamation_odds_effect <- mod_coeffs_odds[5,]

# Extract model coefficients and standard errors
mod_coeffs <- coef(full_model)
stand_errors <- full_mod_summary$coef[,2]

# Create 95% coefficients confidence intervals
coef_LowBound <- mod_coeffs - 1.96 * stand_errors 
coef_UppBound <- mod_coeffs + 1.96 * stand_errors

ci <- cbind(lower_bound = coef_LowBound, coef_estimate = mod_coeffs , upper_bound = coef_UppBound) 
mod_odds_bounds <- exp(ci)
dollar_exclaim_ci <- mod_odds_bounds[5:6,]

# Create table for report
library(xtable)
print.xtable(xtable(dollar_exclaim_ci), file = "./dollar_exclaim.txt")

# Evaluate the general classification accuracy of the model using ROC curve 
library(ROCR)
probs <- fitted(full_model)
predObj <- prediction(probs, spam$type)

performance <- performance(predObj, "tpr", "fpr") 
plot(performance, main = "ROC Curve", 
     ylab = "Sensitivity", xlab = "FPR") 
abline(0, 1, col = "darkorange2", lty = 2) 

auc <- performance(predObj, "auc") 
auc@y.values

# Calculate an optimal threshold τ for prediction.
sensitivity <- performance(predObj, "sens") 
specificity <- performance(predObj, "spec")

tau <- sensitivity@x.values[[1]] 
sens_Spec <- sensitivity@y.values[[1]] + specificity@y.values[[1]] 
best <- which.max(sens_Spec) 

plot(tau, sensitivity@y.values[[1]], type = "l",
     xlab = "Threshold Value", ylab = "Sensitivity")

plot(tau, 1 - specificity@y.values[[1]], type = "l",
     xlab = "Threshold Value", ylab = "FPR")

best_tau = round(tau[best], 4)
best_tau

plot(tau, sens_Spec, type = "l",
     xlab = "Threshold Value", ylab = "Sensitivity + Specificity")
legend("topright", legend = "0.3433  =  Optimal Threshold", 
       col = "darkorange2", pch = 19) 
points(tau[best], sens_Spec[best], pch = 19, 
       col = adjustcolor("darkorange2", .75))

# Evaluate this optimal tau value
library(caret)
tau_chosen = 0.3433
pred <- ifelse(probs > tau_chosen, "spam", "nonspam")
conf_matrix <- table(spam$type, pred)
best_tpr <- round(sensitivity(conf_matrix), 2)
best_fpr <- 1 - round(specificity(conf_matrix), 2)

metrics <- cbind.data.frame(tau_chosen, best_tpr, best_fpr)
metrics <- rename(metrics, "Sensitivity" = best_tpr)
metrics <- rename(metrics, "FPR" = best_fpr)
metrics <- rename(metrics, "Threshold" = tau_chosen)
print.xtable(xtable(metrics), file = "./best_tau.txt")

tau_chosen2 = 0.52
pred2 <- ifelse(probs > tau_chosen2, "spam", "nonspam")
conf_matrix2 <- table(spam$type, pred2)
conf_matrix2
best_fpr2 <- 1-specificity(conf_matrix2)
best_tpr2 <- sensitivity(conf_matrix2)

metrics_2 <- cbind.data.frame(tau_chosen2, best_tpr2, best_fpr2)
metrics_2 <- rename(metrics_2, "Sensitivity" = best_tpr2)
metrics_2 <- rename(metrics_2, "FPR" = best_fpr2)
metrics_2 <- rename(metrics_2, "Threshold" = tau_chosen2)
print.xtable(xtable(metrics_2), file = "./10fpr_tau.txt")

