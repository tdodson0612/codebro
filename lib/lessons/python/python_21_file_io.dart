import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson21 = Lesson(
  language: 'Python',
  title: 'File I/O',
  content: '''
🎯 METAPHOR:
Working with files is like renting a library book.
You go to the library (open the file), check the book out
(get a file handle), read or write in your notepad
(process the content), then MUST return the book
(close the file). The "with" statement is like a
responsible library auto-return system — it guarantees
the book goes back even if you got distracted, even if
you tripped on the way out (exception). Never leave a
library book unreturned.

📖 EXPLANATION:
Python can read, write, and append to files using the
built-in open() function. The "with" statement ensures
files are always properly closed.

─────────────────────────────────────
📂 OPEN() MODES
─────────────────────────────────────
Mode  Meaning
─────────────────────────────────────
'r'   Read (default). Error if not found.
'w'   Write. Creates new or OVERWRITES existing!
'a'   Append. Creates new or adds to end.
'x'   Exclusive create. Error if already exists.
'r+'  Read and write. File must exist.
'w+'  Read and write. Overwrites!
'a+'  Read and append.

Add 'b' for binary mode: 'rb', 'wb', 'ab'
  'rb'  → read binary (images, PDFs, etc.)
  'wb'  → write binary

─────────────────────────────────────
📖 READING METHODS
─────────────────────────────────────
f.read()          → entire file as one string
f.read(n)         → next n characters
f.readline()      → next line (including \\n)
f.readlines()     → list of all lines
for line in f:    → iterate line by line (most memory-efficient)

─────────────────────────────────────
✏️  WRITING METHODS
─────────────────────────────────────
f.write(string)   → write string (no auto newline!)
f.writelines(seq) → write each item in sequence
f.flush()         → flush buffer to disk immediately

─────────────────────────────────────
📍 FILE POSITION
─────────────────────────────────────
f.tell()          → current byte position
f.seek(pos)       → move to byte position
f.seek(0)         → go to beginning
f.seek(0, 2)      → go to end

─────────────────────────────────────
🗂️  WORKING WITH PATHS
─────────────────────────────────────
Use pathlib.Path — modern, cross-platform:
from pathlib import Path
p = Path("data/file.txt")
p.read_text()          → file contents as string
p.write_text("hello")  → write string to file
p.exists()             → True/False
p.mkdir(parents=True)  → create directory tree
p.glob("*.txt")        → find matching files
p.unlink()             → delete file

─────────────────────────────────────
📊 CSV FILES
─────────────────────────────────────
import csv
csv.reader  → read CSV rows as lists
csv.writer  → write CSV rows from lists
csv.DictReader  → read rows as dicts
csv.DictWriter  → write rows from dicts

─────────────────────────────────────
🗄️  JSON FILES
─────────────────────────────────────
import json
json.dump(obj, file)   → write object to JSON file
json.load(file)        → read JSON file to object

💻 CODE:
# Writing a file
with open("example.txt", "w") as f:
    f.write("Hello, World!\\n")
    f.write("Second line\\n")
    f.writelines(["Third\\n", "Fourth\\n", "Fifth\\n"])
# File is automatically closed after the with block!

# Reading entire file
with open("example.txt", "r") as f:
    content = f.read()
    print(content)

# Reading line by line (memory efficient for large files)
with open("example.txt", "r") as f:
    for line in f:
        print(line.strip())   # .strip() removes the \\n

# Reading all lines into a list
with open("example.txt", "r") as f:
    lines = f.readlines()
print(f"{len(lines)} lines")

# Appending to a file
with open("example.txt", "a") as f:
    f.write("Sixth line\\n")

# Reading and writing (r+ mode)
with open("example.txt", "r+") as f:
    content = f.read()
    f.seek(0)           # go back to start
    f.write(content.upper())  # overwrite with uppercase

# Binary mode — reading an image
with open("image.png", "rb") as f:
    header = f.read(8)   # read first 8 bytes
    print(header.hex())  # show as hex

# Pathlib — modern file handling
from pathlib import Path

# Write and read with pathlib (very clean!)
p = Path("data.txt")
p.write_text("Hello from pathlib!\\nSecond line\\n")
content = p.read_text()
print(content)

# Bytes
p_bin = Path("data.bin")
p_bin.write_bytes(b"\\x00\\x01\\x02\\x03")
data = p_bin.read_bytes()

# File/directory operations
data_dir = Path("mydata")
data_dir.mkdir(exist_ok=True)   # create, no error if exists
nested = data_dir / "subdir" / "file.txt"
nested.parent.mkdir(parents=True, exist_ok=True)
nested.write_text("nested file")

# List all .txt files
for txt in Path(".").glob("*.txt"):
    print(txt.name, txt.stat().st_size, "bytes")

# Rename and delete
# p.rename("new_name.txt")
# p.unlink()    # delete file
# data_dir.rmdir()  # delete EMPTY directory

# CSV reading and writing
import csv

# Write CSV
employees = [
    ["Name", "Department", "Salary"],
    ["Alice", "Engineering", 95000],
    ["Bob", "Marketing", 72000],
    ["Carol", "Engineering", 98000],
]
with open("employees.csv", "w", newline="") as f:
    writer = csv.writer(f)
    writer.writerows(employees)

# Read CSV
with open("employees.csv", "r") as f:
    reader = csv.reader(f)
    for row in reader:
        print(row)

# DictReader — rows as dicts
with open("employees.csv", "r") as f:
    reader = csv.DictReader(f)
    for row in reader:
        print(f"{row['Name']}: \${int(row['Salary']):,}")

# DictWriter
fieldnames = ["Name", "Department", "Salary"]
with open("output.csv", "w", newline="") as f:
    writer = csv.DictWriter(f, fieldnames=fieldnames)
    writer.writeheader()
    writer.writerow({"Name": "Dave", "Department": "HR", "Salary": 68000})

# JSON files
import json

config = {
    "debug": True,
    "database": {"host": "localhost", "port": 5432},
    "allowed_hosts": ["localhost", "127.0.0.1"]
}

# Write JSON
with open("config.json", "w") as f:
    json.dump(config, f, indent=2)

# Read JSON
with open("config.json", "r") as f:
    loaded = json.load(f)
print(loaded["database"]["host"])

# Error handling for files
def read_config(path):
    try:
        with open(path) as f:
            return json.load(f)
    except FileNotFoundError:
        print(f"Config not found: {path}, using defaults")
        return {}
    except json.JSONDecodeError as e:
        print(f"Invalid JSON: {e}")
        return {}

# Temporary files
import tempfile
with tempfile.NamedTemporaryFile(mode='w', suffix='.txt', delete=False) as tmp:
    tmp.write("temporary data")
    print(f"Temp file: {tmp.name}")

# StringIO — file-like object in memory
from io import StringIO
buffer = StringIO()
buffer.write("Hello\\nWorld\\n")
buffer.seek(0)
for line in buffer:
    print(line.strip())

📝 KEY POINTS:
✅ Always use "with open(...) as f:" — guarantees file closure
✅ Default mode is 'r' (read) and text mode
✅ 'w' OVERWRITES — use 'a' to append, 'x' to create-only
✅ Iterate file object directly for memory-efficient line reading
✅ pathlib.Path is the modern, cross-platform way to handle paths
✅ Use newline="" when writing CSV on Windows to avoid extra blank lines
❌ Never open a file without "with" unless you carefully call f.close()
❌ 'w' mode destroys existing content — double-check before writing
❌ Large file: never f.read() everything into memory — iterate lines
''',
  quiz: [
    Quiz(question: 'What does opening a file in "w" mode do if the file already exists?', options: [
      QuizOption(text: 'Raises a FileExistsError', correct: false),
      QuizOption(text: 'Appends to the existing content', correct: false),
      QuizOption(text: 'Overwrites (truncates) the existing file completely', correct: true),
      QuizOption(text: 'Opens it read-only for safety', correct: false),
    ]),
    Quiz(question: 'Why should you use "with open(file) as f:" instead of f = open(file)?', options: [
      QuizOption(text: 'with is faster for large files', correct: false),
      QuizOption(text: 'The with statement guarantees the file is closed even if an exception occurs', correct: true),
      QuizOption(text: 'with provides more read/write methods', correct: false),
      QuizOption(text: 'open() alone does not actually open the file', correct: false),
    ]),
    Quiz(question: 'Which method reads a file most memory-efficiently?', options: [
      QuizOption(text: 'f.read() — reads the whole file at once', correct: false),
      QuizOption(text: 'f.readlines() — stores all lines in a list', correct: false),
      QuizOption(text: 'for line in f: — iterates one line at a time', correct: true),
      QuizOption(text: 'f.readline() in a while loop', correct: false),
    ]),
  ],
);
