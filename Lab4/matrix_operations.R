V1 <- c(2, 3, 1, 5, 4, 6, 8, 7, 9)

Matrix1 <- matrix(V1, nrow = 3, ncol = 3, byrow = TRUE)
Matrix2 <- t(Matrix1)

rownames(Matrix1) <- c("R1", "R2", "R3")
colnames(Matrix1) <- c("C1", "C2", "C3")
rownames(Matrix2) <- c("R1", "R2", "R3")
colnames(Matrix2) <- c("C1", "C2", "C3")

cat("Matrix-1:\n")
print(Matrix1)
cat("\nMatrix-2 (Transpose):\n")
print(Matrix2)

cat("\nAddition (Matrix1 + Matrix2):\n")
print(Matrix1 + Matrix2)
cat("\nSubtraction (Matrix1 - Matrix2):\n")
print(Matrix1 - Matrix2)
cat("\nMultiplication (element-wise):\n")
print(Matrix1 * Matrix2)
cat("\nDivision (Matrix1 / Matrix2):\n")
print(Matrix1 / Matrix2)
