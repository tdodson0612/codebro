import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson43 = Lesson(
  language: 'Python',
  title: 'Advanced OOP: MRO, Mixins & Composition',
  content: """
🎯 METAPHOR:
Multiple inheritance with MRO is like a family reunion
deciding whose recipe to use.
When there's a dispute ("should we make Grandma Alice's
lasagna or Grandma Bob's lasagna?"), the family follows
a strict protocol: check the child's recipe first,
then the left parent, then the right parent, then their
parents, level by level. Python's MRO (C3 linearization)
is this protocol — a deterministic, consistent rule for
"whose version of this method wins?"

Composition over inheritance is like LEGO vs clay.
Inheritance = sculpting from clay (modify the whole thing).
Composition = LEGO blocks (attach exactly what you need).
Need your class to fly AND swim AND shoot lasers?
Don't try to make a multi-inheriting monster.
Just attach a Flyer, a Swimmer, and a LaserCannon component.

📖 EXPLANATION:
This lesson covers Python's MRO, mixin patterns,
composition patterns, __init_subclass__, and class decorators.

─────────────────────────────────────
📐 MRO — Method Resolution Order
─────────────────────────────────────
Python uses C3 Linearization to determine method lookup order.
Access it via: ClassName.__mro__ or ClassName.mro()

Rules:
1. Start with the class itself
2. Check parents left-to-right
3. Each class appears exactly once
4. Parent always comes after ALL its children

─────────────────────────────────────
🧩 MIXIN PATTERN
─────────────────────────────────────
A mixin is a class designed to be inherited alongside
another class to add specific functionality.
It should:
  • Not be instantiated alone
  • Add a focused set of methods
  • Not modify __init__ (or call super().__init__())

class LogMixin:
    def log(self, msg):
        print(f"[{type(self).__name__}] {msg}")

class Model(LogMixin, BaseModel):
    def save(self):
        self.log("Saving...")

─────────────────────────────────────
🏗️  COMPOSITION PATTERN
─────────────────────────────────────
Instead of "is-a" (inheritance), use "has-a" (composition):

class Engine:
    def start(self): ...

class Car:
    def __init__(self):
        self.engine = Engine()   # HAS an engine
    def start(self):
        self.engine.start()

Prefer composition when:
  • Relationship is "has-a" not "is-a"
  • You need to swap implementations at runtime
  • Inheritance creates tight coupling

─────────────────────────────────────
🎣 __init_subclass__
─────────────────────────────────────
Called when a class is subclassed — without metaclass!
class Plugin:
    def __init_subclass__(cls, **kwargs):
        super().__init_subclass__(**kwargs)
        # register cls, validate, etc.

💻 CODE:
# ── MRO EXAMPLES ──────────────────

class A:
    def method(self):
        print("A.method")
        super().method()

class B(A):
    def method(self):
        print("B.method")
        super().method()

class C(A):
    def method(self):
        print("C.method")
        super().method()

class D(B, C):
    def method(self):
        print("D.method")
        super().method()

print(D.__mro__)
# (<class 'D'>, <class 'B'>, <class 'C'>, <class 'A'>, <class 'object'>)

D().method()
# D.method → B.method → C.method → A.method (cooperative chain!)

# ── MIXIN PATTERN ──────────────────

class LogMixin:
    """Adds structured logging to any class."""
    def log(self, level, message):
        print(f"[{level.upper()}] {type(self).__name__}: {message}")

    def log_info(self, msg):    self.log("info", msg)
    def log_warning(self, msg): self.log("warning", msg)
    def log_error(self, msg):   self.log("error", msg)

class ValidateMixin:
    """Adds __post_init__ validation support."""
    def __init_subclass__(cls, **kwargs):
        super().__init_subclass__(**kwargs)
        if hasattr(cls, "validate"):
            original_init = cls.__init__
            def new_init(self, *args, **kwargs):
                original_init(self, *args, **kwargs)
                self.validate()
            cls.__init__ = new_init

class SerializeMixin:
    """Adds JSON serialization."""
    def to_dict(self):
        return {k: v for k, v in self.__dict__.items()
                if not k.startswith("_")}

    def to_json(self):
        import json
        return json.dumps(self.to_dict(), default=str)

    @classmethod
    def from_dict(cls, data):
        obj = cls.__new__(cls)
        obj.__dict__.update(data)
        return obj

class TimestampMixin:
    """Adds created_at and updated_at timestamps."""
    from datetime import datetime

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        from datetime import datetime
        self.created_at = datetime.now()
        self.updated_at = datetime.now()

    def touch(self):
        from datetime import datetime
        self.updated_at = datetime.now()

# Combine mixins
class User(LogMixin, SerializeMixin, TimestampMixin):
    def __init__(self, name: str, email: str):
        super().__init__()   # cooperative super() chains all mixins!
        self.name = name
        self.email = email

    def update_email(self, new_email: str):
        self.log_info(f"Email changed from {self.email} to {new_email}")
        self.email = new_email
        self.touch()

u = User("Alice", "alice@example.com")
u.log_info("User created")
u.update_email("newalice@example.com")
print(u.to_json())

# ── COMPOSITION ────────────────────

class Engine:
    def __init__(self, horsepower: int):
        self.horsepower = horsepower
        self.running = False

    def start(self) -> str:
        self.running = True
        return f"🔥 Engine ({self.horsepower}hp) started"

    def stop(self) -> str:
        self.running = False
        return "Engine stopped"

class GPS:
    def navigate(self, destination: str) -> str:
        return f"📍 Navigating to {destination}"

class AudioSystem:
    def play(self, song: str) -> str:
        return f"🎵 Now playing: {song}"

class Car:
    """Car is composed of components — it HAS them, not IS them."""
    def __init__(self, make: str, hp: int):
        self.make = make
        self.engine = Engine(hp)     # HAS an engine
        self.gps = GPS()             # HAS a GPS
        self.audio = AudioSystem()   # HAS audio

    def start(self):
        return self.engine.start()

    def navigate(self, dest):
        return self.gps.navigate(dest)

    def play(self, song):
        return self.audio.play(song)

tesla = Car("Tesla", 450)
print(tesla.start())
print(tesla.navigate("San Francisco"))
print(tesla.play("Highway to Hell"))

# Composition allows runtime swapping
class ElectricEngine:
    def __init__(self, kw: int):
        self.kw = kw
        self.running = False

    def start(self):
        self.running = True
        return f"⚡ Electric motor ({self.kw}kW) silently engaged"

    def stop(self):
        self.running = False
        return "Motor disengaged"

class HybridCar(Car):
    def __init__(self, make: str):
        super().__init__(make, 200)
        self.electric = ElectricEngine(100)
        self._electric_mode = False

    def toggle_mode(self):
        self._electric_mode = not self._electric_mode

    def start(self):
        if self._electric_mode:
            return self.electric.start()
        return self.engine.start()

prius = HybridCar("Toyota Prius")
print(prius.start())          # combustion
prius.toggle_mode()
print(prius.start())          # electric

# ── __init_subclass__ ──────────────

class Registry:
    """Any subclass is automatically registered."""
    _registry = {}

    def __init_subclass__(cls, category=None, **kwargs):
        super().__init_subclass__(**kwargs)
        if category:
            Registry._registry.setdefault(category, []).append(cls)
        else:
            Registry._registry.setdefault("default", []).append(cls)

class Dog(Registry, category="animal"):
    pass

class Cat(Registry, category="animal"):
    pass

class Car2(Registry, category="vehicle"):
    pass

print(Registry._registry)
# {'animal': [Dog, Cat], 'vehicle': [Car2]}

# ── CLASS DECORATORS ───────────────
# Alternative to metaclasses for many use cases

def singleton(cls):
    """Class decorator that makes a class a singleton."""
    instances = {}
    def get_instance(*args, **kwargs):
        if cls not in instances:
            instances[cls] = cls(*args, **kwargs)
        return instances[cls]
    get_instance.__wrapped__ = cls
    return get_instance

@singleton
class AppSettings:
    def __init__(self):
        self.debug = False
        self.version = "2.0"

s1 = AppSettings()
s2 = AppSettings()
print(s1 is s2)   # True

def add_repr(cls):
    """Add a generic __repr__ to any class."""
    def __repr__(self):
        attrs = ", ".join(f"{k}={v!r}" for k,v in self.__dict__.items())
        return f"{type(self).__name__}({attrs})"
    cls.__repr__ = __repr__
    return cls

@add_repr
class Product:
    def __init__(self, name, price):
        self.name = name
        self.price = price

p = Product("Apple", 1.99)
print(p)   # Product(name='Apple', price=1.99)

📝 KEY POINTS:
✅ MRO (C3 linearization) determines method lookup order in multiple inheritance
✅ Always use cooperative super() — call super() even if you think you know which parent
✅ Mixins add focused functionality without creating deep inheritance
✅ Composition ("has-a") is often better than inheritance ("is-a") for flexibility
✅ __init_subclass__ is a modern alternative to metaclasses for subclass hooks
✅ Class decorators add behavior at class level without metaclass complexity
❌ "Diamond problem" is solved by MRO but you must use cooperative super() everywhere
❌ Mixins should not __init__ unless they use cooperative super() correctly
❌ Deep inheritance (> 3 levels) becomes hard to reason about — prefer composition
""",
  quiz: [
    Quiz(question: 'In Python\'s MRO for class D(B, C), what order are methods searched?', options: [
      QuizOption(text: 'D → C → B → A → object (right-to-left)', correct: false),
      QuizOption(text: 'D → B → C → their parents → object (C3 linearization)', correct: true),
      QuizOption(text: 'D → A → B → C → object (base-first)', correct: false),
      QuizOption(text: 'The order is random and depends on method names', correct: false),
    ]),
    Quiz(question: 'What is the "composition over inheritance" principle?', options: [
      QuizOption(text: 'Never use inheritance — only use functions', correct: false),
      QuizOption(text: 'Give objects the behaviors they need by containing other objects rather than deep inheritance', correct: true),
      QuizOption(text: 'Use @dataclass instead of class', correct: false),
      QuizOption(text: 'Compose functions using functools instead of methods', correct: false),
    ]),
    Quiz(question: 'What does __init_subclass__ allow you to do without a metaclass?', options: [
      QuizOption(text: 'Override __init__ in all subclasses automatically', correct: false),
      QuizOption(text: 'Execute code whenever a class is subclassed — great for registries and validation', correct: true),
      QuizOption(text: 'Prevent a class from being subclassed', correct: false),
      QuizOption(text: 'Change the MRO of subclasses', correct: false),
    ]),
  ],
);
