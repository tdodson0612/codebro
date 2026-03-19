import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson57 = Lesson(
  language: 'Python',
  title: 'Performance Optimization',
  content: '''
🎯 METAPHOR:
Optimizing code without profiling is like fixing a car
without knowing what's broken. You might replace the
perfectly good engine when the flat tire was the problem.
"Measure twice, cut once" is the optimization mantra.
Profile first → find the bottleneck → fix THAT.
The same principle applies to algorithms: a better
algorithm beats hardware every time. O(log n) beats
O(n²) even on a supercomputer when n is large enough.

📖 EXPLANATION:
Python has several layers of performance optimization:
algorithmic (Big-O), data structures (the right tool),
Python-level tricks, and native code extensions.

─────────────────────────────────────
📊 ALGORITHMIC COMPLEXITY
─────────────────────────────────────
O(1)      → dict/set lookup, list[index], deque push/pop
O(log n)  → bisect.bisect, heapq operations
O(n)      → list scan, sum(), max(), min()
O(n log n)→ sorted(), list.sort()
O(n²)     → nested loops, list in list for membership

Key: dict/set for membership, not list!
  x in my_list  → O(n)
  x in my_set   → O(1)

─────────────────────────────────────
🏎️  PYTHON-LEVEL WINS
─────────────────────────────────────
• Local variables > global (fewer scope lookups)
• List comprehension > append loop
• join() > string += concatenation
• Generator > list when only iterating once
• Precompute outside loops
• Cache repeated attribute/function lookups
• Use built-ins: sum, max, min, sorted (C speed)
• array.array or numpy for numeric data

─────────────────────────────────────
⚡ CACHING
─────────────────────────────────────
@functools.lru_cache   → memoize function results
@functools.cache       → unbounded lru_cache (3.9+)
@cached_property       → compute once per instance

─────────────────────────────────────
🔧 BEYOND PYTHON
─────────────────────────────────────
PyPy      → JIT compiler, 5-10x faster for pure Python
Cython    → compile Python → C extension
Numba     → JIT compile numeric functions
ctypes    → call C libraries directly
cffi      → Foreign Function Interface
numpy     → C-speed array operations
multiprocessing → true parallelism (bypass GIL)

💻 CODE:
import timeit
import functools
import array
from collections import deque
import heapq
import bisect

# ── DATA STRUCTURE CHOICES ─────────

# O(n) vs O(1) membership testing
def benchmark_membership():
    n = 100_000
    items = range(n)
    target = n - 1   # worst case for list (last item)

    my_list = list(range(n))
    my_set  = set(range(n))
    my_dict = {i: True for i in range(n)}

    t_list = timeit.timeit(lambda: target in my_list, number=1000)
    t_set  = timeit.timeit(lambda: target in my_set,  number=1000)
    t_dict = timeit.timeit(lambda: target in my_dict, number=1000)

    print(f"list membership: {t_list:.4f}s")
    print(f"set  membership: {t_set:.6f}s  ({t_list/t_set:.0f}x faster!)")
    print(f"dict membership: {t_dict:.6f}s")

benchmark_membership()

# ── STRING CONCATENATION ───────────

def naive_concat(n):
    result = ""
    for i in range(n):
        result += str(i)   # creates a new string each time!
    return result

def join_concat(n):
    return "".join(str(i) for i in range(n))

n = 10_000
t1 = timeit.timeit(lambda: naive_concat(n), number=100)
t2 = timeit.timeit(lambda: join_concat(n),  number=100)
print(f"\\nString += concat: {t1:.3f}s")
print(f"''.join():         {t2:.3f}s  ({t1/t2:.1f}x faster)")

# ── LIST vs DEQUE FOR QUEUE ────────

def list_queue(n):
    q = list(range(n))
    while q:
        q.pop(0)   # O(n)! shifts all elements left

def deque_queue(n):
    q = deque(range(n))
    while q:
        q.popleft()   # O(1)!

n = 10_000
t1 = timeit.timeit(lambda: list_queue(n),  number=10)
t2 = timeit.timeit(lambda: deque_queue(n), number=10)
print(f"\\nlist.pop(0): {t1:.3f}s")
print(f"deque.popleft(): {t2:.3f}s  ({t1/t2:.1f}x faster)")

# ── LOOP OPTIMIZATIONS ─────────────

def slow_loop(n):
    result = []
    for i in range(n):
        result.append(i * i)   # attribute lookup every iteration
    return result

def fast_loop(n):
    result = []
    append = result.append    # cache the method
    for i in range(n):
        append(i * i)          # no attribute lookup!
    return result

def comprehension(n):
    return [i * i for i in range(n)]   # fastest

n = 100_000
t1 = timeit.timeit(lambda: slow_loop(n), number=100)
t2 = timeit.timeit(lambda: fast_loop(n), number=100)
t3 = timeit.timeit(lambda: comprehension(n), number=100)
print(f"\\nBasic loop:       {t1:.3f}s")
print(f"Cached method:    {t2:.3f}s  ({t1/t2:.2f}x faster)")
print(f"Comprehension:    {t3:.3f}s  ({t1/t3:.2f}x faster)")

# ── PRECOMPUTE OUTSIDE LOOPS ───────

import math
import re

# Slow — method lookup inside loop
def slow_calc(data):
    return [math.sqrt(x) for x in data]

# Fast — local reference outside loop
def fast_calc(data):
    sqrt = math.sqrt   # cache function lookup!
    return [sqrt(x) for x in data]

# Slow — compile regex inside loop
def slow_match(texts):
    return [re.search(r"\\d+", t) for t in texts]

# Fast — pre-compile regex
def fast_match(texts):
    pattern = re.compile(r"\\d+")
    return [pattern.search(t) for t in texts]

data = list(range(1, 100001))
texts = ["abc123", "def456"] * 50000

t1 = timeit.timeit(lambda: slow_calc(data), number=100)
t2 = timeit.timeit(lambda: fast_calc(data), number=100)
print(f"\\nSlow sqrt: {t1:.3f}s, Fast sqrt: {t2:.3f}s")

t1 = timeit.timeit(lambda: slow_match(texts), number=10)
t2 = timeit.timeit(lambda: fast_match(texts), number=10)
print(f"Slow regex: {t1:.3f}s, Fast regex: {t2:.3f}s")

# ── MEMOIZATION ────────────────────

# Without cache
def fib_slow(n):
    if n < 2: return n
    return fib_slow(n-1) + fib_slow(n-2)

# With lru_cache
@functools.lru_cache(maxsize=None)
def fib_fast(n):
    if n < 2: return n
    return fib_fast(n-1) + fib_fast(n-2)

n = 30
t1 = timeit.timeit(lambda: fib_slow(n), number=10)
t2 = timeit.timeit(lambda: fib_fast(n), number=10)
print(f"\\nfib({n}) without cache: {t1:.3f}s")
print(f"fib({n}) with cache:    {t2:.6f}s  ({t1/t2:.0f}x faster!)")

# ── GENERATORS vs LISTS ────────────

# Memory comparison for large data
import sys

n = 1_000_000
list_comp = [x**2 for x in range(n)]
gen_exp   = (x**2 for x in range(n))

print(f"\\nList size:  {sys.getsizeof(list_comp):,} bytes")
print(f"Generator:  {sys.getsizeof(gen_exp)} bytes")

# For single-pass operations, generator is better
t1 = timeit.timeit(lambda: sum([x**2 for x in range(10000)]), number=1000)
t2 = timeit.timeit(lambda: sum(x**2 for x in range(10000)),   number=1000)
print(f"\\nsum(list comp): {t1:.3f}s")
print(f"sum(gen expr):  {t2:.3f}s")

# ── NUMPY FOR NUMERICAL WORK ────────

# Python loops for numbers: SLOW
def python_sum_of_squares(n):
    return sum(x**2 for x in range(n))

# numpy: C speed
try:
    import numpy as np
    def numpy_sum_of_squares(n):
        return np.sum(np.arange(n)**2)

    n = 100_000
    t1 = timeit.timeit(lambda: python_sum_of_squares(n), number=100)
    t2 = timeit.timeit(lambda: numpy_sum_of_squares(n),  number=100)
    print(f"\\nPython:  {t1:.3f}s")
    print(f"NumPy:   {t2:.3f}s  ({t1/t2:.1f}x faster!)")
except ImportError:
    print("numpy not available")

# ── SLOTS FOR MANY INSTANCES ────────

class NormalPoint:
    def __init__(self, x, y, z):
        self.x = x
        self.y = y
        self.z = z

class SlottedPoint:
    __slots__ = ("x", "y", "z")
    def __init__(self, x, y, z):
        self.x = x
        self.y = y
        self.z = z

n = 1_000_000
t1 = timeit.timeit(lambda: [NormalPoint(i,i,i) for i in range(1000)], number=1000)
t2 = timeit.timeit(lambda: [SlottedPoint(i,i,i) for i in range(1000)], number=1000)
print(f"\\nNormal class: {t1:.3f}s")
print(f"__slots__:    {t2:.3f}s  ({t1/t2:.2f}x faster)")

# Memory
normal = [NormalPoint(i,i,i) for i in range(10)]
slotted = [SlottedPoint(i,i,i) for i in range(10)]
print(f"Normal instance: {sys.getsizeof(normal[0]) + sys.getsizeof(normal[0].__dict__)} bytes")
print(f"Slotted instance: {sys.getsizeof(slotted[0])} bytes")

📝 KEY POINTS:
✅ Profile FIRST (cProfile, timeit) — optimize what actually matters
✅ Use set/dict for membership testing, not list (O(1) vs O(n))
✅ join() instead of string += in loops
✅ Cache repeated attribute lookups outside tight loops
✅ Pre-compile regex patterns used in loops
✅ lru_cache for expensive pure functions called repeatedly
✅ numpy for numerical computation — 10-100x faster than Python loops
✅ __slots__ reduces memory by 30-50% for classes with many instances
❌ Never optimize without measuring — you'll fix the wrong thing
❌ O(n²) algorithms become catastrophically slow — fix the algorithm first
❌ PyPy can't use C extensions easily — check compatibility first
''',
  quiz: [
    Quiz(question: 'Why is "x in my_set" faster than "x in my_list"?', options: [
      QuizOption(text: 'Sets use binary search while lists scan linearly', correct: false),
      QuizOption(text: 'Set membership is O(1) using hash lookup; list membership is O(n) linear scan', correct: true),
      QuizOption(text: 'Sets are stored in CPU cache while lists are in RAM', correct: false),
      QuizOption(text: 'Lists check type equality while sets check identity', correct: false),
    ]),
    Quiz(question: 'Why is "".join(parts) faster than concatenating with += in a loop?', options: [
      QuizOption(text: 'join() is implemented in C', correct: false),
      QuizOption(text: 'String += creates a new string object each iteration; join() allocates memory once', correct: true),
      QuizOption(text: 'join() uses multiple threads', correct: false),
      QuizOption(text: 'They have identical performance', correct: false),
    ]),
    Quiz(question: 'When should you use numpy instead of Python loops for computation?', options: [
      QuizOption(text: 'For any loop regardless of data type', correct: false),
      QuizOption(text: 'For numerical operations on large arrays — numpy uses C-speed vectorized operations', correct: true),
      QuizOption(text: 'When memory usage is more important than speed', correct: false),
      QuizOption(text: 'Only when the array has more than 1 million elements', correct: false),
    ]),
  ],
);
