import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson51 = Lesson(
  language: 'Python',
  title: 'Advanced Generators & Coroutines',
  content: """
🎯 METAPHOR:
A generator with send() is like a walkie-talkie conversation.
Without send(), it's a radio broadcast — one way only,
the generator talks, you listen. With send(), it's a
walkie-talkie: you transmit, generator receives, responds,
pauses waiting for your next message. "Copy that, proceeding.
Over." The generator becomes a two-way communication channel,
not just a one-way data stream. This is the foundation of
coroutines — and ultimately, async/await itself.

📖 EXPLANATION:
Generators are more powerful than simple data producers.
They can RECEIVE data via send(), handle termination via
throw() and close(), and delegate via yield from.
These features make generators the foundation of Python's
coroutine and async machinery.

─────────────────────────────────────
📤 SEND() — TWO-WAY GENERATORS
─────────────────────────────────────
value = yield expression
  • Expression is what the generator YIELDS to caller
  • value is what the CALLER sends back via send()

Priming: first call must be next() (or send(None))
         because you can't send before the first yield

─────────────────────────────────────
💥 THROW() — INJECT EXCEPTIONS
─────────────────────────────────────
gen.throw(ExcType, msg)
  Injects an exception AT the yield point.
  Generator can catch it with try/except.

─────────────────────────────────────
🔚 CLOSE() — TERMINATE
─────────────────────────────────────
gen.close()
  Injects GeneratorExit into the generator.
  Generator should clean up (finally blocks run).

─────────────────────────────────────
🔄 YIELD FROM — DELEGATION
─────────────────────────────────────
yield from sub_generator
  Fully delegates to sub_generator:
  • All values from sub flow through
  • send() goes directly to sub
  • throw() goes directly to sub
  • Return value of sub becomes value of yield from expr

─────────────────────────────────────
🌊 GENERATOR PIPELINES
─────────────────────────────────────
Process data through a chain of generators:
source → filter → transform → sink

Each step is a generator — pull-based data flow.
Memory usage is O(1) regardless of data size.

💻 CODE:
# ── SEND() — BIDIRECTIONAL GENERATOR ─

def running_average():
    """Generator that maintains a running average via send()."""
    total = 0.0
    count = 0
    average = None
    while True:
        value = yield average   # yield current average, receive new value
        if value is None:
            break
        total += value
        count += 1
        average = total / count

gen = running_average()
next(gen)               # prime (send None implicitly)
print(gen.send(10))     # 10.0
print(gen.send(20))     # 15.0
print(gen.send(30))     # 20.0
print(gen.send(40))     # 25.0
gen.close()

# Coroutine decorator (auto-prime)
from functools import wraps

def coroutine(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        gen = func(*args, **kwargs)
        next(gen)   # auto-prime!
        return gen
    return wrapper

@coroutine
def logger(filename):
    """Coroutine that logs values to a file."""
    print(f"Opening log to {filename}")
    try:
        while True:
            value = yield
            print(f"LOG: {value}")
    except GeneratorExit:
        print(f"Closing log")

log = logger("app.log")
log.send("Server started")
log.send("User logged in: Alice")
log.send("Query executed in 0.05s")
log.close()

# ── THROW() ───────────────────────

@coroutine
def resilient_processor():
    while True:
        try:
            value = yield
            print(f"Processing: {value}")
        except ValueError as e:
            print(f"Bad value received: {e}, continuing...")
        except GeneratorExit:
            print("Processor shutting down")
            return

proc = resilient_processor()
proc.send("good data")
proc.send("more data")
proc.throw(ValueError, "invalid input!")   # inject exception
proc.send("recovered data")
proc.close()

# ── YIELD FROM — DELEGATION ────────

def inner_gen():
    yield 1
    yield 2
    return "inner done"   # return value accessible via yield from

def outer_gen():
    result = yield from inner_gen()   # delegate + capture return
    print(f"Inner returned: {result}")
    yield 3
    yield 4

print(list(outer_gen()))   # [1, 2, 3, 4]

# yield from passes send() through to inner generator!
@coroutine
def sub_coroutine():
    while True:
        val = yield
        print(f"  Sub received: {val}")

@coroutine
def main_coroutine():
    print("Starting sub-coroutine")
    yield from sub_coroutine()   # transparently delegates send()

mc = main_coroutine()
mc.send("hello")
mc.send("world")
mc.close()

# ── GENERATOR PIPELINES ────────────

import itertools

def read_data(data):
    """Source generator."""
    for item in data:
        yield item

def parse_line(lines):
    """Transform: parse CSV-like lines."""
    for line in lines:
        parts = line.strip().split(",")
        if len(parts) >= 3:
            yield {
                "name":  parts[0],
                "score": float(parts[1]),
                "dept":  parts[2]
            }

def filter_active(records, min_score=0):
    """Filter: keep records above min_score."""
    for r in records:
        if r["score"] >= min_score:
            yield r

def enrich(records):
    """Transform: add computed fields."""
    for r in records:
        r["grade"] = "A" if r["score"] >= 90 else "B" if r["score"] >= 80 else "C"
        yield r

def top_n(records, n):
    """Sink: get top N by score."""
    yield from itertools.islice(
        sorted(records, key=lambda r: r["score"], reverse=True), n
    )

# Build the pipeline
raw_data = [
    "Alice,92,Eng",
    "Bob,78,Mkt",
    "Carol,95,Eng",
    "Dave,,HR",       # bad row (will be skipped)
    "Eve,88,Eng",
    "Frank,65,Mkt",
]

pipeline = top_n(
    enrich(
        filter_active(
            parse_line(
                read_data(raw_data)
            ),
            min_score=80
        )
    ),
    n=3
)

for record in pipeline:
    print(f"{record['name']:8s}: {record['score']} ({record['grade']}) - {record['dept']}")

# ── ASYNC GENERATOR ───────────────

import asyncio

async def async_range(n: int, delay=0.1):
    """Async generator — yields with async delays."""
    for i in range(n):
        await asyncio.sleep(delay)
        yield i

async def async_pipeline():
    # Async comprehension
    values = [i async for i in async_range(5)]
    print(f"Async range: {values}")

    # Async for loop
    async for val in async_range(3, delay=0.05):
        print(f"Got: {val}")

    # Async generator with filter
    evens = [v async for v in async_range(10) if v % 2 == 0]
    print(f"Even: {evens}")

asyncio.run(async_pipeline())

# ── GENERATOR TOOLS ───────────────

def take(n, iterable):
    return itertools.islice(iterable, n)

def chunked(iterable, n):
    """Yield successive n-sized chunks."""
    it = iter(iterable)
    while True:
        chunk = list(itertools.islice(it, n))
        if not chunk:
            return
        yield chunk

def sliding_window(iterable, size):
    """Sliding window over iterable."""
    iters = itertools.tee(iterable, size)
    for i, it in enumerate(iters):
        for _ in range(i):
            next(it)
    return zip(*iters)

data = range(10)
print(list(chunked(data, 3)))           # [[0,1,2],[3,4,5],[6,7,8],[9]]
print(list(sliding_window(range(6),3))) # [(0,1,2),(1,2,3),(2,3,4),(3,4,5)]

📝 KEY POINTS:
✅ send() turns generators into bidirectional coroutines
✅ Always prime a generator with next() before sending non-None values
✅ Use a @coroutine decorator to auto-prime generators
✅ yield from delegates completely — send/throw/close pass through
✅ Generator pipelines process data with O(1) memory regardless of size
✅ async generators (async def + yield) work with async for
❌ Calling send() before priming raises TypeError
❌ GeneratorExit from close() should NOT be caught (or re-raise it)
❌ Don't use generator send() for new code — async/await is cleaner for coroutines
""",
  quiz: [
    Quiz(question: 'What must you do before calling gen.send(value) on a fresh generator?', options: [
      QuizOption(text: 'Call gen.start()', correct: false),
      QuizOption(text: 'Call next(gen) or gen.send(None) to advance to the first yield', correct: true),
      QuizOption(text: 'Nothing — send() works immediately', correct: false),
      QuizOption(text: 'Call gen.prime()', correct: false),
    ]),
    Quiz(question: 'What does "yield from sub_gen" do beyond just "for x in sub_gen: yield x"?', options: [
      QuizOption(text: 'It is identical — just syntactic sugar', correct: false),
      QuizOption(text: 'It also passes send() calls, throw() calls, and captures the sub-generator return value', correct: true),
      QuizOption(text: 'It runs the sub-generator in a separate thread', correct: false),
      QuizOption(text: 'It makes the delegation asynchronous', correct: false),
    ]),
    Quiz(question: 'What is the memory advantage of a generator pipeline over list processing?', options: [
      QuizOption(text: 'There is no memory advantage', correct: false),
      QuizOption(text: 'Each stage processes one item at a time — O(1) memory regardless of data size', correct: true),
      QuizOption(text: 'Generators compress data before storing', correct: false),
      QuizOption(text: 'Generators use disk instead of RAM', correct: false),
    ]),
  ],
);
