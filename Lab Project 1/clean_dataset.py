import csv
import re
from pathlib import Path
from typing import Dict, List, Optional

import matplotlib.pyplot as plt
import pandas as pd


PROJECT_ROOT = Path(__file__).parent
RAW_PATH = PROJECT_ROOT / "Unclean Dataset.csv"
OUTPUT_PATH = PROJECT_ROOT / "Cleaned_Dataset.csv"
VISUALIZATION_PATH = PROJECT_ROOT / "cleaning_visualization.png"
REPORT_PATH = PROJECT_ROOT / "cleaning_report.txt"


def clean_currency(value: Optional[str]) -> Optional[float]:
    """Convert messy currency strings like ' ?20,000.00 ', '$1200' to float."""
    if value is None:
        return None
    text = str(value)
    if not text or text.strip().upper() in {"NA", "N/A"}:
        return None

    # Remove quotes and surrounding spaces
    text = text.strip().strip('"').strip("'").strip()

    # Remove common currency symbols and question marks
    text = re.sub(r"[£$₦\?]", "", text)

    # Remove spaces and thousands separators
    text = text.replace(" ", "").replace(",", "")

    # Keep only digits and decimal point
    text = re.sub(r"[^0-9.]", "", text)

    if not text:
        return None

    try:
        return float(text)
    except ValueError:
        return None


def clean_age(value: Optional[str]) -> Optional[int]:
    """Extract numeric age from messy strings like 'F 24', '78*', '21*'."""
    if value is None:
        return None
    text = str(value).strip()
    if not text:
        return None

    # Remove gender letters and asterisks
    text = re.sub(r"[MFmf\*]", " ", text)

    # Extract first integer in the string
    match = re.search(r"\d{1,3}", text)
    if not match:
        return None
    try:
        age = int(match.group(0))
        # Filter out obviously invalid ages (e.g. 4, 78* etc. you may adjust as needed)
        if 10 <= age <= 80:
            return age
    except ValueError:
        return None
    return None


def clean_gender(*candidates: Optional[str]) -> Optional[str]:
    """Find a valid gender (M/F) among several messy candidate strings."""
    for val in candidates:
        if val is None:
            continue
        text = str(val).strip().upper()
        if not text:
            continue
        # Look for 'M' or 'F' anywhere in the token
        if "M" in text and "F" not in text:
            return "M"
        if "F" in text and "M" not in text:
            return "F"
    return None


def clean_course(raw: Optional[str]) -> Optional[str]:
    if raw is None:
        return None
    text = str(raw).strip().lower()
    if not text or text in {"na", "n/a"}:
        return None

    if "data science" in text:
        return "Data Science"
    if "machine learn" in text:
        return "Machine Learning"
    if "web develop" in text:
        return "Web Development"
    if "data analy" in text or "data analytics" in text:
        return "Data Analysis"
    if "cyber" in text:
        return "Cyber Security"

    # default: title-case the cleaned text
    return text.title()


def parse_date(raw: Optional[str]) -> Optional[pd.Timestamp]:
    if raw is None:
        return None
    text = str(raw).strip()
    if not text or text.upper() in {"NA", "N/A"}:
        return None

    # Let pandas try multiple formats
    # Try dayfirst=True first (for DD-MM-YY format), then fallback to standard
    dt = pd.to_datetime(text, errors="coerce", dayfirst=True)
    if pd.isna(dt):
        dt = pd.to_datetime(text, errors="coerce", dayfirst=False)
    if pd.isna(dt):
        return None
    return dt


def parse_pipe_line(line: str) -> Optional[Dict]:
    """
    Parse lines using the '|' separator, ignoring any duplicated record
    that appears after the first comma.
    """
    # Keep only part before the first comma to drop duplicated records
    head = line.split(",")[0]
    parts = [p.strip() for p in head.split("|")]
    if len(parts) < 8:
        return None

    student_id, first, last, age, gender, course, enroll_date, payment = parts[:8]

    record = {
        "Student_ID": int(student_id) if student_id.strip().isdigit() else None,
        "First_Name": first or None,
        "Last_Name": last or None,
        "Age": clean_age(age),
        "Gender": clean_gender(gender),
        "Course": clean_course(course),
        "Enrollment_Date": parse_date(enroll_date),
        "Total_Payments": clean_currency(payment),
    }
    return record


