import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson59 = Lesson(
  language: 'Python',
  title: 'The Python Ecosystem & Popular Libraries',
  content: """
🎯 METAPHOR:
The Python ecosystem is like a massive hardware store
where the community has stocked every tool imaginable.
The standard library is the store's permanent inventory.
PyPI (Python Package Index) is the massive warehouse
annex with 500,000+ community-built tools — some
professional-grade, some experimental, some abandoned.
Knowing what's in the warehouse means you never build a
screwdriver when someone already perfected it, packaged
it, tested it, and made it free. The skill is knowing
WHICH tool to grab, not building every tool yourself.

📖 EXPLANATION:
The Python ecosystem has mature, battle-tested libraries
for virtually every domain. This lesson maps the landscape
so you know what exists before you reinvent it.

─────────────────────────────────────
🌐 WEB DEVELOPMENT
─────────────────────────────────────
Flask, FastAPI, Django     → web frameworks (covered!)
aiohttp                    → async HTTP client/server
httpx                      → modern requests (async support)
requests                   → HTTP client (sync)
Starlette                  → ASGI toolkit (FastAPI base)
Tornado                    → async web framework
Sanic                      → async, Flask-like
Pydantic                   → data validation & settings
Jinja2                     → templating engine
Werkzeug                   → WSGI utilities (Flask base)
gunicorn, uvicorn          → production WSGI/ASGI servers

─────────────────────────────────────
🗄️  DATABASES & ORM
─────────────────────────────────────
SQLAlchemy                 → the Python ORM standard
Alembic                    → database migrations
Tortoise ORM               → async ORM
Peewee                     → lightweight ORM
Databases                  → async database queries
psycopg2, asyncpg          → PostgreSQL drivers
pymysql, aiomysql          → MySQL drivers
Motor                      → async MongoDB
redis-py                   → Redis client
SQLModel                   → SQLAlchemy + Pydantic

─────────────────────────────────────
📊 DATA SCIENCE
─────────────────────────────────────
numpy                      → numerical arrays
pandas                     → data manipulation
matplotlib, seaborn        → visualization
plotly, bokeh              → interactive charts
scipy                      → scientific algorithms
statsmodels                → statistical models
scikit-learn               → machine learning
xgboost, lightgbm          → gradient boosting
tensorflow, pytorch        → deep learning
huggingface transformers   → pre-trained models
jupyter                    → interactive notebooks
polars                     → fast DataFrames (Rust-based)

─────────────────────────────────────
🤖 AI / LLM
─────────────────────────────────────
openai                     → OpenAI API client
anthropic                  → Anthropic API client
langchain                  → LLM application framework
llamaindex                 → data + LLM pipelines
sentence-transformers      → embeddings
chromadb, pinecone         → vector databases

─────────────────────────────────────
⚙️  DEVOPS & AUTOMATION
─────────────────────────────────────
boto3                      → AWS SDK
azure-sdk                  → Azure SDK
google-cloud               → GCP SDK
fabric                     → SSH automation
paramiko                   → SSH protocol
docker SDK                 → Docker API
kubernetes (client)        → K8s API
celery                     → distributed task queues
redis                      → message broker
dramatiq                   → alternative task queue
APScheduler                → job scheduling

─────────────────────────────────────
🧪 TESTING
─────────────────────────────────────
pytest                     → the standard test framework
pytest-cov                 → coverage reports
pytest-asyncio             → async test support
hypothesis                 → property-based testing
faker                      → fake data generation
factory_boy                → test fixtures
responses                  → mock HTTP requests
freezegun                  → mock datetime

─────────────────────────────────────
🔧 CODE QUALITY
─────────────────────────────────────
black                      → auto-formatter
ruff                       → ultra-fast linter
mypy, pyright              → type checkers
isort                      → import sorter
bandit                     → security scanner
pre-commit                 → git hook runner

─────────────────────────────────────
🛠️  UTILITIES
─────────────────────────────────────
pydantic                   → data validation
python-dotenv              → .env file loading
rich                       → beautiful terminal output
typer                      → CLI from type hints
click                      → CLI framework
tqdm                       → progress bars
loguru                     → better logging
more-itertools             → itertools superset
toolz                      → functional tools
attrs, cattrs              → alternative to dataclasses
pendulum                   → better datetime
arrow                      → also datetime
humanize                   → human-readable formats

💻 CODE:
# ── PYDANTIC — DATA VALIDATION ─────
# pip install pydantic

PYDANTIC_EXAMPLE = '''
from pydantic import BaseModel, Field, validator, EmailStr
from typing import Optional
from datetime import datetime

class User(BaseModel):
    id: int
    name: str = Field(..., min_length=1, max_length=100)
    email: str
    age: Optional[int] = Field(None, ge=0, le=150)
    created_at: datetime = Field(default_factory=datetime.now)
    tags: list[str] = []

    @validator('name')
    def name_must_not_be_empty(cls, v):
        if v.strip() == '':
            raise ValueError('Name cannot be blank')
        return v.strip()

    class Config:
        # Accept ORM objects directly
        from_attributes = True

# Automatic validation on creation
user = User(id=1, name="Alice", email="alice@ex.com", age=30)
print(user.model_dump())

# Raises ValidationError for bad data:
# User(id=1, name="", email="bad")  → ValidationError
'''

# ── CELERY — DISTRIBUTED TASKS ─────
# pip install celery redis

CELERY_EXAMPLE = '''
from celery import Celery

app = Celery('tasks', broker='redis://localhost:6379/0')

@app.task
def add(x, y):
    return x + y

@app.task(bind=True, max_retries=3)
def send_email(self, email, subject, body):
    try:
        # ... send email
        pass
    except Exception as exc:
        raise self.retry(exc=exc, countdown=60)

# Call tasks:
result = add.delay(4, 4)         # async
result.get(timeout=10)           # wait for result

# Chain tasks:
from celery import chain
pipeline = chain(add.s(2, 2), add.s(4))
result = pipeline.delay()
'''

# ── HTTPX — MODERN HTTP CLIENT ─────
# pip install httpx

HTTPX_EXAMPLE = '''
import httpx
import asyncio

# Sync (like requests but with HTTP/2 support)
with httpx.Client() as client:
    r = client.get("https://httpbin.org/get", timeout=5.0)
    print(r.status_code)
    print(r.json())

# Async (with connection pooling)
async def fetch_many(urls):
    async with httpx.AsyncClient() as client:
        tasks = [client.get(url) for url in urls]
        responses = await asyncio.gather(*tasks)
        return [r.json() for r in responses]

# Retry logic built-in with transport
transport = httpx.HTTPTransport(retries=3)
with httpx.Client(transport=transport) as client:
    r = client.get("https://api.example.com")
'''

# ── SQLALCHEMY — ORM ──────────────
# pip install sqlalchemy

SQLALCHEMY_EXAMPLE = '''
from sqlalchemy import create_engine, Column, Integer, String, DateTime, ForeignKey
from sqlalchemy.orm import DeclarativeBase, Session, relationship
from datetime import datetime

class Base(DeclarativeBase):
    pass

class User(Base):
    __tablename__ = "users"
    id       = Column(Integer, primary_key=True)
    name     = Column(String(100), nullable=False)
    email    = Column(String(255), unique=True, nullable=False)
    posts    = relationship("Post", back_populates="author")

class Post(Base):
    __tablename__ = "posts"
    id        = Column(Integer, primary_key=True)
    title     = Column(String(200), nullable=False)
    content   = Column(String)
    user_id   = Column(Integer, ForeignKey("users.id"))
    author    = relationship("User", back_populates="posts")

engine = create_engine("sqlite:///app.db")
Base.metadata.create_all(engine)

with Session(engine) as session:
    alice = User(name="Alice", email="alice@ex.com")
    session.add(alice)
    session.commit()
    session.refresh(alice)

    post = Post(title="Hello", content="World", author=alice)
    session.add(post)
    session.commit()

    # Query
    users = session.query(User).filter(User.name.startswith("A")).all()
    for u in users:
        print(u.name, [p.title for p in u.posts])
'''

# ── RICH — BEAUTIFUL OUTPUT ────────
# pip install rich

RICH_EXAMPLE = '''
from rich.console import Console
from rich.table import Table
from rich.progress import track
from rich.syntax import Syntax
from rich.panel import Panel
from rich import print as rprint

console = Console()

# Styled print
console.print("[bold green]Success![/bold green] Operation completed.")
console.print("[red]Error:[/red] Something went wrong.")
rprint("[blue]Rich[/blue] [yellow]makes[/yellow] [green]terminals[/green] [magenta]beautiful![/magenta]")

# Table
table = Table(title="Benchmark Results")
table.add_column("Algorithm", style="cyan")
table.add_column("Time (ms)", justify="right", style="green")
table.add_column("Memory (MB)", justify="right")
table.add_row("Quick Sort", "1.23", "4.2")
table.add_row("Merge Sort", "1.45", "8.7")
table.add_row("Bubble Sort", "45.2", "4.1")
console.print(table)

# Progress bar
for item in track(range(100), description="Processing..."):
    pass

# Syntax highlighting
code = "def hello(name: str) -> str:\\n    return f'Hello, {name}!'"
syntax = Syntax(code, "python", theme="monokai")
console.print(Panel(syntax, title="Code Example"))
'''

# ── KEY COMMANDS REFERENCE ─────────

COMMANDS = '''
Package Management:
  pip install package           Install latest
  pip install package==1.2.3   Install specific version
  pip install -r requirements.txt
  pip freeze > requirements.txt
  pip list --outdated           Check for updates
  pip audit                     Security audit

Virtual Environments:
  python -m venv .venv
  source .venv/bin/activate     (Unix)
  .venv\\\\Scripts\\\\activate        (Windows)
  deactivate

Code Quality:
  black .                       Auto-format
  ruff check .                  Lint
  ruff check --fix .            Auto-fix lint
  mypy .                        Type check
  pytest                        Run tests
  pytest --cov=. -v             With coverage
  bandit -r .                   Security scan

Project Init (with poetry):
  poetry new myproject
  poetry add requests
  poetry add --dev pytest black mypy
  poetry install
  poetry run python main.py
  poetry build
'''

print("Python ecosystem overview complete!")
print("\\n=== Key Categories ===")
print("Web: Flask, FastAPI, Django")
print("Data: numpy, pandas, scikit-learn")
print("DB: SQLAlchemy, psycopg2")
print("AI: openai, anthropic, langchain")
print("Utils: pydantic, rich, click, loguru")
print("\\nRun 'pip install <package>' to get started!")

📝 KEY POINTS:
✅ Check PyPI before writing a utility — it probably exists
✅ Pydantic is the go-to library for data validation and settings
✅ SQLAlchemy is the standard Python ORM for relational databases
✅ Celery + Redis for background tasks and job queues
✅ Rich transforms plain terminal output into beautiful formatted UIs
✅ httpx is the modern alternative to requests (supports async)
✅ Use ruff for linting (replaces flake8+isort+more, 100x faster)
❌ Don't install packages globally — always use a virtual environment
❌ Don't use unmaintained packages — check last release date and stars
❌ Don't skip reading the docs — most confusion comes from guessing the API
""",
  quiz: [
    Quiz(question: 'What is Pydantic primarily used for?', options: [
      QuizOption(text: 'Database migrations and schema management', correct: false),
      QuizOption(text: 'Data validation, serialization, and settings management using Python type hints', correct: true),
      QuizOption(text: 'Building CLI tools with type hints', correct: false),
      QuizOption(text: 'Async HTTP requests', correct: false),
    ]),
    Quiz(question: 'What is PyPI?', options: [
      QuizOption(text: 'Python\'s built-in standard library', correct: false),
      QuizOption(text: 'The Python Package Index — a repository of 500,000+ third-party packages', correct: true),
      QuizOption(text: 'Python\'s official IDE', correct: false),
      QuizOption(text: 'A tool for creating virtual environments', correct: false),
    ]),
    Quiz(question: 'What is Celery used for?', options: [
      QuizOption(text: 'Database ORM for async applications', correct: false),
      QuizOption(text: 'Distributed task queues — running tasks asynchronously in background workers', correct: true),
      QuizOption(text: 'HTTP request handling in Flask', correct: false),
      QuizOption(text: 'Static analysis and type checking', correct: false),
    ]),
  ],
);
