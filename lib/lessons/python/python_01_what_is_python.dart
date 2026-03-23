import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson01 = Lesson(
  language: 'Python',
  title: 'What is Python?',
  content: """
🎯 METAPHOR:
Python is like a Swiss Army knife compared to other languages.
C++ is a custom-forged samurai sword — incredibly powerful,
razor-sharp, but requires years of mastery and you can easily
cut yourself. Python is the Swiss Army knife — not always the
"best" tool for any single job, but it has a tool for
EVERYTHING, it's safe to use, and you can pull it out and
get to work in seconds.

📖 EXPLANATION:
Python is a high-level, interpreted, general-purpose
programming language created by Guido van Rossum,
first released in 1991.

─────────────────────────────────────
🕰️  A BRIEF HISTORY
─────────────────────────────────────
1989 — Guido van Rossum starts writing Python
1991 — Python 0.9.0 released
2000 — Python 2.0 (list comprehensions added)
2008 — Python 3.0 (modern Python, breaking changes)
2020 — Python 2 officially end-of-life
Today — Consistently ranked #1 most-used language

─────────────────────────────────────
🌍 WHERE IS PYTHON USED?
─────────────────────────────────────
🤖 AI & Machine Learning  → TensorFlow, PyTorch
🌐 Web Development        → Django, Flask, FastAPI
📊 Data Science           → pandas, NumPy, Matplotlib
🔬 Scientific Computing   → SciPy, Jupyter
🛡️  Cybersecurity          → Pen testing, scripting
⚙️  Automation             → Everywhere

─────────────────────────────────────
💡 THE ZEN OF PYTHON (PEP 20)
─────────────────────────────────────
• Beautiful is better than ugly
• Explicit is better than implicit
• Simple is better than complex
• Readability counts
• There should be one obvious way to do it

─────────────────────────────────────
🔄 INTERPRETED vs COMPILED
─────────────────────────────────────
Compiled (C, C++):
  source → compiler → machine code → runs

Interpreted (Python):
  source → Python interpreter → runs line by line

Python actually compiles to BYTECODE (.pyc) first,
then the CPython interpreter runs it. You never see
this step — it's automatic and invisible.

💻 CODE:
# Your first Python program
print("Hello, World!")

# Dynamically typed — no type declarations needed
name = "Ada Lovelace"
age = 206
is_awesome = True

print(name, "would be", age, "years old today")
print("Is she awesome?", is_awesome)

# f-string formatting (Python 3.6+)
x = 10
y = 20
print(f"{x} + {y} = {x + y}")

# The Zen of Python — run this in any Python shell:
import this

📝 KEY POINTS:
✅ Python uses INDENTATION (4 spaces) — not curly braces
✅ No semicolons needed at end of lines
✅ Dynamically typed — no type declarations needed
✅ Interpreted — run your code instantly without compiling
✅ Python 3 is current — never start a project in Python 2
✅ Case-sensitive: name, Name, and NAME are 3 different vars
❌ Never mix tabs and spaces — use 4 spaces (PEP 8 standard)
❌ Python 2: print "hi" — Python 3: print("hi") — not the same

─────────────────────────────────────
📦 Python Implementations
─────────────────────────────────────
CPython    — Official (python.org). Written in C.
PyPy       — JIT-compiled. Up to 10x faster for some tasks.
Jython     — Runs on the JVM.
MicroPython — For microcontrollers (Raspberry Pi Pico).
""",
  quiz: [
    Quiz(question: 'Who created Python?', options: [
      QuizOption(text: 'Guido van Rossum', correct: true),
      QuizOption(text: 'Bjarne Stroustrup', correct: false),
      QuizOption(text: 'James Gosling', correct: false),
      QuizOption(text: 'Linus Torvalds', correct: false),
    ]),
    Quiz(question: 'How does Python enforce code block structure?', options: [
      QuizOption(text: 'Using indentation — whitespace is meaningful', correct: true),
      QuizOption(text: 'Using curly braces like C and Java', correct: false),
      QuizOption(text: 'Using semicolons at the end of blocks', correct: false),
      QuizOption(text: 'Using BEGIN and END keywords', correct: false),
    ]),
    Quiz(question: 'What type of language is Python?', options: [
      QuizOption(text: 'Compiled and statically typed', correct: false),
      QuizOption(text: 'Interpreted and statically typed', correct: false),
      QuizOption(text: 'Interpreted and dynamically typed', correct: true),
      QuizOption(text: 'Compiled and dynamically typed', correct: false),
    ]),
  ],
);
