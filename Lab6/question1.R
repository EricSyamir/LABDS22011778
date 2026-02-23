# Lab 6b - Question 1: Create and store the table in a data frame

name <- c("Anastasia", "Dima", "Michael", "Matthew", "Laura", "Kevin", "Jonas")
score <- c(12.5, 9.0, 16.5, 12.0, 9.0, 8.0, 19.0)
attempts <- c(1, 3, 2, 3, 2, 1, 2)

df <- data.frame(name, score, attempts)

print("--- Question 1: Original Data Frame ---")
print(df)
