import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson71 = Lesson(
  language: 'Python',
  title: 'Working with REST APIs',
  content: '''
🎯 METAPHOR:
A REST API is like a restaurant menu with a specific ordering system.
The menu (API documentation) tells you what dishes (endpoints) exist,
what format to order them in (request format), and what you'll receive
(response format). GET is browsing the menu or asking "what's today's
special?" POST is placing a new order. PUT is changing your existing
order. DELETE is canceling it. The waiter (HTTP) carries requests
and responses. The kitchen (server) does the work. Authentication
is showing your reservation card — without it, no table.

📖 EXPLANATION:
REST (Representational State Transfer) APIs use HTTP methods
to perform operations on resources. Python's requests library
is the standard tool for consuming APIs.

─────────────────────────────────────
🌐 REST CONVENTIONS
─────────────────────────────────────
GET    /users          → list users
GET    /users/42       → get user 42
POST   /users          → create user
PUT    /users/42       → replace user 42
PATCH  /users/42       → update fields of user 42
DELETE /users/42       → delete user 42

─────────────────────────────────────
📦 HEADERS
─────────────────────────────────────
Content-Type: application/json    → body is JSON
Accept: application/json          → want JSON back
Authorization: Bearer <token>     → JWT auth
X-API-Key: <key>                  → API key auth

─────────────────────────────────────
🔑 AUTHENTICATION PATTERNS
─────────────────────────────────────
API Key:   params={"api_key": key} or header
Bearer:    headers={"Authorization": f"Bearer {token}"}
Basic:     requests.get(url, auth=("user", "pass"))
OAuth2:    use requests_oauthlib or authlib library

─────────────────────────────────────
🏗️  BEST PRACTICES
─────────────────────────────────────
Always set timeout= — never leave requests hanging
Handle errors with raise_for_status()
Use sessions for multiple requests
Implement retry logic for transient failures
Respect rate limits (429 Too Many Requests)
Parse response JSON defensively (validate fields)

💻 CODE:
import json
import time
import os
from typing import Any, Optional
from urllib import request, parse, error

# ── SIMPLE REQUESTS (urllib, no install needed) ──

def http_get(url: str, params: dict = None) -> dict:
    """Simple GET request using urllib."""
    if params:
        url = url + "?" + parse.urlencode(params)
    req = request.Request(url, headers={"Accept": "application/json"})
    try:
        with request.urlopen(req, timeout=10) as resp:
            return json.loads(resp.read().decode())
    except error.HTTPError as e:
        print(f"HTTP {e.code}: {e.reason}")
        return {}
    except error.URLError as e:
        print(f"Connection error: {e.reason}")
        return {}

# Test with a free public API
result = http_get("https://httpbin.org/get", params={"hello": "world"})
print(result.get("args", {}))   # {'hello': 'world'}

# ── REQUESTS-STYLE PATTERNS (shown as examples) ──

# All patterns below are shown as code that would work
# once you have requests installed (pip install requests)

API_CLIENT_EXAMPLE = """
import requests
import time
from functools import wraps

class APIClient:
    """Reusable API client with auth, retry, and rate limiting."""

    def __init__(self, base_url: str, api_key: str = None, token: str = None):
        self.base_url = base_url.rstrip("/")
        self.session = requests.Session()
        self.session.headers.update({
            "Accept": "application/json",
            "Content-Type": "application/json",
        })
        if api_key:
            self.session.headers["X-API-Key"] = api_key
        if token:
            self.session.headers["Authorization"] = f"Bearer {token}"

    def _url(self, path: str) -> str:
        return f"{self.base_url}/{path.lstrip('/')}"

    def _request(self, method: str, path: str, **kwargs) -> dict:
        """Make a request with error handling."""
        kwargs.setdefault("timeout", 10)
        resp = self.session.request(method, self._url(path), **kwargs)
        resp.raise_for_status()   # raises HTTPError for 4xx/5xx
        return resp.json() if resp.content else {}

    def get(self, path: str, params: dict = None) -> dict:
        return self._request("GET", path, params=params)

    def post(self, path: str, data: dict) -> dict:
        return self._request("POST", path, json=data)

    def put(self, path: str, data: dict) -> dict:
        return self._request("PUT", path, json=data)

    def patch(self, path: str, data: dict) -> dict:
        return self._request("PATCH", path, json=data)

    def delete(self, path: str) -> dict:
        return self._request("DELETE", path)

    def __enter__(self):
        return self

    def __exit__(self, *args):
        self.session.close()

# Usage
with APIClient("https://api.example.com", api_key="sk_live_xxx") as client:
    users = client.get("/users", params={"page": 1, "limit": 20})
    new_user = client.post("/users", {"name": "Alice", "email": "alice@ex.com"})
    updated  = client.patch(f"/users/{new_user['id']}", {"active": True})
    client.delete(f"/users/{new_user['id']}")
"""

# ── RETRY WITH BACKOFF ─────────────

RETRY_EXAMPLE = """
import requests
import time
import random
from functools import wraps

def retry_on_failure(max_retries=3, base_delay=1.0, exceptions=(Exception,)):
    """Decorator that retries on failure with exponential backoff."""
    def decorator(func):
        @wraps(func)
        def wrapper(*args, **kwargs):
            for attempt in range(1, max_retries + 1):
                try:
                    return func(*args, **kwargs)
                except exceptions as e:
                    if attempt == max_retries:
                        raise
                    delay = base_delay * (2 ** (attempt - 1))
                    jitter = random.uniform(0, delay * 0.1)
                    print(f"Attempt {attempt} failed: {e}. Retrying in {delay+jitter:.2f}s")
                    time.sleep(delay + jitter)
        return wrapper
    return decorator

@retry_on_failure(max_retries=3, base_delay=1.0,
                  exceptions=(requests.exceptions.RequestException,))
def fetch_user(user_id: int) -> dict:
    resp = requests.get(
        f"https://api.example.com/users/{user_id}",
        timeout=5
    )
    resp.raise_for_status()
    return resp.json()
"""

# ── PAGINATION ─────────────────────

PAGINATION_EXAMPLE = """
import requests

def get_all_pages(url: str, params: dict = None, session=None) -> list:
    """Fetch all pages of a paginated API."""
    get = (session or requests).get
    results = []
    page = 1
    params = (params or {}).copy()

    while True:
        params["page"] = page
        resp = get(url, params=params, timeout=10)
        resp.raise_for_status()
        data = resp.json()

        # Common pagination patterns:
        items = data.get("data") or data.get("results") or data.get("items", [])
        if not items:
            break
        results.extend(items)

        # Check if more pages
        if not data.get("next") and not data.get("has_more"):
            break
        page += 1

    return results

# Usage
all_users = get_all_pages(
    "https://api.example.com/users",
    params={"limit": 100}
)
print(f"Total users: {len(all_users)}")
"""

# ── RATE LIMITING ──────────────────

RATE_LIMIT_EXAMPLE = """
import time
from collections import deque

class RateLimitedClient:
    """Client that respects rate limits."""

    def __init__(self, calls_per_second: float = 5):
        self.min_interval = 1.0 / calls_per_second
        self.last_call = 0

    def _wait_if_needed(self):
        elapsed = time.monotonic() - self.last_call
        if elapsed < self.min_interval:
            time.sleep(self.min_interval - elapsed)
        self.last_call = time.monotonic()

    def get(self, url: str, **kwargs):
        self._wait_if_needed()
        import requests
        return requests.get(url, **kwargs)

# Handle 429 Too Many Requests
def get_with_rate_limit(url: str, **kwargs) -> dict:
    import requests
    for attempt in range(5):
        resp = requests.get(url, **kwargs)
        if resp.status_code == 429:
            retry_after = int(resp.headers.get("Retry-After", 60))
            print(f"Rate limited. Waiting {retry_after}s...")
            time.sleep(retry_after)
            continue
        resp.raise_for_status()
        return resp.json()
    raise RuntimeError("Rate limit retries exhausted")
"""

# ── WEBHOOK RECEIVER (server side) ─

WEBHOOK_EXAMPLE = """
from flask import Flask, request, jsonify
import hmac, hashlib

app = Flask(__name__)
WEBHOOK_SECRET = os.environ["WEBHOOK_SECRET"]

@app.route("/webhook", methods=["POST"])
def handle_webhook():
    # Verify signature (GitHub-style)
    signature = request.headers.get("X-Hub-Signature-256", "")
    body = request.get_data()
    expected = "sha256=" + hmac.new(
        WEBHOOK_SECRET.encode(),
        body,
        hashlib.sha256
    ).hexdigest()

    if not hmac.compare_digest(signature, expected):
        return jsonify({"error": "Invalid signature"}), 401

    event = request.headers.get("X-GitHub-Event", "")
    payload = request.json

    if event == "push":
        repo = payload["repository"]["name"]
        branch = payload["ref"].split("/")[-1]
        commits = payload.get("commits", [])
        print(f"Push to {repo}/{branch}: {len(commits)} commits")

    return jsonify({"status": "received"}), 200
"""

# ── WORKING WITH A REAL FREE API ───

# JSONPlaceholder — free fake REST API for testing
def demo_jsonplaceholder():
    base = "https://jsonplaceholder.typicode.com"

    # Get a post
    result = http_get(f"{base}/posts/1")
    print(f"Post title: {result.get('title', 'N/A')}")

    # Get comments
    comments = http_get(f"{base}/comments", {"postId": 1})
    if isinstance(comments, list):
        print(f"Comments on post 1: {len(comments)}")

    # Get users
    users = http_get(f"{base}/users")
    if isinstance(users, list):
        for user in users[:3]:
            print(f"  {user.get('name')}: {user.get('email')}")

demo_jsonplaceholder()

📝 KEY POINTS:
✅ Always set timeout= — never leave requests open indefinitely
✅ Use raise_for_status() to auto-raise on 4xx/5xx responses
✅ Use sessions for multiple requests to the same server (connection pooling)
✅ Implement retry with exponential backoff for transient failures
✅ Handle 429 Too Many Requests — check Retry-After header
✅ Paginate: keep fetching until no more pages
✅ Verify webhook signatures before processing payloads
❌ Never hardcode API keys — use environment variables
❌ Don't ignore SSL errors (verify=False) in production
❌ Don't make requests in tight loops without rate limiting
''',
  quiz: [
    Quiz(question: 'What HTTP method should you use to partially update a resource?', options: [
      QuizOption(text: 'PUT — replace the entire resource', correct: false),
      QuizOption(text: 'PATCH — update only the specified fields', correct: true),
      QuizOption(text: 'POST — create or update', correct: false),
      QuizOption(text: 'UPDATE — dedicated update method', correct: false),
    ]),
    Quiz(question: 'What does raise_for_status() do?', options: [
      QuizOption(text: 'Returns the HTTP status code as an integer', correct: false),
      QuizOption(text: 'Raises an HTTPError if the response status code is 4xx or 5xx', correct: true),
      QuizOption(text: 'Retries the request on any error', correct: false),
      QuizOption(text: 'Logs the status code to the console', correct: false),
    ]),
    Quiz(question: 'Why is exponential backoff used in retry logic?', options: [
      QuizOption(text: 'To make retries faster over time', correct: false),
      QuizOption(text: 'To avoid hammering a struggling server and allow it time to recover', correct: true),
      QuizOption(text: 'It is required by the HTTP specification', correct: false),
      QuizOption(text: 'To ensure exactly 3 retries always happen', correct: false),
    ]),
  ],
);
