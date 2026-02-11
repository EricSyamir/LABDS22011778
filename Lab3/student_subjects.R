student_record <- list(
  Name = c("Robert", "Hemsworth", "Scarlett", "Evans", "Pratt", "Larson", "Holland", "Paul", "Simu", "Renner"),
  Exam_Score = c(59, 71, 83, 68, 65, 57, 62, 92, 92, 59),
  Chemistry = c(59, 71, 83, 68, 65, 57, 62, 92, 92, 59),
  Physics = c(89, 86, 65, 52, 60, 67, 40, 77, 90, 61)
)

chem_fail <- sum(student_record$Chemistry <= 49)
cat("Number of students who failed Chemistry (<=49):", chem_fail, "\n")

physics_fail <- sum(student_record$Physics <= 49)
cat("Number of students who failed Physics (<=49):", physics_fail, "\n")

chem_highest <- max(student_record$Chemistry)
chem_top_students <- student_record$Name[student_record$Chemistry == chem_highest]
cat("Highest Chemistry score:", chem_highest, "- Student(s):", paste(chem_top_students, collapse = ", "), "\n")

physics_highest <- max(student_record$Physics)
physics_top_students <- student_record$Name[student_record$Physics == physics_highest]
cat("Highest Physics score:", physics_highest, "- Student(s):", paste(physics_top_students, collapse = ", "), "\n")
