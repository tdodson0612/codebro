import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson85 = Lesson(
  language: 'Python',
  title: 'The operator Module & Bitwise Operations',
  content: """
🎯 METAPHOR:
The operator module is like a spare parts catalog for
Python's built-in operators. When you need to pass "addition"
as a function argument — not the result of adding, but
the operation itself — you can't pass "+". But you can
pass operator.add. It's the factory catalog where every
operator (+ - * / & | ~ <) has a named function form.
Especially useful with map(), reduce(), sorted(), and
any higher-order function that takes a function argument.

📖 EXPLANATION:
The operator module exposes Python operators as functions.
Combined with functools.reduce and sorted(), it's often
faster than lambdas and clearer about intent.
Bitwise operators work on the binary representation of ints —
essential for flags, permissions, and low-level programming.

─────────────────────────────────────
📦 OPERATOR MODULE HIGHLIGHTS
─────────────────────────────────────
operator.add(a, b)     → a + b
operator.sub(a, b)     → a - b
operator.mul(a, b)     → a * b
operator.truediv(a,b)  → a / b
operator.floordiv(a,b) → a // b
operator.mod(a, b)     → a % b
operator.pow(a, b)     → a ** b
operator.neg(a)        → -a
operator.abs(a)        → abs(a)
operator.eq(a, b)      → a == b
operator.lt(a, b)      → a < b
operator.le(a, b)      → a <= b
operator.and_(a, b)    → a & b  (and_ avoids keyword conflict)
operator.or_(a, b)     → a | b
operator.not_(a)       → not a

KEY HELPERS:
operator.itemgetter(n)       → func that gets item[n]
operator.attrgetter("name")  → func that gets obj.name
operator.methodcaller("m")   → func that calls obj.m()

─────────────────────────────────────
🔢 BITWISE OPERATORS
─────────────────────────────────────
&   AND    → 1 only where BOTH are 1
|   OR     → 1 where EITHER is 1
^   XOR    → 1 where EXACTLY ONE is 1
~   NOT    → flip all bits (two's complement: ~n = -n-1)
<<  left shift  → multiply by 2 per shift
>>  right shift → divide by 2 per shift

─────────────────────────────────────
🚩 FLAGS PATTERN (Bitwise)
─────────────────────────────────────
Each bit position represents one flag.
Set flag:    flags |= FLAG
Check flag:  bool(flags & FLAG)
Clear flag:  flags &= ~FLAG
Toggle flag: flags ^= FLAG

─────────────────────────────────────
🏎️  WHY operator > LAMBDA
─────────────────────────────────────
operator.attrgetter("name")   # faster than lambda x: x.name
operator.itemgetter(1)        # faster than lambda x: x[1]
operator.add                  # faster than lambda a,b: a+b

💻 CODE:
import operator
from functools import reduce

# ── OPERATOR AS FUNCTIONS ─────────

# Arithmetic
print(operator.add(3, 4))       # 7
print(operator.sub(10, 3))      # 7
print(operator.mul(3, 4))       # 12
print(operator.truediv(7, 2))   # 3.5
print(operator.floordiv(7, 2))  # 3
print(operator.mod(7, 3))       # 1
print(operator.pow(2, 10))      # 1024
print(operator.neg(5))          # -5
print(operator.abs(-7))         # 7

# Comparison
print(operator.eq(3, 3))     # True
print(operator.lt(2, 5))     # True
print(operator.ge(5, 5))     # True
print(operator.ne(3, 4))     # True

# Logical
print(operator.and_(True, False))   # False
print(operator.or_(True, False))    # True
print(operator.not_(True))          # False

# With reduce()
nums = [1, 2, 3, 4, 5]

total    = reduce(operator.add, nums)    # 15
product  = reduce(operator.mul, nums)    # 120
maximum  = reduce(operator.gt, nums)     # Not right — use max()
# Better:
total    = reduce(operator.add, nums)
print(f"Sum: {total}, Product: {product}")

# Concatenation
words = ["Hello", ", ", "World", "!"]
sentence = reduce(operator.add, words)
print(sentence)   # Hello, World!

# ── ITEMGETTER ────────────────────

# itemgetter — get by index or key
get_first  = operator.itemgetter(0)
get_second = operator.itemgetter(1)
get_slice  = operator.itemgetter(slice(1, 4))

data = [10, 20, 30, 40, 50]
print(get_first(data))   # 10
print(get_second(data))  # 20

# Multiple indices at once
get_first_last = operator.itemgetter(0, -1)
print(get_first_last(data))  # (10, 50)

# For sorting — FASTER than lambda
rows = [(3, "Carol"), (1, "Alice"), (2, "Bob")]
sorted_by_num  = sorted(rows, key=operator.itemgetter(0))
sorted_by_name = sorted(rows, key=operator.itemgetter(1))
print(sorted_by_num)   # [(1,'Alice'), (2,'Bob'), (3,'Carol')]
print(sorted_by_name)  # [(1,'Alice'), (2,'Bob'), (3,'Carol')]

# Dict access
students = [
    {"name": "Alice", "grade": 92},
    {"name": "Bob",   "grade": 78},
    {"name": "Carol", "grade": 95},
]
by_grade = sorted(students, key=operator.itemgetter("grade"), reverse=True)
for s in by_grade:
    print(f"  {s['name']}: {s['grade']}")

# ── ATTRGETTER ────────────────────

from dataclasses import dataclass

@dataclass
class Student:
    name: str
    grade: int
    gpa: float

students = [
    Student("Alice", 12, 3.9),
    Student("Bob",   11, 3.5),
    Student("Carol", 12, 3.7),
]

# Sort by attribute — faster than lambda
by_gpa  = sorted(students, key=operator.attrgetter("gpa"), reverse=True)
by_name = sorted(students, key=operator.attrgetter("name"))

# Multi-attribute sort
by_grade_gpa = sorted(students, key=operator.attrgetter("grade", "gpa"))

print("By GPA:")
for s in by_gpa:
    print(f"  {s.name}: {s.gpa}")

# Access nested attributes
@dataclass
class Department:
    name: str
    head: Student

dept = Department("Engineering", Student("Alice", 12, 3.9))
get_head_name = operator.attrgetter("head.name")
print(get_head_name(dept))   # Alice

# ── METHODCALLER ──────────────────

# Call a method on each object
texts = ["hello world", "PYTHON IS GREAT", "  spaces  "]

uppers  = list(map(operator.methodcaller("upper"), texts))
lowers  = list(map(operator.methodcaller("lower"), texts))
strips  = list(map(operator.methodcaller("strip"), texts))

print(uppers)   # ['HELLO WORLD', 'PYTHON IS GREAT', '  SPACES  ']
print(strips)   # ['hello world', 'PYTHON IS GREAT', 'spaces']

# With arguments
replacer = operator.methodcaller("replace", " ", "_")
underscored = list(map(replacer, texts))
print(underscored)

# ── BITWISE OPERATIONS ────────────

# Binary representations
for n in [0, 1, 5, 10, 255]:
    print(f"  {n:3d} = {n:08b}")

# AND — both bits must be 1
a = 0b1100   # 12
b = 0b1010   # 10
print(f"  {a:04b} & {b:04b} = {a & b:04b} = {a & b}")   # 1000 = 8

# OR — at least one bit must be 1
print(f"  {a:04b} | {b:04b} = {a | b:04b} = {a | b}")   # 1110 = 14

# XOR — exactly one bit must be 1
print(f"  {a:04b} ^ {b:04b} = {a ^ b:04b} = {a ^ b}")   # 0110 = 6

# NOT — flip all bits
print(f"  ~{a} = {~a}")   # -13  (~n = -n-1 in two's complement)
print(f"  ~0 = {~0}")     # -1

# Shifts
x = 1
for i in range(8):
    print(f"  1 << {i} = {x << i:4d} = {x << i:08b}")   # powers of 2

# Right shift (divide by 2)
n = 256
for i in range(5):
    print(f"  256 >> {i} = {n >> i}")   # 256, 128, 64, 32, 16

# ── FLAGS PATTERN ─────────────────

# Unix-style permission flags
READ    = 0b001  # 1
WRITE   = 0b010  # 2
EXECUTE = 0b100  # 4

def describe_permissions(flags: int) -> str:
    parts = []
    if flags & READ:    parts.append("read")
    if flags & WRITE:   parts.append("write")
    if flags & EXECUTE: parts.append("execute")
    return ", ".join(parts) or "none"

# Set multiple flags with OR
user_perms = READ | WRITE        # 0b011 = 3
admin_perms = READ | WRITE | EXECUTE  # 0b111 = 7

print(f"User:  {describe_permissions(user_perms)}")    # read, write
print(f"Admin: {describe_permissions(admin_perms)}")   # read, write, execute

# Check flag
print(f"Can read:    {bool(user_perms & READ)}")     # True
print(f"Can execute: {bool(user_perms & EXECUTE)}")  # False

# Grant execute
user_perms |= EXECUTE
print(f"After grant: {describe_permissions(user_perms)}")

# Revoke write
user_perms &= ~WRITE    # AND with NOT WRITE
print(f"After revoke: {describe_permissions(user_perms)}")

# Toggle flag
user_perms ^= WRITE     # XOR toggles
print(f"After toggle: {describe_permissions(user_perms)}")

# ── PRACTICAL EXAMPLES ─────────────

# Using operator with max/min/sorted
people = [
    {"name": "Alice", "age": 30, "score": 92},
    {"name": "Bob",   "age": 25, "score": 78},
    {"name": "Carol", "age": 35, "score": 95},
]

oldest  = max(people, key=operator.itemgetter("age"))
youngest = min(people, key=operator.itemgetter("age"))
print(f"Oldest: {oldest['name']}, Youngest: {youngest['name']}")

# Matrix multiplication (using operator.matmul)
# operator.matmul(A, B)  →  A @ B

# Concat operator
operator.concat([1,2], [3,4])  # [1, 2, 3, 4]

📝 KEY POINTS:
✅ operator.attrgetter/itemgetter are faster than equivalent lambdas
✅ operator functions work seamlessly with map(), sorted(), reduce(), max()
✅ Bitwise &, |, ^ work on integer bit patterns — not booleans!
✅ Flags: set with |=, check with &, clear with &= ~FLAG, toggle with ^=
✅ ~ (bitwise NOT) gives -n-1 in Python (two's complement)
✅ << left shift multiplies by 2 per bit; >> right shift divides by 2 per bit
✅ operator.methodcaller("method", args) creates a callable that calls obj.method(args)
❌ operator.and_ (with underscore) is bitwise AND; "and" (keyword) is logical AND
❌ Don't use bitwise & | for boolean logic — use "and" "or" for booleans
❌ Bitwise NOT (~) on Python ints can surprise: ~0 is -1, not 1
""",
  quiz: [
    Quiz(question: 'What does operator.itemgetter(1) return?', options: [
      QuizOption(text: 'The integer 1', correct: false),
      QuizOption(text: 'A callable that returns item[1] from its argument', correct: true),
      QuizOption(text: 'A function that checks if an item equals 1', correct: false),
      QuizOption(text: 'The second item of the operator module', correct: false),
    ]),
    Quiz(question: 'Given flags = 0b0110, what does flags & 0b0001 equal?', options: [
      QuizOption(text: '1 — the READ flag is set', correct: false),
      QuizOption(text: '0 — the READ flag is not set', correct: true),
      QuizOption(text: '7 — all bits combined', correct: false),
      QuizOption(text: '6 — unchanged', correct: false),
    ]),
    Quiz(question: 'What does 1 << 4 equal?', options: [
      QuizOption(text: '4', correct: false),
      QuizOption(text: '5', correct: false),
      QuizOption(text: '16', correct: true),
      QuizOption(text: '8', correct: false),
    ]),
  ],
);
