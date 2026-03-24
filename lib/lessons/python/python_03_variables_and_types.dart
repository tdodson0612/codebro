import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson03 = Lesson(
  language: 'Python',
  title: 'Variables & Data Types',
  content: """
🎯 METAPHOR:
A variable is like a labeled jar in your kitchen.
The label (variable name) tells you what's inside.
The jar can hold anything — sugar, coins, a note —
and you can replace the contents anytime. In Python,
unlike statically typed languages, you can even CHANGE
what kind of thing the jar holds — put sugar in today,
swap it for marbles tomorrow. The jar doesn't care.
Python is the most flexible kitchen you've ever cooked in.

📖 EXPLANATION:
Variables store data in memory. In Python, you don't
declare a type — Python figures it out automatically
based on what you assign.

─────────────────────────────────────
🔢 CORE DATA TYPES
─────────────────────────────────────
Type        Example           Description
─────────────────────────────────────
int         42, -7, 0         Whole numbers
float       3.14, -0.5, 2.0   Decimal numbers
complex     3+4j, 1j          Complex numbers
str         "hello", 'hi'     Text
bool        True, False       Boolean (yes/no)
NoneType    None              Absence of value
─────────────────────────────────────

─────────────────────────────────────
🧮 INT — Integer Numbers
─────────────────────────────────────
Like a number line with no decimal points.
Python ints have UNLIMITED precision — no overflow!
You can store numbers with thousands of digits.

x = 42
big = 1_000_000   # underscores for readability
negative = -99
binary = 0b1010   # binary: 10
octal = 0o77      # octal: 63
hexadecimal = 0xFF  # hex: 255

─────────────────────────────────────
🌊 FLOAT — Decimal Numbers
─────────────────────────────────────
Like a number line with decimal points.
Uses IEEE 754 double precision (64-bit).
⚠️  Floating point math is NOT perfectly precise!

pi = 3.14159
scientific = 1.5e10   # 15,000,000,000
tiny = 2.5e-4         # 0.00025

# Famous floating point trap:
# 0.1 + 0.2 does NOT equal 0.3 exactly!
# Use round() or the decimal module for precision

─────────────────────────────────────
🔤 STR — Strings (Text)
─────────────────────────────────────
Strings are sequences of characters.
Immutable — once created, cannot be changed in place.

name = "Python"
single = 'also works'
multiline = '''
This spans
multiple lines
'''

─────────────────────────────────────
⚖️  BOOL — Boolean
─────────────────────────────────────
Only two values: True or False (capital T and F!)
Booleans ARE integers in Python:
  True == 1  and  False == 0

─────────────────────────────────────
🕳️  None — The Absence of Value
─────────────────────────────────────
None is like an empty jar with a label.
The jar exists, but contains nothing.
Used to represent "no value", "not yet set",
or "function returned nothing".

─────────────────────────────────────
🏷️  NAMING RULES
─────────────────────────────────────
✅ Letters, digits, underscores
✅ Cannot start with a digit
✅ Case-sensitive
✅ snake_case is Python convention (not camelCase)
❌ Cannot use reserved words: if, for, class, etc.

Good names:   user_name, total_price, is_valid
Bad names:    x, data, temp, thing, foo

─────────────────────────────────────
🔍 TYPE CHECKING
─────────────────────────────────────
type()     → returns the type of a variable
isinstance() → checks if variable is a certain type

💻 CODE:
# Variable assignment
age = 25
price = 9.99
name = "Alice"
is_active = True
nothing = None

# Python figures out the type automatically
print(type(age))       # <class 'int'>
print(type(price))     # <class 'float'>
print(type(name))      # <class 'str'>
print(type(is_active)) # <class 'bool'>
print(type(nothing))   # <class 'NoneType'>

# Multiple assignment
x = y = z = 0        # all get value 0
a, b, c = 1, 2, 3    # unpacking assignment
first, *rest = [1, 2, 3, 4]  # star unpacking

# Swap without temp variable (Python magic!)
a, b = 10, 20
a, b = b, a    # now a=20, b=10

# Type checking
print(isinstance(age, int))      # True
print(isinstance(price, float))  # True
print(isinstance(name, str))     # True

# Unlimited integer precision
huge = 2 ** 1000   # Python handles this!
print(f"2^1000 has {len(str(huge))} digits")

# Float precision issue
print(0.1 + 0.2)          # 0.30000000000000004 !
print(round(0.1 + 0.2, 2)) # 0.3  ← use round()

# Constants — Python has no true const keyword
# Convention: ALL_CAPS means "don't change this"
MAX_SIZE = 100
PI = 3.14159
DATABASE_URL = "localhost:5432"

# Type conversion (casting)
x = int("42")        # str → int
y = float("3.14")    # str → float
z = str(100)         # int → str
b = bool(0)          # int → bool (0 = False)
b2 = bool("hello")   # str → bool (non-empty = True)

📝 KEY POINTS:
✅ Python is dynamically typed — type is determined at runtime
✅ Use type() to check type, isinstance() to verify type
✅ True and False are capitalized (not true/false)
✅ None is the null value — check with "is None", not "== None"
✅ Integers have unlimited precision in Python
✅ Use snake_case for variable names (PEP 8)
✅ ALL_CAPS signals a constant by convention
❌ Avoid single-letter names except loop counters (i, j, k)
❌ float arithmetic is imprecise — use decimal module for money
❌ None is not the same as 0, False, or empty string
""",
  quiz: [
    Quiz(question: 'What is the result of type(3.14) in Python?', options: [
      QuizOption(text: "<class 'float'>", correct: true),
      QuizOption(text: "<class 'int'>", correct: false),
      QuizOption(text: "<class 'double'>", correct: false),
      QuizOption(text: "<class 'number'>", correct: false),
    ]),
    Quiz(question: 'How do you swap two variables a and b in Python without a temp variable?', options: [
      QuizOption(text: 'swap(a, b)', correct: false),
      QuizOption(text: 'a, b = b, a', correct: true),
      QuizOption(text: 'temp = a; a = b; b = temp', correct: false),
      QuizOption(text: 'a.swap(b)', correct: false),
    ]),
    Quiz(question: 'What is the value of bool("") in Python?', options: [
      QuizOption(text: 'True, because the string exists', correct: false),
      QuizOption(text: 'None, because the string is empty', correct: false),
      QuizOption(text: 'False, because an empty string is falsy', correct: true),
      QuizOption(text: 'It raises a TypeError', correct: false),
    ]),
  ],
);
