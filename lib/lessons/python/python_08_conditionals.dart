import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson08 = Lesson(
  language: 'Python',
  title: 'Conditionals: if / elif / else',
  content: '''
🎯 METAPHOR:
An if/elif/else chain is like a bouncer at a nightclub
with a checklist.
The bouncer checks rules TOP to BOTTOM and stops at the
FIRST rule that matches. "Are you on the VIP list?" — yes?
You're in. No? "Are you over 21?" — yes? You're in. No?
"Are you with the band?" — yes? You're in. No? "Sorry, not tonight."
The bouncer doesn't check the rest of the list once
they find a match. The FIRST true condition wins.

📖 EXPLANATION:
Conditionals let your program make decisions.
Python uses if, elif (else if), and else.

─────────────────────────────────────
📐 BASIC SYNTAX
─────────────────────────────────────
if condition:
    # body (indented 4 spaces)
elif another_condition:
    # only checked if first was False
else:
    # runs if NOTHING above was True

Rules:
  • Colon : after every condition
  • Body must be indented (4 spaces)
  • elif and else are optional
  • Can have many elif blocks
  • Only ONE branch ever runs

─────────────────────────────────────
🔄 FLOW DIAGRAM
─────────────────────────────────────
condition1?
  YES → run block 1 → DONE
  NO  ↓
condition2?
  YES → run block 2 → DONE
  NO  ↓
else block → DONE

─────────────────────────────────────
🪺 NESTED if STATEMENTS
─────────────────────────────────────
if outer_condition:
    if inner_condition:
        # runs only if BOTH true
    else:
        # outer true, inner false
else:
    # outer false

⚠️  Deep nesting is a code smell.
Max 2-3 levels. Refactor with functions if deeper.

─────────────────────────────────────
💎 THE MATCH STATEMENT (Python 3.10+)
─────────────────────────────────────
Python 3.10 introduced match/case — like switch but
much more powerful with pattern matching.

match value:
    case pattern1:
        ...
    case pattern2:
        ...
    case _:          # wildcard — matches anything
        ...

─────────────────────────────────────
✨ GUARD CLAUSES — Cleaner Code
─────────────────────────────────────
Instead of deep nesting, use guard clauses:
return early when something is invalid.

# Nested (messy):
def process(data):
    if data is not None:
        if len(data) > 0:
            if data[0] > 0:
                return data[0] * 2

# Guard clauses (clean):
def process(data):
    if data is None: return None
    if len(data) == 0: return None
    if data[0] <= 0: return None
    return data[0] * 2

💻 CODE:
# Basic if/elif/else
score = 82

if score >= 90:
    grade = "A"
elif score >= 80:
    grade = "B"
elif score >= 70:
    grade = "C"
elif score >= 60:
    grade = "D"
else:
    grade = "F"

print(f"Score {score} → Grade {grade}")  # Grade B

# Truthiness in conditions
username = ""
if username:
    print(f"Welcome, {username}!")
else:
    print("Please enter a username")

# Multiple conditions
age = 25
has_id = True
is_member = False

if age >= 21 and has_id:
    print("Access granted")
elif is_member:
    print("Member access")
else:
    print("Access denied")

# Nested conditions
temperature = 28
humidity = 75

if temperature > 25:
    if humidity > 70:
        print("Hot and humid — stay hydrated!")
    else:
        print("Hot but dry — nice weather")
else:
    print("Cool day")

# Ternary (one-line if)
x = 10
status = "positive" if x > 0 else "non-positive"
print(status)

# match statement (Python 3.10+)
day = "Monday"
match day:
    case "Saturday" | "Sunday":
        print("Weekend!")
    case "Monday":
        print("Start of the week 😩")
    case "Friday":
        print("Almost weekend! 🎉")
    case _:
        print("Weekday")

# match with data structures
point = (0, 1)
match point:
    case (0, 0):
        print("Origin")
    case (x, 0):
        print(f"On x-axis at {x}")
    case (0, y):
        print(f"On y-axis at {y}")
    case (x, y):
        print(f"At ({x}, {y})")

# match with types and guards
def classify(value):
    match value:
        case int(n) if n < 0:
            return "negative integer"
        case int(n):
            return f"positive integer: {n}"
        case str(s) if len(s) == 0:
            return "empty string"
        case str(s):
            return f"string: '{s}'"
        case None:
            return "null value"
        case _:
            return "unknown type"

print(classify(-5))      # negative integer
print(classify(42))      # positive integer: 42
print(classify("hi"))    # string: 'hi'
print(classify(None))    # null value

# Guard clauses pattern
def get_discount(user, cart_total):
    if user is None:
        return 0
    if cart_total <= 0:
        return 0
    if not user.get("is_member"):
        return 0
    if cart_total >= 100:
        return 0.20   # 20% for members over \$100
    return 0.10       # 10% for members

# in operator for membership checks
color = "blue"
if color in ["red", "green", "blue"]:
    print(f"{color} is a primary color")

# Dictionary as switch alternative
actions = {
    "start": lambda: print("Starting..."),
    "stop": lambda: print("Stopping..."),
    "pause": lambda: print("Pausing..."),
}
command = "start"
actions.get(command, lambda: print("Unknown command"))()

📝 KEY POINTS:
✅ Only the FIRST matching branch runs — order matters!
✅ Use truthiness checks: "if mylist:" not "if len(mylist) > 0:"
✅ match/case (Python 3.10+) is great for complex pattern matching
✅ Guard clauses reduce nesting and improve readability
✅ elif not elseif or else if — Python is specific
✅ The ternary: x if condition else y — for simple one-liners
❌ No switch statement before Python 3.10 — use if/elif or dict
❌ Don't nest more than 2-3 levels — extract into functions
❌ Don't forget the colon : after if/elif/else
''',
  quiz: [
    Quiz(question: 'In an if/elif/else chain, how many branches can run?', options: [
      QuizOption(text: 'All branches that have True conditions', correct: false),
      QuizOption(text: 'Exactly one — the first True branch', correct: true),
      QuizOption(text: 'The last True branch', correct: false),
      QuizOption(text: 'Always the else branch plus any True branches', correct: false),
    ]),
    Quiz(question: 'What Python version introduced the match statement?', options: [
      QuizOption(text: 'Python 3.8', correct: false),
      QuizOption(text: 'Python 3.9', correct: false),
      QuizOption(text: 'Python 3.10', correct: true),
      QuizOption(text: 'Python 4.0', correct: false),
    ]),
    Quiz(question: 'What is a "guard clause" pattern?', options: [
      QuizOption(text: 'A special type of if/else for security checks', correct: false),
      QuizOption(text: 'Returning early when invalid conditions are met to avoid deep nesting', correct: true),
      QuizOption(text: 'Using try/except instead of if statements', correct: false),
      QuizOption(text: 'A match/case pattern for error handling', correct: false),
    ]),
  ],
);
