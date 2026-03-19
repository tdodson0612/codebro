import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson22 = Lesson(
  language: 'Python',
  title: 'Classes & Objects: OOP Basics',
  content: '''
🎯 METAPHOR:
A class is like a cookie cutter, and objects are the cookies.
The cutter (class) defines the SHAPE — every cookie it cuts
will have that shape. But each cookie (object) is its own
physical thing — you can frost one blue, leave another plain,
eat one without affecting the others. The cutter itself
is just the mold; the cookies are the real things you work
with. In Python, a class is the blueprint, and every time
you call it (instantiate it), you get a fresh, independent
cookie with that shape.

📖 EXPLANATION:
Object-Oriented Programming (OOP) organizes code around
objects — bundles of data (attributes) and behavior (methods).

─────────────────────────────────────
🏗️  CLASS ANATOMY
─────────────────────────────────────
class ClassName:              # class definition
    class_var = "shared"      # class attribute — shared by all

    def __init__(self, args): # constructor — called on creation
        self.attr = args      # instance attribute — unique per object

    def method(self):         # instance method
        return self.attr

    @classmethod              # class method
    def from_string(cls, s):
        return cls(s)

    @staticmethod             # static method — no self or cls
    def helper(x):
        return x * 2

─────────────────────────────────────
🔑 self — The Object Itself
─────────────────────────────────────
self is a reference to the CURRENT instance.
It's the object saying "me, myself."
Every instance method's first parameter is self.
Python passes it automatically — you never pass it explicitly.

─────────────────────────────────────
🏗️  __init__ — The Constructor
─────────────────────────────────────
Called automatically when you create an instance.
Sets up the initial state of the object.
Not technically a "constructor" (the object already
exists by the time __init__ runs), but it's used that way.

─────────────────────────────────────
📊 INSTANCE vs CLASS ATTRIBUTES
─────────────────────────────────────
Instance attribute:  self.name = "Alice"
  → unique to each object
  → stored in object's __dict__

Class attribute:     name = "default"
  → shared by ALL instances
  → changing it affects all instances
  → BUT if you set it on an instance, it shadows the class attr

─────────────────────────────────────
🔒 NAME MANGLING (Privacy Convention)
─────────────────────────────────────
_single_underscore   → convention: "internal use"
__double_underscore  → name mangling: _ClassName__attr
  → hard (not impossible) to access from outside

─────────────────────────────────────
🧮 DUNDER METHODS (Magic Methods)
─────────────────────────────────────
__init__    → constructor
__str__     → str(obj) and print(obj)
__repr__    → repr(obj) — detailed string for devs
__len__     → len(obj)
__eq__      → obj == other
__lt__, __gt__ etc. → comparisons
__add__     → obj + other
__call__    → obj()  (callable object)
__getitem__ → obj[key]
__contains__ → x in obj

💻 CODE:
# Basic class
class Dog:
    # Class attribute — shared by all dogs
    species = "Canis lupus familiaris"
    count = 0

    def __init__(self, name, breed, age):
        # Instance attributes — unique to each dog
        self.name = name
        self.breed = breed
        self.age = age
        Dog.count += 1   # increment class attribute

    def bark(self):
        return f"{self.name} says: Woof!"

    def birthday(self):
        self.age += 1
        return f"{self.name} is now {self.age}"

    def __str__(self):
        return f"Dog({self.name}, {self.breed}, age {self.age})"

    def __repr__(self):
        return f"Dog(name={self.name!r}, breed={self.breed!r}, age={self.age!r})"

    @classmethod
    def from_dict(cls, data):
        return cls(data["name"], data["breed"], data["age"])

    @staticmethod
    def is_adult(age):
        return age >= 2

# Creating instances
d1 = Dog("Rex", "German Shepherd", 3)
d2 = Dog("Bella", "Golden Retriever", 5)

print(d1.name)       # Rex
print(d1.bark())     # Rex says: Woof!
print(d2.bark())     # Bella says: Woof!
print(str(d1))       # Dog(Rex, German Shepherd, age 3)
print(repr(d1))      # Dog(name='Rex', breed='German Shepherd', age=3)
print(Dog.count)     # 2

# Class vs instance attribute
print(d1.species)    # Canis lupus familiaris (from class)
d1.species = "Modified"  # creates INSTANCE attribute, shadows class
print(d1.species)    # Modified (instance attr)
print(d2.species)    # Canis lupus familiaris (class attr unchanged)

# Class method
d3 = Dog.from_dict({"name": "Max", "breed": "Poodle", "age": 1})
print(d3)

# Static method
print(Dog.is_adult(3))   # True
print(Dog.is_adult(1))   # False

# Dunder methods — making classes feel like built-ins
class Vector:
    def __init__(self, x, y):
        self.x = x
        self.y = y

    def __str__(self):
        return f"Vector({self.x}, {self.y})"

    def __repr__(self):
        return f"Vector(x={self.x}, y={self.y})"

    def __add__(self, other):
        return Vector(self.x + other.x, self.y + other.y)

    def __sub__(self, other):
        return Vector(self.x - other.x, self.y - other.y)

    def __mul__(self, scalar):
        return Vector(self.x * scalar, self.y * scalar)

    def __rmul__(self, scalar):        # 3 * v (scalar on left)
        return self.__mul__(scalar)

    def __eq__(self, other):
        return self.x == other.x and self.y == other.y

    def __len__(self):
        return 2   # always 2D

    def __abs__(self):
        import math
        return math.sqrt(self.x**2 + self.y**2)

v1 = Vector(1, 2)
v2 = Vector(3, 4)
print(v1 + v2)    # Vector(4, 6)
print(v1 * 3)     # Vector(3, 6)
print(3 * v1)     # Vector(3, 6)
print(abs(v2))    # 5.0
print(v1 == v2)   # False
print(len(v1))    # 2

# __call__ — callable objects
class Multiplier:
    def __init__(self, factor):
        self.factor = factor

    def __call__(self, value):
        return value * self.factor

double = Multiplier(2)
triple = Multiplier(3)
print(double(5))    # 10
print(triple(5))    # 15
print(double(triple(4)))  # 24

# Properties — controlled attribute access
class Temperature:
    def __init__(self, celsius=0):
        self._celsius = celsius

    @property
    def celsius(self):
        return self._celsius

    @celsius.setter
    def celsius(self, value):
        if value < -273.15:
            raise ValueError("Temperature below absolute zero!")
        self._celsius = value

    @property
    def fahrenheit(self):
        return self._celsius * 9/5 + 32

    @fahrenheit.setter
    def fahrenheit(self, value):
        self.celsius = (value - 32) * 5/9

t = Temperature(100)
print(t.celsius)       # 100
print(t.fahrenheit)    # 212.0
t.fahrenheit = 32
print(t.celsius)       # 0.0

try:
    t.celsius = -300    # raises ValueError
except ValueError as e:
    print(e)

📝 KEY POINTS:
✅ Classes are blueprints; objects (instances) are the real things
✅ self refers to the current instance — first param of every instance method
✅ __init__ sets up initial state — called automatically on creation
✅ __str__ for human-readable; __repr__ for developer-readable
✅ @property turns a method into an attribute with validation
✅ @classmethod receives cls; @staticmethod receives nothing special
✅ Class attributes are shared; instance attributes are unique
❌ Forgetting self as first parameter — TypeError when calling methods
❌ self.method is an instance method; ClassName.method requires passing self manually
❌ Don't do heavy computation in __init__ — keep constructors simple
''',
  quiz: [
    Quiz(question: 'What is the difference between a class attribute and an instance attribute?', options: [
      QuizOption(text: 'Class attributes are defined in __init__; instance attributes are defined outside', correct: false),
      QuizOption(text: 'Class attributes are shared by all instances; instance attributes are unique to each object', correct: true),
      QuizOption(text: 'Instance attributes are faster to access than class attributes', correct: false),
      QuizOption(text: 'They are identical — just different naming conventions', correct: false),
    ]),
    Quiz(question: 'What does the __str__ dunder method control?', options: [
      QuizOption(text: 'How the object is stored in memory', correct: false),
      QuizOption(text: 'The output of str(obj) and print(obj)', correct: true),
      QuizOption(text: 'How the object is compared with ==', correct: false),
      QuizOption(text: 'The object\'s string attribute', correct: false),
    ]),
    Quiz(question: 'When does __init__ get called?', options: [
      QuizOption(text: 'When the class is defined', correct: false),
      QuizOption(text: 'When an instance is created: obj = MyClass()', correct: true),
      QuizOption(text: 'When the first method is called on the object', correct: false),
      QuizOption(text: 'It must be called manually', correct: false),
    ]),
  ],
);
