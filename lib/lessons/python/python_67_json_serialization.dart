import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson67 = Lesson(
  language: 'Python',
  title: 'JSON & Data Serialization',
  content: """
🎯 METAPHOR:
Serialization is like packing a complex piece of furniture
for shipping. A bookshelf with books, a lamp, and a desk
can't be shipped as-is — you disassemble it into flat parts,
wrap each piece, pack it in a box, label it. The recipient
un-boxes, unwraps, and reassembles. JSON is the world's
most popular "flat packing standard" for data — any system
can read and write it, and it faithfully represents your
data structure after being shipped across a network,
saved to disk, or stored in a database.

📖 EXPLANATION:
Serialization converts Python objects → transportable format.
Deserialization reverses this. JSON is the universal standard;
Python also has pickle (Python-only), msgpack (binary), etc.

─────────────────────────────────────
📦 JSON BASICS
─────────────────────────────────────
JSON supports:
  string   → Python str
  number   → Python int or float
  boolean  → Python True/False (true/false in JSON)
  null     → Python None
  array    → Python list
  object   → Python dict

NOT in JSON: datetime, set, tuple, bytes, custom objects

─────────────────────────────────────
🔑 JSON MODULE API
─────────────────────────────────────
json.dumps(obj)           → Python object → JSON string
json.loads(string)        → JSON string → Python object
json.dump(obj, file)      → write JSON to file
json.load(file)           → read JSON from file

Options for dumps/dump:
  indent=2                → pretty-print
  sort_keys=True          → alphabetical keys
  ensure_ascii=False      → allow Unicode
  default=encoder_func    → handle custom types

─────────────────────────────────────
🏗️  CUSTOM SERIALIZATION
─────────────────────────────────────
Option 1: default= parameter — for types json doesn't know
Option 2: JSONEncoder subclass — full control
Option 3: Add .to_dict() / .to_json() methods to classes

─────────────────────────────────────
⚡ ALTERNATIVES
─────────────────────────────────────
pickle   → any Python object, Python-only, not safe for untrusted data
msgpack  → binary JSON, faster, smaller (pip install msgpack)
orjson   → ultrafast JSON (pip install orjson)
pydantic → validation + serialization together

💻 CODE:
import json
import datetime
from pathlib import Path
from dataclasses import dataclass, asdict
from typing import Any

# ── BASIC JSON ─────────────────────

# Python → JSON string
data = {
    "name": "Alice",
    "age": 30,
    "scores": [92, 88, 95],
    "active": True,
    "metadata": None
}

json_str = json.dumps(data)
print(json_str)
print(type(json_str))   # str

# Pretty-printed
pretty = json.dumps(data, indent=2, sort_keys=True)
print(pretty)

# JSON string → Python
parsed = json.loads(json_str)
print(parsed["name"])     # Alice
print(type(parsed))       # dict

# JSON type mapping
json_all = """
{
  "string": "hello",
  "integer": 42,
  "float": 3.14,
  "bool_true": true,
  "bool_false": false,
  "null_value": null,
  "array": [1, 2, 3],
  "object": {"nested": "value"}
}
"""
py = json.loads(json_all)
for k, v in py.items():
    print(f"  {k:12s}: {type(v).__name__:6s} = {v!r}")

# ── FILE I/O ──────────────────────

config = {
    "database": {"host": "localhost", "port": 5432},
    "debug": False,
    "allowed_hosts": ["localhost", "127.0.0.1"]
}

# Write to file
with open("config.json", "w", encoding="utf-8") as f:
    json.dump(config, f, indent=2)

# Read from file
with open("config.json", "r", encoding="utf-8") as f:
    loaded = json.load(f)

print(loaded["database"]["host"])   # localhost

# Pathlib shortcut
Path("config.json").write_text(json.dumps(config, indent=2))
config2 = json.loads(Path("config.json").read_text())

# ── HANDLING UNICODE ──────────────

# By default, non-ASCII chars are escaped
data = {"greeting": "Héllo Wörld 你好"}
print(json.dumps(data))                           # escaped
print(json.dumps(data, ensure_ascii=False))       # Unicode preserved

# ── CUSTOM TYPES ──────────────────

# json doesn't know datetime, set, bytes, etc.
# Use default= for one-off types

def json_default(obj):
    if isinstance(obj, datetime.datetime):
        return obj.isoformat()
    if isinstance(obj, datetime.date):
        return obj.isoformat()
    if isinstance(obj, set):
        return sorted(list(obj))   # sets → sorted lists
    if isinstance(obj, bytes):
        return obj.decode("utf-8")
    raise TypeError(f"Object of type {type(obj)} is not JSON serializable")

data = {
    "created": datetime.datetime(2024, 3, 15, 10, 30),
    "tags": {"python", "backend", "api"},
    "binary": b"hello"
}

print(json.dumps(data, default=json_default, indent=2))

# ── CUSTOM ENCODER CLASS ──────────

class SmartEncoder(json.JSONEncoder):
    def default(self, obj):
        # Dataclasses
        if hasattr(obj, "__dataclass_fields__"):
            return asdict(obj)
        # datetime
        if isinstance(obj, (datetime.datetime, datetime.date)):
            return obj.isoformat()
        # Custom objects with .to_dict()
        if hasattr(obj, "to_dict"):
            return obj.to_dict()
        # sets
        if isinstance(obj, set):
            return sorted(list(obj))
        return super().default(obj)

@dataclass
class User:
    name: str
    email: str
    created: datetime.datetime
    roles: set

user = User(
    name="Alice",
    email="alice@example.com",
    created=datetime.datetime(2024, 1, 1, 9, 0),
    roles={"admin", "editor"}
)

json_str = json.dumps(user, cls=SmartEncoder, indent=2)
print(json_str)

# ── CUSTOM DECODER ────────────────

def date_decoder(obj):
    """Revive ISO datetime strings during parsing."""
    for key, value in obj.items():
        if isinstance(value, str):
            try:
                obj[key] = datetime.datetime.fromisoformat(value)
            except ValueError:
                pass
    return obj

json_with_dates = '{"name": "Alice", "created": "2024-01-01T09:00:00"}'
decoded = json.loads(json_with_dates, object_hook=date_decoder)
print(decoded["created"])              # datetime object
print(type(decoded["created"]))        # datetime.datetime

# ── SERIALIZING DATACLASSES ────────

@dataclass
class Address:
    street: str
    city: str
    country: str

@dataclass
class Person:
    name: str
    age: int
    address: Address
    scores: list[float]

person = Person(
    name="Alice",
    age=30,
    address=Address("123 Main St", "NYC", "USA"),
    scores=[92.5, 88.0, 95.5]
)

# asdict() converts nested dataclasses to dicts
d = asdict(person)
json_str = json.dumps(d, indent=2)
print(json_str)

# Deserialize back
d2 = json.loads(json_str)
person2 = Person(
    name=d2["name"],
    age=d2["age"],
    address=Address(**d2["address"]),
    scores=d2["scores"]
)
print(person2)

# ── JSONLINES FORMAT ──────────────

# One JSON object per line — great for large datasets
records = [
    {"id": 1, "name": "Alice", "score": 92},
    {"id": 2, "name": "Bob",   "score": 78},
    {"id": 3, "name": "Carol", "score": 95},
]

# Write JSONL
with open("data.jsonl", "w") as f:
    for record in records:
        f.write(json.dumps(record) + "\\n")

# Read JSONL
loaded_records = []
with open("data.jsonl", "r") as f:
    for line in f:
        if line.strip():
            loaded_records.append(json.loads(line))

print(loaded_records)

# ── SAFE JSON OPERATIONS ──────────

def safe_json_load(path: str, default: Any = None) -> Any:
    """Load JSON file, return default on any error."""
    try:
        with open(path, "r", encoding="utf-8") as f:
            return json.load(f)
    except (FileNotFoundError, json.JSONDecodeError, PermissionError) as e:
        print(f"Warning: Could not load {path}: {e}")
        return default

config = safe_json_load("config.json", default={})
missing = safe_json_load("nonexistent.json", default={"fallback": True})
print(missing)

# Validate JSON structure
def validate_user_json(data: dict) -> list[str]:
    """Returns list of validation errors."""
    errors = []
    required = ["name", "email", "age"]
    for field in required:
        if field not in data:
            errors.append(f"Missing required field: {field}")
    if "age" in data and not isinstance(data["age"], int):
        errors.append("age must be an integer")
    if "email" in data and "@" not in data.get("email", ""):
        errors.append("email must contain @")
    return errors

test = {"name": "Alice", "email": "not-an-email", "age": "thirty"}
print(validate_user_json(test))

📝 KEY POINTS:
✅ json.dumps() → string; json.dump() → file; add 's' = string version
✅ Use indent=2 for human-readable; omit for compact/network transfer
✅ JSON supports: str, int, float, bool, None, list, dict — nothing else
✅ Use default= for one-off custom types; subclass JSONEncoder for reuse
✅ always open JSON files with encoding="utf-8" and ensure_ascii=False for Unicode
✅ JSONL (one object per line) is great for large streaming datasets
✅ asdict() converts dataclasses to nested dicts ready for json.dumps()
❌ json.loads() parses strings; json.load() parses file objects — easy to mix up
❌ Never use json for sensitive secrets in source code — use env vars
❌ Avoid pickle for untrusted data — it can execute arbitrary code
""",
  quiz: [
    Quiz(question: 'What is the difference between json.dumps() and json.dump()?', options: [
      QuizOption(text: 'dumps() is faster; dump() is safer', correct: false),
      QuizOption(text: 'dumps() returns a string; dump() writes to a file object', correct: true),
      QuizOption(text: 'dump() handles nested objects; dumps() only handles flat data', correct: false),
      QuizOption(text: 'They are identical — just different naming conventions', correct: false),
    ]),
    Quiz(question: 'What does the default= parameter in json.dumps() do?', options: [
      QuizOption(text: 'Sets the default value for missing keys', correct: false),
      QuizOption(text: 'Provides a fallback function to serialize objects JSON doesn\'t know how to handle', correct: true),
      QuizOption(text: 'Sets the default indentation level', correct: false),
      QuizOption(text: 'Specifies what to return when the input is None', correct: false),
    ]),
    Quiz(question: 'Which Python types can be directly serialized to JSON?', options: [
      QuizOption(text: 'All Python types including datetime and custom classes', correct: false),
      QuizOption(text: 'str, int, float, bool, None, list, and dict only', correct: true),
      QuizOption(text: 'Any type that implements __str__', correct: false),
      QuizOption(text: 'str, int, float, bool, None, list, dict, tuple, and set', correct: false),
    ]),
  ],
);
