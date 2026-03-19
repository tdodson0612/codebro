import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson37 = Lesson(
  language: 'Python',
  title: 'Dunder Methods (Magic Methods)',
  content: '''
🎯 METAPHOR:
Dunder methods are like a universal remote control protocol.
Every TV brand (your custom class) supports the SAME button
names: POWER, VOLUME_UP, CHANNEL. When you press VOLUME_UP
(call len(obj) or obj + other), Python looks for that button's
implementation (__len__ or __add__). If your class implements
them, your objects respond to Python's built-in operations
just like built-in types. Your class can be treated as if
it's part of the language itself — and that's the goal.

📖 EXPLANATION:
Dunder (double-underscore) methods hook into Python's
built-in operators and functions. Implementing them lets
your objects behave like native Python types.

─────────────────────────────────────
🏗️  LIFECYCLE
─────────────────────────────────────
__new__(cls)    → creates the object (before __init__)
__init__(self)  → initializes the object
__del__(self)   → destructor (called before garbage collection)

─────────────────────────────────────
📝 REPRESENTATION
─────────────────────────────────────
__str__(self)   → str(obj), print(obj) — human readable
__repr__(self)  → repr(obj) — developer readable, unambiguous
__format__(self, spec) → f"{obj:spec}" formatting
__bytes__(self) → bytes(obj)

Rule: __repr__ should ideally be eval()-able back to the object.
  repr(Point(1,2)) == "Point(x=1, y=2)"

─────────────────────────────────────
🔢 NUMERIC OPERATIONS
─────────────────────────────────────
__add__(self, other)   → self + other
__sub__                → self - other
__mul__                → self * other
__truediv__            → self / other
__floordiv__           → self // other
__mod__                → self % other
__pow__                → self ** other
__neg__                → -self
__pos__                → +self
__abs__                → abs(self)
__round__              → round(self)

Reflected (right-side): __radd__, __rsub__, etc.
In-place:               __iadd__, __isub__, etc.

─────────────────────────────────────
📊 COMPARISON
─────────────────────────────────────
__eq__(self, other)    → self == other
__ne__                 → self != other
__lt__                 → self < other
__le__                 → self <= other
__gt__                 → self > other
__ge__                 → self >= other
__hash__               → hash(self) — needed if __eq__ defined!

─────────────────────────────────────
📦 CONTAINER PROTOCOL
─────────────────────────────────────
__len__(self)           → len(obj)
__getitem__(self, key)  → obj[key]
__setitem__(self, k, v) → obj[key] = value
__delitem__(self, key)  → del obj[key]
__contains__(self, item) → item in obj
__iter__(self)          → for x in obj
__next__(self)          → next(obj)
__reversed__(self)      → reversed(obj)

─────────────────────────────────────
⚙️  CALLABLE & CONTEXT
─────────────────────────────────────
__call__(self, *args)   → obj()
__enter__(self)         → with obj:
__exit__(self, ...)     → end of with block

─────────────────────────────────────
📋 ATTRIBUTE ACCESS
─────────────────────────────────────
__getattr__(self, name)         → obj.name (fallback)
__setattr__(self, name, value)  → obj.name = value
__delattr__(self, name)         → del obj.name
__getattribute__(self, name)    → every attribute access
__dir__(self)                   → dir(obj)

💻 CODE:
from math import sqrt

# A complete Vector class demonstrating many dunders
class Vector:
    def __init__(self, *components):
        self.components = tuple(components)

    # ── REPRESENTATION ────────────
    def __repr__(self):
        args = ", ".join(map(str, self.components))
        return f"Vector({args})"

    def __str__(self):
        arrow = ", ".join(map(str, self.components))
        return f"⟨{arrow}⟩"

    def __format__(self, spec):
        if spec == "norm":
            return f"|{self}| = {abs(self):.4f}"
        return format(str(self), spec)

    # ── CONTAINER ─────────────────
    def __len__(self):
        return len(self.components)

    def __getitem__(self, index):
        return self.components[index]

    def __iter__(self):
        return iter(self.components)

    def __contains__(self, value):
        return value in self.components

    def __reversed__(self):
        return Vector(*reversed(self.components))

    # ── COMPARISON ────────────────
    def __eq__(self, other):
        if isinstance(other, Vector):
            return self.components == other.components
        return NotImplemented

    def __hash__(self):   # required if __eq__ is defined!
        return hash(self.components)

    def __lt__(self, other):
        return abs(self) < abs(other)

    # ── ARITHMETIC ────────────────
    def __add__(self, other):
        if len(self) != len(other):
            raise ValueError("Vectors must have same dimension")
        return Vector(*(a+b for a, b in zip(self, other)))

    def __sub__(self, other):
        return Vector(*(a-b for a, b in zip(self, other)))

    def __mul__(self, scalar):
        return Vector(*(c * scalar for c in self))

    def __rmul__(self, scalar):   # 3 * v (scalar on left)
        return self.__mul__(scalar)

    def __truediv__(self, scalar):
        return Vector(*(c / scalar for c in self))

    def __neg__(self):
        return Vector(*(-c for c in self))

    def __abs__(self):   # magnitude
        return sqrt(sum(c**2 for c in self))

    def __round__(self, n=0):
        return Vector(*(round(c, n) for c in self))

    def __bool__(self):
        return any(c != 0 for c in self)

    # Dot product as @
    def __matmul__(self, other):
        return sum(a*b for a, b in zip(self, other))

    # Scalar products as %
    def __mod__(self, n):
        return Vector(*(c % n for c in self))

# Usage
v1 = Vector(1, 2, 3)
v2 = Vector(4, 5, 6)

print(repr(v1))          # Vector(1, 2, 3)
print(str(v1))           # ⟨1, 2, 3⟩
print(f"{v1:norm}")      # |⟨1, 2, 3⟩| = 3.7417

print(v1 + v2)           # ⟨5, 7, 9⟩
print(v2 - v1)           # ⟨3, 3, 3⟩
print(v1 * 3)            # ⟨3, 6, 9⟩
print(3 * v1)            # ⟨3, 6, 9⟩ (uses __rmul__)
print(-v1)               # ⟨-1, -2, -3⟩
print(abs(v1))           # 3.7417...
print(round(abs(v1), 2)) # 3.74
print(v1 @ v2)           # 32 (dot product)

print(len(v1))           # 3
print(v1[0])             # 1
print(list(v1))          # [1, 2, 3]
print(2 in v1)           # True
print(v1 == Vector(1,2,3))  # True
print(v1 < v2)           # True (by magnitude)

# Sets/dicts work because we defined __hash__:
s = {v1, v2, Vector(1,2,3)}
print(len(s))   # 2 (v1 and Vector(1,2,3) are equal)

# Callable object
class Validator:
    def __init__(self, min_val, max_val):
        self.min_val = min_val
        self.max_val = max_val

    def __call__(self, value):
        return self.min_val <= value <= self.max_val

    def __repr__(self):
        return f"Validator({self.min_val}, {self.max_val})"

is_valid_age = Validator(0, 120)
is_valid_score = Validator(0, 100)

print(is_valid_age(25))    # True
print(is_valid_age(-5))    # False
print(is_valid_score(85))  # True

# Custom mapping (dict-like)
class FrozenDict:
    def __init__(self, **kwargs):
        self._data = dict(kwargs)

    def __getitem__(self, key):
        return self._data[key]

    def __contains__(self, key):
        return key in self._data

    def __len__(self):
        return len(self._data)

    def __iter__(self):
        return iter(self._data)

    def __repr__(self):
        items = ", ".join(f"{k}={v!r}" for k,v in self._data.items())
        return f"FrozenDict({items})"

    def keys(self):   return self._data.keys()
    def values(self): return self._data.values()
    def items(self):  return self._data.items()

    def __setitem__(self, key, value):
        raise TypeError("FrozenDict is immutable!")

fd = FrozenDict(x=1, y=2, z=3)
print(fd["x"])     # 1
print("y" in fd)   # True
print(len(fd))     # 3
for k, v in fd.items():
    print(f"{k}: {v}")

📝 KEY POINTS:
✅ __repr__ for devs (unambiguous); __str__ for users (readable)
✅ If you define __eq__, you MUST also define __hash__ (or it becomes unhashable)
✅ Define __radd__ etc. for when your object is on the RIGHT side of an operator
✅ __call__ makes instances callable like functions
✅ __iter__ + __next__ make objects iterable (for loops, comprehensions, etc.)
✅ Return NotImplemented (not raise) from operators when type is unsupported
❌ Don't define __del__ unless you truly need resource cleanup — Python's GC handles memory
❌ __getattribute__ intercepts ALL attribute access — be very careful or you'll loop
❌ Never mutate self in __hash__ — hash must be stable for dict/set keys
''',
  quiz: [
    Quiz(question: 'If you define __eq__ in a class, what else must you define?', options: [
      QuizOption(text: '__ne__ — to make inequality work', correct: false),
      QuizOption(text: '__hash__ — because Python removes it when __eq__ is defined', correct: true),
      QuizOption(text: '__lt__ — for full comparison support', correct: false),
      QuizOption(text: 'Nothing — __eq__ is self-contained', correct: false),
    ]),
    Quiz(question: 'What is the difference between __str__ and __repr__?', options: [
      QuizOption(text: '__str__ is called automatically; __repr__ is never called automatically', correct: false),
      QuizOption(text: '__str__ is for human-readable output; __repr__ is for unambiguous developer output', correct: true),
      QuizOption(text: '__repr__ is used only in repr() calls; __str__ is used everywhere', correct: false),
      QuizOption(text: 'They are identical — just different naming', correct: false),
    ]),
    Quiz(question: 'What does __radd__ handle?', options: [
      QuizOption(text: 'Right-side addition: when your object is on the RIGHT of the + operator', correct: true),
      QuizOption(text: 'Reverse subtraction', correct: false),
      QuizOption(text: 'In-place addition: a += b', correct: false),
      QuizOption(text: 'Recursive addition for nested objects', correct: false),
    ]),
  ],
);
