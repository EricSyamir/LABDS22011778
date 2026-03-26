# Lab 8a - Built-in datasets & Data Visualization in R

# Ensure outputs go into this lab folder
out_dir <- "Lab8"
if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE)

cat("=== Lab 8a ===\n")

# 1. Using sample datasets from library
cat("\n--- 1.1 data() list of built-in datasets (truncated) ---\n")
data()

cat("\n--- 1.2 Load mtcars and preview ---\n")
data(mtcars)
print(head(mtcars, 10))

input <- mtcars[, c("mpg", "cyl")]
print(head(input))

# 2. Visualizing basic plots
# NOTE: demo(graphics) / demo(image) is interactive in many environments.
# We skip running those demos here and focus on producing the required plot types
# as files in the working directory.

cat("\n--- 2.2-2.4 Pie charts (saved to PNG) ---\n")
x <- c(21, 62, 10, 53)
labels <- c("London", "New York", "Singapore", "Mumbai")

png(file = file.path(out_dir, "city_pie_basic.png"), width = 900, height = 700)
pie(x, labels)
dev.off()

png(file = file.path(out_dir, "city_pie_title_colors.png"), width = 900, height = 700)
pie(x, labels, main = "City pie chart", col = rainbow(length(x)))
dev.off()

piepercent <- round(100 * x / sum(x), 1)
png(file = file.path(out_dir, "city_pie_percent_legend.png"), width = 900, height = 700)
pie(x, labels = paste0(piepercent, "%"), main = "City pie chart", col = rainbow(length(x)))
legend("topright", labels, cex = 0.9, fill = rainbow(length(x)))
dev.off()

cat("\n--- 2.5 3D pie chart (plotrix) ---\n")
cran <- "https://cran.r-project.org/"
user_lib <- Sys.getenv("R_LIBS_USER")
if (!require("plotrix", quietly = TRUE)) install.packages("plotrix", lib = user_lib, repos = cran)
library(plotrix)

png(file = file.path(out_dir, "city_pie_3d.png"), width = 900, height = 700)
pie3D(x, labels = labels, explode = 0.1, main = "Pie Chart of Cities")
dev.off()

cat("\n--- 2.6-2.7 Box plots (mtcars) ---\n")
png(file = file.path(out_dir, "boxplot_mpg_by_cyl.png"), width = 900, height = 700)
boxplot(mpg ~ cyl,
  data = mtcars,
  xlab = "Number of Cylinders",
  ylab = "Miles Per Gallon",
  main = "Mileage Data"
)
dev.off()

png(file = file.path(out_dir, "boxplot_mpg_by_cyl_notch.png"), width = 900, height = 700)
boxplot(mpg ~ cyl,
  data = mtcars,
  xlab = "Number of Cylinders",
  ylab = "Miles Per Gallon",
  main = "Mileage Data (Notched)",
  notch = TRUE,
  varwidth = TRUE,
  col = c("green", "yellow", "purple")
)
dev.off()

cat("\n--- 2.8-2.9 Histograms ---\n")
v <- c(9, 13, 21, 8, 36, 22, 12, 41, 31, 33, 19)

png(file = file.path(out_dir, "hist_basic.png"), width = 900, height = 700)
hist(v, xlab = "Weight", col = "yellow", border = "blue")
dev.off()

png(file = file.path(out_dir, "hist_ranges.png"), width = 900, height = 700)
hist(v,
  xlab = "Weight", col = "green", border = "red",
  xlim = c(0, 40), ylim = c(0, 5), breaks = 5
)
dev.off()

cat("\n--- 2.10-2.11 Scatterplots ---\n")
input2 <- mtcars[, c("wt", "mpg")]

png(file = file.path(out_dir, "scatter_wt_mpg.png"), width = 900, height = 700)
plot(
  x = input2$wt, y = input2$mpg,
  xlab = "Weight",
  ylab = "Mileage",
  xlim = c(2.5, 5),
  ylim = c(15, 30),
  main = "Weight vs Mileage"
)
dev.off()

png(file = file.path(out_dir, "pairs_matrix.png"), width = 900, height = 700)
pairs(~wt + mpg + disp + cyl, data = mtcars, main = "Scatterplot Matrix")
dev.off()

cat("\n--- 2.12-2.14 Bar charts ---\n")
H <- c(7, 12, 28, 3, 41)

png(file = file.path(out_dir, "bar_basic.png"), width = 900, height = 700)
barplot(H)
dev.off()

M <- c("Mar", "Apr", "May", "Jun", "Jul")
png(file = file.path(out_dir, "bar_labeled.png"), width = 900, height = 700)
barplot(H, names.arg = M, xlab = "Month", ylab = "Revenue", col = "blue",
  main = "Revenue chart", border = "red"
)
dev.off()

colors <- c("green", "orange", "brown")
months <- c("Mar", "Apr", "May", "Jun", "Jul")
regions <- c("East", "West", "North")
Values <- matrix(c(2, 9, 3, 11, 9, 4, 8, 7, 3, 12, 5, 2, 8, 10, 11),
  nrow = 3, ncol = 5, byrow = TRUE
)

png(file = file.path(out_dir, "bar_grouped.png"), width = 900, height = 700)
barplot(Values, main = "Total revenue", names.arg = months, xlab = "month",
  ylab = "revenue", col = colors
)
legend("topleft", regions, cex = 1.1, fill = colors)
dev.off()

png(file = file.path(out_dir, "bar_stacked.png"), width = 900, height = 700)
barplot(Values, main = "Total revenue (stacked)", names.arg = months, xlab = "month",
  ylab = "revenue", col = colors
)
legend("topleft", regions, cex = 1.1, fill = colors)
dev.off()

cat("\n--- 2.15-2.17 Line graphs ---\n")
v2 <- c(7, 12, 28, 3, 41)
t2 <- c(14, 7, 6, 19, 3)

png(file = file.path(out_dir, "line_basic.png"), width = 900, height = 700)
plot(v2, type = "o")
dev.off()

png(file = file.path(out_dir, "line_labeled.png"), width = 900, height = 700)
plot(v2, type = "o", col = "red", xlab = "Month", ylab = "Rain fall",
  main = "Rain fall chart"
)
dev.off()

png(file = file.path(out_dir, "line_multiple.png"), width = 900, height = 700)
plot(v2, type = "o", col = "red", xlab = "Month", ylab = "Rain fall",
  main = "Rain fall chart"
)
lines(t2, type = "o", col = "blue")
legend("topright", c("v", "t"), col = c("red", "blue"), lty = 1, pch = 1)
dev.off()

cat("\nSaved plot files in:", normalizePath(out_dir), "\n")

