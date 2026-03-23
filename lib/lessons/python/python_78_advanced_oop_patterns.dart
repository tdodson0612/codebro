import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson78 = Lesson(
  language: 'Python',
  title: 'Advanced OOP: Properties, Slots & Class Internals',
  content: """
🎯 METAPHOR:
Properties are like a smart safe with a keypad.
A regular attribute is an unlocked drawer — anyone can
reach in and put anything. A property is a smart safe:
you press buttons (call the setter), the safe validates
the combination (runs validation logic), stores what's
appropriate, and gives you exactly what it shows on
its display (runs getter logic). From the outside it
looks just like a regular attribute — same dot notation.
But behind the panel there's a guardian.

📖 EXPLANATION:
This lesson dives deep into Python's property system,
__slots__ for memory optimization, class internals
(__dict__, __class__, __mro__), and patterns for
controlling object creation and state.

─────────────────────────────────────
📐 PROPERTY DECORATOR
─────────────────────────────────────
@property         → getter (access like attribute)
@name.setter      → setter (assign like attribute)
@name.deleter     → deleter (del like attribute)

Three steps to a full property:
  1. @property def name(self): ...     (getter)
  2. @name.setter def name(self, v): . (setter)
  3. @name.deleter def name(self): ... (deleter)

─────────────────────────────────────
🔒 NAMING CONVENTION
─────────────────────────────────────
Store in _name (single underscore = "internal")
Expose via @property name (no underscore)

class Circle:
    def __init__(self, r):
        self._radius = r      # internal storage

    @property
    def radius(self):
        return self._radius

    @radius.setter
    def radius(self, v):
        if v < 0: raise ValueError("Radius must be ≥ 0")
        self._radius = v

─────────────────────────────────────
🎰 __slots__
─────────────────────────────────────
By default, each instance has a __dict__ (flexible but uses memory).
__slots__ = ("x", "y") replaces __dict__ with fixed descriptors.

Benefits:
  • 30-60% less memory per instance
  • Faster attribute access
  • Prevents accidental new attributes

─────────────────────────────────────
🏗️  CLASS INTERNALS
─────────────────────────────────────
obj.__dict__       → instance's attribute dict
type(obj).__dict__ → class's attribute dict
obj.__class__      → the class
ClassName.__mro__  → method resolution order
ClassName.__bases__ → direct parent classes

💻 CODE:
import sys
from functools import cached_property
import math

# ── PROPERTIES ────────────────────

class Temperature:
    """Temperature class with Celsius/Fahrenheit conversion."""

    def __init__(self, celsius: float = 0.0):
        self._celsius = celsius   # note: calls the setter!

    @property
    def celsius(self) -> float:
        return self._celsius

    @celsius.setter
    def celsius(self, value: float) -> None:
        if value < -273.15:
            raise ValueError(f"Temperature {value}°C is below absolute zero!")
        self._celsius = float(value)

    @celsius.deleter
    def celsius(self) -> None:
        print("Resetting temperature to 0°C")
        self._celsius = 0.0

    @property
    def fahrenheit(self) -> float:
        return self._celsius * 9/5 + 32

    @fahrenheit.setter
    def fahrenheit(self, value: float) -> None:
        self.celsius = (value - 32) * 5/9   # delegates to celsius setter

    @property
    def kelvin(self) -> float:
        return self._celsius + 273.15

    def __repr__(self) -> str:
        return f"Temperature({self._celsius}°C / {self.fahrenheit}°F)"

t = Temperature(100)
print(t.celsius)       # 100.0
print(t.fahrenheit)    # 212.0
print(t.kelvin)        # 373.15

t.fahrenheit = 32
print(t.celsius)       # 0.0

try:
    t.celsius = -300   # ValueError!
except ValueError as e:
    print(f"Error: {e}")

del t.celsius          # resets to 0.0
print(t.celsius)       # 0.0

# ── CACHED PROPERTY ───────────────

class Circle:
    def __init__(self, radius: float):
        self.radius = radius

    @cached_property
    def area(self) -> float:
        print("Computing area...")   # only runs ONCE!
        return math.pi * self.radius ** 2

    @cached_property
    def circumference(self) -> float:
        print("Computing circumference...")
        return 2 * math.pi * self.radius

c = Circle(5.0)
print(c.area)            # Computing area... 78.54
print(c.area)            # (no computation) 78.54
print(c.circumference)   # Computing circumference... 31.42
print(c.circumference)   # (no computation) 31.42

# ── PROPERTY WITHOUT SETTER (read-only) ──

class Person:
    def __init__(self, first: str, last: str, birth_year: int):
        self.first = first
        self.last = last
        self._birth_year = birth_year

    @property
    def full_name(self) -> str:
        return f"{self.first} {self.last}"

    @property
    def age(self) -> int:
        from datetime import date
        return date.today().year - self._birth_year

    @property
    def birth_year(self) -> int:
        return self._birth_year   # read-only: no setter defined!

p = Person("Alice", "Smith", 1994)
print(p.full_name)    # Alice Smith
print(p.age)          # current age

try:
    p.birth_year = 2000   # AttributeError!
except AttributeError as e:
    print(f"Read-only: {e}")

# ── __SLOTS__ ─────────────────────

class NormalPoint:
    def __init__(self, x: float, y: float, z: float):
        self.x = x
        self.y = y
        self.z = z

class SlottedPoint:
    __slots__ = ("x", "y", "z")

    def __init__(self, x: float, y: float, z: float):
        self.x = x
        self.y = y
        self.z = z

# Memory comparison
normal  = NormalPoint(1.0, 2.0, 3.0)
slotted = SlottedPoint(1.0, 2.0, 3.0)

print(f"Normal:  {sys.getsizeof(normal)} + {sys.getsizeof(normal.__dict__)} bytes")
print(f"Slotted: {sys.getsizeof(slotted)} bytes (no __dict__)")

# Slotted: can't add new attributes
try:
    slotted.w = 4.0   # AttributeError!
except AttributeError as e:
    print(f"No new attrs: {e}")

# Slots with inheritance
class Point3D:
    __slots__ = ("x", "y", "z")
    def __init__(self, x, y, z):
        self.x, self.y, self.z = x, y, z

class ColorPoint(Point3D):
    __slots__ = ("color",)   # only ADD new slots here!
    def __init__(self, x, y, z, color="black"):
        super().__init__(x, y, z)
        self.color = color

cp = ColorPoint(1, 2, 3, "red")
print(f"ColorPoint: ({cp.x},{cp.y},{cp.z}) in {cp.color}")

# ── CLASS INTERNALS ───────────────

class Animal:
    kingdom = "Animalia"

    def __init__(self, name: str):
        self.name = name

    def speak(self) -> str:
        return f"{self.name} makes a sound"

class Dog(Animal):
    def speak(self) -> str:
        return f"{self.name} barks"

d = Dog("Rex")

# Instance attributes
print(f"Instance dict: {d.__dict__}")           # {'name': 'Rex'}
print(f"Class: {d.__class__}")                  # <class 'Dog'>
print(f"Class name: {d.__class__.__name__}")    # Dog

# Class attributes
print(f"Dog dict: {dict(Dog.__dict__)}")
print(f"Animal dict: {dict(Animal.__dict__)}")

# MRO — Method Resolution Order
print(f"MRO: {Dog.__mro__}")
print(f"Bases: {Dog.__bases__}")

# isinstance vs type()
print(f"isinstance(d, Dog):    {isinstance(d, Dog)}")     # True
print(f"isinstance(d, Animal): {isinstance(d, Animal)}")  # True (!)
print(f"type(d) == Dog:        {type(d) == Dog}")         # True
print(f"type(d) == Animal:     {type(d) == Animal}")      # False

# ── CONTROLLING INSTANTIATION ──────

class Singleton:
    _instance = None

    def __new__(cls, *args, **kwargs):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
        return cls._instance

    def __init__(self, value: int = 0):
        if not hasattr(self, "_initialized"):
            self.value = value
            self._initialized = True

s1 = Singleton(10)
s2 = Singleton(99)   # returns same instance, __init__ runs again
print(f"Same instance: {s1 is s2}")  # True
print(f"Value: {s1.value}")           # 10 (not overwritten)

# __ new__ for immutable subtypes
class PositiveInt(int):
    """int subclass that must be positive."""

    def __new__(cls, value: int):
        if value <= 0:
            raise ValueError(f"PositiveInt must be positive, got {value}")
        return super().__new__(cls, value)

pi = PositiveInt(5)
print(pi + 3)   # 8 (still works like int)

try:
    bad = PositiveInt(-1)
except ValueError as e:
    print(f"Error: {e}")

# ── ATTRIBUTE ACCESS CONTROL ───────

class ValidatedRecord:
    """All attributes validated on assignment."""

    _validators: dict = {}

    def __init_subclass__(cls, **kwargs):
        super().__init_subclass__(**kwargs)
        cls._validators = {}

    @classmethod
    def validator(cls, name):
        def decorator(func):
            cls._validators[name] = func
            return func
        return decorator

    def __setattr__(self, name, value):
        if name in self.__class__._validators:
            value = self.__class__._validators[name](value)
        super().__setattr__(name, value)

class User(ValidatedRecord):
    @ValidatedRecord.validator("age")
    def validate_age(value):
        v = int(value)
        if v < 0 or v > 150:
            raise ValueError(f"Age {v} out of range")
        return v

    @ValidatedRecord.validator("email")
    def validate_email(value):
        if "@" not in str(value):
            raise ValueError(f"Invalid email: {value}")
        return str(value).lower()

u = User()
u.name = "Alice"        # no validator → stored as-is
u.age = "30"            # validator coerces to int!
u.email = "ALICE@EX.COM"  # validator lowercases!

print(f"Name:  {u.name}")
print(f"Age:   {u.age}  (type: {type(u.age).__name__})")
print(f"Email: {u.email}")

try:
    u.age = -5
except ValueError as e:
    print(f"Validation: {e}")

📝 KEY POINTS:
✅ Properties look like attributes from outside but run code on access/assignment
✅ @cached_property computes once, then stores as instance attribute — fast!
✅ Read-only property: define @property but omit the @name.setter
✅ __slots__ saves memory and prevents new attribute creation — great for many instances
✅ __new__ controls object creation; __init__ configures it after creation
✅ Instance __dict__ holds instance attrs; class __dict__ holds class attrs
✅ isinstance() respects inheritance; type() checks exact class only
❌ Don't store data in the property name itself — use _name convention for storage
❌ @cached_property requires __dict__ to exist — incompatible with __slots__
❌ __slots__ inheritance: each class must define its own __slots__ for new attributes
""",
  quiz: [
    Quiz(question: 'What is the benefit of @cached_property over @property?', options: [
      QuizOption(text: 'cached_property is faster because it skips validation', correct: false),
      QuizOption(text: 'The computation runs only once and the result is cached as an instance attribute', correct: true),
      QuizOption(text: 'cached_property allows mutation while property does not', correct: false),
      QuizOption(text: 'They are identical — just different names', correct: false),
    ]),
    Quiz(question: 'What happens when you try to add a new attribute to an object with __slots__?', options: [
      QuizOption(text: 'The attribute is added to a hidden __dict__', correct: false),
      QuizOption(text: 'An AttributeError is raised', correct: true),
      QuizOption(text: 'The attribute is silently ignored', correct: false),
      QuizOption(text: 'A new slot is dynamically created', correct: false),
    ]),
    Quiz(question: 'What is the difference between __new__ and __init__?', options: [
      QuizOption(text: '__new__ is for classes; __init__ is for instances', correct: false),
      QuizOption(text: '__new__ creates the object; __init__ initializes it after creation', correct: true),
      QuizOption(text: '__new__ is called on deletion; __init__ on creation', correct: false),
      QuizOption(text: 'They are called at the same time — identical purpose', correct: false),
    ]),
  ],
);
