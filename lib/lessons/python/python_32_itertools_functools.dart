import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson32 = Lesson(
  language: 'Python',
  title: 'itertools & functools',
  content: '''
🎯 METAPHOR:
itertools is like a Lego set for data pipelines.
Each tool is a small, well-engineered piece that snaps
together with any other. chain joins pieces, product
combines dimensions, groupby sorts into bins. You build
complex data transformations out of tiny, reusable blocks
without writing a single loop yourself.

functools is your function upgrade kit.
partial bakes in arguments, lru_cache adds a memory,
reduce folds a sequence into one value, wraps preserves
identity. These are the tools that make functions first-class
citizens — turning simple functions into powerful, reusable machines.

📖 EXPLANATION:
Both modules provide tools for working with functions
and iterables efficiently and elegantly.

─────────────────────────────────────
🔗 ITERTOOLS — INFINITE ITERATORS
─────────────────────────────────────
count(start, step)   → 0, 1, 2, 3, ...
cycle(iter)          → a, b, c, a, b, c, ...
repeat(val, n)       → val, val, val, ...

─────────────────────────────────────
🔗 ITERTOOLS — FINISHING ITERATORS
─────────────────────────────────────
chain(*iters)         → join multiple iterables
chain.from_iterable   → flatten one level
islice(iter, n)       → take first n items
zip_longest(*iters)   → zip, fill missing with fillvalue
compress(data, sel)   → filter by boolean mask
dropwhile(pred, iter) → drop while condition true
takewhile(pred, iter) → take while condition true
filterfalse(pred, i)  → filter where pred is False
starmap(func, iter)   → map with unpacked args
accumulate(iter, op)  → running totals

─────────────────────────────────────
🔗 ITERTOOLS — COMBINATORIC
─────────────────────────────────────
product(*iters)            → cartesian product
permutations(iter, r)      → ordered arrangements
combinations(iter, r)      → unordered selections
combinations_with_replacement → with repeats

─────────────────────────────────────
🔗 ITERTOOLS — GROUPING
─────────────────────────────────────
groupby(iter, key)    → consecutive groups by key
                        ⚠️  must be SORTED first!

─────────────────────────────────────
⚙️  FUNCTOOLS
─────────────────────────────────────
reduce(func, iter, init)   → fold to single value
partial(func, *args)       → partial application
lru_cache(maxsize)         → memoization
cache (Python 3.9+)        → unbounded lru_cache
cached_property             → compute once, cache forever
wraps(func)                → copy function metadata
total_ordering             → fill in comparison methods
cmp_to_key                 → convert cmp func to key
singledispatch             → function overloading by type

💻 CODE:
import itertools
import functools

# ── ITERTOOLS ──────────────────────

# Infinite iterators
counter = itertools.count(10, 5)   # 10, 15, 20, ...
print([next(counter) for _ in range(5)])  # [10, 15, 20, 25, 30]

colors = itertools.cycle(["red", "green", "blue"])
print([next(colors) for _ in range(7)])  # r,g,b,r,g,b,r

five_hellos = list(itertools.repeat("hello", 5))
print(five_hellos)

# chain — join iterables
combined = list(itertools.chain([1,2], [3,4], [5,6]))
print(combined)   # [1, 2, 3, 4, 5, 6]

nested = [[1,2],[3,4],[5,6]]
flat = list(itertools.chain.from_iterable(nested))
print(flat)   # [1, 2, 3, 4, 5, 6]

# islice
gen = itertools.count()
first_10 = list(itertools.islice(gen, 10))
print(first_10)  # [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

# every other (step)
every_other = list(itertools.islice(range(20), 0, 20, 2))
print(every_other)   # [0, 2, 4, 6, 8, 10, 12, 14, 16, 18]

# zip_longest
a = [1, 2, 3]
b = ["a", "b"]
print(list(itertools.zip_longest(a, b, fillvalue="-")))
# [(1,'a'), (2,'b'), (3,'-')]

# compress — filter by boolean mask
data   = ["a", "b", "c", "d", "e"]
select = [True, False, True, True, False]
print(list(itertools.compress(data, select)))  # ['a', 'c', 'd']

# takewhile and dropwhile
nums = [1, 2, 3, 4, 5, 6, 1, 2]
print(list(itertools.takewhile(lambda x: x < 5, nums)))  # [1,2,3,4]
print(list(itertools.dropwhile(lambda x: x < 5, nums)))  # [5,6,1,2]

# accumulate — running total
print(list(itertools.accumulate([1,2,3,4,5])))            # [1,3,6,10,15]
print(list(itertools.accumulate([1,2,3,4,5], lambda a,b: a*b)))  # [1,2,6,24,120]

# starmap — map with unpacked args
pairs = [(2, 3), (4, 2), (3, 4)]
print(list(itertools.starmap(pow, pairs)))  # [8, 16, 81]

# COMBINATORICS
items = ["A", "B", "C", "D"]

# Cartesian product
for combo in itertools.product([1,2], ["a","b"]):
    print(combo, end=" ")
# (1,'a') (1,'b') (2,'a') (2,'b')
print()

# Permutations (ordered, no repeat)
for p in itertools.permutations(items, 2):
    print(p, end=" ")
print()

# Combinations (unordered, no repeat)
for c in itertools.combinations(items, 2):
    print(c, end=" ")
print()

# Combinations with replacement
for c in itertools.combinations_with_replacement("AB", 2):
    print(c, end=" ")
# ('A','A') ('A','B') ('B','B')
print()

# groupby — MUST be sorted first!
data = [
    {"name": "Alice", "dept": "Engineering"},
    {"name": "Bob", "dept": "Marketing"},
    {"name": "Carol", "dept": "Engineering"},
    {"name": "Dave", "dept": "Marketing"},
    {"name": "Eve", "dept": "Engineering"},
]
sorted_data = sorted(data, key=lambda x: x["dept"])
for dept, members in itertools.groupby(sorted_data, key=lambda x: x["dept"]):
    names = [m["name"] for m in members]
    print(f"{dept}: {names}")

# ── FUNCTOOLS ─────────────────────

# reduce
total = functools.reduce(lambda a, b: a + b, [1,2,3,4,5])
print(f"Sum: {total}")    # 15

product = functools.reduce(lambda a, b: a * b, [1,2,3,4,5])
print(f"Product: {product}")   # 120

max_val = functools.reduce(lambda a, b: a if a > b else b, [3,1,4,1,5,9])
print(f"Max: {max_val}")   # 9

# partial — bake in arguments
def power(base, exp):
    return base ** exp

square = functools.partial(power, exp=2)
cube   = functools.partial(power, exp=3)
print(square(5))   # 25
print(cube(3))     # 27

import os
join_home = functools.partial(os.path.join, "/home/user")
print(join_home("documents", "file.txt"))  # /home/user/documents/file.txt

# lru_cache — memoization
@functools.lru_cache(maxsize=128)
def fib(n):
    if n < 2: return n
    return fib(n-1) + fib(n-2)

print(fib(50))   # instant with cache
print(fib.cache_info())

# cache (Python 3.9+) — simpler unbounded cache
@functools.cache
def factorial(n):
    if n <= 1: return 1
    return n * factorial(n-1)

# total_ordering — define < and == to get all comparisons
@functools.total_ordering
class Student:
    def __init__(self, name, gpa):
        self.name = name
        self.gpa = gpa

    def __eq__(self, other):
        return self.gpa == other.gpa

    def __lt__(self, other):
        return self.gpa < other.gpa  # get >, >=, <= for free!

students = [Student("Alice", 3.8), Student("Bob", 3.5), Student("Carol", 3.9)]
print(max(students).name)   # Carol
print(sorted(students, key=lambda s: s.gpa))

# singledispatch — overload by type
@functools.singledispatch
def process(value):
    print(f"Generic: {value}")

@process.register(int)
def _(value):
    print(f"Integer doubled: {value * 2}")

@process.register(str)
def _(value):
    print(f"String upper: {value.upper()}")

@process.register(list)
def _(value):
    print(f"List length: {len(value)}")

process(42)           # Integer doubled: 84
process("hello")      # String upper: HELLO
process([1,2,3])      # List length: 3
process(3.14)         # Generic: 3.14

📝 KEY POINTS:
✅ itertools tools are all lazy (generators) — memory efficient
✅ groupby REQUIRES sorted input — always sort by same key first
✅ partial() is great for creating specialized versions of general functions
✅ lru_cache dramatically speeds up recursive and repeated computations
✅ total_ordering: implement __eq__ and __lt__, get all 6 comparisons free
✅ singledispatch enables function overloading by argument type
❌ groupby doesn't group ALL equal items — only consecutive ones (sort first!)
❌ lru_cache arguments must be hashable — can't cache with list/dict args
❌ Infinite iterators (count, cycle) must be used with islice or break
''',
  quiz: [
    Quiz(question: 'Why must data be sorted before using itertools.groupby()?', options: [
      QuizOption(text: 'groupby only groups CONSECUTIVE equal items, not all matching items in the sequence', correct: true),
      QuizOption(text: 'groupby raises an error on unsorted input', correct: false),
      QuizOption(text: 'Sorting makes groupby significantly faster', correct: false),
      QuizOption(text: 'groupby requires alphabetical ordering to work', correct: false),
    ]),
    Quiz(question: 'What does functools.partial(pow, 2) create?', options: [
      QuizOption(text: 'A function that computes 2 to the power of its argument', correct: true),
      QuizOption(text: 'A partial string "pow"', correct: false),
      QuizOption(text: 'A function that doubles any number', correct: false),
      QuizOption(text: 'An error — partial requires keyword arguments', correct: false),
    ]),
    Quiz(question: 'What is itertools.accumulate([1,2,3,4]) equivalent to?', options: [
      QuizOption(text: '[1, 2, 3, 4] — unchanged', correct: false),
      QuizOption(text: '[1, 3, 6, 10] — running cumulative sum', correct: true),
      QuizOption(text: '10 — the total sum', correct: false),
      QuizOption(text: '[0, 1, 3, 6] — cumulative sum starting at 0', correct: false),
    ]),
  ],
);
