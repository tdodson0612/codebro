import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson46 = Lesson(
  language: 'Python',
  title: 'Advanced Python: Walrus, Match, Assignment Expressions',
  content: '''
🎯 METAPHOR:
The walrus operator := is like a cashier who scans and bags
simultaneously. Old way: scan the item (compute), set it aside
(assign), then check the receipt (use in condition). Walrus
operator: scan the item AND instantly check AND bag in one
motion. Fewer steps, same result. The cashier doesn't miss
a beat — compute, assign, and use in one fluid motion.

match/case is like a professional triage nurse.
Instead of a long chain of "is it this? is it that?"
comparisons, the nurse looks at the patient holistically:
"You have these symptoms AND this age AND this condition?
Diagnosis: X." Pattern matching considers SHAPE, TYPE,
and CONTENT simultaneously — not just a single value.

📖 EXPLANATION:
Python 3.8-3.12 introduced powerful new features:
walrus operator, match/case structural pattern matching,
positional-only parameters, and more.

─────────────────────────────────────
🦭 WALRUS OPERATOR := (Python 3.8+)
─────────────────────────────────────
Assigns a value AND returns it in one expression.
Named "walrus" because := looks like walrus eyes and tusks.

Useful for:
  • while loops with assignment in condition
  • if statements that use the condition value
  • Comprehensions that compute once, use twice

─────────────────────────────────────
🎭 MATCH/CASE (Python 3.10+)
─────────────────────────────────────
Structural pattern matching — more powerful than switch.
Patterns can match:
  • Literals: case 42:, case "hello":
  • Variables: case x: (captures to x)
  • Wildcard: case _: (match anything)
  • OR patterns: case 1 | 2 | 3:
  • Sequences: case [x, y]:
  • Dicts: case {"action": action}:
  • Classes: case Point(x=0, y=0):
  • Guards: case x if x > 0:
  • AND combine: case (x, y) if x == y:

─────────────────────────────────────
📐 POSITIONAL-ONLY PARAMS (3.8+)
─────────────────────────────────────
def func(pos_only, /, normal, *, kw_only):
  /  separates positional-only from regular
  *  separates regular from keyword-only

─────────────────────────────────────
🔢 PYTHON 3.11+ FEATURES
─────────────────────────────────────
Exception groups: except* ExceptionType
Fine-grained tracebacks (pinpoint exact error)
tomllib — built-in TOML parsing
Self type hint — for fluent APIs
LiteralString — type for SQL injection prevention

─────────────────────────────────────
🎯 PYTHON 3.12+ FEATURES
─────────────────────────────────────
Type parameter syntax: class Stack[T]:
New f-string capabilities
@override decorator
TypeVar improvements

💻 CODE:
# ── WALRUS OPERATOR := ──────────────

# Classic while loop without walrus:
line = input("Enter text (empty to quit): ")
while line:
    print(f"You entered: {line}")
    line = input("Enter text (empty to quit): ")

# With walrus — assignment and check in one:
while (line := input("Enter text (empty to quit): ")):
    print(f"You entered: {line}")

# In a comprehension — compute once, use twice
import re
data = ["alice@email.com", "bad-email", "bob@test.org", "also-bad"]
emails = [
    match.group()
    for item in data
    if (match := re.search(r"\\w+@\\w+\\.\\w+", item))
]
print(emails)   # ['alice@email.com', 'bob@test.org']

# Without walrus (less efficient — regex runs twice):
emails2 = [
    re.search(r"\\w+@\\w+\\.\\w+", item).group()
    for item in data
    if re.search(r"\\w+@\\w+\\.\\w+", item)
]

# In if statements
import json
def process_json(raw: str):
    if (data := json.loads(raw)) and "status" in data:
        return data["status"]
    return None

# ── MATCH / CASE ──────────────────

# Basic matching
def http_status(code: int) -> str:
    match code:
        case 200:
            return "OK"
        case 201:
            return "Created"
        case 301 | 302:
            return "Redirect"
        case 400:
            return "Bad Request"
        case 404:
            return "Not Found"
        case 500:
            return "Server Error"
        case _ if 400 <= code < 500:
            return f"Client Error ({code})"
        case _:
            return f"Unknown ({code})"

for code in [200, 201, 302, 404, 418, 500, 999]:
    print(f"{code}: {http_status(code)}")

# Structural pattern matching — sequences
def process_command(command):
    match command.split():
        case ["quit"]:
            return "Quitting..."
        case ["go", direction]:
            return f"Going {direction}"
        case ["go", direction, "fast"]:
            return f"Going {direction} fast!"
        case ["pick", "up", item]:
            return f"Picked up {item}"
        case ["drop", item, *location] if location:
            return f"Dropped {item} at {' '.join(location)}"
        case _:
            return f"Unknown command: {command}"

print(process_command("quit"))
print(process_command("go north"))
print(process_command("go south fast"))
print(process_command("pick up sword"))
print(process_command("drop shield in the cave"))

# Matching data structures (dicts)
def process_event(event: dict) -> str:
    match event:
        case {"type": "click", "button": button, "x": x, "y": y}:
            return f"Clicked {button} at ({x}, {y})"
        case {"type": "keydown", "key": str(key)}:
            return f"Key pressed: {key}"
        case {"type": "scroll", "delta": delta} if delta > 0:
            return "Scrolling down"
        case {"type": "scroll", "delta": delta}:
            return "Scrolling up"
        case {"type": type_name}:
            return f"Unknown event type: {type_name}"
        case _:
            return "Invalid event"

events = [
    {"type": "click", "button": "left", "x": 100, "y": 200},
    {"type": "keydown", "key": "Enter"},
    {"type": "scroll", "delta": 3},
    {"type": "scroll", "delta": -2},
]
for e in events:
    print(process_event(e))

# Matching class instances
from dataclasses import dataclass

@dataclass
class Point:
    x: float
    y: float

@dataclass
class Circle:
    center: Point
    radius: float

@dataclass
class Rectangle:
    top_left: Point
    bottom_right: Point

def describe_shape(shape) -> str:
    match shape:
        case Circle(center=Point(x=0, y=0), radius=r):
            return f"Circle centered at origin, radius {r}"
        case Circle(center=Point(x=x, y=y), radius=r):
            return f"Circle at ({x},{y}), radius {r}"
        case Rectangle(
            top_left=Point(x=x1, y=y1),
            bottom_right=Point(x=x2, y=y2)
        ):
            w, h = abs(x2-x1), abs(y2-y1)
            return f"Rectangle {w}x{h} at ({x1},{y1})"
        case _:
            return "Unknown shape"

shapes = [
    Circle(Point(0, 0), 5),
    Circle(Point(3, 4), 2),
    Rectangle(Point(0, 0), Point(10, 5)),
]
for s in shapes:
    print(describe_shape(s))

# ── POSITIONAL-ONLY PARAMS ─────────

def greet(name, /, greeting="Hello", *, punctuation="!"):
    return f"{greeting}, {name}{punctuation}"

print(greet("Alice"))               # Hello, Alice!
print(greet("Bob", "Hi"))           # Hi, Bob!
print(greet("Carol", punctuation="?"))  # Hello, Carol?
# greet(name="Dave")  → TypeError (name is positional-only)

# ── EXCEPTION GROUPS (Python 3.11+) ─

# Catching multiple unrelated exceptions from concurrent code
async def gather_errors():
    # raise ExceptionGroup("multiple errors", [
    #     ValueError("bad value"),
    #     TypeError("bad type"),
    #     KeyError("bad key"),
    # ])
    pass

# try:
#     await gather_errors()
# except* ValueError as eg:
#     print(f"Value errors: {eg.exceptions}")
# except* TypeError as eg:
#     print(f"Type errors: {eg.exceptions}")

# ── TYPE PARAMETER SYNTAX (3.12+) ──

# Old way (3.11 and below):
from typing import TypeVar, Generic
T = TypeVar("T")
class OldStack(Generic[T]):
    def push(self, item: T) -> None: ...
    def pop(self) -> T: ...

# New way (3.12+):
# class NewStack[T]:
#     def push(self, item: T) -> None: ...
#     def pop(self) -> T: ...

# def first[T](items: list[T]) -> T:
#     return items[0]

print("All modern Python features demonstrated!")

📝 KEY POINTS:
✅ Walrus := assigns and returns in one expression — eliminates redundant computation
✅ match/case is structural — matches SHAPES not just values
✅ match with guards: case x if condition  (the "if" inside match)
✅ Pattern variables capture the matched part: case [x, y]: captures x and y
✅ Positional-only params (/) prevent callers from using keyword syntax
✅ OR patterns with |: case "yes" | "y" | "Y":
❌ Walrus in regular assignments (x := 5) is frowned on — use regular =
❌ match is NOT the same as switch — it's structural pattern matching
❌ Captured pattern variables must be simple names, not dotted (can't use obj.attr as pattern var)
''',
  quiz: [
    Quiz(question: 'What does the walrus operator := do?', options: [
      QuizOption(text: 'Compares two values for strict equality', correct: false),
      QuizOption(text: 'Assigns a value AND returns it, usable inside expressions', correct: true),
      QuizOption(text: 'Creates a deep copy of a variable', correct: false),
      QuizOption(text: 'Declares a final (constant) variable', correct: false),
    ]),
    Quiz(question: 'In match/case, what does "case _:" do?', options: [
      QuizOption(text: 'Matches None values only', correct: false),
      QuizOption(text: 'Acts as a wildcard — matches anything not matched by earlier cases', correct: true),
      QuizOption(text: 'Matches empty strings and empty collections', correct: false),
      QuizOption(text: 'It is a syntax error', correct: false),
    ]),
    Quiz(question: 'What does the / in def func(a, b, /, c) mean?', options: [
      QuizOption(text: 'a and b can only be passed as keyword arguments', correct: false),
      QuizOption(text: 'a and b can only be passed positionally — not as keyword arguments', correct: true),
      QuizOption(text: 'c is optional', correct: false),
      QuizOption(text: 'The function supports division', correct: false),
    ]),
  ],
);
