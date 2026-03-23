import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson88 = Lesson(
  language: 'Python',
  title: 'Intro to Flask',
  content: '''
🎯 WHAT IS FLASK?
Flask is Python's most popular micro web framework.
"Micro" doesn't mean small or limited — it means Flask
gives you the CORE and gets out of your way. No forced
ORM. No mandatory project structure. No built-in admin.
You choose every component: which database library,
which authentication system, which template engine.
Total control. Maximum flexibility. Minimal magic.

Flask is built on two libraries:
  Werkzeug — the WSGI toolkit (routing, request/response)
  Jinja2   — the template engine (HTML generation)

─────────────────────────────────────
💡 FLASK IN ONE SENTENCE
─────────────────────────────────────
Flask maps URL routes to Python functions
and returns HTTP responses.

─────────────────────────────────────
🎯 WHEN TO USE FLASK
─────────────────────────────────────
✅ Small to medium web APIs
✅ Microservices where each service is tiny
✅ Rapid prototyping — fastest to get running
✅ When you want to choose your own components
✅ Learning web development fundamentals
✅ Internal tools, dashboards, webhooks
✅ Projects where Django's conventions feel heavy

❌ Don't use Flask when:
  • You need async performance (use FastAPI instead)
  • You need a built-in ORM + admin panel (use Django)
  • Your team prefers strict conventions over flexibility

─────────────────────────────────────
🚀 GETTING STARTED
─────────────────────────────────────
Install:
  pip install flask

The simplest Flask app (5 lines!):
  from flask import Flask
  app = Flask(__name__)

  @app.route("/")
  def home():
      return "Hello, World!"

  app.run()

Run: python app.py
Open: http://127.0.0.1:5000

─────────────────────────────────────
📐 CORE CONCEPTS
─────────────────────────────────────
Routes:      @app.route("/path") links URL to function
Views:       The function that handles a route
Request:     flask.request — incoming HTTP data
Response:    Return string, dict, or Response object
Templates:   Jinja2 .html files rendered with render_template()
Blueprints:  Organize routes into reusable modules
Config:      app.config["KEY"] = value

─────────────────────────────────────
📦 FLASK ECOSYSTEM
─────────────────────────────────────
Flask-SQLAlchemy  → SQLAlchemy ORM integration
Flask-Login       → User session management
Flask-JWT-Extended → JWT authentication
Flask-Migrate     → Database migrations
Flask-CORS        → Cross-Origin Resource Sharing
Flask-Limiter     → Rate limiting
Flask-Caching     → Caching layer
Flask-SocketIO    → WebSocket support
Marshmallow       → Serialization + validation
Flasgger/apispec  → OpenAPI documentation

─────────────────────────────────────
📁 RECOMMENDED PROJECT STRUCTURE
─────────────────────────────────────
my_flask_app/
├── app/
│   ├── __init__.py      ← create_app() factory
│   ├── models.py        ← database models
│   ├── routes/
│   │   ├── __init__.py
│   │   ├── users.py     ← user Blueprint
│   │   └── posts.py     ← posts Blueprint
│   ├── templates/       ← Jinja2 HTML templates
│   └── static/          ← CSS, JS, images
├── tests/
├── config.py
├── requirements.txt
└── run.py

─────────────────────────────────────
📖 DOCUMENTATION & LEARNING
─────────────────────────────────────
Official docs:   https://flask.palletsprojects.com
Tutorial:        https://flask.palletsprojects.com/tutorial/
Mega-Tutorial:   https://blog.miguelgrinberg.com/post/the-flask-mega-tutorial-part-i-hello-world
  (Miguel Grinberg's Flask Mega-Tutorial — the BEST Flask course)

📚 Recommended Resources:
  • Miguel Grinberg's Flask Mega-Tutorial (free, comprehensive)
  • Real Python Flask tutorials: realpython.com/flask-by-example
  • "Flask Web Development" by Miguel Grinberg (O'Reilly book)

💻 CODE:
# ── A REAL FLASK APPLICATION ───────

# Install first: pip install flask flask-sqlalchemy

FULL_FLASK_EXAMPLE = """
from flask import Flask, request, jsonify, abort
from datetime import datetime
from functools import wraps

# Create the application
app = Flask(__name__)
app.config["DEBUG"] = True
app.config["SECRET_KEY"] = "change-me-in-production"

# ── In-memory "database" for demo ──
users = {
    1: {"id": 1, "name": "Alice", "email": "alice@ex.com", "active": True},
    2: {"id": 2, "name": "Bob",   "email": "bob@ex.com",   "active": True},
}
next_id = 3

# ── MIDDLEWARE / DECORATORS ────────

def require_api_key(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        key = request.headers.get("X-API-Key")
        if key != "secret-key-123":
            abort(401)
        return f(*args, **kwargs)
    return decorated

# ── ROUTES ────────────────────────

@app.route("/")
def index():
    return jsonify({
        "message": "Welcome to the Flask API",
        "version": "1.0.0",
        "endpoints": ["/users", "/users/<id>"]
    })

@app.route("/users", methods=["GET"])
def list_users():
    active_only = request.args.get("active", "false").lower() == "true"
    result = list(users.values())
    if active_only:
        result = [u for u in result if u["active"]]
    return jsonify(result)

@app.route("/users/<int:user_id>", methods=["GET"])
def get_user(user_id):
    user = users.get(user_id)
    if not user:
        abort(404, description=f"User {user_id} not found")
    return jsonify(user)

@app.route("/users", methods=["POST"])
@require_api_key
def create_user():
    global next_id
    data = request.get_json()

    # Validate
    if not data:
        abort(400, description="Request body must be JSON")
    if "name" not in data or "email" not in data:
        abort(400, description="name and email are required")

    user = {
        "id": next_id,
        "name": data["name"],
        "email": data["email"],
        "active": data.get("active", True),
        "created_at": datetime.now().isoformat(),
    }
    users[next_id] = user
    next_id += 1
    return jsonify(user), 201

@app.route("/users/<int:user_id>", methods=["PUT"])
@require_api_key
def update_user(user_id):
    if user_id not in users:
        abort(404)
    data = request.get_json()
    users[user_id].update(data)
    return jsonify(users[user_id])

@app.route("/users/<int:user_id>", methods=["DELETE"])
@require_api_key
def delete_user(user_id):
    if user_id not in users:
        abort(404)
    deleted = users.pop(user_id)
    return jsonify({"deleted": deleted})

# ── ERROR HANDLERS ────────────────

@app.errorhandler(400)
def bad_request(e):
    return jsonify({"error": "Bad Request", "detail": str(e)}), 400

@app.errorhandler(401)
def unauthorized(e):
    return jsonify({"error": "Unauthorized"}), 401

@app.errorhandler(404)
def not_found(e):
    return jsonify({"error": "Not Found", "detail": str(e)}), 404

@app.errorhandler(500)
def server_error(e):
    return jsonify({"error": "Internal Server Error"}), 500

# ── BEFORE/AFTER REQUEST HOOKS ───

@app.before_request
def log_request():
    print(f"→ {request.method} {request.path}")

@app.after_request
def add_headers(response):
    response.headers["X-Powered-By"] = "Flask"
    return response

# ── BLUEPRINTS (modular routes) ───

from flask import Blueprint

auth_bp = Blueprint("auth", __name__, url_prefix="/auth")

@auth_bp.route("/login", methods=["POST"])
def login():
    data = request.get_json()
    # ... validate credentials, return token
    return jsonify({"token": "fake-jwt-token"})

@auth_bp.route("/logout", methods=["POST"])
def logout():
    return jsonify({"message": "Logged out"})

app.register_blueprint(auth_bp)

# ── JINJA2 TEMPLATES ──────────────

# templates/users.html:
# <!DOCTYPE html>
# <html>
# <body>
#   <h1>Users</h1>
#   {% for user in users %}
#     <p>{{ user.name }} — {{ user.email }}</p>
#   {% endfor %}
# </body>
# </html>

from flask import render_template

@app.route("/users/page")
def users_page():
    return render_template("users.html", users=list(users.values()))

# ── RUN ───────────────────────────

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)

# Production: use gunicorn instead of app.run()!
# gunicorn "app:create_app()" --workers 4 --bind 0.0.0.0:5000
"""

print("Flask overview loaded!")
print()
print("Quick start:")
print("  pip install flask")
print("  python -c \\"")
print("  from flask import Flask")
print("  app = Flask(__name__)")
print("  @app.route(\\'/')") 
print("  def home(): return \\'Hello World!\\'")
print("  app.run()")
print("\\"")
print()
print("Then visit: http://127.0.0.1:5000")

📝 KEY POINTS:
✅ Flask is a micro-framework — you start with the minimum and add what you need
✅ Routes: @app.route("/path", methods=["GET","POST"]) → function
✅ request object gives you everything about the incoming HTTP request
✅ return jsonify(dict) for JSON APIs; render_template() for HTML
✅ Blueprints organize routes into reusable, logical groups
✅ Use Flask application factory pattern (create_app()) for testability
✅ NEVER run app.run() in production — use gunicorn or uWSGI
✅ Miguel Grinberg's Flask Mega-Tutorial is the definitive learning resource
❌ Don't hardcode SECRET_KEY — use environment variables in production
❌ app.run(debug=True) in production is a massive security risk
❌ Flask has no async support by default — for async use FastAPI or Quart
''',
  quiz: [
    Quiz(question: 'What does "micro" mean in Flask micro-framework?', options: [
      QuizOption(text: 'Flask is only suitable for small applications', correct: false),
      QuizOption(text: 'Flask provides the core with minimal decisions forced on you — you choose your own components', correct: true),
      QuizOption(text: 'Flask has fewer than 1000 lines of code', correct: false),
      QuizOption(text: 'Flask does not support templates or databases', correct: false),
    ]),
    Quiz(question: 'What is the purpose of Flask Blueprints?', options: [
      QuizOption(text: 'To provide a built-in admin interface', correct: false),
      QuizOption(text: 'To organize routes into reusable, modular components', correct: true),
      QuizOption(text: 'To automatically generate database schemas', correct: false),
      QuizOption(text: 'To handle blueprint CSS for Jinja2 templates', correct: false),
    ]),
    Quiz(question: 'How should you run a Flask app in production?', options: [
      QuizOption(text: 'app.run() — the built-in development server', correct: false),
      QuizOption(text: 'With a production WSGI server like gunicorn or uWSGI', correct: true),
      QuizOption(text: 'python -m flask run --production', correct: false),
      QuizOption(text: 'Flask includes its own production-ready server', correct: false),
    ]),
  ],
);
