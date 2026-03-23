import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson63 = Lesson(
  language: 'Python',
  title: 'Unpacking & Starred Expressions',
  content: """
🎯 METAPHOR:
Unpacking is like unboxing a delivery package.
You don't use the entire box as a single object —
you pull each item out and give it its own place.
The basic unpack gives each item a named shelf:
  x, y, z = [1, 2, 3]
The starred unpack is like "give me the first item,
the last item, and put everything in between in
this one big bin": first, *middle, last = items.
Python handles all the counting and slicing — you
just name where things go.

📖 EXPLANATION:
Unpacking assigns the elements of any iterable to
individual variable names in a single statement.
Starred (*) expressions absorb any remaining elements.

─────────────────────────────────────
📐 BASIC UNPACKING
─────────────────────────────────────
a, b, c = [1, 2, 3]     # exact count required
x, y    = (10, 20)       # works with any iterable
first, second = "Hi"     # strings too!

Rule: left side variable count MUST match iterable length
      (unless using starred expressions)

─────────────────────────────────────
⭐ STARRED EXPRESSIONS (Python 3+)
─────────────────────────────────────
first, *rest = [1, 2, 3, 4, 5]
*head, last  = [1, 2, 3, 4, 5]
first, *mid, last = [1, 2, 3, 4, 5]

The starred variable always gets a LIST (even if empty).
Only ONE starred variable per unpacking.

─────────────────────────────────────
🔄 SWAP WITHOUT TEMP VARIABLE
─────────────────────────────────────
a, b = b, a   # Python's elegant swap
# Internally: right side evaluated as tuple first, then assigned

─────────────────────────────────────
🔁 UNPACKING IN LOOPS
─────────────────────────────────────
for x, y in [(1,2), (3,4)]: ...
for i, val in enumerate(items): ...
for k, v in d.items(): ...

─────────────────────────────────────
🪺 NESTED UNPACKING
─────────────────────────────────────
(a, b), c = (1, 2), 3
(x, (y, z)) = (1, (2, 3))

─────────────────────────────────────
📦 UNPACKING IN FUNCTION CALLS
─────────────────────────────────────
*iterable → spreads into positional args
**dict    → spreads into keyword args
These were covered in args/kwargs lesson — here
we focus on the assignment-side unpacking.

💻 CODE:
# ── BASIC UNPACKING ───────────────

# Tuple unpacking (no parentheses needed)
x, y, z = 1, 2, 3
print(x, y, z)      # 1 2 3

# List unpacking
a, b, c = [10, 20, 30]
print(a, b, c)

# String unpacking (each character)
first, second, third = "abc"
print(first, second, third)   # a b c

# Swap without temp variable
a, b = 10, 20
a, b = b, a
print(a, b)   # 20 10

# Return multiple values from function
def min_max(nums):
    return min(nums), max(nums)   # returns tuple

low, high = min_max([3, 1, 4, 1, 5, 9])
print(f"min={low}, max={high}")

# Discard unwanted values with _
first, _, last = (1, 2, 3)
print(first, last)   # 1 3

# Multiple discards
a, _, _, _, e = range(5)
print(a, e)   # 0 4

# ── STARRED EXPRESSIONS ────────────

# Capture "the rest" as a list
first, *rest = [1, 2, 3, 4, 5]
print(first)   # 1
print(rest)    # [2, 3, 4, 5]  ← always a list

# Last element
*head, last = [1, 2, 3, 4, 5]
print(head)   # [1, 2, 3, 4]
print(last)   # 5

# First, middle, last
first, *middle, last = [1, 2, 3, 4, 5]
print(first, middle, last)   # 1 [2, 3, 4] 5

# Starred gets empty list when no extras
a, *b = [1]
print(a, b)   # 1 []

a, *b, c = [1, 2]
print(a, b, c)   # 1 [] 2

# Practical: split header from data
lines = ["Name,Age,City", "Alice,30,NYC", "Bob,25,LA"]
header, *rows = lines
print(f"Header: {header}")
print(f"Rows: {rows}")

# Practical: first and last line
first_line, *_, last_line = lines
print(first_line, "→", last_line)

# ── UNPACKING IN FOR LOOPS ─────────

# Unpack pairs
pairs = [(1, "one"), (2, "two"), (3, "three")]
for num, word in pairs:
    print(f"{num} = {word}")

# enumerate
fruits = ["apple", "banana", "cherry"]
for i, fruit in enumerate(fruits):
    print(f"{i}: {fruit}")

# dict items
scores = {"Alice": 92, "Bob": 78, "Carol": 95}
for name, score in scores.items():
    print(f"{name}: {score}")

# zip — parallel iteration with unpacking
names = ["Alice", "Bob", "Carol"]
ages  = [30, 25, 35]
for name, age in zip(names, ages):
    print(f"{name} is {age}")

# zip with unpack of longer tuples
data = [("Alice", 30, "NYC"), ("Bob", 25, "LA"), ("Carol", 35, "SF")]
for name, age, city in data:
    print(f"{name} ({age}) lives in {city}")

# Starred in for loops
for first, *rest in [(1,2,3,4), (5,6), (7,8,9,10,11)]:
    print(f"first={first}, rest={rest}")

# ── NESTED UNPACKING ───────────────

# Unpack nested structures
matrix_row = ((1, 2), (3, 4))
(a, b), (c, d) = matrix_row
print(a, b, c, d)   # 1 2 3 4

# Nested in for loop
points = [(1, (2, 3)), (4, (5, 6))]
for x, (y, z) in points:
    print(f"x={x}, y={y}, z={z}")

# ── PRACTICAL PATTERNS ─────────────

# Destructure a dict's values
config = {"host": "localhost", "port": 5432, "db": "mydb"}
host, port, db = config["host"], config["port"], config["db"]
# Or with dict unpacking:
host = config["host"]; port = config["port"]  # simpler for a few keys

# CSV-like parsing
record = "Alice,30,NYC,Engineer"
name, age, city, role = record.split(",")
print(name, int(age), city, role)

# Parse with starred
csv_line = "2024-03-15,INFO,Server started,host=localhost,port=8080"
date, level, message, *extras = csv_line.split(",")
print(f"[{date}] {level}: {message}")
print(f"Extra fields: {extras}")

# Fibonacci step using unpacking swap
def fib_sequence(n):
    a, b = 0, 1
    for _ in range(n):
        yield a
        a, b = b, a + b   # simultaneous assignment!

print(list(fib_sequence(10)))

# Rotating a list with star unpack
def rotate_left(lst, n=1):
    return [*lst[n:], *lst[:n]]

print(rotate_left([1,2,3,4,5], 2))   # [3, 4, 5, 1, 2]

# Flatten one level with star
nested = [[1,2], [3,4], [5,6]]
flat = [*nested[0], *nested[1], *nested[2]]
print(flat)   # [1, 2, 3, 4, 5, 6]

# Better with chain:
from itertools import chain
flat = list(chain(*nested))
print(flat)

# Building lists/tuples with star
a = [1, 2, 3]
b = [4, 5, 6]
combined = [*a, 99, *b]        # [1, 2, 3, 99, 4, 5, 6]
combined_tuple = (*a, *b)      # (1, 2, 3, 4, 5, 6)
combined_set = {*a, *b}        # {1, 2, 3, 4, 5, 6}
print(combined)
print(combined_tuple)
print(combined_set)

# Copying with star (shallow copy)
original = [1, 2, 3]
copy = [*original]
copy.append(99)
print(original)   # [1, 2, 3] — unchanged
print(copy)       # [1, 2, 3, 99]

📝 KEY POINTS:
✅ Unpacking works with ANY iterable (list, tuple, string, range, generator)
✅ Starred (*var) always captures a list — even if zero or one element
✅ Only ONE starred variable per unpacking statement
✅ a, b = b, a — Python's elegant no-temp swap
✅ for x, y in pairs: — unpack directly in loop header
✅ *list in literal: [*a, *b] builds a new merged list
✅ _ is convention for "don't care" values you're discarding
❌ Can't have two starred variables: a, *b, *c = ... → SyntaxError
❌ Exact count mismatch without star → ValueError: not enough/too many values
❌ Nested unpacking gets hard to read past 2 levels — extract to variables
""",
  quiz: [
    Quiz(question: 'What does first, *rest = [1, 2, 3, 4] produce?', options: [
      QuizOption(text: 'first=1, rest=(2, 3, 4)', correct: false),
      QuizOption(text: 'first=1, rest=[2, 3, 4]', correct: true),
      QuizOption(text: 'first=[1], rest=[2, 3, 4]', correct: false),
      QuizOption(text: 'A SyntaxError — starred unpacking not allowed', correct: false),
    ]),
    Quiz(question: 'What type does the starred variable always receive?', options: [
      QuizOption(text: 'A tuple', correct: false),
      QuizOption(text: 'A list', correct: true),
      QuizOption(text: 'The same type as the original iterable', correct: false),
      QuizOption(text: 'A generator', correct: false),
    ]),
    Quiz(question: 'What does [*a, *b] do when a=[1,2] and b=[3,4]?', options: [
      QuizOption(text: 'Creates a list of two lists: [[1,2],[3,4]]', correct: false),
      QuizOption(text: 'Creates a new merged list: [1, 2, 3, 4]', correct: true),
      QuizOption(text: 'SyntaxError — two starred expressions in a literal', correct: false),
      QuizOption(text: 'Concatenates to the string "1234"', correct: false),
    ]),
  ],
);
