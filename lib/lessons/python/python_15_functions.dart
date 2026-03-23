import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson15 = Lesson(
  language: 'Python',
  title: 'Functions',
  content: """
🎯 METAPHOR:
A function is like a vending machine with a purpose.
You put in coins (arguments), push a button (call the function),
it performs its internal magic you don't need to see,
and out comes your snack (return value). You can use
the machine over and over without knowing HOW it works
inside — you just know what goes in and what comes out.
Good functions are black boxes: clear inputs, clear outputs,
no surprises.

📖 EXPLANATION:
Functions are reusable blocks of code that:
  • Avoid repetition (DRY — Don't Repeat Yourself)
  • Organize code into logical units
  • Accept inputs (parameters) and return outputs
  • Can be passed around, stored, and called later

─────────────────────────────────────
📐 DEFINING AND CALLING
─────────────────────────────────────
def function_name(parameters):
    """Docstring: explains what function does"""
    # body
    return value   # optional

Calling:
  result = function_name(arguments)

─────────────────────────────────────
📦 PARAMETERS vs ARGUMENTS
─────────────────────────────────────
Parameter — the variable in the function definition
Argument  — the actual value you pass when calling

def greet(name):   # name is PARAMETER
    print(f"Hi, {name}!")

greet("Alice")     # "Alice" is ARGUMENT

─────────────────────────────────────
🔧 PARAMETER TYPES
─────────────────────────────────────
1. Positional — matched by order
   def add(a, b): return a + b
   add(3, 4)   → 7

2. Default — value if not provided
   def greet(name, greeting="Hello"):
   greet("Alice")           # Hello Alice
   greet("Alice", "Hi")     # Hi Alice

3. Keyword — matched by name
   greet(name="Alice", greeting="Hey")
   greet(greeting="Hey", name="Alice")  # order doesn't matter!

4. *args — variable positional (tuple)
   def total(*nums): return sum(nums)
   total(1, 2, 3, 4, 5)  → 15

5. **kwargs — variable keyword (dict)
   def info(**data): print(data)
   info(name="Alice", age=30)

Full order rule:
  def func(pos, /, norm, *, kw_only):
  positional-only / normal / *args / keyword-only / **kwargs

─────────────────────────────────────
↩️  RETURN VALUES
─────────────────────────────────────
return ends the function and sends back a value.
Without return (or bare return), function returns None.
Can return multiple values (they become a tuple):
  def min_max(lst): return min(lst), max(lst)
  lo, hi = min_max([3,1,4,1,5])

─────────────────────────────────────
📖 DOCSTRINGS
─────────────────────────────────────
Always document your functions with a docstring.
It's the first string literal in the function body.
Access with: function.__doc__ or help(function)

def area(radius):
    """
    Calculate circle area.
    Args:
        radius (float): Circle radius
    Returns:
        float: Area of the circle
    """
    return 3.14159 * radius ** 2

─────────────────────────────────────
🌍 SCOPE — LEGB Rule
─────────────────────────────────────
Python looks up variables in this order:
  L — Local (inside current function)
  E — Enclosing (outer function, for closures)
  G — Global (module level)
  B — Built-in (print, len, etc.)

global  keyword — access/modify global var inside function
nonlocal keyword — access/modify enclosing var

─────────────────────────────────────
⚠️  MUTABLE DEFAULT ARGUMENT TRAP
─────────────────────────────────────
NEVER use mutable types as defaults!

# BUG — the list is created ONCE, shared across calls:
def append_to(item, lst=[]):
    lst.append(item)
    return lst
append_to(1)  # [1]
append_to(2)  # [1, 2]  ← BAD! List persists between calls!

# CORRECT pattern:
def append_to(item, lst=None):
    if lst is None:
        lst = []
    lst.append(item)
    return lst

💻 CODE:
# Basic function
def greet(name):
    """Greet someone by name."""
    return f"Hello, {name}!"

print(greet("Alice"))   # Hello, Alice!
print(greet("Bob"))     # Hello, Bob!

# Default parameters
def power(base, exponent=2):
    return base ** exponent

print(power(3))     # 9  (3^2)
print(power(3, 3))  # 27 (3^3)
print(power(2, 10)) # 1024

# Keyword arguments
def create_user(name, age, role="user", active=True):
    return {"name": name, "age": age, "role": role, "active": active}

u1 = create_user("Alice", 30)
u2 = create_user("Bob", 25, role="admin")
u3 = create_user(age=22, name="Carol", active=False)
print(u1)
print(u2)
print(u3)

# *args — variable positional arguments
def sum_all(*numbers):
    print(f"Received: {numbers}")  # tuple
    return sum(numbers)

print(sum_all(1, 2, 3))         # 6
print(sum_all(1, 2, 3, 4, 5))   # 15
print(sum_all())                 # 0

# **kwargs — variable keyword arguments
def print_info(**data):
    print(f"Received: {data}")   # dict
    for key, value in data.items():
        print(f"  {key}: {value}")

print_info(name="Alice", age=30, city="NYC")

# Combining all parameter types
def full_function(a, b, *args, keyword_only, **kwargs):
    print(f"a={a}, b={b}")
    print(f"args={args}")
    print(f"keyword_only={keyword_only}")
    print(f"kwargs={kwargs}")

full_function(1, 2, 3, 4, 5, keyword_only="hello", x=10, y=20)

# Multiple return values
def stats(numbers):
    """Return mean, min, and max."""
    return sum(numbers)/len(numbers), min(numbers), max(numbers)

mean, minimum, maximum = stats([4, 7, 2, 9, 1, 5])
print(f"Mean={mean:.1f}, Min={minimum}, Max={maximum}")

# Scope: LEGB
x = "global"

def outer():
    x = "enclosing"
    def inner():
        x = "local"
        print(x)   # local
    inner()
    print(x)       # enclosing

outer()
print(x)           # global

# global keyword
count = 0
def increment():
    global count
    count += 1

increment()
increment()
print(count)   # 2

# nonlocal keyword
def make_counter():
    n = 0
    def counter():
        nonlocal n
        n += 1
        return n
    return counter

c = make_counter()
print(c())   # 1
print(c())   # 2
print(c())   # 3

# Mutable default argument trap
def good_append(item, lst=None):
    if lst is None:
        lst = []
    lst.append(item)
    return lst

print(good_append(1))   # [1]
print(good_append(2))   # [2] (not [1, 2]!)

# Unpacking into function arguments
def add(a, b, c):
    return a + b + c

nums = [1, 2, 3]
print(add(*nums))    # unpacks list as positional args

info = {"a": 1, "b": 2, "c": 3}
print(add(**info))   # unpacks dict as keyword args

# Docstring
def circle_area(radius):
    """
    Calculate the area of a circle.

    Args:
        radius (float): The radius of the circle.

    Returns:
        float: The area.

    Raises:
        ValueError: If radius is negative.
    """
    if radius < 0:
        raise ValueError("Radius cannot be negative")
    import math
    return math.pi * radius ** 2

help(circle_area)   # displays docstring
print(circle_area(5))

📝 KEY POINTS:
✅ Use def function_name(params): to define a function
✅ Default args must come after required args
✅ *args collects extra positionals into a tuple
✅ **kwargs collects extra keywords into a dict
✅ Functions return None by default if no return statement
✅ Always document with docstrings — first string in function body
✅ LEGB scope rule: Local → Enclosing → Global → Built-in
❌ NEVER use mutable types (list, dict) as default arguments
❌ Calling global variables from inside functions is fine; MODIFYING requires global keyword
❌ Don't put code after return — it's unreachable
""",
  quiz: [
    Quiz(question: 'What is the mutable default argument trap?', options: [
      QuizOption(text: 'Mutable defaults are created once at definition time and shared across all calls', correct: true),
      QuizOption(text: 'Mutable defaults cause slower function execution', correct: false),
      QuizOption(text: 'Python raises a TypeError when mutable defaults are used', correct: false),
      QuizOption(text: 'Mutable defaults cannot be changed inside the function', correct: false),
    ]),
    Quiz(question: 'What does def func(*args) do?', options: [
      QuizOption(text: 'Requires exactly one argument called args', correct: false),
      QuizOption(text: 'Collects all extra positional arguments into a tuple named args', correct: true),
      QuizOption(text: 'Collects keyword arguments into a dict', correct: false),
      QuizOption(text: 'Makes all arguments optional', correct: false),
    ]),
    Quiz(question: 'In the LEGB scope rule, what does E stand for?', options: [
      QuizOption(text: 'External module scope', correct: false),
      QuizOption(text: 'Enclosing function scope (for nested functions)', correct: true),
      QuizOption(text: 'Exception scope', correct: false),
      QuizOption(text: 'Environment scope', correct: false),
    ]),
  ],
);
