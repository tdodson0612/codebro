import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson73 = Lesson(
  language: 'Python',
  title: 'pathlib Deep Dive',
  content: """
🎯 METAPHOR:
pathlib.Path is like a GPS navigator for your file system.
The old way (os.path) was like using string directions:
"go to /users, turn at /alice, continue to /documents".
pathlib.Path gives you an intelligent object that knows
where it is: p.parent, p.name, p.suffix, p.exists().
You navigate with /: Path("/home") / "alice" / "docs".
The path object IS the navigator, not just the address.

📖 EXPLANATION:
pathlib (Python 3.4+) provides an object-oriented interface
for filesystem paths. It replaces os.path and os functions
with a cleaner, chainable API that works cross-platform.

─────────────────────────────────────
📐 CORE OPERATIONS
─────────────────────────────────────
Path("dir") / "file.txt"  → join paths with /
p.parent          → parent directory
p.name            → filename with extension
p.stem            → filename without extension
p.suffix          → extension: ".txt"
p.suffixes        → all extensions: [".tar", ".gz"]
p.parts           → tuple of path components
p.exists()        → True/False
p.is_file()       → True if file
p.is_dir()        → True if directory
p.stat()          → file metadata
p.resolve()       → absolute path, resolves symlinks

─────────────────────────────────────
📖 READING / WRITING
─────────────────────────────────────
p.read_text(encoding="utf-8")  → str
p.write_text(text)             → bytes written
p.read_bytes()                 → bytes
p.write_bytes(data)            → bytes written
p.open("r") as f:              → file object

─────────────────────────────────────
📁 DIRECTORY OPERATIONS
─────────────────────────────────────
p.mkdir(parents=True, exist_ok=True)
p.iterdir()        → all direct children
p.glob("*.py")     → match pattern (non-recursive)
p.rglob("*.py")    → match pattern (recursive!)
p.unlink()         → delete file
p.rmdir()          → delete empty directory
shutil.rmtree(p)   → delete directory with contents

─────────────────────────────────────
🏭 FACTORY METHODS
─────────────────────────────────────
Path.cwd()         → current working directory
Path.home()        → user's home directory
Path(__file__)     → path to current script

💻 CODE:
from pathlib import Path
import shutil
import os
from datetime import datetime

# ── CREATING PATHS ────────────────

# Different ways to create paths
p1 = Path("/home/alice/documents/report.pdf")
p2 = Path("relative/path/file.txt")
p3 = Path.home() / "Documents" / "project"
p4 = Path.cwd() / "output"
p5 = Path(__file__).parent   # directory of current script

print(f"Home: {Path.home()}")
print(f"CWD:  {Path.cwd()}")

# Join with / operator
base = Path("/var/log")
app_log = base / "myapp" / "app.log"
print(app_log)   # /var/log/myapp/app.log

# ── PATH PROPERTIES ───────────────

p = Path("/home/alice/docs/report.final.pdf")
print(f"Full path:   {p}")
print(f"Parent:      {p.parent}")       # /home/alice/docs
print(f"Grandparent: {p.parent.parent}") # /home/alice
print(f"Name:        {p.name}")         # report.final.pdf
print(f"Stem:        {p.stem}")         # report.final
print(f"Suffix:      {p.suffix}")       # .pdf
print(f"Suffixes:    {p.suffixes}")     # ['.final', '.pdf']
print(f"Parts:       {p.parts}")        # ('/', 'home', 'alice', 'docs', 'report.final.pdf')

# String operations on paths
print(f"Name upper:  {p.name.upper()}")
print(f"Is absolute: {p.is_absolute()}")

# Change parts
new_path = p.with_name("summary.txt")      # change filename
new_stem = p.with_stem("report_v2")        # change stem (Py 3.9+)
new_ext  = p.with_suffix(".docx")          # change extension
print(new_path)   # /home/alice/docs/summary.txt
print(new_stem)   # /home/alice/docs/report_v2.pdf
print(new_ext)    # /home/alice/docs/report.final.docx

# ── FILE OPERATIONS ───────────────

# Create directory structure
work_dir = Path("/tmp/pathlib_demo")
(work_dir / "input").mkdir(parents=True, exist_ok=True)
(work_dir / "output" / "reports").mkdir(parents=True, exist_ok=True)

# Write files
(work_dir / "input" / "data.txt").write_text("line 1\\nline 2\\nline 3\\n")
(work_dir / "input" / "config.json").write_text('{"debug": true}')
(work_dir / "input" / "image.png").write_bytes(b"\\x89PNG\\r\\n\\x1a\\n")

# Read files
text_file = work_dir / "input" / "data.txt"
content = text_file.read_text()
print(f"Content:\\n{content}")

lines = text_file.read_text().splitlines()
print(f"Lines: {lines}")

# File with context manager
with (work_dir / "input" / "data.txt").open("r") as f:
    for line in f:
        print(f"  {line.rstrip()}")

# ── CHECKING FILE PROPERTIES ──────

p = work_dir / "input" / "data.txt"
print(f"Exists:   {p.exists()}")
print(f"Is file:  {p.is_file()}")
print(f"Is dir:   {p.is_dir()}")
print(f"Is symlink: {p.is_symlink()}")

stat = p.stat()
print(f"Size:     {stat.st_size} bytes")
print(f"Modified: {datetime.fromtimestamp(stat.st_mtime)}")
print(f"Created:  {datetime.fromtimestamp(stat.st_ctime)}")
print(f"Mode:     {oct(stat.st_mode)}")

# File size human-readable
def human_size(bytes: int) -> str:
    for unit in ["B", "KB", "MB", "GB", "TB"]:
        if bytes < 1024:
            return f"{bytes:.1f} {unit}"
        bytes /= 1024
    return f"{bytes:.1f} PB"

print(human_size(stat.st_size))

# ── DIRECTORY LISTING ─────────────

# All direct children
print("\\nDirect contents of input/:")
for item in sorted((work_dir / "input").iterdir()):
    size = item.stat().st_size if item.is_file() else "-"
    print(f"  {'D' if item.is_dir() else 'F'} {item.name:20s} {size}")

# Glob — pattern matching
py_files = list(Path(".").glob("*.py"))
print(f"\\n.py files in CWD: {len(py_files)}")

# All Python files recursively
all_py = list(Path(".").rglob("*.py"))
print(f"All .py files (recursive): {len(all_py)}")

# Multiple patterns with glob
for pattern in ["*.txt", "*.json"]:
    matches = list((work_dir / "input").glob(pattern))
    print(f"  {pattern}: {[f.name for f in matches]}")

# ── FILE MANIPULATION ─────────────

# Copy
src = work_dir / "input" / "data.txt"
dst = work_dir / "output" / "data_copy.txt"
shutil.copy2(src, dst)     # copy2 preserves metadata

# Move/rename
src2 = work_dir / "output" / "data_copy.txt"
dst2 = work_dir / "output" / "data_backup.txt"
src2.rename(dst2)

# Resolve symlinks and relative paths
abs_path = Path("../../etc/passwd").resolve()
print(f"Resolved: {abs_path}")

# Make path relative to another
p1 = Path("/home/alice/docs/report.pdf")
p2 = Path("/home/alice")
print(p1.relative_to(p2))   # docs/report.pdf

# ── WALKING A DIRECTORY TREE ───────

def print_tree(directory: Path, prefix: str = "", max_depth: int = 3, depth: int = 0):
    if depth > max_depth:
        return
    print(f"{prefix}{directory.name}/")
    prefix += "  "
    try:
        for item in sorted(directory.iterdir()):
            if item.is_dir():
                print_tree(item, prefix, max_depth, depth + 1)
            else:
                size = human_size(item.stat().st_size)
                print(f"{prefix}{item.name} ({size})")
    except PermissionError:
        print(f"{prefix}[Permission Denied]")

print_tree(work_dir, max_depth=2)

# ── PRACTICAL SCRIPTS ─────────────

def find_large_files(directory: Path, min_mb: float = 10) -> list:
    '''Find files larger than min_mb.'''
    min_bytes = min_mb * 1024 * 1024
    large = []
    for f in directory.rglob("*"):
        if f.is_file() and f.stat().st_size >= min_bytes:
            large.append((f, f.stat().st_size))
    return sorted(large, key=lambda x: x[1], reverse=True)

def cleanup_old_files(directory: Path, days_old: int = 30):
    '''Delete files older than days_old days.'''
    import time
    cutoff = time.time() - (days_old * 86400)
    deleted = 0
    for f in directory.rglob("*"):
        if f.is_file() and f.stat().st_mtime < cutoff:
            f.unlink()
            deleted += 1
    print(f"Deleted {deleted} files older than {days_old} days")

# Cleanup demo directory
shutil.rmtree(work_dir, ignore_errors=True)
print("\\nDemo directory cleaned up")

📝 KEY POINTS:
✅ Use / operator to join paths: Path("/home") / "user" / "file.txt"
✅ p.parent, p.name, p.stem, p.suffix give you path components cleanly
✅ p.read_text() / p.write_text() for quick file I/O without open()
✅ p.glob("*.py") for non-recursive; p.rglob("*.py") for recursive
✅ p.mkdir(parents=True, exist_ok=True) creates the full directory tree
✅ p.with_suffix(".txt"), p.with_name("new.txt") — create modified paths
✅ Always use shutil for copy/move/delete of directories — not os.remove
❌ Don't use os.path.join() — use Path("/dir") / "file" instead
❌ p.rmdir() only deletes empty directories — use shutil.rmtree() for trees
❌ Forgetting exist_ok=True in mkdir raises FileExistsError if dir already exists
""",
  quiz: [
    Quiz(question: 'How do you create the path /home/alice/data/report.csv with pathlib?', options: [
      QuizOption(text: 'Path("/home/alice/data/report.csv")', correct: true),
      QuizOption(text: 'Path.join("/home", "alice", "data", "report.csv")', correct: false),
      QuizOption(text: 'Path.home() + "/data/report.csv"', correct: false),
      QuizOption(text: 'Path("/home/alice") + "data/report.csv"', correct: false),
    ]),
    Quiz(question: 'What does p.rglob("*.py") do?', options: [
      QuizOption(text: 'Finds .py files only in the current directory', correct: false),
      QuizOption(text: 'Recursively finds all .py files in all subdirectories', correct: true),
      QuizOption(text: 'Generates random Python filenames', correct: false),
      QuizOption(text: 'Runs all .py files in the directory', correct: false),
    ]),
    Quiz(question: 'What does p.with_suffix(".json") do?', options: [
      QuizOption(text: 'Converts the file content to JSON format', correct: false),
      QuizOption(text: 'Returns a new path with the file extension changed to .json', correct: true),
      QuizOption(text: 'Adds .json to the end of the filename', correct: false),
      QuizOption(text: 'Renames the file on disk', correct: false),
    ]),
  ],
);
