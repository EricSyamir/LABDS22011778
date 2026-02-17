# Lab Project 1: Data Cleaning and Analysis

## Overview

This project focuses on cleaning and analyzing an unclean dataset containing student enrollment information. The dataset includes messy data formats, missing values, duplicates, and inconsistent formatting that requires comprehensive cleaning.

## Dataset

The project uses `Unclean Dataset.csv` which contains student records with the following fields:
- **Student_ID**: Student identification number
- **First_Name**: Student's first name
- **Last_Name**: Student's last name
- **Age**: Student's age
- **Gender**: Student's gender (M/F)
- **Course**: Course enrollment (Data Science, Machine Learning, Web Development, etc.)
- **Enrollment_Date**: Date of enrollment
- **Total_Payments**: Total payment amount

### Data Quality Issues

The original dataset contains various data quality issues:
- Multiple data formats (pipe-delimited and comma-delimited)
- Missing/null values across multiple columns
- Duplicate records and duplicate Student IDs
- Inconsistent currency formatting (£, $, ₦, with commas and spaces)
- Mixed date formats
- Inconsistent course name spellings
- Age values mixed with gender indicators

## Features

### Data Cleaning Script (`clean_dataset.py`)

The script performs comprehensive data cleaning operations:

1. **Multi-format Parsing**
   - Handles pipe-delimited (`|`) and comma-delimited formats
   - Automatically detects and parses different data structures

2. **Data Standardization**
   - Cleans currency values (removes symbols, commas, spaces)
   - Extracts and validates ages from messy strings
   - Standardizes gender values (M/F)
   - Normalizes course names (fixes typos and variations)
   - Parses dates from multiple formats

3. **Duplicate Removal**
   - Removes exact duplicate rows
   - Removes duplicate Student IDs (keeps first occurrence)

4. **Missing Value Handling**
   - Identifies missing values across all columns
   - Removes records with any missing/null values

5. **Data Quality Analysis**
   - Calculates data quality scores
   - Analyzes completeness and uniqueness metrics
   - Generates comprehensive statistics

6. **Visualization**
   - Creates dashboard with multiple charts:
     - Before/After record comparison
     - Missing values analysis
     - Data retention rate
     - Duplicate analysis
     - Data quality metrics

7. **Reporting**
   - Generates detailed text report with cleaning statistics
   - Provides executive summary and cleaning actions performed

## Requirements

### Python Packages

```bash
pip install pandas matplotlib
```

Required packages:
- `pandas` - Data manipulation and analysis
- `matplotlib` - Data visualization

## Usage

### Running the Cleaning Script

1. Navigate to the project directory:
   ```bash
   cd "Lab Project 1"
   ```

2. Run the cleaning script:
   ```bash
   python clean_dataset.py
   ```

### Output Files

The script generates the following output files:

1. **`Cleaned_Dataset.csv`**
   - Final cleaned dataset with no missing values
   - Standardized formats and data types
   - No duplicate records

2. **`cleaning_visualization.png`**
   - Comprehensive dashboard showing:
     - Record counts before/after cleaning
     - Missing values by column
     - Data retention rate
     - Duplicate analysis
     - Data quality metrics

3. **`cleaning_report.txt`**
   - Detailed text report including:
     - Executive summary
     - Missing values analysis
     - Duplicate analysis
     - Data types
     - Cleaning actions performed
     - Final dataset status

## Script Output

When you run the script, you'll see:

```
================================================================================
                         DATA CLEANING PROCESS STARTED                          
================================================================================

[Loading and parsing data...]
[OK] Loaded 135 records (before cleaning)

[Analyzing uncleaned data...]

================================================================================
                       UNCLEANED DATA CLEANING STATISTICS                      
================================================================================

[Dataset Overview]
   Total Rows: 135
   Total Columns: 8
   Data Quality Score: 61.02/100

[Missing Values Analysis]
   Total Missing Values: 138
   ...

[Duplicate Analysis]
   Duplicate Rows: 9
   Duplicate Student IDs: 88

[Removing records with missing values...]
[OK] Removed 7 records with missing values

[Creating visualizations...]
Visualization saved to: cleaning_visualization.png

[Generating cleaning report...]
Cleaning report saved to: cleaning_report.txt

================================================================================
                                CLEANING SUMMARY                                
================================================================================

[OK] Cleaned dataset written to: Cleaned_Dataset.csv
[OK] Visualization saved to: cleaning_visualization.png
[OK] Report saved to: cleaning_report.txt

[Final Statistics]
   Rows before removing nulls: 47
   Rows after removing nulls: 40
   Records removed: 7
   Retention rate: 85.1%
   Data quality improvement: 61.02 -> 100.00
```

## Data Cleaning Process

### Step 1: Data Loading
- Reads the unclean dataset with multiple encoding support
- Handles special characters and encoding issues

### Step 2: Data Parsing
- Parses pipe-delimited records
- Parses comma-delimited records
- Handles quoted values and special characters

### Step 3: Data Cleaning
- Standardizes currency values to numeric format
- Extracts valid ages (filters invalid ranges)
- Normalizes gender to M/F format
- Standardizes course names
- Parses dates to datetime format

### Step 4: Duplicate Removal
- Removes exact duplicate rows
- Removes duplicate Student IDs (keeps first occurrence)

### Step 5: Missing Value Removal
- Identifies all missing/null values
- Removes records with any missing values

### Step 6: Output Generation
- Saves cleaned dataset
- Generates visualization dashboard
- Creates detailed cleaning report

## Data Quality Metrics

The script calculates several data quality metrics:

- **Completeness**: Percentage of non-missing values
- **Uniqueness**: Percentage of unique records (based on Student_ID)
- **Overall Quality Score**: Average of completeness and uniqueness

## File Structure

```
Lab Project 1/
├── README.md                      # This file
├── Unclean Dataset.csv            # Original messy dataset
├── clean_dataset.py               # Data cleaning script
├── Cleaned_Dataset.csv            # Output: Cleaned dataset
├── cleaning_visualization.png     # Output: Visualization dashboard
└── cleaning_report.txt            # Output: Cleaning report
```

## Notes

- The script automatically handles multiple data formats and encoding issues
- All cleaning operations are logged and reported
- The visualization provides a quick overview of the cleaning process
- The cleaned dataset is ready for further analysis
