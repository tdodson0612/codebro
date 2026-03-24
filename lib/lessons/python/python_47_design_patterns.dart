import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson47 = Lesson(
  language: 'Python',
  title: 'Design Patterns in Python',
  content: """
🎯 METAPHOR:
Design patterns are like proven architectural blueprints.
When an architect needs to design a hotel lobby, they don't
invent the concept of a reception desk, elevators, and
seating area from scratch. They use the established pattern —
refined over decades of hotel building. Design patterns
in code are the same: proven solutions to recurring problems.
Factory, Observer, Strategy — these are battle-tested
blueprints. You still build the specific building, but you're
not reinventing the structural logic.

📖 EXPLANATION:
Design patterns are reusable solutions to common problems.
In Python, many GoF (Gang of Four) patterns have simpler
implementations than in Java/C++ thanks to first-class
functions, duck typing, and the data model.

─────────────────────────────────────
🏭 CREATIONAL PATTERNS
─────────────────────────────────────
Singleton    → one instance only
Factory      → create objects without specifying exact class
Builder      → construct complex objects step by step
Prototype    → create copies of objects

─────────────────────────────────────
🔗 STRUCTURAL PATTERNS
─────────────────────────────────────
Adapter      → interface translation
Decorator    → add behavior without changing class
Proxy        → control access to another object
Facade       → simplified interface to complex subsystem
Composite    → tree structures of objects

─────────────────────────────────────
📡 BEHAVIORAL PATTERNS
─────────────────────────────────────
Observer     → subscribe/notify
Strategy     → interchangeable algorithms
Command      → encapsulate operations as objects
Iterator     → sequential access
State        → change behavior based on state
Template     → algorithm skeleton with customizable steps
Chain of Responsibility → pass request along a chain

💻 CODE:
from abc import ABC, abstractmethod
from typing import Callable, Any
from functools import wraps
import copy

# ── SINGLETON ────────────────────

class Singleton:
    _instance = None

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
        return cls._instance

class AppConfig(Singleton):
    def __init__(self):
        if not hasattr(self, "_initialized"):
            self.debug = False
            self.version = "1.0"
            self._initialized = True

c1 = AppConfig()
c2 = AppConfig()
print(c1 is c2)   # True

# ── FACTORY ──────────────────────

class Animal(ABC):
    @abstractmethod
    def speak(self) -> str: ...

class Dog(Animal):
    def speak(self): return "Woof!"

class Cat(Animal):
    def speak(self): return "Meow!"

class Duck(Animal):
    def speak(self): return "Quack!"

def animal_factory(animal_type: str) -> Animal:
    animals = {"dog": Dog, "cat": Cat, "duck": Duck}
    cls = animals.get(animal_type.lower())
    if cls is None:
        raise ValueError(f"Unknown animal: {animal_type}")
    return cls()

dog = animal_factory("dog")
print(dog.speak())   # Woof!

# Registry-based factory
class PluginFactory:
    _registry: dict[str, type] = {}

    @classmethod
    def register(cls, name):
        def decorator(plugin_cls):
            cls._registry[name] = plugin_cls
            return plugin_cls
        return decorator

    @classmethod
    def create(cls, name, *args, **kwargs):
        if name not in cls._registry:
            raise KeyError(f"Unknown plugin: {name}")
        return cls._registry[name](*args, **kwargs)

@PluginFactory.register("json")
class JsonPlugin:
    def process(self, data): return f"JSON: {data}"

@PluginFactory.register("xml")
class XmlPlugin:
    def process(self, data): return f"XML: <data>{data}</data>"

plugin = PluginFactory.create("json")
print(plugin.process("hello"))

# ── BUILDER ──────────────────────

class QueryBuilder:
    def __init__(self):
        self._table = ""
        self._conditions = []
        self._columns = ["*"]
        self._limit = None
        self._order_by = None

    def from_table(self, table: str) -> "QueryBuilder":
        self._table = table
        return self   # return self for chaining!

    def select(self, *columns: str) -> "QueryBuilder":
        self._columns = list(columns)
        return self

    def where(self, condition: str) -> "QueryBuilder":
        self._conditions.append(condition)
        return self

    def limit(self, n: int) -> "QueryBuilder":
        self._limit = n
        return self

    def order_by(self, col: str, direction="ASC") -> "QueryBuilder":
        self._order_by = f"{col} {direction}"
        return self

    def build(self) -> str:
        cols = ", ".join(self._columns)
        sql = f"SELECT {cols} FROM {self._table}"
        if self._conditions:
            sql += " WHERE " + " AND ".join(self._conditions)
        if self._order_by:
            sql += f" ORDER BY {self._order_by}"
        if self._limit:
            sql += f" LIMIT {self._limit}"
        return sql

query = (QueryBuilder()
    .from_table("users")
    .select("name", "email", "score")
    .where("active = true")
    .where("score > 80")
    .order_by("score", "DESC")
    .limit(10)
    .build())
print(query)

# ── OBSERVER ─────────────────────

class EventEmitter:
    def __init__(self):
        self._listeners: dict[str, list[Callable]] = {}

    def on(self, event: str, callback: Callable) -> None:
        self._listeners.setdefault(event, []).append(callback)

    def off(self, event: str, callback: Callable) -> None:
        if event in self._listeners:
            self._listeners[event].remove(callback)

    def emit(self, event: str, *args, **kwargs) -> None:
        for cb in self._listeners.get(event, []):
            cb(*args, **kwargs)

class UserService(EventEmitter):
    def __init__(self):
        super().__init__()
        self.users = []

    def create_user(self, name: str, email: str):
        user = {"name": name, "email": email, "id": len(self.users)+1}
        self.users.append(user)
        self.emit("user_created", user)
        return user

    def delete_user(self, user_id: int):
        user = next((u for u in self.users if u["id"] == user_id), None)
        if user:
            self.users.remove(user)
            self.emit("user_deleted", user)

service = UserService()
service.on("user_created", lambda u: print(f"📧 Welcome email sent to {u['email']}"))
service.on("user_created", lambda u: print(f"📊 Analytics: new user {u['name']}"))
service.on("user_deleted", lambda u: print(f"🗑️  Account {u['name']} deleted"))

service.create_user("Alice", "alice@example.com")
service.create_user("Bob", "bob@example.com")
service.delete_user(1)

# ── STRATEGY ─────────────────────

# Python way: functions as strategies (simpler than classes)
def bubble_sort(data: list) -> list:
    data = data.copy()
    for i in range(len(data)):
        for j in range(len(data)-i-1):
            if data[j] > data[j+1]:
                data[j], data[j+1] = data[j+1], data[j]
    return data

def quick_sort(data: list) -> list:
    if len(data) <= 1: return data
    pivot = data[len(data)//2]
    left = [x for x in data if x < pivot]
    mid  = [x for x in data if x == pivot]
    right= [x for x in data if x > pivot]
    return quick_sort(left) + mid + quick_sort(right)

class Sorter:
    def __init__(self, strategy: Callable = sorted):
        self.strategy = strategy   # inject the algorithm

    def sort(self, data: list) -> list:
        return self.strategy(data)

data = [3, 1, 4, 1, 5, 9, 2, 6]
sorter = Sorter(bubble_sort)
print(sorter.sort(data))

sorter.strategy = quick_sort   # swap algorithm at runtime!
print(sorter.sort(data))

# ── STATE ────────────────────────

class TrafficLight:
    def __init__(self):
        self._states = {
            "red":    {"next": "green",  "action": "STOP"},
            "green":  {"next": "yellow", "action": "GO"},
            "yellow": {"next": "red",    "action": "SLOW DOWN"},
        }
        self._state = "red"

    def next(self):
        info = self._states[self._state]
        print(f"{self._state.upper()}: {info['action']}")
        self._state = info["next"]

light = TrafficLight()
for _ in range(6):
    light.next()

# ── PROXY ────────────────────────

class LazyLoadProxy:
    '''Loads the expensive object only when first accessed.'''
    def __init__(self, target_class, *args, **kwargs):
        self._target_class = target_class
        self._args = args
        self._kwargs = kwargs
        self._target = None

    def _get_target(self):
        if self._target is None:
            print(f"Loading {self._target_class.__name__}...")
            self._target = self._target_class(*self._args, **self._kwargs)
        return self._target

    def __getattr__(self, name):
        return getattr(self._get_target(), name)

class HeavyDatabase:
    def __init__(self, url):
        print(f"Connecting to {url}...")   # expensive!
        self.url = url
    def query(self, sql): return f"Results for: {sql}"

db = LazyLoadProxy(HeavyDatabase, "postgresql://localhost/mydb")
print("Proxy created (no connection yet)")
print(db.query("SELECT * FROM users"))  # NOW it connects

📝 KEY POINTS:
✅ Python's first-class functions simplify many patterns (Strategy, Command, Observer)
✅ Builder pattern with method chaining creates fluent, readable APIs
✅ Observer (EventEmitter) is fundamental to event-driven architecture
✅ Singleton in Python is best done with metaclass or module-level variable
✅ Factory pattern decouples creation from usage — easy to extend
✅ Lazy proxy defers expensive initialization until first use
❌ Don't apply patterns where they're not needed — simpler is better
❌ Singleton makes testing hard — consider dependency injection instead
❌ Many GoF patterns are unnecessary in Python due to duck typing and first-class functions
""",
  quiz: [
    Quiz(question: 'What problem does the Observer pattern solve?', options: [
      QuizOption(text: 'Creating objects without specifying their exact class', correct: false),
      QuizOption(text: 'Notifying multiple objects when one object changes state', correct: true),
      QuizOption(text: 'Ensuring only one instance of a class exists', correct: false),
      QuizOption(text: 'Adding behavior to objects without modifying their class', correct: false),
    ]),
    Quiz(question: 'What is the Builder pattern best used for?', options: [
      QuizOption(text: 'Creating a single instance of an object', correct: false),
      QuizOption(text: 'Constructing complex objects step by step with a fluent interface', correct: true),
      QuizOption(text: 'Translating between incompatible interfaces', correct: false),
      QuizOption(text: 'Delaying object creation until first use', correct: false),
    ]),
    Quiz(question: 'In Python, what is the simplest way to implement the Strategy pattern?', options: [
      QuizOption(text: 'Create an abstract base class with an algorithm() method', correct: false),
      QuizOption(text: 'Pass functions as arguments since Python has first-class functions', correct: true),
      QuizOption(text: 'Use a dictionary of class names', correct: false),
      QuizOption(text: 'Use multiple inheritance for each strategy', correct: false),
    ]),
  ],
);
