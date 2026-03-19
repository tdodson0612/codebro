import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson23 = Lesson(
  language: 'Python',
  title: 'Inheritance & Polymorphism',
  content: '''
🎯 METAPHOR:
Inheritance is like a family tree.
A child inherits traits from their parents — eye color,
height tendencies, maybe some personality traits — but
they're also their own person with unique characteristics.
In Python, a child class inherits all methods and attributes
from its parent, and can either USE them as-is, OVERRIDE
them (be different from the parent), or ADD new ones
(be more than the parent). super() is how the child calls
their parent: "Hey Mom, can you do that thing you do?
I'll take it from there."

📖 EXPLANATION:
Inheritance lets a class (child/subclass) inherit behavior
from another class (parent/superclass). It promotes code
reuse and models "is-a" relationships.

─────────────────────────────────────
📐 SYNTAX
─────────────────────────────────────
class Child(Parent):
    def __init__(self, ...):
        super().__init__(...)  # call parent constructor!
        self.extra = ...       # add child-specific stuff

─────────────────────────────────────
🔑 super()
─────────────────────────────────────
super() returns a proxy to the parent class.
Use super().__init__() to call parent's constructor.
Use super().method() to call parent's version of a method.
Essential for cooperative multiple inheritance.

─────────────────────────────────────
🔄 METHOD OVERRIDING
─────────────────────────────────────
If child defines a method with same name as parent,
the child's version OVERRIDES the parent's.
This is how you customize inherited behavior.

─────────────────────────────────────
🎭 POLYMORPHISM
─────────────────────────────────────
Poly = many, morph = form.
Different classes respond to the SAME method call
differently. Python is "duck typed":
"If it walks like a duck and quacks like a duck,
it IS a duck." — doesn't care about the actual type,
only if it has the right methods.

─────────────────────────────────────
🔗 MULTIPLE INHERITANCE
─────────────────────────────────────
class Child(Parent1, Parent2): ...
Python uses MRO (Method Resolution Order) to
determine which parent's method wins.
Check with ClassName.__mro__ or ClassName.mro()

─────────────────────────────────────
🔍 CHECKING INHERITANCE
─────────────────────────────────────
isinstance(obj, ClassName)   → True if obj is an instance
issubclass(Child, Parent)    → True if Child inherits Parent

─────────────────────────────────────
🏛️  ABSTRACT CLASSES
─────────────────────────────────────
from abc import ABC, abstractmethod
Defines a blueprint that MUST be subclassed.
Abstract methods must be implemented in child classes.
Cannot instantiate an abstract class directly.

💻 CODE:
# Base class
class Animal:
    def __init__(self, name, age):
        self.name = name
        self.age = age

    def eat(self):
        return f"{self.name} is eating"

    def sleep(self):
        return f"{self.name} is sleeping"

    def speak(self):
        return f"{self.name} makes a sound"

    def __str__(self):
        return f"{type(self).__name__}(name={self.name}, age={self.age})"

# Child classes
class Dog(Animal):
    def __init__(self, name, age, breed):
        super().__init__(name, age)   # call parent's __init__
        self.breed = breed

    def speak(self):                  # override parent method
        return f"{self.name} barks: Woof!"

    def fetch(self):                  # new method, only in Dog
        return f"{self.name} fetches the ball!"

class Cat(Animal):
    def __init__(self, name, age, indoor):
        super().__init__(name, age)
        self.indoor = indoor

    def speak(self):
        return f"{self.name} says: Meow~"

    def purr(self):
        return f"{self.name} purrs..."

class Duck(Animal):
    def speak(self):
        return f"{self.name} says: Quack!"

# Usage
dog = Dog("Rex", 3, "Husky")
cat = Cat("Whiskers", 5, True)
duck = Duck("Donald", 2)

print(dog.eat())     # Rex is eating  (inherited)
print(dog.speak())   # Rex barks: Woof! (overridden)
print(dog.fetch())   # Rex fetches the ball! (new)
print(cat.speak())   # Whiskers says: Meow~
print(duck.speak())  # Donald says: Quack!

# Polymorphism — same method, different behavior
animals = [dog, cat, duck]
for animal in animals:
    print(animal.speak())   # each calls ITS OWN version

# isinstance and issubclass
print(isinstance(dog, Dog))     # True
print(isinstance(dog, Animal))  # True — Dog IS-A Animal
print(isinstance(dog, Cat))     # False
print(issubclass(Dog, Animal))  # True
print(issubclass(Dog, Cat))     # False

# type() vs isinstance()
print(type(dog) == Dog)     # True
print(type(dog) == Animal)  # False (exact type only)
print(isinstance(dog, Animal))  # True (considers inheritance)
# Use isinstance() — type() breaks with inheritance

# Multiple inheritance
class Flyable:
    def fly(self):
        return f"{self.name} is flying!"

class FlyingDog(Dog, Flyable):
    def speak(self):
        return f"{self.name} barks AND can fly!"

fd = FlyingDog("AirBud", 4, "Golden Retriever")
print(fd.speak())    # barks AND can fly!
print(fd.fly())      # AirBud is flying!
print(fd.eat())      # inherited from Animal via Dog
print(FlyingDog.__mro__)   # Method Resolution Order

# Abstract classes
from abc import ABC, abstractmethod

class Shape(ABC):
    def __init__(self, color="black"):
        self.color = color

    @abstractmethod
    def area(self):
        pass    # child MUST implement this

    @abstractmethod
    def perimeter(self):
        pass

    def describe(self):
        return f"{self.color} {type(self).__name__}: area={self.area():.2f}"

class Circle(Shape):
    def __init__(self, radius, color="black"):
        super().__init__(color)
        self.radius = radius

    def area(self):
        import math
        return math.pi * self.radius ** 2

    def perimeter(self):
        import math
        return 2 * math.pi * self.radius

class Rectangle(Shape):
    def __init__(self, width, height, color="black"):
        super().__init__(color)
        self.width = width
        self.height = height

    def area(self):
        return self.width * self.height

    def perimeter(self):
        return 2 * (self.width + self.height)

# Can't instantiate abstract class:
try:
    s = Shape()
except TypeError as e:
    print(f"Can't instantiate abstract class: {e}")

c = Circle(5, "red")
r = Rectangle(4, 6, "blue")
print(c.describe())    # red Circle: area=78.54
print(r.describe())    # blue Rectangle: area=24.00

# Polymorphism with abstract classes
shapes = [Circle(3), Rectangle(4, 5), Circle(1, "green")]
total_area = sum(s.area() for s in shapes)
print(f"Total area: {total_area:.2f}")

# super() in multiple inheritance — cooperative inheritance
class A:
    def method(self):
        print("A")
        super().method()   # cooperative!

class B:
    def method(self):
        print("B")

class C(A, B):  # MRO: C → A → B
    pass

c = C()
c.method()   # prints: A then B (cooperative chain)

# Mixin pattern
class JSONMixin:
    def to_json(self):
        import json
        return json.dumps(self.__dict__, default=str)

    @classmethod
    def from_json(cls, json_str):
        import json
        data = json.loads(json_str)
        obj = cls.__new__(cls)
        obj.__dict__.update(data)
        return obj

class User(JSONMixin):
    def __init__(self, name, email):
        self.name = name
        self.email = email

u = User("Alice", "alice@example.com")
json_str = u.to_json()
print(json_str)   # {"name": "Alice", "email": "alice@example.com"}

📝 KEY POINTS:
✅ Child inherits all parent methods and attributes automatically
✅ Always call super().__init__() in child's __init__
✅ Override methods by redefining them in the child class
✅ isinstance() respects inheritance; type() only checks exact type
✅ Abstract classes enforce that subclasses implement required methods
✅ Mixins are small classes that add specific functionality via multiple inheritance
❌ Don't forget super().__init__() — parent state won't be set up
❌ Deep inheritance chains > 3 levels are hard to follow — prefer composition
❌ Multiple inheritance can cause ambiguity — use with care
''',
  quiz: [
    Quiz(question: 'What does super().__init__() do in a child class?', options: [
      QuizOption(text: 'Creates a new parent class instance', correct: false),
      QuizOption(text: 'Calls the parent class constructor to initialize inherited attributes', correct: true),
      QuizOption(text: 'Overrides the parent constructor completely', correct: false),
      QuizOption(text: 'It is only needed for multiple inheritance', correct: false),
    ]),
    Quiz(question: 'What is polymorphism in Python?', options: [
      QuizOption(text: 'A class having multiple constructors', correct: false),
      QuizOption(text: 'Different classes implementing the same method name with different behavior', correct: true),
      QuizOption(text: 'A method calling itself recursively', correct: false),
      QuizOption(text: 'A variable holding multiple types', correct: false),
    ]),
    Quiz(question: 'What happens if you try to instantiate an abstract class?', options: [
      QuizOption(text: 'It creates an incomplete object with None for abstract methods', correct: false),
      QuizOption(text: 'It raises a TypeError', correct: true),
      QuizOption(text: 'It automatically creates a concrete subclass', correct: false),
      QuizOption(text: 'It works fine — abstract is just a hint', correct: false),
    ]),
  ],
);
