import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson89 = Lesson(
  language: 'Python',
  title: 'Intro to FastAPI',
  content: '''
🎯 WHAT IS FASTAPI?
FastAPI is the modern Python web framework built on two
revolutionary ideas: let TYPE HINTS do the heavy lifting,
and make ASYNC the default.

You write a function with type hints. FastAPI reads
those hints and automatically:
  • Validates incoming request data
  • Converts between JSON and Python types
  • Generates OpenAPI (Swagger) documentation
  • Generates JSON Schema
  • Reports validation errors with precise messages

It's built on Starlette (ASGI toolkit) and Pydantic
(data validation). The result is the fastest Python
framework to develop with, and one of the fastest in
raw performance (beating Flask and Django significantly).

─────────────────────────────────────
💡 FASTAPI IN ONE SENTENCE
─────────────────────────────────────
FastAPI turns Python type hints into a validated,
documented, high-performance async web API.

─────────────────────────────────────
🎯 WHEN TO USE FASTAPI
─────────────────────────────────────
✅ REST APIs and microservices
✅ When you need async/await (high concurrency)
✅ When auto-generated documentation is valuable
✅ When data validation matters (Pydantic models)
✅ When you need high performance
✅ ML model serving, data pipelines
✅ Modern type-hinted Python codebases

❌ Don't use FastAPI when:
  • You need server-side HTML rendering (use Django/Flask)
  • You need Django's built-in admin panel
  • Your team has deep Flask expertise and doesn't need async

─────────────────────────────────────
🚀 GETTING STARTED
─────────────────────────────────────
Install:
  pip install fastapi uvicorn[standard]

The simplest FastAPI app:
  from fastapi import FastAPI

  app = FastAPI()

  @app.get("/")
  async def root():
      return {"message": "Hello, World!"}

Run: uvicorn main:app --reload
Open: http://127.0.0.1:8000
Docs: http://127.0.0.1:8000/docs   ← interactive Swagger UI!
      http://127.0.0.1:8000/redoc  ← ReDoc documentation

─────────────────────────────────────
📐 CORE CONCEPTS
─────────────────────────────────────
Path Operations: @app.get/post/put/patch/delete("/path")
Path Params:     /users/{user_id} → int user_id in signature
Query Params:    ?skip=0&limit=10 → Optional params
Request Body:    Pydantic model → validated automatically
Response Model:  response_model=MyModel → filters output
Dependencies:    Depends() → reusable logic (auth, DB)
Middleware:      app.add_middleware() → cross-cutting concerns
Background Tasks: BackgroundTasks → fire-and-forget

─────────────────────────────────────
⚡ THE MAGIC: TYPE HINTS = EVERYTHING
─────────────────────────────────────
@app.get("/users/{user_id}")
async def get_user(
    user_id: int,          # path param, auto-converted int
    active: bool = True,   # query param with default
    db: Session = Depends(get_db)  # dependency injection
) -> UserResponse:          # response model
    ...

FastAPI reads this function signature and:
  • Routes /users/42 (parses user_id=42 as int)
  • Adds ?active=true query param to /users/42?active=true
  • Injects a DB session via Depends(get_db)
  • Validates the response matches UserResponse schema
  • Adds all of this to the /docs Swagger UI

─────────────────────────────────────
📦 FASTAPI ECOSYSTEM
─────────────────────────────────────
uvicorn           → ASGI server to run FastAPI
SQLAlchemy        → ORM (with asyncpg for async)
SQLModel          → SQLAlchemy + Pydantic together
Alembic           → database migrations
python-jose       → JWT tokens
passlib[bcrypt]   → password hashing
httpx             → async HTTP client (for testing)
pytest + httpx    → testing FastAPI apps
Celery            → background tasks
Redis             → caching and task queues

─────────────────────────────────────
📁 RECOMMENDED PROJECT STRUCTURE
─────────────────────────────────────
my_fastapi_app/
├── app/
│   ├── main.py         ← FastAPI app creation
│   ├── models/         ← Pydantic request/response models
│   ├── routers/        ← APIRouter modules
│   │   ├── users.py
│   │   └── posts.py
│   ├── database.py     ← DB connection + sessions
│   ├── crud.py         ← database operations
│   ├── dependencies.py ← reusable Depends() functions
│   └── config.py       ← Settings with pydantic-settings
├── tests/
├── alembic/            ← migrations
├── requirements.txt
└── docker-compose.yml

─────────────────────────────────────
📖 DOCUMENTATION & LEARNING
─────────────────────────────────────
Official docs:  https://fastapi.tiangolo.com
  (Best framework docs in the Python world — comprehensive,
   beginner-friendly, with interactive examples)

Tutorial:       https://fastapi.tiangolo.com/tutorial/
Advanced:       https://fastapi.tiangolo.com/advanced/
Full-stack app: https://github.com/tiangolo/full-stack-fastapi-template

📚 Recommended Resources:
  • FastAPI official tutorial (fastapi.tiangolo.com) — start here!
  • TestDriven.io FastAPI course: testdriven.io/courses/tdd-fastapi/
  • "FastAPI: Modern Python Web Development" (O'Reilly book)
  • YouTube: "FastAPI Tutorial" by Sebastián Ramírez (the creator)

💻 CODE:
FULL_FASTAPI_EXAMPLE = """
from fastapi import FastAPI, HTTPException, Depends, status, Query
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field, EmailStr
from typing import Optional
from datetime import datetime
import uvicorn

# ── PYDANTIC MODELS ───────────────

class UserBase(BaseModel):
    name: str = Field(..., min_length=1, max_length=100)
    email: str = Field(..., description="User email address")

class UserCreate(UserBase):
    password: str = Field(..., min_length=8)

class UserResponse(UserBase):
    id: int
    active: bool
    created_at: datetime

    class Config:
        from_attributes = True   # support ORM objects

class UserUpdate(BaseModel):
    name: Optional[str] = None
    email: Optional[str] = None
    active: Optional[bool] = None

# ── CREATE THE APP ────────────────

app = FastAPI(
    title="My FastAPI",
    description="A complete REST API built with FastAPI",
    version="1.0.0",
    docs_url="/docs",      # Swagger UI
    redoc_url="/redoc",    # ReDoc UI
)

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["https://myfrontend.com"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ── IN-MEMORY DATABASE ────────────

from datetime import timezone
fake_db: dict[int, dict] = {
    1: {"id": 1, "name": "Alice", "email": "alice@ex.com",
        "active": True, "created_at": datetime.now(timezone.utc)},
    2: {"id": 2, "name": "Bob",   "email": "bob@ex.com",
        "active": True, "created_at": datetime.now(timezone.utc)},
}
next_id = 3

# ── DEPENDENCY INJECTION ──────────

from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials

security = HTTPBearer()

async def verify_token(
    credentials: HTTPAuthorizationCredentials = Depends(security)
) -> str:
    token = credentials.credentials
    if token != "valid-secret-token":
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid token"
        )
    return token

# ── ROUTES ────────────────────────

@app.get("/")
async def root():
    return {"message": "FastAPI is running!", "docs": "/docs"}

@app.get(
    "/users",
    response_model=list[UserResponse],
    summary="List all users",
    description="Returns a paginated list of users with optional filtering."
)
async def list_users(
    skip: int = Query(0, ge=0, description="Records to skip"),
    limit: int = Query(100, ge=1, le=1000, description="Max records"),
    active: Optional[bool] = None,
):
    result = list(fake_db.values())
    if active is not None:
        result = [u for u in result if u["active"] == active]
    return result[skip : skip + limit]

@app.get("/users/{user_id}", response_model=UserResponse)
async def get_user(user_id: int):
    user = fake_db.get(user_id)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"User {user_id} not found"
        )
    return user

@app.post(
    "/users",
    response_model=UserResponse,
    status_code=status.HTTP_201_CREATED,
)
async def create_user(
    user: UserCreate,                          # body validated automatically
    token: str = Depends(verify_token),        # requires auth
):
    global next_id
    new_user = {
        "id": next_id,
        "name": user.name,
        "email": user.email,
        "active": True,
        "created_at": datetime.now(timezone.utc),
    }
    fake_db[next_id] = new_user
    next_id += 1
    return new_user   # FastAPI validates this matches UserResponse

@app.patch("/users/{user_id}", response_model=UserResponse)
async def update_user(
    user_id: int,
    updates: UserUpdate,
    token: str = Depends(verify_token),
):
    if user_id not in fake_db:
        raise HTTPException(status_code=404, detail="User not found")
    # Only update provided fields (exclude_unset!)
    update_data = updates.model_dump(exclude_unset=True)
    fake_db[user_id].update(update_data)
    return fake_db[user_id]

@app.delete("/users/{user_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_user(
    user_id: int,
    token: str = Depends(verify_token),
):
    if user_id not in fake_db:
        raise HTTPException(status_code=404, detail="User not found")
    del fake_db[user_id]
    # No return needed for 204

# ── BACKGROUND TASKS ─────────────

from fastapi import BackgroundTasks

def send_welcome_email(email: str, name: str):
    print(f"Sending welcome email to {email}...")
    import time; time.sleep(2)   # simulate slow email
    print(f"Email sent to {name}!")

@app.post("/users/welcome/{user_id}")
async def send_welcome(user_id: int, background_tasks: BackgroundTasks):
    user = fake_db.get(user_id)
    if not user:
        raise HTTPException(status_code=404)
    background_tasks.add_task(send_welcome_email, user["email"], user["name"])
    return {"message": "Welcome email queued!"}

# ── API ROUTER (for modular code) ─

from fastapi import APIRouter

health_router = APIRouter(prefix="/health", tags=["health"])

@health_router.get("/")
async def health_check():
    return {"status": "healthy", "timestamp": datetime.now().isoformat()}

@health_router.get("/db")
async def db_health():
    return {"status": "healthy", "users_count": len(fake_db)}

app.include_router(health_router)

# ── STARTUP & SHUTDOWN ────────────

@app.on_event("startup")
async def startup():
    print("Application starting up...")

@app.on_event("shutdown")
async def shutdown():
    print("Application shutting down...")

# ── RUN ───────────────────────────

if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
# Production: uvicorn main:app --workers 4 --host 0.0.0.0 --port 8000
"""

# ── TESTING FASTAPI ───────────────

TESTING_EXAMPLE = """
from fastapi.testclient import TestClient
from main import app

client = TestClient(app)

def test_root():
    response = client.get("/")
    assert response.status_code == 200
    assert response.json()["message"] == "FastAPI is running!"

def test_list_users():
    response = client.get("/users")
    assert response.status_code == 200
    users = response.json()
    assert len(users) >= 2

def test_create_user_unauthorized():
    response = client.post("/users", json={"name": "Carol", "email": "carol@ex.com", "password": "secret123"})
    assert response.status_code == 403   # no auth header

def test_create_user():
    response = client.post(
        "/users",
        json={"name": "Carol", "email": "carol@ex.com", "password": "secret123"},
        headers={"Authorization": "Bearer valid-secret-token"}
    )
    assert response.status_code == 201
    data = response.json()
    assert data["name"] == "Carol"
    assert "password" not in data  # never returned in response!
"""

print("FastAPI overview loaded!")
print()
print("Quick start:")
print("  pip install fastapi uvicorn")
print("  uvicorn main:app --reload")
print()
print("Then visit:")
print("  http://127.0.0.1:8000       ← your API")
print("  http://127.0.0.1:8000/docs  ← auto-generated Swagger UI")

📝 KEY POINTS:
✅ FastAPI reads type hints to automatically validate, convert, and document
✅ Pydantic models for request bodies — invalid data returns clear 422 errors
✅ Auto-generated /docs (Swagger UI) and /redoc — great for teams and clients
✅ Depends() for dependency injection — reuse auth, DB sessions, etc.
✅ async def routes for non-blocking I/O (use await inside)
✅ response_model= filters the response — never accidentally leak fields
✅ TestClient for synchronous testing, httpx.AsyncClient for async tests
✅ The official FastAPI tutorial at fastapi.tiangolo.com is exceptional — start there
❌ Don't use regular def instead of async def for I/O-bound routes — defeats the purpose
❌ Never return passwords or sensitive fields without a response_model filter
❌ Don't call blocking code (requests.get, time.sleep) directly in async routes — use run_in_executor
''',
  quiz: [
    Quiz(question: 'What does FastAPI automatically generate from your type hints?', options: [
      QuizOption(text: 'Only input validation', correct: false),
      QuizOption(text: 'Request validation, type conversion, JSON Schema, and interactive OpenAPI documentation', correct: true),
      QuizOption(text: 'Database migration files', correct: false),
      QuizOption(text: 'Unit tests for each route', correct: false),
    ]),
    Quiz(question: 'What is the purpose of response_model= in a FastAPI route?', options: [
      QuizOption(text: 'It specifies the database model to query', correct: false),
      QuizOption(text: 'It filters and validates the response data — preventing accidental field leakage', correct: true),
      QuizOption(text: 'It tells FastAPI to cache the response', correct: false),
      QuizOption(text: 'It sets the HTTP Content-Type header', correct: false),
    ]),
    Quiz(question: 'What URL serves FastAPI\'s interactive documentation by default?', options: [
      QuizOption(text: '/documentation', correct: false),
      QuizOption(text: '/api', correct: false),
      QuizOption(text: '/docs', correct: true),
      QuizOption(text: '/swagger', correct: false),
    ]),
  ],
);
