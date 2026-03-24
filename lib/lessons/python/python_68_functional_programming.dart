import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson68 = Lesson(
  language: 'Python',
  title: 'Functional Programming in Python',
  content: """
🎯 METAPHOR:
Functional programming is like cooking with pure recipes.
Each recipe (function) takes ingredients (input), produces
a dish (output), and NEVER touches anyone else's food or
rearranges the kitchen (no side effects). You can run the
same recipe 1000 times with the same ingredients and always
get the same dish. You can combine recipes: "first do recipe A,
then recipe B on the result." This predictability and
composability makes code much easier to reason about, test,
and parallelize.

📖 EXPLANATION:
Python supports functional programming styles alongside OOP.
Key concepts: pure functions, immutability, higher-order
functions, function composition, map/filter/reduce, and
avoiding side effects.

─────────────────────────────────────
🔑 CORE PRINCIPLES
─────────────────────────────────────
Pure functions:
  • Same input → always same output
  • No side effects (no modifying external state)
  • Easy to test, memoize, parallelize

Immutability:
  • Prefer creating new objects over mutating
  • Tuples over lists when data shouldn't change

Higher-order functions:
  • Functions that take functions as arguments
  • Functions that return functions

Function composition:
  • f(g(x)) — chain transformations

─────────────────────────────────────
📦 FUNCTIONAL TOOLS
─────────────────────────────────────
map(f, iter)       → apply f to each element (lazy)
filter(pred, iter) → keep elements where pred(x) is True
functools.reduce(f, iter) → fold to single value
functools.partial  → partial application
functools.compose  → (not built-in, but easy to write)
itertools          → combinatorial and lazy tools

─────────────────────────────────────
🆚 FUNCTIONAL vs IMPERATIVE
─────────────────────────────────────
Imperative: HOW to do something (step-by-step commands)
Functional: WHAT to compute (transformations of data)

─────────────────────────────────────
🐍 PYTHON'S STANCE
─────────────────────────────────────
Python supports functional style but isn't purely
functional. Comprehensions are usually more Pythonic
than map/filter. Use functional tools when they make
the code clearer or when chaining transformations.

💻 CODE:
from functools import reduce, partial, lru_cache
from itertools import chain, starmap, takewhile
from operator import add, mul, attrgetter
from typing import Callable, TypeVar, Iterable, Any
import operator

T = TypeVar("T")
U = TypeVar("U")

# ── PURE FUNCTIONS ─────────────────

# IMPURE — modifies external state (side effect)
total = 0
def add_to_total_bad(x):
    global total
    total += x    # side effect!
    return total

# PURE — same input = same output, no side effects
def add_values(a, b):
    return a + b   # pure!

# Impure: depends on external state
import datetime
def get_greeting_bad():
    hour = datetime.datetime.now().hour
    return "Good morning" if hour < 12 else "Good evening"

# Pure: takes all inputs as parameters
def get_greeting(hour: int) -> str:
    return "Good morning" if hour < 12 else "Good evening"

# ── HIGHER-ORDER FUNCTIONS ─────────

# Functions as arguments
def apply(func: Callable, value):
    return func(value)

print(apply(str.upper, "hello"))    # HELLO
print(apply(lambda x: x**2, 5))    # 25

# Functions as return values
def make_adder(n: int) -> Callable[[int], int]:
    return lambda x: x + n

add5  = make_adder(5)
add10 = make_adder(10)
print(add5(3))    # 8
print(add10(3))   # 13

# Decorator pattern (higher-order)
def twice(func):
    def wrapper(*args, **kwargs):
        func(*args, **kwargs)
        func(*args, **kwargs)
    return wrapper

@twice
def say(msg):
    print(msg)

say("Hello!")   # prints twice

# ── MAP, FILTER, REDUCE ────────────

numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

# map — transform each element (lazy iterator)
squares = list(map(lambda x: x**2, numbers))
doubled = list(map(lambda x: x * 2, numbers))
print(squares)   # [1, 4, 9, 16, 25, 36, 49, 64, 81, 100]

# With Python function (no lambda needed)
strs = list(map(str, numbers))
print(strs)   # ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10']

# filter — keep matching elements (lazy iterator)
evens  = list(filter(lambda x: x % 2 == 0, numbers))
odds   = list(filter(lambda x: x % 2 != 0, numbers))
print(evens)   # [2, 4, 6, 8, 10]

# filterfalse — keep non-matching
from itertools import filterfalse
non_evens = list(filterfalse(lambda x: x % 2 == 0, numbers))
print(non_evens)

# reduce — fold to single value
total = reduce(add, numbers)          # 55
product = reduce(mul, numbers)        # 3628800
max_val = reduce(lambda a,b: a if a>b else b, numbers)  # 10
print(total, product, max_val)

# Custom reduce: flatten
nested = [[1,2],[3,4],[5,6]]
flat = reduce(lambda acc, lst: acc + lst, nested, [])
print(flat)   # [1, 2, 3, 4, 5, 6]

# ── COMPREHENSIONS vs FUNCTIONAL ──

data = range(1, 11)

# map + filter with lambdas (functional)
result_functional = list(map(lambda x: x**2,
                             filter(lambda x: x % 2 == 0, data)))

# Comprehension (more Pythonic)
result_pythonic = [x**2 for x in data if x % 2 == 0]

print(result_functional)   # [4, 16, 36, 64, 100]
print(result_pythonic)     # [4, 16, 36, 64, 100]

# ── FUNCTION COMPOSITION ──────────

# Manual composition
def compose(*fns):
    '''Compose functions right-to-left: compose(f, g)(x) = f(g(x))'''
    def composed(x):
        for fn in reversed(fns):
            x = fn(x)
        return x
    return composed

def pipe(*fns):
    '''Compose functions left-to-right: pipe(f, g)(x) = g(f(x))'''
    def piped(x):
        for fn in fns:
            x = fn(x)
        return x
    return piped

# Build a text processing pipeline
clean = pipe(
    str.strip,
    str.lower,
    lambda s: s.replace("-", "_"),
    lambda s: s.replace(" ", "_"),
)

print(clean("  Hello World-Python  "))   # hello_world_python

# Compose math functions
double    = lambda x: x * 2
add_one   = lambda x: x + 1
square    = lambda x: x ** 2

# double, then add_one, then square
transform = pipe(double, add_one, square)
print(transform(3))   # ((3*2)+1)^2 = 49

# ── PARTIAL APPLICATION ────────────

from functools import partial

def power(base, exp):
    return base ** exp

square = partial(power, exp=2)
cube   = partial(power, exp=3)
to_10  = partial(power, exp=10)

print(square(5))   # 25
print(cube(3))     # 27
print(to_10(2))    # 1024

# Partial with positional args
def greet(greeting, name, punctuation="!"):
    return f"{greeting}, {name}{punctuation}"

hello = partial(greet, "Hello")
print(hello("Alice"))          # Hello, Alice!
print(hello("Bob", punctuation="?"))  # Hello, Bob?

# Real use: pre-configure functions
import os.path
join_home = partial(os.path.join, "/home/user")
print(join_home("docs", "report.txt"))

# ── CURRYING ──────────────────────

def curry(func):
    '''Convert f(a,b,c) to f(a)(b)(c).'''
    import inspect
    n = len(inspect.signature(func).parameters)

    def curried(*args):
        if len(args) >= n:
            return func(*args)
        return lambda *more: curried(*args, *more)
    return curried

@curry
def add3(a, b, c):
    return a + b + c

print(add3(1)(2)(3))    # 6
print(add3(1, 2)(3))    # 6
print(add3(1)(2, 3))    # 6

# ── MEMOIZATION ───────────────────

@lru_cache(maxsize=256)
def expensive(n: int) -> int:
    '''Pure function — safe to memoize.'''
    return sum(i**2 for i in range(n))

print(expensive(1000))   # computed
print(expensive(1000))   # cached — instant!
print(expensive.cache_info())

# ── REAL PIPELINE EXAMPLE ─────────

from dataclasses import dataclass

@dataclass
class Product:
    name: str
    price: float
    category: str
    in_stock: bool

products = [
    Product("Widget",  9.99,  "tools",  True),
    Product("Gadget",  24.99, "tech",   True),
    Product("Doohickey", 4.99, "tools", False),
    Product("Thingamajig", 49.99, "tech", True),
    Product("Whatsit",  14.99, "tools", True),
]

# Functional pipeline
is_in_stock   = lambda p: p.in_stock
is_tools      = lambda p: p.category == "tools"
get_price     = lambda p: p.price
get_name      = lambda p: p.name
apply_discount= lambda p: Product(p.name, p.price * 0.9, p.category, p.in_stock)

# Find discounted in-stock tool prices, sorted
result = sorted(
    map(get_price,
        map(apply_discount,
            filter(is_in_stock,
                   filter(is_tools, products)))),
    reverse=True
)
print("Discounted in-stock tool prices (desc):", result)

# Same with comprehension (often clearer):
result2 = sorted(
    [p.price * 0.9 for p in products if p.in_stock and p.category == "tools"],
    reverse=True
)
print(result2)

📝 KEY POINTS:
✅ Pure functions: same inputs → same output, no side effects — easy to test
✅ Higher-order functions take/return functions — enables powerful abstractions
✅ map/filter return lazy iterators — wrap in list() only when needed
✅ reduce folds a sequence into a single value left-to-right
✅ partial() bakes in arguments to create specialized versions of functions
✅ Function composition (pipe/compose) builds complex transforms from simple ones
✅ @lru_cache memoizes pure functions safely — never memoize impure functions
❌ Comprehensions are usually more Pythonic than nested map/filter/lambda
❌ Don't memoize functions with side effects — cache stores stale state
❌ Deeply nested map(filter(map(...))) — use comprehensions or named steps
""",
  quiz: [
    Quiz(question: 'What makes a function "pure"?', options: [
      QuizOption(text: 'It uses only built-in functions', correct: false),
      QuizOption(text: 'Same inputs always produce the same output, with no side effects', correct: true),
      QuizOption(text: 'It has no loops or conditionals', correct: false),
      QuizOption(text: 'It returns a value (not None)', correct: false),
    ]),
    Quiz(question: 'What does functools.partial(pow, exp=2) create?', options: [
      QuizOption(text: 'A partial string "pow"', correct: false),
      QuizOption(text: 'A new function that calls pow() with exp=2 baked in', correct: true),
      QuizOption(text: 'A class that wraps pow()', correct: false),
      QuizOption(text: 'A cached version of pow()', correct: false),
    ]),
    Quiz(question: 'What is the difference between map() and a list comprehension?', options: [
      QuizOption(text: 'map() is faster; comprehensions are more readable', correct: false),
      QuizOption(text: 'map() returns a lazy iterator; list comprehension creates a list immediately', correct: true),
      QuizOption(text: 'map() can handle multiple iterables; comprehensions cannot', correct: false),
      QuizOption(text: 'They are identical in behavior', correct: false),
    ]),
  ],
);