def parse_csv_line(line: str) -> Optional[Dict]:
    """
    Parse lines using comma delimiter (non '|' rows).
    These rows are quite messy, so we use heuristics:
    - If first column is numeric => Student_ID present.
    - Otherwise Student_ID is missing.
    """
    # Use csv reader to respect quotes
    reader = csv.reader([line])
    cols = next(reader, [])
    cols = [c.strip() for c in cols]
    if not cols or all(c == "" for c in cols):
        return None

    # Pad to at least 8 columns
    while len(cols) < 8:
        cols.append("")

    student_id = None
    first = last = age_raw = gender_raw = course_raw = enroll_date_raw = payment_raw = None

    if cols[0].isdigit():
        # Format: ID, First, Last, Age?, Gender?, Course, Date, Payment
        student_id = int(cols[0])
        first = cols[1] or None
        last = cols[2] or None
        # Some rows have age and gender mixed across col3 and col4
        age_raw = cols[3] or None
        gender_raw = cols[4] or None
        course_raw = cols[5] or None
        enroll_date_raw = cols[6] or None
        payment_raw = cols[7] or None
    else:
        # No explicit ID – assume: First, First(repeat), Last, Age?, Gender?, Course, Date, Payment
        first = cols[0] or None
        # sometimes first name is repeated; prefer non-empty last name
        last = cols[2] or cols[1] or None
        # age and gender often mixed in col3/col4/col5
        age_raw = cols[3] or cols[4] or None
        gender_raw = cols[3] or cols[4] or None
        course_raw = cols[5] or None
        enroll_date_raw = cols[6] or None
        payment_raw = cols[7] or None

    record = {
        "Student_ID": student_id,
        "First_Name": first,
        "Last_Name": last,
        "Age": clean_age(age_raw),
        "Gender": clean_gender(gender_raw),
        "Course": clean_course(course_raw),
        "Enrollment_Date": parse_date(enroll_date_raw),
        "Total_Payments": clean_currency(payment_raw),
    }
    # Drop rows that are completely empty in key fields
    if not any(
        record.get(k)
        for k in ["Student_ID", "First_Name", "Last_Name", "Course", "Total_Payments"]
    ):
        return None
    return record


def load_and_clean() -> tuple[pd.DataFrame, pd.DataFrame]:
    """
    Read the raw messy CSV and return:
    - df_raw: parsed records before any de-duplication / type casting
    - df_clean: cleaned version with standardized types and de-duplicated IDs
    """
    records: List[Dict] = []

    # Try multiple encodings to handle special characters
    encodings = ["utf-8", "latin-1", "cp1252", "iso-8859-1"]
    file_content = None
    
    for encoding in encodings:
        try:
            with RAW_PATH.open("r", encoding=encoding) as f:
                file_content = f.readlines()
            break
        except UnicodeDecodeError:
            continue
    
    if file_content is None:
        # Fallback: read with errors='ignore'
        with RAW_PATH.open("r", encoding="utf-8", errors="ignore") as f:
            file_content = f.readlines()
    
    for i, raw_line in enumerate(file_content):
        line = raw_line.strip()
        # Skip header
        if i == 0:
            continue
        if not line:
            continue

        if "|" in line:
            rec = parse_pipe_line(line)
        else:
            rec = parse_csv_line(line)

        if rec:
            records.append(rec)

    # df_raw represents the parsed dataset before de-duplication
    df_raw = pd.DataFrame.from_records(records)

    # Work on a copy for cleaning so raw stats stay accurate
    df = df_raw.copy()

    # Standardize gender and course again at DataFrame level
    df["Gender"] = df["Gender"].apply(lambda g: g.upper() if isinstance(g, str) else g)
    df["Course"] = df["Course"].apply(clean_course)

    # Ensure numeric and datetime types
    df["Age"] = pd.to_numeric(df["Age"], errors="coerce")
    df["Total_Payments"] = pd.to_numeric(df["Total_Payments"], errors="coerce")
    df["Enrollment_Date"] = pd.to_datetime(df["Enrollment_Date"], errors="coerce")

    # Remove duplicate exact rows
    df = df.drop_duplicates()

    # If Student_ID exists, prefer first occurrence per ID
    if "Student_ID" in df.columns:
        df = df.sort_values(by=["Student_ID", "Enrollment_Date"], na_position="last")
        df = df.drop_duplicates(subset=["Student_ID"], keep="first")

    # Reorder columns
    cols = [
        "Student_ID",
        "First_Name",
        "Last_Name",
        "Age",
        "Gender",
        "Course",
        "Enrollment_Date",
        "Total_Payments",
    ]
    df = df[[c for c in cols if c in df.columns]]

    return df_raw, df


