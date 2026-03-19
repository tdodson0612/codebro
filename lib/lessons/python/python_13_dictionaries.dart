import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson13 = Lesson(
  language: 'Python',
  title: 'Dictionaries',
  content: '''
🎯 METAPHOR:
A dictionary is like a real-world phone book — but instant.
In a phone book, you look up a NAME (the key) to find a
PHONE NUMBER (the value). You don't scan page by page;
you go directly to the name. Python dictionaries work
exactly this way: you give it a key, it gives you the value
in O(1) time — instantly, regardless of how many entries
there are. It's one of Python's most powerful data structures.

📖 EXPLANATION:
Dictionaries store KEY-VALUE pairs.
Keys must be unique and IMMUTABLE (strings, numbers, tuples).
Values can be anything, including other dicts or lists.

From Python 3.7+, dictionaries MAINTAIN INSERTION ORDER.

─────────────────────────────────────
📐 CREATING DICTIONARIES
─────────────────────────────────────
empty  = {}
person = {"name": "Alice", "age": 30}
scores = dict(math=95, english=87, science=92)
from_pairs = dict([("a", 1), ("b", 2), ("c", 3)])
from_keys = dict.fromkeys(["a","b","c"], 0)  # all val=0

─────────────────────────────────────
🔑 ACCESSING VALUES
─────────────────────────────────────
d["key"]           → value (KeyError if not found!)
d.get("key")       → value or None if not found
d.get("key", default) → value or default if not found

ALWAYS use .get() for uncertain keys!
d["missing"] raises KeyError
d.get("missing") returns None safely

─────────────────────────────────────
🛠️  DICTIONARY METHODS
─────────────────────────────────────
Reading:
  d.keys()     → view of all keys
  d.values()   → view of all values
  d.items()    → view of (key, value) pairs

Writing:
  d[key] = value       — add or update
  d.update(other)      — merge another dict in
  d.update(k=v, k2=v2) — update with keyword args
  d.setdefault(k, v)   — set only if key missing

Removing:
  del d[key]           — delete (KeyError if missing)
  d.pop(key)           — delete and return value
  d.pop(key, default)  — delete, return default if missing
  d.popitem()          — remove and return last inserted (k,v)
  d.clear()            — remove all items

Copying:
  d.copy()             — shallow copy
  dict(d)              — shallow copy

─────────────────────────────────────
🔀 DICTIONARY MERGING (Python 3.9+)
─────────────────────────────────────
merged = dict1 | dict2    # new merged dict
dict1 |= dict2            # update dict1 in place

─────────────────────────────────────
💡 DICT COMPREHENSIONS
─────────────────────────────────────
{key_expr: val_expr for item in iterable if cond}

squares = {x: x**2 for x in range(1, 6)}
# {1:1, 2:4, 3:9, 4:16, 5:25}

inverted = {v: k for k, v in original.items()}

─────────────────────────────────────
🏗️  DEFAULTDICT & COUNTER
─────────────────────────────────────
from collections import defaultdict, Counter

defaultdict — never raises KeyError, provides default:
dd = defaultdict(list)   # default value is []
dd["new_key"].append(1)  # no KeyError!

Counter — counts hashable objects:
c = Counter("abracadabra")
c.most_common(3)   # [('a', 5), ('b', 2), ('r', 2)]

─────────────────────────────────────
🪆 NESTED DICTIONARIES
─────────────────────────────────────
database = {
    "alice": {"age": 30, "scores": [95, 87]},
    "bob":   {"age": 25, "scores": [72, 88]},
}
database["alice"]["age"]        → 30
database["alice"]["scores"][0]  → 95

💻 CODE:
# Creating
person = {
    "name": "Alice",
    "age": 30,
    "skills": ["Python", "SQL", "Docker"],
    "address": {"city": "NYC", "zip": "10001"}
}

# Accessing
print(person["name"])           # Alice
print(person.get("age"))        # 30
print(person.get("salary", 0))  # 0 (default, no KeyError)

# Nested access
print(person["address"]["city"])  # NYC
print(person["skills"][0])        # Python

# Adding and updating
person["email"] = "alice@example.com"   # add new key
person["age"] = 31                       # update existing
person.setdefault("country", "USA")      # only set if missing
print(person)

# Deleting
removed = person.pop("email")   # remove and return
print(f"Removed: {removed}")
del person["address"]           # delete without returning

# Iterating
inventory = {"apple": 10, "banana": 5, "cherry": 20}
for key in inventory:
    print(key)  # just keys

for value in inventory.values():
    print(value)  # just values

for key, value in inventory.items():
    print(f"{key}: {value}")

# Checking membership
print("apple" in inventory)      # True (checks keys!)
print("apple" in inventory.values())  # False (checking values)
print(10 in inventory.values())  # True

# Dict comprehension
squares = {x: x**2 for x in range(1, 6)}
print(squares)  # {1:1, 2:4, 3:9, 4:16, 5:25}

# Invert a dictionary
original = {"a": 1, "b": 2, "c": 3}
inverted = {v: k for k, v in original.items()}
print(inverted)   # {1:'a', 2:'b', 3:'c'}

# Filter dict by condition
scores = {"Alice": 92, "Bob": 65, "Carol": 88, "Dave": 71}
passing = {k: v for k, v in scores.items() if v >= 70}
print(passing)   # Alice, Carol, Dave

# Merging dicts (Python 3.9+)
defaults = {"color": "blue", "size": "medium", "qty": 1}
custom = {"color": "red", "qty": 5}
final = defaults | custom    # custom values win
print(final)  # {"color": "red", "size": "medium", "qty": 5}

# defaultdict
from collections import defaultdict

# Group words by first letter
words = ["apple", "ant", "bat", "banana", "cherry", "cat"]
by_letter = defaultdict(list)
for word in words:
    by_letter[word[0]].append(word)
print(dict(by_letter))
# {'a': ['apple', 'ant'], 'b': ['bat', 'banana'], 'c': ['cherry', 'cat']}

# Counter
from collections import Counter
text = "mississippi"
letter_count = Counter(text)
print(letter_count)               # Counter({'i':4,'s':4,'p':2,'m':1})
print(letter_count.most_common(3)) # [('i',4), ('s',4), ('p',2)]
print(letter_count['z'])           # 0 (no KeyError!)

# Nested dict manipulation
users = {}
users["alice"] = {"login_count": 0, "permissions": []}
users["alice"]["login_count"] += 1
users["alice"]["permissions"].append("read")
print(users)

# Dict as a switch/dispatch table
def add(a, b): return a + b
def sub(a, b): return a - b
def mul(a, b): return a * b

operations = {"+": add, "-": sub, "*": mul}
op = "+"
result = operations[op](10, 5)
print(f"10 {op} 5 = {result}")   # 10 + 5 = 15

# Counting occurrences (manual)
votes = ["Alice", "Bob", "Alice", "Carol", "Bob", "Alice"]
tally = {}
for vote in votes:
    tally[vote] = tally.get(vote, 0) + 1
print(tally)  # {'Alice': 3, 'Bob': 2, 'Carol': 1}

📝 KEY POINTS:
✅ Use .get(key, default) instead of [key] to avoid KeyError
✅ Dict maintains insertion order (Python 3.7+)
✅ Keys must be immutable (str, int, float, tuple) — not lists!
✅ Dict comprehensions: {k:v for k,v in items if condition}
✅ Use defaultdict to avoid "key not found" errors
✅ Use Counter for frequency counting
✅ d.items() gives (key, value) tuples for iteration
❌ d["missing_key"] raises KeyError — use .get() instead
❌ Lists cannot be dict keys (they're mutable/unhashable)
❌ Modifying a dict while iterating raises RuntimeError — iterate d.copy()
''',
  quiz: [
    Quiz(question: 'What is the safest way to access a possibly-missing dictionary key?', options: [
      QuizOption(text: 'd.get("key", default_value)', correct: true),
      QuizOption(text: 'd["key"] inside a try/except', correct: false),
      QuizOption(text: 'if "key" in d: d["key"]', correct: false),
      QuizOption(text: 'd.fetch("key")', correct: false),
    ]),
    Quiz(question: 'What does "key" in my_dict check?', options: [
      QuizOption(text: 'Whether "key" is in the dictionary values', correct: false),
      QuizOption(text: 'Whether "key" is in the dictionary keys', correct: true),
      QuizOption(text: 'Whether "key" is in both keys and values', correct: false),
      QuizOption(text: 'Whether "key" is a valid Python identifier', correct: false),
    ]),
    Quiz(question: 'What does defaultdict(list) do when you access a missing key?', options: [
      QuizOption(text: 'Raises a KeyError', correct: false),
      QuizOption(text: 'Returns None', correct: false),
      QuizOption(text: 'Creates the key with an empty list as its value', correct: true),
      QuizOption(text: 'Returns 0', correct: false),
    ]),
  ],
);
