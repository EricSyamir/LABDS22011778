# Lab 9a - Correlation Analyses and Normalization in R

cran <- "https://cran.r-project.org/"
user_lib <- Sys.getenv("R_LIBS_USER")

out_dir <- "Lab9"
if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE)

cat("=== Lab 9a ===\n")

# -----------------------------------------------------------------------------
# 1. Understanding Correlation Analyses
# -----------------------------------------------------------------------------
cat("\n--- 1.1 Pearson correlation using cor() ---\n")
x <- c(1, 2, 3, 4, 5, 6, 7)
y <- c(1, 3, 6, 2, 7, 4, 5)
result <- cor(x, y, method = "pearson")
cat("Pearson correlation coefficient is:", result, "\n")

cat("\n--- 1.2 Pearson correlation using cor.test() ---\n")
result_test <- cor.test(x, y, method = "pearson")
print(result_test)

cat("\n--- 1.3 Correlation matrix using corrplot (mtcars) ---\n")
if (!require("corrplot", quietly = TRUE)) install.packages("corrplot", lib = user_lib, repos = cran)
if (!require("RColorBrewer", quietly = TRUE)) install.packages("RColorBrewer", lib = user_lib, repos = cran)
library(corrplot)
library(RColorBrewer)

data(mtcars)
M <- cor(mtcars)

png(file = file.path(out_dir, "corrplot_upper.png"), width = 1000, height = 800)
corrplot(M, type = "upper")
dev.off()

png(file = file.path(out_dir, "corrplot_upper_hclust.png"), width = 1000, height = 800)
corrplot(M, type = "upper", order = "hclust")
dev.off()

png(file = file.path(out_dir, "corrplot_upper_hclust_colors.png"), width = 1000, height = 800)
corrplot(M, type = "upper", order = "hclust", col = brewer.pal(n = 8, name = "RdYlBu"))
dev.off()

# -----------------------------------------------------------------------------
# 2. Plotting Correlation with Heatmap
# -----------------------------------------------------------------------------
cat("\n--- 2.1 Create & reorder correlation matrix, then melt ---\n")
if (!require("lattice", quietly = TRUE)) install.packages("lattice", lib = user_lib, repos = cran)
library(lattice)

# The lab references `environmental`. Use it if available; otherwise fall back to mtcars.
data_name <- "environmental"
if (exists(data_name, where = asNamespace("lattice"), inherits = FALSE)) {
  data <- get(data_name, envir = asNamespace("lattice"))
} else if (exists(data_name, inherits = TRUE)) {
  data <- get(data_name)
} else {
  data <- mtcars
}

corr_mat <- round(cor(data), 2)

dist_mat <- as.dist((1 - corr_mat) / 2)
hc <- hclust(dist_mat)
corr_mat <- corr_mat[hc$order, hc$order]

if (!require("reshape2", quietly = TRUE)) install.packages("reshape2", lib = user_lib, repos = cran)
library(reshape2)
melted_corr_mat <- melt(corr_mat)

cat("\n--- 2.2 Correlation heatmap using ggplot2 ---\n")
if (!require("ggplot2", quietly = TRUE)) install.packages("ggplot2", lib = user_lib, repos = cran)
library(ggplot2)

heatmap_plot <- ggplot(data = melted_corr_mat, aes(x = Var1, y = Var2, fill = value)) +
  geom_tile() +
  geom_text(aes(label = value), color = "white", size = 3) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(title = "Correlation Heatmap", x = "Features", y = "Features")

ggsave(filename = file.path(out_dir, "corr_heatmap_ggplot2.png"), plot = heatmap_plot, width = 10, height = 8, dpi = 150)

# -----------------------------------------------------------------------------
# 3. Understanding Normalization
# -----------------------------------------------------------------------------
cat("\n--- 3.1 Log transformation (base R) ---\n")
mydata <- c(244, 753, 596, 645, 874, 141, 639, 465, 999, 654)
scaled_data1 <- log(mydata)
print(scaled_data1)

cat("\n--- 3.2 Standard scaling (scale) ---\n")
scaled_data2 <- as.data.frame(scale(mydata))
print(scaled_data2)

cat("\n--- 3.3 Min-Max scaling (caret) ---\n")
if (!require("caret", quietly = TRUE)) install.packages("caret", lib = user_lib, repos = cran)
library(caret)
minmax <- preProcess(as.data.frame(mydata), method = c("range"))
scaled_data3 <- predict(minmax, as.data.frame(mydata))
print(scaled_data3)

cat("\n--- 3.4 Summary comparison: raw vs normalized ---\n")
print(summary(mydata))
print(summary(scaled_data1))
print(summary(scaled_data2))
print(summary(scaled_data3))

cat("\nSaved outputs to:", normalizePath(out_dir), "\n")

