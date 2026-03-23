import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson62 = Lesson(
  language: 'Python',
  title: 'Scope: LEGB, global & nonlocal',
  content: '''
🎯 METAPHOR:
Scope is like finding where a name lives.
When Python sees a variable name, it searches through
concentric rooms from the innermost outward:
  Local → Enclosing → Global → Built-in
It's like checking your desk drawer first (Local),
then the office supply closet (Enclosing function),
then the company warehouse (Global module),
then the manufacturer's catalog (Built-in).
The moment Python finds the name, it stops searching.
If it reaches Built-in without finding it: NameError.

📖 EXPLANATION:
Python resolves names using the LEGB rule, applied in
strict order. Understanding this prevents subtle bugs
where the wrong value is found or mutations have
unexpected effects.

─────────────────────────────────────
📐 THE LEGB RULE
─────────────────────────────────────
L — Local       innermost function's namespace
E — Enclosing   any enclosing function scopes (closures)
G — Global      module-level namespace
B — Built-in    builtins module (len, print, range, …)

Python searches LEFT to RIGHT in LEGB.
First match wins.

─────────────────────────────────────
🔑 global KEYWORD
─────────────────────────────────────
Assignment inside a function creates a LOCAL variable.
If you want to MODIFY a global variable from inside
a function, you must declare it with: global varname

Without global: assignment creates a shadow local.
With global: assignment modifies the module-level var.

─────────────────────────────────────
🔑 nonlocal KEYWORD
─────────────────────────────────────
Like global but for the ENCLOSING function scope.
Used in nested functions to modify the outer function's
variable (not the global).

─────────────────────────────────────
⚠️  ASSIGNMENT VS READ
─────────────────────────────────────
Reading a variable → LEGB lookup, works fine.
Assigning a variable → creates LOCAL (without global/nonlocal).
This asymmetry causes classic bugs:

x = 10
def f():
    print(x)   # reads global — OK
    x = 20     # creates LOCAL x — but Python sees the
               # assignment ANYWHERE in the function and
               # treats x as local THROUGHOUT → UnboundLocalError!

─────────────────────────────────────
🔍 NAMESPACE INSPECTION
─────────────────────────────────────
locals()   → dict of current local namespace
globals()  → dict of current global namespace
vars(obj)  → obj's __dict__
dir(obj)   → all names in obj's scope

💻 CODE:
# ── LEGB LOOKUP ───────────────────

x = "global"     # Global scope

def outer():
    x = "enclosing"   # Enclosing scope

    def inner():
        x = "local"   # Local scope
        print(x)      # → "local"    (L wins)

    inner()
    print(x)          # → "enclosing" (E at this level = L)

outer()
print(x)              # → "global"

# Showing the full lookup chain
y = "global_y"

def outer2():
    def inner2():
        def innermost():
            print(y)    # Not in L or E → finds in G
        innermost()
    inner2()

outer2()   # → "global_y"

# Built-in scope
print(type(len))   # <class 'builtin_function_or_method'>
# 'len' is in Built-in scope

# Shadowing a built-in (BAD PRACTICE!)
def bad_example():
    len = lambda x: 99   # shadows built-in 'len' locally
    print(len([1,2,3]))  # → 99 (using local, not built-in!)
    # After function returns, global len is restored

# ── THE ASSIGNMENT TRAP ────────────

counter = 0

def broken_increment():
    # Python sees 'counter = counter + 1'
    # → treats counter as LOCAL throughout the function
    # → but reading it BEFORE assigning → UnboundLocalError!
    try:
        counter = counter + 1   # UnboundLocalError!
    except UnboundLocalError as e:
        print(f"Error: {e}")

broken_increment()

# ── global KEYWORD ─────────────────

count = 0

def increment():
    global count    # declares intent to use global
    count += 1      # now modifies the global

def reset():
    global count
    count = 0

increment(); increment(); increment()
print(f"count = {count}")   # 3
reset()
print(f"count = {count}")   # 0

# Multiple globals
total = 0
calls = 0

def track(value):
    global total, calls    # declare multiple
    total += value
    calls += 1

track(10); track(20); track(30)
print(f"total={total}, calls={calls}")   # 60, 3

# ── nonlocal KEYWORD ───────────────

def make_counter(start=0, step=1):
    count = start

    def increment():
        nonlocal count     # modifies the ENCLOSING count
        count += step
        return count

    def decrement():
        nonlocal count
        count -= step
        return count

    def value():
        return count       # just reads — no nonlocal needed

    return increment, decrement, value

inc, dec, val = make_counter(0, 2)
print(inc())   # 2
print(inc())   # 4
print(dec())   # 2
print(val())   # 2

# Nested nonlocal
def outer3():
    x = 1
    def middle():
        nonlocal x
        x = 2
        def inner3():
            nonlocal x
            x = 3
        inner3()
        print(f"middle after inner3: x={x}")   # 3
    middle()
    print(f"outer3 after middle: x={x}")        # 3

outer3()

# ── SCOPE INSPECTION ──────────────

module_var = "I'm global"

def inspect_scope():
    local_var = "I'm local"
    print("Locals:", list(locals().keys()))
    print("Globals (partial):", [k for k in globals() if not k.startswith('_')][:5])

inspect_scope()

# ── COMMON SCOPE PATTERNS ─────────

# ANTI-PATTERN: relying on global state
total_sales = 0

def add_sale_bad(amount):
    global total_sales
    total_sales += amount   # hard to test, side effects

# BETTER: return new value, let caller manage state
def add_sale_good(current_total, amount):
    return current_total + amount   # pure function!

t = 0
t = add_sale_good(t, 100)
t = add_sale_good(t, 200)
print(f"Total: {t}")   # 300

# PATTERN: use class for shared mutable state
class Counter:
    def __init__(self):
        self.value = 0

    def increment(self, step=1):
        self.value += step

    def reset(self):
        self.value = 0

c = Counter()
c.increment(); c.increment(5)
print(c.value)   # 6

# ── LEGB with class bodies ─────────

# Class body has its own scope — but NOT in LEGB chain!
x = "global"

class MyClass:
    x = "class"     # class scope — NOT accessible to methods via LEGB!

    def method(self):
        print(x)   # → "global" (skips class scope!)
        # To access class var: self.x or MyClass.x

obj = MyClass()
obj.method()        # "global" — NOT "class"!
print(MyClass.x)    # "class" — accessed via attribute, not LEGB

# ── CLOSURES AND SCOPE ─────────────

def make_multiplier(factor):
    # 'factor' lives in the Enclosing scope
    def multiply(n):
        return n * factor   # 'factor' found in E (closure)
    return multiply

double = make_multiplier(2)
triple = make_multiplier(3)
print(double(5))   # 10 — factor=2 captured
print(triple(5))   # 15 — factor=3 captured

# Show captured variables
print(double.__code__.co_freevars)          # ('factor',)
print(double.__closure__[0].cell_contents) # 2

📝 KEY POINTS:
✅ LEGB: Local → Enclosing → Global → Built-in — first match wins
✅ Reading a global works without declaration — assignment creates local
✅ Use global sparingly — prefer returning values and passing arguments
✅ nonlocal modifies the nearest enclosing (non-global) scope
✅ Class scope is NOT in the LEGB chain — methods don't see class vars via lookup
✅ UnboundLocalError means Python saw an assignment making it local, then tried to read before assigning
❌ Don't overuse global — it makes functions harder to test and reason about
❌ Don't shadow built-in names (len, list, type, id, etc.)
❌ Class attributes are NOT visible inside methods via plain name lookup
''',
  quiz: [
    Quiz(question: 'In what order does Python search for a variable name?', options: [
      QuizOption(text: 'Global → Local → Enclosing → Built-in', correct: false),
      QuizOption(text: 'Local → Enclosing → Global → Built-in', correct: true),
      QuizOption(text: 'Built-in → Global → Enclosing → Local', correct: false),
      QuizOption(text: 'Local → Global → Enclosing → Built-in', correct: false),
    ]),
    Quiz(question: 'Why does this cause UnboundLocalError?\nx=10\ndef f():\n    print(x)\n    x = 20', options: [
      QuizOption(text: 'Global variables cannot be read inside functions', correct: false),
      QuizOption(text: 'The assignment x=20 makes Python treat x as local throughout f(), so reading it before assignment fails', correct: true),
      QuizOption(text: 'print() cannot access outer scope variables', correct: false),
      QuizOption(text: 'x=20 inside a function is a syntax error', correct: false),
    ]),
    Quiz(question: 'What is the difference between global and nonlocal?', options: [
      QuizOption(text: 'global is for Python 2; nonlocal is for Python 3', correct: false),
      QuizOption(text: 'global refers to module-level scope; nonlocal refers to the nearest enclosing function scope', correct: true),
      QuizOption(text: 'nonlocal is faster than global', correct: false),
      QuizOption(text: 'They are identical — just different syntax', correct: false),
    ]),
  ],
);
