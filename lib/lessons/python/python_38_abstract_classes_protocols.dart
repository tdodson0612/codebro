import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson38 = Lesson(
  language: 'Python',
  title: 'Abstract Classes & Protocols',
  content: '''
🎯 METAPHOR:
Abstract classes are like building codes.
They define the REQUIREMENTS a building must meet —
minimum ceiling height, fire exits, electrical wiring
standards — but they don't say what color to paint it.
Any building (subclass) in the city must follow the code
(implement abstract methods), or the inspector (Python)
will refuse to let it open. The code exists to ensure
all buildings share a reliable interface.

Protocols are like industry standards.
If something has USB-A connectors in the right shape,
it IS USB-A compatible — regardless of who made it.
No certificate required, no inheritance needed.
Just "if it looks right, it fits." Python checks the
shape of an object (does it have the right methods?)
without caring about its class hierarchy.

📖 EXPLANATION:
Abstract Base Classes (ABCs): enforce that subclasses
implement specific methods. Nominal typing.

Protocols: structural subtyping (duck typing with type checking).
Any class with the right methods satisfies a Protocol —
no explicit inheritance needed.

─────────────────────────────────────
🏛️  ABSTRACT BASE CLASSES (ABC)
─────────────────────────────────────
from abc import ABC, abstractmethod

class Animal(ABC):
    @abstractmethod
    def speak(self) -> str: ...   # must be implemented!

    @abstractmethod
    def move(self) -> None: ...

    def describe(self) -> str:    # concrete method!
        return f"I am a {type(self).__name__}"

─────────────────────────────────────
📦 ABC DECORATORS
─────────────────────────────────────
@abstractmethod          → must override in subclass
@abstractclassmethod     → abstract class method
@abstractstaticmethod    → abstract static method
@abstractproperty        → abstract property (use @property + @abstractmethod)

─────────────────────────────────────
🦆 PROTOCOLS (Python 3.8+)
─────────────────────────────────────
from typing import Protocol

class Drawable(Protocol):
    def draw(self) -> None: ...

Any class with a draw() method satisfies Drawable —
even without inheriting from it!
Checked by type checkers (mypy) not at runtime.

runtime_checkable makes isinstance() work with Protocols.

─────────────────────────────────────
🆚 ABC vs PROTOCOL
─────────────────────────────────────
ABC:      explicit inheritance, runtime enforcement
Protocol: structural ("duck") typing, static checking
          No inheritance needed — just the right methods

Use ABC when you want to share implementation + enforce interface.
Use Protocol when you want to type-check duck-typed code.

─────────────────────────────────────
📋 BUILT-IN ABCs (collections.abc)
─────────────────────────────────────
Iterable, Iterator, Generator
Sequence, MutableSequence
Mapping, MutableMapping
Set, MutableSet
Callable, Hashable, Sized
Container, Reversible

💻 CODE:
from abc import ABC, abstractmethod
from typing import Protocol, runtime_checkable
from collections.abc import Sequence, Mapping

# ── ABSTRACT BASE CLASSES ──────────

class Shape(ABC):
    """Abstract base class for all shapes."""

    def __init__(self, color: str = "black"):
        self.color = color

    @abstractmethod
    def area(self) -> float:
        """Return the area of the shape."""
        ...

    @abstractmethod
    def perimeter(self) -> float:
        """Return the perimeter of the shape."""
        ...

    @property
    @abstractmethod
    def name(self) -> str:
        """Return the shape's name."""
        ...

    # Concrete method — shared by all subclasses
    def describe(self) -> str:
        return (f"{self.color.title()} {self.name}: "
                f"area={self.area():.2f}, perimeter={self.perimeter():.2f}")

    def scale(self, factor: float) -> "Shape":
        """Create a scaled copy — subclasses should override."""
        raise NotImplementedError(f"{type(self).__name__} doesn't support scale()")

class Circle(Shape):
    def __init__(self, radius: float, color: str = "black"):
        super().__init__(color)
        self.radius = radius

    @property
    def name(self) -> str:
        return "Circle"

    def area(self) -> float:
        import math
        return math.pi * self.radius ** 2

    def perimeter(self) -> float:
        import math
        return 2 * math.pi * self.radius

    def scale(self, factor: float) -> "Circle":
        return Circle(self.radius * factor, self.color)

class Rectangle(Shape):
    def __init__(self, w: float, h: float, color: str = "black"):
        super().__init__(color)
        self.width = w
        self.height = h

    @property
    def name(self) -> str:
        return "Rectangle"

    def area(self) -> float:
        return self.width * self.height

    def perimeter(self) -> float:
        return 2 * (self.width + self.height)

class Triangle(Shape):
    def __init__(self, a: float, b: float, c: float, color: str = "black"):
        super().__init__(color)
        self.sides = (a, b, c)
        s = sum(self.sides) / 2
        self.area_val = (s*(s-a)*(s-b)*(s-c))**0.5

    @property
    def name(self) -> str:
        return "Triangle"

    def area(self) -> float:
        return self.area_val

    def perimeter(self) -> float:
        return sum(self.sides)

# Can't instantiate abstract class:
try:
    s = Shape()
except TypeError as e:
    print(f"Error: {e}")

shapes: list[Shape] = [
    Circle(5, "red"),
    Rectangle(4, 6, "blue"),
    Triangle(3, 4, 5, "green"),
]

for shape in shapes:
    print(shape.describe())

total_area = sum(s.area() for s in shapes)
print(f"Total area: {total_area:.2f}")

# Abstract class with register() — virtual subclasses
from abc import ABCMeta

class Vehicle(ABC):
    @abstractmethod
    def start_engine(self) -> str: ...

# Register an existing class WITHOUT inheritance
class Bicycle:
    def start_engine(self) -> str:
        return "Bicycles have no engine!"

Vehicle.register(Bicycle)
print(isinstance(Bicycle(), Vehicle))  # True (registered!)

# ── PROTOCOLS ──────────────────────

@runtime_checkable
class Drawable(Protocol):
    def draw(self) -> None: ...

@runtime_checkable
class Resizable(Protocol):
    def resize(self, factor: float) -> None: ...

@runtime_checkable
class Drawable2D(Drawable, Resizable, Protocol):
    """Combined protocol."""
    ...

# Classes that SATISFY the protocol without inheriting
class SVGCircle:
    def __init__(self, radius: float):
        self.radius = radius

    def draw(self) -> None:
        print(f"<circle r='{self.radius}'/>")

    def resize(self, factor: float) -> None:
        self.radius *= factor

class TerminalBox:
    def draw(self) -> None:
        print("[ box ]")

    def resize(self, factor: float) -> None:
        pass

def render_all(drawables: list[Drawable]) -> None:
    for d in drawables:
        d.draw()

# These classes never inherited from Drawable!
objects = [SVGCircle(5), TerminalBox()]
render_all(objects)   # works because they have draw()

# Runtime isinstance check (because @runtime_checkable)
print(isinstance(SVGCircle(1), Drawable))   # True
print(isinstance(SVGCircle(1), Drawable2D)) # True
print(isinstance(TerminalBox(), Drawable))  # True

# ── COLLECTIONS.ABC ────────────────
from collections.abc import Sequence, Callable

# Use Sequence for type hints instead of list
def total(nums: Sequence[float]) -> float:
    return sum(nums)

print(total([1,2,3]))      # works with list
print(total((1,2,3)))      # works with tuple
print(total(range(5)))     # works with range!

# Check if something is iterable
from collections.abc import Iterable
print(isinstance([1,2,3], Iterable))   # True
print(isinstance("hello", Iterable))   # True
print(isinstance(42, Iterable))        # False

# Check if something is a mapping
from collections.abc import Mapping
print(isinstance({}, Mapping))         # True
print(isinstance([], Mapping))         # False

# Custom Sequence — implement __getitem__ and __len__
class Fibonacci(Sequence):
    def __init__(self, n: int):
        self._data = []
        a, b = 0, 1
        for _ in range(n):
            self._data.append(a)
            a, b = b, a + b

    def __getitem__(self, index):
        return self._data[index]

    def __len__(self):
        return len(self._data)

    # count(), index(), reversed(), __contains__, __iter__
    # are ALL provided by Sequence for free!

fib = Fibonacci(10)
print(list(fib))                 # [0, 1, 1, 2, 3, 5, 8, 13, 21, 34]
print(fib[5])                    # 5
print(3 in fib)                  # True
print(fib.count(1))              # 2
print(fib.index(8))              # 6
print(list(reversed(fib)))       # reversed!

📝 KEY POINTS:
✅ ABCs enforce interface contracts — subclass MUST implement abstract methods
✅ @abstractmethod + @property creates an abstract property
✅ Protocols enable structural (duck) typing with static type checking
✅ @runtime_checkable allows isinstance() checks against Protocols
✅ collections.abc provides ABCs for Iterable, Sequence, Mapping, etc.
✅ Inherit from Sequence/Mapping to get many methods for free by implementing just 1-2
✅ ABC.register() lets existing classes "virtually" inherit from an ABC
❌ Forgetting even ONE abstract method prevents instantiation
❌ Protocols are not enforced at runtime without @runtime_checkable
❌ Don't use ABCs when a simple Protocol would do — ABCs create tight coupling
''',
  quiz: [
    Quiz(question: 'What happens if a subclass of an ABC does not implement all abstract methods?', options: [
      QuizOption(text: 'The missing methods default to None', correct: false),
      QuizOption(text: 'Instantiation raises a TypeError', correct: true),
      QuizOption(text: 'A warning is printed but instantiation succeeds', correct: false),
      QuizOption(text: 'The subclass also becomes abstract automatically', correct: false),
    ]),
    Quiz(question: 'What is the key difference between ABC and Protocol?', options: [
      QuizOption(text: 'ABC is for Python 3; Protocol is for Python 2 compatibility', correct: false),
      QuizOption(text: 'ABC requires explicit inheritance; Protocol uses structural (duck) typing — no inheritance needed', correct: true),
      QuizOption(text: 'Protocol enforces methods at runtime; ABC only at class definition', correct: false),
      QuizOption(text: 'They are identical — just different modules', correct: false),
    ]),
    Quiz(question: 'What does @runtime_checkable do to a Protocol?', options: [
      QuizOption(text: 'Enforces the protocol at function call time', correct: false),
      QuizOption(text: 'Allows isinstance() to check if an object satisfies the Protocol', correct: true),
      QuizOption(text: 'Makes the protocol work at runtime instead of only with type checkers', correct: false),
      QuizOption(text: 'Automatically generates abstract methods', correct: false),
    ]),
  ],
);