def analyze_uncleaned_data(df: pd.DataFrame) -> Dict:
    """Analyze and return data cleaning statistics about the uncleaned data."""
    stats = {
        "total_rows": len(df),
        "total_columns": len(df.columns),
        "missing_values": {},
        "missing_percentage": {},
        "duplicate_rows": df.duplicated().sum(),
        "duplicate_student_ids": 0,
        "data_types": df.dtypes.to_dict(),
        "data_quality_score": 0.0,
    }
    
    # Missing values analysis
    missing_counts = df.isnull().sum()
    stats["missing_values"] = missing_counts.to_dict()
    stats["missing_percentage"] = (missing_counts / len(df) * 100).to_dict()
    
    # Duplicate Student IDs (based on Student_ID, if present)
    id_dupes = 0
    if "Student_ID" in df.columns:
        id_dupes = df["Student_ID"].duplicated().sum()
        stats["duplicate_student_ids"] = id_dupes

    # Calculate data quality score (0-100)
    # Based on: completeness and uniqueness (prefer ID-based uniqueness if available)
    completeness = (1 - missing_counts.sum() / (len(df) * len(df.columns))) * 100
    if len(df) > 0:
        if "Student_ID" in df.columns:
            uniqueness = (1 - id_dupes / len(df)) * 100
        else:
            uniqueness = (1 - stats["duplicate_rows"] / len(df)) * 100
    else:
        uniqueness = 0

    stats["data_quality_score"] = (completeness + uniqueness) / 2
    
    return stats


def print_uncleaned_statistics(stats: Dict) -> None:
    """Print data cleaning statistics about uncleaned data."""
    print("\n" + "="*80)
    print("UNCLEANED DATA CLEANING STATISTICS".center(80))
    print("="*80)
    
    print(f"\n[Dataset Overview]")
    print(f"   Total Rows: {stats['total_rows']}")
    print(f"   Total Columns: {stats['total_columns']}")
    print(f"   Data Quality Score: {stats['data_quality_score']:.2f}/100")
    
    print(f"\n[Missing Values Analysis]")
    if any(stats['missing_values'].values()):
        total_missing = sum(stats['missing_values'].values())
        print(f"   Total Missing Values: {total_missing}")
        for col, count in stats['missing_values'].items():
            if count > 0:
                pct = stats['missing_percentage'][col]
                print(f"   {col:25s}: {count:4d} missing ({pct:5.2f}%)")
    else:
        print("   [OK] No missing values found")
    
    print(f"\n[Duplicate Analysis]")
    print(f"   Duplicate Rows: {stats['duplicate_rows']}")
    if stats['duplicate_student_ids'] > 0:
        print(f"   Duplicate Student IDs: {stats['duplicate_student_ids']}")
    else:
        print("   [OK] No duplicate Student IDs")
    
    print(f"\n[Data Types]")
    for col, dtype in stats['data_types'].items():
        print(f"   {col:25s}: {str(dtype)}")


def remove_null_records(df: pd.DataFrame) -> tuple:
    """Remove records with any null/missing values."""
    # Count rows before removing nulls
    rows_before = len(df)
    
    # Count missing values per column before removal
    missing_before = df.isnull().sum().to_dict()
    
    # Remove rows with any null values
    df_cleaned = df.dropna()
    
    rows_after = len(df_cleaned)
    
    return df_cleaned, rows_before, rows_after, missing_before


