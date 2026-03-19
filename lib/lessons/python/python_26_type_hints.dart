import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson26 = Lesson(
  language: 'Python',
  title: 'Type Hints & Annotations',
  content: '''
🎯 METAPHOR:
Type hints are like labels on kitchen containers.
Python doesn't FORCE you to label them — it's optional.
But imagine opening a shelf of unlabeled containers:
is this sugar or salt? flour or powdered sugar?
When you label everything (add type hints), you and
your teammates know exactly what each container holds.
Your text editor (IDE) becomes a super-smart sous chef
that yells "You're about to put salt in the cake batter!"
before you make a mistake. The labels don't change the
food inside — they just make the kitchen run more safely.

📖 EXPLANATION:
Type hints (PEP 484) let you annotate variable and
function types. Python DOES NOT enforce them at runtime
— they're hints for humans and tools.
Tools like mypy, pyright, and IDEs use them for
static analysis to catch bugs before running code.

─────────────────────────────────────
📐 BASIC SYNTAX
─────────────────────────────────────
# Variable annotations
name: str = "Alice"
age: int = 30
price: float = 9.99
active: bool = True

# Function annotations
def greet(name: str) -> str:
    return f"Hello, {name}!"

def add(x: int, y: int) -> int:
    return x + y

def log(msg: str) -> None:    # -> None = returns nothing
    print(msg)

─────────────────────────────────────
📦 TYPING MODULE (Python 3.5-3.8)
─────────────────────────────────────
from typing import List, Dict, Tuple, Set, Optional,
                   Union, Any, Callable, TypeVar,
                   Generator, Iterator, Sequence,
                   Mapping, MutableMapping

─────────────────────────────────────
✨ MODERN TYPE HINTS (Python 3.9+)
─────────────────────────────────────
Python 3.9+ can use built-in types directly:
  list[int]     instead of  List[int]
  dict[str,int] instead of  Dict[str,int]
  tuple[int,str] instead of Tuple[int,str]
  set[str]      instead of  Set[str]

Python 3.10+ pipe union syntax:
  int | None    instead of  Optional[int]
  int | str     instead of  Union[int, str]

─────────────────────────────────────
🔑 KEY TYPES
─────────────────────────────────────
Optional[X]  = X | None — value might be absent
Union[X,Y]   = X | Y — value is one of these types
Any          = any type — opt out of checking
Callable     = a function/callable type
TypeVar      = generic type variable
Literal      = only specific values allowed
Final        = constant — should not be reassigned
ClassVar     = class variable, not instance
Protocol     = structural subtyping (duck typing)
TypedDict    = dict with specific key types
NamedTuple   = named tuple with types

─────────────────────────────────────
🔍 RUNTIME TYPE INTROSPECTION
─────────────────────────────────────
import typing
hints = typing.get_type_hints(func)
function.__annotations__   # raw annotations dict

💻 CODE:
from __future__ import annotations  # for forward references
from typing import (Optional, Union, Any, Callable,
                    TypeVar, Generic, Protocol,
                    TypedDict, Literal, Final, ClassVar)
from collections.abc import Sequence, Mapping, Iterator

# Basic variable annotations
name: str = "Alice"
age: int = 30
scores: list[float] = [95.5, 87.0, 92.3]
lookup: dict[str, int] = {"apple": 1, "banana": 2}
coords: tuple[float, float] = (3.14, 2.71)

# Function annotations
def greet(name: str, times: int = 1) -> str:
    return (f"Hello, {name}! " * times).strip()

def process(items: list[int]) -> dict[str, int]:
    return {"min": min(items), "max": max(items), "sum": sum(items)}

# Optional — value might be None
def find_user(user_id: int) -> Optional[str]:
    users = {1: "Alice", 2: "Bob"}
    return users.get(user_id)   # returns str or None

# Union — multiple possible types
def stringify(value: Union[int, float, bool]) -> str:
    return str(value)

# Python 3.10+ syntax (cleaner!)
def find(query: str) -> str | None:
    return None

def accept(value: int | float | str) -> str:
    return str(value)

# Callable type
from collections.abc import Callable

def apply(func: Callable[[int, int], int], a: int, b: int) -> int:
    return func(a, b)

print(apply(lambda x, y: x + y, 3, 4))   # 7

# TypeVar — generic functions
T = TypeVar('T')

def first(items: list[T]) -> T:
    return items[0]

print(first([1, 2, 3]))      # 1 (type: int)
print(first(["a", "b"]))    # a (type: str)

# TypeVar with bounds
Numeric = TypeVar('Numeric', int, float)

def double(x: Numeric) -> Numeric:
    return x * 2

# TypedDict — typed dictionary
class Movie(TypedDict):
    title: str
    year: int
    rating: float

def get_movie() -> Movie:
    return {"title": "Inception", "year": 2010, "rating": 8.8}

# Literal — only specific values
Direction = Literal["north", "south", "east", "west"]

def move(direction: Direction, steps: int) -> str:
    return f"Moving {direction} {steps} steps"

# Final — constant (don't reassign!)
MAX_CONNECTIONS: Final = 100
APP_NAME: Final[str] = "MyApp"

# ClassVar — class variable
class Counter:
    count: ClassVar[int] = 0
    name: str

    def __init__(self, name: str) -> None:
        self.name = name
        Counter.count += 1

# Protocol — structural subtyping (duck typing)
class Drawable(Protocol):
    def draw(self) -> None: ...

class Circle:
    def draw(self) -> None:
        print("Drawing circle")

class Square:
    def draw(self) -> None:
        print("Drawing square")

def render(shape: Drawable) -> None:
    shape.draw()   # works with ANY class that has draw()

render(Circle())
render(Square())

# Generic class
class Stack(Generic[T]):
    def __init__(self) -> None:
        self._items: list[T] = []

    def push(self, item: T) -> None:
        self._items.append(item)

    def pop(self) -> T:
        return self._items.pop()

    def peek(self) -> T:
        return self._items[-1]

int_stack: Stack[int] = Stack()
int_stack.push(1)
int_stack.push(2)
print(int_stack.pop())   # 2

# NamedTuple with types
from typing import NamedTuple

class Point(NamedTuple):
    x: float
    y: float
    label: str = ""   # with default

p = Point(1.0, 2.0, "origin")
print(p.x, p.y, p.label)

# Get type hints at runtime
import typing
def add(x: int, y: int) -> int: return x + y
print(typing.get_type_hints(add))
# {'x': <class 'int'>, 'y': <class 'int'>, 'return': <class 'int'>}

# dataclass with types (full OOP with type checking)
from dataclasses import dataclass, field

@dataclass
class User:
    name: str
    age: int
    email: str = ""
    tags: list[str] = field(default_factory=list)

u = User("Alice", 30)
print(u)  # User(name='Alice', age=30, email='', tags=[])

📝 KEY POINTS:
✅ Type hints are optional — Python doesn't enforce them at runtime
✅ Use them anyway — they help IDEs, mypy, and your teammates
✅ Python 3.9+: use list[int], dict[str,int] directly (no import needed)
✅ Python 3.10+: use int | None instead of Optional[int]
✅ Optional[X] means "X or None" — use when value might be absent
✅ TypeVar enables generic functions/classes that work with any type
✅ Protocol enables structural (duck) typing — no explicit inheritance needed
❌ Type hints are NOT enforced at runtime — wrong types won't raise errors
❌ Adding -> None is better than no return annotation on void functions
❌ Avoid Any — it opts out of type checking entirely
''',
  quiz: [
    Quiz(question: 'What does Optional[str] mean in a type hint?', options: [
      QuizOption(text: 'The parameter is optional and can be skipped', correct: false),
      QuizOption(text: 'The value can be a str or None', correct: true),
      QuizOption(text: 'The value must be any type except None', correct: false),
      QuizOption(text: 'The value will be auto-converted to str', correct: false),
    ]),
    Quiz(question: 'Does Python enforce type hints at runtime?', options: [
      QuizOption(text: 'Yes — passing the wrong type raises a TypeError', correct: false),
      QuizOption(text: 'No — type hints are only for tools and humans, not enforced by Python', correct: true),
      QuizOption(text: 'Only for function return types, not parameters', correct: false),
      QuizOption(text: 'Only in Python 3.10+', correct: false),
    ]),
    Quiz(question: 'What is the modern Python 3.10+ syntax for "int or None"?', options: [
      QuizOption(text: 'Optional[int]', correct: false),
      QuizOption(text: 'Union[int, None]', correct: false),
      QuizOption(text: 'int | None', correct: true),
      QuizOption(text: 'int?', correct: false),
    ]),
  ],
);
