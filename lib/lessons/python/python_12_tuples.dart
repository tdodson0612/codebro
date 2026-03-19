import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson12 = Lesson(
  language: 'Python',
  title: 'Tuples',
  content: '''
🎯 METAPHOR:
A tuple is like a birth certificate.
Once issued, the data is PERMANENT — name, date of birth,
parents' names are locked in forever. You can read the
information, you can hand it to others, you can compare it
with another birth certificate — but you cannot change it.
Lists are like notebooks — editable. Tuples are like
certificates — sealed. Use tuples when the data represents
a fixed fact that should never change.

📖 EXPLANATION:
Tuples are ordered, immutable sequences.
They look like lists but with parentheses, and they
CANNOT be modified after creation.

─────────────────────────────────────
📐 CREATING TUPLES
─────────────────────────────────────
empty    = ()
single   = (1,)        ← MUST have comma! (1) is just 1
pair     = (1, 2)
triple   = (1, 2, 3)
no_parens = 1, 2, 3    ← parentheses optional!
nested   = ((1,2), (3,4))
from_list = tuple([1,2,3])
from_str  = tuple("hello")   # ('h','e','l','l','o')

⚠️  THE SINGLE-ITEM GOTCHA:
(1)   → This is just the number 1 (parentheses for grouping)
(1,)  → This is a tuple with one element!
1,    → Also a tuple with one element!

─────────────────────────────────────
🔒 IMMUTABILITY
─────────────────────────────────────
Once created, you CANNOT:
  • Change a value: t[0] = 5  → TypeError
  • Add items: t.append(5)   → AttributeError
  • Remove items: t.pop()    → AttributeError

You CAN:
  • Read by index: t[0], t[-1]
  • Slice: t[1:3]
  • Iterate: for x in t
  • Check membership: 5 in t
  • Concatenate: t1 + t2 (makes new tuple)
  • Repeat: t * 3

─────────────────────────────────────
🆚 TUPLE vs LIST — When to Use Which
─────────────────────────────────────
Use TUPLE when:
  • Data should not change (coordinates, RGB color)
  • Returning multiple values from a function
  • Using as dictionary keys (lists can't be dict keys!)
  • Slightly faster and uses less memory than lists
  • Signaling "this is fixed data"

Use LIST when:
  • Data needs to grow, shrink, or change
  • Order matters AND you need to modify it

─────────────────────────────────────
📦 TUPLE PACKING & UNPACKING
─────────────────────────────────────
Packing:   point = 3, 4       # creates (3, 4)
Unpacking: x, y = point       # x=3, y=4

This is how functions return multiple values:
def min_max(lst):
    return min(lst), max(lst)   # returns a tuple!
low, high = min_max([3,1,4,1,5,9])

Extended unpacking (Python 3):
first, *rest = (1, 2, 3, 4, 5)
*init, last  = (1, 2, 3, 4, 5)
first, *middle, last = (1,2,3,4,5)

─────────────────────────────────────
🔑 TUPLES AS DICTIONARY KEYS
─────────────────────────────────────
Since tuples are immutable (hashable), they can be
used as dictionary keys. Lists cannot!

locations = {}
locations[(40.7128, -74.0060)] = "New York City"
locations[(51.5074, -0.1278)]  = "London"
locations[(35.6762, 139.6503)] = "Tokyo"

─────────────────────────────────────
🏷️  NAMED TUPLES — Best of Both Worlds
─────────────────────────────────────
Regular tuple: point[0], point[1] — hard to read
Named tuple: point.x, point.y — self-documenting!

from collections import namedtuple
Point = namedtuple('Point', ['x', 'y'])
p = Point(3, 4)
print(p.x, p.y)   # 3 4
print(p[0])       # 3 (still works as tuple)

💻 CODE:
# Creating tuples
empty = ()
single = (42,)       # MUST have comma
coords = (3, 4)
rgb = (255, 128, 0)  # orange color
person = ("Alice", 30, "Engineer")

# The comma makes it a tuple, not parens!
print(type((1)))     # <class 'int'>
print(type((1,)))    # <class 'tuple'>
print(type(1,))      # <class 'tuple'>

# Indexing and slicing (same as lists)
print(coords[0])     # 3
print(coords[-1])    # 4
print(person[1:3])   # (30, 'Engineer')

# Immutability
try:
    coords[0] = 10
except TypeError as e:
    print(f"TypeError: {e}")  # can't modify!

# Tuple packing and unpacking
point = 10, 20         # packing — no parens needed
x, y = point           # unpacking
print(f"x={x}, y={y}") # x=10, y=20

# Function returning multiple values (uses tuple)
def divmod_manual(a, b):
    return a // b, a % b   # returns tuple (q, r)

quotient, remainder = divmod_manual(17, 5)
print(f"17 / 5 = {quotient} r {remainder}")

# Extended unpacking
first, *middle, last = (1, 2, 3, 4, 5)
print(first)    # 1
print(middle)   # [2, 3, 4] ← comes back as list!
print(last)     # 5

# Swap using tuple
a, b = 1, 2
a, b = b, a    # under the hood: a, b = (b, a) tuple!
print(a, b)    # 2 1

# Tuples as dict keys
grid = {}
grid[(0, 0)] = "origin"
grid[(1, 0)] = "right"
grid[(0, 1)] = "up"
print(grid[(0, 0)])  # origin

# Tuples in a list (table of records)
employees = [
    ("Alice", "Engineering", 95000),
    ("Bob", "Marketing", 72000),
    ("Carol", "Engineering", 98000),
]
for name, dept, salary in employees:
    print(f"{name} ({dept}): \${salary:,}")

# Sort list of tuples by second element
sorted_by_salary = sorted(employees, key=lambda e: e[2])
for emp in sorted_by_salary:
    print(emp)

# Named tuples
from collections import namedtuple
Point = namedtuple('Point', ['x', 'y', 'z'])
p = Point(1, 2, 3)
print(p.x, p.y, p.z)   # 1 2 3
print(p[0])              # 1 (still indexable)
print(p._asdict())       # OrderedDict

# Named tuple for structured data
Car = namedtuple('Car', ['make', 'model', 'year', 'mpg'])
tesla = Car('Tesla', 'Model 3', 2024, 140)
print(f"{tesla.year} {tesla.make} {tesla.model}: {tesla.mpg} MPGe")

# Tuple methods (only 2!)
t = (1, 2, 3, 2, 4, 2)
print(t.count(2))   # 3 (occurrences of 2)
print(t.index(3))   # 2 (index of first 3)

# Tuple vs list performance
import sys
lst = [1, 2, 3, 4, 5]
tpl = (1, 2, 3, 4, 5)
print(f"List size: {sys.getsizeof(lst)} bytes")
print(f"Tuple size: {sys.getsizeof(tpl)} bytes")  # smaller!

📝 KEY POINTS:
✅ Tuples are immutable — use when data should not change
✅ Single-item tuple REQUIRES a trailing comma: (1,) not (1)
✅ Tuples can be used as dictionary keys; lists cannot
✅ Functions "returning multiple values" actually return a tuple
✅ Named tuples give readable attribute access: point.x vs point[0]
✅ Tuples use less memory and are slightly faster than lists
✅ Tuple unpacking is Python's elegant way to swap variables
❌ (1) is NOT a tuple — it's just the integer 1 in parentheses
❌ Can't sort a tuple in place — must convert: sorted(t) returns a list
❌ Tuples can contain mutable items — immutability is shallow
''',
  quiz: [
    Quiz(question: 'How do you create a tuple with a single element?', options: [
      QuizOption(text: '(1,) — trailing comma is required', correct: true),
      QuizOption(text: '(1) — parentheses create the tuple', correct: false),
      QuizOption(text: 'tuple{1} — curly brace syntax', correct: false),
      QuizOption(text: 'single(1) — built-in function', correct: false),
    ]),
    Quiz(question: 'Why can tuples be used as dictionary keys but lists cannot?', options: [
      QuizOption(text: 'Tuples are smaller in memory', correct: false),
      QuizOption(text: 'Tuples are immutable (hashable); lists are mutable and cannot be hashed', correct: true),
      QuizOption(text: 'It is just a Python convention, not a technical requirement', correct: false),
      QuizOption(text: 'Lists use too much memory to be dictionary keys', correct: false),
    ]),
    Quiz(question: 'What type does *middle get in: first, *middle, last = (1,2,3,4,5)?', options: [
      QuizOption(text: 'tuple: (2, 3, 4)', correct: false),
      QuizOption(text: 'list: [2, 3, 4]', correct: true),
      QuizOption(text: 'generator object', correct: false),
      QuizOption(text: 'set: {2, 3, 4}', correct: false),
    ]),
  ],
);
