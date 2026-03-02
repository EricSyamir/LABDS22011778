# Lab 7a - Managing data frame (using df from Lab6/question4.R)

# -----------------------------------------------------------------------------
# 1. Creating data frame (same as Lab6/question4.R - replaces importing)
# -----------------------------------------------------------------------------
name <- c("Anastasia", "Dima", "Michael", "Matthew", "Laura", "Kevin", "Jonas")
score <- c(12.5, 9.0, 16.5, 12.0, 9.0, 8.0, 19.0)
attempts <- c(1, 3, 2, 3, 2, 1, 2)
qualify <- c("yes", "no", "yes", "no", "no", "no", "yes")

df <- data.frame(name, score, attempts, qualify)
new_row <- data.frame(name = "Emily", score = 14.5, attempts = 1, qualify = "yes")
df <- rbind(df, new_row)
df$qualify <- as.factor(df$qualify)

print("--- 1. Data frame (from Lab6/question4.R) ---")
print(df)

# 1.2. Identify and setting folder path
print("\n--- 1.2. Working directory ---")
print(getwd())
# setwd('C:/Users/User/Desktop')  # Optional: change as needed
print("Files in directory:")
print(list.files())

# -----------------------------------------------------------------------------
# 2. Identifying NA/empty cells in data frame
# -----------------------------------------------------------------------------
# Add NAs for demonstration (df originally has none)
df_with_na <- df
df_with_na[2, 2] <- NA   # Dima's score
df_with_na[5, 3] <- NA   # Laura's attempts

print("\n--- 2. Identifying NA values ---")
print("Total NA in df_with_na:")
print(sum(is.na(df_with_na)))
print("Positions of NA:")
print(which(is.na(df_with_na)))

# Demo with smaller dataset
demo <- c(1, 2, NA, 4, NA, 6, 7)
print("Demo: sum(is.na(demo)) ="); print(sum(is.na(demo)))
print("Demo: which(is.na(demo)) ="); print(which(is.na(demo)))

print("NA count per column:")
print(sapply(df_with_na, function(x) sum(is.na(x))))

# -----------------------------------------------------------------------------
# 3. Managing NA/empty cells
# -----------------------------------------------------------------------------
print("\n--- 3. Managing NA (na.omit) ---")
print("Before cleaning:"); print(dim(df_with_na))
df_cleaned <- na.omit(df_with_na)
print("After na.omit:"); print(dim(df_cleaned))
print(df_cleaned)

# -----------------------------------------------------------------------------
# 4. Filtering values in data frame
# -----------------------------------------------------------------------------
# 4.1. Load dplyr
cran <- "https://cran.r-project.org/"
user_lib <- Sys.getenv("R_LIBS_USER")
if (!require("dplyr", quietly = TRUE)) install.packages("dplyr", lib = user_lib, repos = cran)
library(dplyr)

# 4.2. Get column names
print("\n--- 4.2. Column names ---")
print(colnames(df_cleaned))
print(names(df_cleaned))

# 4.3. Renaming (demo: if we had spaces, gsub would replace with underscore)
# Our columns have no spaces; showing the pattern:
# names(df_cleaned) <- gsub(" ", "_", colnames(df_cleaned))

# 4.4. Filtering
print("\n--- 4.4. Filtering ---")
print("Filter: qualify == 'yes':")
print(filter(df_cleaned, qualify == "yes"))
print("Filter: score > 12:")
print(filter(df_cleaned, score > 12))

# -----------------------------------------------------------------------------
# 5. Searching - multiple conditions
# -----------------------------------------------------------------------------
print("\n--- 5. Filter by multiple conditions ---")
print("qualify == 'yes' AND score > 10:")
print(filter(df_cleaned, qualify == "yes" & score > 10))
# Or with pipe:
df_qualified <- df_cleaned %>% filter(qualify == "yes")
print("Qualified students (yes):"); print(df_qualified)

# -----------------------------------------------------------------------------
# 6. Arranging (sorting)
# -----------------------------------------------------------------------------
print("\n--- 6. Arranging by score ---")
df_sort_asc <- arrange(df_cleaned, score)
print("Sorted by score (ascending):"); print(df_sort_asc)
df_sort_desc <- arrange(df_cleaned, desc(score))
print("Sorted by score (descending):"); print(df_sort_desc)

# -----------------------------------------------------------------------------
# 7. Exporting to Excel and CSV
# -----------------------------------------------------------------------------
if (!require("writexl", quietly = TRUE)) install.packages("writexl", lib = user_lib, repos = cran)
library(writexl)
write_xlsx(as.data.frame(df_qualified), "df_qualified.xlsx")
write.csv(df_sort_desc, "df_sort_by_score.csv", row.names = FALSE)

print("\n--- 7. Exported ---")
print("df_qualified.xlsx (students who qualified)")
print("df_sort_by_score.csv (sorted by score descending)")
