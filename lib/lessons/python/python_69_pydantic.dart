import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson69 = Lesson(
  language: 'Python',
  title: 'Pydantic: Data Validation & Settings',
  content: """
🎯 METAPHOR:
Pydantic is like a strict customs officer at an airport.
You declare what should be in your suitcase (your model).
Every bag (incoming data) gets inspected.
Missing item? Confiscated at the border (ValidationError).
Wrong type? The officer tries to convert it (coercion)
— "this is a number but the manifest says string — fine,
I'll convert it." Still wrong after conversion? Rejected.
Only bags that pass inspection make it through. And you
always know exactly what's inside because the customs
officer guarantees it.

📖 EXPLANATION:
Pydantic uses Python type hints to validate data at runtime.
It automatically converts (coerces) compatible types and
raises ValidationError with clear messages for invalid data.
Used heavily in FastAPI and anywhere you receive external data.

─────────────────────────────────────
📦 PYDANTIC V2 API (Modern)
─────────────────────────────────────
pip install pydantic

from pydantic import BaseModel, Field, validator
from pydantic import field_validator, model_validator

class MyModel(BaseModel):
    field: type = default
    field: type = Field(..., description="...")

Methods:
  model.model_dump()       → dict
  model.model_dump_json()  → JSON string
  MyModel(**dict)          → create from dict
  MyModel.model_validate(dict) → explicit validation
  MyModel.model_json_schema()  → JSON Schema

─────────────────────────────────────
🔑 FIELD() OPTIONS
─────────────────────────────────────
Field(default)
Field(default, alias="json_name")
Field(...) — required (... = Ellipsis)
Field(None) — optional
Field(ge=0, le=100) — numeric bounds
Field(min_length=1, max_length=100) — string bounds
Field(pattern=r"regex") — regex validation
Field(description="...") — documentation

─────────────────────────────────────
⚡ COERCION
─────────────────────────────────────
Pydantic V2 is strict by default in some modes but
generally tries to coerce:
  "42" → int: 42  (string to int)
  1    → bool: True (int to bool)
  "2024-01-15" → date object

─────────────────────────────────────
🏗️  VALIDATORS
─────────────────────────────────────
@field_validator("field_name")     → validate one field
@model_validator(mode="after")     → validate whole model

💻 CODE:
# pip install pydantic (already assumed installed)
# Note: This uses Pydantic V2 syntax

PYDANTIC_CODE = '''
from pydantic import (
    BaseModel, Field, field_validator, model_validator,
    EmailStr, HttpUrl, ValidationError, ConfigDict
)
from typing import Optional, Annotated
from datetime import datetime, date
from enum import Enum

# ── BASIC MODEL ────────────────────

class User(BaseModel):
    id: int
    name: str
    email: str
    age: Optional[int] = None
    active: bool = True

# Create from keyword args
u1 = User(id=1, name="Alice", email="alice@example.com", age=30)
print(u1)
print(u1.name)        # Alice
print(u1.model_dump()) # dict

# Pydantic tries to coerce:
u2 = User(id="42", name="Bob", email="bob@test.com")  # id coerced
print(u2.id, type(u2.id))   # 42 <class 'int'>

# ValidationError for invalid data:
try:
    u3 = User(id="not_a_number", name="Carol", email="carol@test.com")
except ValidationError as e:
    print(e)   # clear error messages

# Create from dict
data = {"id": 3, "name": "Dave", "email": "dave@test.com"}
u4 = User(**data)
# or
u5 = User.model_validate(data)

# Serialize
print(u1.model_dump())          # {'id': 1, 'name': 'Alice', ...}
print(u1.model_dump_json())     # JSON string

# ── FIELD VALIDATION ──────────────

class Product(BaseModel):
    name: str = Field(..., min_length=1, max_length=100,
                      description="Product name")
    price: float = Field(..., gt=0, description="Price > 0")
    quantity: int = Field(0, ge=0, description="Stock quantity")
    sku: str = Field(..., pattern=r"^[A-Z]{2}-\\\\d{4}\$",
                     description="Format: XX-0000")
    category: str = Field("general")
    tags: list[str] = Field(default_factory=list)

try:
    p = Product(name="Widget", price=9.99, sku="WG-1234")
    print(p)
except ValidationError as e:
    print(e)

try:
    bad = Product(name="", price=-5, sku="invalid")
except ValidationError as e:
    for error in e.errors():
        print(f"  {error['loc']}: {error['msg']}")

# ── ENUMS IN MODELS ───────────────

class Status(str, Enum):
    PENDING   = "pending"
    ACTIVE    = "active"
    INACTIVE  = "inactive"

class Order(BaseModel):
    id: int
    status: Status = Status.PENDING
    amount: float

order = Order(id=1, amount=99.99)
print(order.status)   # Status.PENDING

order2 = Order(id=2, status="active", amount=50.0)
print(order2.status)   # Status.ACTIVE (string auto-converted to Enum)

# ── CUSTOM VALIDATORS ─────────────

class SignupForm(BaseModel):
    username: str = Field(..., min_length=3, max_length=30)
    password: str = Field(..., min_length=8)
    email: str
    age: int = Field(..., ge=13, le=120)
    website: Optional[str] = None

    @field_validator("username")
    @classmethod
    def username_alphanumeric(cls, v: str) -> str:
        import re
        if not re.match(r"^[a-zA-Z0-9_-]+\$", v):
            raise ValueError("Username: only letters, numbers, _ and -")
        return v.lower()   # normalize to lowercase

    @field_validator("password")
    @classmethod
    def password_strength(cls, v: str) -> str:
        import re
        if not re.search(r"[A-Z]", v):
            raise ValueError("Password must contain uppercase")
        if not re.search(r"[0-9]", v):
            raise ValueError("Password must contain a digit")
        return v

    @field_validator("email")
    @classmethod
    def valid_email(cls, v: str) -> str:
        import re
        pattern = r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\\\.[a-zA-Z]{2,}\$"
        if not re.match(pattern, v):
            raise ValueError("Invalid email format")
        return v.lower()

    @model_validator(mode="after")
    def check_age_for_website(self) -> "SignupForm":
        if self.age < 18 and self.website:
            raise ValueError("Users under 18 cannot add websites")
        return self

# Valid form
form = SignupForm(
    username="Alice123",
    password="SecurePass1",
    email="Alice@Example.COM",
    age=25
)
print(f"Username: {form.username}")  # alice123 (normalized)
print(f"Email: {form.email}")        # alice@example.com (normalized)

# ── NESTED MODELS ─────────────────

class Address(BaseModel):
    street: str
    city: str
    country: str = "US"
    zip_code: Optional[str] = None

class Company(BaseModel):
    name: str
    address: Address
    employees: list[User] = []

company = Company(
    name="Acme Corp",
    address={"street": "123 Main St", "city": "NYC"},  # dict auto-converted!
    employees=[
        {"id": 1, "name": "Alice", "email": "alice@acme.com"},
        {"id": 2, "name": "Bob",   "email": "bob@acme.com"},
    ]
)
print(company.address.city)      # NYC (Address object!)
print(company.employees[0].name) # Alice (User object!)
print(company.model_dump())      # fully nested dict

# ── SETTINGS MANAGEMENT ───────────

from pydantic_settings import BaseSettings  # pip install pydantic-settings

class Settings(BaseSettings):
    app_name: str = "MyApp"
    debug: bool = False
    database_url: str = "sqlite:///dev.db"
    secret_key: str = "dev-secret-change-in-prod"
    max_connections: int = 10
    allowed_hosts: list[str] = ["localhost"]

    model_config = ConfigDict(
        env_file=".env",          # load from .env file
        env_file_encoding="utf-8",
        env_prefix="APP_",        # APP_DEBUG, APP_DATABASE_URL, etc.
        case_sensitive=False,
    )

# settings = Settings()  # reads from env + .env file
# print(settings.database_url)

# ── JSON SCHEMA ───────────────────

print(Product.model_json_schema())
# Generates OpenAPI-compatible JSON schema

# ── IMMUTABLE MODELS ──────────────

class ImmutablePoint(BaseModel):
    model_config = ConfigDict(frozen=True)
    x: float
    y: float

p = ImmutablePoint(x=1.0, y=2.0)
try:
    p.x = 5.0   # ValidationError!
except Exception as e:
    print(f"Immutable: {e}")

# Can be used as dict key (hashable when frozen)
d = {p: "origin"}
'''

print("Pydantic examples ready!")
print("Install: pip install pydantic pydantic-settings")

# Actual runnable summary (no pydantic import needed for display)
print('''
Pydantic Key Concepts:
  BaseModel     → base class for all models
  Field(...)    → required field
  Field(None)   → optional field
  Field(gt=0)   → validated field (gt/lt/ge/le/min_length/max_length/pattern)
  @field_validator → custom field validation
  @model_validator → cross-field validation
  model.model_dump()      → to dict
  model.model_dump_json() → to JSON string
  Model(**dict) → from dict (auto-validates)
  ValidationError → raised with clear messages
''')

📝 KEY POINTS:
✅ Pydantic validates data at runtime using type hints — catches bad data early
✅ Field(...) means required; Field(None) means optional
✅ Pydantic coerces compatible types (string "42" → int 42)
✅ Nested models: pass a dict and Pydantic constructs the nested model
✅ @field_validator for per-field custom logic
✅ @model_validator(mode="after") for cross-field validation
✅ frozen=True makes models immutable and hashable
✅ pydantic-settings for environment variable management
❌ Don't catch and ignore ValidationError silently — it carries important information
❌ Pydantic V1 and V2 have different APIs — check which version you have
❌ Don't use Pydantic for pure data containers that never receive external input — dataclass is sufficient
""",
  quiz: [
    Quiz(question: 'What does Field(...) mean in a Pydantic model?', options: [
      QuizOption(text: 'An optional field that defaults to None', correct: false),
      QuizOption(text: 'A required field — ... (Ellipsis) signals no default', correct: true),
      QuizOption(text: 'A field that accepts any type', correct: false),
      QuizOption(text: 'A field that gets validated only on export', correct: false),
    ]),
    Quiz(question: 'What happens when you pass a string "42" to an int field in Pydantic?', options: [
      QuizOption(text: 'A ValidationError is raised immediately', correct: false),
      QuizOption(text: 'Pydantic coerces it to the integer 42', correct: true),
      QuizOption(text: 'It is stored as the string "42" unchanged', correct: false),
      QuizOption(text: 'The field is set to None', correct: false),
    ]),
    Quiz(question: 'What does model_config = ConfigDict(frozen=True) do?', options: [
      QuizOption(text: 'Prevents the model class from being subclassed', correct: false),
      QuizOption(text: 'Makes model instances immutable — fields cannot be changed after creation', correct: true),
      QuizOption(text: 'Disables validation for better performance', correct: false),
      QuizOption(text: 'Freezes the JSON schema', correct: false),
    ]),
  ],
);
