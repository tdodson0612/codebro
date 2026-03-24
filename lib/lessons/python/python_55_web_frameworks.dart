import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson55 = Lesson(
  language: 'Python',
  title: 'Web Frameworks: Flask, FastAPI & Django',
  content: """
🎯 METAPHOR:
Flask is like a LEGO base plate — minimal, just enough
to build on. You choose every piece: what database library,
what authentication system, what validation. Total control,
but you assemble everything yourself.

FastAPI is like a high-end prefab modular home.
Modern structure built in, excellent defaults, type hints
drive the whole API, and it auto-generates documentation.
Still flexible, but the best parts are already there.

Django is like a fully furnished apartment complex.
Move in and everything works: kitchen (ORM), living room
(admin panel), security system (auth), mailbox (email).
Convention over configuration. Less freedom, but you're
productive in 10 minutes and production-ready in a day.

📖 EXPLANATION:
Python has three dominant web frameworks:
  Flask   — micro, flexible, explicit
  FastAPI — modern, async-ready, type-driven
  Django  — batteries included, opinionated

─────────────────────────────────────
🟦 FLASK — MICRO FRAMEWORK
─────────────────────────────────────
pip install flask

Minimal server:
  from flask import Flask
  app = Flask(__name__)

  @app.route("/")
  def index():
      return "Hello World"

  app.run()

─────────────────────────────────────
⚡ FASTAPI — MODERN ASYNC
─────────────────────────────────────
pip install fastapi uvicorn

Type hints = validation + docs + OpenAPI
Built on Starlette (ASGI) + Pydantic
Auto-generates /docs (Swagger) + /redoc

─────────────────────────────────────
🐘 DJANGO — FULL-STACK
─────────────────────────────────────
pip install django

django-admin startproject mysite
python manage.py startapp myapp
python manage.py runserver

ORM, migrations, admin panel, auth,
templates, forms, middleware, signals

─────────────────────────────────────
🆚 WHEN TO USE WHICH
─────────────────────────────────────
Flask:   microservices, small APIs, learning
FastAPI: REST APIs with type validation,
         async workloads, auto-docs needed
Django:  full web apps, content sites, admin panel,
         team projects needing conventions

💻 CODE:
# ── FLASK ──────────────────────────
# pip install flask

FLASK_EXAMPLE = '''
from flask import Flask, request, jsonify, abort
from functools import wraps

app = Flask(__name__)

# In-memory "database" for demo
users = {1: {"name": "Alice", "email": "alice@example.com"}}

# Middleware-style decorator
def require_auth(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        token = request.headers.get("Authorization")
        if not token or not token.startswith("Bearer "):
            abort(401, description="Missing or invalid token")
        return f(*args, **kwargs)
    return decorated

# Routes
@app.route("/")
def index():
    return jsonify({"message": "Welcome to Flask API", "version": "1.0"})

@app.route("/users", methods=["GET"])
def list_users():
    return jsonify(list(users.values()))

@app.route("/users/<int:user_id>", methods=["GET"])
def get_user(user_id):
    user = users.get(user_id)
    if not user:
        abort(404, description=f"User {user_id} not found")
    return jsonify(user)

@app.route("/users", methods=["POST"])
@require_auth
def create_user():
    data = request.get_json()
    if not data or "name" not in data:
        abort(400, description="name field required")
    new_id = max(users.keys()) + 1
    users[new_id] = {"id": new_id, **data}
    return jsonify(users[new_id]), 201

@app.route("/users/<int:user_id>", methods=["PUT"])
@require_auth
def update_user(user_id):
    if user_id not in users:
        abort(404)
    data = request.get_json()
    users[user_id].update(data)
    return jsonify(users[user_id])

@app.route("/users/<int:user_id>", methods=["DELETE"])
@require_auth
def delete_user(user_id):
    if user_id not in users:
        abort(404)
    deleted = users.pop(user_id)
    return jsonify({"deleted": deleted})

# Error handlers
@app.errorhandler(404)
def not_found(e):
    return jsonify({"error": str(e)}), 404

@app.errorhandler(401)
def unauthorized(e):
    return jsonify({"error": str(e)}), 401

if __name__ == "__main__":
    app.run(debug=True, port=5000)
'''

# ── FASTAPI ────────────────────────
# pip install fastapi uvicorn pydantic

FASTAPI_EXAMPLE = '''
from fastapi import FastAPI, HTTPException, Depends, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from pydantic import BaseModel, EmailStr, Field
from typing import Optional
import uvicorn

app = FastAPI(
    title="My API",
    description="A FastAPI example with full CRUD",
    version="1.0.0"
)

# ── PYDANTIC MODELS (Request/Response schemas) ──
class UserBase(BaseModel):
    name: str = Field(..., min_length=1, max_length=100)
    email: str = Field(..., pattern=r"^[^@]+@[^@]+\\\\.[^@]+\$")
    age: Optional[int] = Field(None, ge=0, le=150)

class UserCreate(UserBase):
    pass   # same as base for creation

class User(UserBase):
    id: int

    class Config:
        from_attributes = True  # Pydantic v2

# In-memory storage
db: dict[int, dict] = {
    1: {"id": 1, "name": "Alice", "email": "alice@example.com", "age": 30},
}
next_id = 2

# ── AUTH ──
security = HTTPBearer()

def verify_token(credentials: HTTPAuthorizationCredentials = Depends(security)):
    if credentials.credentials != "secret-token":
        raise HTTPException(status_code=401, detail="Invalid token")
    return credentials.credentials

# ── ROUTES (type hints = validation + docs!) ──
@app.get("/")
async def root():
    return {"message": "FastAPI is running!"}

@app.get("/users", response_model=list[User])
async def list_users():
    return list(db.values())

@app.get("/users/{user_id}", response_model=User)
async def get_user(user_id: int):
    if user_id not in db:
        raise HTTPException(status_code=404, detail="User not found")
    return db[user_id]

@app.post("/users", response_model=User, status_code=201)
async def create_user(user: UserCreate, token: str = Depends(verify_token)):
    global next_id
    new_user = {"id": next_id, **user.model_dump()}
    db[next_id] = new_user
    next_id += 1
    return new_user

@app.put("/users/{user_id}", response_model=User)
async def update_user(user_id: int, user: UserBase, token: str = Depends(verify_token)):
    if user_id not in db:
        raise HTTPException(status_code=404, detail="User not found")
    db[user_id].update(user.model_dump())
    return db[user_id]

@app.delete("/users/{user_id}", status_code=204)
async def delete_user(user_id: int, token: str = Depends(verify_token)):
    if user_id not in db:
        raise HTTPException(status_code=404, detail="User not found")
    del db[user_id]

if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
    # Visit http://localhost:8000/docs for auto-generated Swagger UI!
'''

# ── DJANGO OVERVIEW ────────────────

DJANGO_OVERVIEW = '''
# 1. Create project:
django-admin startproject mysite
cd mysite

# 2. Create app:
python manage.py startapp blog

# 3. models.py — define data models
from django.db import models

class Post(models.Model):
    title   = models.CharField(max_length=200)
    content = models.TextField()
    author  = models.ForeignKey("auth.User", on_delete=models.CASCADE)
    created = models.DateTimeField(auto_now_add=True)
    updated = models.DateTimeField(auto_now=True)
    active  = models.BooleanField(default=True)

    class Meta:
        ordering = ["-created"]

    def __str__(self):
        return self.title

# 4. Migrations:
# python manage.py makemigrations
# python manage.py migrate

# 5. views.py
from django.http import JsonResponse
from django.views.decorators.http import require_http_methods
from .models import Post

def post_list(request):
    posts = Post.objects.filter(active=True).values("id", "title", "created")
    return JsonResponse(list(posts), safe=False)

# 6. urls.py
from django.urls import path
urlpatterns = [
    path("posts/", post_list),
]

# 7. Admin — auto-generated admin panel!
from django.contrib import admin
admin.site.register(Post)

# 8. Django REST Framework (DRF) for APIs
# pip install djangorestframework
from rest_framework import serializers, viewsets, routers

class PostSerializer(serializers.ModelSerializer):
    class Meta:
        model = Post
        fields = "__all__"

class PostViewSet(viewsets.ModelViewSet):
    queryset = Post.objects.all()
    serializer_class = PostSerializer

router = routers.DefaultRouter()
router.register("posts", PostViewSet)
'''

# Summary comparison
COMPARISON = '''
Feature         Flask      FastAPI    Django
─────────────────────────────────────────────
Type           Micro      Micro+     Full-stack
Async          Manual     Native     Yes (3.1+)
ORM            3rd party  3rd party  Built-in
Admin Panel    3rd party  3rd party  Built-in
Auth           3rd party  3rd party  Built-in
Validation     Manual     Pydantic   Forms/DRF
Auto Docs      No         Yes        DRF only
Performance    Good       Excellent  Good
Learning Curve Low        Low-Med    Medium-High
'''

print(COMPARISON)

📝 KEY POINTS:
✅ Flask: minimal, explicit — great for simple APIs and learning
✅ FastAPI: type hints drive validation, serialization, and auto-docs
✅ Django: batteries included — use for full web apps with admin panel
✅ FastAPI's Pydantic models validate request data automatically
✅ Use uvicorn or gunicorn to run ASGI/WSGI apps in production
✅ Django REST Framework (DRF) adds a complete API layer to Django
❌ Don't use Flask's built-in server in production — use gunicorn
❌ Don't expose debug=True in production
❌ Don't put secret keys in source code — use environment variables
""",
  quiz: [
    Quiz(question: 'What is the main advantage of FastAPI over Flask for REST APIs?', options: [
      QuizOption(text: 'FastAPI is older and more battle-tested', correct: false),
      QuizOption(text: 'Type hints automatically drive validation, serialization, and auto-generated documentation', correct: true),
      QuizOption(text: 'FastAPI has a built-in admin panel', correct: false),
      QuizOption(text: 'FastAPI requires less code overall', correct: false),
    ]),
    Quiz(question: 'What does Django\'s ORM "makemigrations" and "migrate" do?', options: [
      QuizOption(text: 'makemigrations runs all tests; migrate deploys the app', correct: false),
      QuizOption(text: 'makemigrations generates migration files from model changes; migrate applies them to the database', correct: true),
      QuizOption(text: 'They both create new Django apps', correct: false),
      QuizOption(text: 'They export and import database data', correct: false),
    ]),
    Quiz(question: 'When would you choose Django over Flask?', options: [
      QuizOption(text: 'When you need a minimal microservice with full control over all components', correct: false),
      QuizOption(text: 'When you need a full web app with admin panel, auth, ORM, and convention-driven structure', correct: true),
      QuizOption(text: 'When async performance is the top priority', correct: false),
      QuizOption(text: 'When you want auto-generated Swagger documentation', correct: false),
    ]),
  ],
);
