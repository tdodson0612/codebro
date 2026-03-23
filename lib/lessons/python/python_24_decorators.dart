import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson24 = Lesson(
  language: 'Python',
  title: 'Decorators',
  content: """
🎯 METAPHOR:
A decorator is like a gift-wrapping service.
You bring in your present (a function). The gift wrapper
adds beautiful paper, a bow, and a tag (extra behavior).
The recipient gets what appears to be the same gift,
but now it's enhanced and presented differently.
Your original present is still inside — untouched —
but the experience of receiving it is different.
The @decorator syntax is just a shortcut for:
"wrap this function before handing it out."

📖 EXPLANATION:
Decorators are functions that take a function as input,
add behavior, and return a modified version.
They're based on closures and higher-order functions.

─────────────────────────────────────
📐 THE PATTERN
─────────────────────────────────────
# Manual wrapping:
def my_decorator(func):
    def wrapper(*args, **kwargs):
        # before
        result = func(*args, **kwargs)
        # after
        return result
    return wrapper

greet = my_decorator(greet)  # wraps greet

# Shortcut — same thing:
@my_decorator
def greet():
    ...

─────────────────────────────────────
🔖 functools.wraps — ALWAYS USE IT
─────────────────────────────────────
Without @wraps, the wrapper replaces the original
function's __name__, __doc__, etc.
With @wraps(func), the wrapper PRESERVES the
original function's metadata. Always add it.

─────────────────────────────────────
📦 DECORATORS WITH ARGUMENTS
─────────────────────────────────────
To pass args to a decorator, add another level:

def repeat(n):
    def decorator(func):
        @wraps(func)
        def wrapper(*args, **kwargs):
            for _ in range(n):
                func(*args, **kwargs)
        return wrapper
    return decorator

@repeat(3)
def hello():
    print("Hello!")

─────────────────────────────────────
🔗 STACKING DECORATORS
─────────────────────────────────────
@decorator1    ← applied SECOND (outer)
@decorator2    ← applied FIRST (inner)
def func(): ...

Equivalent to: func = decorator1(decorator2(func))

─────────────────────────────────────
🏗️  CLASS-BASED DECORATORS
─────────────────────────────────────
A class with __call__ can be a decorator:

class MyDecorator:
    def __init__(self, func):
        self.func = func
    def __call__(self, *args, **kwargs):
        # extra behavior
        return self.func(*args, **kwargs)

─────────────────────────────────────
⭐ BUILT-IN DECORATORS
─────────────────────────────────────
@property       → getter property
@setter         → setter for property
@staticmethod   → no self or cls
@classmethod    → receives cls
@functools.lru_cache  → memoize results
@functools.cached_property → computed once, then cached
@dataclasses.dataclass → auto-generate __init__, etc.
@abstractmethod → must be overridden

💻 CODE:
import functools
import time

# Basic decorator
def timer(func):
    @functools.wraps(func)    # preserve func metadata!
    def wrapper(*args, **kwargs):
        start = time.perf_counter()
        result = func(*args, **kwargs)
        elapsed = time.perf_counter() - start
        print(f"⏱️  {func.__name__} took {elapsed:.4f}s")
        return result
    return wrapper

@timer
def slow_sum(n):
    """Sum numbers 0 to n."""
    return sum(range(n))

print(slow_sum(1_000_000))   # prints timing + result
print(slow_sum.__name__)     # "slow_sum" (not "wrapper" — @wraps works!)
print(slow_sum.__doc__)      # "Sum numbers 0 to n."

# Logger decorator
def logger(func):
    @functools.wraps(func)
    def wrapper(*args, **kwargs):
        args_repr = [repr(a) for a in args]
        kwargs_repr = [f"{k}={v!r}" for k,v in kwargs.items()]
        signature = ", ".join(args_repr + kwargs_repr)
        print(f"📞 Calling {func.__name__}({signature})")
        result = func(*args, **kwargs)
        print(f"✅ {func.__name__} returned {result!r}")
        return result
    return wrapper

@logger
def add(x, y):
    return x + y

add(3, 4)   # logs: Calling add(3, 4)  then  add returned 7

# Decorator with arguments
def repeat(n=1):
    def decorator(func):
        @functools.wraps(func)
        def wrapper(*args, **kwargs):
            for _ in range(n):
                result = func(*args, **kwargs)
            return result
        return wrapper
    return decorator

@repeat(3)
def say_hello(name):
    print(f"Hello, {name}!")

say_hello("Alice")   # prints 3 times

# Stacking decorators
@timer
@logger
def compute(n):
    return sum(i**2 for i in range(n))

compute(1000)  # logger runs first, timer wraps outside

# Caching with lru_cache — memoization
@functools.lru_cache(maxsize=None)  # cache all results
def fibonacci(n):
    if n < 2:
        return n
    return fibonacci(n-1) + fibonacci(n-2)

print(fibonacci(50))    # instant with caching!
print(fibonacci.cache_info())   # shows hits/misses

# Retry decorator
def retry(max_attempts=3, delay=1.0):
    def decorator(func):
        @functools.wraps(func)
        def wrapper(*args, **kwargs):
            for attempt in range(1, max_attempts + 1):
                try:
                    return func(*args, **kwargs)
                except Exception as e:
                    if attempt == max_attempts:
                        raise
                    print(f"Attempt {attempt} failed: {e}. Retrying...")
                    time.sleep(delay)
        return wrapper
    return decorator

@retry(max_attempts=3, delay=0.5)
def flaky_network_call():
    import random
    if random.random() < 0.7:
        raise ConnectionError("Network error")
    return "Success!"

# Validate input decorator
def validate_positive(*arg_positions):
    def decorator(func):
        @functools.wraps(func)
        def wrapper(*args, **kwargs):
            for i in arg_positions:
                if i < len(args) and args[i] <= 0:
                    raise ValueError(
                        f"Argument {i} must be positive, got {args[i]}"
                    )
            return func(*args, **kwargs)
        return wrapper
    return decorator

@validate_positive(0, 1)
def rectangle_area(width, height):
    return width * height

print(rectangle_area(4, 5))   # 20
try:
    rectangle_area(-1, 5)     # raises ValueError
except ValueError as e:
    print(e)

# Class-based decorator (for stateful decorators)
class CountCalls:
    def __init__(self, func):
        functools.update_wrapper(self, func)
        self.func = func
        self.call_count = 0

    def __call__(self, *args, **kwargs):
        self.call_count += 1
        print(f"Call #{self.call_count} to {self.func.__name__}")
        return self.func(*args, **kwargs)

@CountCalls
def greet(name):
    return f"Hello, {name}!"

greet("Alice")
greet("Bob")
greet("Carol")
print(f"Total calls: {greet.call_count}")   # 3

# @cached_property — compute once, then cached as attribute
class Circle:
    def __init__(self, radius):
        self.radius = radius

    @functools.cached_property
    def area(self):
        import math
        print("Computing area...")  # only runs ONCE
        return math.pi * self.radius ** 2

c = Circle(5)
print(c.area)   # Computing area... 78.53...
print(c.area)   # (no print) — returns cached value

📝 KEY POINTS:
✅ Always use @functools.wraps(func) inside your decorator
✅ Use *args, **kwargs in wrapper to handle any function signature
✅ Decorators with arguments need 3 levels of nesting
✅ Stacking: bottom decorator applied first, top applied last
✅ @lru_cache is great for expensive recursive/pure functions
✅ Class-based decorators are useful when you need state (call count etc.)
❌ Forgetting @wraps breaks __name__, __doc__, and other function metadata
❌ Decorating functions with side effects and caching them can cause bugs
❌ Don't use decorators that change function signatures unless necessary
""",
  quiz: [
    Quiz(question: 'Why should you use @functools.wraps(func) in your decorator?', options: [
      QuizOption(text: 'It makes the decorator run faster', correct: false),
      QuizOption(text: 'It preserves the original function\'s __name__, __doc__, and other metadata', correct: true),
      QuizOption(text: 'It allows the decorator to accept arguments', correct: false),
      QuizOption(text: 'It is required for the decorator to work at all', correct: false),
    ]),
    Quiz(question: 'What is @functools.lru_cache used for?', options: [
      QuizOption(text: 'Making functions run in parallel threads', correct: false),
      QuizOption(text: 'Memoizing (caching) function results to avoid repeated computation', correct: true),
      QuizOption(text: 'Logging all function calls automatically', correct: false),
      QuizOption(text: 'Limiting how many times a function can be called', correct: false),
    ]),
    Quiz(question: 'Given @timer on top of @logger on a function, which runs first?', options: [
      QuizOption(text: '@timer runs first (outermost = first applied = first to run)', correct: false),
      QuizOption(text: '@logger runs first (innermost = first applied = inside the call stack)', correct: true),
      QuizOption(text: 'They run simultaneously', correct: false),
      QuizOption(text: 'The order is random', correct: false),
    ]),
  ],
);
