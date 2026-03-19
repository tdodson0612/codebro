import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson27 = Lesson(
  language: 'Python',
  title: 'Dataclasses',
  content: '''
🎯 METAPHOR:
@dataclass is like a form auto-filler for your class.
Without it, you write the same boilerplate over and over:
"Hello, I'm __init__, and I take name, age, email, score,
and I set self.name = name, self.age = age, self.email = email..."
With @dataclass, you write the FORM (the field names and types),
and Python auto-fills __init__, __repr__, __eq__, and optionally
__hash__, __lt__, __gt__, and more. You describe WHAT the data
looks like — Python handles the mechanics.

📖 EXPLANATION:
Dataclasses (PEP 557, Python 3.7+) automatically generate
common dunder methods from field declarations.

─────────────────────────────────────
📐 BASIC SYNTAX
─────────────────────────────────────
from dataclasses import dataclass, field

@dataclass
class Point:
    x: float
    y: float

Point automatically gets:
  __init__(self, x, y)
  __repr__  → Point(x=1.0, y=2.0)
  __eq__    → compares all fields

─────────────────────────────────────
⚙️  @dataclass OPTIONS
─────────────────────────────────────
@dataclass(
  init=True,       # generate __init__
  repr=True,       # generate __repr__
  eq=True,         # generate __eq__
  order=False,     # generate __lt__, __le__, __gt__, __ge__
  frozen=False,    # if True, instances are immutable!
  slots=False,     # if True, use __slots__ (faster, less memory)
  kw_only=False,   # all fields keyword-only in __init__
  match_args=True, # for match/case pattern matching
)

─────────────────────────────────────
📦 FIELD DEFAULTS
─────────────────────────────────────
Simple default:   name: str = "Unknown"
Mutable default:  tags: list = field(default_factory=list)
  ← Never use tags: list = [] — shared across instances!
Exclude from repr: field(repr=False)
Exclude from compare: field(compare=False)
Metadata:          field(metadata={"unit": "kg"})

─────────────────────────────────────
🏗️  POST-INIT PROCESSING
─────────────────────────────────────
def __post_init__(self):
    # runs after __init__, for validation/derived fields
    self.full_name = f"{self.first} {self.last}"

─────────────────────────────────────
🔒 FROZEN DATACLASSES
─────────────────────────────────────
@dataclass(frozen=True)
Instances become immutable like namedtuples.
Automatically generates __hash__ too.
Perfect for use as dictionary keys.

─────────────────────────────────────
🧬 INHERITANCE WITH DATACLASSES
─────────────────────────────────────
@dataclass
class Animal:
    name: str
    age: int

@dataclass
class Dog(Animal):
    breed: str   # must come after parent fields

💻 CODE:
from dataclasses import dataclass, field, asdict, astuple, replace
from typing import Optional, ClassVar

# Basic dataclass
@dataclass
class Point:
    x: float
    y: float

p1 = Point(1.0, 2.0)
p2 = Point(1.0, 2.0)
p3 = Point(3.0, 4.0)

print(p1)          # Point(x=1.0, y=2.0)
print(p1 == p2)    # True  (compares all fields)
print(p1 == p3)    # False

# With defaults
@dataclass
class User:
    name: str
    age: int
    email: str = ""
    active: bool = True
    tags: list[str] = field(default_factory=list)   # ← must use field() for mutable!
    score: float = field(default=0.0, repr=False)   # hidden from repr

u = User("Alice", 30)
print(u)   # User(name='Alice', age=30, email='', active=True, tags=[])
u.tags.append("admin")
print(u.tags)

# __post_init__ for validation and derived fields
@dataclass
class Person:
    first_name: str
    last_name: str
    age: int
    full_name: str = field(init=False)   # not in __init__!

    def __post_init__(self):
        if self.age < 0:
            raise ValueError(f"Age cannot be negative: {self.age}")
        self.full_name = f"{self.first_name} {self.last_name}"

p = Person("John", "Doe", 25)
print(p.full_name)    # John Doe

# Ordered dataclass (enables <, <=, >, >=)
@dataclass(order=True)
class Version:
    major: int
    minor: int
    patch: int

    def __str__(self):
        return f"{self.major}.{self.minor}.{self.patch}"

v1 = Version(1, 2, 3)
v2 = Version(2, 0, 0)
v3 = Version(1, 2, 3)

print(v1 < v2)     # True
print(v1 == v3)    # True
versions = [Version(1,9,0), Version(2,0,0), Version(1,2,3)]
print(sorted(versions))  # sorted by (major, minor, patch)

# Frozen (immutable) dataclass
@dataclass(frozen=True)
class Color:
    r: int
    g: int
    b: int

    def __str__(self):
        return f"rgb({self.r},{self.g},{self.b})"

red = Color(255, 0, 0)
print(red)

try:
    red.r = 100   # TypeError!
except Exception as e:
    print(f"Immutable: {e}")

# Frozen dataclasses can be dict keys!
palette = {
    Color(255, 0, 0): "red",
    Color(0, 255, 0): "green",
    Color(0, 0, 255): "blue"
}

# asdict and astuple — convert to plain types
@dataclass
class Student:
    name: str
    grades: list[float]
    gpa: float = field(init=False)

    def __post_init__(self):
        self.gpa = sum(self.grades) / len(self.grades)

s = Student("Alice", [90.0, 85.5, 92.0])
print(asdict(s))     # {'name': 'Alice', 'grades': [...], 'gpa': 89.16...}
print(astuple(s))    # ('Alice', [90.0, 85.5, 92.0], 89.16...)

# replace() — create modified copy (like namedtuple._replace)
s2 = replace(s, name="Bob", grades=[75.0, 80.0, 78.0])
print(s2)

# ClassVar — class-level variable, not an instance field
@dataclass
class AppConfig:
    debug: bool = False
    max_connections: int = 100
    _instances: ClassVar[int] = 0   # not in __init__!

    def __post_init__(self):
        AppConfig._instances += 1

# Dataclass inheritance
@dataclass
class Vehicle:
    make: str
    model: str
    year: int

@dataclass
class Car(Vehicle):
    num_doors: int = 4
    electric: bool = False

car = Car("Tesla", "Model 3", 2024, electric=True)
print(car)  # Car(make='Tesla', model='Model 3', year=2024, num_doors=4, electric=True)

# kw_only (Python 3.10+) — all fields keyword-only
@dataclass(kw_only=True)
class Config:
    host: str
    port: int
    debug: bool = False

cfg = Config(host="localhost", port=5432)
# Config(host, port) not Config("localhost", 5432) — keyword required

# slots=True (Python 3.10+) — more memory efficient
@dataclass(slots=True)
class FastPoint:
    x: float
    y: float

import sys
import tracemalloc
fp = FastPoint(1.0, 2.0)
rp = Point(1.0, 2.0)
print(f"FastPoint uses __slots__ = {hasattr(fp, '__slots__')}")

📝 KEY POINTS:
✅ @dataclass auto-generates __init__, __repr__, __eq__
✅ Use field(default_factory=list) for mutable defaults — NEVER []
✅ __post_init__ runs after __init__ for validation and derived fields
✅ @dataclass(frozen=True) makes instances immutable + hashable
✅ @dataclass(order=True) enables comparison operators <, >, <=, >=
✅ asdict() and astuple() convert to plain Python types (for JSON etc.)
✅ replace() creates a modified copy without mutating the original
❌ Don't use mutable defaults like tags: list = [] — use field(default_factory=list)
❌ Fields with defaults must come after fields without defaults
❌ @dataclass(frozen=True) objects cannot be modified after creation
''',
  quiz: [
    Quiz(question: 'Why must mutable defaults use field(default_factory=list) instead of []?', options: [
      QuizOption(text: 'field() is required syntax — [] would be a SyntaxError', correct: false),
      QuizOption(text: 'Without field(), the same list object is shared across ALL instances', correct: true),
      QuizOption(text: 'Lists are not supported as dataclass fields', correct: false),
      QuizOption(text: 'default_factory makes the list immutable', correct: false),
    ]),
    Quiz(question: 'What does @dataclass(frozen=True) do?', options: [
      QuizOption(text: 'Prevents the class from being subclassed', correct: false),
      QuizOption(text: 'Makes instances immutable and automatically generates __hash__', correct: true),
      QuizOption(text: 'Freezes all ClassVar attributes', correct: false),
      QuizOption(text: 'Disables the __eq__ method', correct: false),
    ]),
    Quiz(question: 'When does __post_init__ run?', options: [
      QuizOption(text: 'Before __init__ for pre-validation', correct: false),
      QuizOption(text: 'After __init__, allowing derived fields and validation', correct: true),
      QuizOption(text: 'Only when the class is defined', correct: false),
      QuizOption(text: 'It replaces __init__ entirely', correct: false),
    ]),
  ],
);
