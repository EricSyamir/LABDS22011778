string1 <- readline(prompt = "Enter first string: ")
string2 <- readline(prompt = "Enter second string: ")

if (tolower(string1) == tolower(string2)) {
  print("The inputs are the same.")
} else {
  print("The inputs are different.")
}
