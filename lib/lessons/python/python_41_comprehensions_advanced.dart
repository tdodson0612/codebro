import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson41 = Lesson(
  language: 'Python',
  title: 'Advanced Comprehensions & Functional Tools',
  content: """
🎯 METAPHOR:
Advanced comprehensions are like SQL queries for Python data.
WHERE = the if condition, SELECT = the expression,
FROM = the iterable, JOIN = nested comprehension.
Just as SQL lets you express "get all active users with
score > 90, return their names in uppercase" in one statement,
comprehensions let you say the same thing about Python
collections in one elegant line. The more you internalize
this pattern, the faster you think in data transformations.

📖 EXPLANATION:
Building on the basics, this lesson covers advanced patterns:
walrus operator in comprehensions, nested structures,
conditional transformations, and combining with map/filter/zip.

─────────────────────────────────────
🎯 COMPREHENSION PATTERNS
─────────────────────────────────────
# Basic transform
[expr for x in iter]

# With filter
[expr for x in iter if cond]

# With ternary (transform-based)
[a if cond else b for x in iter]

# Nested (flatten)
[expr for row in matrix for x in row]

# Nested with filter
[x for row in matrix for x in row if x > 0]

# Walrus := in comprehension
[y := f(x), y**2]  → complex multi-use

─────────────────────────────────────
🔀 MAP vs COMPREHENSION
─────────────────────────────────────
Both transform — comprehension is more Pythonic.

map(lambda x: x*2, lst) ≡ [x*2 for x in lst]
filter(lambda x: x>0, lst) ≡ [x for x in lst if x>0]

When to use map/filter:
  • Passing to another function expecting an iterable
  • Avoiding creating a full list (they're lazy)

─────────────────────────────────────
⚡ GENERATOR vs LIST COMPREHENSION
─────────────────────────────────────
List:       [x*2 for x in range(10**6)]  → 8MB
Generator:  (x*2 for x in range(10**6))  → 200 bytes

Use generator when:
  • Iterating once
  • Passing to sum(), any(), all(), max(), min()
  • Data too large to hold in memory

─────────────────────────────────────
🧮 ADVANCED DICT COMPREHENSIONS
─────────────────────────────────────
# Group by key
{k: [v for k2,v in pairs if k2==k] for k in keys}

# Better with defaultdict:
from collections import defaultdict
groups = defaultdict(list)
for k, v in pairs:
    groups[k].append(v)

💻 CODE:
# ── ADVANCED LIST COMPREHENSIONS ───

# Nested flattening with condition
matrix = [[1,-2,3],[-4,5,-6],[7,-8,9]]
positives = [x for row in matrix for x in row if x > 0]
print(positives)   # [1, 3, 5, 7, 9]

# Transpose a matrix
matrix = [[1,2,3],[4,5,6],[7,8,9]]
transposed = [[row[i] for row in matrix] for i in range(3)]
print(transposed)   # [[1,4,7],[2,5,8],[3,6,9]]
# Or more elegantly:
transposed2 = list(map(list, zip(*matrix)))

# Walrus operator in comprehension (Python 3.8+)
# Process expensive computation once, use result multiple times
data = range(20)
results = [square for x in data if (square := x**2) > 100]
print(results[:5])   # [121, 144, 169, 196, 225, ...]

# Conditional transformation
numbers = [-3, -2, -1, 0, 1, 2, 3]
classified = [
    "positive" if x > 0 else "negative" if x < 0 else "zero"
    for x in numbers
]
print(classified)

# Multiple conditions
students = [
    {"name": "Alice", "score": 92, "active": True},
    {"name": "Bob",   "score": 65, "active": False},
    {"name": "Carol", "score": 88, "active": True},
    {"name": "Dave",  "score": 45, "active": True},
]
honor_roll = [
    s["name"].upper()
    for s in students
    if s["active"] and s["score"] >= 85
]
print(honor_roll)   # ['ALICE', 'CAROL']

# Flattening irregular nested structures
irregular = [[1,2,3], [4,5], [6,7,8,9], [10]]
flat = [x for sublist in irregular for x in sublist]
print(flat)   # [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

# ── DICT COMPREHENSIONS ────────────

# Invert: value → key
prices = {"apple": 1.0, "banana": 0.5, "cherry": 2.0}
inverted = {v: k for k, v in prices.items()}
print(inverted)   # {1.0: 'apple', 0.5: 'banana', 2.0: 'cherry'}

# Filter and transform
expensive = {k: v for k, v in prices.items() if v >= 1.0}
print(expensive)  # {'apple': 1.0, 'cherry': 2.0}

# Build lookup table
words = ["apple", "banana", "cherry", "apricot", "blueberry"]
by_first_letter = {
    letter: [w for w in words if w.startswith(letter)]
    for letter in set(w[0] for w in words)
}
print(by_first_letter)

# Merging with dict comprehension
users = {"alice": {"role": "admin"}, "bob": {"role": "user"}}
upgraded = {
    k: {**v, "premium": True}
    for k, v in users.items()
}
print(upgraded)  # adds premium=True to each user dict

# ── SET COMPREHENSIONS ─────────────

words = "the quick brown fox jumps over the lazy dog".split()
lengths = {len(w) for w in words}
print(sorted(lengths))  # unique word lengths

first_letters = {w[0] for w in words}
print(sorted(first_letters))  # unique first letters

# ── GENERATOR EXPRESSIONS ──────────

# Memory-efficient pipeline
import os
from pathlib import Path

# Sum of all file sizes without loading everything
# (generator pipeline — nothing stored in memory)
p = Path(".")
total_size = sum(
    f.stat().st_size
    for f in p.rglob("*.py")
    if f.is_file()
)
print(f"Total .py size: {total_size} bytes")

# all() / any() with generators — short-circuit!
data = range(1, 100)
print(any(x > 50 for x in data))   # True — stops at 51
print(all(x > 0 for x in data))    # True — checks all
print(all(x % 2 == 0 for x in data))  # False — stops at 1

# Chained generators (lazy pipeline)
def numbers():
    yield from range(1, 1000001)

# These compute nothing until sum() pulls values
evens     = (x for x in numbers() if x % 2 == 0)
squares   = (x**2 for x in evens)
filtered  = (x for x in squares if x % 3 == 0)
result    = sum(filtered)   # processes one at a time!
print(result)

# ── FUNCTIONAL TOOLS ───────────────

from functools import reduce

# map + reduce (functional style)
nums = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

# Functional:
total = reduce(lambda a, b: a + b, map(lambda x: x**2, filter(lambda x: x % 2 == 0, nums)))
# Comprehension (cleaner):
total = sum(x**2 for x in nums if x % 2 == 0)
print(total)   # 220

# zip with comprehension
names   = ["Alice", "Bob", "Carol"]
scores  = [92, 85, 96]
reports = {n: s for n, s in zip(names, scores)}
print(reports)

# enumerate in comprehension
indexed = {i: v.upper() for i, v in enumerate(names)}
print(indexed)   # {0: 'ALICE', 1: 'BOB', 2: 'CAROL'}

# Nested dict comprehension
def multiplication_table(n):
    return {i: {j: i*j for j in range(1, n+1)} for i in range(1, n+1)}

table = multiplication_table(5)
for i in range(1, 6):
    row = " ".join(f"{table[i][j]:3d}" for j in range(1, 6))
    print(row)

# Handling exceptions in comprehensions — tricky!
def safe_int(s):
    try:
        return int(s)
    except ValueError:
        return None

raw = ["1", "2", "bad", "4", "oops", "6"]
nums = [n for s in raw if (n := safe_int(s)) is not None]
print(nums)   # [1, 2, 4, 6]

📝 KEY POINTS:
✅ Nested comprehensions: inner for comes AFTER outer for in the expression
✅ Walrus := in comprehensions lets you compute once and use the result in condition + expression
✅ Generator expressions with sum/any/all are always better than list comprehensions
✅ Dict comprehensions handle transformation + filtering in one pass
✅ For exception handling in comprehensions, use a helper function
✅ Prefer comprehensions over map+filter+lambda — more readable
❌ Don't nest more than 2 levels — extract into a function
❌ Avoid side effects in comprehensions (print, file write, etc.)
❌ Don't use a comprehension just to execute side effects — use a for loop
""",
  quiz: [
    Quiz(question: 'What does [x for row in matrix for x in row] do?', options: [
      QuizOption(text: 'Creates a 2D nested list', correct: false),
      QuizOption(text: 'Flattens a 2D matrix into a 1D list', correct: true),
      QuizOption(text: 'Transposes the matrix', correct: false),
      QuizOption(text: 'SyntaxError — two for clauses are not allowed', correct: false),
    ]),
    Quiz(question: 'When should you use a generator expression instead of a list comprehension?', options: [
      QuizOption(text: 'When you need to index into the results', correct: false),
      QuizOption(text: 'When passing to sum(), any(), all(), or only iterating once — saves memory', correct: true),
      QuizOption(text: 'Generator expressions are always faster', correct: false),
      QuizOption(text: 'When the iterable has more than 100 items', correct: false),
    ]),
    Quiz(question: 'What is [a if cond else b for x in items] vs [a for x in items if cond]?', options: [
      QuizOption(text: 'They are identical', correct: false),
      QuizOption(text: 'First transforms every item (a or b); second keeps only items where cond is True', correct: true),
      QuizOption(text: 'First is a filter; second is a transform', correct: false),
      QuizOption(text: 'The first raises SyntaxError', correct: false),
    ]),
  ],
);
