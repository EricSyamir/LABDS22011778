Array1 <- array(seq(1, 24), dim = c(2, 4, 3))
cat("Array1\n")
print(Array1)

Array2 <- array(seq(25, 54), dim = c(3, 2, 5))
cat("\nArray2\n")
print(Array2)

result1 <- Array1[2, , 2]
cat("\nThe second row of the second matrix of the array:\n")
print(result1)

result2 <- Array2[3, 2, 1]
cat("\nThe element in the 3rd row and 2nd column of the 1st matrix:\n")
print(result2)
