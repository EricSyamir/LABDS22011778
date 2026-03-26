# Lab 8b - Visualization report
# Requirements:
# 1) Improve Lab7 report using the same dataset as Lab6/question4.R, supported by >=2 plot types
# 2) Choose ONE built-in dataset and use visualization to tell a story

cran <- "https://cran.r-project.org/"
user_lib <- Sys.getenv("R_LIBS_USER")

if (!require("dplyr", quietly = TRUE)) install.packages("dplyr", lib = user_lib, repos = cran)
library(dplyr)

out_dir <- "Lab8"
if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE)

cat("=== Lab 8b ===\n")

# -----------------------------------------------------------------------------
# Part 1: Improve Lab7 report using df (from Lab6/question4.R)
# -----------------------------------------------------------------------------
name <- c("Anastasia", "Dima", "Michael", "Matthew", "Laura", "Kevin", "Jonas")
score <- c(12.5, 9.0, 16.5, 12.0, 9.0, 8.0, 19.0)
attempts <- c(1, 3, 2, 3, 2, 1, 2)
qualify <- c("yes", "no", "yes", "no", "no", "no", "yes")

df <- data.frame(name, score, attempts, qualify)
df <- rbind(df, data.frame(name = "Emily", score = 14.5, attempts = 1, qualify = "yes"))
df$qualify <- as.factor(df$qualify)
df <- na.omit(df)

# Key summaries
n_total <- nrow(df)
qualified <- df %>% filter(qualify == "yes")
pct_yes <- round(100 * nrow(qualified) / n_total, 0)
avg_score <- round(mean(df$score), 2)
avg_attempts <- round(mean(df$attempts), 2)

top3 <- df %>% arrange(desc(score)) %>% head(3)

# Report text (creative formatting)
report_path <- file.path(out_dir, "lab8b_report.txt")
cat(
  paste0(
    "LAB 8b - Visualization Supported Report\n",
    "======================================\n\n",
    "Dataset: Student score data (from Lab6/question4.R)\n",
    "Rows: ", n_total, " | Columns: ", ncol(df), "\n\n",
    "Summary:\n",
    "- Qualification rate: ", pct_yes, "% qualified\n",
    "- Average score: ", avg_score, "\n",
    "- Average attempts: ", avg_attempts, "\n\n",
    "Top 3 scorers:\n",
    paste0("1) ", top3$name[1], " (", top3$score[1], ")\n"),
    paste0("2) ", top3$name[2], " (", top3$score[2], ")\n"),
    paste0("3) ", top3$name[3], " (", top3$score[3], ")\n"),
    "\n",
    "Visual evidence saved as PNG:\n",
    "- lab8b_bar_scores.png (bar chart)\n",
    "- lab8b_boxplot_score_by_qualify.png (box plot)\n",
    "- lab8b_scatter_attempts_vs_score.png (scatter plot)\n\n"
  ),
  file = report_path
)

# Plot 1: Bar chart of scores by student
png(file = file.path(out_dir, "lab8b_bar_scores.png"), width = 1000, height = 700)
barplot(df$score,
  names.arg = df$name,
  las = 2,
  col = ifelse(df$qualify == "yes", "seagreen3", "tomato3"),
  main = "Student Scores (green=qualified, red=not qualified)",
  ylab = "Score"
)
legend("topright", legend = c("yes", "no"), fill = c("seagreen3", "tomato3"), cex = 0.9)
dev.off()

# Plot 2: Box plot of score by qualify
png(file = file.path(out_dir, "lab8b_boxplot_score_by_qualify.png"), width = 900, height = 700)
boxplot(score ~ qualify,
  data = df,
  col = c("tomato3", "seagreen3"),
  main = "Score distribution by qualification",
  xlab = "Qualify",
  ylab = "Score"
)
dev.off()

# Plot 3: Scatter plot attempts vs score
png(file = file.path(out_dir, "lab8b_scatter_attempts_vs_score.png"), width = 900, height = 700)
plot(
  x = df$attempts, y = df$score,
  pch = 19,
  col = ifelse(df$qualify == "yes", "seagreen3", "tomato3"),
  xlab = "Attempts",
  ylab = "Score",
  main = "Attempts vs Score"
)
text(df$attempts, df$score, labels = df$name, pos = 3, cex = 0.75)
dev.off()

# -----------------------------------------------------------------------------
# Part 2: Built-in dataset story visualization
# Choose dataset: BJsales (monthly sales) – present as sales performance story
# -----------------------------------------------------------------------------
cat("\n--- Built-in dataset story: BJsales ---\n")
data(BJsales)

sales <- as.numeric(BJsales)
time_idx <- seq_along(sales)

png(file = file.path(out_dir, "lab8b_bjsales_trend.png"), width = 1000, height = 700)
plot(time_idx, sales,
  type = "o",
  col = "dodgerblue4",
  xlab = "Time (index)",
  ylab = "Sales",
  main = "BJsales performance trend"
)
abline(h = mean(sales), col = "darkorange3", lwd = 2, lty = 2)
legend("topleft", legend = c("Sales", "Average"), col = c("dodgerblue4", "darkorange3"),
  lty = c(1, 2), lwd = c(2, 2), cex = 0.9
)
dev.off()

png(file = file.path(out_dir, "lab8b_bjsales_hist.png"), width = 900, height = 700)
hist(sales,
  breaks = 12,
  col = "gold",
  border = "gray30",
  main = "BJsales distribution",
  xlab = "Sales"
)
dev.off()

# Add a short story note
cat(
  paste0(
    "\nBuilt-in dataset story (BJsales):\n",
    "- Trend plot shows how sales move across time; the dashed line is the average.\n",
    "- Histogram shows typical sales range and how often high/low values occur.\n",
    "Saved: lab8b_bjsales_trend.png, lab8b_bjsales_hist.png\n"
  )
)

cat("\nSaved report:", normalizePath(report_path), "\n")

