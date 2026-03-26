# Lab 10a - Linear Regression and K-NN Classifier in R

cran <- "https://cran.r-project.org/"
user_lib <- Sys.getenv("R_LIBS_USER")

out_dir <- "Lab10"
if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE)

cat("=== Lab 10a ===\n")

# -----------------------------------------------------------------------------
# 1. Introduction to linear regression (vectors)
# -----------------------------------------------------------------------------
cat("\n--- 1.1 Create relationship model & coefficients ---\n")
x <- c(151, 174, 138, 186, 128, 136, 179, 163, 152, 131)
y <- c(63, 81, 56, 91, 47, 57, 76, 72, 62, 48)

relation <- lm(y ~ x)
print(relation)

cat("\n--- 1.2 Summary of relationship ---\n")
print(summary(relation))

cat("\n--- 1.3 Predict single value (height 170) ---\n")
a <- data.frame(x = 170)
result1 <- predict(relation, a)
print(result1)

cat("\n--- 1.4 Predict multiple values ---\n")
b <- data.frame(x = c(151, 174, 170))
result2 <- predict(relation, b)
print(result2)

cat("\n--- 1.5 Visualize regression (saved) ---\n")
png(file = file.path(out_dir, "height_weight_regression.png"), width = 1000, height = 700)
plot(y, x,
  col = "blue",
  main = "Height & Weight Regression",
  cex = 1.3,
  pch = 16,
  xlab = "Weight in Kg",
  ylab = "Height in cm"
)
abline(lm(x ~ y), col = "red", lwd = 2)
dev.off()

png(file = file.path(out_dir, "height_weight_scatter_smooth.png"), width = 1000, height = 700)
scatter.smooth(y, x, col = "blue", main = "Height & Weight", xlab = "Weight in Kg", ylab = "Height in cm")
dev.off()

# -----------------------------------------------------------------------------
# 2. Linear regression with built-in dataset (cars)
# -----------------------------------------------------------------------------
cat("\n--- 2.1 cars dataset model, summary and plots ---\n")
x <- cars$speed
y <- cars$dist
model1 <- lm(y ~ x)
print(model1)
print(summary(model1))

png(file = file.path(out_dir, "cars_dist_speed_plot.png"), width = 1000, height = 700)
plot(y, x, main = "Distance & Speed",
  xlab = "Distance", ylab = "Speed"
)
abline(lm(speed ~ dist, data = cars), col = "red", lwd = 2)
dev.off()

png(file = file.path(out_dir, "cars_dist_speed_scatter_smooth.png"), width = 1000, height = 700)
scatter.smooth(y, x, main = "Dist ~ Speed", xlab = "Distance", ylab = "Speed")
dev.off()

cat("\n--- 2.2 Predict new values (newspeed = 26,27,28) ---\n")
newspeed <- data.frame(x = c(26, 27, 28))
result3 <- predict(model1, newspeed)
print(result3)

# -----------------------------------------------------------------------------
# 3. K-NN Classifier (iris)
# -----------------------------------------------------------------------------
cat("\n--- 3.1 Install/load packages and data(iris) ---\n")
if (!require("e1071", quietly = TRUE)) install.packages("e1071", lib = user_lib, repos = cran)
if (!require("caTools", quietly = TRUE)) install.packages("caTools", lib = user_lib, repos = cran)
if (!require("class", quietly = TRUE)) install.packages("class", lib = user_lib, repos = cran)

library(e1071)
library(caTools)
library(class)

data(iris)
print(head(iris))

cat("\n--- 3.2 Split train/test and scale ---\n")
set.seed(42)
split <- sample.split(iris$Species, SplitRatio = 0.7)
train_cl <- subset(iris, split == TRUE)
test_cl <- subset(iris, split == FALSE)

train_scale <- scale(train_cl[, 1:4])
test_scale <- scale(test_cl[, 1:4])

cat("\n--- 3.3 Fit KNN (k=1) ---\n")
classifier_knn <- knn(train = train_scale, test = test_scale, cl = train_cl$Species, k = 1)
print(classifier_knn)

cat("\n--- 3.4 Confusion matrix + accuracy (k=1) ---\n")
cm <- table(test_cl$Species, classifier_knn)
print(cm)
misClassError <- mean(classifier_knn != test_cl$Species)
print(paste("Accuracy =", 1 - misClassError))

cat("\n--- 3.5 Try multiple K values ---\n")
ks <- c(3, 5, 7, 15, 19)
acc <- numeric(length(ks))
names(acc) <- as.character(ks)

for (i in seq_along(ks)) {
  k <- ks[i]
  pred <- knn(train = train_scale, test = test_scale, cl = train_cl$Species, k = k)
  err <- mean(pred != test_cl$Species)
  acc[i] <- 1 - err
  cat("k =", k, "Accuracy =", acc[i], "\n")
}

# Save K accuracy results
write.csv(data.frame(k = ks, accuracy = as.numeric(acc)), file.path(out_dir, "iris_knn_accuracy_by_k.csv"), row.names = FALSE)
cat("\nSaved outputs to:", normalizePath(out_dir), "\n")

