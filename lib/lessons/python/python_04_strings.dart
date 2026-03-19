import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson04 = Lesson(
  language: 'Python',
  title: 'Strings',
  content: '''
🎯 METAPHOR:
A string is like a bead necklace.
Each bead is one character. The necklace (string) is
immutable — you can't change one bead in place; to
"modify" the necklace, you have to make a whole new one.
But you CAN look at any bead by its position (index),
cut out a section (slice), or count the beads (len).
Python gives you incredible tools to work with necklaces.

📖 EXPLANATION:
Strings are sequences of Unicode characters, enclosed in
single quotes, double quotes, or triple quotes.
They are IMMUTABLE — once created, individual characters
cannot be changed. "Modifications" always produce new strings.

─────────────────────────────────────
📝 CREATING STRINGS
─────────────────────────────────────
single    = 'Hello'
double    = "World"
triple    = """Multi
line string"""
raw       = r"C:\\Users\\name"   # raw: backslashes literal
bytes_str = b"bytes data"        # bytes, not str

Use double quotes when string contains apostrophes:
  "it's a beautiful day"
Use single quotes when string contains double quotes:
  'She said "hello"'

─────────────────────────────────────
🔢 INDEXING — Accessing Characters
─────────────────────────────────────
Like necklace beads numbered from left and right:

  H  e  l  l  o
  0  1  2  3  4    ← positive indices
 -5 -4 -3 -2 -1   ← negative indices (from end)

s[0]  → 'H'   (first char)
s[-1] → 'o'   (last char)
s[4]  → 'o'
s[10] → IndexError! (out of range)

─────────────────────────────────────
✂️  SLICING — Extracting Substrings
─────────────────────────────────────
Like cutting a section out of the necklace.

s[start:stop:step]
  start — index to begin (inclusive)
  stop  — index to end (EXCLUSIVE)
  step  — how many to skip (default 1)

s[1:4]   → 'ell'   (chars at 1, 2, 3)
s[::2]   → 'Hlo'   (every 2nd char)
s[::-1]  → 'olleH' (reversed!)
s[:]     → 'Hello' (full copy)

─────────────────────────────────────
🧵 STRING CONCATENATION & REPETITION
─────────────────────────────────────
"Hello" + " " + "World"  → "Hello World"
"ha" * 3                 → "hahaha"

⚠️  Don't + concatenate in a loop — use join() instead!
It's slow because each + creates a new string object.

─────────────────────────────────────
📐 F-STRINGS (Python 3.6+) — The Best Way
─────────────────────────────────────
Like a template with live slots:

name = "Alice"
age = 30
f"My name is {name} and I am {age} years old"

F-strings can hold any expression:
f"2 + 2 = {2 + 2}"
f"Upper: {name.upper()}"
f"Pi: {3.14159:.2f}"   # format specifier

─────────────────────────────────────
🔧 STRING ESCAPE SEQUENCES
─────────────────────────────────────
\\n    newline
\\t    tab
\\\\    literal backslash
\\'    single quote
\\"    double quote
\\r    carriage return
\\0    null character
\\uXXXX  Unicode character

─────────────────────────────────────
🔍 STRING METHODS OVERVIEW
─────────────────────────────────────
Case:       upper(), lower(), title(), capitalize(), swapcase()
Search:     find(), index(), count(), startswith(), endswith()
Modify:     strip(), lstrip(), rstrip(), replace(), split(), join()
Check:      isalpha(), isdigit(), isalnum(), isspace(), islower()
Format:     center(), ljust(), rjust(), zfill()
Encode:     encode(), decode()

💻 CODE:
# Creating strings
s = "Hello, Python!"
print(len(s))       # 14
print(s[0])         # H
print(s[-1])        # !
print(s[7:13])      # Python
print(s[:5])        # Hello
print(s[::-1])      # !nohtyP ,olleH  (reversed)

# f-strings
name = "Alice"
score = 95.678
print(f"Player: {name}")
print(f"Score: {score:.1f}")   # 95.7 (1 decimal)
print(f"Hex: {255:#x}")        # 0xff
print(f"Width: {name:>10}")    # right-align in 10 chars

# String methods
text = "  hello world  "
print(text.strip())          # "hello world"
print(text.upper())          # "  HELLO WORLD  "
print(text.title())          # "  Hello World  "
print(text.replace("l","L")) # "  heLLo worLd  "

words = "one,two,three"
parts = words.split(",")     # ['one', 'two', 'three']
joined = " | ".join(parts)   # 'one | two | three'
print(parts)
print(joined)

# Search
sentence = "The quick brown fox"
print(sentence.find("quick"))      # 4 (index)
print(sentence.find("cat"))        # -1 (not found)
print(sentence.count("o"))         # 2
print(sentence.startswith("The"))  # True
print(sentence.endswith("fox"))    # True

# Check methods
print("hello123".isalnum())   # True
print("hello".isalpha())      # True
print("12345".isdigit())      # True
print("   ".isspace())        # True

# Efficient string building
parts = ["one", "two", "three", "four"]
result = ", ".join(parts)     # fast!
print(result)                  # one, two, three, four

# String formatting alternatives
# Old style (still works):
print("Hello %s, you are %d" % ("Bob", 25))
# .format() style:
print("Hello {}, you are {}".format("Bob", 25))
# f-string (best, Python 3.6+):
print(f"Hello {'Bob'}, you are {25}")

# Multi-line string
poem = """
Roses are red,
Violets are blue,
Python is awesome,
And so are you!
"""
print(poem.strip())

# Raw strings — backslashes are literal
path = r"C:\\Users\\Alice\\Documents"
pattern = r"\\d+\\.\\d+"   # regex pattern

# String contains check
print("Python" in "I love Python!")  # True
print("Java" not in "I love Python!") # True

📝 KEY POINTS:
✅ Strings are IMMUTABLE — methods return new strings, never modify in place
✅ Use f-strings for formatting (Python 3.6+) — clearest and fastest
✅ Negative indices count from the end: s[-1] is last character
✅ Slicing never raises IndexError — it just clips to valid range
✅ s[::-1] reverses a string
✅ Use join() to build strings from lists — faster than + in a loop
✅ Raw strings r"..." treat backslashes as literal characters
❌ "hello"[0] = "H" is illegal — strings are immutable
❌ Don't use + concatenation in loops — use "".join(list) instead
❌ find() returns -1 if not found; index() raises ValueError
''',
  quiz: [
    Quiz(question: 'What does s[::-1] do to a string s?', options: [
      QuizOption(text: 'Returns the string reversed', correct: true),
      QuizOption(text: 'Returns every other character', correct: false),
      QuizOption(text: 'Returns the last character only', correct: false),
      QuizOption(text: 'Raises a SyntaxError', correct: false),
    ]),
    Quiz(question: 'What is the output of "hello".upper().replace("L", "x")?', options: [
      QuizOption(text: 'HExxO', correct: true),
      QuizOption(text: 'hexxo', correct: false),
      QuizOption(text: 'HELLO', correct: false),
      QuizOption(text: 'HExLO', correct: false),
    ]),
    Quiz(question: 'Which method is fastest for combining a list of strings?', options: [
      QuizOption(text: 'Using + in a for loop', correct: false),
      QuizOption(text: '",".join(list)', correct: true),
      QuizOption(text: 'str.concat(list)', correct: false),
      QuizOption(text: 'append() then print()', correct: false),
    ]),
  ],
);
