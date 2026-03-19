import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson07 = Lesson(
  language: 'Python',
  title: 'User Input & Type Conversion',
  content: '''
🎯 METAPHOR:
input() is like a drive-through window.
You call out your order (your prompt), the customer
(user) tells you what they want, and it comes back
to you as a wrapped paper bag (a string). Whatever
they ordered — even if they said "two burgers" or "42"
or "yes" — it ALWAYS comes back in a bag (as a string).
You have to unwrap it yourself. Want a number? You have
to peel the string off with int() or float().
Always check what's in the bag before using it.

📖 EXPLANATION:
The input() function reads a line of text from the user
and ALWAYS returns it as a string, no matter what they type.

─────────────────────────────────────
📥 THE input() FUNCTION
─────────────────────────────────────
Syntax: variable = input(prompt)

  prompt — optional text shown to user
  Returns — string typed by user (ALWAYS a string)
  Blocks until user presses Enter

name = input("What is your name? ")
# User types: Alice
# name is now the string "Alice"

─────────────────────────────────────
🔄 TYPE CONVERSION (CASTING)
─────────────────────────────────────
Since input() always returns a string, you often
need to convert to the right type:

str → int:     int("42")       → 42
str → float:   float("3.14")   → 3.14
str → bool:    bool("True")    → True (anything non-empty!)
int → str:     str(42)         → "42"
int → float:   float(42)       → 42.0
float → int:   int(3.9)        → 3  (truncates, no rounding!)
list → tuple:  tuple([1,2,3])  → (1, 2, 3)
str → list:    list("hello")   → ['h','e','l','l','o']

─────────────────────────────────────
⚠️  CONVERSION ERRORS
─────────────────────────────────────
int("hello") → ValueError! (can't convert non-numeric)
int("3.14")  → ValueError! (float string, not int)
int(float("3.14")) → 3  ← this works (two-step)

Always validate or use try/except when converting
user input — users WILL type the wrong thing.

─────────────────────────────────────
🎨 FORMATTING OUTPUT WITH print()
─────────────────────────────────────
print() function:
  sep   — separator between values (default: space)
  end   — what to print at end (default: newline "\\n")
  file  — where to print (default: sys.stdout)

print("a", "b", "c")           # a b c
print("a", "b", "c", sep="-")  # a-b-c
print("Hello", end="!")        # Hello! (no newline)
print("a", "b", sep="\\n")      # a\nb (each on new line)

─────────────────────────────────────
🖨️  OUTPUT FORMATTING OPTIONS
─────────────────────────────────────
1. f-strings (best for Python 3.6+)
2. .format() method
3. % formatting (old style)

# f-string format specifiers:
f"{value:.2f}"    # 2 decimal places
f"{value:,}"      # thousands separator
f"{value:>10}"    # right-align in 10 chars
f"{value:<10}"    # left-align in 10 chars
f"{value:^10}"    # center in 10 chars
f"{value:0>5}"    # pad with zeros: 00042
f"{value:+}"      # always show sign: +42
f"{value:e}"      # scientific notation: 4.2e+01
f"{value:x}"      # hex: 2a
f"{value:b}"      # binary: 101010

💻 CODE:
# Basic input
name = input("Enter your name: ")
print(f"Hello, {name}!")

# Convert to number
age_str = input("Enter your age: ")
age = int(age_str)              # convert string to int
print(f"In 10 years, you'll be {age + 10}")

# One-line conversion
height = float(input("Enter height in cm: "))
print(f"Height in meters: {height / 100:.2f}")

# Safe input with error handling
def get_integer(prompt):
    while True:
        try:
            return int(input(prompt))
        except ValueError:
            print("❌ Please enter a valid integer!")

# Multiple inputs on one line
coords = input("Enter x y: ").split()  # "3 4" → ['3', '4']
x, y = int(coords[0]), int(coords[1])
print(f"Point: ({x}, {y})")

# Elegant multi-input
x, y = map(int, input("Enter x y: ").split())
# map applies int() to each item in the split list

# Multiple values on separate lines
values = []
for i in range(3):
    val = int(input(f"Enter value {i+1}: "))
    values.append(val)
print(f"Sum: {sum(values)}")

# print() formatting
print("Name", "Age", "Score", sep=" | ")
print("Alice", 30, 95.5, sep=" | ")
print("Bob", 25, 87.3, sep=" | ")
# Output:
# Name | Age | Score
# Alice | 30 | 95.5
# Bob | 25 | 87.3

# Aligned table
print(f"{'Name':<10} {'Age':>5} {'Score':>8}")
print(f"{'Alice':<10} {30:>5} {95.5:>8.1f}")
print(f"{'Bob':<10} {25:>5} {87.3:>8.1f}")

# Number formatting
pi = 3.14159265358979
print(f"Pi = {pi:.2f}")        # Pi = 3.14
print(f"Pi = {pi:.5f}")        # Pi = 3.14159
print(f"Big: {1234567:,}")     # Big: 1,234,567
print(f"Sci: {0.000042:e}")    # Sci: 4.200000e-05
print(f"Pct: {0.856:.1%}")     # Pct: 85.6%

# Type conversion examples
print(int("0xFF", 16))   # 255 — hex string to int
print(int("0b1010", 2))  # 10  — binary string to int
print(int("077", 8))     # 63  — octal string to int

📝 KEY POINTS:
✅ input() ALWAYS returns a string — always convert if you need a number
✅ Use int(input(...)) or float(input(...)) for numeric input
✅ Use map(int, input().split()) for multiple numbers on one line
✅ Always wrap input conversion in try/except for robustness
✅ int() truncates floats: int(3.9) == 3 (not 4)
✅ f-string format specs: :.2f, :, :>10, :<10, :^10
❌ Never assume input is the right type — always validate
❌ bool("False") is True! ("False" is a non-empty string)
❌ int() cannot parse "3.14" directly — use float() first then int()
''',
  quiz: [
    Quiz(question: 'What does input() always return?', options: [
      QuizOption(text: 'A string, regardless of what the user types', correct: true),
      QuizOption(text: 'An integer if the user types a number', correct: false),
      QuizOption(text: 'The appropriate type based on what was typed', correct: false),
      QuizOption(text: 'None if the user presses Enter without typing', correct: false),
    ]),
    Quiz(question: 'What is the result of int(3.9) in Python?', options: [
      QuizOption(text: '4 — rounds to nearest integer', correct: false),
      QuizOption(text: '3 — truncates toward zero, no rounding', correct: true),
      QuizOption(text: 'ValueError — cannot convert float to int', correct: false),
      QuizOption(text: '3.9 — int() has no effect on floats', correct: false),
    ]),
    Quiz(question: 'How do you read two integers from one line of user input?', options: [
      QuizOption(text: 'x, y = map(int, input().split())', correct: true),
      QuizOption(text: 'x, y = int(input()), int(input())', correct: false),
      QuizOption(text: 'x, y = input().split(int)', correct: false),
      QuizOption(text: 'x = int(input()); y = int(input())', correct: false),
    ]),
  ],
);
