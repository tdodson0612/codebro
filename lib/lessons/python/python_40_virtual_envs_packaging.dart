import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson40 = Lesson(
  language: 'Python',
  title: 'Virtual Environments & Packaging',
  content: """
🎯 METAPHOR:
A virtual environment is like a spaceship airlock.
Outside (your system Python) is the vast shared universe.
Inside each project is its own controlled atmosphere.
When you suit up (activate the venv), you're in the
project's private environment — its own Python version,
its own packages, its own oxygen mix. You can have a
spaceship that breathes 100% oxygen and another that
breathes argon — they don't interfere. Without airlocks
(venvs), every project shares the same air, and one
project's toxic gas can kill another project.

📖 EXPLANATION:
Virtual environments isolate project dependencies.
Each project gets its own Python and packages,
preventing conflicts between projects.

─────────────────────────────────────
🏗️  VIRTUAL ENVIRONMENT TOOLS
─────────────────────────────────────
venv       → built-in (Python 3.3+), the standard
virtualenv → third-party, older, more features
conda      → Anaconda's env manager (data science)
poetry     → modern dependency management + packaging
pipenv     → Pipfile-based workflow

─────────────────────────────────────
⚙️  VENV WORKFLOW
─────────────────────────────────────
# Create
python3 -m venv myenv

# Activate
source myenv/bin/activate    (Mac/Linux)
myenv\\Scripts\\activate       (Windows)

# Use — you're now in the venv
pip install requests
python my_script.py

# Deactivate
deactivate

# Delete — just delete the folder!
rm -rf myenv

─────────────────────────────────────
📦 PIP — PACKAGE MANAGEMENT
─────────────────────────────────────
pip install package           → latest version
pip install package==1.2.3    → exact version
pip install "package>=1.2,<2" → version range
pip install -r requirements.txt → install from file
pip list                      → show installed
pip freeze                    → exact versions
pip freeze > requirements.txt → save deps
pip show package              → package info
pip uninstall package         → remove
pip install --upgrade package → upgrade

─────────────────────────────────────
📄 REQUIREMENTS.TXT
─────────────────────────────────────
Simple list of packages:
  requests==2.31.0
  numpy>=1.24.0
  pandas
  flask[async]   ← with extras

─────────────────────────────────────
📦 PYPROJECT.TOML (Modern Standard)
─────────────────────────────────────
[build-system]
requires = ["setuptools>=61"]
build-backend = "setuptools.backends.legacy:build"

[project]
name = "mypackage"
version = "0.1.0"
dependencies = ["requests>=2.0", "click>=8.0"]

─────────────────────────────────────
🚀 POETRY — MODERN WORKFLOW
─────────────────────────────────────
poetry new myproject    → create project
poetry add requests     → add dependency
poetry install          → install all deps
poetry run python app.py → run in env
poetry build            → build package
poetry publish          → publish to PyPI

─────────────────────────────────────
📁 PROJECT STRUCTURE
─────────────────────────────────────
my_project/
├── src/
│   └── mypackage/
│       ├── __init__.py
│       ├── core.py
│       └── utils.py
├── tests/
│   ├── __init__.py
│   └── test_core.py
├── pyproject.toml
├── README.md
├── .gitignore
└── requirements.txt

💻 CODE:
# ── VIRTUAL ENVIRONMENT WORKFLOW ───

# Terminal commands (run in shell, not Python):
# python3 -m venv .venv
# source .venv/bin/activate
# pip install requests pandas flask
# pip freeze > requirements.txt
# deactivate

# ── PACKAGE STRUCTURE ─────────────

# mypackage/__init__.py
# Controls what's exported when: import mypackage

# __init__.py:
"""
MyPackage — A sample Python package.
"""
# from .core import MainClass, utility_func
# from .config import Config
# __version__ = "1.0.0"
# __all__ = ["MainClass", "utility_func", "Config"]

# ── PYPROJECT.TOML EXAMPLE ─────────
PYPROJECT_EXAMPLE = """
[build-system]
requires = ["setuptools>=61.0", "wheel"]
build-backend = "setuptools.backends.legacy:build"

[project]
name = "my-awesome-package"
version = "1.0.0"
authors = [{name="Alice Dev", email="alice@example.com"}]
description = "A fantastic Python package"
readme = "README.md"
license = {file = "LICENSE"}
requires-python = ">=3.9"
dependencies = [
    "requests>=2.28.0",
    "click>=8.0",
    "pydantic>=2.0",
]

[project.optional-dependencies]
dev = ["pytest>=7.0", "black", "mypy", "ruff"]
docs = ["sphinx", "sphinx-rtd-theme"]

[project.scripts]
my-tool = "mypackage.cli:main"   # CLI entry point

[tool.pytest.ini_options]
testpaths = ["tests"]
addopts = "-v --tb=short"

[tool.mypy]
python_version = "3.11"
strict = true

[tool.ruff]
line-length = 88
select = ["E", "F", "I"]
"""

# ── REQUIREMENTS.TXT ──────────────
REQUIREMENTS_EXAMPLE = """
# Core dependencies
requests==2.31.0
pydantic>=2.0,<3.0
click>=8.0

# Optional feature flags
flask[async]==3.0.0
sqlalchemy[asyncio]>=2.0

# Dev dependencies (requirements-dev.txt)
pytest>=7.4
pytest-cov>=4.0
black>=23.0
mypy>=1.5
ruff>=0.1.0
"""

# ── BUILDING AND DISTRIBUTING ──────

# Build your package:
# python -m build            → creates dist/ with .whl and .tar.gz

# Upload to PyPI:
# python -m twine upload dist/*

# Upload to Test PyPI first:
# python -m twine upload --repository testpypi dist/*

# ── IMPORTLIB — DYNAMIC IMPORTS ────
import importlib

# Dynamic import by string name
module_name = "math"
math_module = importlib.import_module(module_name)
print(math_module.sqrt(16))

# Reload a module (useful in development)
import math
importlib.reload(math)

# Check if module is available
def is_available(module_name: str) -> bool:
    try:
        importlib.import_module(module_name)
        return True
    except ImportError:
        return False

print(is_available("numpy"))   # True or False
print(is_available("pandas"))  # True or False

# ── __init__.py PATTERNS ──────────

# Lazy imports to speed up import time:
def get_numpy():
    import numpy as np
    return np

# Version info
import sys

def check_python_version(min_version=(3, 9)):
    if sys.version_info < min_version:
        raise RuntimeError(
            f"Python {min_version[0]}.{min_version[1]}+ required, "
            f"got {sys.version_info.major}.{sys.version_info.minor}"
        )

check_python_version()

# Package metadata
def get_package_info(package_name: str) -> dict:
    from importlib.metadata import metadata, version, packages_distributions
    try:
        meta = metadata(package_name)
        return {
            "name": meta["Name"],
            "version": version(package_name),
            "summary": meta["Summary"],
            "author": meta["Author"],
        }
    except Exception:
        return {}

# ── .gitignore for Python ──────────
GITIGNORE = """
# Virtual environments
.venv/
venv/
env/
.env

# Python cache
__pycache__/
*.py[cod]
*.pyo
.pytest_cache/
.mypy_cache/
.ruff_cache/

# Distribution
dist/
build/
*.egg-info/
*.egg

# IDE
.vscode/
.idea/
*.swp

# Environment variables
.env
.env.local

# Coverage
.coverage
htmlcov/

# Jupyter notebooks
.ipynb_checkpoints/
"""

print("📦 Python packaging workflow ready!")
print("1. Create venv: python3 -m venv .venv")
print("2. Activate: source .venv/bin/activate")
print("3. Install deps: pip install -r requirements.txt")
print("4. Freeze: pip freeze > requirements.txt")

📝 KEY POINTS:
✅ Always use a virtual environment for every project
✅ Add .venv/ and __pycache__/ to .gitignore
✅ pip freeze > requirements.txt captures exact versions for reproducibility
✅ pyproject.toml is the modern standard — replaces setup.py and setup.cfg
✅ poetry is the most ergonomic modern workflow for new projects
✅ src/ layout prevents accidentally importing from your source tree
❌ Never pip install globally (without a venv) for project work
❌ Don't commit .venv/ to git — commit requirements.txt or pyproject.toml
❌ Pinning all versions too tightly causes "dependency hell" — use ranges
""",
  quiz: [
    Quiz(question: 'Why should each Python project have its own virtual environment?', options: [
      QuizOption(text: 'Virtual environments make Python run faster', correct: false),
      QuizOption(text: 'To isolate project dependencies and prevent version conflicts between projects', correct: true),
      QuizOption(text: 'It is required by Python 3.9+', correct: false),
      QuizOption(text: 'To enable pip to install packages', correct: false),
    ]),
    Quiz(question: 'What does "pip freeze > requirements.txt" do?', options: [
      QuizOption(text: 'Installs all packages listed in requirements.txt', correct: false),
      QuizOption(text: 'Saves the exact version of every installed package to requirements.txt', correct: true),
      QuizOption(text: 'Freezes the virtual environment to prevent further changes', correct: false),
      QuizOption(text: 'Removes unused packages', correct: false),
    ]),
    Quiz(question: 'What file is the modern standard for Python project configuration?', options: [
      QuizOption(text: 'setup.py', correct: false),
      QuizOption(text: 'setup.cfg', correct: false),
      QuizOption(text: 'pyproject.toml', correct: true),
      QuizOption(text: 'Pipfile', correct: false),
    ]),
  ],
);
