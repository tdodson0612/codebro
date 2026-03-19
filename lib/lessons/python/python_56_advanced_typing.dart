import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson56 = Lesson(
  language: 'Python',
  title: 'Advanced Type Hints & Generic Programming',
  content: '''
🎯 METAPHOR:
Generic programming is like a factory that can produce
any product, not just one type.
A regular factory: "We make red bicycles."
A generic factory: "We make [T]s — tell us what T is."
When you call Stack[int], T becomes int.
When you call Stack[str], T becomes str.
The factory logic is the same — only the product type changes.
TypeVar is how you name the T, and Generic[T] is how
you tell the class "this factory is parameterized."

📖 EXPLANATION:
Advanced typing covers TypeVar, Generic classes, Protocol,
Callable types, Literal, TypedDict, ParamSpec, TypeAlias,
and modern Python 3.12 type syntax.

─────────────────────────────────────
🔤 TYPEVAR — TYPE VARIABLES
─────────────────────────────────────
T = TypeVar("T")              → any type
S = TypeVar("S", int, float)  → bound to int or float
U = TypeVar("U", bound=Comparable) → must be subtype

─────────────────────────────────────
📦 GENERIC CLASSES
─────────────────────────────────────
from typing import Generic

class Stack(Generic[T]):
    def push(self, item: T) -> None: ...
    def pop(self) -> T: ...

stack: Stack[int] = Stack()

─────────────────────────────────────
🔗 CALLABLE TYPES
─────────────────────────────────────
Callable[[int, str], bool]    # (int, str) -> bool
Callable[..., int]            # any args, returns int
Callable[[], None]            # no args, returns None

─────────────────────────────────────
📚 TYPED COLLECTIONS
─────────────────────────────────────
list[int]           # Python 3.9+ (no List import)
dict[str, int]      # Python 3.9+
tuple[int, str, float]  # fixed-length tuple
tuple[int, ...]     # variable-length int tuple

─────────────────────────────────────
🔒 SPECIAL TYPES
─────────────────────────────────────
Literal["yes", "no"]  → only specific values allowed
Final[int]            → value cannot be reassigned
TypeAlias             → give a type a name
TypedDict             → dict with specific key types
NamedTuple            → tuple with named, typed fields
NewType               → create a distinct type alias
ParamSpec             → capture callable parameter specs
Concatenate           → used with ParamSpec
Self                  → for methods returning self
Never                 → function never returns (raises/loops)
NotRequired           → optional key in TypedDict

💻 CODE:
from __future__ import annotations
from typing import (TypeVar, Generic, Protocol, Callable,
                    Literal, TypedDict, NamedTuple, NewType,
                    overload, get_type_hints, cast, TYPE_CHECKING,
                    ClassVar, Final, TypeAlias, Any,
                    ParamSpec, Concatenate)
from collections.abc import Sequence, Iterator, Iterable
import functools

# ── TYPEVAR ───────────────────────

T = TypeVar("T")
K = TypeVar("K")
V = TypeVar("V")
N = TypeVar("N", int, float)           # constrained to int or float
C = TypeVar("C", bound="Comparable")  # must implement Comparable

# Generic function — works with any type
def first(items: Sequence[T]) -> T:
    return items[0]

def last(items: Sequence[T]) -> T:
    return items[-1]

print(first([1, 2, 3]))       # 1  — mypy infers T=int
print(first(["a", "b"]))     # 'a' — mypy infers T=str
print(last((10.0, 20.0)))    # 20.0 — T=float

# Constrained TypeVar
def add_numbers(a: N, b: N) -> N:
    return a + b

print(add_numbers(1, 2))       # 3
print(add_numbers(1.5, 2.5))   # 4.0
# add_numbers("a", "b") → type error!

# ── GENERIC CLASSES ───────────────

class Stack(Generic[T]):
    """Type-safe stack."""
    def __init__(self) -> None:
        self._items: list[T] = []

    def push(self, item: T) -> None:
        self._items.append(item)

    def pop(self) -> T:
        if not self._items:
            raise IndexError("Stack is empty")
        return self._items.pop()

    def peek(self) -> T:
        return self._items[-1]

    def __len__(self) -> int:
        return len(self._items)

    def __bool__(self) -> bool:
        return bool(self._items)

    def __iter__(self) -> Iterator[T]:
        yield from reversed(self._items)

int_stack: Stack[int] = Stack()
int_stack.push(1)
int_stack.push(2)
print(int_stack.pop())   # 2

str_stack: Stack[str] = Stack()
str_stack.push("hello")
str_stack.push("world")
for item in str_stack:
    print(item)

# Generic Pair
class Pair(Generic[K, V]):
    def __init__(self, key: K, value: V) -> None:
        self.key = key
        self.value = value

    def swap(self) -> Pair[V, K]:
        return Pair(self.value, self.key)

    def __repr__(self) -> str:
        return f"Pair({self.key!r}, {self.value!r})"

p = Pair("age", 30)
swapped = p.swap()
print(p)        # Pair('age', 30)
print(swapped)  # Pair(30, 'age')

# ── CALLABLE TYPES ────────────────

from collections.abc import Callable

def apply(func: Callable[[int], int], value: int) -> int:
    return func(value)

def apply_binary(func: Callable[[int, int], int], a: int, b: int) -> int:
    return func(a, b)

print(apply(lambda x: x * 2, 5))        # 10
print(apply_binary(lambda a, b: a + b, 3, 4))  # 7

# Higher-order function types
def compose(
    f: Callable[[int], int],
    g: Callable[[int], int]
) -> Callable[[int], int]:
    def composed(x: int) -> int:
        return f(g(x))
    return composed

double = lambda x: x * 2
add_one = lambda x: x + 1
double_then_add = compose(add_one, double)
print(double_then_add(5))   # 11  (5*2=10, then +1=11)

# ── LITERAL ──────────────────────

Direction = Literal["north", "south", "east", "west"]
HttpMethod = Literal["GET", "POST", "PUT", "DELETE", "PATCH"]
LogLevel = Literal["DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL"]

def move(direction: Direction, steps: int = 1) -> str:
    return f"Moving {direction} {steps} steps"

def http_request(method: HttpMethod, url: str) -> dict[str, Any]:
    return {"method": method, "url": url}

print(move("north"))           # OK
print(move("north", 3))        # OK
# move("up") → type error (not in Literal)

# ── TYPED DICT ────────────────────

class UserInfo(TypedDict):
    name: str
    email: str
    age: int

class PartialUserInfo(TypedDict, total=False):
    name: str          # optional
    email: str         # optional
    age: int           # optional

class Config(TypedDict):
    host: str
    port: int
    debug: bool
    extra: str    # NotRequired in 3.11+

def create_user(info: UserInfo) -> str:
    return f"Created {info['name']} ({info['email']})"

user: UserInfo = {"name": "Alice", "email": "alice@ex.com", "age": 30}
print(create_user(user))

# ── NAMED TUPLE ───────────────────

class Point(NamedTuple):
    x: float
    y: float
    label: str = ""

class RGB(NamedTuple):
    red: int
    green: int
    blue: int

    def as_hex(self) -> str:
        return f"#{self.red:02x}{self.green:02x}{self.blue:02x}"

    def __str__(self) -> str:
        return f"rgb({self.red},{self.green},{self.blue})"

p = Point(1.0, 2.0, "origin")
print(p.x, p.y, p.label)
x, y, label = p   # unpack like a tuple

color = RGB(255, 128, 0)
print(color.as_hex())   # #ff8000
print(str(color))       # rgb(255,128,0)

# ── NEWTYPE ───────────────────────

UserId = NewType("UserId", int)
ProductId = NewType("ProductId", int)

def get_user(user_id: UserId) -> dict:
    return {"id": user_id}

uid = UserId(42)
pid = ProductId(42)
# get_user(pid) → type error! They're different types
# Even though both are ints at runtime
print(get_user(uid))

# ── OVERLOAD ─────────────────────

@overload
def process(data: str) -> str: ...
@overload
def process(data: int) -> int: ...
@overload
def process(data: list) -> list: ...

def process(data):
    if isinstance(data, str):
        return data.upper()
    elif isinstance(data, int):
        return data * 2
    elif isinstance(data, list):
        return [process(x) for x in data]
    raise TypeError(f"Unsupported type: {type(data)}")

print(process("hello"))    # "HELLO"  — mypy knows: str in → str out
print(process(21))         # 42       — mypy knows: int in → int out
print(process([1, "a"]))   # [2, "A"]

# ── PARAMSPEC ─────────────────────

P = ParamSpec("P")
R = TypeVar("R")

def log_calls(func: Callable[P, R]) -> Callable[P, R]:
    """Decorator that preserves the function signature."""
    @functools.wraps(func)
    def wrapper(*args: P.args, **kwargs: P.kwargs) -> R:
        print(f"Calling {func.__name__}")
        result = func(*args, **kwargs)
        print(f"Done: {result!r}")
        return result
    return wrapper

@log_calls
def greet(name: str, times: int = 1) -> str:
    return (f"Hello {name}! " * times).strip()

result = greet("Alice", times=2)  # mypy knows args and return type!

# ── TYPE ALIAS ────────────────────

# Python 3.12+:
# type Matrix = list[list[float]]
# type Vector = list[float]

# Python 3.9-3.11:
Matrix: TypeAlias = list[list[float]]
Vector: TypeAlias = list[float]

def dot_product(a: Vector, b: Vector) -> float:
    return sum(x * y for x, y in zip(a, b))

v1: Vector = [1.0, 2.0, 3.0]
v2: Vector = [4.0, 5.0, 6.0]
print(dot_product(v1, v2))   # 32.0

📝 KEY POINTS:
✅ TypeVar lets you write functions that work with any type but preserve type info
✅ Generic[T] makes classes parameterizable: Stack[int], Stack[str]
✅ Literal restricts values to a specific set — better than plain str
✅ TypedDict gives dicts a typed schema — great for JSON/config data
✅ NewType creates semantically distinct types (UserId vs ProductId)
✅ @overload lets you declare multiple signatures for one function
✅ ParamSpec preserves decorator signatures for type checkers
❌ TypeVar constraints are checked by mypy/pyright, NOT at runtime
❌ NewType is only a type hint — runtime it's still just the base type
❌ Don't use Any unless truly necessary — it opts out of type checking
''',
  quiz: [
    Quiz(question: 'What is TypeVar("T") used for?', options: [
      QuizOption(text: 'Creating a new type with validation at runtime', correct: false),
      QuizOption(text: 'Declaring a placeholder type that gets filled in when the function or class is used', correct: true),
      QuizOption(text: 'Restricting a variable to one specific type', correct: false),
      QuizOption(text: 'Creating an enum of valid type names', correct: false),
    ]),
    Quiz(question: 'What is the purpose of NewType("UserId", int)?', options: [
      QuizOption(text: 'Creates a subclass of int with new behavior', correct: false),
      QuizOption(text: 'Creates a semantically distinct type so type checkers treat UserId and plain int as different', correct: true),
      QuizOption(text: 'Creates an int with a range restriction', correct: false),
      QuizOption(text: 'Aliases int so UserId is identical in all contexts', correct: false),
    ]),
    Quiz(question: 'When should you use @overload?', options: [
      QuizOption(text: 'When a function can accept different argument types and the return type depends on the argument type', correct: true),
      QuizOption(text: 'When you want to call the same function with different numbers of arguments', correct: false),
      QuizOption(text: 'When you need to override a method from a base class', correct: false),
      QuizOption(text: 'When the function needs to run differently on different platforms', correct: false),
    ]),
  ],
);
