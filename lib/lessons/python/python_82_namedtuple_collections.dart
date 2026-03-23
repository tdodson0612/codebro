import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson82 = Lesson(
  language: 'Python',
  title: 'namedtuple, OrderedDict & ChainMap',
  content: """
🎯 METAPHOR:
namedtuple is like a form with labeled fields.
A plain tuple is a row of boxes: box[0], box[1], box[2].
You must remember "oh, index 2 is the ZIP code."
A namedtuple labels each box: address.zip_code.
Same memory efficiency as a tuple — but the fields have
meaningful names. You can still unpack it like a tuple,
iterate it, index it — and you get the readability bonus.

OrderedDict used to be essential when dicts didn't
preserve insertion order. In Python 3.7+ regular dicts
DO preserve order, so OrderedDict is mainly useful for
its extra methods: move_to_end() and the fact that
two OrderedDicts compare order-sensitively.

ChainMap lets multiple dicts appear as one — it searches
the first dict, then the second, then the third. Like
layered config files: user settings override defaults.

📖 EXPLANATION:
These collections.abc tools fill specific gaps that
plain dict and tuple don't cover cleanly.

─────────────────────────────────────
📦 NAMEDTUPLE — TWO FLAVORS
─────────────────────────────────────
from collections import namedtuple

Old style (factory function):
  Point = namedtuple("Point", ["x", "y"])
  Point = namedtuple("Point", "x y")    # space-separated string

New style (class with type hints):
  from typing import NamedTuple
  class Point(NamedTuple):
      x: float
      y: float
      label: str = ""    # with default!

NamedTuple class style is always preferred — it supports
defaults, docstrings, and methods.

─────────────────────────────────────
🔄 NAMEDTUPLE FEATURES
─────────────────────────────────────
p.x, p.y          → named field access
p[0], p[1]        → index access (still a tuple!)
x, y = p          → unpacking works
p._asdict()       → convert to dict
p._replace(x=10)  → create modified copy (immutable!)
p._fields         → ('x', 'y')
Point._make([1,2]) → create from iterable

─────────────────────────────────────
📚 ORDEREDDICT
─────────────────────────────────────
from collections import OrderedDict

d.move_to_end("key")           → move to end (default)
d.move_to_end("key", last=False) → move to front
popitem(last=True)             → pop last (True) or first (False)
Two OrderedDicts are equal only if same order!

─────────────────────────────────────
🔗 CHAINMAP
─────────────────────────────────────
from collections import ChainMap

ChainMap searches maps left-to-right (first match wins)
Updates and deletes only affect the FIRST map
New maps inserted at the front with .new_child()
Access original maps via .maps attribute

💻 CODE:
from collections import namedtuple, OrderedDict, ChainMap
from typing import NamedTuple

# ── NAMEDTUPLE OLD STYLE ──────────

Point = namedtuple("Point", ["x", "y"])
Color = namedtuple("Color", "red green blue")

p = Point(3.0, 4.0)
print(p)          # Point(x=3.0, y=4.0)
print(p.x, p.y)   # 3.0 4.0
print(p[0], p[1]) # 3.0 4.0 (still a tuple!)
x, y = p          # unpack works!

# Tuple operations still work
import math
distance = math.sqrt(p.x**2 + p.y**2)
print(f"Distance from origin: {distance}")

# Named access is MORE readable than index
c = Color(255, 128, 0)
print(f"Red: {c.red}, Green: {c.green}, Blue: {c.blue}")
print(f"Hex: #{c.red:02x}{c.green:02x}{c.blue:02x}")

# Convert to dict
print(p._asdict())   # {'x': 3.0, 'y': 4.0}

# Immutable — create modified copy
p2 = p._replace(x=10.0)
print(p2)   # Point(x=10.0, y=4.0)
print(p)    # Point(x=3.0, y=4.0) — original unchanged!

# Create from iterable
coords = [5.0, 6.0]
p3 = Point._make(coords)
print(p3)   # Point(x=5.0, y=6.0)

# Fields tuple
print(Point._fields)   # ('x', 'y')

# ── NAMEDTUPLE NEW STYLE (preferred) ──

class Employee(NamedTuple):
    """An employee record."""
    name: str
    department: str
    salary: float
    level: int = 1    # default value!

    @property
    def annual_bonus(self) -> float:
        return self.salary * 0.1 * self.level

    def promote(self, raise_pct: float = 0.1) -> "Employee":
        return self._replace(
            level=self.level + 1,
            salary=self.salary * (1 + raise_pct)
        )

e1 = Employee("Alice", "Engineering", 95000.0, level=3)
e2 = Employee("Bob", "Marketing", 72000.0)  # level defaults to 1

print(e1)
print(f"Bonus:\${e1.annual_bonus:,.0f}")

promoted = e1.promote(0.15)
print(f"After promotion: {promoted}")

# Sort employees
employees = [e1, e2, Employee("Carol", "Engineering", 98000.0, 4)]
by_salary = sorted(employees, key=lambda e: e.salary, reverse=True)
for e in by_salary:
    print(f"  {e.name:<10}\${e.salary:>10,.0f} (L{e.level})")

# Still a tuple — works with CSV, dict, etc.
print(list(e1))    # ['Alice', 'Engineering', 95000.0, 3]
print(e1._asdict()) # OrderedDict or dict

# Comparison (field by field, like tuples)
p1 = Point(1.0, 2.0)
p2 = Point(1.0, 3.0)
print(p1 < p2)   # True (x equal, y: 2 < 3)

# ── ORDEREDDICT ───────────────────

# Python 3.7+ regular dicts preserve insertion order
# OrderedDict still useful for:
# 1. move_to_end() method
# 2. Order-sensitive equality
# 3. popitem(last=False) — FIFO queue behavior

od = OrderedDict()
od["first"]  = 1
od["second"] = 2
od["third"]  = 3
od["fourth"] = 4

print(od)   # OrderedDict([('first',1), ('second',2), ...])

# Move to end
od.move_to_end("first")   # move to back
print(list(od.keys()))    # ['second', 'third', 'fourth', 'first']

od.move_to_end("first", last=False)   # move to front
print(list(od.keys()))    # ['first', 'second', 'third', 'fourth']

# Order-sensitive equality (unlike regular dicts!)
d1 = OrderedDict([("a", 1), ("b", 2)])
d2 = OrderedDict([("b", 2), ("a", 1)])
d3 = {"a": 1, "b": 2}
d4 = {"b": 2, "a": 1}

print(d1 == d2)   # False — different order!
print(d3 == d4)   # True  — regular dicts ignore order

# LRU Cache implementation with OrderedDict
class LRUCache:
    def __init__(self, capacity: int):
        self.capacity = capacity
        self.cache = OrderedDict()

    def get(self, key):
        if key not in self.cache:
            return -1
        self.cache.move_to_end(key)   # mark as recently used
        return self.cache[key]

    def put(self, key, value):
        if key in self.cache:
            self.cache.move_to_end(key)
        self.cache[key] = value
        if len(self.cache) > self.capacity:
            self.cache.popitem(last=False)   # remove oldest

lru = LRUCache(3)
lru.put("a", 1); lru.put("b", 2); lru.put("c", 3)
print(lru.get("a"))   # 1, and "a" moves to end
lru.put("d", 4)       # evicts "b" (least recently used)
print(lru.get("b"))   # -1 (evicted)
print(lru.get("c"))   # 3

# FIFO queue using OrderedDict
fifo = OrderedDict()
fifo["task1"] = "do thing"
fifo["task2"] = "do other"
fifo["task3"] = "do more"
task = fifo.popitem(last=False)   # pop from front
print(f"Processing: {task}")

# ── CHAINMAP ──────────────────────

# Classic use: layered configuration
defaults = {"color": "blue", "size": "M", "debug": False, "timeout": 30}
user_prefs = {"color": "red", "size": "XL"}
cli_args = {"debug": True}

# Priority: CLI > user > defaults
config = ChainMap(cli_args, user_prefs, defaults)

print(config["color"])    # red   (from user_prefs)
print(config["debug"])    # True  (from cli_args)
print(config["timeout"])  # 30    (from defaults)
print(config["size"])     # XL    (from user_prefs)

# See all maps
print(config.maps)

# Update only affects the FIRST map
config["timeout"] = 60
print(cli_args)    # {'debug': True, 'timeout': 60}  — updated!
print(defaults)    # {'timeout': 30} — unchanged!

# new_child() — add a higher-priority layer
runtime = config.new_child({"color": "green"})
print(runtime["color"])   # green (from new child)
print(config["color"])    # red   (runtime doesn't affect config)

# Access the underlying maps
print(config.parents)   # ChainMap without the first map

# Practical: scope simulation
global_scope = {"x": 1, "y": 2, "print": print}
local_scope  = {"x": 99, "z": 3}   # x shadows global

scope = ChainMap(local_scope, global_scope)
print(scope["x"])   # 99 (local wins)
print(scope["y"])   # 2  (from global)
print(scope["z"])   # 3  (only in local)

# Convert to regular dict (all visible keys)
merged = dict(config)
print(merged)

📝 KEY POINTS:
✅ Use NamedTuple class style — supports defaults, methods, docstrings
✅ namedtuple is a tuple — same memory, same performance, named access bonus
✅ _replace() creates a modified copy — namedtuples are immutable
✅ OrderedDict.move_to_end() is the key feature for LRU cache patterns
✅ OrderedDict equality is order-sensitive; regular dict equality is not
✅ ChainMap searches maps left-to-right — first match wins
✅ ChainMap writes go to the FIRST map only
✅ ChainMap is perfect for layered configs: defaults < user < CLI < runtime
❌ Don't use old-style namedtuple() when NamedTuple class is cleaner
❌ In Python 3.7+, don't use OrderedDict just for insertion-order — regular dict preserves it
❌ ChainMap updates don't propagate to parent maps — only the first map changes
""",
  quiz: [
    Quiz(question: 'What is the advantage of NamedTuple over a regular tuple?', options: [
      QuizOption(text: 'NamedTuple is faster than regular tuples', correct: false),
      QuizOption(text: 'Fields can be accessed by name (point.x) and the tuple still supports all tuple operations', correct: true),
      QuizOption(text: 'NamedTuple values can be modified after creation', correct: false),
      QuizOption(text: 'NamedTuple uses less memory than regular tuples', correct: false),
    ]),
    Quiz(question: 'When is OrderedDict still useful in Python 3.7+?', options: [
      QuizOption(text: 'It is never useful — regular dicts preserve order now', correct: false),
      QuizOption(text: 'For move_to_end(), order-sensitive equality, and popitem(last=False)', correct: true),
      QuizOption(text: 'Only for backwards compatibility with Python 2', correct: false),
      QuizOption(text: 'OrderedDict is faster than dict for lookups', correct: false),
    ]),
    Quiz(question: 'With ChainMap(a, b, c), where do writes go?', options: [
      QuizOption(text: 'Distributed across all maps', correct: false),
      QuizOption(text: 'Only to map a — the first (highest priority) map', correct: true),
      QuizOption(text: 'To whichever map originally contained that key', correct: false),
      QuizOption(text: 'To map c — the lowest priority map', correct: false),
    ]),
  ],
);
