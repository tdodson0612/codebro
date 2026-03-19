import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson19 = Lesson(
  language: 'Python',
  title: 'Modules & Imports',
  content: '''
🎯 METAPHOR:
Modules are like toolboxes in a workshop.
Instead of dumping every single tool in one pile,
you organize them: the math toolbox, the date toolbox,
the network toolbox. When you need a specific tool,
you open the right toolbox and grab it. Python ships
with hundreds of toolboxes (the Standard Library) and
you can order more online (PyPI/pip). You don't carry
all toolboxes to every job — you only bring what you need.

📖 EXPLANATION:
A module is any .py file. Python's standard library is
a massive collection of modules that comes pre-installed.
Third-party modules are installed via pip.

─────────────────────────────────────
📥 IMPORT SYNTAX
─────────────────────────────────────
import module                → access as module.name
import module as alias       → access as alias.name
from module import name      → access as name directly
from module import name as a → access as a
from module import *         → import everything (avoid!)

─────────────────────────────────────
📦 STANDARD LIBRARY HIGHLIGHTS
─────────────────────────────────────
math        → sqrt, pi, sin, cos, ceil, floor, log
random      → randint, choice, shuffle, random
os          → file system, env variables, paths
sys         → interpreter, argv, exit, path
datetime    → date, time, datetime, timedelta
json        → encode/decode JSON
re          → regular expressions
collections → Counter, defaultdict, deque, OrderedDict
itertools   → chain, product, combinations, permutations
functools   → reduce, partial, lru_cache, wraps
pathlib     → modern file path handling
io          → StringIO, BytesIO
time        → sleep, time, perf_counter
hashlib     → md5, sha256, etc.
urllib      → HTTP requests (basic)
http        → HTTP client/server
socket      → low-level networking
threading   → threads
multiprocessing → processes
subprocess  → run system commands
argparse    → command-line argument parsing
logging     → proper log output
unittest    → testing framework
abc         → abstract base classes
typing      → type hints
dataclasses → @dataclass decorator
enum        → Enum class
contextlib  → @contextmanager
copy        → deepcopy
pprint      → pretty printing
textwrap    → wrap/indent text
struct      → pack/unpack binary data
base64      → encode/decode base64
csv         → CSV file reading/writing
sqlite3     → built-in SQL database

─────────────────────────────────────
📁 CREATING YOUR OWN MODULES
─────────────────────────────────────
Any .py file is a module.
myutils.py:
  def greet(name): return f"Hello, {name}!"
  PI = 3.14159

main.py:
  import myutils
  print(myutils.greet("Alice"))

─────────────────────────────────────
📦 PACKAGES
─────────────────────────────────────
A package is a folder with an __init__.py file.

mypackage/
  __init__.py
  utils.py
  math_tools.py

from mypackage import utils
from mypackage.math_tools import calculate

─────────────────────────────────────
🔒 if __name__ == "__main__"
─────────────────────────────────────
When a file is run directly, __name__ == "__main__"
When it's imported, __name__ == the module name.
This lets you write code that only runs when directly
executed, not when imported as a module.

💻 CODE:
# Standard imports
import math
import random
import datetime
from collections import Counter, defaultdict, deque
from itertools import chain, combinations
from functools import reduce, partial

# math
print(math.pi)             # 3.141592653589793
print(math.sqrt(144))      # 12.0
print(math.ceil(3.2))      # 4
print(math.floor(3.9))     # 3
print(math.log2(1024))     # 10.0
print(math.factorial(10))  # 3628800
print(math.gcd(48, 18))    # 6

# random
random.seed(42)   # reproducible results
print(random.randint(1, 100))       # random int 1-100
print(random.random())              # float 0.0-1.0
print(random.choice(["a","b","c"])) # random item
lst = [1, 2, 3, 4, 5]
random.shuffle(lst)                 # shuffle in place
print(lst)
print(random.sample(lst, 3))        # 3 unique picks

# datetime
from datetime import datetime, date, timedelta
now = datetime.now()
print(now)
print(now.strftime("%Y-%m-%d %H:%M:%S"))   # formatted
today = date.today()
print(today.strftime("%B %d, %Y"))          # e.g. "March 15, 2024"
birthday = date(1990, 6, 15)
age_days = (today - birthday).days
print(f"Age in days: {age_days}")

# timedelta
tomorrow = today + timedelta(days=1)
next_week = today + timedelta(weeks=1)
print(tomorrow, next_week)

# os and pathlib
import os
from pathlib import Path

print(os.getcwd())              # current directory
print(os.listdir("."))          # list files
home = Path.home()              # home directory
print(home)
p = Path("data") / "file.txt"   # path joining
print(p)                        # data/file.txt
print(p.suffix)                 # .txt
print(p.stem)                   # file
print(p.parent)                 # data
print(p.exists())               # True/False

# sys
import sys
print(sys.version)              # Python version
print(sys.platform)             # 'win32', 'darwin', 'linux'
print(sys.argv)                 # command-line arguments
# sys.exit(0)                   # exit with code

# json
import json
data = {"name": "Alice", "age": 30, "scores": [95, 87]}
json_str = json.dumps(data)          # dict → JSON string
json_pretty = json.dumps(data, indent=2)  # formatted
back = json.loads(json_str)          # JSON string → dict
print(json_str)
print(json_pretty)

# Save/load JSON files
with open("data.json", "w") as f:
    json.dump(data, f, indent=2)
with open("data.json", "r") as f:
    loaded = json.load(f)
print(loaded)

# collections
text = "banana"
freq = Counter(text)
print(freq)                    # Counter({'a':3,'n':2,'b':1})
print(freq.most_common(2))     # [('a',3), ('n',2)]

graph = defaultdict(list)
graph["A"].append("B")
graph["A"].append("C")
print(dict(graph))

queue = deque([1,2,3])
queue.appendleft(0)    # O(1) front insert
queue.append(4)        # O(1) back insert
print(queue)
queue.popleft()        # O(1) front remove

# itertools
from itertools import chain, combinations, permutations, product

# chain — iterate multiple iterables as one
combined = list(chain([1,2], [3,4], [5,6]))
print(combined)   # [1, 2, 3, 4, 5, 6]

# combinations — choose r from n
for c in combinations([1,2,3,4], 2):
    print(c, end=" ")
# (1,2) (1,3) (1,4) (2,3) (2,4) (3,4)
print()

# product — cartesian product
for p in product([1,2], ["a","b"]):
    print(p, end=" ")
# (1,'a') (1,'b') (2,'a') (2,'b')
print()

# functools
add = lambda x, y: x + y
add5 = partial(add, 5)    # "bake in" first argument
print(add5(3))    # 8
print(add5(10))   # 15

product_func = partial(reduce, lambda a,b: a*b)
print(product_func([1,2,3,4,5]))   # 120

# __name__ == "__main__"
if __name__ == "__main__":
    print("Running directly, not imported!")

📝 KEY POINTS:
✅ import module as alias — shorter names for frequently used modules
✅ from module import name — use directly without prefix
✅ Avoid "from module import *" — pollutes namespace
✅ if __name__ == "__main__": guards code that should only run directly
✅ Standard library is huge — check docs before writing your own utility
✅ pathlib.Path is modern and preferred over os.path for file paths
❌ Circular imports (A imports B, B imports A) — restructure your code
❌ Don't import * in production code
❌ Don't shadow built-ins: never name a variable "list", "str", "math" etc.
''',
  quiz: [
    Quiz(question: 'What does "if __name__ == \'__main__\':" do?', options: [
      QuizOption(text: 'Runs code only when the file is executed directly, not when imported', correct: true),
      QuizOption(text: 'Defines the main function like Java', correct: false),
      QuizOption(text: 'Checks if the module name is valid', correct: false),
      QuizOption(text: 'Prevents the file from being imported', correct: false),
    ]),
    Quiz(question: 'What is the difference between "import math" and "from math import sqrt"?', options: [
      QuizOption(text: '"import math" requires math.sqrt(); "from math import sqrt" lets you call sqrt() directly', correct: true),
      QuizOption(text: '"from math import sqrt" is slower because it does more work', correct: false),
      QuizOption(text: 'They are identical — just different syntax', correct: false),
      QuizOption(text: '"import math" only imports the math module metadata', correct: false),
    ]),
    Quiz(question: 'Which collection type gives O(1) insertion and removal at both ends?', options: [
      QuizOption(text: 'list', correct: false),
      QuizOption(text: 'collections.deque', correct: true),
      QuizOption(text: 'tuple', correct: false),
      QuizOption(text: 'set', correct: false),
    ]),
  ],
);
