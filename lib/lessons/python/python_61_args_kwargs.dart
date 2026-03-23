import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson61 = Lesson(
  language: 'Python',
  title: 'args, kwargs & Parameter Deep Dive',
  content: '''
🎯 METAPHOR:
*args is like a carry-on bag that expands to fit any
number of items. You don't know in advance how many
shirts, books, or snacks the traveler will pack — the
bag just stretches. **kwargs is like a form where
each item has BOTH a label AND a value: "shirts: 3",
"books: 2", "snacks: many". One handles unnamed extras,
the other handles named extras.

📖 EXPLANATION:
Python has 5 types of function parameters:
  1. Positional: def f(x, y)
  2. Default: def f(x, y=10)
  3. *args: captures extra positional args as tuple
  4. **kwargs: captures extra keyword args as dict
  5. Keyword-only: def f(*, key) after the *

─────────────────────────────────────
📐 PARAMETER ORDER RULE
─────────────────────────────────────
def func(pos, /, normal, *args, kw_only, **kwargs)
         ▲          ▲      ▲       ▲          ▲
    pos-only    regular  extra  kw-only   extra
    (py3.8+)           pos      args     kwargs

Order MUST be:
  1. Positional-only (before /)
  2. Regular (with or without defaults)
  3. *args (or bare * for kw-only separator)
  4. Keyword-only (after *)
  5. **kwargs (always last)

─────────────────────────────────────
📦 *args — VARIABLE POSITIONAL
─────────────────────────────────────
Collects ALL extra positional arguments into a TUPLE.
def f(*args): args is a tuple.
Caller can pass 0, 1, or 100 positional args.

─────────────────────────────────────
📦 **kwargs — VARIABLE KEYWORD
─────────────────────────────────────
Collects ALL extra keyword arguments into a DICT.
def f(**kwargs): kwargs is a dict.
Caller can pass any named arguments.

─────────────────────────────────────
🔀 UNPACKING WITH * AND **
─────────────────────────────────────
At the CALL SITE (not definition):
  *iterable → unpacks into positional args
  **dict    → unpacks into keyword args

─────────────────────────────────────
🔑 KEYWORD-ONLY PARAMETERS
─────────────────────────────────────
Parameters AFTER * or *args MUST be passed by name.
def draw(shape, *, color="black", fill=True):
    ...
draw("circle", color="red")      # ✅
draw("circle", "red")            # ❌ TypeError

💻 CODE:
# ── *args — variable positional ────

def add(*args):
    return sum(args)

print(add(1, 2))           # 3
print(add(1, 2, 3, 4, 5)) # 15
print(add())               # 0

def greet(greeting, *names):
    for name in names:
        print(f"{greeting}, {name}!")

greet("Hello", "Alice", "Bob", "Carol")

# args is a TUPLE — can iterate, index, unpack
def show_args(*args):
    print(type(args))    # <class 'tuple'>
    print(len(args))
    for i, arg in enumerate(args):
        print(f"  [{i}] {arg!r}")

show_args("x", 42, True, [1,2,3])

# ── **kwargs — variable keyword ────

def create_profile(**kwargs):
    print(type(kwargs))  # <class 'dict'>
    for key, value in kwargs.items():
        print(f"  {key}: {value}")

create_profile(name="Alice", age=30, city="NYC", role="engineer")

# Mix positional + kwargs
def log(level, message, **context):
    print(f"[{level}] {message}")
    if context:
        for k, v in context.items():
            print(f"  {k}={v}")

log("INFO", "Server started", port=8080, host="localhost")
log("ERROR", "Connection failed", retries=3, timeout=30)

# ── Combining all parameter types ──

def full_example(a, b, /, c, d=10, *args, kw_only, flag=False, **kwargs):
    print(f"pos-only:  a={a}, b={b}")
    print(f"normal:    c={c}, d={d}")
    print(f"extra pos: {args}")
    print(f"kw-only:   kw_only={kw_only}, flag={flag}")
    print(f"extra kw:  {kwargs}")

full_example(1, 2, 3, 4, 5, 6, 7, kw_only="hi", flag=True, x=99, y=100)

# ── Forwarding args and kwargs ──────

def wrapper(*args, **kwargs):
    """Pass everything through to another function."""
    print(f"Before call: args={args}, kwargs={kwargs}")
    result = original(*args, **kwargs)
    print(f"After call: result={result}")
    return result

def original(a, b, *, multiplier=1):
    return (a + b) * multiplier

wrapper(3, 4, multiplier=2)

# ── Unpacking at call site ──────────

def add3(a, b, c):
    return a + b + c

nums = [1, 2, 3]
print(add3(*nums))        # Unpacks list → positional args: 6

coords = {"a": 10, "b": 20, "c": 30}
print(add3(**coords))     # Unpacks dict → keyword args: 60

# Mix unpacking
print(add3(*[1, 2], c=3)) # 6

# Unpack multiple iterables
def f(*args):
    return list(args)

a = [1, 2, 3]
b = [4, 5, 6]
c = [7, 8, 9]
print(f(*a, *b, *c))      # [1, 2, 3, 4, 5, 6, 7, 8, 9]

# Merge dicts with **
defaults = {"color": "blue", "size": "M"}
overrides = {"color": "red", "weight": 1.5}
merged = {**defaults, **overrides}  # later keys win
print(merged)  # {'color': 'red', 'size': 'M', 'weight': 1.5}

# ── Keyword-only parameters ─────────

def connect(host, port, *, timeout=30, retries=3, ssl=True):
    """All params after * are keyword-only."""
    print(f"Connecting to {host}:{port}")
    print(f"  timeout={timeout}, retries={retries}, ssl={ssl}")

connect("localhost", 5432)                    # uses defaults
connect("prod.db", 5432, timeout=10, ssl=False)
# connect("localhost", 5432, 10)  → TypeError!

# ── Positional-only (Python 3.8+) ──

def normalize(value, /, min_val=0, max_val=1):
    """value is positional-only — can't pass as keyword."""
    return (value - min_val) / (max_val - min_val)

print(normalize(0.5))               # 0.5
print(normalize(0.5, min_val=-1))   # 0.75
# normalize(value=0.5)  → TypeError!

# ── Real-world: decorator preserving signature ──

import functools

def retry(max_attempts=3, delay=1.0):
    def decorator(func):
        @functools.wraps(func)
        def wrapper(*args, **kwargs):  # captures all args!
            for attempt in range(1, max_attempts + 1):
                try:
                    return func(*args, **kwargs)  # forwards all!
                except Exception as e:
                    if attempt == max_attempts:
                        raise
                    import time; time.sleep(delay)
        return wrapper
    return decorator

@retry(max_attempts=3)
def unreliable(x, *, verbose=False):
    import random
    if random.random() < 0.5:
        raise ValueError("Random failure")
    return x * 2

# ── Type hints with *args/**kwargs ──

from typing import Any

def typed_log(level: str, *messages: str, **context: Any) -> None:
    print(f"[{level}]", " | ".join(messages))
    for k, v in context.items():
        print(f"  {k}: {v}")

typed_log("INFO", "Server up", "Ready", host="localhost", port=8080)

📝 KEY POINTS:
✅ *args collects extra positional args as a TUPLE
✅ **kwargs collects extra keyword args as a DICT
✅ Order: positional → defaults → *args → kw-only → **kwargs
✅ At call site: *list unpacks to positional, **dict unpacks to keyword
✅ Keyword-only params (after *) MUST be named at call site
✅ **{...} is the clean way to merge dicts
✅ Decorators use *args, **kwargs to transparently forward all arguments
❌ Can't have *args before regular params with defaults
❌ **kwargs must always be the very last parameter
❌ Bare * (without args) just separates positional from keyword-only
''',
  quiz: [
    Quiz(question: 'What type does *args collect arguments into?', options: [
      QuizOption(text: 'A list', correct: false),
      QuizOption(text: 'A tuple', correct: true),
      QuizOption(text: 'A dict', correct: false),
      QuizOption(text: 'A set', correct: false),
    ]),
    Quiz(question: 'What does def f(a, b, *, c) mean for parameter c?', options: [
      QuizOption(text: 'c is optional and defaults to None', correct: false),
      QuizOption(text: 'c must be passed as a keyword argument: f(1, 2, c=3)', correct: true),
      QuizOption(text: 'c collects extra positional arguments', correct: false),
      QuizOption(text: 'c is positional-only', correct: false),
    ]),
    Quiz(question: 'What does func(**{"a": 1, "b": 2}) do at the call site?', options: [
      QuizOption(text: 'Passes the dict as a single argument', correct: false),
      QuizOption(text: 'Unpacks the dict into keyword arguments: func(a=1, b=2)', correct: true),
      QuizOption(text: 'Creates a copy of the dict inside the function', correct: false),
      QuizOption(text: 'Raises a TypeError — ** is only for definitions', correct: false),
    ]),
  ],
);
