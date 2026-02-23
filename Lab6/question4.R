# Lab 6b - Question 4: Display structure, summary, rows/columns, and observation

name <- c("Anastasia", "Dima", "Michael", "Matthew", "Laura", "Kevin", "Jonas")
score <- c(12.5, 9.0, 16.5, 12.0, 9.0, 8.0, 19.0)
attempts <- c(1, 3, 2, 3, 2, 1, 2)
qualify <- c("yes", "no", "yes", "no", "no", "no", "yes")

df <- data.frame(name, score, attempts, qualify)
new_row <- data.frame(name = "Emily", score = 14.5, attempts = 1, qualify = "yes")
df <- rbind(df, new_row)

# Change 'qualify' column to factor for categorical summary count (as per clue)
df$qualify <- as.factor(df$qualify)

print("--- Data Frame Structure ---")
str(df)

print(paste("Number of rows:", nrow(df)))
print(paste("Number of columns:", ncol(df)))

print("--- Data Frame Summary ---")
summary(df)

print("--- Observation / Insight of the Dataset ---")
print("Score ranges from 8.0 to 19.0 with mean ~12.56. Average attempts ~1.88.")
print("By changing qualify to factor, summary shows categorical counts: 4 yes, 4 no (even split).")
