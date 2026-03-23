import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson44 = Lesson(
  language: 'Python',
  title: 'Memory Management & Garbage Collection',
  content: """
🎯 METAPHOR:
Python's memory management is like a city's recycling system.
Every object you create is a piece of garbage with a
"reference counter" label. As long as ANYONE holds a reference
to it (the counter > 0), it stays in use. When nobody
references it (counter hits 0), it's instantly recycled.
But what about circular references — two pieces of garbage
that reference each other but nobody else touches?
That's where the garbage collector comes in, like a
special recycling crew that hunts for isolated cycles of
objects that reference each other but are unreachable
from the outside world.

📖 EXPLANATION:
Python uses reference counting + cyclic garbage collection.
Most objects are freed immediately when reference count
hits zero. The gc module handles reference cycles.

─────────────────────────────────────
📊 REFERENCE COUNTING
─────────────────────────────────────
Every Python object has a reference count.
Incremented when: assigned to variable, passed as arg,
                  added to container, returned from function
Decremented when: name goes out of scope, del statement,
                  reassigned, container item removed

import sys
sys.getrefcount(obj)   → current ref count (always >= 1)

─────────────────────────────────────
🔄 CYCLIC GARBAGE COLLECTOR
─────────────────────────────────────
Problem: A → B → A (cycle) — ref counts never reach 0!
Solution: Python's gc module periodically finds and
          collects these unreachable cycles.

import gc
gc.collect()          → force a collection
gc.disable()          → disable automatic collection
gc.get_count()        → (gen0, gen1, gen2) counts
gc.get_threshold()    → collection thresholds
gc.is_tracked(obj)    → is obj tracked by gc?

─────────────────────────────────────
👻 WEAK REFERENCES
─────────────────────────────────────
A weak reference doesn't increment the ref count.
The object can be garbage collected even if a weak
reference exists. Use for caches and observers.

import weakref
ref = weakref.ref(obj)
ref()     → obj if alive, None if collected

─────────────────────────────────────
💾 MEMORY PROFILING TOOLS
─────────────────────────────────────
sys.getsizeof(obj)    → shallow size in bytes
tracemalloc           → trace memory allocations
memory_profiler       → line-by-line memory usage (pip)
objgraph              → visualize object references (pip)

─────────────────────────────────────
🚀 OPTIMIZATION TECHNIQUES
─────────────────────────────────────
__slots__             → no __dict__ per instance
generators            → process one item at a time
array module          → typed arrays (less overhead)
numpy arrays          → for numeric computation
del + gc.collect()    → force cleanup of large objects
StringIO              → in-memory file operations
memoryview            → zero-copy buffer access

💻 CODE:
import sys
import gc
import weakref
import tracemalloc
from array import array

# ── REFERENCE COUNTING ─────────────

x = [1, 2, 3]
print(sys.getrefcount(x))   # 2 (x + getrefcount arg)

y = x            # ref count → 3
print(sys.getrefcount(x))

del y            # ref count → 2
print(sys.getrefcount(x))

# Small integers and strings are cached (interned)
a = 256
b = 256
print(a is b)   # True  — integers -5 to 256 are cached
a = 1000
b = 1000
print(a is b)   # False — different objects (usually)

# String interning
s1 = "hello"
s2 = "hello"
print(s1 is s2)   # True  — short strings are interned
s3 = " ".join(["hel", "lo"])
print(s3 is s2)   # False — dynamically built strings

# ── GARBAGE COLLECTOR ─────────────

# Demonstrate reference cycle
class Node:
    def __init__(self, value):
        self.value = value
        self.next = None
    def __del__(self):
        print(f"Node({self.value}) collected")

# Create a cycle
gc.disable()   # pause GC to see the cycle
a = Node(1)
b = Node(2)
a.next = b     # a → b
b.next = a     # b → a  (cycle!)

del a
del b
# Objects NOT collected yet — cycle prevents ref-count cleanup
print("Still alive despite del!")
print(f"Tracked objects: {len(gc.get_objects())}")

gc.collect()   # force collection — now cycles are found!
print("After gc.collect()")
gc.enable()

# Check if tracked
lst = [1, 2, 3]
d = {"a": 1}
print(gc.is_tracked(lst))   # True (containers tracked)
print(gc.is_tracked(42))    # False (ints not tracked)

# GC generations
print(f"Thresholds: {gc.get_threshold()}")   # (700, 10, 10)
print(f"Counts:     {gc.get_count()}")       # (gen0, gen1, gen2)

# ── WEAK REFERENCES ───────────────

class ExpensiveObject:
    def __init__(self, data):
        self.data = data
    def process(self):
        return f"Processing {self.data}"
    def __del__(self):
        print(f"ExpensiveObject({self.data!r}) freed!")

# Strong reference
obj = ExpensiveObject("important data")
strong_ref = obj   # another strong reference — won't be GC'd

# Weak reference — doesn't prevent GC
weak_ref = weakref.ref(obj)
print(weak_ref())          # <ExpensiveObject ...> (alive)
print(weak_ref().process())

del obj
del strong_ref   # now ref count → 0 → freed!
# Python frees it, then weak_ref() returns None
import ctypes   # skip actual check for safety
print("Object has been freed")
print(weak_ref())   # None (object gone)

# WeakValueDictionary — cache that lets objects be GC'd
cache = weakref.WeakValueDictionary()
resource = ExpensiveObject("cached data")
cache["key"] = resource

print(cache["key"].process())   # works while resource exists
del resource
# resource freed, cache["key"] no longer accessible

# WeakKeyDictionary — keys can be GC'd
weak_key_dict = weakref.WeakKeyDictionary()

class Key:
    pass

k = Key()
weak_key_dict[k] = "some value"
print(weak_key_dict[k])   # "some value"
del k   # key freed, entry removed from dict

# ── MEMORY PROFILING ──────────────

# tracemalloc — track allocations
tracemalloc.start()

# Do some work
big_list = [i**2 for i in range(100_000)]
big_dict = {str(i): i for i in range(10_000)}

snapshot = tracemalloc.take_snapshot()
stats = snapshot.statistics("lineno")
for stat in stats[:3]:
    print(stat)

tracemalloc.stop()

# sys.getsizeof — shallow size
print(f"Empty list:  {sys.getsizeof([])} bytes")
print(f"100-item:    {sys.getsizeof(list(range(100)))} bytes")
print(f"Empty dict:  {sys.getsizeof({})} bytes")
print(f"Integer:     {sys.getsizeof(42)} bytes")
print(f"String 'hi': {sys.getsizeof('hi')} bytes")

# NOTE: getsizeof is SHALLOW — doesn't count object contents
a = [[0]*1000 for _ in range(1000)]
print(f"Shallow size of 2D list: {sys.getsizeof(a)} bytes")

# For deep size, use a recursive function:
def deep_sizeof(obj, seen=None):
    if seen is None: seen = set()
    obj_id = id(obj)
    if obj_id in seen: return 0
    seen.add(obj_id)
    size = sys.getsizeof(obj)
    if isinstance(obj, dict):
        size += sum(deep_sizeof(k, seen) + deep_sizeof(v, seen)
                    for k, v in obj.items())
    elif hasattr(obj, "__iter__") and not isinstance(obj, (str, bytes, bytearray)):
        size += sum(deep_sizeof(i, seen) for i in obj)
    return size

print(f"Deep size of 2D list: {deep_sizeof(a):,} bytes")

# ── MEMORY-EFFICIENT PATTERNS ──────

# 1. Use generators instead of lists
import sys
list_mem = sys.getsizeof([x**2 for x in range(10_000)])
gen_mem  = sys.getsizeof(x**2 for x in range(10_000))
print(f"List: {list_mem:,} bytes vs Generator: {gen_mem} bytes")

# 2. array module — typed, compact arrays
import array
py_list = list(range(1_000_000))
int_array = array.array('i', range(1_000_000))   # 'i' = signed int
print(f"List:  {sys.getsizeof(py_list):,} bytes")
print(f"Array: {sys.getsizeof(int_array):,} bytes")

# 3. memoryview — zero-copy access to buffer
data = bytearray(b"hello world")
view = memoryview(data)
print(view[0])     # 104 (ASCII 'h') — no copy made!
view[0] = 72       # modify in place — 'H'
print(data)        # bytearray(b'Hello world')

# 4. del large objects explicitly
def process_large_data():
    data = [0] * 10_000_000   # 80MB
    result = sum(data)
    del data                   # free immediately, don't wait for function exit
    gc.collect()               # force collection
    return result

📝 KEY POINTS:
✅ Python frees objects immediately when ref count hits 0 (usually)
✅ gc module handles reference cycles — runs automatically in generations
✅ Weak references allow caching without preventing garbage collection
✅ tracemalloc is the best built-in tool for finding memory leaks
✅ sys.getsizeof is SHALLOW — use a recursive function for deep size
✅ Generators, __slots__, array, numpy drastically reduce memory usage
❌ Don't assume del immediately frees memory — ref cycles delay it
❌ Don't disable gc in long-running apps without understanding the consequences
❌ sys.getsizeof doesn't count the objects referenced inside a container
""",
  quiz: [
    Quiz(question: 'What happens to a Python object when its reference count reaches zero?', options: [
      QuizOption(text: 'It is moved to the garbage collector queue for later collection', correct: false),
      QuizOption(text: 'It is immediately freed and its memory reclaimed', correct: true),
      QuizOption(text: 'It is kept alive until the next gc.collect() call', correct: false),
      QuizOption(text: 'It becomes a weak reference', correct: false),
    ]),
    Quiz(question: 'Why does Python need a cyclic garbage collector beyond reference counting?', options: [
      QuizOption(text: 'Reference counting is too slow for large programs', correct: false),
      QuizOption(text: 'Reference cycles (A→B→A) prevent ref counts from reaching zero even when unreachable', correct: true),
      QuizOption(text: 'Reference counting doesn\'t work on 64-bit systems', correct: false),
      QuizOption(text: 'It handles memory in C extensions', correct: false),
    ]),
    Quiz(question: 'What is a weak reference?', options: [
      QuizOption(text: 'A reference that expires after a timeout', correct: false),
      QuizOption(text: 'A reference that does not increment the ref count, allowing the object to be GC\'d', correct: true),
      QuizOption(text: 'A reference stored in a weakref.dict', correct: false),
      QuizOption(text: 'A partial reference to a specific attribute of an object', correct: false),
    ]),
  ],
);
