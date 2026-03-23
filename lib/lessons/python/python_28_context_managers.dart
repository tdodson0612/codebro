import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson28 = Lesson(
  language: 'Python',
  title: 'Context Managers & the with Statement',
  content: """
🎯 METAPHOR:
A context manager is like a responsible hotel concierge.
When you check in (enter the context), the concierge
hands you your key and sets everything up. When you
check out (exit the context), the concierge takes back
the key, cleans the room, and settles the bill —
AUTOMATICALLY, whether your stay was pleasant or
you left in a fire alarm. You don't have to remember to
return the key. The "with" statement is your check-in
and checkout process in one tidy block.

📖 EXPLANATION:
Context managers manage setup and teardown code,
guaranteeing cleanup happens even if exceptions occur.
The "with" statement calls __enter__ on entry and
__exit__ on exit (even if an exception occurs).

─────────────────────────────────────
📐 SYNTAX
─────────────────────────────────────
with context_manager as variable:
    # body — variable is what __enter__ returns
    # __exit__ called automatically when block ends

─────────────────────────────────────
🔑 THE PROTOCOL
─────────────────────────────────────
__enter__(self)          → setup, returns "as" variable
__exit__(self, exc_type, exc_val, exc_tb) → cleanup
  exc_* params are None if no exception occurred
  Return True to suppress exception; False to re-raise

─────────────────────────────────────
📦 BUILT-IN CONTEXT MANAGERS
─────────────────────────────────────
open()          → file handling
threading.Lock  → thread synchronization
decimal.localcontext → temporary decimal precision
unittest.mock.patch → testing mocks
tempfile.TemporaryDirectory → temp dir auto-cleanup

─────────────────────────────────────
🏗️  CREATING CONTEXT MANAGERS
─────────────────────────────────────
Method 1: class with __enter__ / __exit__
Method 2: @contextmanager decorator (easiest!)
  from contextlib import contextmanager
  yield is the "with" body

─────────────────────────────────────
🧰 CONTEXTLIB UTILITIES
─────────────────────────────────────
contextmanager   → decorator to make generators into CMs
suppress         → silently ignore specific exceptions
redirect_stdout  → redirect print() output
ExitStack        → manage variable number of CMs
nullcontext      → no-op context manager
asynccontextmanager → for async context managers

💻 CODE:
# Classic: file handling
with open("example.txt", "w") as f:
    f.write("Hello World")
# f is automatically closed here — even on exception!

# Multiple context managers (Python 3.1+)
with open("source.txt") as src, open("dest.txt", "w") as dst:
    dst.write(src.read())

# Class-based context manager
class Timer:
    import time

    def __enter__(self):
        import time
        self.start = time.perf_counter()
        print("⏱️  Timer started")
        return self   # "as" variable gets this

    def __exit__(self, exc_type, exc_val, exc_tb):
        import time
        elapsed = time.perf_counter() - self.start
        print(f"⏱️  Elapsed: {elapsed:.4f}s")
        return False   # don't suppress exceptions

with Timer() as t:
    total = sum(range(1_000_000))
    print(f"Sum: {total}")
# ⏱️  Timer started → Sum: ... → ⏱️  Elapsed: ...

# Suppress exceptions
class SuppressErrors:
    def __init__(self, *exceptions):
        self.exceptions = exceptions

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        return exc_type is not None and issubclass(exc_type, self.exceptions)

with SuppressErrors(ZeroDivisionError, ValueError):
    x = 1 / 0   # silently suppressed!
    y = int("bad")   # also suppressed!
print("Still running!")

# @contextmanager decorator — much easier!
from contextlib import contextmanager

@contextmanager
def timer_ctx(label=""):
    import time
    start = time.perf_counter()
    try:
        yield   # ← body of "with" block runs here
    finally:
        elapsed = time.perf_counter() - start
        print(f"⏱️  {label}: {elapsed:.4f}s")

with timer_ctx("My computation"):
    result = sum(x**2 for x in range(100000))

# Context manager that yields a value
@contextmanager
def managed_resource(name):
    print(f"Setting up {name}")
    resource = {"name": name, "data": []}
    try:
        yield resource          # this is the "as" variable
    except Exception as e:
        print(f"Error in {name}: {e}")
        raise
    finally:
        print(f"Cleaning up {name}")

with managed_resource("database") as db:
    db["data"].append(1)
    db["data"].append(2)
    print(f"Resource: {db}")

# Temporary directory
import tempfile
import os
with tempfile.TemporaryDirectory() as tmpdir:
    path = os.path.join(tmpdir, "test.txt")
    with open(path, "w") as f:
        f.write("temp data")
    print(f"Temp dir: {tmpdir}")
    print(os.listdir(tmpdir))
# tmpdir automatically deleted after block!

# contextlib.suppress — built-in version
from contextlib import suppress

with suppress(FileNotFoundError):
    os.remove("nonexistent.txt")   # no crash!

with suppress(KeyError, IndexError):
    d = {}
    x = d["missing"]   # silently ignored

# redirect_stdout — capture print output
from contextlib import redirect_stdout
import io

buffer = io.StringIO()
with redirect_stdout(buffer):
    print("This goes to buffer, not screen!")
    print("Me too!")

output = buffer.getvalue()
print(f"Captured: {repr(output)}")

# ExitStack — dynamic number of context managers
from contextlib import ExitStack

files_to_open = ["file1.txt", "file2.txt", "file3.txt"]
# Create them first
for fn in files_to_open:
    Path(fn).write_text(f"content of {fn}")

from pathlib import Path
with ExitStack() as stack:
    handles = [stack.enter_context(open(fn)) for fn in files_to_open]
    for handle in handles:
        print(handle.readline().strip())
# All files closed automatically!

# Database connection context manager
@contextmanager
def db_transaction(connection):
    """Commit on success, rollback on failure."""
    try:
        yield connection
        connection.commit()
        print("Transaction committed")
    except Exception:
        connection.rollback()
        print("Transaction rolled back")
        raise
    finally:
        connection.close()

# Reentrant context managers (can be nested)
import threading
lock = threading.RLock()  # reentrant lock

with lock:
    with lock:   # same thread can acquire again
        print("Nested lock works with RLock")

# asynccontextmanager (for async code)
from contextlib import asynccontextmanager

@asynccontextmanager
async def async_timer():
    import asyncio, time
    start = time.perf_counter()
    try:
        yield
    finally:
        print(f"Async elapsed: {time.perf_counter()-start:.4f}s")

📝 KEY POINTS:
✅ Context managers guarantee cleanup even when exceptions occur
✅ @contextmanager makes creating CMs easy — yield is the with-body
✅ Use contextlib.suppress to silently ignore specific exceptions
✅ Use ExitStack when you have a dynamic number of context managers
✅ Multiple CMs in one with: "with cm1() as a, cm2() as b:"
✅ __exit__ receives exception info — return True to suppress it
❌ Without context managers, exceptions can leave files/connections open
❌ Don't swallow exceptions silently unless you truly intend to
❌ contextmanager generator must yield EXACTLY once
""",
  quiz: [
    Quiz(question: 'What is guaranteed by the "with" statement?', options: [
      QuizOption(text: 'The code inside runs without exceptions', correct: false),
      QuizOption(text: '__exit__ is called on exit, even if an exception occurs', correct: true),
      QuizOption(text: 'The context manager runs in a separate thread', correct: false),
      QuizOption(text: 'The "as" variable is always defined', correct: false),
    ]),
    Quiz(question: 'In a @contextmanager function, where does the "with" block body execute?', options: [
      QuizOption(text: 'Before the yield statement', correct: false),
      QuizOption(text: 'After the function returns', correct: false),
      QuizOption(text: 'At the yield statement — execution is suspended there', correct: true),
      QuizOption(text: 'In a separate thread', correct: false),
    ]),
    Quiz(question: 'What does contextlib.suppress(ValueError) do?', options: [
      QuizOption(text: 'Converts ValueError to a warning', correct: false),
      QuizOption(text: 'Silently catches and discards ValueError inside the with block', correct: true),
      QuizOption(text: 'Logs ValueError without crashing', correct: false),
      QuizOption(text: 'Re-raises ValueError as RuntimeError', correct: false),
    ]),
  ],
);
