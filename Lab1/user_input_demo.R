name <- readline(prompt = "Enter name: ")
age <- readline(prompt = "Enter age: ")
age <- as.numeric(age)
print(paste("Hi,", name, "this year you are", age, "years old."))