def create_comprehensive_visualization(df_before: pd.DataFrame, df_after: pd.DataFrame, 
                                      stats_before: Dict, rows_before: int, rows_after: int) -> None:
    """Create visualizations showing data cleaning statistics."""
    fig = plt.figure(figsize=(14, 8))
    gs = fig.add_gridspec(2, 3, hspace=0.3, wspace=0.3)
    
    # 1. Before/After comparison bar chart
    ax1 = fig.add_subplot(gs[0, 0])
    categories = ['Before\n(With Nulls)', 'After\n(No Nulls)']
    counts = [rows_before, rows_after]
    colors = ['#ff6b6b', '#51cf66']
    bars = ax1.bar(categories, counts, color=colors, alpha=0.8, edgecolor='black', linewidth=1.5)
    ax1.set_ylabel('Number of Records', fontsize=11, fontweight='bold')
    ax1.set_title('Records: Before vs After Cleaning', fontsize=12, fontweight='bold')
    ax1.grid(axis='y', alpha=0.3, linestyle='--')
    for bar in bars:
        height = bar.get_height()
        ax1.text(bar.get_x() + bar.get_width()/2., height,
                f'{int(height)}', ha='center', va='bottom', fontsize=11, fontweight='bold')
    
    # 2. Missing values per column (before cleaning)
    ax2 = fig.add_subplot(gs[0, 1])
    missing_data = {k: v for k, v in stats_before['missing_values'].items() if v > 0}
    if missing_data:
        cols = list(missing_data.keys())
        counts = list(missing_data.values())
        bars = ax2.barh(cols, counts, color='#ff6b6b', alpha=0.7, edgecolor='black')
        ax2.set_xlabel('Missing Count', fontsize=11, fontweight='bold')
        ax2.set_title('Missing Values by Column (Before)', fontsize=12, fontweight='bold')
        ax2.grid(axis='x', alpha=0.3, linestyle='--')
        for i, (bar, count) in enumerate(zip(bars, counts)):
            ax2.text(count + 0.1, i, f'{count}', va='center', fontsize=10, fontweight='bold')
    else:
        ax2.text(0.5, 0.5, 'No Missing Values', ha='center', va='center', 
                transform=ax2.transAxes, fontsize=12, fontweight='bold')
        ax2.set_title('Missing Values by Column (Before)', fontsize=12, fontweight='bold')
    
    # 3. Data retention pie chart
    ax3 = fig.add_subplot(gs[0, 2])
    cleaned_pct = (rows_after / rows_before * 100) if rows_before > 0 else 0
    removed_pct = 100 - cleaned_pct
    sizes = [cleaned_pct, removed_pct]
    labels = [f'Retained\n{cleaned_pct:.1f}%', f'Removed\n{removed_pct:.1f}%']
    colors_pie = ['#51cf66', '#ff6b6b']
    ax3.pie(sizes, labels=labels, colors=colors_pie, autopct='%1.1f%%', 
           startangle=90, textprops={'fontsize': 11, 'fontweight': 'bold'},
           explode=(0.05, 0.1))
    ax3.set_title('Data Retention Rate', fontsize=12, fontweight='bold')
    
    # 4. Missing values percentage chart
    ax4 = fig.add_subplot(gs[1, 0])
    missing_pct_data = {k: v for k, v in stats_before['missing_percentage'].items() if v > 0}
    if missing_pct_data:
        cols = list(missing_pct_data.keys())
        percentages = list(missing_pct_data.values())
        bars = ax4.barh(cols, percentages, color='#ff8787', alpha=0.7, edgecolor='black')
        ax4.set_xlabel('Missing Percentage (%)', fontsize=11, fontweight='bold')
        ax4.set_title('Missing Values % by Column', fontsize=12, fontweight='bold')
        ax4.grid(axis='x', alpha=0.3, linestyle='--')
        for i, (bar, pct) in enumerate(zip(bars, percentages)):
            ax4.text(pct + 0.5, i, f'{pct:.1f}%', va='center', fontsize=10, fontweight='bold')
    else:
        ax4.text(0.5, 0.5, 'No Missing Values', ha='center', va='center', 
                transform=ax4.transAxes, fontsize=12, fontweight='bold')
        ax4.set_title('Missing Values % by Column', fontsize=12, fontweight='bold')
    
    # 5. Duplicate analysis
    ax5 = fig.add_subplot(gs[1, 1])
    duplicate_data = {
        'Duplicate Rows': stats_before['duplicate_rows'],
        'Duplicate IDs': stats_before.get('duplicate_student_ids', 0)
    }
    if any(duplicate_data.values()):
        labels = list(duplicate_data.keys())
        values = list(duplicate_data.values())
        bars = ax5.bar(labels, values, color='#ff6b6b', alpha=0.7, edgecolor='black')
        ax5.set_ylabel('Count', fontsize=11, fontweight='bold')
        ax5.set_title('Duplicate Records Analysis', fontsize=12, fontweight='bold')
        ax5.grid(axis='y', alpha=0.3, linestyle='--')
        for bar, val in zip(bars, values):
            if val > 0:
                ax5.text(bar.get_x() + bar.get_width()/2., val,
                        f'{int(val)}', ha='center', va='bottom', fontsize=11, fontweight='bold')
    else:
        ax5.text(0.5, 0.5, 'No Duplicates Found', ha='center', va='center', 
                transform=ax5.transAxes, fontsize=12, fontweight='bold', color='#51cf66')
        ax5.set_title('Duplicate Records Analysis', fontsize=12, fontweight='bold')
    
    # 6. Data quality metrics
    ax6 = fig.add_subplot(gs[1, 2])
    metrics = ['Completeness', 'Uniqueness', 'Overall Quality']

    # Recompute completeness / uniqueness in the same way as analyze_uncleaned_data
    total_missing = sum(stats_before['missing_values'].values())
    completeness = (1 - total_missing / (rows_before * len(df_before.columns))) * 100 if rows_before > 0 else 0

    if rows_before > 0:
        if "Student_ID" in df_before.columns:
            id_dupes = df_before["Student_ID"].duplicated().sum()
            uniqueness = (1 - id_dupes / rows_before) * 100
        else:
            uniqueness = (1 - stats_before['duplicate_rows'] / rows_before) * 100
    else:
        uniqueness = 0

    scores = [completeness, uniqueness, stats_before['data_quality_score']]
    bars = ax6.barh(metrics, scores, color=['#51cf66', '#4dabf7', '#ffd43b'], 
                   alpha=0.7, edgecolor='black')
    ax6.set_xlabel('Score (%)', fontsize=11, fontweight='bold')
    ax6.set_title('Data Quality Metrics (Before)', fontsize=12, fontweight='bold')
    ax6.set_xlim(0, 100)
    ax6.grid(axis='x', alpha=0.3, linestyle='--')
    for i, (bar, score) in enumerate(zip(bars, scores)):
        ax6.text(score + 2, i, f'{score:.1f}%', va='center', fontsize=11, fontweight='bold')
    
    plt.suptitle('Data Cleaning Statistics Dashboard', fontsize=16, fontweight='bold', y=0.995)
    plt.savefig(VISUALIZATION_PATH, dpi=300, bbox_inches='tight')
    print(f"Visualization saved to: {VISUALIZATION_PATH}")
    plt.close()


