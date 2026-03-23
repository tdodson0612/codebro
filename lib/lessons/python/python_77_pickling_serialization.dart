import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson77 = Lesson(
  language: 'Python',
  title: 'Pickle, Shelve & Binary Serialization',
  content: """
🎯 METAPHOR:
Pickle is like flash-freezing cooked food.
You take a fully prepared Python object — class instance,
dictionary with custom types, complex graph of objects —
and freeze it into a binary blob. Later, you defrost
(unpickle) it and get back the exact same object, ready
to use. But just like you wouldn't eat mystery frozen food
from a stranger's freezer, you should never unpickle data
from an untrusted source — the "defrosting" process can
execute arbitrary code.

📖 EXPLANATION:
pickle serializes Python objects to binary format.
shelve provides a persistent dict backed by pickle.
These are Python-specific formats — not portable to
other languages. Use JSON for interoperability;
use pickle when you need to save complex Python objects.

─────────────────────────────────────
📦 PICKLE
─────────────────────────────────────
import pickle

pickle.dumps(obj)        → bytes
pickle.loads(data)       → object
pickle.dump(obj, file)   → write to file
pickle.load(file)        → read from file

protocols: 0-5 (5 is fastest/most compact, Python 3.8+)
pickle.dump(obj, f, protocol=pickle.HIGHEST_PROTOCOL)

─────────────────────────────────────
🗄️  SHELVE
─────────────────────────────────────
import shelve

with shelve.open("mydb") as db:
    db["key"] = any_python_object
    value = db["key"]
    del db["key"]
    for key in db:  ...

Like a persistent dict — keys must be strings.
Values can be any picklable object.

─────────────────────────────────────
⚠️  SECURITY WARNING
─────────────────────────────────────
NEVER unpickle data from untrusted sources!
Pickle can execute arbitrary code on load.
Only pickle/unpickle data you created yourself.

─────────────────────────────────────
🔧 WHAT CAN BE PICKLED
─────────────────────────────────────
✅ Basic types: int, float, str, bytes, bool, None
✅ Containers: list, tuple, dict, set
✅ Functions (by reference — must be importable)
✅ Classes (by reference — must be importable)
✅ Class instances (if class is importable)
✅ Lambdas? ❌ No! Use regular functions.

─────────────────────────────────────
🎛️  CUSTOMIZING PICKLE
─────────────────────────────────────
__getstate__(self)    → what to save
__setstate__(self, d) → how to restore
__reduce__(self)      → full custom pickling

─────────────────────────────────────
⚡ ALTERNATIVES TO PICKLE
─────────────────────────────────────
JSON        → portable, human-readable, limited types
msgpack     → binary JSON (faster, smaller)
joblib      → better for numpy arrays (scikit-learn uses it)
cloudpickle → pickle lambdas and closures (pip)
dill        → extended pickle (pip)
marshal     → Python internal code objects (not for general use)

💻 CODE:
import pickle
import shelve
import io
from pathlib import Path
from dataclasses import dataclass
from datetime import datetime

# ── BASIC PICKLE ──────────────────

# Simple objects
data = {
    "name": "Alice",
    "scores": [92, 88, 95],
    "active": True,
    "created": datetime(2024, 3, 15, 10, 30),
}

# Serialize to bytes
pickled = pickle.dumps(data)
print(f"Pickled size: {len(pickled)} bytes")
print(f"Type: {type(pickled)}")   # bytes

# Deserialize
restored = pickle.loads(pickled)
print(f"Restored: {restored}")
print(f"datetime type: {type(restored['created'])}")  # datetime!

# To/from file
with open("data.pkl", "wb") as f:   # 'wb' = write binary!
    pickle.dump(data, f, protocol=pickle.HIGHEST_PROTOCOL)

with open("data.pkl", "rb") as f:   # 'rb' = read binary!
    loaded = pickle.load(f)
print(f"From file: {loaded['name']}")

# Using BytesIO (in-memory file)
buffer = io.BytesIO()
pickle.dump(data, buffer, protocol=5)
buffer.seek(0)
restored2 = pickle.load(buffer)
print(f"From buffer: {restored2['name']}")

# ── PICKLING CUSTOM CLASSES ────────

@dataclass
class GameSave:
    player_name: str
    level: int
    health: int
    inventory: list[str]
    position: tuple[float, float]
    timestamp: datetime = None

    def __post_init__(self):
        if self.timestamp is None:
            self.timestamp = datetime.now()

    def save(self, path: str):
        with open(path, "wb") as f:
            pickle.dump(self, f, protocol=pickle.HIGHEST_PROTOCOL)
        print(f"Saved game for {self.player_name}")

    @classmethod
    def load(cls, path: str) -> "GameSave":
        with open(path, "rb") as f:
            save = pickle.load(f)
        print(f"Loaded save for {save.player_name}")
        return save

save = GameSave(
    player_name="Alice",
    level=15,
    health=87,
    inventory=["sword", "shield", "healing_potion"],
    position=(342.5, 891.2),
)
save.save("gamesave.pkl")
loaded_save = GameSave.load("gamesave.pkl")
print(f"Level: {loaded_save.level}, Health: {loaded_save.health}")
print(f"Inventory: {loaded_save.inventory}")

# ── CUSTOM __GETSTATE__ / __SETSTATE__ ─

class DatabaseConnection:
    """Can't pickle open connections — customize pickling."""

    def __init__(self, host: str, port: int, db: str):
        self.host = host
        self.port = port
        self.db = db
        self._connection = None   # NOT picklable!
        self._connect()

    def _connect(self):
        print(f"Connecting to {self.host}:{self.port}/{self.db}")
        self._connection = f"<connection to {self.host}>"  # fake

    def query(self, sql: str):
        return f"Results for: {sql}"

    def __getstate__(self):
        """What to save — exclude unpicklable connection."""
        state = self.__dict__.copy()
        del state["_connection"]   # remove the connection
        return state

    def __setstate__(self, state):
        """How to restore — reconnect after unpickling."""
        self.__dict__.update(state)
        self._connect()   # reconnect on restore

    def __repr__(self):
        return f"DB({self.host}/{self.db})"

db = DatabaseConnection("localhost", 5432, "mydb")
print(f"Before pickle: {db}")

pickled_db = pickle.dumps(db)
restored_db = pickle.loads(pickled_db)
print(f"After unpickle: {restored_db}")
print(f"Query: {restored_db.query('SELECT 1')}")

# ── SHELVE — PERSISTENT DICT ───────

print("\\n=== SHELVE ===")

with shelve.open("myshelf") as db:
    # Store complex objects by string key
    db["user_alice"] = {"name": "Alice", "scores": [92, 88, 95]}
    db["user_bob"]   = {"name": "Bob",   "scores": [78, 82, 80]}
    db["game_save"]  = save   # the GameSave from above!
    db["last_login"] = datetime.now()

    print(f"Keys: {list(db.keys())}")
    print(f"Alice: {db['user_alice']}")

# Access later (data persists!)
with shelve.open("myshelf") as db:
    alice = db["user_alice"]
    print(f"Alice's scores: {alice['scores']}")

    # Update
    db["user_alice"]["scores"].append(99)   # ⚠️ may not work with default!
    # Safe update:
    alice_data = db["user_alice"]
    alice_data["scores"].append(99)
    db["user_alice"] = alice_data           # reassign to trigger save

    # Delete
    del db["user_bob"]

    print(f"Remaining keys: {list(db.keys())}")

# ── WRITEBACK FLAG ────────────────

# writeback=True makes nested mutation work directly
with shelve.open("myshelf2", writeback=True) as db:
    db["data"] = {"nested": {"value": 1}}
    db["data"]["nested"]["value"] = 42   # works with writeback!
    print(f"Nested: {db['data']}")

# ── MULTIPLE OBJECTS IN ONE FILE ──

def save_all(filepath: str, **objects):
    """Save multiple named objects to one file."""
    with open(filepath, "wb") as f:
        pickle.dump(objects, f, protocol=pickle.HIGHEST_PROTOCOL)

def load_all(filepath: str) -> dict:
    """Load all objects from file."""
    with open(filepath, "rb") as f:
        return pickle.load(f)

# Save multiple objects
save_all("checkpoint.pkl",
    model_weights=[0.1, 0.5, 0.3, 0.8],
    config={"lr": 0.001, "epochs": 100},
    history={"loss": [1.0, 0.5, 0.2], "accuracy": [0.6, 0.8, 0.95]},
    step=50
)

# Load them back
checkpoint = load_all("checkpoint.pkl")
print(f"Step: {checkpoint['step']}")
print(f"Accuracy: {checkpoint['history']['accuracy']}")

# ── PICKLE PROTOCOL SIZES ─────────

import pickle

data = list(range(10000))
for proto in range(6):
    size = len(pickle.dumps(data, protocol=proto))
    print(f"Protocol {proto}: {size:,} bytes")

# Protocol 5 is fastest for large binary data
# Protocol 0 is ASCII-safe but large

# Cleanup
for f in ["data.pkl", "gamesave.pkl", "myshelf.db",
          "myshelf2.db", "checkpoint.pkl",
          "myshelf", "myshelf.bak", "myshelf.dir",
          "myshelf.dat", "myshelf2", "myshelf2.bak",
          "myshelf2.dir", "myshelf2.dat"]:
    Path(f).unlink(missing_ok=True)

📝 KEY POINTS:
✅ Use pickle for complex Python objects that JSON can't handle
✅ Always open pickle files in binary mode: "wb" write, "rb" read
✅ Use protocol=pickle.HIGHEST_PROTOCOL for best performance
✅ __getstate__/__setstate__ let you customize pickling for complex objects
✅ shelve is a persistent dict — great for simple key-value storage
✅ Use writeback=True in shelve to safely mutate nested objects
✅ Check cloudpickle/dill for pickling lambdas and closures
❌ NEVER unpickle data from untrusted sources — it's a code execution vulnerability
❌ Don't rely on pickle for cross-version or cross-language compatibility
❌ Default shelve writeback=False means nested mutations are NOT saved without reassignment
""",
  quiz: [
    Quiz(question: 'What security risk does pickle.loads() pose with untrusted data?', options: [
      QuizOption(text: 'It may produce incorrect results for complex types', correct: false),
      QuizOption(text: 'Unpickling untrusted data can execute arbitrary code on the machine', correct: true),
      QuizOption(text: 'It can corrupt the file system', correct: false),
      QuizOption(text: 'It uses too much memory for large files', correct: false),
    ]),
    Quiz(question: 'What file mode should you use when writing a pickle file?', options: [
      QuizOption(text: '"w" — standard write mode', correct: false),
      QuizOption(text: '"wb" — write binary mode', correct: true),
      QuizOption(text: '"a" — append mode', correct: false),
      QuizOption(text: '"x" — exclusive create mode', correct: false),
    ]),
    Quiz(question: 'What does shelve\'s writeback=True option do?', options: [
      QuizOption(text: 'Writes data back to a backup file automatically', correct: false),
      QuizOption(text: 'Allows direct mutation of nested objects in the shelf without manual reassignment', correct: true),
      QuizOption(text: 'Reverts all changes when the shelf is closed', correct: false),
      QuizOption(text: 'Uses more efficient binary encoding', correct: false),
    ]),
  ],
);
