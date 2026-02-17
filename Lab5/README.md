# Lab 5b - Selection Statement and Repetition Statement

This lab contains three R programs demonstrating selection and repetition statements.

## Programs

### 1. leap_year.R
Checks whether a given year is a leap year or not.
- A leap year is divisible by 4
- But not by 100 unless also divisible by 400

**Example:**
- Input: 2004 → Output: 2004 is a leap year.
- Input: 1900 → Output: 1900 is a not leap year.

### 2. cube_numbers.R
Displays the cube of numbers from 1 up to a given integer.

**Example:**
- Input: 5
- Output: Displays cubes from 1^3 to 5^3

### 3. armstrong_number.R
Checks whether an n-digit number is an Armstrong number.
An Armstrong number is one whose sum of digits raised to the power of the number of digits equals the number itself.

**Example:**
- Input: 1634
- Calculation: 1^4 + 6^4 + 3^4 + 4^4 = 1 + 1296 + 81 + 256 = 1634
- Output: 1634 is an Armstrong number.

## How to Run

Run each program in R or RStudio:
```r
source("leap_year.R")
source("cube_numbers.R")
source("armstrong_number.R")
```
