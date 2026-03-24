import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson58 = Lesson(
  language: 'Python',
  title: 'Security Best Practices in Python',
  content: """
🎯 METAPHOR:
Security is like building locks for a bank vault, not a diary.
Most developers build diary locks: technically a lock, but any
determined teenager can pick it. Bank vault design asks:
"What's the worst an attacker could do, and how do we stop it?"
SQL injection, hardcoded secrets, deserializing untrusted data —
these are picked diary locks. The attacker doesn't need to guess
your password if you've written it on a sticky note outside the
vault (hardcoded secrets) or if they can just tell the vault to
open itself (SQL injection). Security is about removing that
sticky note and wiring the vault to not take instructions from
strangers.

📖 EXPLANATION:
Common Python security pitfalls and how to prevent them.
SQL injection, secret management, input validation,
cryptography, and safe deserialization.

─────────────────────────────────────
🔑 TOP SECURITY RULES
─────────────────────────────────────
1. Never hardcode secrets (API keys, passwords)
2. Always use parameterized SQL queries
3. Never pickle untrusted data
4. Validate and sanitize all user input
5. Use secrets module for tokens, not random
6. Hash passwords with bcrypt/argon2, not md5/sha1
7. Use HTTPS (ssl module / requests verify=True)
8. Keep dependencies updated (pip audit)
9. Use least privilege principle
10. Log security events, never log secrets

─────────────────────────────────────
🌍 ENVIRONMENT VARIABLES FOR SECRETS
─────────────────────────────────────
Never hardcode in source!
Store in .env file (gitignored) or OS env vars.
Use python-dotenv to load .env:
  pip install python-dotenv

─────────────────────────────────────
🔐 SECRETS MODULE
─────────────────────────────────────
Use secrets (not random!) for:
  • Tokens
  • Password reset URLs
  • API keys
  • Session IDs

secrets.token_bytes(32)    → 32 random bytes
secrets.token_hex(32)      → 64-char hex string
secrets.token_urlsafe(32)  → URL-safe base64 string
secrets.compare_digest(a, b) → timing-safe comparison!

─────────────────────────────────────
🔒 PASSWORD HASHING
─────────────────────────────────────
NEVER: md5, sha1, sha256 (too fast!)
USE: bcrypt, argon2, pbkdf2_hmac

pip install bcrypt
pip install argon2-cffi

─────────────────────────────────────
💉 SQL INJECTION PREVENTION
─────────────────────────────────────
ALWAYS use parameterized queries.
NEVER string-format user input into SQL.

─────────────────────────────────────
🚫 DANGEROUS FUNCTIONS
─────────────────────────────────────
eval()       → executes arbitrary Python code
exec()       → same
pickle.loads → arbitrary code execution on untrusted data
subprocess(shell=True) + user input → shell injection
yaml.load()  → use yaml.safe_load() instead
os.system()  → use subprocess.run() instead

💻 CODE:
import os
import secrets
import hashlib
import hmac
import ssl
import subprocess
import re
from pathlib import Path

# ── SECRETS — NEVER USE RANDOM FOR SECURITY ─

# BAD — predictable!
import random
bad_token = "".join([str(random.randint(0,9)) for _ in range(16)])
print(f"Bad token (predictable): {bad_token}")

# GOOD — cryptographically secure
good_token = secrets.token_urlsafe(32)   # 43 chars of secure randomness
good_hex   = secrets.token_hex(32)       # 64 hex chars
good_bytes = secrets.token_bytes(32)     # 32 raw bytes
print(f"Good token: {good_token}")
print(f"Good hex:   {good_hex}")

# Generate API keys
def generate_api_key(prefix="sk") -> str:
    '''Generate a secure API key like OpenAI/Stripe do.'''
    return f"{prefix}_{secrets.token_urlsafe(32)}"

api_key = generate_api_key()
print(f"API key: {api_key}")

# Timing-safe comparison (prevents timing attacks!)
def verify_token(provided: str, stored: str) -> bool:
    return secrets.compare_digest(provided, stored)
    # NEVER use: provided == stored
    # String comparison short-circuits → timing oracle!

# ── ENVIRONMENT VARIABLES ─────────

# .env file (NEVER commit to git!):
# DATABASE_URL=postgresql://user:pass@localhost/mydb
# SECRET_KEY=abc123xyz
# API_KEY=sk_live_xxxx

# Load with python-dotenv:
# from dotenv import load_dotenv
# load_dotenv()

# Access safely with defaults:
db_url    = os.environ.get("DATABASE_URL", "sqlite:///dev.db")
secret    = os.environ.get("SECRET_KEY")
debug_mode = os.environ.get("DEBUG", "false").lower() == "true"

if not secret:
    raise RuntimeError("SECRET_KEY environment variable not set!")

print(f"DB: {db_url}")
print(f"Debug: {debug_mode}")

# ── PASSWORD HASHING ──────────────

# Using hashlib.pbkdf2_hmac (built-in)
def hash_password_pbkdf2(password: str) -> dict:
    salt = secrets.token_bytes(32)
    key = hashlib.pbkdf2_hmac(
        "sha256",
        password.encode("utf-8"),
        salt,
        iterations=600_000   # NIST recommendation 2024
    )
    return {"hash": key.hex(), "salt": salt.hex()}

def verify_password_pbkdf2(password: str, stored_hash: str, stored_salt: str) -> bool:
    salt = bytes.fromhex(stored_salt)
    key = hashlib.pbkdf2_hmac(
        "sha256",
        password.encode("utf-8"),
        salt,
        iterations=600_000
    )
    return secrets.compare_digest(key.hex(), stored_hash)

stored = hash_password_pbkdf2("my_secure_password!")
print(f"Hash: {stored['hash'][:20]}...")
print(f"Verify correct:   {verify_password_pbkdf2('my_secure_password!', stored['hash'], stored['salt'])}")
print(f"Verify wrong:     {verify_password_pbkdf2('wrong_password', stored['hash'], stored['salt'])}")

# Using bcrypt (pip install bcrypt)
# import bcrypt
# hashed = bcrypt.hashpw("password".encode(), bcrypt.gensalt(rounds=12))
# bcrypt.checkpw("password".encode(), hashed)  # True

# ── SQL INJECTION ──────────────────

# VULNERABLE — NEVER DO THIS
def get_user_vulnerable(conn, username):
    # If username = "' OR '1'='1" → returns ALL users!
    query = f"SELECT * FROM users WHERE name = '{username}'"
    return conn.execute(query).fetchall()

# SAFE — always use parameterized queries
def get_user_safe(conn, username):
    return conn.execute(
        "SELECT * FROM users WHERE name = ?",
        (username,)  # always a tuple, never concatenated
    ).fetchall()

# ── INPUT VALIDATION ──────────────

import re
from typing import Optional

def validate_email(email: str) -> bool:
    pattern = r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}\$"
    return bool(re.match(pattern, email))

def validate_username(username: str) -> Optional[str]:
    '''Returns error message or None if valid.'''
    if not username:
        return "Username is required"
    if len(username) < 3 or len(username) > 30:
        return "Username must be 3-30 characters"
    if not re.match(r"^[a-zA-Z0-9_-]+\$", username):
        return "Username can only contain letters, numbers, _ and -"
    return None

def sanitize_filename(filename: str) -> str:
    '''Remove dangerous path traversal characters.'''
    # Remove directory separators and null bytes
    filename = re.sub(r"[/\\\\\\0]", "", filename)
    # Remove leading dots (hidden files)
    filename = filename.lstrip(".")
    # Limit length
    return filename[:255]

print(validate_email("alice@example.com"))  # True
print(validate_email("not-an-email"))       # False
print(validate_username("alice_123"))       # None (valid)
print(validate_username("a"))               # "Username must be 3-30..."
print(sanitize_filename("../../../etc/passwd"))  # "etcpasswd"

# ── SAFE SUBPROCESS ───────────────

# UNSAFE — shell injection!
# user_input = "file.txt; rm -rf /"
# os.system(f"cat {user_input}")     # DISASTER!
# subprocess.run(f"cat {user_input}", shell=True)  # same

# SAFE — list form, no shell
def safe_word_count(filename: str) -> int:
    '''Count words in a file safely.'''
    # Validate the filename first
    path = Path(filename)
    if not path.exists() or not path.is_file():
        raise ValueError(f"Invalid file: {filename}")
    if ".." in str(path.resolve()):
        raise ValueError("Path traversal not allowed")

    result = subprocess.run(
        ["wc", "-w", str(path)],   # list, not string — NO shell injection
        capture_output=True,
        text=True
    )
    return int(result.stdout.split()[0])

# ── AVOID EVAL/EXEC ───────────────

# NEVER:
user_input = "2 + 2"
# result = eval(user_input)  # "os.system('rm -rf /')" would also work!

# Instead, use safe alternatives:
import ast

def safe_eval_math(expression: str) -> float:
    '''Safely evaluate a math expression.'''
    # Parse the AST and only allow safe nodes
    try:
        tree = ast.parse(expression, mode="eval")
    except SyntaxError:
        raise ValueError("Invalid expression")

    SAFE_NODES = {
        ast.Expression, ast.BinOp, ast.UnaryOp, ast.Num,
        ast.Add, ast.Sub, ast.Mult, ast.Div, ast.Pow,
        ast.USub, ast.UAdd, ast.Constant
    }

    for node in ast.walk(tree):
        if type(node) not in SAFE_NODES:
            raise ValueError(f"Unsafe operation: {type(node).__name__}")

    return eval(compile(tree, "<string>", "eval"))

print(safe_eval_math("2 + 2 * 3"))    # 8.0
print(safe_eval_math("(10 + 5) / 3")) # 5.0
try:
    safe_eval_math("__import__('os').system('ls')")
except ValueError as e:
    print(f"Blocked: {e}")

# ── HMAC FOR MESSAGE AUTHENTICITY ─

def sign_message(message: str, secret_key: str) -> str:
    '''Sign a message with HMAC-SHA256.'''
    return hmac.new(
        secret_key.encode(),
        message.encode(),
        hashlib.sha256
    ).hexdigest()

def verify_message(message: str, signature: str, secret_key: str) -> bool:
    '''Verify a message signature.'''
    expected = sign_message(message, secret_key)
    return hmac.compare_digest(signature, expected)

key = os.environ.get("SIGNING_KEY", "dev-secret-key")
msg = "user_id=42&action=approve"
sig = sign_message(msg, key)
print(f"Signature: {sig[:20]}...")
print(f"Valid:     {verify_message(msg, sig, key)}")
print(f"Tampered:  {verify_message(msg + '&admin=true', sig, key)}")

📝 KEY POINTS:
✅ Use secrets module for tokens, API keys, session IDs — not random
✅ secrets.compare_digest() for token comparison — prevents timing attacks
✅ Store secrets in environment variables, NEVER in source code
✅ Use pbkdf2_hmac (600k+ iterations) or bcrypt/argon2 for passwords
✅ ALWAYS use parameterized SQL queries — no string formatting
✅ Never eval() user input — use ast.literal_eval() or custom parsers
✅ Use subprocess.run(list, shell=False) — never shell=True with user input
❌ MD5/SHA1/SHA256 for passwords — they're too fast for secure hashing
❌ pickle.loads() on untrusted data — arbitrary code execution
❌ yaml.load() — use yaml.safe_load() always
""",
  quiz: [
    Quiz(question: 'Why should you use secrets.compare_digest() instead of == for token comparison?', options: [
      QuizOption(text: 'compare_digest is faster than ==', correct: false),
      QuizOption(text: 'String == short-circuits on first mismatch, creating a timing oracle; compare_digest takes constant time', correct: true),
      QuizOption(text: 'compare_digest handles Unicode better', correct: false),
      QuizOption(text: 'compare_digest is case-insensitive', correct: false),
    ]),
    Quiz(question: 'Why is MD5 unsafe for password hashing even though it\'s a "hash"?', options: [
      QuizOption(text: 'MD5 is reversible and can be decoded', correct: false),
      QuizOption(text: 'MD5 is too fast — attackers can test billions of passwords per second with GPUs', correct: true),
      QuizOption(text: 'MD5 does not produce unique hashes for different inputs', correct: false),
      QuizOption(text: 'MD5 has been removed from Python\'s standard library', correct: false),
    ]),
    Quiz(question: 'What makes subprocess.run(["ls", "-la"], shell=False) safer than shell=True with user input?', options: [
      QuizOption(text: 'shell=False is faster', correct: false),
      QuizOption(text: 'With shell=False, args are passed directly to the process — no shell interpretation means no shell injection', correct: true),
      QuizOption(text: 'shell=False captures output automatically', correct: false),
      QuizOption(text: 'shell=True is deprecated in Python 3.10+', correct: false),
    ]),
  ],
);
