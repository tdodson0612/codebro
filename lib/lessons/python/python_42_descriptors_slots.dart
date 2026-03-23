import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson42 = Lesson(
  language: 'Python',
  title: 'Descriptors, __slots__ & Metaclasses',
  content: """
🎯 METAPHOR:
Descriptors are like smart power outlets.
A regular outlet just provides power — no intelligence.
A smart outlet (descriptor) knows WHO is plugging in,
tracks how long they've been connected, limits the current,
and shuts off automatically. When you define a descriptor,
accessing the attribute on any class that has it goes
through the descriptor's logic — not directly to the value.
The attribute lookup is INTERCEPTED and processed.

__slots__ is like assigning fixed lockers to class instances.
Normally, each object has a free-form dictionary for attributes
(flexible but wasteful). With __slots__, you pre-assign
specific named lockers. No dictionary, no flexibility,
but 30-60% less memory and faster attribute access.

📖 EXPLANATION:
Descriptors are objects that define how attribute access works.
They implement __get__, __set__, and/or __delete__.
Properties are just a convenient descriptor wrapper.

─────────────────────────────────────
📐 DESCRIPTOR PROTOCOL
─────────────────────────────────────
class Descriptor:
    def __get__(self, obj, objtype=None):
        # obj = instance (None if accessed on class)
        # objtype = the class
        ...
    def __set__(self, obj, value):
        ...
    def __delete__(self, obj):
        ...

Data descriptor:     defines __set__ or __delete__
Non-data descriptor: defines only __get__
Data descriptors take precedence over instance __dict__

─────────────────────────────────────
🔑 LOOKUP PRIORITY ORDER
─────────────────────────────────────
1. Data descriptors (class level)
2. Instance __dict__
3. Non-data descriptors + class vars

─────────────────────────────────────
🎰 __slots__
─────────────────────────────────────
class Point:
    __slots__ = ("x", "y")   # ONLY these attributes allowed

Benefits:
  • 30-60% less memory (no __dict__ per instance)
  • Faster attribute access
  • Prevents accidental new attributes

Limitations:
  • Can't add new attributes dynamically
  • Complicates inheritance
  • Can't use __weakref__ unless added to __slots__

─────────────────────────────────────
🏭 METACLASSES
─────────────────────────────────────
A metaclass is a class whose instances are classes.
type is the default metaclass.
Custom metaclasses control class CREATION itself.
Used for: ORMs, API frameworks, registries, validation.

class Meta(type):
    def __new__(mcs, name, bases, namespace):
        # called when class is being CREATED
        return super().__new__(mcs, name, bases, namespace)

class MyClass(metaclass=Meta):
    pass

💻 CODE:
import sys

# ── DESCRIPTORS ────────────────────

# Typed descriptor — validates type on assignment
class Typed:
    def __init__(self, expected_type, name=None):
        self.expected_type = expected_type
        self.name = name

    def __set_name__(self, owner, name):   # Python 3.6+
        self.name = name

    def __get__(self, obj, objtype=None):
        if obj is None:
            return self   # accessed on class, not instance
        return getattr(obj, f"_{self.name}", None)

    def __set__(self, obj, value):
        if not isinstance(value, self.expected_type):
            raise TypeError(
                f"{self.name} must be {self.expected_type.__name__}, "
                f"got {type(value).__name__}"
            )
        setattr(obj, f"_{self.name}", value)

    def __delete__(self, obj):
        delattr(obj, f"_{self.name}")

class Person:
    name  = Typed(str)
    age   = Typed(int)
    score = Typed(float)

    def __init__(self, name, age, score):
        self.name  = name   # calls Typed.__set__
        self.age   = age
        self.score = score

p = Person("Alice", 30, 95.5)
print(p.name)    # Alice
print(p.age)     # 30

try:
    p.age = "thirty"    # TypeError!
except TypeError as e:
    print(f"Error: {e}")

try:
    p.score = 100       # TypeError! Must be float
except TypeError as e:
    print(f"Error: {e}")

p.score = 100.0   # OK

# Range validator descriptor
class RangeCheck:
    def __init__(self, min_val, max_val):
        self.min_val = min_val
        self.max_val = max_val

    def __set_name__(self, owner, name):
        self.name = name

    def __get__(self, obj, objtype=None):
        if obj is None: return self
        return obj.__dict__.get(self.name)

    def __set__(self, obj, value):
        if not (self.min_val <= value <= self.max_val):
            raise ValueError(
                f"{self.name} must be between {self.min_val} and {self.max_val}, got {value}"
            )
        obj.__dict__[self.name] = value

class Student:
    gpa   = RangeCheck(0.0, 4.0)
    grade = RangeCheck(0, 100)

    def __init__(self, name, gpa, grade):
        self.name  = name
        self.gpa   = gpa
        self.grade = grade

s = Student("Bob", 3.8, 95)
print(s.gpa)
try:
    s.gpa = 5.0   # ValueError!
except ValueError as e:
    print(f"Range error: {e}")

# ── __slots__ ─────────────────────

class PointNoSlots:
    def __init__(self, x, y):
        self.x = x
        self.y = y

class PointSlots:
    __slots__ = ("x", "y")
    def __init__(self, x, y):
        self.x = x
        self.y = y

p_no  = PointNoSlots(1, 2)
p_yes = PointSlots(1, 2)

print(f"No slots: {sys.getsizeof(p_no.__dict__)} bytes for __dict__")
print(f"Slots:    no __dict__ — smaller memory footprint")

# Can add new attrs to regular class
p_no.z = 3      # OK
p_no.extra = "anything"  # OK

# Cannot add new attrs with __slots__
try:
    p_yes.z = 3   # AttributeError!
except AttributeError as e:
    print(f"Slots prevent: {e}")

# Performance test
import timeit

# Creating 1 million instances
no_slots_time = timeit.timeit(
    "PointNoSlots(1, 2)",
    globals={"PointNoSlots": PointNoSlots},
    number=1_000_000
)
slots_time = timeit.timeit(
    "PointSlots(1, 2)",
    globals={"PointSlots": PointSlots},
    number=1_000_000
)
print(f"No slots: {no_slots_time:.2f}s")
print(f"Slots:    {slots_time:.2f}s")

# __slots__ with inheritance (tricky!)
class Animal:
    __slots__ = ("name", "age")
    def __init__(self, name, age):
        self.name = name
        self.age = age

class Dog(Animal):
    __slots__ = ("breed",)   # ONLY add new slots here
    def __init__(self, name, age, breed):
        super().__init__(name, age)
        self.breed = breed

d = Dog("Rex", 3, "Husky")
print(d.name, d.breed)

# ── METACLASSES ────────────────────

# A registry metaclass — tracks all subclasses
class PluginMeta(type):
    registry = {}

    def __new__(mcs, name, bases, namespace):
        cls = super().__new__(mcs, name, bases, namespace)
        if bases:   # don't register the base class itself
            mcs.registry[name] = cls
        return cls

class Plugin(metaclass=PluginMeta):
    def run(self): raise NotImplementedError

class FilePlugin(Plugin):
    def run(self): return "Processing files..."

class NetworkPlugin(Plugin):
    def run(self): return "Processing network..."

class DatabasePlugin(Plugin):
    def run(self): return "Processing database..."

# All subclasses auto-registered!
print(PluginMeta.registry)
for name, cls in PluginMeta.registry.items():
    plugin = cls()
    print(f"{name}: {plugin.run()}")

# Singleton metaclass
class SingletonMeta(type):
    _instances = {}

    def __call__(cls, *args, **kwargs):
        if cls not in cls._instances:
            cls._instances[cls] = super().__call__(*args, **kwargs)
        return cls._instances[cls]

class Config(metaclass=SingletonMeta):
    def __init__(self):
        self.debug = False
        self.version = "1.0"

c1 = Config()
c2 = Config()
print(c1 is c2)   # True — same instance!
c1.debug = True
print(c2.debug)   # True — it's the same object

📝 KEY POINTS:
✅ Descriptors intercept attribute get/set/delete — used for validation, transformation
✅ __set_name__ is called at class creation time — auto-sets the attribute name
✅ Data descriptors (define __set__) override instance __dict__
✅ __slots__ saves 30-60% memory for classes with many instances
✅ __slots__ prevents dynamic attribute creation — catches typos!
✅ Metaclasses control CLASS creation itself — use sparingly
❌ Avoid metaclasses unless truly needed — class decorators or __init_subclass__ often suffice
❌ __slots__ with inheritance: each class must define its own __slots__
❌ Non-data descriptors (only __get__) can be shadowed by instance attributes
""",
  quiz: [
    Quiz(question: 'What is the main benefit of using __slots__ in a class?', options: [
      QuizOption(text: 'It makes the class immutable like a frozen dataclass', correct: false),
      QuizOption(text: 'It reduces memory usage and speeds up attribute access by eliminating __dict__', correct: true),
      QuizOption(text: 'It enables multiple inheritance', correct: false),
      QuizOption(text: 'It auto-generates __init__ like @dataclass', correct: false),
    ]),
    Quiz(question: 'What makes a "data descriptor" different from a "non-data descriptor"?', options: [
      QuizOption(text: 'Data descriptors define __set__ or __delete__; non-data only define __get__', correct: true),
      QuizOption(text: 'Data descriptors work with data types like int and str', correct: false),
      QuizOption(text: 'Non-data descriptors are class variables; data descriptors are instance variables', correct: false),
      QuizOption(text: 'They are the same thing with different names', correct: false),
    ]),
    Quiz(question: 'What does a metaclass control?', options: [
      QuizOption(text: 'How objects (instances) are created', correct: false),
      QuizOption(text: 'How classes themselves are created and behave', correct: true),
      QuizOption(text: 'Which methods are inherited', correct: false),
      QuizOption(text: 'Memory allocation for instances', correct: false),
    ]),
  ],
);
