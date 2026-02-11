scores <- c(33, 24, 54, 94, 16, 89, 60, 6, 77, 61, 13, 44, 26, 24, 73, 73, 90, 39, 90, 54)

get_grade <- function(score) {
  if (score >= 90) return("A")
  if (score >= 80) return("B")
  if (score >= 70) return("C")
  if (score >= 60) return("D")
  if (score >= 50) return("E")
  return("F")
}

grades <- sapply(scores, get_grade)
cat("Score\tGrade\tNumber of students\n")
cat("90-100\tA\t", sum(grades == "A"), "\n")
cat("80-89\tB\t", sum(grades == "B"), "\n")
cat("70-79\tC\t", sum(grades == "C"), "\n")
cat("60-69\tD\t", sum(grades == "D"), "\n")
cat("50-59\tE\t", sum(grades == "E"), "\n")
cat("<=49\tF\t", sum(grades == "F"), "\n")

passed <- scores > 49
cat("\nPass/Fail (>49):\n")
print(passed)
