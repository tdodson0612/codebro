import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson36 = Lesson(
  language: 'Python',
  title: 'Closures & Advanced Scope',
  content: """
🎯 METAPHOR:
A closure is like a backpack that a function carries with it.
When a function is defined inside another function, it can
grab items from the outer function's environment and put them
in its backpack before the outer function exits. Even after
the outer function is gone — its local variables normally
destroyed — the inner function still has those captured
variables in its backpack. The backpack travels with the
function wherever it goes. It remembers its origin.

📖 EXPLANATION:
A closure is a function that retains access to variables
from its enclosing scope even after that scope has returned.
It "closes over" those variables — hence the name.

─────────────────────────────────────
📐 WHAT MAKES A CLOSURE
─────────────────────────────────────
Three conditions for a closure:
1. A nested (inner) function
2. The inner function references variables from the outer scope
3. The outer function RETURNS the inner function

─────────────────────────────────────
🔍 FREE VARIABLES
─────────────────────────────────────
Variables referenced in a closure but not locally
defined are called "free variables."
Access them via: function.__code__.co_freevars
and             function.__closure__

─────────────────────────────────────
🔑 nonlocal KEYWORD
─────────────────────────────────────
Like global but for enclosing (not global) scope.
Required to MODIFY (not just read) an enclosing var.
Without nonlocal, assignment creates a NEW local var.

─────────────────────────────────────
🏭 CLOSURE FACTORY PATTERN
─────────────────────────────────────
A function that returns customized functions.
Each returned function has its own copy of the
captured variables — they don't share state.

─────────────────────────────────────
⚠️  LATE BINDING GOTCHA
─────────────────────────────────────
Closures capture the VARIABLE, not the value.
If the variable changes after the closure is created,
the closure sees the NEW value!

# Bug:
funcs = [lambda: i for i in range(5)]
funcs[0]()  → 4  ← NOT 0!

# Fix:
funcs = [lambda i=i: i for i in range(5)]
funcs[0]()  → 0  ✅

💻 CODE:
# Basic closure
def make_multiplier(factor):
    '''Returns a function that multiplies by factor.'''
    def multiply(x):
        return x * factor   # captures 'factor' from outer scope
    return multiply

double = make_multiplier(2)
triple = make_multiplier(3)

print(double(5))    # 10  (factor=2 captured)
print(triple(5))    # 15  (factor=3 captured)
print(double(triple(4)))  # 24

# Each closure has its OWN factor
print(double.__closure__[0].cell_contents)   # 2
print(triple.__closure__[0].cell_contents)   # 3

# Closure with state — counter factory
def make_counter(start=0, step=1):
    count = start

    def increment():
        nonlocal count    # ← required to MODIFY outer variable
        count += step
        return count

    def decrement():
        nonlocal count
        count -= step
        return count

    def reset():
        nonlocal count
        count = start

    def current():
        return count

    return increment, decrement, reset, current

inc, dec, rst, cur = make_counter(0, 2)
print(inc())   # 2
print(inc())   # 4
print(inc())   # 6
print(dec())   # 4
print(cur())   # 4
rst()
print(cur())   # 0

# Memoization closure
def memoize(func):
    cache = {}          # captured by wrapper — persists!
    def wrapper(*args):
        if args not in cache:
            cache[args] = func(*args)
        return cache[args]
    wrapper.cache = cache   # expose cache for inspection
    return wrapper

@memoize
def slow_fib(n):
    if n < 2: return n
    return slow_fib(n-1) + slow_fib(n-2)

print(slow_fib(35))    # instant because of closure cache
print(slow_fib.cache)  # inspect the cache

# Logger factory — closure over log level
def make_logger(name, level="INFO"):
    prefix = f"[{level}] {name}"

    def log(message):
        print(f"{prefix}: {message}")

    return log

debug = make_logger("App", "DEBUG")
error = make_logger("App", "ERROR")
debug("Server started")
error("Connection failed")

# ⚠️  Late binding gotcha
# BUG — all lambdas capture the SAME i variable
buggy = [lambda: i for i in range(5)]
print([f() for f in buggy])   # [4, 4, 4, 4, 4] ← BUG!

# FIX 1 — default argument bakes in value at creation time
fixed1 = [lambda i=i: i for i in range(5)]
print([f() for f in fixed1])  # [0, 1, 2, 3, 4] ✅

# FIX 2 — use a factory function
def make_func(i):
    return lambda: i   # i is a LOCAL param, not a loop var

fixed2 = [make_func(i) for i in range(5)]
print([f() for f in fixed2])  # [0, 1, 2, 3, 4] ✅

# Closure vs class comparison
# These two are equivalent:

# Closure version
def make_adder(n):
    def add(x):
        return x + n
    return add

add5 = make_adder(5)
print(add5(3))    # 8

# Class version
class Adder:
    def __init__(self, n):
        self.n = n
    def __call__(self, x):
        return x + self.n

add5_class = Adder(5)
print(add5_class(3))   # 8

# Closure is simpler for simple stateless cases
# Class is better when state grows complex

# Closure for private state (before dataclasses)
def make_bank_account(initial_balance):
    balance = initial_balance   # "private" — only accessible via closures

    def deposit(amount):
        nonlocal balance
        if amount <= 0:
            raise ValueError("Deposit must be positive")
        balance += amount
        return balance

    def withdraw(amount):
        nonlocal balance
        if amount > balance:
            raise ValueError("Insufficient funds")
        balance -= amount
        return balance

    def get_balance():
        return balance

    return deposit, withdraw, get_balance

deposit, withdraw, balance = make_bank_account(100)
print(balance())     # 100
print(deposit(50))   # 150
print(withdraw(30))  # 120

# inspect closure variables
def outer(x):
    def inner(y):
        return x + y
    return inner

fn = outer(10)
print(fn.__code__.co_freevars)           # ('x',)
print(fn.__closure__[0].cell_contents)  # 10

📝 KEY POINTS:
✅ Closures capture variables from enclosing scope — they live on after outer function exits
✅ nonlocal is required to MODIFY (not just read) an enclosing variable
✅ Each call to a factory function creates a closure with its OWN captured variables
✅ Closures can hold state (like objects) but are simpler for small cases
✅ Late binding: closures capture the VARIABLE, not the value at time of creation
✅ The default argument trick (lambda i=i: i) captures the current value
❌ Don't use global if nonlocal will do — global is too broad
❌ Late binding in loops creates subtle bugs — always use the default arg fix
❌ Deep closures (3+ levels) become hard to debug — consider a class instead
""",
  quiz: [
    Quiz(question: 'What is a closure?', options: [
      QuizOption(text: 'A function defined inside a class', correct: false),
      QuizOption(text: 'An inner function that retains access to variables from its enclosing scope after that scope has exited', correct: true),
      QuizOption(text: 'A function with no return value', correct: false),
      QuizOption(text: 'A context manager using the with statement', correct: false),
    ]),
    Quiz(question: 'Why does [lambda: i for i in range(5)] produce [4,4,4,4,4]?', options: [
      QuizOption(text: 'Python lists only keep the last element', correct: false),
      QuizOption(text: 'Each lambda captures the variable i (late binding), and i ends at 4', correct: true),
      QuizOption(text: 'Lambda functions share state by default', correct: false),
      QuizOption(text: 'It is a bug in Python\'s list comprehension', correct: false),
    ]),
    Quiz(question: 'What does the nonlocal keyword do?', options: [
      QuizOption(text: 'Makes a variable accessible globally', correct: false),
      QuizOption(text: 'Allows an inner function to modify a variable in its enclosing (not global) scope', correct: true),
      QuizOption(text: 'Prevents a variable from being modified by any inner function', correct: false),
      QuizOption(text: 'Creates a new variable in the enclosing scope', correct: false),
    ]),
  ],
);
