import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson06 = Lesson(
  language: 'Python',
  title: 'Booleans & Comparisons',
  content: '''
🎯 METAPHOR:
Booleans are like light switches — they are either ON (True)
or OFF (False). No dimmer, no maybe, no 37% on. Just on or off.
But Python's "truthiness" system is like a smart home —
many things in your house can TRIGGER a light switch even
if they aren't a light switch themselves: motion sensors
(non-zero numbers), door sensors (non-empty strings),
presence detectors (non-empty lists). Python decides whether
any value is "switch-worthy" based on a set of rules.

📖 EXPLANATION:
Python's bool type has exactly two values: True and False.
Booleans are actually a subclass of int:
  True == 1  and  False == 0  (this is wild but true!)

─────────────────────────────────────
🔍 COMPARISON OPERATORS
─────────────────────────────────────
Operator   Meaning              Example    Result
─────────────────────────────────────
==         Equal                5 == 5     True
!=         Not equal            5 != 3     True
<          Less than            3 < 5      True
>          Greater than         5 > 3      True
<=         Less or equal        3 <= 3     True
>=         Greater or equal     4 >= 5     False
is         Identity (same obj)  a is b
is not     Not identity         a is not b
in         Membership           3 in [1,2,3]  True
not in     Not member           5 not in [1,2] True

⚠️  == checks VALUE equality
⚠️  is  checks IDENTITY (same object in memory)
Never use is to compare values! Use is only for None.

─────────────────────────────────────
🔗 LOGICAL OPERATORS
─────────────────────────────────────
and  — True if BOTH are true
or   — True if AT LEAST ONE is true
not  — Flips True to False, False to True

Truth table:
  A      B      A and B   A or B   not A
─────────────────────────────────────
True   True    True      True     False
True   False   False     True     False
False  True    False     True     True
False  False   False     False    True

─────────────────────────────────────
⚡ SHORT-CIRCUIT EVALUATION
─────────────────────────────────────
Like a lazy reader: stops as soon as result is clear.

and: if first is False, doesn't check second
or:  if first is True, doesn't check second

This is useful and important:
  x != 0 and 10/x > 1   ← safe! won't divide by zero
  user or get_default()  ← get_default() only called if user is falsy

─────────────────────────────────────
🌗 TRUTHINESS — Falsy Values
─────────────────────────────────────
These are ALL treated as False in a boolean context:

  False         the boolean False
  None          null value
  0             integer zero
  0.0           float zero
  0j            complex zero
  ""            empty string
  []            empty list
  ()            empty tuple
  {}            empty dict
  set()         empty set
  b""           empty bytes

EVERYTHING ELSE is True (truthy).

This is incredibly useful:
  if my_list:     # True if list is not empty
  if username:    # True if not empty string
  if result:      # True if not None/0/False

─────────────────────────────────────
🔢 BOOL IS A SUBCLASS OF INT
─────────────────────────────────────
True + True     → 2
True * 5        → 5
sum([True, False, True, True])  → 3  (count Trues!)
[True, False, True].count(True) → 2

─────────────────────────────────────
⛓️  CHAINED COMPARISONS
─────────────────────────────────────
Python allows chaining comparisons (unlike most languages!):

1 < x < 10        (x is between 1 and 10)
0 <= age <= 120   (valid age range)
a == b == c       (all three equal)

This is much cleaner than:
x > 1 and x < 10  (equivalent but verbose)

─────────────────────────────────────
🎯 CONDITIONAL EXPRESSIONS (Ternary)
─────────────────────────────────────
value_if_true if condition else value_if_false

status = "adult" if age >= 18 else "minor"
result = x if x > 0 else -x   # absolute value

💻 CODE:
# Basic comparisons
x = 10
print(x > 5)    # True
print(x == 10)  # True
print(x != 5)   # True
print(x >= 10)  # True

# is vs == (important difference!)
a = [1, 2, 3]
b = [1, 2, 3]
c = a

print(a == b)    # True  (same values)
print(a is b)    # False (different objects!)
print(a is c)    # True  (same object!)

# Use "is" ONLY for None:
result = None
if result is None:
    print("No result yet")

# Logical operators
age = 25
has_ticket = True
print(age >= 18 and has_ticket)  # True

name = ""
print(name or "Anonymous")       # Anonymous (short-circuit)
print(name or "Guest")           # Guest

# Truthiness
print(bool(0))       # False
print(bool(42))      # True
print(bool(""))      # False
print(bool("hi"))    # True
print(bool([]))      # False
print(bool([0]))     # True (list with one item!)
print(bool(None))    # False

# Practical truthiness
users = []
if not users:
    print("No users found")

data = {"name": "Alice"}
if data:
    print(f"Got data: {data}")

# Chained comparisons (Python superpower!)
x = 7
print(1 < x < 10)     # True  (in range)
print(1 < x < 5)      # False
print(0 <= x <= 100)  # True

# Short-circuit saves from errors
items = []
if items and items[0] > 5:   # safe — won't IndexError
    print("First item > 5")

# Ternary expression
score = 75
grade = "Pass" if score >= 60 else "Fail"
print(grade)  # Pass

# Bool is a subclass of int
votes = [True, False, True, True, False]
print(sum(votes))   # 3 (count of True votes)
winners = sum(1 for v in votes if v)  # same thing
print(winners)

# any() and all()
nums = [1, 2, 3, 4, 5]
print(any(n > 4 for n in nums))    # True (5 > 4)
print(all(n > 0 for n in nums))    # True (all positive)
print(all(n > 3 for n in nums))    # False (1, 2, 3 not > 3)

📝 KEY POINTS:
✅ Use == for value comparison, is only for None checks
✅ Falsy values: None, 0, "", [], {}, (), set() — everything else truthy
✅ Python supports chained comparisons: 1 < x < 10
✅ and/or use short-circuit evaluation — can prevent errors
✅ any() and all() are clean ways to test multiple conditions
✅ True == 1 and False == 0 — booleans are ints in Python
❌ Never use is to compare numbers or strings (use ==)
❌ "not empty list" check: use "if mylist:" not "if len(mylist) > 0:"
❌ and/or don't always return True/False — they return one of their operands
''',
  quiz: [
    Quiz(question: 'What is the result of [] or "default"?', options: [
      QuizOption(text: '"default" — because [] is falsy, or returns the second operand', correct: true),
      QuizOption(text: 'True — because or always returns a boolean', correct: false),
      QuizOption(text: '[] — because [] is the first operand', correct: false),
      QuizOption(text: 'False — because [] is falsy', correct: false),
    ]),
    Quiz(question: 'What does 1 < x < 10 mean in Python?', options: [
      QuizOption(text: 'It is a syntax error — you must use and', correct: false),
      QuizOption(text: 'True if x is greater than 1 AND less than 10', correct: true),
      QuizOption(text: 'True if x is greater than 1 OR less than 10', correct: false),
      QuizOption(text: 'It compares 1 to x, then x to 10 separately', correct: false),
    ]),
    Quiz(question: 'When should you use "is" instead of "=="?', options: [
      QuizOption(text: 'When comparing large numbers for speed', correct: false),
      QuizOption(text: 'Only when checking if a value is None', correct: true),
      QuizOption(text: 'When comparing strings', correct: false),
      QuizOption(text: 'They are interchangeable', correct: false),
    ]),
  ],
);
