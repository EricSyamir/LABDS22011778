name <- readline(prompt = "Enter name: ")
phone <- readline(prompt = "Enter phone number: ")

name_upper <- toupper(name)
phone_digits <- gsub("[^0-9]", "", phone)
n <- nchar(phone_digits)

if (n >= 7) {
  first_3 <- substr(phone_digits, 1, 3)
  last_4 <- substr(phone_digits, n - 3, n)
  phone_display <- paste0(first_3, "-", last_4)
} else {
  phone_display <- phone
}

print(paste("Name:", name_upper))
print(paste("Phone:", phone_display))
