import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson70 = Lesson(
  language: 'Python',
  title: 'CSV & Excel with Python',
  content: '''
🎯 METAPHOR:
CSV files are like plain-text spreadsheets.
No formatting, no formulas, just data rows separated
by commas (or any delimiter). They're the lingua franca
of data exchange — every tool can read and write them.
Excel files (.xlsx) are the formatted, formula-rich
cousins — great for human consumption but harder to
process programmatically. Python handles both: csv module
for the simple text format, openpyxl/pandas for Excel.

📖 EXPLANATION:
Python's built-in csv module handles CSV files.
For Excel: openpyxl (read/write .xlsx), xlrd (read .xls),
xlwt (write .xls). pandas handles both formats and is
the best tool for data analysis.

─────────────────────────────────────
📦 CSV MODULE
─────────────────────────────────────
import csv

Reading:
  csv.reader(file)          → rows as lists
  csv.DictReader(file)      → rows as dicts (uses header row)

Writing:
  csv.writer(file)          → write rows as lists
  csv.DictWriter(file, fieldnames) → write rows as dicts

Options:
  delimiter=","             → field separator (default: comma)
  quotechar='"'             → quote character
  quoting=csv.QUOTE_MINIMAL → when to quote
  newline=""                → critical on Windows!

─────────────────────────────────────
📊 PANDAS FOR EXCEL & CSV
─────────────────────────────────────
pip install pandas openpyxl

pd.read_csv("file.csv")     → DataFrame
pd.read_excel("file.xlsx")  → DataFrame
df.to_csv("out.csv")        → write CSV
df.to_excel("out.xlsx")     → write Excel

─────────────────────────────────────
📝 OPENPYXL FOR EXCEL CONTROL
─────────────────────────────────────
pip install openpyxl

Full control over:
  Formatting (fonts, colors, borders)
  Multiple sheets
  Charts
  Formulas
  Images

─────────────────────────────────────
⚠️  WINDOWS CSV GOTCHA
─────────────────────────────────────
Always open CSV files with newline="" on Windows
to prevent double newlines in output:

with open("file.csv", "w", newline="") as f:
    writer = csv.writer(f)

💻 CODE:
import csv
import io
from pathlib import Path
from datetime import date, datetime

# ── CSV READING ────────────────────

# Create a sample CSV for demo
sample_csv = """Name,Age,Department,Salary,Start Date
Alice,30,Engineering,95000,2020-03-15
Bob,25,Marketing,72000,2021-06-01
Carol,35,Engineering,98000,2019-01-10
Dave,28,HR,65000,2022-09-20
Eve,32,Marketing,78000,2020-11-05
"""

# Reader — rows as lists
print("=== csv.reader ===")
reader = csv.reader(io.StringIO(sample_csv))
header = next(reader)   # skip/read header
print(f"Columns: {header}")
for row in reader:
    print(row)

# DictReader — rows as dicts (keys from header)
print("\\n=== csv.DictReader ===")
reader = csv.DictReader(io.StringIO(sample_csv))
for row in reader:
    print(f"  {row['Name']:8s} | {row['Department']:12s} | \${int(row['Salary']):,}")

# With type conversion
employees = []
reader = csv.DictReader(io.StringIO(sample_csv))
for row in reader:
    employees.append({
        "name": row["Name"],
        "age": int(row["Age"]),
        "dept": row["Department"],
        "salary": float(row["Salary"]),
        "start": date.fromisoformat(row["Start Date"]),
    })

# Sort by salary
for e in sorted(employees, key=lambda x: x["salary"], reverse=True):
    print(f"  {e['name']:8s}: \${e['salary']:,.0f} ({e['dept']})")

# ── CSV WRITING ────────────────────

# Write with csv.writer
with open("output.csv", "w", newline="", encoding="utf-8") as f:
    writer = csv.writer(f)
    writer.writerow(["Name", "Score", "Grade"])  # header
    writer.writerows([
        ["Alice", 92, "A"],
        ["Bob",   78, "C"],
        ["Carol", 95, "A"],
    ])

# DictWriter
fieldnames = ["name", "dept", "salary"]
with open("employees.csv", "w", newline="", encoding="utf-8") as f:
    writer = csv.DictWriter(f, fieldnames=fieldnames)
    writer.writeheader()
    for emp in employees:
        writer.writerow({
            "name": emp["name"],
            "dept": emp["dept"],
            "salary": emp["salary"],
        })

print("Written employees.csv")

# ── CUSTOM DELIMITER ──────────────

# Tab-separated (TSV)
tsv_data = "Name\\tAge\\tCity\\nAlice\\t30\\tNYC\\nBob\\t25\\tLA\\n"
reader = csv.reader(io.StringIO(tsv_data), delimiter="\\t")
for row in reader:
    print(row)

# Pipe-separated
pipe_data = "Alice|30|NYC\\nBob|25|LA\\n"
reader = csv.reader(io.StringIO(pipe_data), delimiter="|")
for row in reader:
    print(row)

# ── HANDLING EDGE CASES ────────────

tricky_csv = '''Name,Description,Price
"Apple, Red",A fresh apple,$1.99
"Banana Bread","Bread with banana, walnuts","$4.50"
Widget,"Contains ""quotes""",9.99
'''

reader = csv.reader(io.StringIO(tricky_csv))
for row in reader:
    print(row)
# csv handles commas in quoted fields and escaped quotes

# ── PANDAS CSV ────────────────────

# (shown as strings since pandas may not be installed)
PANDAS_CSV_EXAMPLE = """
import pandas as pd

# Read CSV
df = pd.read_csv("employees.csv")
print(df.head())
print(df.dtypes)

# Read with type specs
df = pd.read_csv("employees.csv",
    dtype={"salary": float, "age": int},
    parse_dates=["start_date"],
    index_col="id"
)

# Filter
eng = df[df["dept"] == "Engineering"]

# Stats
print(df.groupby("dept")["salary"].agg(["mean", "min", "max"]))

# Export
df.to_csv("output.csv", index=False)
df.to_csv("output.csv", sep="\\t", encoding="utf-8")
"""

# ── OPENPYXL EXCEL ─────────────────

OPENPYXL_EXAMPLE = """
import openpyxl
from openpyxl.styles import Font, PatternFill, Alignment, numbers
from openpyxl.utils import get_column_letter
from openpyxl.chart import BarChart, Reference

# Create new workbook
wb = openpyxl.Workbook()
ws = wb.active
ws.title = "Sales Report"

# Style header row
header_font = Font(bold=True, color="FFFFFF", size=12)
header_fill = PatternFill("solid", fgColor="366092")

headers = ["Name", "Q1", "Q2", "Q3", "Q4", "Total"]
for col, header in enumerate(headers, 1):
    cell = ws.cell(row=1, column=col, value=header)
    cell.font = header_font
    cell.fill = header_fill
    cell.alignment = Alignment(horizontal="center")

# Add data
data = [
    ("Alice",  45000, 52000, 48000, 61000),
    ("Bob",    38000, 41000, 44000, 49000),
    ("Carol",  52000, 55000, 58000, 72000),
]

for row_idx, (name, *quarters) in enumerate(data, 2):
    ws.cell(row=row_idx, column=1, value=name)
    for col_idx, val in enumerate(quarters, 2):
        ws.cell(row=row_idx, column=col_idx, value=val)
    # Total formula
    total_cell = ws.cell(row=row_idx, column=6)
    total_cell.value = f"=SUM(B{row_idx}:E{row_idx})"

# Format currency columns
for row in ws.iter_rows(min_row=2, min_col=2, max_col=6):
    for cell in row:
        cell.number_format = '"$"#,##0'

# Set column widths
for col in range(1, 7):
    ws.column_dimensions[get_column_letter(col)].width = 12

# Add a chart
chart = BarChart()
chart.title = "Quarterly Sales"
chart.y_axis.title = "Revenue"
data_ref = Reference(ws, min_col=2, max_col=5, min_row=1, max_row=4)
cats_ref = Reference(ws, min_col=1, min_row=2, max_row=4)
chart.add_data(data_ref, titles_from_data=True)
chart.set_categories(cats_ref)
ws.add_chart(chart, "A8")

# Save
wb.save("sales_report.xlsx")
print("Excel file created!")

# Read existing Excel
wb2 = openpyxl.load_workbook("sales_report.xlsx")
ws2 = wb2.active
for row in ws2.iter_rows(min_row=2, values_only=True):
    name, q1, q2, q3, q4, total = row
    if name:
        print(f"{name}: Total = {total}")
"""

# ── PANDAS EXCEL ──────────────────

PANDAS_EXCEL_EXAMPLE = """
import pandas as pd

# Read Excel
df = pd.read_excel("sales_report.xlsx", sheet_name="Sales Report")

# Write Excel with multiple sheets
with pd.ExcelWriter("multi_sheet.xlsx", engine="openpyxl") as writer:
    df_eng.to_excel(writer, sheet_name="Engineering", index=False)
    df_mkt.to_excel(writer, sheet_name="Marketing", index=False)
    df_all.to_excel(writer, sheet_name="All Staff", index=False)

# Read multiple sheets
sheets = pd.read_excel("multi_sheet.xlsx", sheet_name=None)  # all sheets
for name, df in sheets.items():
    print(f"{name}: {len(df)} rows")
"""

print("CSV & Excel examples ready!")
print("Libraries: csv (built-in), openpyxl, pandas")

📝 KEY POINTS:
✅ Always use newline="" when opening CSV files for writing on Windows
✅ DictReader is usually better — row["Name"] is clearer than row[0]
✅ csv handles quoted fields with commas automatically
✅ pandas is best for data analysis — read_csv/read_excel then transform
✅ openpyxl gives full control over Excel formatting, charts, formulas
✅ Use encoding="utf-8" for international characters in CSV
✅ DictWriter.writeheader() writes the column names row
❌ Forgetting newline="" on Windows creates empty rows between data rows
❌ Don't manually parse CSV with str.split(",") — quoted commas will break it
❌ xlrd 2.0+ dropped .xlsx support — use openpyxl for modern Excel files
''',
  quiz: [
    Quiz(question: 'Why must you open CSV files with newline="" on Windows when writing?', options: [
      QuizOption(text: 'It makes the file smaller', correct: false),
      QuizOption(text: 'Without it, the csv module adds extra blank lines between rows on Windows', correct: true),
      QuizOption(text: 'It enables Unicode support', correct: false),
      QuizOption(text: 'It is required for DictWriter to work', correct: false),
    ]),
    Quiz(question: 'What is the advantage of csv.DictReader over csv.reader?', options: [
      QuizOption(text: 'DictReader is faster for large files', correct: false),
      QuizOption(text: 'DictReader gives each row as a dict with column names as keys — more readable', correct: true),
      QuizOption(text: 'DictReader handles custom delimiters automatically', correct: false),
      QuizOption(text: 'DictReader automatically converts data types', correct: false),
    ]),
    Quiz(question: 'What library provides full control over Excel formatting including charts and formulas?', options: [
      QuizOption(text: 'csv', correct: false),
      QuizOption(text: 'openpyxl', correct: true),
      QuizOption(text: 'xlrd', correct: false),
      QuizOption(text: 'json', correct: false),
    ]),
  ],
);
