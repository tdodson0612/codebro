import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson53 = Lesson(
  language: 'Python',
  title: 'Logging, Debugging & Profiling',
  content: """
🎯 METAPHOR:
Logging is like a ship's captain's logbook.
Every significant event gets recorded: departure time,
weather conditions, course changes, problems encountered.
When something goes wrong, you don't guess — you read the log.
print() is like shouting updates into the wind — they vanish.
The logging module is the official logbook: structured,
timestamped, severity-leveled, filterable, and permanently
recorded. Debug is "weather conditions." Info is "departed port."
Warning is "rough seas." Error is "hull damage." Critical
is "abandon ship."

📖 EXPLANATION:
Python's logging module provides structured, configurable
logging. pdb is the built-in debugger. cProfile and timeit
measure performance. Together they form the complete
"find and fix" toolkit.

─────────────────────────────────────
📊 LOG LEVELS (lowest → highest)
─────────────────────────────────────
DEBUG    (10) → detailed diagnostic info
INFO     (20) → confirmation things work
WARNING  (30) → something unexpected (default level)
ERROR    (40) → serious problem, function failed
CRITICAL (50) → program may not continue

─────────────────────────────────────
📦 LOGGING SETUP
─────────────────────────────────────
Basic (quick and dirty):
  logging.basicConfig(level=logging.DEBUG)

Production (handlers + formatters):
  logger = logging.getLogger("myapp")
  handler = logging.FileHandler("app.log")
  formatter = logging.Formatter("%(asctime)s %(levelname)s %(message)s")
  handler.setFormatter(formatter)
  logger.addHandler(handler)

─────────────────────────────────────
🔑 KEY CONCEPTS
─────────────────────────────────────
Logger     → named log channel (hierarchical)
Handler    → destination (file, console, email, etc.)
Formatter  → log message format
Filter     → selective logging
Level      → minimum severity to log

─────────────────────────────────────
🐛 PDB — PYTHON DEBUGGER
─────────────────────────────────────
import pdb; pdb.set_trace()    # Python < 3.7
breakpoint()                   # Python 3.7+ (cleaner!)

PDB commands:
  n  → next line (step over)
  s  → step into function call
  c  → continue until next breakpoint
  q  → quit
  p expr → print expression
  pp expr → pretty-print expression
  l  → list source around current line
  bt → backtrace (call stack)
  b line → set breakpoint at line
  w  → where (call stack)
  u/d → up/down in call stack

─────────────────────────────────────
⏱️  PROFILING TOOLS
─────────────────────────────────────
timeit      → measure small code snippets
cProfile    → function-level CPU profiling
profile     → pure Python profiler (slower)
line_profiler → line-by-line (pip install)
memory_profiler → memory usage (pip install)
tracemalloc  → built-in memory tracing

💻 CODE:
import logging
import logging.handlers
import sys
import timeit
import cProfile
import pstats
import io
from functools import wraps
import time

# ── BASIC LOGGING ─────────────────

# Quick setup
logging.basicConfig(
    level=logging.DEBUG,
    format="%(asctime)s [%(levelname)-8s] %(name)s: %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S"
)

# Get a logger — use __name__ convention!
logger = logging.getLogger(__name__)

logger.debug("This is debug info")
logger.info("Server starting up")
logger.warning("Config file missing, using defaults")
logger.error("Failed to connect to database")
logger.critical("Out of disk space!")

# ── STRUCTURED LOGGING ─────────────

# Create a proper logger with handlers
def setup_logger(name: str, log_file: str = None, level=logging.DEBUG):
    logger = logging.getLogger(name)
    logger.setLevel(level)

    formatter = logging.Formatter(
        "%(asctime)s [%(levelname)-8s] %(name)s (%(filename)s:%(lineno)d): %(message)s"
    )

    # Console handler
    console = logging.StreamHandler(sys.stdout)
    console.setLevel(logging.INFO)
    console.setFormatter(formatter)
    logger.addHandler(console)

    # File handler
    if log_file:
        file_handler = logging.FileHandler(log_file)
        file_handler.setLevel(logging.DEBUG)
        file_handler.setFormatter(formatter)
        logger.addHandler(file_handler)

    return logger

app_logger = setup_logger("myapp")
app_logger.info("Application started")
app_logger.debug("Debug message (file only if configured)")

# ── ROTATING FILE HANDLER ──────────

def setup_rotating_logger(name: str, log_file: str):
    """Log files that auto-rotate at 1MB, keep 5 backups."""
    logger = logging.getLogger(name)
    logger.setLevel(logging.DEBUG)

    handler = logging.handlers.RotatingFileHandler(
        log_file,
        maxBytes=1_000_000,   # 1MB
        backupCount=5
    )
    formatter = logging.Formatter("%(asctime)s %(levelname)s %(message)s")
    handler.setFormatter(formatter)
    logger.addHandler(handler)
    return logger

# ── LOG WITH EXTRA CONTEXT ─────────

# Structured log fields via extra={}
request_logger = logging.getLogger("requests")
request_logger.info(
    "Request processed",
    extra={
        "user_id": 42,
        "endpoint": "/api/users",
        "duration_ms": 15,
        "status": 200
    }
)

# ── LOG EXCEPTIONS ─────────────────

def divide(a, b):
    return a / b

try:
    result = divide(10, 0)
except ZeroDivisionError:
    logger.exception("Division failed")  # logs traceback automatically!
    # logger.error("...", exc_info=True)  # equivalent

# ── CONDITIONAL LOGGING ────────────

# Expensive message formatting — only format if level is active
if logger.isEnabledFor(logging.DEBUG):
    expensive_data = {"key": "value", "list": list(range(1000))}
    logger.debug("Data: %s", expensive_data)   # lazy formatting!

# Use % formatting in logging (NOT f-strings!) for lazy evaluation:
# logger.debug("Value: %s", compute_heavy_value())   # lazy
# logger.debug(f"Value: {compute_heavy_value()}")    # eager (always runs!)

# ── LOGGING CONTEXT ────────────────

class RequestContext:
    """Add request context to all log messages."""
    def __init__(self, request_id: str):
        self.request_id = request_id

    def __enter__(self):
        self.old_factory = logging.getLogRecordFactory()
        request_id = self.request_id

        def record_factory(*args, **kwargs):
            record = self.old_factory(*args, **kwargs)
            record.request_id = request_id
            return record

        logging.setLogRecordFactory(record_factory)
        return self

    def __exit__(self, *args):
        logging.setLogRecordFactory(self.old_factory)

# ── DEBUGGING ─────────────────────

def buggy_function(data):
    result = []
    for i, item in enumerate(data):
        # Uncomment to debug:
        # breakpoint()   # Python 3.7+ — opens interactive debugger
        processed = item * 2 + 1
        result.append(processed)
    return result

# Debugging without breakpoint — print debugging (quick and dirty)
def debug_trace(func):
    """Decorator that prints function calls and returns."""
    @wraps(func)
    def wrapper(*args, **kwargs):
        print(f"→ {func.__name__}({args}, {kwargs})")
        result = func(*args, **kwargs)
        print(f"← {func.__name__} returned {result!r}")
        return result
    return wrapper

@debug_trace
def add(a, b):
    return a + b

add(3, 4)   # → add((3, 4), {})  ← add returned 7

# ── PROFILING WITH TIMEIT ──────────

# Measure single expression
t = timeit.timeit(
    stmt="[x**2 for x in range(1000)]",
    number=10_000
)
print(f"List comp (10k runs): {t:.3f}s")

# Compare two approaches
def approach1():
    return [x**2 for x in range(1000)]

def approach2():
    return list(map(lambda x: x**2, range(1000)))

t1 = timeit.timeit(approach1, number=10_000)
t2 = timeit.timeit(approach2, number=10_000)
print(f"List comp: {t1:.3f}s")
print(f"map+lambda: {t2:.3f}s")
print(f"Winner: {'list comp' if t1 < t2 else 'map'} by {abs(t1-t2):.3f}s")

# ── PROFILING WITH CPROFILE ────────

def fibonacci(n):
    if n <= 1: return n
    return fibonacci(n-1) + fibonacci(n-2)

def run_fibonacci():
    return [fibonacci(i) for i in range(25)]

# Capture profile data
profiler = cProfile.Profile()
profiler.enable()
run_fibonacci()
profiler.disable()

# Print stats
stream = io.StringIO()
stats = pstats.Stats(profiler, stream=stream)
stats.sort_stats("cumulative")
stats.print_stats(10)    # top 10 functions
print(stream.getvalue()[:500])   # show first 500 chars

# ── TIMING DECORATOR ──────────────

def timer(func=None, *, repeats=1):
    """Measure execution time of a function."""
    if func is None:
        return lambda f: timer(f, repeats=repeats)

    @wraps(func)
    def wrapper(*args, **kwargs):
        times = []
        result = None
        for _ in range(repeats):
            start = time.perf_counter()
            result = func(*args, **kwargs)
            times.append(time.perf_counter() - start)
        avg = sum(times) / len(times)
        print(f"⏱️  {func.__name__}: {avg*1000:.3f}ms avg ({repeats} runs)")
        return result
    return wrapper

@timer(repeats=5)
def slow_operation():
    return sum(range(100_000))

slow_operation()

# ── ASSERT FOR DEBUGGING ───────────

def binary_search(arr, target):
    assert len(arr) == len(set(arr)), "Array must have unique elements"
    assert arr == sorted(arr), "Array must be sorted"

    lo, hi = 0, len(arr) - 1
    while lo <= hi:
        mid = (lo + hi) // 2
        if arr[mid] == target:
            return mid
        elif arr[mid] < target:
            lo = mid + 1
        else:
            hi = mid - 1
    return -1

print(binary_search([1,3,5,7,9,11], 7))   # 3
# Run with python -O to disable assertions in production

📝 KEY POINTS:
✅ Use logging instead of print() for any code beyond scripts
✅ Always get logger via logging.getLogger(__name__) — hierarchical names
✅ Use % formatting in log messages (not f-strings) for lazy evaluation
✅ logger.exception() inside except blocks auto-attaches the traceback
✅ breakpoint() is the modern way to drop into pdb (Python 3.7+)
✅ cProfile shows WHERE time is spent; timeit measures HOW FAST specific code runs
✅ RotatingFileHandler prevents log files from growing forever
❌ Don't use print() in library or production code — use logging
❌ Don't log sensitive data (passwords, tokens, PII) even at DEBUG level
❌ Don't profile prematurely — first make it correct, then make it fast
""",
  quiz: [
    Quiz(question: 'What is the correct way to log an exception with its traceback?', options: [
      QuizOption(text: 'logger.error(str(e))', correct: false),
      QuizOption(text: 'logger.exception("Message") inside an except block', correct: true),
      QuizOption(text: 'logger.debug(traceback.format_exc())', correct: false),
      QuizOption(text: 'print(traceback.print_exc())', correct: false),
    ]),
    Quiz(question: 'Why should you use "logger.debug(\'Value: %s\', x)" instead of "logger.debug(f\'Value: {x}\')"?', options: [
      QuizOption(text: 'f-strings don\'t work in logging calls', correct: false),
      QuizOption(text: 'The % format is lazily evaluated — the string is only built if DEBUG level is active', correct: true),
      QuizOption(text: '% format is faster syntax', correct: false),
      QuizOption(text: 'f-strings cause encoding errors in log files', correct: false),
    ]),
    Quiz(question: 'What does cProfile measure?', options: [
      QuizOption(text: 'Memory usage of each line', correct: false),
      QuizOption(text: 'CPU time spent in each function and how many times each was called', correct: true),
      QuizOption(text: 'Network I/O per function', correct: false),
      QuizOption(text: 'Thread contention and GIL wait time', correct: false),
    ]),
  ],
);
