import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson75 = Lesson(
  language: 'Python',
  title: 'String Formatting Mastery',
  content: '''
🎯 METAPHOR:
String formatting is like a mail merge template.
You have a letter template with blank fields: 
"Dear [NAME], your order [ORDER_ID] for [AMOUNT] 
is ready." Python fills in the blanks at runtime.
f-strings are the modern, readable template.
format() is the flexible predecessor.
% is the ancient C-style way (still works, but don't use it).
The art is knowing ALL the special codes that go
in the blanks: alignment, precision, thousands separator,
padding character — these make the difference between
"3.14159265" and "    3.14".

📖 EXPLANATION:
Python has three string formatting systems. f-strings
(Python 3.6+) are the modern standard. This lesson
covers comprehensive f-string format specifications.

─────────────────────────────────────
🎨 F-STRING FORMAT SPEC SYNTAX
─────────────────────────────────────
f"{value:[[fill]align][sign][z][#][0][width][grouping][.precision][type]}"

fill:      any char to use for padding
align:     < left  > right  ^ center  = (sign-aware padding)
sign:      + (always show sign)  - (default)  space
z:         coerce negative zero to zero (3.11+)
#:         alternate form: 0x prefix for hex, 0o for oct
0:         zero-pad (same as fill=0, align==)
width:     minimum field width
grouping:  , (comma separator) or _ (underscore)
precision: decimal places (float) or max chars (string)
type:      d int, f float, e sci, g general, % percent,
           x hex, X HEX, o octal, b binary, s string,
           c char from int, n locale-aware number

─────────────────────────────────────
🔧 THREE FORMATTING SYSTEMS
─────────────────────────────────────
f-string:   f"Hello, {name}!"            (Python 3.6+)
.format():  "Hello, {}!".format(name)
%:          "Hello, %s!" % name          (C-style, avoid)

─────────────────────────────────────
🔑 SPECIAL CONVERSIONS
─────────────────────────────────────
f"{val!r}" → calls repr(val)   (good for debugging)
f"{val!s}" → calls str(val)    (default)
f"{val!a}" → calls ascii(val)  (escapes non-ASCII)
f"{val=}"  → shows name=value  (Python 3.8+, debugging!)

💻 CODE:
# ── F-STRING BASICS ───────────────

name = "Alice"
age  = 30
pi   = 3.14159265358979

# Simple interpolation
print(f"Hello, {name}! You are {age} years old.")

# Expressions inside f-strings
print(f"In 5 years: {age + 5}")
print(f"Uppercase: {name.upper()}")
print(f"Pi × 2 = {pi * 2:.4f}")

# Multiline f-strings
msg = (
    f"Name: {name}\\n"
    f"Age:  {age}\\n"
    f"Pi:   {pi:.2f}"
)
print(msg)

# ── NUMERIC FORMATTING ─────────────

n = 1234567.891

# Thousands separator
print(f"{n:,}")         # 1,234,567.891
print(f"{n:_.2f}")      # 1_234_567.89

# Decimal places
print(f"{pi:.2f}")      # 3.14
print(f"{pi:.6f}")      # 3.141593
print(f"{pi:.0f}")      # 3

# Scientific notation
print(f"{n:e}")         # 1.234568e+06
print(f"{n:.3e}")       # 1.235e+06

# General (picks fixed or scientific)
print(f"{n:g}")         # 1.23457e+06
print(f"{0.000123:g}")  # 0.000123

# Integer bases
x = 255
print(f"{x:d}")         # 255   (decimal)
print(f"{x:b}")         # 11111111 (binary)
print(f"{x:o}")         # 377   (octal)
print(f"{x:x}")         # ff    (hex lowercase)
print(f"{x:X}")         # FF    (hex uppercase)
print(f"{x:#x}")        # 0xff  (with 0x prefix)
print(f"{x:#010b}")     # 0b11111111 (zero-padded binary)

# Percentage
ratio = 0.857
print(f"{ratio:.1%}")   # 85.7%
print(f"{ratio:.0%}")   # 86%

# Sign
print(f"{3.14:+.2f}")   # +3.14
print(f"{-3.14:+.2f}")  # -3.14
print(f"{3.14: .2f}")   # ` 3.14` (space for positive)

# ── STRING ALIGNMENT ──────────────

label = "hello"

# Width and alignment
print(f"{label:10}")     # "hello     " (left, default for str)
print(f"{label:<10}")    # "hello     " (left)
print(f"{label:>10}")    # "     hello" (right)
print(f"{label:^10}")    # "  hello   " (center)

# Custom fill character
print(f"{label:*<10}")   # "hello*****"
print(f"{label:->10}")   # "-----hello"
print(f"{label:-^10}")   # "--hello---"

# Numbers: right-aligned by default
n = 42
print(f"{n:10}")         # "        42"
print(f"{n:010}")        # "0000000042"
print(f"{n:<10}")        # "42        "

# ── TABLE FORMATTING ──────────────

# Build a clean table
data = [
    ("Alice",  "Engineering", 95000),
    ("Bob",    "Marketing",   72000),
    ("Carol",  "Engineering", 98000),
    ("Dave",   "HR",          65000),
    ("Eve",    "Marketing",   78000),
]

header = f"{'Name':<10} {'Department':<15} {'Salary':>10}"
divider = "-" * len(header)
print(header)
print(divider)
for name, dept, salary in sorted(data, key=lambda x: x[2], reverse=True):
    print(f"{name:<10} {dept:<15} \${salary:>9,.0f}")
print(divider)
total = sum(s for _, _, s in data)
print(f"{'TOTAL':<27} \${total:>9,.0f}")

# ── DEBUGGING WITH = ──────────────

# Python 3.8+ f"{var=}" shows variable name + value
x = 42
y = [1, 2, 3]
name = "Alice"

print(f"{x=}")        # x=42
print(f"{y=}")        # y=[1, 2, 3]
print(f"{name=}")     # name='Alice'
print(f"{x * 2 + 1=}") # x * 2 + 1=85

# !r conversion for unambiguous repr
text = "Hello\\tWorld\\n"
print(f"{text!r}")    # 'Hello\\tWorld\\n'  (shows escape sequences)
print(f"{text}")      # Hello	World       (actual tab and newline)

# ── FORMAT() METHOD ──────────────

# Positional
print("Hello, {}! You are {} years old.".format("Alice", 30))

# Named
print("Hello, {name}! You are {age}.".format(name="Alice", age=30))

# Index
print("Hello, {0}! {0} is {1}.".format("Alice", 30))

# format() with spec
print("{:.2f}".format(3.14159))    # 3.14
print("{:>10}".format("hello"))    # "     hello"
print("{:,}".format(1234567))      # 1,234,567

# ── TEMPLATE STRINGS ─────────────

from string import Template

# Safe for user-controlled strings (no code execution!)
t = Template("Dear \$name, your order #\$order_id is ready.")
print(t.substitute(name="Alice", order_id=42))
print(t.safe_substitute(name="Alice"))  # missing vars → placeholder

# ── TEXTWRAP ─────────────────────

import textwrap

long_text = "Python is a high-level, general-purpose programming language. It is designed to be readable and straightforward to write."

# Wrap to 40 chars
print(textwrap.fill(long_text, width=40))

# Indent
print(textwrap.indent(long_text, "    "))

# Dedent (remove common leading whitespace)
indented = """
    Line one
    Line two
    Line three
"""
print(textwrap.dedent(indented))

# ── LOCALE-AWARE ─────────────────

import locale
# locale.setlocale(locale.LC_ALL, "")  # system locale
# print(f"{1234567.89:n}")  # locale-aware: 1,234,567.89

📝 KEY POINTS:
✅ f-strings are the modern standard — fast, readable, and powerful
✅ f"{val=}" is invaluable for debugging — shows name and value
✅ f"{val!r}" uses repr() — shows escape sequences and exact types
✅ Format spec: fill+align, width, .precision, type (d/f/e/x/b/%) 
✅ {n:,} and {n:_} for thousands separators in numbers
✅ {ratio:.1%} for percentage formatting — no need to multiply by 100
✅ Use Template for user-controlled strings — no code injection risk
❌ Don't use % formatting in new code — use f-strings
❌ f-strings can execute arbitrary Python — don't use with untrusted strings
❌ Forgetting the colon before the format spec: {n10} not {n:10}
''',
  quiz: [
    Quiz(question: 'What does f"{value=}" do in Python 3.8+?', options: [
      QuizOption(text: 'Assigns the value to a variable named "value"', correct: false),
      QuizOption(text: 'Prints the variable name and its value: "value=42"', correct: true),
      QuizOption(text: 'Checks if value is equal to itself', correct: false),
      QuizOption(text: 'Raises a SyntaxError', correct: false),
    ]),
    Quiz(question: 'What format spec produces "  3.14" (right-aligned in width 6, 2 decimal places)?', options: [
      QuizOption(text: ':6.2f', correct: true),
      QuizOption(text: ':.2f6', correct: false),
      QuizOption(text: ':2.6f', correct: false),
      QuizOption(text: ':f6.2', correct: false),
    ]),
    Quiz(question: 'What does f"{0.857:.1%}" produce?', options: [
      QuizOption(text: '"0.9%"', correct: false),
      QuizOption(text: '"85.7%"', correct: true),
      QuizOption(text: '"85.7" (no percent sign)', correct: false),
      QuizOption(text: '"0.857%"', correct: false),
    ]),
  ],
);
