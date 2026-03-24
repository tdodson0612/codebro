import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson49 = Lesson(
  language: 'Python',
  title: 'Databases & SQL with Python',
  content: """
🎯 METAPHOR:
A database connection is like a checkout counter at a store.
The store (database) has all the products (data). The checkout
counter (connection) is your dedicated point of interaction —
you make requests, they fulfill them. A cursor is the cashier
at that counter — they take your items (SQL queries), ring
them up (execute), and hand you back the receipt (results).
You don't open a new store for each purchase; you use the
same counter. Transactions are like filling a shopping cart —
everything goes in together, and either ALL gets rung up
(COMMIT) or you put everything back (ROLLBACK).

📖 EXPLANATION:
Python has built-in SQLite support and libraries for all
major databases. SQLAlchemy is the dominant ORM.

─────────────────────────────────────
📦 DATABASE OPTIONS
─────────────────────────────────────
SQLite    → sqlite3 (built-in), file-based, great for dev
PostgreSQL → psycopg2 or asyncpg (pip)
MySQL     → mysql-connector-python or PyMySQL (pip)
MongoDB   → pymongo (pip)
Redis     → redis-py (pip)

─────────────────────────────────────
🔑 SQLITE3 — BUILT-IN DATABASE
─────────────────────────────────────
import sqlite3

conn = sqlite3.connect("mydb.sqlite3")  # or ":memory:"
cursor = conn.cursor()

cursor.execute("SQL")
cursor.executemany("SQL", list_of_params)
cursor.fetchone()    → one row
cursor.fetchall()    → all rows
cursor.fetchmany(n)  → n rows
conn.commit()        → save changes
conn.rollback()      → undo changes
conn.close()         → release connection

─────────────────────────────────────
⚠️  SQL INJECTION PREVENTION
─────────────────────────────────────
NEVER concatenate user input into SQL!

# BUG — SQL INJECTION!
name = input()  # "'; DROP TABLE users; --"
cursor.execute(f"SELECT * FROM users WHERE name='{name}'")

# SAFE — parameterized queries (always use these!)
cursor.execute("SELECT * FROM users WHERE name=?", (name,))

─────────────────────────────────────
🏗️  SQLALCHEMY — ORM
─────────────────────────────────────
pip install sqlalchemy

Two modes:
  Core   → SQL Expression Language (SQL-like)
  ORM    → map classes to tables (Pythonic)

─────────────────────────────────────
🔄 TRANSACTIONS
─────────────────────────────────────
BEGIN → COMMIT (success) or ROLLBACK (failure)
In Python: conn.commit() / conn.rollback()
Context manager: with conn: auto-commits/rolls back

💻 CODE:
import sqlite3
from contextlib import contextmanager
from dataclasses import dataclass, field
from datetime import datetime
from typing import Optional

# ── SQLITE3 BASICS ─────────────────

# In-memory database for demos
conn = sqlite3.connect(":memory:")
conn.row_factory = sqlite3.Row   # rows accessible by column name!

cursor = conn.cursor()

# Create table
cursor.execute('''
    CREATE TABLE users (
        id       INTEGER PRIMARY KEY AUTOINCREMENT,
        name     TEXT    NOT NULL,
        email    TEXT    UNIQUE NOT NULL,
        age      INTEGER CHECK(age >= 0 AND age <= 150),
        created  TEXT    DEFAULT CURRENT_TIMESTAMP,
        active   INTEGER DEFAULT 1
    )
''')

cursor.execute('''
    CREATE TABLE posts (
        id        INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id   INTEGER REFERENCES users(id) ON DELETE CASCADE,
        title     TEXT NOT NULL,
        content   TEXT,
        created   TEXT DEFAULT CURRENT_TIMESTAMP
    )
''')

conn.commit()

# INSERT — parameterized (safe from SQL injection!)
users = [
    ("Alice",  "alice@example.com",  30),
    ("Bob",    "bob@example.com",    25),
    ("Carol",  "carol@example.com",  35),
    ("Dave",   "dave@example.com",   28),
]
cursor.executemany(
    "INSERT INTO users (name, email, age) VALUES (?, ?, ?)",
    users
)
conn.commit()
print(f"Inserted {cursor.rowcount} users")

# INSERT single row and get ID
cursor.execute(
    "INSERT INTO users (name, email, age) VALUES (?, ?, ?)",
    ("Eve", "eve@example.com", 22)
)
new_id = cursor.lastrowid
print(f"New user ID: {new_id}")
conn.commit()

# SELECT
cursor.execute("SELECT * FROM users ORDER BY age")
rows = cursor.fetchall()
for row in rows:
    print(f"[{row['id']}] {row['name']} ({row['age']}) - {row['email']}")

# SELECT with condition
cursor.execute("SELECT name, age FROM users WHERE age > ?", (25,))
print("Users over 25:", [dict(r) for r in cursor.fetchall()])

# SELECT with LIKE, IN, BETWEEN
cursor.execute("SELECT name FROM users WHERE name LIKE ?", ("A%",))
print("Names starting with A:", [r[0] for r in cursor.fetchall()])

cursor.execute("SELECT name FROM users WHERE age BETWEEN ? AND ?", (25, 30))
print("Ages 25-30:", [r[0] for r in cursor.fetchall()])

# UPDATE
cursor.execute(
    "UPDATE users SET age = age + 1 WHERE name = ?",
    ("Alice",)
)
print(f"Updated {cursor.rowcount} rows")
conn.commit()

# DELETE
cursor.execute("DELETE FROM users WHERE age < ?", (23,))
print(f"Deleted {cursor.rowcount} users")
conn.commit()

# AGGREGATE queries
cursor.execute('''
    SELECT
        COUNT(*) as total,
        AVG(age) as avg_age,
        MIN(age) as min_age,
        MAX(age) as max_age
    FROM users
    WHERE active = 1
''')
stats = dict(cursor.fetchone())
print(f"Stats: {stats}")

# GROUP BY
cursor.execute('''
    SELECT
        CASE WHEN age < 30 THEN 'young' ELSE 'senior' END as group_name,
        COUNT(*) as count
    FROM users
    GROUP BY group_name
    ORDER BY count DESC
''')
for row in cursor.fetchall():
    print(f"{row['group_name']}: {row['count']}")

# JOIN
cursor.executemany(
    "INSERT INTO posts (user_id, title, content) VALUES (?, ?, ?)",
    [
        (1, "Hello World", "My first post"),
        (1, "Python Tips", "Use list comprehensions!"),
        (2, "Bob's Blog", "Hi there"),
    ]
)
conn.commit()

cursor.execute('''
    SELECT u.name, p.title, p.created
    FROM users u
    JOIN posts p ON u.id = p.user_id
    ORDER BY u.name, p.created
''')
for row in cursor.fetchall():
    print(f"{row['name']}: {row['title']}")

# TRANSACTION — atomic operation
def transfer_money(conn, from_id, to_id, amount):
    try:
        cursor = conn.cursor()
        cursor.execute("UPDATE accounts SET balance = balance - ? WHERE id = ?", (amount, from_id))
        if cursor.rowcount == 0:
            raise ValueError(f"Source account {from_id} not found")
        cursor.execute("UPDATE accounts SET balance = balance + ? WHERE id = ?", (amount, to_id))
        if cursor.rowcount == 0:
            raise ValueError(f"Target account {to_id} not found")
        conn.commit()   # both succeed → commit
        print(f"Transferred \${amount} from {from_id} to {to_id}")
    except Exception as e:
        conn.rollback()  # either fails → rollback both!
        print(f"Transfer failed: {e}")

# Context manager for connections
@contextmanager
def get_db(path=":memory:"):
    conn = sqlite3.connect(path)
    conn.row_factory = sqlite3.Row
    conn.execute("PRAGMA foreign_keys = ON")
    try:
        yield conn
        conn.commit()
    except Exception:
        conn.rollback()
        raise
    finally:
        conn.close()

with get_db() as db:
    db.execute("CREATE TABLE test (id INTEGER PRIMARY KEY, val TEXT)")
    db.execute("INSERT INTO test (val) VALUES (?)", ("hello",))
    rows = db.execute("SELECT * FROM test").fetchall()
    print([dict(r) for r in rows])

# Repository pattern — clean data access layer
class UserRepository:
    def __init__(self, connection: sqlite3.Connection):
        self.conn = connection

    def find_by_id(self, user_id: int) -> Optional[dict]:
        row = self.conn.execute(
            "SELECT * FROM users WHERE id = ?", (user_id,)
        ).fetchone()
        return dict(row) if row else None

    def find_all(self, active_only=True) -> list[dict]:
        sql = "SELECT * FROM users"
        if active_only:
            sql += " WHERE active = 1"
        return [dict(r) for r in self.conn.execute(sql).fetchall()]

    def create(self, name: str, email: str, age: int) -> int:
        cursor = self.conn.execute(
            "INSERT INTO users (name, email, age) VALUES (?, ?, ?)",
            (name, email, age)
        )
        self.conn.commit()
        return cursor.lastrowid

    def update_age(self, user_id: int, new_age: int) -> bool:
        cursor = self.conn.execute(
            "UPDATE users SET age = ? WHERE id = ?",
            (new_age, user_id)
        )
        self.conn.commit()
        return cursor.rowcount > 0

    def delete(self, user_id: int) -> bool:
        cursor = self.conn.execute(
            "DELETE FROM users WHERE id = ?", (user_id,)
        )
        self.conn.commit()
        return cursor.rowcount > 0

repo = UserRepository(conn)
user = repo.find_by_id(1)
print(user)
all_users = repo.find_all()
print(f"Active users: {len(all_users)}")

conn.close()

📝 KEY POINTS:
✅ ALWAYS use parameterized queries (?) — never format user input into SQL
✅ Set conn.row_factory = sqlite3.Row to access results by column name
✅ Use transactions for related operations that must succeed or fail together
✅ Enable foreign keys in SQLite: PRAGMA foreign_keys = ON
✅ Repository pattern separates database logic from business logic
✅ Use ":memory:" for testing — fast, isolated, no cleanup needed
❌ NEVER concatenate user input into SQL strings — SQL injection!
❌ Don't leave connections open — use context managers or close() explicitly
❌ SQLite is not for high-concurrency production — use PostgreSQL/MySQL there
""",
  quiz: [
    Quiz(question: 'Why must you use parameterized queries (?) instead of string formatting in SQL?', options: [
      QuizOption(text: 'Parameterized queries are faster', correct: false),
      QuizOption(text: 'To prevent SQL injection attacks where user input alters the SQL logic', correct: true),
      QuizOption(text: 'String formatting doesn\'t work with SQL', correct: false),
      QuizOption(text: 'Parameterized queries handle NULL values better', correct: false),
    ]),
    Quiz(question: 'What does conn.rollback() do in a database transaction?', options: [
      QuizOption(text: 'Saves all pending changes to the database', correct: false),
      QuizOption(text: 'Undoes all changes made since the last commit', correct: true),
      QuizOption(text: 'Closes the database connection', correct: false),
      QuizOption(text: 'Resets the auto-increment counter', correct: false),
    ]),
    Quiz(question: 'What does setting conn.row_factory = sqlite3.Row enable?', options: [
      QuizOption(text: 'Faster query execution', correct: false),
      QuizOption(text: 'Accessing row values by column name instead of index', correct: true),
      QuizOption(text: 'Automatic type conversion for all columns', correct: false),
      QuizOption(text: 'Row-level locking for concurrent access', correct: false),
    ]),
  ],
);
