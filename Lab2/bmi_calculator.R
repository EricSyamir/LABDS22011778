weight <- as.numeric(readline(prompt = "Enter weight (kg): "))
height <- as.numeric(readline(prompt = "Enter height (cm): "))

height_m <- height / 100
bmi <- weight / (height_m^2)

if (bmi < 18.5) {
  status <- "Underweight"
} else if (bmi < 25) {
  status <- "Normal"
} else if (bmi < 30) {
  status <- "Overweight"
} else {
  status <- "Obese"
}

print(paste("Your BMI is:", round(bmi, 2)))
print(paste("Status:", status))
