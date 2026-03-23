import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson52 = Lesson(
  language: 'Python',
  title: 'Python Internals & CPython',
  content: """
🎯 METAPHOR:
Understanding Python internals is like knowing how your
car's engine works. Most drivers never open the hood —
they just drive. But mechanics (senior engineers) know
exactly what pistons, valves, and camshafts do, so when
the car makes a strange noise, they know exactly what's
wrong and how to fix it. When Python behaves strangely
with identity vs equality, integer caching, or GIL effects,
you'll be the mechanic, not the stranded driver.

📖 EXPLANATION:
CPython internals: how Python actually stores objects,
how the GIL works, bytecode, the import system, and
Python's object model at a low level.

─────────────────────────────────────
🔑 EVERY OBJECT IN PYTHON
─────────────────────────────────────
Everything is a PyObject in C (CPython):
  ob_refcnt  → reference count
  ob_type    → pointer to type object
  ob_val     → the actual data

This is why: type(42) == <class 'int'>
And why: everything has __class__, __dict__, etc.

─────────────────────────────────────
📦 OBJECT IDENTITY & INTERNING
─────────────────────────────────────
id(obj)  → memory address of object

Integer cache (-5 to 256):
  a = 100; b = 100; a is b  → True  (same object!)
  a = 1000; b = 1000; a is b → False (different!)

String interning:
  Short strings, identifiers, compile-time constants
  → automatically interned (same object)
  Dynamically built strings → not interned

sys.intern("my string")  → explicitly intern a string

─────────────────────────────────────
📜 BYTECODE
─────────────────────────────────────
Python compiles .py → bytecode (.pyc in __pycache__)
bytecode is run by the CPython virtual machine (VM)

import dis
dis.dis(function)  → disassemble to bytecode

─────────────────────────────────────
🔒 THE GIL IN DEPTH
─────────────────────────────────────
Global Interpreter Lock: a mutex in CPython.
Only ONE thread runs Python bytecode at a time.
Released during: I/O, time.sleep, C extensions
Why it exists: simplifies memory management (ref counting)
               makes C extensions easier to write

Alternatives: PyPy (STM), Jython, Python 3.12+ sub-interpreters
Python 3.13: optional GIL (experimental)

─────────────────────────────────────
🏗️  THE IMPORT SYSTEM
─────────────────────────────────────
import searches:
  1. sys.modules (cache — already imported?)
  2. sys.meta_path (importers)
  3. sys.path (file system)

sys.path includes: script dir, PYTHONPATH, std lib, site-packages
Can add to sys.path to import from custom locations

─────────────────────────────────────
⚡ PERFORMANCE TIPS
─────────────────────────────────────
• Use local variables over global (faster lookup)
• List comprehension > map() > for loop for creation
• dict/set for O(1) membership (not list)
• Cache attr lookups: obj_method = obj.method
• Use __slots__ for memory-heavy classes
• PyPy for pure-Python CPU work
• Cython/ctypes/cffi for C extensions

💻 CODE:
import sys
import dis
import gc
import ctypes
import weakref

# ── OBJECT IDENTITY ───────────────

# Integer interning (-5 to 256)
a = 100; b = 100
print(f"a is b (100): {a is b}")    # True  (cached)
print(f"id(a)={id(a)}, id(b)={id(b)}")

x = 1000; y = 1000
print(f"x is y (1000): {x is y}")  # False (not cached)
print(f"id(x)={id(x)}, id(y)={id(y)}")

# String interning
s1 = "hello"
s2 = "hello"
print(f"s1 is s2 (literal): {s1 is s2}")  # True (interned)

# Dynamic strings — may or may not be interned
s3 = "hel" + "lo"   # compile-time const → interned
s4 = "".join(["h","e","l","l","o"])  # runtime → NOT interned (usually)
print(f"s1 is s3: {s1 is s3}")  # True (compile-time optimization)
print(f"s1 is s4: {s1 is s4}")  # False

# Force interning
s5 = sys.intern("my_key")
s6 = sys.intern("my_key")
print(f"s5 is s6 (interned): {s5 is s6}")  # True

# ── BYTECODE DISASSEMBLY ──────────

def simple_func(x, y):
    """Add two numbers and return if positive."""
    result = x + y
    if result > 0:
        return result
    return 0

print("\\n=== Bytecode for simple_func ===")
dis.dis(simple_func)
print()

# Compile and inspect code object
code = compile("x = 1 + 2", "<string>", "exec")
print(f"Co-constants: {code.co_consts}")
print(f"Co-names:     {code.co_names}")
print(f"Co-varnames:  {code.co_varnames}")
dis.dis(code)

# ── REFERENCE COUNTING ────────────

def ref_count(obj):
    """Get true reference count (subtract temporary refs)."""
    return sys.getrefcount(obj) - 1   # -1 for getrefcount's own ref

x = [1, 2, 3]
print(f"Base ref count: {ref_count(x)}")   # 1

y = x
print(f"After y=x: {ref_count(x)}")       # 2

lst = [x, x, x]
print(f"After lst with 3 refs: {ref_count(x)}")  # 5

del y
del lst
print(f"After cleanup: {ref_count(x)}")   # 1

# ── OBJECT MODEL ──────────────────

# Everything is an object — even types!
print(type(42))          # <class 'int'>
print(type(int))         # <class 'type'>
print(type(type))        # <class 'type'> (type is its own type!)

# All objects have __class__ and __dict__
class MyClass:
    x = 10
    def method(self): pass

obj = MyClass()
print(obj.__class__)           # <class 'MyClass'>
print(obj.__dict__)            # {} (no instance attrs yet)
print(MyClass.__dict__.keys()) # class attrs + methods

# MRO is stored in __mro__
print(MyClass.__mro__)   # (MyClass, object)

# ── IMPORT SYSTEM ─────────────────

import sys

# What's already imported
print("math" in sys.modules)   # False if not imported yet
import math
print("math" in sys.modules)   # True

# Second import is instant — returns cached module
import math   # from sys.modules, no file I/O!

# Where Python looks for modules
print("\\n=== sys.path ===")
for p in sys.path:
    print(f"  {p}")

# Add custom path
sys.path.insert(0, "/my/custom/modules")

# ── PERFORMANCE MEASUREMENT ────────

import timeit

# Global vs local variable lookup
setup_global = """
x = 42
def global_lookup():
    return x
"""

setup_local = """
def local_lookup():
    x = 42
    return x
"""

global_time = timeit.timeit("global_lookup()", setup=setup_global, number=1_000_000)
local_time  = timeit.timeit("local_lookup()",  setup=setup_local,  number=1_000_000)
print(f"Global lookup: {global_time:.3f}s")
print(f"Local lookup:  {local_time:.3f}s")
print(f"Local is {global_time/local_time:.2f}x faster")

# Cache method lookup
class MyObj:
    def compute(self): return 42

obj = MyObj()
# Slow — attribute lookup every iteration
t1 = timeit.timeit("obj.compute()", globals={"obj": obj}, number=1_000_000)

# Fast — cache the method reference
method = obj.compute
t2 = timeit.timeit("method()", globals={"method": method}, number=1_000_000)
print(f"\\nMethod via attr: {t1:.3f}s")
print(f"Cached method:   {t2:.3f}s")

# ── MEMORY LAYOUT ─────────────────

# Compact int representation
import array
py_list = list(range(1000))
np_like = array.array("i", range(1000))

print(f"\\nPython list of 1000 ints: {sys.getsizeof(py_list)} bytes header")
print(f"array.array of 1000 ints: {sys.getsizeof(np_like)} bytes")
# Python list stores pointers to int objects (28 bytes each)
# array.array stores actual ints (4 bytes each) in C

# Object size comparison
print(f"\\nEmpty object():    {sys.getsizeof(object())} bytes")
print(f"Empty list []:     {sys.getsizeof([])} bytes")
print(f"Empty dict {{}}:     {sys.getsizeof({})} bytes")
print(f"Empty tuple ():    {sys.getsizeof(())} bytes")
print(f"Integer 0:         {sys.getsizeof(0)} bytes")
print(f"Integer 2**30:     {sys.getsizeof(2**30)} bytes")
print(f"Integer 2**60:     {sys.getsizeof(2**60)} bytes")  # grows!
print(f"Float 1.0:         {sys.getsizeof(1.0)} bytes")
print(f"String 'a':        {sys.getsizeof('a')} bytes")
print(f"String 'hello':    {sys.getsizeof('hello')} bytes")

📝 KEY POINTS:
✅ id() returns the memory address — use for identity debugging
✅ Integers -5..256 and common strings are interned — same object across uses
✅ dis.dis() reveals Python bytecode — useful for performance analysis
✅ Local variable lookup is faster than global (fewer scope checks)
✅ Cache frequently accessed attributes and methods for performance
✅ sys.getrefcount(obj) returns the reference count (always ≥ 1)
✅ Everything in Python is an object — even types and functions
❌ Don't rely on integer interning in logic — use == not is for values
❌ Don't modify sys.path permanently in library code
❌ Don't over-optimize without profiling first — measure before tuning
""",
  quiz: [
    Quiz(question: 'Why does "a = 100; b = 100; a is b" return True but "a = 1000; b = 1000; a is b" returns False?', options: [
      QuizOption(text: 'Large integers are stored differently in memory', correct: false),
      QuizOption(text: 'CPython caches (interns) integers from -5 to 256 as single objects', correct: true),
      QuizOption(text: 'The is operator behaves differently for small numbers', correct: false),
      QuizOption(text: 'Python rounds large numbers to different values', correct: false),
    ]),
    Quiz(question: 'What does dis.dis(function) show?', options: [
      QuizOption(text: 'The function\'s source code with line numbers', correct: false),
      QuizOption(text: 'The compiled bytecode instructions Python\'s VM will execute', correct: true),
      QuizOption(text: 'The function\'s call stack at runtime', correct: false),
      QuizOption(text: 'A disassembled C representation of the function', correct: false),
    ]),
    Quiz(question: 'What is the main reason the GIL exists in CPython?', options: [
      QuizOption(text: 'To prevent race conditions in user code', correct: false),
      QuizOption(text: 'To simplify reference counting memory management and make C extensions easier to write', correct: true),
      QuizOption(text: 'To limit Python programs to one CPU core', correct: false),
      QuizOption(text: 'To ensure Python programs run in the same order on all platforms', correct: false),
    ]),
  ],
);
