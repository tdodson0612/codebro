import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson45 = Lesson(
  language: 'Python',
  title: 'Python Best Practices & Pythonic Code',
  content: """
🎯 METAPHOR:
"Pythonic" code is like a native speaker vs a translator.
A tourist in France might say "I desire to buy one bread."
A Parisian says "Une baguette, s'il vous plaît."
Both communicate, but one FITS the language naturally —
it's idiomatic, concise, and locals immediately understand it.
Pythonic code is the same: you're not just translating logic
from C++ or Java into Python syntax — you're thinking in Python,
using its idioms, its patterns, its culture. The Zen of Python
is the grammar guide. PEP 8 is the style guide.
Learn them and your code will feel native.

📖 EXPLANATION:
Pythonic code follows Python's conventions and idioms.
It's readable, concise, and uses Python's strengths.
This lesson covers PEP 8, idioms, anti-patterns, and
tools for writing and maintaining clean Python code.

─────────────────────────────────────
📏 PEP 8 — THE STYLE GUIDE
─────────────────────────────────────
Indentation:      4 spaces (NEVER tabs)
Line length:      79 chars (code), 72 (docstrings)
Blank lines:      2 between top-level, 1 between methods
Imports:          stdlib → third-party → local, one per line
Names:            snake_case for vars/funcs, PascalCase for classes
                  UPPER_SNAKE_CASE for constants
                  _single_leading for "internal"
                  __double for name mangling
Whitespace:       no space before colon/comma/paren
                  spaces around operators (but not in kwargs)
Comparisons:      is/is not for None, singletons
                  == for values, not type(x) == int → isinstance

─────────────────────────────────────
🎯 PYTHONIC IDIOMS
─────────────────────────────────────
✅ Use truthiness: if lst  not  if len(lst) > 0
✅ Swap: a, b = b, a
✅ Unpack: first, *rest = items
✅ Ternary: x if cond else y
✅ Comprehensions over map/filter
✅ enumerate() over range(len())
✅ zip() for parallel iteration
✅ with for resource management
✅ f-strings for formatting (3.6+)
✅ Use walrus := when it clarifies
✅ Return early (guard clauses)

─────────────────────────────────────
❌ ANTI-PATTERNS
─────────────────────────────────────
❌ Mutable default arguments
❌ Catching bare except:
❌ type(x) == int instead of isinstance(x, int)
❌ Using == to compare with None
❌ Building strings with + in a loop
❌ import * from modules
❌ Global state (hard to test)
❌ Deep nesting (> 3 levels)
❌ Hungarian notation (strName, intAge)

─────────────────────────────────────
🔧 CODE QUALITY TOOLS
─────────────────────────────────────
black    → auto-formatter (pip install black)
ruff     → ultra-fast linter + formatter
flake8   → style checker
pylint   → deep code analysis
mypy     → static type checker
isort    → import sorter
bandit   → security vulnerability scanner
pre-commit → run tools automatically before commits

💻 CODE:
# ── PYTHONIC vs NON-PYTHONIC ────────

# ❌ Non-Pythonic: check length
my_list = [1, 2, 3]
if len(my_list) > 0:
    print("has items")

# ✅ Pythonic: use truthiness
if my_list:
    print("has items")

# ❌ Non-Pythonic: index-based loop
names = ["Alice", "Bob", "Carol"]
for i in range(len(names)):
    print(f"{i}: {names[i]}")

# ✅ Pythonic: enumerate
for i, name in enumerate(names):
    print(f"{i}: {name}")

# ❌ Non-Pythonic: manual swap
temp = a
a = b
b = temp

# ✅ Pythonic: tuple swap
a, b = b, a

# ❌ Non-Pythonic: string building
result = ""
for word in words:
    result += word + " "

# ✅ Pythonic: join
result = " ".join(words)

# ❌ Non-Pythonic: isinstance check
if type(x) == int:
    ...
# ✅ Pythonic: isinstance (handles subclasses too)
if isinstance(x, int):
    ...

# ❌ Non-Pythonic: None comparison
if x == None:
    ...
# ✅ Pythonic: is None
if x is None:
    ...

# ❌ Non-Pythonic: nested returns
def process(data):
    if data is not None:
        if len(data) > 0:
            if data[0] > 0:
                return data[0] * 2
    return None

# ✅ Pythonic: guard clauses
def process(data):
    if data is None or len(data) == 0:
        return None
    if data[0] <= 0:
        return None
    return data[0] * 2

# ❌ Non-Pythonic: manual key existence
if "key" in d.keys():
    ...
# ✅ Pythonic: direct check
if "key" in d:
    ...

# ❌ Non-Pythonic: catch-all exception
try:
    result = risky()
except:   # catches EVERYTHING including Ctrl+C!
    pass

# ✅ Pythonic: specific exception
try:
    result = risky()
except ValueError as e:
    handle(e)
except (TypeError, KeyError):
    ...

# ── CONTEXT MANAGERS ───────────────

# ❌ Non-Pythonic: manual file handling
f = open("file.txt")
try:
    data = f.read()
finally:
    f.close()

# ✅ Pythonic: with statement
with open("file.txt") as f:
    data = f.read()

# ── COMPREHENSIONS ─────────────────

# ❌ Non-Pythonic: building list with loop
squares = []
for x in range(10):
    if x % 2 == 0:
        squares.append(x**2)

# ✅ Pythonic: list comprehension
squares = [x**2 for x in range(10) if x % 2 == 0]

# ── NAMING CONVENTIONS ─────────────

# PEP 8 names:
MAX_RETRIES = 3           # UPPER_SNAKE_CASE = constant
class UserAccount: pass   # PascalCase = class
def calculate_total(): pass  # snake_case = function
_internal_var = True      # _prefix = internal
__mangled = True          # __prefix = name-mangled

# ── DOCSTRINGS ─────────────────────

def calculate_discount(price: float, rate: float) -> float:
    """
    Calculate the discounted price.

    Args:
        price: Original price in dollars.
        rate: Discount rate as a decimal (0.0 to 1.0).

    Returns:
        The discounted price.

    Raises:
        ValueError: If price is negative or rate is out of range.

    Example:
        >>> calculate_discount(100.0, 0.2)
        80.0
    """
    if price < 0:
        raise ValueError(f"Price cannot be negative: {price}")
    if not 0.0 <= rate <= 1.0:
        raise ValueError(f"Rate must be 0.0-1.0, got: {rate}")
    return price * (1 - rate)

# ── STRUCTURED PATTERNS ────────────

# Configuration object instead of many args
from dataclasses import dataclass, field

@dataclass
class DatabaseConfig:
    host: str = "localhost"
    port: int = 5432
    name: str = "mydb"
    pool_size: int = 10
    timeout: float = 30.0

# Result type instead of exception-or-value
@dataclass
class Result:
    success: bool
    value: object = None
    error: str = ""

    @classmethod
    def ok(cls, value): return cls(True, value)
    @classmethod
    def fail(cls, error): return cls(False, error=error)

def safe_divide(a, b) -> Result:
    if b == 0:
        return Result.fail("Division by zero")
    return Result.ok(a / b)

r = safe_divide(10, 2)
if r.success:
    print(f"Result: {r.value}")

r = safe_divide(10, 0)
if not r.success:
    print(f"Error: {r.error}")

# ── TOOLS CONFIGURATION ────────────
PYPROJECT_TOOLS = """
[tool.black]
line-length = 88
target-version = ['py311']

[tool.ruff]
line-length = 88
select = ["E", "F", "I", "N", "W", "UP"]
ignore = ["E501"]

[tool.mypy]
python_version = "3.11"
strict = true
ignore_missing_imports = true

[tool.pytest.ini_options]
testpaths = ["tests"]
addopts = "-v --tb=short --cov=src"
"""

# ── PERFORMANCE PROFILING ──────────
import timeit
import cProfile

# timeit for microbenchmarks
setup = "data = list(range(10000))"
stmt1 = "[x*2 for x in data]"
stmt2 = "list(map(lambda x: x*2, data))"
t1 = timeit.timeit(stmt1, setup=setup, number=1000)
t2 = timeit.timeit(stmt2, setup=setup, number=1000)
print(f"Comprehension: {t1:.3f}s")
print(f"map+lambda:    {t2:.3f}s")

# cProfile for function-level profiling
def slow_function():
    result = 0
    for i in range(100000):
        result += i ** 2
    return result

# Run with: python -m cProfile -s cumulative myscript.py
# Or in code:
cProfile.run("slow_function()")

📝 KEY POINTS:
✅ Read and internalize PEP 8 — it's the universal Python style guide
✅ Use truthiness checks, enumerate, zip, comprehensions — they're Pythonic
✅ Guard clauses (early returns) are cleaner than deep nesting
✅ f-strings are the modern standard for string formatting
✅ Use black for auto-formatting — removes all style debates
✅ Run mypy for type checking — catches bugs before runtime
✅ Profile BEFORE optimizing — don't guess where it's slow
❌ Writing Python like it's Java or C++ — learn the Python way
❌ Mutable default args, bare except:, == None — classic anti-patterns
❌ Premature optimization — write clean readable code first
""",
  quiz: [
    Quiz(question: 'What is the Pythonic way to check if a list is not empty?', options: [
      QuizOption(text: 'if len(my_list) > 0:', correct: false),
      QuizOption(text: 'if my_list != []:', correct: false),
      QuizOption(text: 'if my_list:', correct: true),
      QuizOption(text: 'if my_list.length > 0:', correct: false),
    ]),
    Quiz(question: 'What is the correct way to compare a value with None?', options: [
      QuizOption(text: 'if x == None:', correct: false),
      QuizOption(text: 'if x is None:', correct: true),
      QuizOption(text: 'if x === None:', correct: false),
      QuizOption(text: 'if not x:', correct: false),
    ]),
    Quiz(question: 'What naming convention does PEP 8 specify for class names?', options: [
      QuizOption(text: 'snake_case like my_class', correct: false),
      QuizOption(text: 'UPPER_SNAKE_CASE like MY_CLASS', correct: false),
      QuizOption(text: 'PascalCase like MyClass', correct: true),
      QuizOption(text: 'camelCase like myClass', correct: false),
    ]),
  ],
);
