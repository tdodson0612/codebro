import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson66 = Lesson(
  language: 'Python',
  title: 'Object Copying: Shallow vs Deep',
  content: '''
🎯 METAPHOR:
Copying in Python is like photocopying a folder of documents.
A SHALLOW copy makes a new folder but puts the same
ORIGINAL documents inside. Change a document — both folders
reflect the change, because there's only one physical document.
A DEEP copy photocopies EVERY document too — full independence.
Now you can scribble on your copy's documents without
affecting the original folder at all. Python defaults
to aliasing (just pointing at the same folder), so
you must explicitly request the copy you need.

📖 EXPLANATION:
Python variables are references (pointers) to objects.
  Assignment: creates another reference to the SAME object.
  Shallow copy: new container, same contained objects.
  Deep copy: new container AND new copies of all contained objects.

─────────────────────────────────────
📐 THREE LEVELS
─────────────────────────────────────
1. ALIAS (=)
   b = a   — b and a point to the SAME object.
   Any change to the object is visible from both.

2. SHALLOW COPY
   b = a.copy()
   b = list(a)
   b = a[:]
   b = copy.copy(a)
   New outer container, but nested objects are SHARED.

3. DEEP COPY
   b = copy.deepcopy(a)
   New container AND recursively new copies of everything.
   Fully independent.

─────────────────────────────────────
🔑 WHEN IT MATTERS
─────────────────────────────────────
Immutables (int, str, tuple of immutables):
  Copying rarely matters — can't be mutated anyway.

Mutables (list, dict, set, custom objects):
  Copying is critical — shared references = surprise bugs.

─────────────────────────────────────
⚡ COPY METHODS BY TYPE
─────────────────────────────────────
list:   a[:], list(a), a.copy(), copy.copy(a)
dict:   d.copy(), dict(d), {**d}, copy.copy(d)
set:    s.copy(), set(s), copy.copy(s)
custom: copy.copy(a)   (calls __copy__)
deep:   copy.deepcopy(a) for anything nested

💻 CODE:
import copy

# ── ALIASING (NOT A COPY) ──────────

a = [1, 2, [3, 4]]
b = a           # b is just another name for the same list!

b.append(99)
print(a)   # [1, 2, [3, 4], 99] — a is affected!
print(b is a)   # True — same object

# Reassigning b doesn't affect a
b = [100, 200]
print(a)   # [1, 2, [3, 4], 99] — unchanged
print(b is a)   # False — different objects now

# ── SHALLOW COPY ──────────────────

original = [1, 2, [3, 4], {"x": 10}]

# Four equivalent ways to shallow copy a list:
shallow1 = original[:]
shallow2 = list(original)
shallow3 = original.copy()
shallow4 = copy.copy(original)

# New outer list — confirmed
print(shallow1 is original)   # False — different objects

# But inner objects are SHARED
print(shallow1[2] is original[2])   # True — same inner list!
print(shallow1[3] is original[3])   # True — same inner dict!

# Modifying the outer list: doesn't affect original
shallow1.append(99)
print(len(original), len(shallow1))   # 4, 5

# Modifying an inner (nested) object: DOES affect original!
shallow1[2].append(999)
print(original[2])   # [3, 4, 999] — !! affected !!
print(shallow1[2])   # [3, 4, 999]  — same object

shallow1[3]["y"] = 20
print(original[3])   # {'x': 10, 'y': 20} — !! affected !!

# ── DEEP COPY ─────────────────────

original = [1, 2, [3, 4], {"x": 10}]
deep = copy.deepcopy(original)

# Different outer list
print(deep is original)     # False

# Different inner objects too!
print(deep[2] is original[2])   # False — independent copy!
print(deep[3] is original[3])   # False

# Modifying nested object does NOT affect original
deep[2].append(999)
print(original[2])   # [3, 4]  — unchanged!
print(deep[2])       # [3, 4, 999]

deep[3]["y"] = 20
print(original[3])   # {'x': 10} — unchanged!

# ── SHALLOW COPY OF DICTS ─────────

d = {"a": 1, "b": [10, 20], "c": {"nested": True}}

# Shallow copies of dict
d1 = d.copy()
d2 = dict(d)
d3 = {**d}
d4 = copy.copy(d)

# All are shallow — nested objects shared
d1["b"].append(30)
print(d["b"])    # [10, 20, 30] — affected!

# Deep copy for full independence
d5 = copy.deepcopy(d)
d5["b"].append(99)
print(d["b"])    # [10, 20, 30] — unaffected

# ── CUSTOM __COPY__ AND __DEEPCOPY__

class Config:
    def __init__(self, settings, cache=None):
        self.settings = settings  # dict
        self.cache = cache or {}  # should NOT be shared

    def __copy__(self):
        """Shallow copy: new Config but shared settings."""
        new = Config.__new__(Config)
        new.settings = self.settings    # shared reference
        new.cache = {}                  # fresh cache for each copy
        return new

    def __deepcopy__(self, memo):
        """Deep copy: independent settings and cache."""
        new = Config.__new__(Config)
        memo[id(self)] = new
        new.settings = copy.deepcopy(self.settings, memo)
        new.cache = {}   # always fresh
        return new

    def __repr__(self):
        return f"Config(settings={self.settings}, cache={self.cache})"

cfg = Config({"debug": True, "port": 8080})
cfg.cache["key"] = "value"

shallow = copy.copy(cfg)
deep = copy.deepcopy(cfg)

print(f"Original: {cfg}")
print(f"Shallow:  {shallow}")  # cache is fresh []
print(f"Deep:     {deep}")     # cache is also fresh []

# Shared settings in shallow
print(shallow.settings is cfg.settings)   # True — shared
print(deep.settings is cfg.settings)      # False — independent

# ── COPY PERFORMANCE ──────────────

import timeit

data = list(range(1000))

t_shallow = timeit.timeit(lambda: data[:], number=100_000)
t_deep    = timeit.timeit(lambda: copy.deepcopy(data), number=10_000)

print(f"Shallow copy (list[:]): {t_shallow:.3f}s")
print(f"Deep copy (deepcopy):   {t_deep:.3f}s (10x fewer runs)")

# Deep copy is MUCH slower — avoid for large objects

# ── PRACTICAL RULES ───────────────

# Rule: use the minimum copy depth you need.
# Flat data (no nested mutables) → shallow copy is fine
# Nested mutable data → deep copy for full safety
# Performance-critical code → profile and minimize copies

# Example: function that shouldn't modify its argument
def process_safe(data):
    # Deep copy if you MUST modify and can't know nesting depth
    data = copy.deepcopy(data)
    data["processed"] = True
    return data

# Or better: don't modify — build new object
def process_pure(data):
    return {**data, "processed": True}   # no copy needed!

original = {"name": "Alice", "score": 95}
result = process_pure(original)
print(original)   # unchanged
print(result)     # has "processed": True

📝 KEY POINTS:
✅ Assignment (=) creates an alias — same object, two names
✅ Shallow copy: new container, shared nested objects
✅ Deep copy: new container AND new copies of all nested objects
✅ For flat (non-nested) data, shallow copy is sufficient
✅ For nested mutable data, use copy.deepcopy() for full independence
✅ dict.copy(), list[:], {**d} are all shallow copies
✅ Prefer building new objects (pure functions) over copying when possible
❌ Assuming list2 = list1 creates a copy — it's an alias!
❌ Using shallow copy when your data has nested mutables — sneaky bugs
❌ Deep copying unnecessarily large objects — it's slow
''',
  quiz: [
    Quiz(question: 'What does b = a do when a is a list?', options: [
      QuizOption(text: 'Creates a shallow copy of a', correct: false),
      QuizOption(text: 'Creates an alias — b and a refer to the same list object', correct: true),
      QuizOption(text: 'Creates a deep copy of a', correct: false),
      QuizOption(text: 'Creates b as an empty list', correct: false),
    ]),
    Quiz(question: 'With a shallow copy of [[1,2],[3,4]], what happens when you modify the inner list?', options: [
      QuizOption(text: 'Only the copy is affected — they are independent', correct: false),
      QuizOption(text: 'Both the original and copy reflect the change — inner lists are shared', correct: true),
      QuizOption(text: 'A ValueError is raised — shallow copies are immutable', correct: false),
      QuizOption(text: 'The original is unaffected but future copies are also changed', correct: false),
    ]),
    Quiz(question: 'When should you use copy.deepcopy()?', options: [
      QuizOption(text: 'For all Python objects — it is always the safe choice', correct: false),
      QuizOption(text: 'When you need full independence from an object containing nested mutable structures', correct: true),
      QuizOption(text: 'Only for custom classes with __deepcopy__ defined', correct: false),
      QuizOption(text: 'Only when the object contains more than 100 elements', correct: false),
    ]),
  ],
);
