import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson35 = Lesson(
  language: 'Python',
  title: 'Enums',
  content: """
🎯 METAPHOR:
An enum is like a traffic light.
A traffic light has exactly THREE states: RED, YELLOW, GREEN.
Not "red-ish", not 4, not "stop" — exactly those three named
states. Without an enum, you might use strings ("red", "green")
or numbers (0, 1, 2) — but then someone could accidentally pass
"purple" or 99 and your code would silently accept invalid data.
An enum is a locked box of valid options — you can only choose
from the defined set. It makes invalid states unrepresentable.

📖 EXPLANATION:
Enums (enumerations) define a fixed set of named constants.
Python's enum module (Python 3.4+) provides Enum, IntEnum,
Flag, IntFlag, and StrEnum (3.11+) base classes.

─────────────────────────────────────
📐 BASIC SYNTAX
─────────────────────────────────────
from enum import Enum, auto

class Color(Enum):
    RED   = 1
    GREEN = 2
    BLUE  = 3

# Or use auto() to auto-number:
class Direction(Enum):
    NORTH = auto()
    SOUTH = auto()
    EAST  = auto()
    WEST  = auto()

─────────────────────────────────────
🔑 KEY PROPERTIES
─────────────────────────────────────
Color.RED          → <Color.RED: 1>
Color.RED.name     → "RED"
Color.RED.value    → 1
Color(1)           → Color.RED  (lookup by value)
Color["RED"]       → Color.RED  (lookup by name)

─────────────────────────────────────
🆚 ENUM VARIANTS
─────────────────────────────────────
Enum     → base class, values are any type
IntEnum  → values are ints, comparable to ints
StrEnum  → values are strings (Python 3.11+)
Flag     → supports bitwise operations (|, &, ~)
IntFlag  → Flag + int compatibility
auto()   → automatically assigns values

─────────────────────────────────────
🔗 FLAG — Bitmask Enums
─────────────────────────────────────
from enum import Flag, auto

class Permission(Flag):
    READ    = auto()   # 1
    WRITE   = auto()   # 2
    EXECUTE = auto()   # 4
    ALL     = READ | WRITE | EXECUTE

user_perms = Permission.READ | Permission.WRITE
Permission.EXECUTE in user_perms  → False
Permission.READ in user_perms     → True

💻 CODE:
from enum import Enum, IntEnum, Flag, StrEnum, auto

# Basic Enum
class Color(Enum):
    RED   = 1
    GREEN = 2
    BLUE  = 3

# Access
print(Color.RED)           # Color.RED
print(Color.RED.name)      # RED
print(Color.RED.value)     # 1
print(repr(Color.RED))     # <Color.RED: 1>

# Lookup by value and name
print(Color(2))            # Color.GREEN
print(Color["BLUE"])       # Color.BLUE

# Comparison
print(Color.RED == Color.RED)    # True
print(Color.RED == Color.BLUE)   # False
print(Color.RED is Color.RED)    # True (singletons!)

# Identity — enums are singletons
c = Color.RED
print(c is Color.RED)   # True — same object

# Iteration — all members
for color in Color:
    print(f"{color.name}: {color.value}")

# Membership check
print(Color.RED in Color)   # True

# auto() — automatic values
class Weekday(Enum):
    MONDAY    = auto()   # 1
    TUESDAY   = auto()   # 2
    WEDNESDAY = auto()   # 3
    THURSDAY  = auto()   # 4
    FRIDAY    = auto()   # 5
    SATURDAY  = auto()   # 6
    SUNDAY    = auto()   # 7

today = Weekday.WEDNESDAY
print(f"Day {today.value}: {today.name}")
print(f"Is weekend: {today in (Weekday.SATURDAY, Weekday.SUNDAY)}")

# Methods on Enum
class Planet(Enum):
    MERCURY = (3.303e+23, 2.4397e6)
    VENUS   = (4.869e+24, 6.0518e6)
    EARTH   = (5.976e+24, 6.37814e6)
    MARS    = (6.421e+23, 3.3972e6)

    def __init__(self, mass, radius):
        self.mass = mass        # kg
        self.radius = radius    # meters

    @property
    def surface_gravity(self):
        G = 6.67430e-11
        return G * self.mass / (self.radius ** 2)

    def weight_on(self, earth_weight_kg):
        return earth_weight_kg * self.surface_gravity / Planet.EARTH.surface_gravity

for planet in Planet:
    print(f"{planet.name:8s}: gravity = {planet.surface_gravity:.2f} m/s²")
    print(f"          100kg person weighs {planet.weight_on(100):.1f}kg")

# IntEnum — comparable to ints
class Priority(IntEnum):
    LOW    = 1
    MEDIUM = 2
    HIGH   = 3
    URGENT = 4

print(Priority.HIGH > Priority.LOW)    # True  (int comparison works)
print(Priority.URGENT == 4)            # True  (int comparison)
print(sorted([Priority.MEDIUM, Priority.LOW, Priority.URGENT]))

# Using in if/match
task_priority = Priority.HIGH
if task_priority >= Priority.HIGH:
    print("Process this soon!")

# StrEnum (Python 3.11+)
class Status(StrEnum):
    PENDING   = "pending"
    ACTIVE    = "active"
    INACTIVE  = "inactive"
    DELETED   = "deleted"

s = Status.ACTIVE
print(s == "active")    # True (string comparison works)
print(f"Status: {s}")   # Status: active  (no "Status.ACTIVE")

# Flag — bitwise permissions
class Permission(Flag):
    NONE    = 0
    READ    = auto()   # 1
    WRITE   = auto()   # 2
    EXECUTE = auto()   # 4
    ALL     = READ | WRITE | EXECUTE

user = Permission.READ | Permission.WRITE
admin = Permission.ALL

print(Permission.READ in user)     # True
print(Permission.EXECUTE in user)  # False
print(user & admin)                # Permission.READ|WRITE

# Grant and revoke permissions
user |= Permission.EXECUTE         # grant
print(Permission.EXECUTE in user)  # True
user &= ~Permission.WRITE          # revoke
print(Permission.WRITE in user)    # False

# Enum in match/case (Python 3.10+)
def describe_day(day: Weekday) -> str:
    match day:
        case Weekday.SATURDAY | Weekday.SUNDAY:
            return "Weekend! 🎉"
        case Weekday.MONDAY:
            return "Monday blues 😩"
        case Weekday.FRIDAY:
            return "TGIF! 🎊"
        case _:
            return f"Just a {day.name.title()}"

for day in Weekday:
    print(f"{day.name}: {describe_day(day)}")

# Enum aliases (same value → alias)
class HttpStatus(IntEnum):
    OK                  = 200
    CREATED             = 201
    NOT_MODIFIED        = 304
    BAD_REQUEST         = 400
    UNAUTHORIZED        = 401
    FORBIDDEN           = 403
    NOT_FOUND           = 404
    INTERNAL_ERROR      = 500

# Check enum in HTTP responses
def handle_response(status_code: int):
    try:
        status = HttpStatus(status_code)
    except ValueError:
        print(f"Unknown status: {status_code}")
        return
    match status:
        case HttpStatus.OK | HttpStatus.CREATED:
            print(f"✅ Success: {status.name}")
        case HttpStatus.NOT_FOUND:
            print("❌ Resource not found")
        case HttpStatus.INTERNAL_ERROR:
            print("💥 Server error")
        case _:
            print(f"ℹ️  {status.name} ({status.value})")

handle_response(200)
handle_response(404)
handle_response(500)
handle_response(999)

📝 KEY POINTS:
✅ Enums make invalid states unrepresentable
✅ Enum members are singletons — use "is" for comparison
✅ auto() assigns sequential values automatically
✅ IntEnum values work in integer comparisons and arithmetic
✅ Flag supports bitwise | & ~ for combining permissions
✅ Add methods to Enum for behavior alongside the constants
✅ StrEnum (3.11+) members work as strings directly
❌ Enum values are not ordered by default — use IntEnum for sorting
❌ Don't compare regular Enum members with == to raw values (use IntEnum/StrEnum)
❌ Avoid using 0 as a Flag value — it represents "no flags set"
""",
  quiz: [
    Quiz(question: 'What does auto() do in an Enum definition?', options: [
      QuizOption(text: 'Automatically generates names for unnamed members', correct: false),
      QuizOption(text: 'Automatically assigns incrementing integer values to members', correct: true),
      QuizOption(text: 'Automatically imports the enum everywhere it\'s needed', correct: false),
      QuizOption(text: 'Automatically makes the enum thread-safe', correct: false),
    ]),
    Quiz(question: 'When should you use IntEnum instead of Enum?', options: [
      QuizOption(text: 'When you need to compare enum members with raw integers or sort them', correct: true),
      QuizOption(text: 'When enum values can be any type', correct: false),
      QuizOption(text: 'When you need bitwise operations on the enum', correct: false),
      QuizOption(text: 'IntEnum is always preferred over Enum', correct: false),
    ]),
    Quiz(question: 'What does Permission.READ | Permission.WRITE create?', options: [
      QuizOption(text: 'A list of two permissions', correct: false),
      QuizOption(text: 'A combined Flag value representing both READ and WRITE permissions', correct: true),
      QuizOption(text: 'A ValueError — you cannot combine Flag members', correct: false),
      QuizOption(text: 'The integer sum of the two values', correct: false),
    ]),
  ],
);
