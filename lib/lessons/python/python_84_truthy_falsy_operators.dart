import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson84 = Lesson(
  language: 'Python',
  title: 'Truthiness, Operators & Comparisons Deep Dive',
  content: """
🎯 METAPHOR:
Python's truthiness system is like a universal lie detector
that reads ANY object, not just booleans.
Feed it a number, a list, a string, a custom object —
it gives you True or False. Empty means False. Non-empty
means True. Zero means False. Non-zero means True.
None means False. This "emptiness = falsy" rule is
consistent, predictable, and deeply Pythonic. Once you
internalize it, "if my_list:" is not just shorter than
"if len(my_list) > 0:" — it's the right way to think.

📖 EXPLANATION:
Python evaluates truthiness for any object in boolean
context. Understanding this — along with short-circuit
evaluation, chained comparisons, and augmented assignment
— eliminates a whole class of verbose, non-Pythonic code.

─────────────────────────────────────
🔑 FALSY VALUES
─────────────────────────────────────
None
False
0  (int zero)
0.0  (float zero)
0j  (complex zero)
""  (empty string)
[]  (empty list)
()  (empty tuple)
{}  (empty dict)
set()  (empty set)
b""  (empty bytes)
range(0)  (empty range)
Any custom object where __bool__ returns False
Any custom object where __len__ returns 0

Everything else is TRUTHY.

─────────────────────────────────────
⚡ SHORT-CIRCUIT EVALUATION
─────────────────────────────────────
and: stops at first FALSY value (returns it)
     if all truthy, returns the LAST value
or:  stops at first TRUTHY value (returns it)
     if all falsy, returns the LAST value

These return the VALUE, not just True/False!
  "hello" or "default"   → "hello"
  None or "default"      → "default"
  [] and do_work()       → []  (do_work never called)

─────────────────────────────────────
🔗 CHAINED COMPARISONS
─────────────────────────────────────
1 < x < 10            → same as (1 < x) and (x < 10)
0 <= score <= 100
a == b == c           → a==b and b==c
a < b < c < d         → a<b and b<c and c<d

─────────────────────────────────────
➕ AUGMENTED ASSIGNMENT
─────────────────────────────────────
x += 1    → x = x + 1
x -= 1    → x = x - 1
x *= 2    → x = x * 2
x /= 2    → x = x / 2
x //= 2   → x = x // 2
x %= 3    → x = x % 3
x **= 2   → x = x ** 2
x &= mask → x = x & mask   (bitwise)
x |= flag → x = x | flag
x ^= val  → x = x ^ val
x <<= 1   → x = x << 1     (left shift)
x >>= 1   → x = x >> 1     (right shift)

💻 CODE:
# ── TRUTHINESS ────────────────────

# Test truthiness with bool()
print("=== Falsy values ===")
for val in [None, False, 0, 0.0, 0j, "", [], (), {}, set(), b"", range(0)]:
    print(f"  bool({val!r:15}) = {bool(val)}")

print("\\n=== Truthy values ===")
for val in [True, 1, -1, 0.001, 1j, "a", [0], (None,), {"k":0}, {0}, b"x", range(1)]:
    print(f"  bool({val!r:15}) = {bool(val)}")

# Custom __bool__ and __len__
class Empty:
    def __bool__(self):
        return False

class Sized:
    def __init__(self, count):
        self.count = count
    def __len__(self):
        return self.count

print(bool(Empty()))    # False (uses __bool__)
print(bool(Sized(0)))   # False (uses __len__ == 0)
print(bool(Sized(5)))   # True  (uses __len__ > 0)

# Pythonic idioms
my_list = [1, 2, 3]

# ❌ Non-Pythonic
if len(my_list) > 0:
    print("has items")

# ✅ Pythonic
if my_list:
    print("has items")

# ❌ Non-Pythonic
if my_list is not None and len(my_list) > 0:
    first = my_list[0]

# ✅ Pythonic
if my_list:
    first = my_list[0]

# None checks — use "is not None", not truthiness
value = 0   # truthy check would fail! 0 is falsy but valid
if value is not None:
    print(f"Value is set: {value}")   # prints correctly!

# ── SHORT-CIRCUIT EVALUATION ──────

# and returns first Falsy, or last Truthy
print("\\n=== and short-circuit ===")
print(1 and 2 and 3)         # 3  (all truthy → last)
print(1 and 0 and 3)         # 0  (first falsy)
print([] and do_anything())  # [] (stops immediately, no call)
print(None and 1/0)          # None (no ZeroDivisionError!)

# or returns first Truthy, or last Falsy
print("\\n=== or short-circuit ===")
print(0 or "" or [] or 42)   # 42 (first truthy)
print(0 or "" or [])          # [] (all falsy → last)
print("hello" or "default")  # "hello" (first truthy)
print("" or "default")       # "default" (first falsy → second)
print(None or 0 or False)    # False (all falsy → last)

# Practical idioms using short-circuit
def get_name():
    return None   # simulate missing data

# Default value pattern
name = get_name() or "Anonymous"
print(f"Name: {name}")   # Anonymous

# Guard pattern
data = {"user": {"name": "Alice"}}
username = data.get("user") and data["user"].get("name")
print(username)   # Alice (safe navigation)

# or for default in assignment
config = {}
timeout = config.get("timeout") or 30   # 30 if not set or 0
print(timeout)   # 30

# ⚠️ Warning: "or" treats 0 as falsy!
port = config.get("port") or 8080   # 8080 even if port=0 was intended!
# Better:
port = config.get("port") if config.get("port") is not None else 8080
# Or even better:
port = config.get("port", 8080)

# not
print("\\n=== not ===")
print(not True)    # False
print(not False)   # True
print(not [])      # True  (empty list is falsy)
print(not [1])     # False (non-empty is truthy)
print(not None)    # True

# ── CHAINED COMPARISONS ───────────

x = 5

# Range check
print(1 < x < 10)          # True  ← Python style!
print(1 < x and x < 10)    # True  ← equivalent but verbose

# Score validation
score = 85
print(0 <= score <= 100)   # True

# Boundary check
print(0 <= score < 60)     # False (not failing)
print(60 <= score < 70)    # False
print(70 <= score < 80)    # False
print(80 <= score < 90)    # True  → B grade

def letter_grade(score: int) -> str:
    if not (0 <= score <= 100):
        raise ValueError(f"Score {score} out of range")
    if score >= 90: return "A"
    if score >= 80: return "B"
    if score >= 70: return "C"
    if score >= 60: return "D"
    return "F"

print(letter_grade(85))   # B

# Equality chain
a = b = c = 5
print(a == b == c)    # True

# Can chain with mixed operators
print(1 < 2 == 2 < 3 != 4)   # True

# ── AUGMENTED ASSIGNMENT ──────────

x = 10
x += 5;  print(x)    # 15
x -= 3;  print(x)    # 12
x *= 2;  print(x)    # 24
x //= 5; print(x)    # 4
x **= 3; print(x)    # 64
x %= 10; print(x)    # 4
x /= 2;  print(x)    # 2.0

# On mutable objects — augmented modifies in place!
lst = [1, 2, 3]
original_id = id(lst)
lst += [4, 5]         # += on list calls list.__iadd__ → extends in place!
print(lst)            # [1, 2, 3, 4, 5]
print(id(lst) == original_id)   # True — SAME object!

# Contrast with regular +
lst2 = [1, 2, 3]
original_id2 = id(lst2)
lst2 = lst2 + [4, 5]  # creates NEW list
print(id(lst2) == original_id2)   # False — new object!

# Tuples are immutable — += creates a new tuple
t = (1, 2, 3)
original_id3 = id(t)
t += (4, 5)
print(id(t) == original_id3)   # False — new tuple!

# Bitwise augmented assignment
flags = 0b0000
READ    = 0b0001
WRITE   = 0b0010
EXECUTE = 0b0100

flags |= READ     # grant read
flags |= WRITE    # grant write
print(f"flags = {flags:04b}")   # 0011

flags &= ~WRITE   # revoke write (AND with NOT WRITE)
print(f"flags = {flags:04b}")   # 0001

# ── COMPARISON OPERATORS ──────────

# is vs ==
a = [1, 2, 3]
b = [1, 2, 3]
c = a

print(a == b)    # True  (same VALUE)
print(a is b)    # False (different OBJECTS)
print(a is c)    # True  (same OBJECT)

# None comparison — always use "is"
x = None
print(x is None)      # ✅ correct
print(x == None)      # works but PEP 8 says use "is"
print(not x)          # works but could be misleading (0, "" also falsy)

# in / not in
fruits = ["apple", "banana", "cherry"]
print("apple" in fruits)       # True
print("grape" not in fruits)   # True

# in with strings
print("py" in "python")     # True (substring check)
print("PY" in "python")     # False (case-sensitive)

# in with dict (checks keys)
d = {"a": 1, "b": 2}
print("a" in d)       # True  (key check)
print(1 in d)         # False (not a key!)
print(1 in d.values()) # True  (value check)

# Walrus operator := (assignment expression)
data = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
if n := len(data):
    print(f"Data has {n} items")   # n is now defined!

# Filter with walrus — compute once, use twice
import re
results = [m.group() for s in ["abc123", "def", "ghi456"]
           if (m := re.search(r"\\d+", s))]
print(results)   # ['123', '456']

📝 KEY POINTS:
✅ Falsy: None, False, 0, 0.0, 0j, "", [], (), {}, set(), b""
✅ "if my_list:" is Pythonic — more readable than "if len(my_list) > 0:"
✅ and/or return VALUES not just True/False — use for defaults and guards
✅ Chained comparisons: "0 <= x < 100" is clean and correct Python
✅ Augmented assignment on mutable types (+=) modifies in-place
✅ Augmented assignment on immutable types creates new objects
✅ Use "is None" / "is not None" — not "== None"
❌ "value or default" fails when value is 0, False, "" — use "if value is not None"
❌ Chaining is/is not for value comparison — use == for values
❌ Using == to compare with None (PEP 8 says use "is")
""",
  quiz: [
    Quiz(question: 'What does "name = user_input or \'Anonymous\'" do?', options: [
      QuizOption(text: 'Always assigns "Anonymous"', correct: false),
      QuizOption(text: 'Assigns user_input if truthy, otherwise "Anonymous"', correct: true),
      QuizOption(text: 'Raises an error if user_input is None', correct: false),
      QuizOption(text: 'Compares user_input to "Anonymous"', correct: false),
    ]),
    Quiz(question: 'What does 1 < x < 10 mean in Python?', options: [
      QuizOption(text: 'A syntax error — chained comparisons are not allowed', correct: false),
      QuizOption(text: '(1 < x) and (x < 10) — x is between 1 and 10 exclusive', correct: true),
      QuizOption(text: '(1 < x) < 10 — comparing a boolean to 10', correct: false),
      QuizOption(text: 'x is between 1 and 10 inclusive', correct: false),
    ]),
    Quiz(question: 'With lst = [1,2,3], what does lst += [4,5] do?', options: [
      QuizOption(text: 'Creates a new list [1,2,3,4,5] and assigns to lst', correct: false),
      QuizOption(text: 'Extends lst in-place — same list object now contains [1,2,3,4,5]', correct: true),
      QuizOption(text: 'Appends [4,5] as a nested list', correct: false),
      QuizOption(text: 'Raises a TypeError', correct: false),
    ]),
  ],
);
