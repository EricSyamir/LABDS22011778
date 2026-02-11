student_record <- list(
  Name = c("Robert", "Hemsworth", "Scarlett", "Evans", "Pratt", "Larson", "Holland", "Paul", "Simu", "Renner"),
  Exam_Score = c(59, 71, 83, 68, 65, 57, 62, 92, 92, 59)
)

highest <- max(student_record$Exam_Score)
lowest <- min(student_record$Exam_Score)
average <- mean(student_record$Exam_Score)

cat("Highest exam score:", highest, "\n")
cat("Lowest exam score:", lowest, "\n")
cat("Average exam score:", round(average, 2), "\n")
