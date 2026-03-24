import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson79 = Lesson(
  language: 'Python',
  title: 'Type Checking Tools: mypy & pyright',
  content: """
🎯 METAPHOR:
mypy is like a spell-checker for your code's data types.
Your word processor doesn't prevent you from typing
"teh" — it underlines it and flags it before you send
the document. mypy doesn't stop you from writing
wrong types — it underlines the mistakes BEFORE you run
the code, before the bug reaches production. You wrote
a function that takes str but you're passing int?
mypy catches it. You returned None from a function that
says it returns str? mypy catches it. All caught before
a single line of code executes.

📖 EXPLANATION:
Static type checkers analyze Python code with type hints
and find type errors without running the program.
mypy is the original; pyright (from Microsoft) is faster
and powers VS Code's Python extension (Pylance).

─────────────────────────────────────
📦 TOOLS
─────────────────────────────────────
mypy     → pip install mypy; mypy myfile.py
pyright  → pip install pyright; pyright myfile.py
pytype   → Google's type checker
pyre     → Meta's type checker

─────────────────────────────────────
🔑 COMMON mypy OPTIONS
─────────────────────────────────────
mypy file.py              → check one file
mypy .                    → check all .py files
mypy --strict .           → maximum strictness
mypy --ignore-missing-imports → ignore missing stubs

pyproject.toml config:
[tool.mypy]
python_version = "3.11"
strict = true
ignore_missing_imports = true
files = ["src/"]

─────────────────────────────────────
📝 COMMON TYPE ERRORS CAUGHT
─────────────────────────────────────
• Passing wrong type to function
• Returning wrong type from function
• Accessing attribute that doesn't exist
• Calling None (NoneType has no methods)
• Ignoring Optional return values
• Incompatible types in containers
• Unreachable code after return
• Missing return in non-None function

─────────────────────────────────────
🛡️  TYPE NARROWING
─────────────────────────────────────
if isinstance(x, str):    → x is str after check
if x is not None:         → x is not None after check
match x:
  case str():             → x is str in that branch
assert isinstance(x, int) → x is int after assert

─────────────────────────────────────
🔧 TYPE: IGNORE
─────────────────────────────────────
x: int = "hello"  # type: ignore[assignment]
Suppresses a specific error on one line.
Use sparingly — it defeats the purpose!

💻 CODE:
from __future__ import annotations
from typing import Optional, Union, Any, overload, TYPE_CHECKING
from collections.abc import Sequence, Callable, Iterator

# ── WHAT MYPY CATCHES ─────────────

# EXAMPLE 1: Wrong argument type
def double(x: int) -> int:
    return x * 2

# double("hello")     # mypy error: Argument 1 has incompatible type "str"; expected "int"
# double(3.14)        # mypy error: Argument 1 has incompatible type "float"; expected "int"
print(double(5))      # OK: 10

# EXAMPLE 2: Missing return
def greet(name: str) -> str:
    if name:
        return f"Hello, {name}!"
    # mypy error: Missing return statement (when name is falsy)

# EXAMPLE 3: Optional not handled
def get_user_name(user_id: int) -> Optional[str]:
    users = {1: "Alice", 2: "Bob"}
    return users.get(user_id)

name = get_user_name(1)
# print(name.upper())  # mypy error: Item "None" of "str | None" has no attribute "upper"

# Fix: check for None first
if name is not None:
    print(name.upper())  # OK after narrowing

# EXAMPLE 4: Container type mismatch
numbers: list[int] = [1, 2, 3]
# numbers.append("four")  # mypy error: Argument 1 to "append" has incompatible type "str"

# ── TYPE NARROWING ─────────────────

from typing import Union

def process(value: Union[str, int, list]) -> str:
    if isinstance(value, str):
        return value.upper()        # mypy knows: str here
    elif isinstance(value, int):
        return str(value * 2)       # mypy knows: int here
    else:
        return ", ".join(str(x) for x in value)  # list here

print(process("hello"))   # HELLO
print(process(21))        # 42
print(process([1,2,3]))   # 1, 2, 3

# Narrowing with assert
def expects_string(x: str | None) -> str:
    assert x is not None, "x cannot be None"
    return x.upper()   # mypy knows x is str after assert

# Narrowing in match/case (Python 3.10+)
def classify(x: str | int | list) -> str:
    match x:
        case str():
            return f"string: {x.upper()}"
        case int():
            return f"integer: {x * 2}"
        case list():
            return f"list of {len(x)} items"

# ── STRICT MODE PATTERNS ───────────

# In strict mode, you need explicit types everywhere

def strict_function(
    items: Sequence[int],
    transform: Callable[[int], int],
    *,
    limit: Optional[int] = None
) -> list[int]:
    result = [transform(x) for x in items]
    if limit is not None:
        result = result[:limit]
    return result

print(strict_function([1, 2, 3, 4, 5], lambda x: x**2, limit=3))

# ── REVEAL_TYPE FOR DEBUGGING ──────

x = [1, 2, 3]
reveal_type(x)   # mypy outputs: Revealed type is "list[int]"
# This is ONLY for mypy — it raises NameError at runtime!
# Wrap in TYPE_CHECKING guard:

if TYPE_CHECKING:
    reveal_type(x)   # OK — only runs in type checker

# Python 3.11+ has runtime reveal_type that works:
# reveal_type(x)  # prints: Runtime type is 'list'

# ── FORWARD REFERENCES ─────────────

# When a class refers to itself (before it's fully defined):
from __future__ import annotations  # enables string annotations automatically

class Node:
    def __init__(self, value: int, next: Optional[Node] = None):
        self.value = value
        self.next = next    # Optional[Node] — self-referential

    def append(self, value: int) -> Node:
        new_node = Node(value)
        self.next = new_node
        return new_node

head = Node(1)
head.append(2).append(3)

# ── GENERICS IN PRACTICE ───────────

from typing import TypeVar, Generic
T = TypeVar("T")

class Stack(Generic[T]):
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

int_stack: Stack[int] = Stack()
int_stack.push(1)
int_stack.push(2)
val: int = int_stack.pop()   # mypy knows it's int, not Any

# ── PROTOCOL FOR DUCK TYPING ───────

from typing import Protocol, runtime_checkable

@runtime_checkable
class Drawable(Protocol):
    def draw(self) -> None: ...

def render(shape: Drawable) -> None:
    shape.draw()

class Circle:
    def draw(self) -> None:
        print("Drawing circle")

class Square:
    def draw(self) -> None:
        print("Drawing square")

# Both satisfy Drawable without inheriting from it!
render(Circle())
render(Square())

# ── TYPED DICT ────────────────────

from typing import TypedDict, NotRequired

class UserData(TypedDict):
    name: str
    email: str
    age: int
    role: NotRequired[str]   # optional key (Python 3.11+)

def create_user(data: UserData) -> str:
    return f"{data['name']} <{data['email']}>"

user: UserData = {"name": "Alice", "email": "alice@ex.com", "age": 30}
print(create_user(user))   # type-safe!

# ── MYPY CONFIGURATION ─────────────

MYPY_CONFIG = '''
# pyproject.toml
[tool.mypy]
python_version = "3.11"
strict = true
warn_return_any = true
warn_unused_configs = true
ignore_missing_imports = false
show_error_codes = true
files = ["src/", "tests/"]

# Per-module overrides
[[tool.mypy.overrides]]
module = "third_party_lib.*"
ignore_missing_imports = true

[[tool.mypy.overrides]]
module = "tests.*"
disallow_untyped_defs = false  # relax for test files
'''

PYRIGHT_CONFIG = '''
# pyrightconfig.json
{
  "pythonVersion": "3.11",
  "typeCheckingMode": "strict",
  "reportMissingImports": true,
  "reportMissingTypeStubs": false,
  "include": ["src"],
  "exclude": ["tests", "**/__pycache__"]
}
'''

# ── GRADUAL TYPING STRATEGY ────────

GRADUAL_STRATEGY = '''
Phase 1: Add types to new code only
  → Run mypy with --ignore-missing-imports
  → Fix errors only in new files

Phase 2: Add types to critical paths
  → Add types to functions that are called everywhere
  → Add types to public API functions

Phase 3: Increase strictness
  → Enable more mypy flags gradually
  → Add types to remaining files

Phase 4: Full strict mode
  → mypy --strict . with zero errors
  → CI blocks PRs that introduce type errors
'''

print("Type checking setup complete!")
print("Run: pip install mypy && mypy .")
print("Or:  pip install pyright && pyright .")

📝 KEY POINTS:
✅ Type checkers find bugs without running code — use them from the start
✅ Optional[str] means str | None — always check for None before using!
✅ isinstance() checks enable type narrowing — mypy understands them
✅ reveal_type(x) in mypy mode shows what type mypy inferred
✅ from __future__ import annotations enables self-referential type hints
✅ Protocols enable structural typing — duck typing with static checking
✅ Add type hints gradually — you don't need to type everything at once
❌ # type: ignore is a last resort — fix the real issue instead
❌ Don't use Any unless truly necessary — it disables type checking
❌ Type hints alone don't enforce types at runtime — use pydantic for that
""",
  quiz: [
    Quiz(question: 'What is the purpose of a static type checker like mypy?', options: [
      QuizOption(text: 'It runs your code faster by optimizing types', correct: false),
      QuizOption(text: 'It finds type errors in your code without running it', correct: true),
      QuizOption(text: 'It enforces types at runtime like a compiled language', correct: false),
      QuizOption(text: 'It automatically adds type hints to untyped code', correct: false),
    ]),
    Quiz(question: 'What is type narrowing in Python?', options: [
      QuizOption(text: 'Converting a wider type to a narrower one like float to int', correct: false),
      QuizOption(text: 'After an isinstance() or None-check, the type checker knows the more specific type', correct: true),
      QuizOption(text: 'Reducing the number of types a function can accept', correct: false),
      QuizOption(text: 'Using TypeVar to constrain generic types', correct: false),
    ]),
    Quiz(question: 'What does Optional[str] mean in a type hint?', options: [
      QuizOption(text: 'The parameter is optional and can be omitted', correct: false),
      QuizOption(text: 'The value can be str or None', correct: true),
      QuizOption(text: 'The value can be any type of string subclass', correct: false),
      QuizOption(text: 'The value is optional and defaults to ""', correct: false),
    ]),
  ],
);
