import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson02 = Lesson(
  language: 'Python',
  title: 'Installing Python & Running Code',
  content: """
🎯 METAPHOR:
Installing Python is like installing a game engine before
playing a game. The game (your code) needs the engine
(Python interpreter) to run. Without the engine, your
.py file is just text — the same way a movie file is
just data without a video player. The interpreter IS
the player that brings your code to life.

📖 EXPLANATION:
Python code lives in .py files. To run them, you need
the Python interpreter installed on your machine.

─────────────────────────────────────
💾 INSTALLATION
─────────────────────────────────────
🪟 Windows:
  1. Go to python.org/downloads
  2. Download latest Python 3.x
  3. ✅ CHECK "Add Python to PATH" during install
  4. Verify: open terminal → python --version

🍎 macOS:
  Python 2 comes pre-installed (do NOT use it)
  Install Python 3 via:
    brew install python   (Homebrew — recommended)
  Or download from python.org

🐧 Linux:
  sudo apt install python3 python3-pip   (Debian/Ubuntu)
  sudo dnf install python3               (Fedora)

─────────────────────────────────────
▶️  THREE WAYS TO RUN PYTHON
─────────────────────────────────────

1️⃣  INTERACTIVE MODE (REPL)
   Type python or python3 in terminal
   Get a >>> prompt — type code, see results instantly
   Perfect for experiments and quick checks
   Exit with: exit() or Ctrl+D

2️⃣  SCRIPT MODE
   Write code in a .py file
   Run with: python3 myfile.py
   This is how real programs are run

3️⃣  IDE / EDITOR
   VS Code        — most popular, free, great extensions
   PyCharm        — powerful Python-specific IDE
   Jupyter Notebook — for data science / interactive work
   Thonny         — great for beginners

─────────────────────────────────────
🔢 CHECKING YOUR VERSION
─────────────────────────────────────
python --version     →  might show Python 2.x (old!)
python3 --version    →  shows Python 3.x (use this)

On many systems, python3 is the correct command.
Always verify before starting a project.

─────────────────────────────────────
📦 PIP — Python Package Manager
─────────────────────────────────────
pip is like an app store for Python libraries.

pip install requests      # install a package
pip install numpy pandas  # install multiple
pip uninstall requests    # remove a package
pip list                  # see installed packages
pip freeze > requirements.txt  # save project deps

─────────────────────────────────────
🏝️  VIRTUAL ENVIRONMENTS
─────────────────────────────────────
A virtual environment is like a separate sandbox for
each project — its own Python, its own packages.
Without it, all projects share one Python install
and packages conflict.

python3 -m venv myenv        # create environment
source myenv/bin/activate    # activate (Mac/Linux)
myenv\\Scripts\\activate       # activate (Windows)
deactivate                   # exit environment

💻 CODE:
# Save this as hello.py and run: python3 hello.py

print("Python is running!")
print(f"Your Python version works great")

# Check Python version from inside code
import sys
print("Version:", sys.version)
print("Version info:", sys.version_info)

# Check if version is 3.8+
if sys.version_info >= (3, 8):
    print("✅ Python 3.8+ — all modern features available")
else:
    print("⚠️  Consider upgrading Python")

# Where is Python installed?
import sys
print("Executable:", sys.executable)

📝 KEY POINTS:
✅ Always use Python 3 — Python 2 is dead
✅ Check "Add to PATH" during Windows installation
✅ Use virtual environments for every project
✅ pip is your package manager — learn it early
✅ python3 command on Mac/Linux, python on Windows (usually)
❌ Don't install packages globally — use a venv
❌ Don't use sudo pip install — it breaks system Python
❌ Don't mix python and python3 commands in the same project
""",
  quiz: [
    Quiz(question: 'What is a Python virtual environment used for?', options: [
      QuizOption(text: 'To isolate project dependencies from other projects', correct: true),
      QuizOption(text: 'To make Python run faster on slow computers', correct: false),
      QuizOption(text: 'To enable Python 2 features in Python 3', correct: false),
      QuizOption(text: 'To compile Python code to machine code', correct: false),
    ]),
    Quiz(question: 'What command installs a Python package?', options: [
      QuizOption(text: 'python install packagename', correct: false),
      QuizOption(text: 'pip install packagename', correct: true),
      QuizOption(text: 'apt install packagename', correct: false),
      QuizOption(text: 'import packagename', correct: false),
    ]),
    Quiz(question: 'What is the Python REPL?', options: [
      QuizOption(text: 'A code editor built into Python', correct: false),
      QuizOption(text: 'An interactive mode where code runs line by line instantly', correct: true),
      QuizOption(text: 'A tool that compiles .py files to executables', correct: false),
      QuizOption(text: 'A package manager for Python', correct: false),
    ]),
  ],
);
