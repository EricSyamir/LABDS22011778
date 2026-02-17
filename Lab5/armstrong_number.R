# Lab 5b - Activity 3: Check Armstrong number of n digits
# An Armstrong number is one whose sum of digits raised to the power three equals the number itself
# Example: 1^3 + 6^3 + 3^3 + 4^3 = 1634

# Function to check if a number is an Armstrong number
check_armstrong <- function(num) {
  # Convert number to string to get individual digits
  num_str <- as.character(num)
  n_digits <- nchar(num_str)
  
  # Calculate sum of digits raised to the power of number of digits
  sum_power <- 0
  for (i in 1:n_digits) {
    digit <- as.integer(substr(num_str, i, i))
    sum_power <- sum_power + digit^n_digits
  }
  
  # Check if sum equals the original number
  return(sum_power == num)
}

# Main program
cat("Check whether an n digits number is Armstrong or not:\n")
cat("-----------------------------------------------------------\n")
cat("Input an integer: ")
num <- as.integer(readline())

if (check_armstrong(num)) {
  cat(num, "is an Armstrong number.\n")
} else {
  cat(num, "is not an Armstrong number.\n")
}
