# Lab 6b - Question 3: Using same table as Question 1, add new row for Emily

name <- c("Anastasia", "Dima", "Michael", "Matthew", "Laura", "Kevin", "Jonas")
score <- c(12.5, 9.0, 16.5, 12.0, 9.0, 8.0, 19.0)
attempts <- c(1, 3, 2, 3, 2, 1, 2)
qualify <- c("yes", "no", "yes", "no", "no", "no", "yes")

df <- data.frame(name, score, attempts, qualify)

# Add new row for Emily
new_row <- data.frame(name = "Emily", score = 14.5, attempts = 1, qualify = "yes")
df <- rbind(df, new_row)

print("--- Question 3: Data Frame with Emily's row ---")
print(df)
