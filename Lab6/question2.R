# Lab 6b - Question 2: Using same table as Question 1, add new column 'qualify'

name <- c("Anastasia", "Dima", "Michael", "Matthew", "Laura", "Kevin", "Jonas")
score <- c(12.5, 9.0, 16.5, 12.0, 9.0, 8.0, 19.0)
attempts <- c(1, 3, 2, 3, 2, 1, 2)

df <- data.frame(name, score, attempts)

# Add new column 'qualify'
qualify <- c("yes", "no", "yes", "no", "no", "no", "yes")
df$qualify <- qualify

print("--- Question 2: Data Frame with 'qualify' column ---")
print(df)
