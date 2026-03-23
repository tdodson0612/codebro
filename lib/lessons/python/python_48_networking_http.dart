import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson48 = Lesson(
  language: 'Python',
  title: 'Networking & HTTP',
  content: """
🎯 METAPHOR:
HTTP requests are like sending a formal letter to a business.
You put your letter in an envelope (the request body),
write the address (URL), label the type of request (GET/POST),
add any required ID cards (headers, auth tokens), and send it.
The business reads your letter, processes it, and sends back
a response in their own envelope with a status code
on the outside (200 OK, 404 NOT FOUND) and their answer inside.
Python's requests library is your personal secretary who
handles all the envelope-stuffing and post-office logistics.

📖 EXPLANATION:
Python provides several tools for networking:
  urllib (built-in): basic HTTP
  http.client (built-in): lower-level HTTP
  requests (third-party): the standard, user-friendly choice
  httpx (third-party): async-capable, modern requests
  aiohttp (third-party): async HTTP client/server
  socket (built-in): raw TCP/UDP networking

─────────────────────────────────────
🌐 HTTP FUNDAMENTALS
─────────────────────────────────────
Methods:
  GET    → retrieve data (no body)
  POST   → submit data (body)
  PUT    → replace resource (body)
  PATCH  → partial update (body)
  DELETE → remove resource
  HEAD   → GET but response body only
  OPTIONS → what methods are supported?

Status Codes:
  2xx — Success: 200 OK, 201 Created, 204 No Content
  3xx — Redirect: 301 Moved, 302 Found, 304 Not Modified
  4xx — Client Error: 400 Bad Request, 401 Unauthorized,
         403 Forbidden, 404 Not Found, 429 Too Many Requests
  5xx — Server Error: 500 Internal, 502 Bad Gateway, 503 Unavailable

Headers:
  Content-Type: application/json
  Authorization: Bearer <token>
  Accept: application/json
  User-Agent: MyApp/1.0

─────────────────────────────────────
📦 REQUESTS LIBRARY
─────────────────────────────────────
pip install requests

import requests
r = requests.get(url, params={}, headers={}, timeout=5)
r.status_code    → int
r.text           → response as string
r.json()         → response as dict (if JSON)
r.content        → response as bytes
r.headers        → response headers dict
r.raise_for_status() → raise HTTPError if 4xx/5xx

─────────────────────────────────────
🔒 AUTHENTICATION
─────────────────────────────────────
Basic Auth:  requests.get(url, auth=("user", "pass"))
Bearer:      headers={"Authorization": "Bearer token"}
API Key:     params={"api_key": "key"}
OAuth:       requests_oauthlib or authlib libraries

─────────────────────────────────────
🔄 SESSIONS
─────────────────────────────────────
Session persists cookies, headers, and connection pool:
with requests.Session() as session:
    session.headers.update({"Authorization": "Bearer token"})
    r = session.get(url)

💻 CODE:
import json
import urllib.request
import urllib.parse
from http import HTTPStatus

# ── URLLIB (BUILT-IN) ──────────────

# Simple GET request
url = "https://httpbin.org/get"
with urllib.request.urlopen(url) as response:
    data = json.loads(response.read().decode())
    print(data["url"])

# POST with urllib
post_data = json.dumps({"name": "Alice", "age": 30}).encode("utf-8")
req = urllib.request.Request(
    "https://httpbin.org/post",
    data=post_data,
    headers={"Content-Type": "application/json"},
    method="POST"
)
with urllib.request.urlopen(req) as response:
    result = json.loads(response.read())
    print(result["json"])   # echoed back by httpbin

# ── REQUESTS (THIRD-PARTY) ─────────
# pip install requests
# import requests

# GET request
# r = requests.get("https://api.github.com/users/python", timeout=5)
# print(r.status_code)     # 200
# print(r.headers["Content-Type"])
# data = r.json()
# print(data["name"])      # Python

# Query parameters
# r = requests.get(
#     "https://httpbin.org/get",
#     params={"q": "python", "page": 1},
#     timeout=5
# )
# print(r.url)    # https://httpbin.org/get?q=python&page=1

# POST JSON
# r = requests.post(
#     "https://httpbin.org/post",
#     json={"name": "Alice", "score": 95},   # auto-sets Content-Type
#     timeout=5
# )
# print(r.json()["json"])

# Error handling
# try:
#     r = requests.get("https://httpbin.org/status/404", timeout=5)
#     r.raise_for_status()   # raises HTTPError for 4xx/5xx
# except requests.exceptions.HTTPError as e:
#     print(f"HTTP Error: {e}")
# except requests.exceptions.Timeout:
#     print("Request timed out!")
# except requests.exceptions.ConnectionError:
#     print("Cannot connect!")

# Authentication
# r = requests.get(url, auth=("user", "password"))    # Basic Auth
# r = requests.get(url, headers={"Authorization": f"Bearer {token}"})
# r = requests.get(url, params={"api_key": api_key})

# Session (connection pooling + shared headers)
# with requests.Session() as session:
#     session.headers.update({
#         "Authorization": f"Bearer {token}",
#         "Accept": "application/json",
#         "User-Agent": "MyApp/1.0"
#     })
#     users = session.get("https://api.example.com/users").json()
#     posts = session.get("https://api.example.com/posts").json()

# ── SIMPLE HTTP SERVER ─────────────

from http.server import HTTPServer, BaseHTTPRequestHandler

class SimpleHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/":
            self.send_response(200)
            self.send_header("Content-Type", "text/html")
            self.end_headers()
            self.wfile.write(b"<h1>Hello World!</h1>")
        elif self.path == "/api/status":
            self.send_response(200)
            self.send_header("Content-Type", "application/json")
            self.end_headers()
            response = json.dumps({"status": "ok", "version": "1.0"})
            self.wfile.write(response.encode())
        else:
            self.send_response(404)
            self.end_headers()

    def do_POST(self):
        length = int(self.headers.get("Content-Length", 0))
        body = self.rfile.read(length)
        data = json.loads(body)
        print(f"Received: {data}")
        self.send_response(201)
        self.send_header("Content-Type", "application/json")
        self.end_headers()
        resp = json.dumps({"received": data, "id": 42})
        self.wfile.write(resp.encode())

    def log_message(self, format, *args):
        pass   # silence default logging

# Uncomment to run:
# server = HTTPServer(("localhost", 8080), SimpleHandler)
# print("Server at http://localhost:8080")
# server.serve_forever()

# ── RAW SOCKET ────────────────────

import socket

# TCP Client
def tcp_get(host, path="/"):
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.connect((host, 80))
        request = f"GET {path} HTTP/1.1\\r\\nHost: {host}\\r\\nConnection: close\\r\\n\\r\\n"
        s.sendall(request.encode())
        response = b""
        while chunk := s.recv(4096):
            response += chunk
        headers, _, body = response.partition(b"\\r\\n\\r\\n")
        return headers.decode(), body.decode()

# TCP Server
def start_echo_server(port=9999):
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as server:
        server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        server.bind(("localhost", port))
        server.listen(5)
        print(f"Echo server on port {port}")
        # while True:
        #     conn, addr = server.accept()
        #     with conn:
        #         data = conn.recv(1024)
        #         conn.sendall(data)  # echo back

# ── ASYNC HTTP WITH AIOHTTP ────────

# pip install aiohttp
# import aiohttp
# import asyncio
#
# async def fetch(session, url):
#     async with session.get(url) as response:
#         return await response.json()
#
# async def fetch_all(urls):
#     async with aiohttp.ClientSession() as session:
#         tasks = [fetch(session, url) for url in urls]
#         return await asyncio.gather(*tasks)
#
# urls = [
#     "https://api.example.com/user/1",
#     "https://api.example.com/user/2",
#     "https://api.example.com/user/3",
# ]
# results = asyncio.run(fetch_all(urls))
# for r in results:
#     print(r)

# ── URL PARSING ────────────────────

from urllib.parse import urlparse, urlencode, quote, unquote, urljoin

url = "https://api.example.com:8080/v2/users?page=1&limit=10#results"
parsed = urlparse(url)
print(parsed.scheme)    # https
print(parsed.netloc)    # api.example.com:8080
print(parsed.path)      # /v2/users
print(parsed.query)     # page=1&limit=10
print(parsed.fragment)  # results

# Build query string
params = {"q": "python tutorials", "page": 1, "sort": "date"}
query = urlencode(params)
print(query)   # q=python+tutorials&page=1&sort=date

# URL encoding
raw = "Hello World & Goodbye/Farewell"
encoded = quote(raw)
print(encoded)   # Hello%20World%20%26%20Goodbye%2FFarewell
print(unquote(encoded))

# Join URLs
base = "https://api.example.com/v1/"
print(urljoin(base, "users"))        # https://api.example.com/v1/users
print(urljoin(base, "/admin"))       # https://api.example.com/admin
print(urljoin(base, "users/42"))     # https://api.example.com/v1/users/42

📝 KEY POINTS:
✅ Use requests library for HTTP — much simpler than urllib
✅ Always set a timeout on HTTP requests — never leave them open indefinitely
✅ Use session.raise_for_status() to automatically handle error status codes
✅ Use sessions for multiple requests to the same server (connection pooling)
✅ aiohttp for async HTTP (high-throughput services)
✅ urllib.parse for URL manipulation
❌ Never hardcode credentials — use environment variables
❌ Don't ignore SSL certificate verification in production (verify=False)
❌ Always handle timeout and connection errors — networks are unreliable
""",
  quiz: [
    Quiz(question: 'What HTTP method should you use to retrieve data without side effects?', options: [
      QuizOption(text: 'POST', correct: false),
      QuizOption(text: 'GET', correct: true),
      QuizOption(text: 'PUT', correct: false),
      QuizOption(text: 'FETCH', correct: false),
    ]),
    Quiz(question: 'What does raise_for_status() do in the requests library?', options: [
      QuizOption(text: 'Raises an error if the connection failed', correct: false),
      QuizOption(text: 'Raises an HTTPError if the response status code is 4xx or 5xx', correct: true),
      QuizOption(text: 'Returns True if the status is 200', correct: false),
      QuizOption(text: 'Retries the request if it failed', correct: false),
    ]),
    Quiz(question: 'Why should you use a requests.Session() for multiple requests?', options: [
      QuizOption(text: 'Sessions enable async requests', correct: false),
      QuizOption(text: 'Sessions persist cookies, headers, and reuse TCP connections (pooling)', correct: true),
      QuizOption(text: 'Sessions are required for POST requests', correct: false),
      QuizOption(text: 'Sessions automatically retry failed requests', correct: false),
    ]),
  ],
);
