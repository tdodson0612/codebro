import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson05 = Lesson(
  language: 'Python',
  title: 'Numbers & Math',
  content: """
🎯 METAPHOR:
Python's number system is like a calculator that never
runs out of digits. A normal calculator overflows when
numbers get too big. Python's integers are like a
calculator connected to infinite paper tape — it just
keeps going. Need to calculate 2 to the power of 1000?
No problem. But for decimals, Python uses the same
limited floating-point hardware as every other language,
so precision has limits. It's a very long paper tape,
not infinite.

📖 EXPLANATION:
Python has three built-in numeric types:
  int     — unlimited precision integers
  float   — 64-bit IEEE 754 decimal numbers
  complex — numbers with real and imaginary parts

And the math and decimal modules for advanced use.

─────────────────────────────────────
➕ ARITHMETIC OPERATORS
─────────────────────────────────────
Operator  Name              Example    Result
─────────────────────────────────────
  +       Addition          5 + 3      8
  -       Subtraction       5 - 3      2
  *       Multiplication    5 * 3      15
  /       True Division     7 / 2      3.5  ← always float
  //      Floor Division    7 // 2     3    ← rounds down
  %       Modulo (remainder) 7 % 2     1
  **      Exponentiation    2 ** 8     256
  -x      Negation          -5         -5

Key difference: / always returns float in Python 3!
7 / 2 = 3.5 (not 3 like in C/Java)
7 // 2 = 3  (floor division — rounds toward -infinity)

─────────────────────────────────────
📐 OPERATOR PRECEDENCE (PEMDAS)
─────────────────────────────────────
()       Parentheses (highest)
**       Exponentiation (right-to-left!)
+x, -x  Unary plus/minus
*, /, //, %  Multiply/divide
+, -     Add/subtract (lowest)

2 + 3 * 4    = 14   (not 20)
(2 + 3) * 4  = 20
2 ** 3 ** 2  = 512  (2^(3^2) = 2^9 — right to left!)

─────────────────────────────────────
🔀 AUGMENTED ASSIGNMENT
─────────────────────────────────────
x += 5   → x = x + 5
x -= 5   → x = x - 5
x *= 2   → x = x * 2
x /= 2   → x = x / 2
x //= 2  → x = x // 2
x **= 2  → x = x ** 2
x %= 3   → x = x % 3

─────────────────────────────────────
⚠️  FLOATING POINT PRECISION
─────────────────────────────────────
Floats use binary fractions internally.
0.1 cannot be represented exactly in binary!

0.1 + 0.2 == 0.3   →  False  ← famous gotcha!
0.1 + 0.2          →  0.30000000000000004

Solutions:
  round(0.1 + 0.2, 10)       → "close enough"
  math.isclose(a, b)          → better comparison
  from decimal import Decimal  → exact decimal math

─────────────────────────────────────
🔢 NUMBER BASES
─────────────────────────────────────
Binary  (base 2):  0b1010  = 10
Octal   (base 8):  0o17    = 15
Hex     (base 16): 0xFF    = 255

bin(255)   → '0b11111111'
oct(255)   → '0o377'
hex(255)   → '0xff'
int('FF', 16) → 255  (string to int with base)

─────────────────────────────────────
📊 BUILT-IN MATH FUNCTIONS
─────────────────────────────────────
abs(-5)       → 5       absolute value
round(3.7)    → 4       round to nearest int
round(3.456, 2) → 3.46  round to 2 decimal places
min(3,1,4,1)  → 1       minimum
max(3,1,4,1)  → 4       maximum
sum([1,2,3])  → 6       sum of iterable
pow(2, 8)     → 256     power (same as **)
divmod(7, 2)  → (3, 1)  returns (quotient, remainder)

─────────────────────────────────────
📐 THE MATH MODULE
─────────────────────────────────────
import math

math.pi         → 3.141592653589793
math.e          → 2.718281828459045
math.inf        → infinity
math.nan        → not a number
math.sqrt(16)   → 4.0
math.ceil(3.2)  → 4   (round up)
math.floor(3.9) → 3   (round down)
math.trunc(3.9) → 3   (toward zero)
math.log(100, 10) → 2.0  (log base 10)
math.log2(8)    → 3.0
math.log10(1000) → 3.0
math.sin(math.pi/2) → 1.0
math.factorial(5)   → 120
math.gcd(12, 8) → 4  (greatest common divisor)
math.lcm(4, 6)  → 12 (Python 3.9+)
math.isclose(0.1+0.2, 0.3) → True (float comparison!)
math.isnan(float('nan'))    → True
math.isinf(float('inf'))    → True

─────────────────────────────────────
💰 DECIMAL — Exact Decimal Math
─────────────────────────────────────
For financial calculations, use Decimal:

from decimal import Decimal, getcontext
getcontext().prec = 28  # set precision

Decimal('0.1') + Decimal('0.2') == Decimal('0.3')  → True!

─────────────────────────────────────
🔀 FRACTIONS
─────────────────────────────────────
from fractions import Fraction
Fraction(1, 3)           # 1/3 exactly
Fraction(1,3) + Fraction(1,6)  # 1/2

─────────────────────────────────────
🎲 RANDOM NUMBERS
─────────────────────────────────────
import random
random.random()         # float: 0.0 to 1.0
random.randint(1, 6)    # int: 1 to 6 inclusive
random.choice([1,2,3])  # random item from list
random.shuffle(mylist)  # shuffle list in place
random.sample(list, k)  # k unique random items

💻 CODE:
# Basic arithmetic
print(10 / 3)     # 3.3333333333333335 (true div)
print(10 // 3)    # 3 (floor div)
print(10 % 3)     # 1 (remainder)
print(2 ** 10)    # 1024
print(2 ** 1000)  # Python handles this huge number!

# Modulo tricks
print(10 % 2 == 0)  # True — even number check
print(7 % 2 == 1)   # True — odd number check
hour = 14
print(hour % 12)    # 2 — 24h to 12h conversion

# divmod
quotient, remainder = divmod(17, 5)
print(f"17 / 5 = {quotient} remainder {remainder}")

# float precision
import math
a = 0.1 + 0.2
print(a == 0.3)                # False!
print(math.isclose(a, 0.3))   # True  ← use this

# math module
print(math.pi)          # 3.141592653589793
print(math.sqrt(144))   # 12.0
print(math.ceil(4.1))   # 5
print(math.floor(4.9))  # 4
print(math.factorial(10))  # 3628800
area = math.pi * 5 ** 2    # area of circle r=5
print(f"Circle area: {area:.2f}")

# Complex numbers
z = 3 + 4j
print(z.real)   # 3.0
print(z.imag)   # 4.0
print(abs(z))   # 5.0 (magnitude)

# Decimal for money
from decimal import Decimal
price = Decimal('9.99')
tax = Decimal('0.08')
total = price * (1 + tax)
print(f"Total:\${
total:.2f}")  # Total: \$10.79

# Number formatting
big_number = 1_234_567_890  # readable!
print(f"{big_number:,}")     # 1,234,567,890
print(f"{3.14159:.4f}")      # 3.1416
print(f"{255:#x}")           # 0xff (hex)
print(f"{255:#b}")           # 0b11111111 (binary)

📝 KEY POINTS:
✅ / always returns float in Python 3 (7/2 = 3.5, not 3)
✅ // is floor division — rounds toward negative infinity
✅ ** is exponentiation — right-associative
✅ Python integers have unlimited precision — no overflow
✅ Use math.isclose() to compare floats — never ==
✅ Use Decimal for financial calculations
✅ Use underscores in big numbers: 1_000_000 for readability
❌ Never compare floats with == — use math.isclose()
❌ Don't use float for money — use Decimal
❌ -7 // 2 == -4 (not -3) — floor rounds toward negative infinity
""",
  quiz: [
    Quiz(question: 'What is the result of 7 / 2 in Python 3?', options: [
      QuizOption(text: '3.5 (true division always returns float)', correct: true),
      QuizOption(text: '3 (integer division)', correct: false),
      QuizOption(text: '4 (rounds up)', correct: false),
      QuizOption(text: '3.0 only if both are floats', correct: false),
    ]),
    Quiz(question: 'Why should you use math.isclose() instead of == for floats?', options: [
      QuizOption(text: 'Floats have limited binary precision, so 0.1+0.2 != 0.3 exactly', correct: true),
      QuizOption(text: '== only works with integers in Python', correct: false),
      QuizOption(text: 'math.isclose() is faster', correct: false),
      QuizOption(text: 'Floats are mutable and change value over time', correct: false),
    ]),
    Quiz(question: 'What does -7 // 2 equal in Python?', options: [
      QuizOption(text: '-3 (truncates toward zero)', correct: false),
      QuizOption(text: '-4 (floor division rounds toward negative infinity)', correct: true),
      QuizOption(text: '3 (ignores the negative sign)', correct: false),
      QuizOption(text: '-3.5', correct: false),
    ]),
  ],
);
