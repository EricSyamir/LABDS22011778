seq_numbers <- seq(1, 20)
squares <- seq_numbers^2
print("Sequence of 20 numbers:")
print(seq_numbers)
print("Squares of the numbers:")
print(squares)

num1 <- 0.956786
num2 <- 7.8345901
print(paste("num1 (2 decimal places):", round(num1, 2)))
print(paste("num2 (3 decimal places):", round(num2, 3)))

radius <- as.numeric(readline(prompt = "Enter the radius of the circle: "))
area <- pi * radius^2
print(paste("The area of the circle with radius", radius, "is:", round(area, 2)))
