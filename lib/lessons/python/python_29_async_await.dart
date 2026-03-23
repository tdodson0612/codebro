import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson29 = Lesson(
  language: 'Python',
  title: 'Async / Await & Concurrency',
  content: """
🎯 METAPHOR:
Async/await is like a single chef managing multiple orders.
A synchronous chef cooks one dish start to finish before
touching the next order. If the pasta needs to boil for
10 minutes, they stare at the pot for 10 minutes.
An async chef puts the pasta on, then starts the salad,
then checks on the soup, then comes back to drain the pasta.
They're not working in parallel — there's still ONE chef —
but they're NEVER sitting idle waiting. This is asyncio:
one thread, switching tasks during wait times (I/O, network),
dramatically improving throughput without parallelism.

📖 EXPLANATION:
asyncio enables concurrent code using a single thread.
Perfect for I/O-bound tasks: web requests, database queries,
file reading, network communication.
NOT for CPU-bound work — use multiprocessing for that.

─────────────────────────────────────
📐 SYNTAX
─────────────────────────────────────
async def — defines a coroutine function
await      — suspends current coroutine until result ready
asyncio.run(coro) — runs the event loop

─────────────────────────────────────
🔄 COROUTINE vs THREAD
─────────────────────────────────────
Thread:    multiple OS threads, OS decides when to switch
           → shared memory, race conditions, complex
Coroutine: single thread, YOU decide when to yield
           → simpler, no race conditions for shared data
           → uses "cooperative multitasking"

─────────────────────────────────────
🚀 KEY asyncio TOOLS
─────────────────────────────────────
asyncio.run(main())          → run event loop
asyncio.sleep(n)             → async sleep (yields control)
asyncio.gather(*coros)       → run coroutines CONCURRENTLY
asyncio.create_task(coro)    → schedule coroutine
asyncio.wait_for(coro, timeout) → with timeout
asyncio.Queue                → async queue
asyncio.Lock, Semaphore      → async synchronization

─────────────────────────────────────
🌊 ASYNC GENERATORS & COMPREHENSIONS
─────────────────────────────────────
async def gen():
    for i in range(10):
        await asyncio.sleep(0)
        yield i

async for item in gen(): ...
result = [x async for x in gen()]

─────────────────────────────────────
⚡ THREADS vs PROCESSES vs ASYNC
─────────────────────────────────────
I/O-bound (waiting):   asyncio or threading
CPU-bound (computing): multiprocessing
Mixed:                 ThreadPoolExecutor + asyncio

💻 CODE:
import asyncio
import time

# Basic coroutine
async def greet(name, delay):
    print(f"Hello {name}! Waiting {delay}s...")
    await asyncio.sleep(delay)   # yields control — doesn't block!
    print(f"Done with {name}!")
    return f"Greeted {name}"

# Sequential (slow) — total 3 seconds
async def sequential():
    start = time.perf_counter()
    await greet("Alice", 1)
    await greet("Bob", 1)
    await greet("Carol", 1)
    print(f"Sequential: {time.perf_counter()-start:.2f}s")

# Concurrent (fast) — total ~1 second
async def concurrent():
    start = time.perf_counter()
    results = await asyncio.gather(
        greet("Alice", 1),
        greet("Bob", 1),
        greet("Carol", 1),
    )
    print(f"Concurrent: {time.perf_counter()-start:.2f}s")
    print(f"Results: {results}")

# asyncio.run() is the entry point
asyncio.run(concurrent())

# Tasks — explicit task creation
async def main():
    task1 = asyncio.create_task(greet("Alice", 2))
    task2 = asyncio.create_task(greet("Bob", 1))

    # Tasks start running immediately
    print("Tasks created")

    # Await them
    r1 = await task1
    r2 = await task2
    print(r1, r2)

asyncio.run(main())

# Timeout
async def slow_operation():
    await asyncio.sleep(10)
    return "done"

async def with_timeout():
    try:
        result = await asyncio.wait_for(slow_operation(), timeout=2.0)
    except asyncio.TimeoutError:
        print("Operation timed out!")

asyncio.run(with_timeout())

# Async context manager
class AsyncDatabase:
    async def __aenter__(self):
        print("Connecting to database...")
        await asyncio.sleep(0.1)   # simulate connection
        return self

    async def __aexit__(self, *args):
        print("Closing connection...")
        await asyncio.sleep(0.1)

    async def query(self, sql):
        await asyncio.sleep(0.05)   # simulate query
        return [{"id": 1, "name": "Alice"}]

async def db_example():
    async with AsyncDatabase() as db:
        results = await db.query("SELECT * FROM users")
        print(results)

asyncio.run(db_example())

# Async generator
async def fetch_pages(urls):
    for url in urls:
        await asyncio.sleep(0.1)   # simulate download
        yield f"content of {url}"

async def process_pages():
    urls = ["url1", "url2", "url3"]
    async for page in fetch_pages(urls):
        print(f"Processing: {page}")

    # Async list comprehension
    pages = [page async for page in fetch_pages(urls)]
    print(f"Got {len(pages)} pages")

asyncio.run(process_pages())

# Queue — producer/consumer pattern
async def producer(queue, n):
    for i in range(n):
        await asyncio.sleep(0.1)
        item = f"item_{i}"
        await queue.put(item)
        print(f"Produced: {item}")
    await queue.put(None)   # signal done

async def consumer(queue):
    while True:
        item = await queue.get()
        if item is None:
            break
        print(f"Consumed: {item}")
        await asyncio.sleep(0.05)

async def producer_consumer():
    queue = asyncio.Queue(maxsize=3)
    await asyncio.gather(
        producer(queue, 5),
        consumer(queue)
    )

asyncio.run(producer_consumer())

# Semaphore — limit concurrency
async def limited_task(sem, task_id):
    async with sem:   # only N tasks at once
        print(f"Task {task_id} running")
        await asyncio.sleep(1)
        print(f"Task {task_id} done")

async def limited_concurrency():
    sem = asyncio.Semaphore(3)   # max 3 concurrent
    tasks = [limited_task(sem, i) for i in range(10)]
    await asyncio.gather(*tasks)

# Run in executor — use thread/process pool with async
async def run_sync_in_async():
    loop = asyncio.get_event_loop()
    # Run CPU-bound sync code in a thread pool
    result = await loop.run_in_executor(
        None,    # None = default ThreadPoolExecutor
        lambda: sum(i**2 for i in range(1_000_000))
    )
    print(f"Result: {result}")

asyncio.run(run_sync_in_async())

📝 KEY POINTS:
✅ async/await is for I/O-bound tasks — network, file, database
✅ asyncio.gather() runs multiple coroutines CONCURRENTLY
✅ await releases the event loop — never use time.sleep() in async code
✅ asyncio.create_task() schedules a coroutine to run soon
✅ Async context managers use async with and __aenter__/__aexit__
✅ Async generators use async for and yield inside async def
❌ asyncio doesn't give you parallelism — still single-threaded
❌ Never call regular blocking code (time.sleep, requests.get) in async — use run_in_executor
❌ Can't use await outside of async def — you'll get SyntaxError
""",
  quiz: [
    Quiz(question: 'What is asyncio best suited for?', options: [
      QuizOption(text: 'CPU-intensive calculations like image processing', correct: false),
      QuizOption(text: 'I/O-bound tasks like network requests and file operations', correct: true),
      QuizOption(text: 'Running code on multiple CPU cores simultaneously', correct: false),
      QuizOption(text: 'Managing multiple threads safely', correct: false),
    ]),
    Quiz(question: 'What does asyncio.gather() do?', options: [
      QuizOption(text: 'Runs coroutines sequentially one by one', correct: false),
      QuizOption(text: 'Runs multiple coroutines concurrently and waits for all to finish', correct: true),
      QuizOption(text: 'Creates new threads for each coroutine', correct: false),
      QuizOption(text: 'Combines results from synchronous functions', correct: false),
    ]),
    Quiz(question: 'Why should you NOT use time.sleep() inside an async function?', options: [
      QuizOption(text: 'time.sleep raises an error in async functions', correct: false),
      QuizOption(text: 'time.sleep blocks the entire event loop — use await asyncio.sleep() instead', correct: true),
      QuizOption(text: 'time.sleep is deprecated in Python 3.9+', correct: false),
      QuizOption(text: 'time.sleep does not work with coroutines', correct: false),
    ]),
  ],
);
