# Lab 7b - Report: Insights from data (df from Lab6/question4.R)
# Uses all libraries from Lab7a: dplyr, writexl, base (na.omit, str, summary, etc.)

library(dplyr)
if (!require("writexl", quietly = TRUE)) install.packages("writexl", repos = "https://cran.r-project.org/")
library(writexl)

# -----------------------------------------------------------------------------
# Create data (same as Lab6/question4.R)
# -----------------------------------------------------------------------------
name <- c("Anastasia", "Dima", "Michael", "Matthew", "Laura", "Kevin", "Jonas")
score <- c(12.5, 9.0, 16.5, 12.0, 9.0, 8.0, 19.0)
attempts <- c(1, 3, 2, 3, 2, 1, 2)
qualify <- c("yes", "no", "yes", "no", "no", "no", "yes")

df <- data.frame(name, score, attempts, qualify)
new_row <- data.frame(name = "Emily", score = 14.5, attempts = 1, qualify = "yes")
df <- rbind(df, new_row)
df$qualify <- as.factor(df$qualify)

# Lab7a: clean data
df_cleaned <- na.omit(df)
n_total <- nrow(df_cleaned)

# -----------------------------------------------------------------------------
# REPORT (using Lab7a: filter, arrange, str, summary, colnames, export)
# -----------------------------------------------------------------------------
cat("\n")
cat("################################################################################\n")
cat("#                    LAB 7b – INSIGHTS REPORT                                  #\n")
cat("#         Dataset: Student scores (Lab6/question4.R)                            #\n")
cat("################################################################################\n\n")

# --- Structure (Lab7a: str, dimensions) ---
cat("────────────────── 1. DATA STRUCTURE ──────────────────\n")
str(df_cleaned)
cat("Rows:", nrow(df_cleaned), "  |  Columns:", ncol(df_cleaned), "\n")
cat("Column names:", paste(colnames(df_cleaned), collapse = ", "), "\n\n")

# --- Summary (Lab7a: summary) ---
cat("────────────────── 2. SUMMARY ──────────────────\n")
print(summary(df_cleaned))
cat("\n")

# --- Percentage-style insights (like "80% from Cherbourg survived") ---
qualified <- df_cleaned %>% filter(qualify == "yes")
not_qualified <- df_cleaned %>% filter(qualify == "no")

pct_yes <- round(100 * nrow(qualified) / n_total, 0)
pct_no  <- round(100 * nrow(not_qualified) / n_total, 0)

cat("────────────────── 3. KEY INSIGHTS (percentages) ──────────────────\n\n")

cat("  • ", pct_yes, "% of students qualified (yes) and ", pct_no, "% did not (no).\n", sep = "")
cat("  • Among those who qualified, ", round(100 * sum(qualified$attempts == 1) / nrow(qualified), 0),
    "% passed in 1 attempt.\n", sep = "")

high_score <- df_cleaned %>% filter(score >= 12)
pct_high <- round(100 * nrow(high_score) / n_total, 0)
cat("  • ", pct_high, "% of students scored 12 or above.\n", sep = "")

low_score <- df_cleaned %>% filter(score < 10)
pct_low <- round(100 * nrow(low_score) / n_total, 0)
cat("  • ", pct_low, "% scored below 10 (", paste(low_score$name, collapse = ", "), ").\n", sep = "")

three_attempts <- df_cleaned %>% filter(attempts == 3)
pct_3att <- round(100 * nrow(three_attempts) / n_total, 0)
cat("  • ", pct_3att, "% needed 3 attempts, and ", round(100 - pct_3att, 0),
    "% needed 1 or 2 attempts.\n", sep = "")

# Qualified + high score (combined condition, Lab7a style)
qual_high <- df_cleaned %>% filter(qualify == "yes", score >= 14)
pct_qh <- round(100 * nrow(qual_high) / n_total, 0)
cat("  • ", pct_qh, "% both qualified and scored 14+ (", paste(qual_high$name, collapse = ", "), ").\n", sep = "")

# One-attempt qualifiers
one_att_yes <- df_cleaned %>% filter(attempts == 1, qualify == "yes")
pct_1y <- round(100 * nrow(one_att_yes) / n_total, 0)
cat("  • ", pct_1y, "% qualified in a single attempt (", paste(one_att_yes$name, collapse = ", "), ").\n\n", sep = "")

# --- Arranging (Lab7a: arrange) ---
cat("────────────────── 4. TOP SCORERS (arrange by score, Lab7a) ──────────────────\n")
top3 <- df_cleaned %>% arrange(desc(score)) %>% head(3)
print(top3)
cat("\n")

# --- Export (Lab7a: write.csv, write_xlsx) ---
write.csv(df_cleaned, "lab7b_report_data.csv", row.names = FALSE)
write_xlsx(as.data.frame(qualified), "lab7b_qualified_students.xlsx")

df_sorted <- df_cleaned %>% arrange(desc(score))
write.csv(df_sorted, "lab7b_sorted_by_score.csv", row.names = FALSE)

cat("────────────────── 5. EXPORTS ──────────────────\n")
cat("  lab7b_report_data.csv         – full cleaned dataset\n")
cat("  lab7b_qualified_students.xlsx – qualified students only\n")
cat("  lab7b_sorted_by_score.csv     – all students sorted by score (desc)\n")
cat("\n################################################################################\n")
