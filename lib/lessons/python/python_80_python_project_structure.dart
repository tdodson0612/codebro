import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson80 = Lesson(
  language: 'Python',
  title: 'Python Project Structure & Best Project Setup',
  content: """
🎯 METAPHOR:
A well-structured Python project is like a professional kitchen.
Everything has a designated place: ingredients (source code) in
the pantry (src/), recipes (tests) in the recipe binder (tests/),
prep tools (scripts) on the counter (scripts/), and the
restaurant rulebook (pyproject.toml) on the manager's desk.
A new chef (developer) walks in and immediately knows where
everything is. No hunting for the sugar. No mystery drawers.
The structure communicates the intent before a single line
is read.

📖 EXPLANATION:
Good project structure makes code maintainable, testable,
and distributable. This lesson covers the modern Python
project layout, tool configuration, CI/CD patterns, and
development workflow.

─────────────────────────────────────
📁 RECOMMENDED PROJECT STRUCTURE
─────────────────────────────────────
my_project/
├── src/
│   └── my_package/
│       ├── __init__.py
│       ├── core.py
│       ├── models.py
│       └── utils.py
├── tests/
│   ├── __init__.py
│   ├── test_core.py
│   └── conftest.py        ← pytest fixtures
├── docs/
│   └── index.md
├── scripts/
│   └── run_dev.sh
├── .github/
│   └── workflows/
│       └── ci.yml         ← GitHub Actions
├── pyproject.toml         ← THE config file
├── README.md
├── .gitignore
├── .env.example
└── Makefile               ← development shortcuts

─────────────────────────────────────
📦 PYPROJECT.TOML — EVERYTHING IN ONE
─────────────────────────────────────
Replaces: setup.py, setup.cfg, requirements.txt,
          pytest.ini, mypy.ini, .flake8

One file configures:
  • Package metadata and dependencies
  • Build system (setuptools, poetry, hatch)
  • Tool config: pytest, mypy, ruff, black, coverage

─────────────────────────────────────
🔄 DEVELOPMENT WORKFLOW
─────────────────────────────────────
1. Clone repo
2. python -m venv .venv && source .venv/bin/activate
3. pip install -e ".[dev]"   (editable + dev deps)
4. pre-commit install        (auto-run checks on commit)
5. Write code + tests
6. make test                 (or pytest)
7. make lint                 (or ruff check .)
8. git commit                (pre-commit runs hooks)

─────────────────────────────────────
🤖 CI/CD WITH GITHUB ACTIONS
─────────────────────────────────────
On every PR:
  1. Set up Python matrix (3.10, 3.11, 3.12)
  2. Install dependencies
  3. Run ruff (lint)
  4. Run mypy (type check)
  5. Run pytest with coverage
  6. Fail if coverage < threshold

💻 CODE:
# ── COMPLETE PYPROJECT.TOML ────────

PYPROJECT_TOML = '''
[build-system]
requires = ["setuptools>=68", "wheel"]
build-backend = "setuptools.backends.legacy:build"

[project]
name = "my-awesome-package"
version = "1.0.0"
description = "A fantastic Python package"
readme = "README.md"
license = {file = "LICENSE"}
authors = [{name = "Alice Dev", email = "alice@example.com"}]
maintainers = [{name = "Alice Dev", email = "alice@example.com"}]
keywords = ["python", "awesome", "package"]
classifiers = [
    "Development Status :: 4 - Beta",
    "Intended Audience :: Developers",
    "License :: OSI Approved :: MIT License",
    "Programming Language :: Python :: 3",
    "Programming Language :: Python :: 3.10",
    "Programming Language :: Python :: 3.11",
    "Programming Language :: Python :: 3.12",
    "Topic :: Software Development :: Libraries",
]
requires-python = ">=3.10"
dependencies = [
    "requests>=2.28.0",
    "pydantic>=2.0",
    "click>=8.0",
]

[project.optional-dependencies]
dev = [
    "pytest>=7.4",
    "pytest-cov>=4.0",
    "pytest-asyncio>=0.21",
    "httpx>=0.24",         # for testing HTTP
    "black>=23.0",
    "ruff>=0.1.0",
    "mypy>=1.5",
    "pre-commit>=3.0",
]
docs = [
    "sphinx>=7.0",
    "sphinx-rtd-theme",
    "myst-parser",
]

[project.urls]
Homepage = "https://github.com/alice/my-awesome-package"
Documentation = "https://my-awesome-package.readthedocs.io"
Repository = "https://github.com/alice/my-awesome-package"
"Bug Tracker" = "https://github.com/alice/my-awesome-package/issues"
Changelog = "https://github.com/alice/my-awesome-package/blob/main/CHANGELOG.md"

[project.scripts]
my-tool = "my_package.cli:main"
my-server = "my_package.server:serve"

# ── TOOL CONFIGURATION ─────────────

[tool.setuptools.packages.find]
where = ["src"]

[tool.pytest.ini_options]
testpaths = ["tests"]
addopts = [
    "--tb=short",
    "--strict-markers",
    "-ra",
    "--cov=src",
    "--cov-report=term-missing",
    "--cov-report=html",
    "--cov-fail-under=80",
]
asyncio_mode = "auto"
markers = [
    "slow: marks tests as slow (deselect with -m 'not slow')",
    "integration: marks integration tests",
    "unit: marks unit tests",
]

[tool.coverage.run]
source = ["src"]
omit = ["*/tests/*", "*/conftest.py"]

[tool.coverage.report]
exclude_lines = [
    "pragma: no cover",
    "if TYPE_CHECKING:",
    "raise NotImplementedError",
    "@abstractmethod",
]

[tool.mypy]
python_version = "3.11"
strict = true
warn_return_any = true
warn_unused_configs = true
show_error_codes = true
files = ["src/", "tests/"]

[[tool.mypy.overrides]]
module = "tests.*"
disallow_untyped_defs = false

[tool.ruff]
target-version = "py310"
line-length = 88
select = [
    "E",   # pycodestyle errors
    "W",   # pycodestyle warnings
    "F",   # pyflakes
    "I",   # isort
    "B",   # bugbear
    "C4",  # comprehensions
    "UP",  # pyupgrade
    "N",   # naming
    "SIM", # simplify
]
ignore = ["E501", "B008"]

[tool.ruff.isort]
known-first-party = ["my_package"]

[tool.black]
line-length = 88
target-version = ["py310", "py311"]
'''

# ── .GITHUB/WORKFLOWS/CI.YML ──────

CI_YAML = '''
name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        python-version: ["3.10", "3.11", "3.12"]
      fail-fast: false

    steps:
      - uses: actions/checkout@v4

      - name: Set up Python\${{ matrix.python-version }}
        uses: actions/setup-python@v5
        with:
          python-version: \${{ matrix.python-version }}
          cache: pip

      - name: Install dependencies
        run: |
          pip install -e ".[dev]"

      - name: Lint with ruff
        run: ruff check .

      - name: Check formatting with black
        run: black --check .

      - name: Type check with mypy
        run: mypy .

      - name: Test with pytest
        run: pytest

      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          token: \${{ secrets.CODECOV_TOKEN }}

  publish:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main' && github.event_name == 'push'
    steps:
      - uses: actions/checkout@v4
      - name: Build and publish
        run: |
          pip install build twine
          python -m build
          twine upload dist/*
        env:
          TWINE_USERNAME: __token__
          TWINE_PASSWORD: \${{ secrets.PYPI_TOKEN }}
'''

# ── PRE-COMMIT CONFIG ─────────────

PRE_COMMIT_CONFIG = '''
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.5.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-json
      - id: check-toml
      - id: check-added-large-files
        args: ['--maxkb=1000']
      - id: debug-statements
      - id: no-commit-to-branch
        args: ['--branch', 'main']

  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.1.0
    hooks:
      - id: ruff
        args: [--fix]
      - id: ruff-format

  - repo: https://github.com/pre-commit/mirrors-mypy
    rev: v1.5.0
    hooks:
      - id: mypy
        additional_dependencies: ['pydantic>=2.0']
'''

# ── MAKEFILE ──────────────────────

MAKEFILE = '''
.PHONY: install test lint format type-check clean build publish

install:
\tpip install -e ".[dev]"
\tpre-commit install

test:
\tpytest

test-fast:
\tpytest -m "not slow" -x

lint:
\truff check .

format:
\truff format .

type-check:
\tmypy .

check: lint type-check test

clean:
\trm -rf .pytest_cache .mypy_cache .ruff_cache htmlcov dist build *.egg-info
\tfind . -name "*.pyc" -delete
\tfind . -name "__pycache__" -type d -exec rm -rf {} +

build:
\tpython -m build

publish: build
\ttwine upload dist/*

docs:
\tsphinx-build -b html docs/ docs/_build/html
'''

# ── CONFTEST.PY (pytest fixtures) ─

CONFTEST_PY = '''
# tests/conftest.py
import pytest
from pathlib import Path

@pytest.fixture(scope="session")
def test_data_dir() -> Path:
    return Path(__file__).parent / "data"

@pytest.fixture
def sample_users() -> list[dict]:
    return [
        {"id": 1, "name": "Alice", "email": "alice@ex.com"},
        {"id": 2, "name": "Bob",   "email": "bob@ex.com"},
    ]

@pytest.fixture
def db_connection():
    # Setup
    conn = create_test_db()
    yield conn
    # Teardown
    conn.close()

@pytest.fixture(autouse=True)
def reset_state():
    # Runs before/after every test automatically
    yield
    # cleanup after each test

# Parametrize with indirect fixtures
@pytest.fixture(params=["sqlite", "postgresql"])
def database(request):
    if request.param == "sqlite":
        return setup_sqlite()
    return setup_postgresql()
'''

# ── SRC LAYOUT BENEFITS ───────────

SRC_LAYOUT_BENEFITS = '''
Why src/ layout?
  1. Prevents accidental imports from the working directory
     instead of the installed package
  2. Forces you to install the package properly (pip install -e .)
  3. Clear separation between package code and project files
  4. mypy and pytest work more predictably

Without src/:
  /my_package/__init__.py
  /my_package/core.py
  → 'import my_package' might import from local dir, not installed!

With src/:
  /src/my_package/__init__.py
  /src/my_package/core.py
  → 'import my_package' MUST come from installed package
'''

print("Project structure best practices ready!")
print('''
Quick start:
  mkdir my_project && cd my_project
  python -m venv .venv
  source .venv/bin/activate
  mkdir -p src/my_package tests
  touch src/my_package/__init__.py
  touch pyproject.toml README.md .gitignore
  pip install -e ".[dev]"
  pre-commit install
''')

📝 KEY POINTS:
✅ Use src/ layout — prevents local import conflicts
✅ pyproject.toml is the single source of truth for all tool configuration
✅ pre-commit hooks catch issues before they're committed
✅ CI runs lint + type check + tests on every PR — never skip this
✅ pip install -e ".[dev]" installs package + dev dependencies in editable mode
✅ conftest.py for shared pytest fixtures — don't repeat test setup
✅ Makefile or just provides simple shortcuts: make test, make lint
❌ Don't skip the src/ layout for anything beyond a single script
❌ Don't use separate config files (pytest.ini, .mypy.ini) — put it all in pyproject.toml
❌ Don't commit without running tests and lint — use pre-commit hooks
""",
  quiz: [
    Quiz(question: 'What is the main benefit of the src/ layout for Python projects?', options: [
      QuizOption(text: 'It makes imports faster', correct: false),
      QuizOption(text: 'It prevents accidentally importing from the local directory instead of the installed package', correct: true),
      QuizOption(text: 'It is required by pip for packaging', correct: false),
      QuizOption(text: 'It enables better tree-shaking', correct: false),
    ]),
    Quiz(question: 'What does pip install -e ".[dev]" do?', options: [
      QuizOption(text: 'Installs only the dev dependencies', correct: false),
      QuizOption(text: 'Installs the package in editable mode plus the [dev] optional dependencies', correct: true),
      QuizOption(text: 'Encrypts the package files for distribution', correct: false),
      QuizOption(text: 'Builds the package for production', correct: false),
    ]),
    Quiz(question: 'What is the purpose of tests/conftest.py?', options: [
      QuizOption(text: 'It configures which tests to skip', correct: false),
      QuizOption(text: 'It provides shared pytest fixtures available to all test files', correct: true),
      QuizOption(text: 'It configures pytest settings like addopts', correct: false),
      QuizOption(text: 'It is the entry point for running all tests', correct: false),
    ]),
  ],
);