def generate_cleaning_report(df_before: pd.DataFrame, df_after: pd.DataFrame,
                             stats_before: Dict, rows_before: int, rows_after: int,
                             missing_before: Dict) -> None:
    """Generate a comprehensive text report of the cleaning process."""
    with open(REPORT_PATH, 'w', encoding='utf-8') as f:
        f.write("="*80 + "\n")
        f.write("DATA CLEANING REPORT".center(80) + "\n")
        f.write("="*80 + "\n\n")
        
        f.write("EXECUTIVE SUMMARY\n")
        f.write("-"*80 + "\n")
        f.write(f"Original Records: {rows_before}\n")
        f.write(f"Cleaned Records: {rows_after}\n")
        f.write(f"Records Removed: {rows_before - rows_after}\n")
        f.write(f"Retention Rate: {rows_after/rows_before*100:.2f}%\n")
        f.write(f"Data Quality Score (Before): {stats_before['data_quality_score']:.2f}/100\n\n")
        
        f.write("MISSING VALUES ANALYSIS (Before Cleaning)\n")
        f.write("-"*80 + "\n")
        total_missing = sum(missing_before.values())
        if total_missing > 0:
            for col, count in missing_before.items():
                if count > 0:
                    pct = (count / rows_before) * 100
                    f.write(f"{col:25s}: {count:4d} missing ({pct:5.2f}%)\n")
        else:
            f.write("No missing values found.\n")
        f.write("\n")
        
        f.write("DUPLICATE ANALYSIS\n")
        f.write("-"*80 + "\n")
        f.write(f"Duplicate Rows: {stats_before['duplicate_rows']}\n")
        if stats_before['duplicate_student_ids'] > 0:
            f.write(f"Duplicate Student IDs: {stats_before['duplicate_student_ids']}\n")
        f.write("\n")
        
        f.write("DATA TYPES\n")
        f.write("-"*80 + "\n")
        for col, dtype in stats_before['data_types'].items():
            f.write(f"{col:25s}: {str(dtype)}\n")
        f.write("\n")
        
        f.write("CLEANING ACTIONS PERFORMED\n")
        f.write("-"*80 + "\n")
        f.write("1. Parsed messy data formats (pipe-delimited and comma-delimited)\n")
        f.write("2. Cleaned currency values (removed symbols, commas, spaces)\n")
        f.write("3. Extracted and validated ages\n")
        f.write("4. Standardized gender values (M/F)\n")
        f.write("5. Normalized course names\n")
        f.write("6. Parsed dates from multiple formats\n")
        f.write("7. Removed duplicate rows\n")
        f.write("8. Removed duplicate Student IDs (kept first occurrence)\n")
        f.write("9. Removed all records with missing/null values\n")
        f.write("\n")
        
        f.write("FINAL DATASET STATUS\n")
        f.write("-"*80 + "\n")
        f.write(f"Total Records: {len(df_after)}\n")
        f.write(f"Total Columns: {len(df_after.columns)}\n")
        f.write(f"Missing Values: {df_after.isnull().sum().sum()}\n")
        f.write(f"Duplicate Rows: {df_after.duplicated().sum()}\n")
        f.write("\n")
        
        f.write("="*80 + "\n")
        f.write("Report generated successfully.\n")
    
    print(f"Cleaning report saved to: {REPORT_PATH}")


