# Lab 5b - Activity 1: Check whether a year is leap year or not
# A leap year is divisible by 4, but not by 100 unless also divisible by 400

# Function to check if a year is a leap year
check_leap_year <- function(year) {
  if (year %% 400 == 0) {
    return(TRUE)
  } else if (year %% 100 == 0) {
    return(FALSE)
  } else if (year %% 4 == 0) {
    return(TRUE)
  } else {
    return(FALSE)
  }
}

# Main program
cat("Input year: ")
year <- as.integer(readline())

if (check_leap_year(year)) {
  cat("Output:", year, "is a leap year.\n")
} else {
  cat("Output:", year, "is a not leap year.\n")
}
