# Lab 10b - Linear Regression and K-NN Classifier in R

cran <- "https://cran.r-project.org/"
user_lib <- Sys.getenv("R_LIBS_USER")

out_dir <- "Lab10"
if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE)

cat("=== Lab 10b ===\n")

# -----------------------------------------------------------------------------
# 1) Theoph: linear model + visualize + predict dose given weight
# -----------------------------------------------------------------------------
cat("\n--- 1. Theoph linear regression (Dose ~ Wt) ---\n")
data(Theoph)

# Model: Dose (mg/kg) as a function of weight (kg)
model_theoph <- lm(Dose ~ Wt, data = Theoph)
print(model_theoph)
print(summary(model_theoph))

# Predict dose for weights 90, 95, 100 kg
new_wt <- data.frame(Wt = c(90, 95, 100))
pred_dose <- predict(model_theoph, new_wt)
pred_table <- data.frame(Wt = new_wt$Wt, Predicted_Dose_mg_per_kg = as.numeric(pred_dose))
print(pred_table)

# Plot + regression line
png(file = file.path(out_dir, "theoph_dose_vs_weight.png"), width = 1000, height = 700)
plot(Theoph$Wt, Theoph$Dose,
  pch = 16, col = "dodgerblue4",
  xlab = "Weight (kg)", ylab = "Dose (mg/kg)",
  main = "Theoph: Dose vs Weight (linear regression)"
)
abline(model_theoph, col = "red", lwd = 2)
points(new_wt$Wt, pred_dose, pch = 17, col = "darkgreen", cex = 1.4)
legend("topright", legend = c("Observed", "Predicted (90/95/100kg)"),
  pch = c(16, 17), col = c("dodgerblue4", "darkgreen"), cex = 0.9
)
dev.off()

write.csv(pred_table, file.path(out_dir, "theoph_predicted_dose.csv"), row.names = FALSE)

# -----------------------------------------------------------------------------
# 2) ChickWeight: KNN to predict Diet (optimal K) + confusion matrix
# -----------------------------------------------------------------------------
cat("\n--- 2. ChickWeight KNN to predict Diet ---\n")
data(ChickWeight)

# Prepare a modeling dataset:
# Use numeric predictors only; Diet is the target
cw <- ChickWeight
cw$Diet <- as.factor(cw$Diet)

# Features: weight, Time (and optionally Chick as numeric id)
cw$Chick_num <- as.numeric(cw$Chick)
features <- cw[, c("weight", "Time", "Chick_num")]
target <- cw$Diet

if (!require("class", quietly = TRUE)) install.packages("class", lib = user_lib, repos = cran)
if (!require("caTools", quietly = TRUE)) install.packages("caTools", lib = user_lib, repos = cran)
library(class)
library(caTools)

set.seed(42)
split <- sample.split(target, SplitRatio = 0.7)
train_x <- features[split == TRUE, ]
test_x <- features[split == FALSE, ]
train_y <- target[split == TRUE]
test_y <- target[split == FALSE]

# Scale features
train_scale <- scale(train_x)
test_scale <- scale(test_x)

# Try a range of K values and pick best accuracy
ks <- c(1, 3, 5, 7, 9, 11, 13, 15, 17, 19)
acc <- numeric(length(ks))
names(acc) <- as.character(ks)

for (i in seq_along(ks)) {
  k <- ks[i]
  pred <- knn(train = train_scale, test = test_scale, cl = train_y, k = k)
  acc[i] <- mean(pred == test_y)
  cat("k =", k, "Accuracy =", round(acc[i], 4), "\n")
}

best_k <- ks[which.max(acc)]
cat("\nBest K =", best_k, "with accuracy =", round(max(acc), 4), "\n")

# Fit final model with best_k
pred_best <- knn(train = train_scale, test = test_scale, cl = train_y, k = best_k)
cm <- table(Actual = test_y, Predicted = pred_best)
print(cm)

# Save results
write.csv(data.frame(k = ks, accuracy = acc), file.path(out_dir, "chickweight_knn_accuracy_by_k.csv"), row.names = FALSE)
write.csv(as.data.frame(cm), file.path(out_dir, "chickweight_confusion_matrix.csv"), row.names = FALSE)

cat("\nDiscussion notes:\n")
cat("- The confusion matrix shows which diets are commonly confused.\n")
cat("- Accuracy depends on selected features; scaling is required for KNN.\n")

cat("\nSaved outputs to:", normalizePath(out_dir), "\n")