def main() -> None:
    if not RAW_PATH.exists():
        raise FileNotFoundError(f"Raw dataset not found at {RAW_PATH}")

    print("\n" + "="*80)
    print("DATA CLEANING PROCESS STARTED".center(80))
    print("="*80)
    
    # Load and clean the data
    print("\n[Loading and parsing data...]")
    df_raw, df = load_and_clean()
    print(f"[OK] Loaded {len(df_raw)} records (before cleaning)")
    
    # Analyze uncleaned data (before any de-duplication / null removal)
    print("\n[Analyzing uncleaned data...]")
    stats_before = analyze_uncleaned_data(df_raw)
    print_uncleaned_statistics(stats_before)
    
    # Remove records with null values from the cleaned DataFrame
    print("\n[Removing records with missing values...]")
    df_cleaned, rows_before, rows_after, missing_before = remove_null_records(df)
    print(f"[OK] Removed {rows_before - rows_after} records with missing values")
    
    # Create comprehensive visualization
    print("\n[Creating visualizations...]")
    create_comprehensive_visualization(df, df_cleaned, stats_before, rows_before, rows_after)
    
    # Generate cleaning report
    print("\n[Generating cleaning report...]")
    generate_cleaning_report(df, df_cleaned, stats_before, rows_before, rows_after, missing_before)

    # Write cleaned dataset (without nulls)
    OUTPUT_PATH.parent.mkdir(parents=True, exist_ok=True)
    df_cleaned.to_csv(OUTPUT_PATH, index=False)
    
    print("\n" + "="*80)
    print("CLEANING SUMMARY".center(80))
    print("="*80)
    print(f"\n[OK] Cleaned dataset written to: {OUTPUT_PATH}")
    print(f"[OK] Visualization saved to: {VISUALIZATION_PATH}")
    print(f"[OK] Report saved to: {REPORT_PATH}")
    print(f"\n[Final Statistics]")
    print(f"   Rows before removing nulls: {rows_before}")
    print(f"   Rows after removing nulls: {rows_after}")
    print(f"   Records removed: {rows_before - rows_after}")
    print(f"   Retention rate: {rows_after/rows_before*100:.1f}%")
    print(f"   Data quality improvement: {stats_before['data_quality_score']:.2f} -> 100.00")
    print("\n" + "="*80)


if __name__ == "__main__":
    main()

