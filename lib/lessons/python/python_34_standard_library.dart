import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson34 = Lesson(
  language: 'Python',
  title: 'Standard Library Deep Dive',
  content: '''
🎯 METAPHOR:
Python's standard library is like a massive hardware store
where everything is already paid for.
You walk in with your needs: "I need to sort files by date,
hash a password, parse command-line args, run a web server,
compress a file, send an email, or talk to a database."
There's an aisle for every single one of those. No internet
connection, no pip install needed. Just import and build.
Learning the standard library means you stop reinventing
things that Python already built perfectly.

📖 EXPLANATION:
Python ships with a massive standard library ("batteries included"
philosophy). This lesson covers the most useful modules.

─────────────────────────────────────
🗂️  FILE & SYSTEM
─────────────────────────────────────
os         → file ops, env vars, process
sys        → interpreter, args, path
pathlib    → modern OOP path handling
shutil     → high-level file operations
glob       → file pattern matching
tempfile   → temporary files/dirs
stat       → file stat constants

─────────────────────────────────────
📊 DATA STRUCTURES
─────────────────────────────────────
collections → Counter, defaultdict, OrderedDict,
              deque, ChainMap, namedtuple
heapq      → heap / priority queue operations
bisect     → binary search on sorted lists
array      → typed arrays
struct     → pack/unpack binary data
io         → file-like objects in memory

─────────────────────────────────────
🔢 MATH & NUMBERS
─────────────────────────────────────
math       → sqrt, pi, sin, log, factorial
decimal    → precise decimal arithmetic
fractions  → exact rational numbers
statistics → mean, median, mode, stdev
random     → random numbers, sampling
cmath      → complex number math

─────────────────────────────────────
📝 TEXT PROCESSING
─────────────────────────────────────
string     → constants, Template
re         → regular expressions
textwrap   → wrap/indent text
unicodedata → Unicode database
difflib    → diff/compare sequences
readline   → line-editing library

─────────────────────────────────────
🌐 INTERNET & NETWORKING
─────────────────────────────────────
urllib     → URL parsing, opening, encoding
http       → HTTP client/server
email      → parse/construct email messages
html       → HTML parser, escape
xml        → XML parsing
json       → JSON encode/decode
socket     → low-level networking
ssl        → SSL wrapping
ipaddress  → IP address manipulation

─────────────────────────────────────
⚡ PROCESSES & CONCURRENCY
─────────────────────────────────────
threading  → threads
multiprocessing → processes
concurrent.futures → thread/process pools
subprocess → run external commands
queue      → thread-safe queues
asyncio    → async event loop
signal     → Unix signals

─────────────────────────────────────
🛡️  CRYPTO & HASHING
─────────────────────────────────────
hashlib    → MD5, SHA1, SHA256, etc.
hmac       → keyed hashing for messages
secrets    → cryptographically secure random
base64     → encode/decode binary data
binascii   → binary ↔ ASCII conversion

─────────────────────────────────────
🧪 TESTING & DEBUGGING
─────────────────────────────────────
unittest   → unit testing framework
doctest    → tests in docstrings
pdb        → Python debugger
traceback  → format tracebacks
cProfile   → CPU profiling
timeit     → time small code snippets
logging    → structured logging
warnings   → warning system

─────────────────────────────────────
📦 PACKAGING & DISTRIBUTION
─────────────────────────────────────
argparse   → command-line argument parsing
configparser → INI config file parsing
logging    → logging framework
pprint     → pretty printer
reprlib    → repr for large containers
abc        → abstract base classes
enum       → enumerations
dataclasses → auto-generate class boilerplate
typing     → type hints

💻 CODE:
# ── os and pathlib ─────────────────
import os
from pathlib import Path

# Environment variables
home = os.environ.get("HOME", "/tmp")
path_var = os.environ.get("PATH", "")
os.environ["MY_APP_DEBUG"] = "true"

p = Path.home() / "Desktop"
print(p.exists())

# Walk directory tree
for dirpath, dirnames, filenames in os.walk("."):
    for filename in filenames:
        full = os.path.join(dirpath, filename)
        size = os.path.getsize(full)
        print(f"{full}: {size} bytes")

# shutil — high-level file ops
import shutil
# shutil.copy("src.txt", "dst.txt")        # copy file
# shutil.copytree("src_dir", "dst_dir")    # copy dir
# shutil.rmtree("my_dir")                  # delete dir+contents
# shutil.move("old.txt", "new.txt")        # move/rename
disk = shutil.disk_usage("/")
print(f"Disk: {disk.total//1e9:.1f}GB total, {disk.free//1e9:.1f}GB free")

# glob — find files matching pattern
import glob
py_files = glob.glob("**/*.py", recursive=True)
for f in py_files[:3]:
    print(f)

# ── COLLECTIONS ────────────────────
from collections import Counter, defaultdict, OrderedDict, ChainMap, deque

# Counter
words = "the quick brown fox jumps over the lazy dog the fox".split()
freq = Counter(words)
print(freq.most_common(3))
freq.update(["fox", "dog"])  # add more counts
print(f"fox appears: {freq['fox']}")

# Counter arithmetic
c1 = Counter(a=3, b=2, c=1)
c2 = Counter(a=1, b=5, d=2)
print(c1 + c2)   # add counts
print(c1 - c2)   # subtract (drop negatives)
print(c1 & c2)   # intersection (min of each)
print(c1 | c2)   # union (max of each)

# deque — double-ended queue
dq = deque(maxlen=3)   # fixed-size sliding window!
for i in range(6):
    dq.append(i)
    print(list(dq))
# Once maxlen reached, oldest items are auto-dropped!

# ChainMap — layered lookups
defaults   = {"color": "blue", "size": "M", "qty": 1}
user_prefs = {"color": "red"}
combined = ChainMap(user_prefs, defaults)
print(combined["color"])  # red (user preference wins)
print(combined["size"])   # M   (from defaults)

# ── HEAPQ — Priority Queue ─────────
import heapq

tasks = [(3,"low priority"), (1,"urgent!"), (2,"normal")]
heapq.heapify(tasks)
print(heapq.heappop(tasks))   # (1, 'urgent!') — smallest first
heapq.heappush(tasks, (0, "CRITICAL!"))
print(heapq.heappop(tasks))   # (0, 'CRITICAL!')

# Top N items
nums = [3, 1, 4, 1, 5, 9, 2, 6, 5, 3]
print(heapq.nlargest(3, nums))   # [9, 6, 5]
print(heapq.nsmallest(3, nums))  # [1, 1, 2]

# ── BISECT — Binary Search ─────────
import bisect

sorted_list = [1, 3, 5, 7, 9, 11]
pos = bisect.bisect_left(sorted_list, 6)  # where 6 would go
print(f"6 would be at index {pos}")        # 3
bisect.insort(sorted_list, 6)   # insert in sorted position
print(sorted_list)   # [1, 3, 5, 6, 7, 9, 11]

# ── STATISTICS ─────────────────────
import statistics

data = [2, 3, 3, 4, 4, 4, 5, 5, 6, 7, 9]
print(f"Mean:   {statistics.mean(data):.2f}")
print(f"Median: {statistics.median(data)}")
print(f"Mode:   {statistics.mode(data)}")
print(f"Stdev:  {statistics.stdev(data):.2f}")
print(f"Var:    {statistics.variance(data):.2f}")
print(f"Quant:  {statistics.quantiles(data, n=4)}")

# ── HASHLIB ────────────────────────
import hashlib
import secrets

# Hash a password
def hash_password(password: str, salt: bytes = None) -> tuple:
    if salt is None:
        salt = secrets.token_bytes(16)
    key = hashlib.pbkdf2_hmac('sha256', password.encode(), salt, 100000)
    return salt, key

salt, hashed = hash_password("mypassword123")
print(f"Salt: {salt.hex()[:16]}...")
print(f"Hash: {hashed.hex()[:16]}...")

# File checksum
def file_checksum(path):
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(8192), b""):
            h.update(chunk)
    return h.hexdigest()

# ── SUBPROCESS ─────────────────────
import subprocess

result = subprocess.run(
    ["python3", "--version"],
    capture_output=True,
    text=True
)
print(result.stdout)    # Python 3.x.y
print(result.returncode)  # 0 = success

# ── LOGGING ────────────────────────
import logging

logging.basicConfig(
    level=logging.DEBUG,
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s"
)
logger = logging.getLogger("myapp")

logger.debug("Debug info")
logger.info("User logged in")
logger.warning("Low disk space")
logger.error("File not found")
logger.critical("System failure!")

# ── ARGPARSE ───────────────────────
import argparse

parser = argparse.ArgumentParser(description="My CLI tool")
parser.add_argument("filename",             help="Input file")
parser.add_argument("--output", "-o",      help="Output file", default="out.txt")
parser.add_argument("--verbose", "-v",     action="store_true")
parser.add_argument("--count",  "-n",      type=int, default=10)
# args = parser.parse_args()   # use in a real script

📝 KEY POINTS:
✅ Python's standard library is vast — search docs before writing utilities
✅ pathlib.Path is OOP path handling — preferred over os.path
✅ collections.Counter, defaultdict, deque are workhorses
✅ heapq provides an efficient priority queue
✅ Use hashlib.pbkdf2_hmac for password hashing — NOT md5 or sha1!
✅ logging is far superior to print() for production applications
✅ argparse turns your scripts into proper CLI tools
❌ Don't re-implement what's in the standard library
❌ Never use md5 or sha1 for password hashing — use pbkdf2/bcrypt/argon2
❌ subprocess.shell=True is a security risk with user input
''',
  quiz: [
    Quiz(question: 'Which hashing function should you use for password storage?', options: [
      QuizOption(text: 'hashlib.md5 — fast and widely supported', correct: false),
      QuizOption(text: 'hashlib.sha1 — secure and efficient', correct: false),
      QuizOption(text: 'hashlib.pbkdf2_hmac with salt — deliberately slow for security', correct: true),
      QuizOption(text: 'base64.b64encode — easy to decode', correct: false),
    ]),
    Quiz(question: 'What does collections.Counter([1,1,2,3,3,3]).most_common(2) return?', options: [
      QuizOption(text: '[1, 3] — the two most common values', correct: false),
      QuizOption(text: '[(3, 3), (1, 2)] — the two most common (value, count) pairs', correct: true),
      QuizOption(text: '{1: 2, 3: 3} — a dictionary', correct: false),
      QuizOption(text: '[3, 1] — sorted by frequency', correct: false),
    ]),
    Quiz(question: 'What makes deque(maxlen=5) different from a regular list?', options: [
      QuizOption(text: 'deque is slower but uses less memory', correct: false),
      QuizOption(text: 'When full, it automatically discards the oldest item when a new one is added', correct: true),
      QuizOption(text: 'deque only allows integers', correct: false),
      QuizOption(text: 'deque is immutable after creation', correct: false),
    ]),
  ],
);
