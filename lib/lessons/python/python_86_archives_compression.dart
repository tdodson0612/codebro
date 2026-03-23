import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson86 = Lesson(
  language: 'Python',
  title: 'Archives, Compression & File Formats',
  content: '''
🎯 METAPHOR:
Archives are like moving boxes for your file system.
Instead of moving each file separately (expensive, slow),
you pack everything into labeled boxes (zip/tar), shrink
the boxes with a vacuum sealer (compression: gzip, bz2, lzma),
and ship one package. On arrival you unpack. Python's
zipfile and tarfile modules are your packing service —
they handle the box format; the compression algorithms
handle the shrinking. The pathlib integration makes it
feel like manipulating a live directory.

📖 EXPLANATION:
Python's standard library handles ZIP, TAR (+ gzip/bz2/xz),
gzip, bz2, lzma, and zlib. No external libraries needed
for the most common archive operations.

─────────────────────────────────────
📦 FORMAT GUIDE
─────────────────────────────────────
.zip         → most compatible, random access
.tar         → Unix tradition, no compression by default
.tar.gz/.tgz → tar + gzip (most common on Linux)
.tar.bz2     → tar + bzip2 (better compression, slower)
.tar.xz      → tar + lzma (best compression)
.gz          → gzip compressed single file
.bz2         → bzip2 compressed single file

─────────────────────────────────────
🔑 ZIPFILE MODULE
─────────────────────────────────────
import zipfile

zipfile.ZipFile(path, "r")  → read
zipfile.ZipFile(path, "w")  → write (overwrite)
zipfile.ZipFile(path, "a")  → append

zf.namelist()              → list of files in archive
zf.extractall(path)        → extract all to path
zf.extract("file.txt", ".") → extract one file
zf.read("file.txt")        → get bytes without extracting
zf.write("src.txt", "arc.txt") → add file with archive name
zf.writestr("name.txt", data) → add string/bytes as file
zf.getinfo("file.txt")     → ZipInfo metadata
zf.infolist()              → list of ZipInfo objects

─────────────────────────────────────
📁 TARFILE MODULE
─────────────────────────────────────
import tarfile

tarfile.open(path, "r:gz")  → read .tar.gz
tarfile.open(path, "w:gz")  → write .tar.gz
tarfile.open(path, "w:bz2") → write .tar.bz2
tarfile.open(path, "w:xz")  → write .tar.xz
tarfile.open(path, "r:*")   → auto-detect compression

tf.extractall(path)
tf.add("dir/", arcname="mydir")
tf.getmembers()              → list of TarInfo objects

─────────────────────────────────────
🗜️  SINGLE-FILE COMPRESSION
─────────────────────────────────────
import gzip, bz2, lzma

gzip.compress(data)   / gzip.decompress(data)
bz2.compress(data)    / bz2.decompress(data)
lzma.compress(data)   / lzma.decompress(data)

Or file I/O:
gzip.open("file.gz", "wt")  → text write
gzip.open("file.gz", "rb")  → binary read

💻 CODE:
import zipfile
import tarfile
import gzip
import bz2
import lzma
import os
import io
from pathlib import Path

# Create some test files
Path("/tmp/archive_demo").mkdir(exist_ok=True)
for i, content in enumerate(["Hello, World!", "Python is great!", "Archives rock!"]):
    Path(f"/tmp/archive_demo/file{i+1}.txt").write_text(content)
Path("/tmp/archive_demo/subdir").mkdir(exist_ok=True)
Path("/tmp/archive_demo/subdir/nested.txt").write_text("Nested file content")

# ── ZIP FILES ────────────────────

# Create a ZIP archive
with zipfile.ZipFile("/tmp/demo.zip", "w", compression=zipfile.ZIP_DEFLATED) as zf:
    # Add individual files with custom archive names
    zf.write("/tmp/archive_demo/file1.txt", "docs/file1.txt")
    zf.write("/tmp/archive_demo/file2.txt", "docs/file2.txt")

    # Add entire directory
    for path in Path("/tmp/archive_demo").rglob("*"):
        if path.is_file():
            arcname = path.relative_to("/tmp/archive_demo")
            zf.write(path, str(arcname))

    # Add content from a string/bytes (no actual file needed)
    zf.writestr("README.txt", "This is a README file generated in memory!")
    zf.writestr("data/config.json", '{"debug": true, "version": "1.0"}')

print(f"Created: /tmp/demo.zip ({os.path.getsize('/tmp/demo.zip')} bytes)")

# List contents
with zipfile.ZipFile("/tmp/demo.zip", "r") as zf:
    print("\\nContents:")
    for info in zf.infolist():
        print(f"  {info.filename:30s} {info.file_size:,} bytes → {info.compress_size:,} compressed")

# Read without extracting
with zipfile.ZipFile("/tmp/demo.zip", "r") as zf:
    content = zf.read("README.txt").decode("utf-8")
    print(f"\\nREADME: {content}")

# Extract specific file
with zipfile.ZipFile("/tmp/demo.zip", "r") as zf:
    zf.extract("data/config.json", "/tmp/extracted/")
    print(f"Extracted config.json")

# Extract all
with zipfile.ZipFile("/tmp/demo.zip", "r") as zf:
    zf.extractall("/tmp/extracted_all/")
    print(f"Extracted all to /tmp/extracted_all/")

# Check if file exists in archive
with zipfile.ZipFile("/tmp/demo.zip", "r") as zf:
    names = set(zf.namelist())
    print(f"README.txt exists: {'README.txt' in names}")

# Append to ZIP
with zipfile.ZipFile("/tmp/demo.zip", "a") as zf:
    zf.writestr("appended.txt", "I was added later!")

# Compression levels
for level in [zipfile.ZIP_STORED, zipfile.ZIP_DEFLATED]:
    with zipfile.ZipFile(f"/tmp/demo_{level}.zip", "w", compression=level) as zf:
        for i in range(1, 4):
            zf.write(f"/tmp/archive_demo/file{i}.txt", f"file{i}.txt")
    size = os.path.getsize(f"/tmp/demo_{level}.zip")
    print(f"  Compression {level}: {size} bytes")

# In-memory ZIP (no file on disk!)
buffer = io.BytesIO()
with zipfile.ZipFile(buffer, "w", zipfile.ZIP_DEFLATED) as zf:
    zf.writestr("data.txt", "This ZIP lives only in memory!")
    zf.writestr("meta.json", '{"created": "now"}')

# Get the ZIP bytes
zip_bytes = buffer.getvalue()
print(f"\\nIn-memory ZIP: {len(zip_bytes)} bytes")

# Read from in-memory ZIP
buffer.seek(0)
with zipfile.ZipFile(buffer, "r") as zf:
    print(zf.read("data.txt").decode())

# ── TAR FILES ────────────────────

# Create tar.gz archive
with tarfile.open("/tmp/demo.tar.gz", "w:gz") as tf:
    tf.add("/tmp/archive_demo", arcname="myproject")

size = os.path.getsize("/tmp/demo.tar.gz")
print(f"\\nCreated: demo.tar.gz ({size} bytes)")

# List contents
with tarfile.open("/tmp/demo.tar.gz", "r:gz") as tf:
    print("\\nTAR contents:")
    for member in tf.getmembers():
        if member.isfile():
            print(f"  {member.name:30s} {member.size:,} bytes")

# Extract
with tarfile.open("/tmp/demo.tar.gz", "r:gz") as tf:
    tf.extractall("/tmp/tar_extracted/")

# Different compression formats
compressions = [("gz", "w:gz"), ("bz2", "w:bz2"), ("xz", "w:xz")]
for ext, mode in compressions:
    with tarfile.open(f"/tmp/demo.tar.{ext}", mode) as tf:
        tf.add("/tmp/archive_demo", arcname="myproject")
    size = os.path.getsize(f"/tmp/demo.tar.{ext}")
    print(f"  tar.{ext}: {size:,} bytes")

# ── SINGLE-FILE COMPRESSION ───────

data = "Python compression " * 1000  # repetitive = compresses well

original_bytes = data.encode("utf-8")
print(f"\\nOriginal size: {len(original_bytes):,} bytes")

# gzip
gz_bytes = gzip.compress(original_bytes)
print(f"gzip:  {len(gz_bytes):,} bytes ({100*len(gz_bytes)//len(original_bytes)}%)")

back = gzip.decompress(gz_bytes)
print(f"Decompressed matches: {back == original_bytes}")

# bz2 (better compression, slower)
bz2_bytes = bz2.compress(original_bytes)
print(f"bz2:   {len(bz2_bytes):,} bytes ({100*len(bz2_bytes)//len(original_bytes)}%)")

# lzma (best compression)
lzma_bytes = lzma.compress(original_bytes)
print(f"lzma:  {len(lzma_bytes):,} bytes ({100*len(lzma_bytes)//len(original_bytes)}%)")

# gzip file (text mode)
with gzip.open("/tmp/compressed.txt.gz", "wt", encoding="utf-8") as f:
    f.write("Hello from gzip! " * 100)

with gzip.open("/tmp/compressed.txt.gz", "rt", encoding="utf-8") as f:
    content = f.read()
print(f"Read {len(content)} chars from gzip file")

# ── SHUTIL ARCHIVE SHORTCUTS ──────

import shutil

# Make archive (easiest way!)
shutil.make_archive("/tmp/shutil_demo", "zip", "/tmp/archive_demo")
shutil.make_archive("/tmp/shutil_demo_gz", "gztar", "/tmp/archive_demo")

# Unpack
shutil.unpack_archive("/tmp/shutil_demo.zip", "/tmp/shutil_unpacked/")
print(f"Unpacked via shutil")

# Supported formats
print(f"Supported formats: {[fmt[0] for fmt in shutil.get_archive_formats()]}")

# Cleanup
import shutil as sh
for path in ["/tmp/archive_demo", "/tmp/extracted", "/tmp/extracted_all",
             "/tmp/tar_extracted", "/tmp/shutil_unpacked"]:
    sh.rmtree(path, ignore_errors=True)
for f in Path("/tmp").glob("demo*"):
    f.unlink(missing_ok=True)
for f in ["/tmp/compressed.txt.gz", "/tmp/shutil_demo.zip", "/tmp/shutil_demo_gz.tar.gz"]:
    Path(f).unlink(missing_ok=True)

📝 KEY POINTS:
✅ zipfile.ZipFile() works as context manager — always use "with"
✅ writestr() lets you add in-memory data to archives without temp files
✅ In-memory ZIPs with BytesIO() — great for streaming/HTTP responses
✅ ZIP: random access to any file; TAR: streaming, better for large files
✅ tarfile modes: "w:gz" write gzip, "r:*" auto-detect on read
✅ shutil.make_archive() is the quickest way for simple archive creation
✅ gzip.open() / bz2.open() work like open() — read/write compressed files transparently
❌ Never extract untrusted archives without checking paths (path traversal attack!)
❌ ZIP_STORED (no compression) for files already compressed (jpg, mp4) — compression wastes time
❌ tarfile.extractall() on untrusted data can overwrite system files — always validate paths
''',
  quiz: [
    Quiz(question: 'What does zipfile.ZipFile.writestr("readme.txt", "hello") do?', options: [
      QuizOption(text: 'Writes "hello" to a file called readme.txt on disk', correct: false),
      QuizOption(text: 'Adds a file called readme.txt containing "hello" to the ZIP archive without needing a real file', correct: true),
      QuizOption(text: 'Extracts readme.txt from the archive and writes to disk', correct: false),
      QuizOption(text: 'Overwrites any existing readme.txt in the archive', correct: false),
    ]),
    Quiz(question: 'What does tarfile.open("archive.tar.gz", "r:*") do?', options: [
      QuizOption(text: 'Creates a new compressed archive', correct: false),
      QuizOption(text: 'Opens any tar archive for reading with automatic compression detection', correct: true),
      QuizOption(text: 'Lists the contents without opening', correct: false),
      QuizOption(text: 'Raises an error — the mode is invalid', correct: false),
    ]),
    Quiz(question: 'Which Python built-in makes creating a zip archive simplest for a directory?', options: [
      QuizOption(text: 'zipfile.ZipFile().add_directory()', correct: false),
      QuizOption(text: 'shutil.make_archive(name, "zip", directory)', correct: true),
      QuizOption(text: 'os.compress(directory, "zip")', correct: false),
      QuizOption(text: 'pathlib.Path.archive()', correct: false),
    ]),
  ],
);
