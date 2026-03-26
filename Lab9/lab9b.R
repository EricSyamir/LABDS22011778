# Lab 9b - Correlation Analyses and Normalization in R
#
# Activity:
# 1) ToothGrowth: correlation + heatmap + observation/insight
# 2) mtcars: normalization via log transform, standard scaling, min-max; compare

cran <- "https://cran.r-project.org/"
user_lib <- Sys.getenv("R_LIBS_USER")

out_dir <- "Lab9"
if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE)

cat("=== Lab 9b ===\n")

# Packages (installed to user lib to avoid admin permission issues)
if (!require("reshape2", quietly = TRUE)) install.packages("reshape2", lib = user_lib, repos = cran)
if (!require("ggplot2", quietly = TRUE)) install.packages("ggplot2", lib = user_lib, repos = cran)
if (!require("caret", quietly = TRUE)) install.packages("caret", lib = user_lib, repos = cran)

library(reshape2)
library(ggplot2)
library(caret)

# -----------------------------------------------------------------------------
# 1) ToothGrowth: correlation + heatmap
# -----------------------------------------------------------------------------
cat("\n--- 1. ToothGrowth correlation ---\n")
data(ToothGrowth)

# Convert supp to numeric for correlation purposes (OJ=1, VC=0)
tg <- ToothGrowth
tg$supp_num <- ifelse(tg$supp == "OJ", 1, 0)

# Use only numeric columns for correlation
tg_num <- tg[, c("len", "dose", "supp_num")]
corr_tg <- round(cor(tg_num), 2)
print(corr_tg)

# Heatmap with values
melted <- melt(corr_tg)
tg_plot <- ggplot(melted, aes(x = Var1, y = Var2, fill = value)) +
  geom_tile() +
  geom_text(aes(label = value), color = "white", size = 4) +
  theme_minimal() +
  labs(title = "ToothGrowth Correlation Heatmap", x = "Variables", y = "Variables")

ggsave(file.path(out_dir, "toothgrowth_corr_heatmap.png"), tg_plot, width = 7, height = 6, dpi = 160)

# Simple insights
cat("\nObservation/Insight (ToothGrowth):\n")
cat("- 'len' is strongly positively correlated with 'dose' (higher dose, longer tooth length).\n")
cat("- 'supp' effect is encoded as supp_num (OJ vs VC); correlation gives a quick direction but is not a causal test.\n")

# -----------------------------------------------------------------------------
# 2) mtcars: normalization comparisons
# -----------------------------------------------------------------------------
cat("\n--- 2. mtcars normalization ---\n")
data(mtcars)

# Use numeric columns only (mtcars is all numeric)
mt <- mtcars

# 2.1 Log transformation (log(1+x) to avoid issues if zeros ever appear)
mt_log <- log1p(mt)

# 2.2 Standard scaling (z-score)
mt_z <- as.data.frame(scale(mt))

# 2.3 Min-max scaling (caret range)
mm <- preProcess(mt, method = c("range"))
mt_minmax <- predict(mm, mt)

# Compare summary for one column (mpg) and overall ranges
cat("\nSummary comparison (mpg):\n")
cat("Raw mpg:\n"); print(summary(mt$mpg))
cat("Log mpg (log1p):\n"); print(summary(mt_log$mpg))
cat("Z-score mpg:\n"); print(summary(mt_z$mpg))
cat("Min-max mpg:\n"); print(summary(mt_minmax$mpg))

cat("\nFindings:\n")
cat("- Log transform compresses large values and reduces right-skew, but changes scale.\n")
cat("- Standard scaling centers to mean 0 and sd 1; good for distance-based models.\n")
cat("- Min-max scaling maps values into [0,1]; preserves shape but sensitive to outliers.\n")

# Export a few outputs for submission evidence
write.csv(head(mt_log, 10), file.path(out_dir, "mtcars_log_head10.csv"), row.names = TRUE)
write.csv(head(mt_z, 10), file.path(out_dir, "mtcars_zscore_head10.csv"), row.names = TRUE)
write.csv(head(mt_minmax, 10), file.path(out_dir, "mtcars_minmax_head10.csv"), row.names = TRUE)

cat("\nSaved outputs to:", normalizePath(out_dir), "\n")

