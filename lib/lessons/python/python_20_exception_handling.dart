import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson20 = Lesson(
  language: 'Python',
  title: 'Exception Handling',
  content: """
🎯 METAPHOR:
Exception handling is like an airbag system in a car.
You don't expect to crash, but you build in the protection
anyway. When a crash (exception) happens, the airbag
(except block) deploys — the program doesn't just smash
into a wall and die. You handle the crash gracefully,
maybe restart, maybe log the event, maybe tell the user
what happened. The finally block is like the post-crash
checklist — it runs no matter what, even if there was
no crash, because some things (like turning off the engine)
must always happen.

📖 EXPLANATION:
Exceptions are runtime errors that disrupt normal flow.
Python uses try/except/else/finally to handle them.

─────────────────────────────────────
📐 FULL SYNTAX
─────────────────────────────────────
try:
    # code that might fail
except ExceptionType as e:
    # handle specific exception
except (TypeError, ValueError) as e:
    # handle multiple types
except Exception as e:
    # catch-all (use sparingly!)
else:
    # runs ONLY if try succeeded (no exception)
finally:
    # ALWAYS runs — cleanup goes here

─────────────────────────────────────
⚠️  EXCEPTION HIERARCHY
─────────────────────────────────────
BaseException
  ├── SystemExit
  ├── KeyboardInterrupt
  ├── GeneratorExit
  └── Exception
       ├── ArithmeticError
       │    ├── ZeroDivisionError
       │    └── OverflowError
       ├── LookupError
       │    ├── IndexError
       │    └── KeyError
       ├── TypeError
       ├── ValueError
       ├── NameError
       ├── AttributeError
       ├── ImportError
       │    └── ModuleNotFoundError
       ├── OSError
       │    ├── FileNotFoundError
       │    └── PermissionError
       ├── RuntimeError
       ├── StopIteration
       ├── NotImplementedError
       └── ... many more

─────────────────────────────────────
🚀 RAISING EXCEPTIONS
─────────────────────────────────────
raise ValueError("message")
raise  # re-raise current exception

─────────────────────────────────────
🏗️  CUSTOM EXCEPTIONS
─────────────────────────────────────
class MyError(Exception):
    def __init__(self, message, code=None):
        super().__init__(message)
        self.code = code

─────────────────────────────────────
🔗 EXCEPTION CHAINING
─────────────────────────────────────
try: ...
except SomeError as e:
    raise NewError("context") from e  # chain exceptions

raise NewError() from None  # suppress original exception

💻 CODE:
# Basic try/except
try:
    result = 10 / 0
except ZeroDivisionError:
    print("Can't divide by zero!")

# Capturing the exception object
try:
    int("not a number")
except ValueError as e:
    print(f"ValueError: {e}")

# Multiple except clauses
def safe_access(lst, index):
    try:
        return lst[index]
    except IndexError:
        return f"Index {index} out of range"
    except TypeError:
        return "Index must be an integer"

print(safe_access([1,2,3], 5))    # Index 5 out of range
print(safe_access([1,2,3], "a"))  # Index must be an integer

# Multiple exception types in one clause
def parse_number(s):
    try:
        return int(s)
    except (ValueError, TypeError) as e:
        print(f"Parsing error: {e}")
        return None

# try/except/else/finally
def read_file(filename):
    f = None
    try:
        f = open(filename)
        content = f.read()
    except FileNotFoundError:
        print(f"File not found: {filename}")
        return None
    except PermissionError:
        print(f"Permission denied: {filename}")
        return None
    else:
        print("File read successfully!")  # only if no exception
        return content
    finally:
        if f:
            f.close()   # ALWAYS close the file
        print("Cleanup done")

# Better: use context manager (with statement)
def read_file_better(filename):
    try:
        with open(filename) as f:    # auto-closes!
            return f.read()
    except FileNotFoundError:
        return None

# Raising exceptions
def set_age(age):
    if not isinstance(age, int):
        raise TypeError(f"Age must be int, got {type(age).__name__}")
    if age < 0 or age > 150:
        raise ValueError(f"Age {age} is out of realistic range")
    return age

try:
    set_age(-5)
except ValueError as e:
    print(f"Bad value: {e}")

# Re-raising
def process(data):
    try:
        result = risky_operation(data)
    except Exception as e:
        print(f"Logging error: {e}")
        raise   # re-raise the SAME exception

# Custom exceptions
class InsufficientFundsError(Exception):
    def __init__(self, amount, balance):
        self.amount = amount
        self.balance = balance
        super().__init__(
            f"Cannot withdraw \${amount:.2f}: balance is \${balance:.2f}"
        )

class BankAccount:
    def __init__(self, balance=0):
        self.balance = balance

    def withdraw(self, amount):
        if amount > self.balance:
            raise InsufficientFundsError(amount, self.balance)
        self.balance -= amount
        return amount

account = BankAccount(100)
try:
    account.withdraw(150)
except InsufficientFundsError as e:
    print(f"Error: {e}")
    print(f"Tried to withdraw: \${e.amount}")
    print(f"Available: \${e.balance}")

# Exception chaining
class DatabaseError(Exception): pass

def query_db(sql):
    try:
        # imagine this fails
        raise ConnectionError("DB connection lost")
    except ConnectionError as e:
        raise DatabaseError("Query failed") from e

try:
    query_db("SELECT *")
except DatabaseError as e:
    print(f"DB Error: {e}")
    print(f"Caused by: {e.__cause__}")

# Suppress exception chaining
def safe_parse(s):
    try:
        return int(s)
    except ValueError:
        raise ValueError(f"'{s}' is not a valid integer") from None

# The EAFP vs LBYL philosophies
# LBYL — Look Before You Leap (C style):
if "key" in my_dict:
    value = my_dict["key"]

# EAFP — Easier to Ask Forgiveness than Permission (Pythonic):
try:
    value = my_dict["key"]
except KeyError:
    value = None

# warnings module
import warnings
def old_function():
    warnings.warn("Use new_function() instead", DeprecationWarning)
    return 42

# Context manager for temporary error suppression
from contextlib import suppress
with suppress(FileNotFoundError):
    open("nonexistent.txt")
# No crash — exception silently suppressed

📝 KEY POINTS:
✅ Catch SPECIFIC exceptions — not bare except: or except Exception:
✅ else: runs only when no exception occurred in try:
✅ finally: ALWAYS runs — perfect for cleanup (close files, DBs)
✅ Use "with" statement — it auto-handles cleanup via __exit__
✅ Custom exceptions should inherit from Exception
✅ Python favors EAFP (try/except) over LBYL (if checks)
✅ raise without argument re-raises the current exception
❌ Never use bare "except:" — it catches SystemExit and KeyboardInterrupt too
❌ Don't use exceptions for normal flow control — only for errors
❌ Don't silently swallow exceptions: "except: pass" hides bugs
""",
  quiz: [
    Quiz(question: 'When does the "else" block in try/except/else/finally run?', options: [
      QuizOption(text: 'When an exception WAS raised and caught', correct: false),
      QuizOption(text: 'Only when no exception occurred in the try block', correct: true),
      QuizOption(text: 'Always, like finally', correct: false),
      QuizOption(text: 'When the finally block completes successfully', correct: false),
    ]),
    Quiz(question: 'What does "raise" (with no argument) do inside an except block?', options: [
      QuizOption(text: 'Raises a new generic Exception', correct: false),
      QuizOption(text: 'Re-raises the currently handled exception', correct: true),
      QuizOption(text: 'Cancels the exception handling', correct: false),
      QuizOption(text: 'Raises a RuntimeError', correct: false),
    ]),
    Quiz(question: 'What is the EAFP Python programming style?', options: [
      QuizOption(text: 'Always check conditions before accessing data (if key in dict)', correct: false),
      QuizOption(text: 'Try the operation and catch exceptions if they occur', correct: true),
      QuizOption(text: 'Use assertions everywhere for safety', correct: false),
      QuizOption(text: 'Avoid exceptions entirely by validating all inputs', correct: false),
    ]),
  ],
);
