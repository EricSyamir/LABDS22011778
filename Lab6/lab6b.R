# TEB2164 Introduction to Data Science
# Lab 6b - Create, display, access and modify using data frame

# =============================================================================
# Activity 1: Store the table in a data frame
# =============================================================================
Name <- c("John", "Jane", "Bob")
Age <- c(25, 30, 28)
Gender <- c("M", "F", "M")

df <- data.frame(Name, Age, Gender)

cat("Activity 1 - Data frame:\n")
print(df)

# =============================================================================
# Activity 2: Add new column
# =============================================================================
df$Score <- c(85, 90, 78)

cat("\nActivity 2 - After adding Score column:\n")
print(df)

# =============================================================================
# Activity 3: Add new row
# =============================================================================
new_row <- data.frame(Name = "Alice", Age = 32, Gender = "F", Score = 92)
df <- rbind(df, new_row)

cat("\nActivity 3 - After adding new row:\n")
print(df)

# =============================================================================
# Activity 4: Display structures, summary, and dimensions
# =============================================================================
cat("\nActivity 4 - Structure (str):\n")
str(df)

cat("\nSummary:\n")
summary(df)

cat("\nNumber of rows:", nrow(df), "\n")
cat("Number of columns:", ncol(df), "\n")

# -----------------------------------------------------------------------------
# Observation/Insight - Data type and summary:
# When Age and Score are numeric, summary() gives min, 1st qu, median, mean,
# 3rd qu, max, and NA count. If these columns are stored as character (chr),
# summary() only shows length, class, and mode. Converting numeric columns
# to the correct type (as.numeric()) enables meaningful statistical summaries.
# -----------------------------------------------------------------------------
cat("\n--- Insight: Try changing column data types ---\n")
cat("If Age/Score were character, summary would show length/class only.\n")
cat("Using as.numeric() on numeric columns enables proper statistical summary.\n")

# Example: Compare summary when Age is character vs numeric
df_char <- df
df_char$Age <- as.character(df_char$Age)
cat("\nSummary when Age is character:\n")
summary(df_char$Age)
cat("\nSummary when Age is numeric:\n")
summary(df$Age)
