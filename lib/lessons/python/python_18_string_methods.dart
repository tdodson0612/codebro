import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson18 = Lesson(
  language: 'Python',
  title: 'String Methods & Advanced Formatting',
  content: """
🎯 METAPHOR:
Python strings come with a built-in Swiss Army knife.
The knife is always there, attached to the string —
you just call its tools with a dot: .upper(), .split(),
.replace(). Each tool does one job well. You don't
need to import anything; just pick the tool and use it.
The string itself never changes (remember: immutable!)
— each tool returns a shiny NEW string.

📖 EXPLANATION:
Python strings have 40+ built-in methods covering
case conversion, searching, splitting, stripping,
checking, formatting, and encoding.

─────────────────────────────────────
🔠 CASE METHODS
─────────────────────────────────────
s.upper()        → "HELLO WORLD"
s.lower()        → "hello world"
s.title()        → "Hello World"    (first letter of each word)
s.capitalize()   → "Hello world"    (first letter only)
s.swapcase()     → "hELLO wORLD"
s.casefold()     → like lower() but more aggressive (for comparisons)

─────────────────────────────────────
🔍 SEARCH & CHECK
─────────────────────────────────────
s.find(sub)      → index or -1
s.rfind(sub)     → last occurrence index or -1
s.index(sub)     → index or ValueError
s.rindex(sub)    → last occurrence or ValueError
s.count(sub)     → number of occurrences
s.startswith(prefix) → bool (accepts tuple of prefixes!)
s.endswith(suffix)   → bool (accepts tuple of suffixes!)
s.in keyword     → fastest membership check

─────────────────────────────────────
✂️  SPLIT & JOIN
─────────────────────────────────────
s.split(sep)       → list of strings (default: whitespace)
s.rsplit(sep, n)   → split from right, max n splits
s.splitlines()     → split on newlines
sep.join(iterable) → join list into string

─────────────────────────────────────
🧼 STRIP METHODS
─────────────────────────────────────
s.strip()          → remove leading+trailing whitespace
s.lstrip()         → remove leading whitespace
s.rstrip()         → remove trailing whitespace
s.strip("xyz")     → remove specific chars from both ends

─────────────────────────────────────
🔧 REPLACE & TRANSLATE
─────────────────────────────────────
s.replace(old, new)        → replace all occurrences
s.replace(old, new, count) → replace max count times
s.translate(table)         → char-by-char substitution
str.maketrans(x, y, z)     → build translation table

─────────────────────────────────────
✅ BOOLEAN CHECK METHODS
─────────────────────────────────────
s.isalpha()    → all alphabetic?
s.isdigit()    → all digit characters?
s.isnumeric()  → all numeric? (includes ², ½ etc.)
s.isdecimal()  → all decimal digits 0-9?
s.isalnum()    → alphanumeric?
s.isspace()    → all whitespace?
s.islower()    → all lowercase?
s.isupper()    → all uppercase?
s.istitle()    → title case?
s.isidentifier() → valid Python identifier?
s.isprintable()  → all printable characters?

─────────────────────────────────────
📐 ALIGNMENT & PADDING
─────────────────────────────────────
s.center(width, fillchar)  → center in width
s.ljust(width, fillchar)   → left-justify
s.rjust(width, fillchar)   → right-justify
s.zfill(width)             → pad with zeros on left

─────────────────────────────────────
🎨 ADVANCED F-STRING FORMATTING
─────────────────────────────────────
f"{value:{width}.{precision}type}"

Type codes:
  d — integer decimal      f"{42:05d}"   → "00042"
  f — fixed float          f"{3.14:.2f}" → "3.14"
  e — scientific           f"{12345:e}"  → "1.234500e+04"
  % — percentage           f"{0.85:.1%}" → "85.0%"
  x — hex lowercase        f"{255:x}"    → "ff"
  X — hex uppercase        f"{255:X}"    → "FF"
  b — binary               f"{10:b}"     → "1010"
  o — octal                f"{8:o}"      → "10"
  , — thousands sep        f"{1234567:,}" → "1,234,567"
  _ — underscore sep       f"{1234567:_}" → "1_234_567"
  s — string               f"{'hi':>10}" → "        hi"
  > — right align          f"{42:>10}"   → "        42"
  < — left align           f"{42:<10}"   → "42        "
  ^ — center               f"{42:^10}"   → "    42    "

─────────────────────────────────────
🔄 ENCODE / DECODE
─────────────────────────────────────
s.encode("utf-8")        → bytes object
b"bytes".decode("utf-8") → string

💻 CODE:
# Case
s = "hello world"
print(s.upper())      # HELLO WORLD
print(s.title())      # Hello World
print(s.swapcase())   # HELLO WORLD → hELLO wORLD
print("HELLO".casefold() == "hello".casefold())  # True

# Search
text = "the quick brown fox jumps over the lazy dog"
print(text.count("the"))         # 2
print(text.find("fox"))          # 16
print(text.rfind("the"))         # 31
print(text.startswith("the"))    # True
print(text.endswith(("dog", "cat")))  # True (tuple!)

# Split and join
csv = "Alice,Bob,Carol,Dave"
names = csv.split(",")
print(names)   # ['Alice', 'Bob', 'Carol', 'Dave']

sentence = "  lots   of    spaces  "
words = sentence.split()   # splits on any whitespace
print(words)   # ['lots', 'of', 'spaces']

# Join is the INVERSE of split
print(" | ".join(names))   # Alice | Bob | Carol | Dave
print("\\n".join(names))    # each name on its own line

# Split with limit
path = "/usr/local/bin/python"
parts = path.split("/", 2)
print(parts)   # ['', 'usr', 'local/bin/python']

# Strip
messy = "   \\t  hello world  \\n  "
print(repr(messy.strip()))    # 'hello world'
print(repr(messy.lstrip()))   # 'hello world  \\n  '

url = "***important***"
print(url.strip("*"))   # important

# Replace
sentence = "I like cats. Cats are great."
print(sentence.replace("cats", "dogs").replace("Cats", "Dogs"))

# translate — very fast for multiple replacements
rot13_table = str.maketrans(
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz",
    "NOPQRSTUVWXYZABCDEFGHIJKLMnopqrstuvwxyzabcdefghijklm"
)
print("Hello World".translate(rot13_table))  # Uryyb Jbeyq

# Remove specific chars
remove_table = str.maketrans("", "", "aeiou")  # remove vowels
print("Hello World".translate(remove_table))  # Hll Wrld

# Boolean checks
print("hello123".isalnum())   # True
print("hello".isalpha())      # True
print("   ".isspace())        # True
print("123".isdecimal())      # True
print("²³".isnumeric())       # True  (but not isdecimal!)
print("MyVar".isidentifier()) # True

# Padding and alignment
print("42".zfill(6))           # 000042
print("hello".center(20, "-")) # -------hello--------
print("left".ljust(10, "."))   # left......
print("right".rjust(10, "."))  # .....right

# Advanced f-string formatting
pi = 3.14159265358979
print(f"Pi: {pi:.2f}")          # Pi: 3.14
print(f"Pi: {pi:.10f}")         # Pi: 3.1415926536
print(f"Pi: {pi:e}")            # Pi: 3.141593e+00
print(f"Pct: {0.857:.1%}")      # Pct: 85.7%
print(f"Hex: {255:#010x}")      # Hex: 0x000000ff
print(f"Bin: {42:>10b}")        # Bin:     101010
print(f"Big: {1_234_567:,}")    # Big: 1,234,567
print(f"Big: {1_234_567:_}")    # Big: 1_234_567

# Table alignment with f-strings
headers = ("Name", "Score", "Grade")
rows = [("Alice", 92, "A"), ("Bob", 78, "C"), ("Carol", 95, "A")]
print(f"{headers[0]:<10} {headers[1]:>6} {headers[2]:>6}")
print("-" * 24)
for name, score, grade in rows:
    print(f"{name:<10} {score:>6} {grade:>6}")

# Template strings (safer for user input)
from string import Template
t = Template("Hello, \$name! You scored \$score.")
print(t.substitute(name="Alice", score=92))

📝 KEY POINTS:
✅ All string methods return new strings — strings are immutable
✅ join() is the inverse of split() — and much faster than + concat
✅ startswith/endswith accept a TUPLE of options
✅ casefold() is better than lower() for international comparisons
✅ translate() is fastest for multiple char replacements
✅ f-string format specs: :.2f, :,  :>10, :<10, :^10, :05d, :.1%
❌ str.split() with no arg splits on ANY whitespace and ignores empties
❌ "hello"[0] = "H" — illegal, strings are immutable
❌ find() returns -1 on failure; index() raises ValueError
""",
  quiz: [
    Quiz(question: 'What does "a,b,c".split(",") return?', options: [
      QuizOption(text: "['a', 'b', 'c']", correct: true),
      QuizOption(text: "('a', 'b', 'c')", correct: false),
      QuizOption(text: '"a" "b" "c"', correct: false),
      QuizOption(text: 'A SyntaxError', correct: false),
    ]),
    Quiz(question: 'What format spec produces "85.7%" from 0.857?', options: [
      QuizOption(text: ':.1%', correct: true),
      QuizOption(text: ':.1f%', correct: false),
      QuizOption(text: ':pct', correct: false),
      QuizOption(text: ':.0%', correct: false),
    ]),
    Quiz(question: 'Which method checks if ALL characters are alphabetic?', options: [
      QuizOption(text: 'isalpha()', correct: true),
      QuizOption(text: 'isalnum()', correct: false),
      QuizOption(text: 'istext()', correct: false),
      QuizOption(text: 'alpha()', correct: false),
    ]),
  ],
);
