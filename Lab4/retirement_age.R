age <- c(55, 57, 56, 52, 51, 59, 58, 53, 59, 55, 60, 60, 60, 60, 52, 55, 56, 51, 60, 52, 54, 56, 52, 57, 54, 56, 58, 53, 53, 50, 55, 51, 57, 60, 57, 55, 51, 50, 57, 58)

age_factor <- factor(age)
levels_vec <- sort(as.numeric(levels(age_factor)))

cat("Staff Age\tTotal number of staff\n")
for (a in levels_vec) {
  count <- sum(age == a)
  cat(a, "\t\t", count, "\n")
}

ranges <- c("50-52", "52-54", "54-56", "56-58", "58-60")
range_counts <- c(
  sum(age >= 50 & age < 52),
  sum(age >= 52 & age < 54),
  sum(age >= 54 & age < 56),
  sum(age >= 56 & age < 58),
  sum(age >= 58 & age <= 60)
)

cat("\nAge Range\tTotal number of staff\n")
for (i in 1:5) {
  cat(ranges[i], "\t\t", range_counts[i], "\n")
}

cat("\nInsight: Most staff retire between ages 56-60. The company has a concentration of retirements at 60 years old (5 staff), suggesting a mandatory retirement age policy.\n")
