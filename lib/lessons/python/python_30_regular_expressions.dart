import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson30 = Lesson(
  language: 'Python',
  title: 'Regular Expressions',
  content: """
🎯 METAPHOR:
Regular expressions are like a metal detector at an airport.
The metal detector doesn't care what your bags LOOK like —
it's programmed to find specific patterns (metal objects).
It scans every item passing through and flags matches.
A regex is your pattern detector: you describe the pattern
("a word starting with capital letter, followed by digits"),
and the regex engine scans text and reports every match.
Your text is the airport. The regex is the metal detector.
The matches are the flagged items.

📖 EXPLANATION:
Regular expressions (regex) are patterns that describe
sets of strings. Used for searching, validating, and
transforming text. Python's re module provides regex support.

─────────────────────────────────────
🔤 PATTERN SYNTAX
─────────────────────────────────────
.       any char except newline
^       start of string
\$       end of string
*       0 or more
+       1 or more
?       0 or 1 (optional)
{n}     exactly n times
{n,m}   n to m times
[]      character class: [abc], [a-z], [^abc]
|       or: cat|dog
()      group: capture or organize
\\       escape: \\., \\*, \\(

─────────────────────────────────────
🔡 CHARACTER CLASSES
─────────────────────────────────────
\\d    digit [0-9]
\\D    not digit
\\w    word char [a-zA-Z0-9_]
\\W    not word char
\\s    whitespace [\\t\\n\\r\\f\\v ]
\\S    not whitespace
\\b    word boundary
\\B    not word boundary

─────────────────────────────────────
🏷️  GROUPS AND CAPTURING
─────────────────────────────────────
(pattern)      capturing group → match.group(1)
(?P<name>...)  named group → match.group("name")
(?:pattern)    non-capturing group
(?=pattern)    lookahead (not consumed)
(?!pattern)    negative lookahead
(?<=pattern)   lookbehind
(?<!pattern)   negative lookbehind

─────────────────────────────────────
📦 RE MODULE FUNCTIONS
─────────────────────────────────────
re.match(p, s)    → match at START of string
re.search(p, s)   → match ANYWHERE in string
re.findall(p, s)  → list of all matches
re.finditer(p, s) → iterator of match objects
re.sub(p, r, s)   → replace matches
re.split(p, s)    → split on pattern
re.compile(p)     → pre-compile for reuse (faster!)

FLAGS:
re.IGNORECASE / re.I   → case insensitive
re.MULTILINE / re.M    → ^ and \$ match each line
re.DOTALL / re.S       → . matches newline too
re.VERBOSE / re.X      → allow whitespace/comments

💻 CODE:
import re

# Basic search
text = "The quick brown fox jumps over the lazy dog"
match = re.search(r"\\bfox\\b", text)
if match:
    print(f"Found '{match.group()}' at position {match.start()}")

# findall — get all matches
emails = "Contact alice@example.com or bob@test.org for help"
pattern = r"[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}"
found = re.findall(pattern, emails)
print(found)   # ['alice@example.com', 'bob@test.org']

# Compiled pattern (reuse = faster)
email_re = re.compile(r"[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}")
print(email_re.findall(emails))

# Match vs Search
s = "hello world"
print(re.match(r"world", s))    # None (match = from START)
print(re.search(r"world", s))   # Match! (search = anywhere)

# Groups — capturing
date_pattern = r"(\\d{4})-(\\d{2})-(\\d{2})"
date_str = "Today is 2024-03-15 and tomorrow is 2024-03-16"

for m in re.finditer(date_pattern, date_str):
    print(f"Full: {m.group(0)}, Year: {m.group(1)}, Month: {m.group(2)}, Day: {m.group(3)}")

# Named groups — much clearer!
named = r"(?P<year>\\d{4})-(?P<month>\\d{2})-(?P<day>\\d{2})"
m = re.search(named, "2024-03-15")
if m:
    print(m.group("year"))    # 2024
    print(m.group("month"))   # 03
    print(m.groupdict())      # {'year': '2024', 'month': '03', 'day': '15'}

# Substitution
text = "I like cats and cats like me"
result = re.sub(r"cats", "dogs", text)
print(result)   # I like dogs and dogs like me

result = re.sub(r"cats", "dogs", text, count=1)
print(result)   # I like dogs and cats like me (only first)

# sub with function
def capitalize_match(m):
    return m.group().upper()

text = "hello world foo bar"
result = re.sub(r"\\b\\w{4}\\b", capitalize_match, text)
print(result)   # HELLO world FOOS BAR (4-letter words uppercased)

# Splitting
text = "one,two;three four\\tfive"
parts = re.split(r"[,;\\s]+", text)
print(parts)   # ['one', 'two', 'three', 'four', 'five']

# Flags
text = "Python PYTHON python PYthon"
print(re.findall(r"python", text, re.IGNORECASE))
# ['Python', 'PYTHON', 'python', 'PYthon']

# DOTALL — . matches newlines
multiline = "line 1\\nline 2\\nline 3"
match = re.search(r"line 1.*line 3", multiline, re.DOTALL)
print(match.group() if match else "No match")

# VERBOSE — write readable patterns
phone_pattern = re.compile(r'''
    \\b                 # word boundary
    (\\d{3})            # area code
    [-. ]              # separator
    (\\d{3})            # first 3 digits
    [-. ]              # separator
    (\\d{4})            # last 4 digits
    \\b                 # word boundary
''', re.VERBOSE)

phones = "Call 555-1234 or 555.9876 or 555 4321"
for m in phone_pattern.finditer(phones):
    print(f"Phone: {m.group()}")

# Lookahead and lookbehind
text = "price: \$100, discount: \$20, total: \$80"
# Find numbers preceded by \$
amounts = re.findall(r"(?<=\\\\\\\$)\\d+", text)
print(amounts)   # ['100', '20', '80']

# Negative lookahead — "python" not followed by "3"
txt = "python python3 python2 python"
matches = re.findall(r"python(?!\\d)", txt)
print(matches)   # ['python', 'python']

# Password validation
def validate_password(password):
    checks = {
        "length": len(password) >= 8,
        "uppercase": bool(re.search(r"[A-Z]", password)),
        "lowercase": bool(re.search(r"[a-z]", password)),
        "digit": bool(re.search(r"\\d", password)),
        "special": bool(re.search(r"[!@#\$%^&*(),.?\":{}|<>]", password)),
    }
    for check, passed in checks.items():
        print(f"  {'✅' if passed else '❌'} {check}")
    return all(checks.values())

print("\\nPassword 'Abc123!' valid:", validate_password("Abc123!"))
print("\\nPassword 'weak' valid:", validate_password("weak"))

# URL parsing
url_pattern = re.compile(
    r"(?P<scheme>https?)://"
    r"(?P<domain>[\\w.-]+)"
    r"(?P<path>/[\\w./-]*)?"
    r"(?:\\?(?P<query>[\\w=&]+))?"
)
url = "https://example.com/page/1?id=42&format=json"
m = url_pattern.match(url)
if m:
    print(m.groupdict())

📝 KEY POINTS:
✅ Always use raw strings r"..." for regex patterns — avoids double-escaping
✅ re.compile() for patterns used multiple times — much faster
✅ re.search() matches anywhere; re.match() only at the start
✅ Use named groups (?P<name>...) for readable match access
✅ re.VERBOSE flag lets you write multi-line documented patterns
✅ Lookaheads/lookbehinds match without consuming characters
❌ Don't use regex for simple string operations — use str methods (faster!)
❌ Beware catastrophic backtracking with complex nested patterns
❌ Regex is not suitable for parsing HTML/XML — use BeautifulSoup/lxml
""",
  quiz: [
    Quiz(question: 'What is the difference between re.match() and re.search()?', options: [
      QuizOption(text: 'match() is faster; search() is more accurate', correct: false),
      QuizOption(text: 'match() only checks the START of a string; search() checks anywhere', correct: true),
      QuizOption(text: 'match() returns a list; search() returns one match', correct: false),
      QuizOption(text: 'They are identical — just different names', correct: false),
    ]),
    Quiz(question: 'Why should you use raw strings r"..." for regex patterns?', options: [
      QuizOption(text: 'Raw strings are faster for the regex engine', correct: false),
      QuizOption(text: 'Raw strings prevent Python from processing backslashes, avoiding double-escaping', correct: true),
      QuizOption(text: 'Regular strings don\'t support special regex characters', correct: false),
      QuizOption(text: 'Raw strings enable the VERBOSE flag automatically', correct: false),
    ]),
    Quiz(question: 'What does the pattern r"\\d{3}-\\d{4}" match?', options: [
      QuizOption(text: '3 digits, a hyphen, then 4 digits', correct: true),
      QuizOption(text: 'Any 3-4 digit number with a hyphen', correct: false),
      QuizOption(text: 'A digit repeated exactly 3 to 4 times', correct: false),
      QuizOption(text: 'A backslash followed by digits', correct: false),
    ]),
  ],
);
