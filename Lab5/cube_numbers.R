# Lab 5b - Activity 2: Display the cube of the number up to a given integer

# Main program
cat("Input an integer: ")
n <- as.integer(readline())

for (i in 1:n) {
  cube <- i^3
  cat("Number is:", i, "and cube of the", i, "is :", cube, "\n")
}
