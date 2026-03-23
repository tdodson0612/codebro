import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson17 = Lesson(
  language: 'Python',
  title: 'List, Dict, Set & Generator Comprehensions',
  content: """
🎯 METAPHOR:
A comprehension is like a factory assembly line with a
built-in quality inspector.
Raw materials (the iterable) flow in on a conveyor belt.
The inspector (if condition) checks each item and tosses
rejects. Passing items go through the transformer (expression)
and come out as finished products in a shiny new collection.
One concise description handles intake, filtering, AND
transformation — no separate loops required.

📖 EXPLANATION:
Comprehensions are Python's elegant, readable way to build
collections. They replace verbose for loops in many cases.

─────────────────────────────────────
📋 LIST COMPREHENSION
─────────────────────────────────────
[expression for item in iterable if condition]

The if condition is optional.
Reads almost like English:
  "Give me x squared, for each x in range(10),
   if x is even."
  [x**2 for x in range(10) if x % 2 == 0]

─────────────────────────────────────
📖 DICT COMPREHENSION
─────────────────────────────────────
{key_expr: value_expr for item in iterable if condition}

─────────────────────────────────────
🔵 SET COMPREHENSION
─────────────────────────────────────
{expression for item in iterable if condition}

Same as list but with {} → automatic deduplication.

─────────────────────────────────────
⚡ GENERATOR EXPRESSION
─────────────────────────────────────
(expression for item in iterable if condition)

Like a list comprehension but LAZY — computes values
one at a time on demand. No [] brackets — uses ().
Saves memory for large datasets.
Use when you only need to iterate once.

─────────────────────────────────────
🪆 NESTED COMPREHENSIONS
─────────────────────────────────────
[[expression for col in row] for row in matrix]

Reads inside-out:
  "For each row in matrix, for each col in row..."

─────────────────────────────────────
⚖️  WHEN TO USE COMPREHENSION vs LOOP
─────────────────────────────────────
✅ Use comprehension: simple transformation/filter
✅ Use for loop: complex logic, multiple operations,
   side effects (printing, writing to db), > 2 levels deep

💻 CODE:
# List comprehension basics
squares = [x**2 for x in range(1, 6)]
print(squares)   # [1, 4, 9, 16, 25]

# With filter
evens = [x for x in range(20) if x % 2 == 0]
print(evens)   # [0, 2, 4, 6, 8, 10, 12, 14, 16, 18]

# Transform strings
words = ["hello", "world", "python"]
upper = [w.upper() for w in words]
lengths = [len(w) for w in words]
print(upper)    # ['HELLO', 'WORLD', 'PYTHON']
print(lengths)  # [5, 5, 6]

# Filter + transform
names = ["Alice", "Bob", "Carol", "Dave", "Eve"]
long_upper = [n.upper() for n in names if len(n) > 3]
print(long_upper)  # ['ALICE', 'CAROL', 'DAVE']

# Nested list comprehension — flatten 2D matrix
matrix = [[1,2,3],[4,5,6],[7,8,9]]
flat = [x for row in matrix for x in row]
print(flat)   # [1, 2, 3, 4, 5, 6, 7, 8, 9]

# Build 2D matrix
grid = [[i*j for j in range(1,4)] for i in range(1,4)]
for row in grid:
    print(row)
# [1, 2, 3]
# [2, 4, 6]
# [3, 6, 9]

# Dict comprehension
squares_dict = {x: x**2 for x in range(1, 6)}
print(squares_dict)  # {1:1, 2:4, 3:9, 4:16, 5:25}

# Invert a dictionary
original = {"a": 1, "b": 2, "c": 3}
inverted = {v: k for k, v in original.items()}
print(inverted)  # {1:'a', 2:'b', 3:'c'}

# Filter dict — keep high scores
scores = {"Alice": 92, "Bob": 61, "Carol": 88, "Dave": 55}
passing = {k: v for k, v in scores.items() if v >= 70}
print(passing)   # {'Alice': 92, 'Carol': 88}

# Set comprehension — unique lengths
words = ["cat", "dog", "bird", "fish", "elephant"]
unique_lengths = {len(w) for w in words}
print(unique_lengths)   # {3, 4, 8} — unordered, unique

# Generator expression — lazy, memory-efficient
gen = (x**2 for x in range(1_000_000))
print(next(gen))   # 0  (computed on demand)
print(next(gen))   # 1
print(next(gen))   # 4

# Generator in sum — never builds full list in memory
total = sum(x**2 for x in range(1_000_000))
print(total)   # 333332833333500000

# any() / all() with generator (stops early!)
numbers = range(1, 1000000)
has_even = any(x % 2 == 0 for x in numbers)  # stops at first even!
all_pos  = all(x > 0 for x in numbers)
print(has_even)  # True
print(all_pos)   # True

# Conditional expression in comprehension
labels = ["even" if x % 2 == 0 else "odd" for x in range(8)]
print(labels)  # ['even', 'odd', 'even', 'odd', ...]

# Comprehension vs loop — readability comparison
# Loop version:
result = []
for x in range(10):
    if x % 2 == 0:
        result.append(x**2)

# Comprehension version (better):
result = [x**2 for x in range(10) if x % 2 == 0]

# Zip in comprehension
names = ["Alice", "Bob", "Carol"]
grades = [92, 85, 96]
report = {name: grade for name, grade in zip(names, grades)}
print(report)   # {'Alice': 92, 'Bob': 85, 'Carol': 96}

# Flatten with condition
nested = [[1,-2,3],[-4,5,-6],[7,8,-9]]
positives = [x for row in nested for x in row if x > 0]
print(positives)  # [1, 3, 5, 7, 8]

📝 KEY POINTS:
✅ [expr for x in iter if cond] — list comprehension
✅ {k:v for x in iter} — dict comprehension
✅ {expr for x in iter} — set comprehension
✅ (expr for x in iter) — generator (lazy, memory efficient)
✅ Nested comprehensions: inner loop comes FIRST in the expression
✅ Use generator expressions for large data — avoids building full list
✅ any()/all() with generators short-circuit for performance
❌ Don't use comprehensions with side effects (printing, writing)
❌ Deep nesting > 2 levels — switch to explicit for loops
❌ Forget: if/else BEFORE for is ternary, if AFTER for is filter
""",
  quiz: [
    Quiz(question: 'What is the difference between [x for x in r] and (x for x in r)?', options: [
      QuizOption(text: 'No difference — both produce a list', correct: false),
      QuizOption(text: 'The first builds a list in memory; the second is a lazy generator', correct: true),
      QuizOption(text: 'The second uses parentheses so it creates a tuple', correct: false),
      QuizOption(text: 'The first is faster; the second saves syntax', correct: false),
    ]),
    Quiz(question: 'What does [x if x>0 else 0 for x in nums] do?', options: [
      QuizOption(text: 'Filters out non-positive numbers', correct: false),
      QuizOption(text: 'Replaces negative numbers with 0, keeps positives as-is', correct: true),
      QuizOption(text: 'SyntaxError — if/else not allowed in comprehensions', correct: false),
      QuizOption(text: 'Keeps only the positive numbers unchanged', correct: false),
    ]),
    Quiz(question: 'How do you flatten [[1,2],[3,4],[5,6]] with a comprehension?', options: [
      QuizOption(text: '[x for x in row for row in matrix]', correct: false),
      QuizOption(text: '[x for row in matrix for x in row]', correct: true),
      QuizOption(text: 'flatten([x for x in matrix])', correct: false),
      QuizOption(text: '[matrix[i][j] for i, j in matrix]', correct: false),
    ]),
  ],
);
