import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson33 = Lesson(
  language: 'Python',
  title: 'Threading & Multiprocessing',
  content: '''
🎯 METAPHOR:
Threading vs multiprocessing is like a restaurant kitchen.
Threading is one chef with multiple hands — they can stir
the soup, chop vegetables, and keep an eye on the oven at
the same time, but they can only truly do ONE thing at a
moment (the brain is shared). Useful when most time is
spent waiting (I/O). Multiprocessing is hiring multiple
chefs — each has their own brain, hands, and tools. They
truly work in parallel. More overhead (hiring, equipping),
but when you need real horsepower for heavy cooking
(CPU-intensive tasks), you need multiple chefs.

📖 EXPLANATION:
Python has three concurrency models:
1. threading — multiple threads, one GIL-controlled process
2. multiprocessing — multiple processes, true parallelism
3. concurrent.futures — high-level wrapper for both

─────────────────────────────────────
🔒 THE GIL (Global Interpreter Lock)
─────────────────────────────────────
Python's CPython interpreter has a GIL — only ONE thread
can execute Python bytecode at a time.
→ threading is for I/O-bound tasks (the GIL is released
  during I/O operations)
→ multiprocessing bypasses the GIL (separate processes)
→ For CPU-bound work, use multiprocessing

─────────────────────────────────────
🧵 THREADING
─────────────────────────────────────
Good for: web scraping, API calls, file I/O, GUI apps
threading.Thread(target=func, args=(...)
thread.start() → begin execution
thread.join()  → wait for thread to finish
thread.daemon  → dies when main thread dies

─────────────────────────────────────
⚙️  THREAD SAFETY TOOLS
─────────────────────────────────────
threading.Lock()       → mutual exclusion
threading.RLock()      → reentrant lock
threading.Event()      → signal between threads
threading.Condition()  → wait/notify pattern
threading.Semaphore(n) → limit n concurrent
threading.Barrier(n)   → wait for n threads
threading.local()      → thread-local storage

─────────────────────────────────────
🏭 MULTIPROCESSING
─────────────────────────────────────
Good for: data processing, ML training, number crunching
multiprocessing.Process(target=func, args=...)
Pool(n) → manage pool of worker processes
  pool.map(func, items)    → map in parallel
  pool.starmap             → map with multiple args
  pool.apply_async         → async apply

─────────────────────────────────────
🚀 CONCURRENT.FUTURES — HIGH LEVEL
─────────────────────────────────────
ThreadPoolExecutor  → thread pool (I/O tasks)
ProcessPoolExecutor → process pool (CPU tasks)
executor.submit(fn, *args) → returns Future
executor.map(fn, items)    → parallel map
as_completed(futures)      → yield as they complete

💻 CODE:
import threading
import multiprocessing
import concurrent.futures
import time
import queue

# ── THREADING ──────────────────────

# Basic thread
def download(url, results, index):
    time.sleep(0.1)   # simulate I/O
    results[index] = f"Data from {url}"

urls = ["url1", "url2", "url3", "url4"]
results = [None] * len(urls)
threads = []

start = time.perf_counter()
for i, url in enumerate(urls):
    t = threading.Thread(target=download, args=(url, results, i))
    threads.append(t)
    t.start()

for t in threads:
    t.join()   # wait for all to finish

elapsed = time.perf_counter() - start
print(f"Downloaded {len(results)} urls in {elapsed:.2f}s")
print(results)

# Thread with return value — use a Queue
def worker(q, value):
    result = value ** 2
    q.put(result)

q = queue.Queue()
threads = [threading.Thread(target=worker, args=(q, i)) for i in range(5)]
for t in threads: t.start()
for t in threads: t.join()

results = []
while not q.empty():
    results.append(q.get())
print(sorted(results))   # [0, 1, 4, 9, 16]

# Lock — prevent race conditions
counter = 0
lock = threading.Lock()

def increment_safe(n):
    global counter
    for _ in range(n):
        with lock:    # acquire lock, release on exit
            counter += 1

threads = [threading.Thread(target=increment_safe, args=(1000,)) for _ in range(10)]
for t in threads: t.start()
for t in threads: t.join()
print(f"Counter: {counter}")   # 10000 (correct with lock)

# Event — signal between threads
event = threading.Event()

def producer():
    print("Producer: preparing data...")
    time.sleep(1)
    print("Producer: data ready!")
    event.set()   # signal consumers

def consumer(name):
    print(f"Consumer {name}: waiting...")
    event.wait()  # block until event is set
    print(f"Consumer {name}: processing data!")

threads = [
    threading.Thread(target=producer),
    threading.Thread(target=consumer, args=("A",)),
    threading.Thread(target=consumer, args=("B",)),
]
for t in threads: t.start()
for t in threads: t.join()

# Daemon thread — dies when main thread dies
def background_task():
    while True:
        print("Background task running...")
        time.sleep(1)

t = threading.Thread(target=background_task, daemon=True)
t.start()
time.sleep(2.5)
print("Main thread ending — daemon will be killed")

# Thread-local storage
local_data = threading.local()

def thread_func(name):
    local_data.name = name   # each thread has its OWN copy
    time.sleep(0.1)
    print(f"Thread data: {local_data.name}")

threads = [threading.Thread(target=thread_func, args=(f"Thread-{i}",))
           for i in range(3)]
for t in threads: t.start()
for t in threads: t.join()

# ── MULTIPROCESSING ────────────────

def cpu_task(n):
    """CPU-intensive task — benefits from multiprocessing."""
    return sum(i**2 for i in range(n))

if __name__ == "__main__":   # REQUIRED for multiprocessing on Windows!
    # Pool.map — simple parallel map
    with multiprocessing.Pool() as pool:   # defaults to CPU count
        inputs = [1_000_000] * 4
        start = time.perf_counter()
        results = pool.map(cpu_task, inputs)
        elapsed = time.perf_counter() - start
        print(f"Multiprocessing: {elapsed:.2f}s → {results}")

    # Compare with sequential
    start = time.perf_counter()
    results = [cpu_task(n) for n in inputs]
    elapsed = time.perf_counter() - start
    print(f"Sequential: {elapsed:.2f}s")

    # starmap for multiple arguments
    def power(base, exp):
        return base ** exp

    with multiprocessing.Pool() as pool:
        results = pool.starmap(power, [(2,10), (3,8), (4,6)])
        print(results)   # [1024, 6561, 4096]

# ── CONCURRENT.FUTURES ─────────────

# ThreadPoolExecutor (I/O tasks)
def fetch_url(url):
    time.sleep(0.2)   # simulate network
    return f"response from {url}"

urls = [f"https://example.com/{i}" for i in range(10)]

with concurrent.futures.ThreadPoolExecutor(max_workers=5) as executor:
    start = time.perf_counter()
    results = list(executor.map(fetch_url, urls))
    elapsed = time.perf_counter() - start
    print(f"Fetched {len(results)} URLs in {elapsed:.2f}s")

# submit() — get Future objects
with concurrent.futures.ThreadPoolExecutor(max_workers=4) as executor:
    futures = {executor.submit(fetch_url, url): url for url in urls[:4]}

    for future in concurrent.futures.as_completed(futures):
        url = futures[future]
        try:
            result = future.result()
            print(f"✅ {url}: {result}")
        except Exception as e:
            print(f"❌ {url} failed: {e}")

📝 KEY POINTS:
✅ Use threading for I/O-bound tasks (network, files, DB)
✅ Use multiprocessing for CPU-bound tasks (number crunching)
✅ Use concurrent.futures for a simple, high-level API for both
✅ ALWAYS use "if __name__ == '__main__':" with multiprocessing
✅ Use Lock to protect shared mutable state in threads
✅ GIL means threads don't give parallelism for CPU tasks
❌ Don't share mutable state between threads without locking
❌ multiprocessing has overhead — only worth it for heavy CPU work
❌ Never put multiprocessing code at module level without __main__ guard
''',
  quiz: [
    Quiz(question: 'What is the Python GIL and how does it affect threading?', options: [
      QuizOption(text: 'It prevents all threads from running — use async instead', correct: false),
      QuizOption(text: 'It allows only one thread to execute Python code at a time, limiting CPU parallelism', correct: true),
      QuizOption(text: 'It locks shared variables automatically, preventing race conditions', correct: false),
      QuizOption(text: 'It is removed in Python 3.12+', correct: false),
    ]),
    Quiz(question: 'When should you use multiprocessing instead of threading?', options: [
      QuizOption(text: 'For web scraping and API calls', correct: false),
      QuizOption(text: 'For CPU-bound tasks that need true parallel execution', correct: true),
      QuizOption(text: 'Multiprocessing is always better than threading', correct: false),
      QuizOption(text: 'When you need shared memory between workers', correct: false),
    ]),
    Quiz(question: 'What is the purpose of threading.Lock()?', options: [
      QuizOption(text: 'To pause all threads except the current one', correct: false),
      QuizOption(text: 'To prevent race conditions by ensuring only one thread accesses shared data at a time', correct: true),
      QuizOption(text: 'To lock a thread into a CPU core for performance', correct: false),
      QuizOption(text: 'To create a daemon thread that exits when the main thread does', correct: false),
    ]),
  ],
);
