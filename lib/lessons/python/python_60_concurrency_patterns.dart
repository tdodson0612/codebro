import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson60 = Lesson(
  language: 'Python',
  title: 'Concurrency Patterns & Real-World Async',
  content: """
🎯 METAPHOR:
Real-world async is like managing a busy restaurant kitchen.
You're the head chef (event loop). Ten orders come in simultaneously.
You don't have ten chefs (threads) — you have one, but you're
brilliant at multitasking. You put the steaks on (start I/O task),
start chopping (another coroutine), check on the pasta (await),
plate the appetizers (complete a task). When steak is done
(I/O completes), you finish that dish. The key: you NEVER
stand still waiting. The moment you'd have to wait, you switch
to another task. The restaurant serves 10x more customers per
hour than a restaurant with one chef who finishes one meal
completely before starting the next.

📖 EXPLANATION:
This lesson covers real-world async patterns: rate limiting,
retry with backoff, connection pools, fan-out/fan-in,
async context managers, and integrating sync code.

─────────────────────────────────────
🔄 KEY ASYNC PATTERNS
─────────────────────────────────────
Fan-out:   start many tasks, wait for all
Fan-in:    collect results as they complete
Pipeline:  pass output of one to input of next
Broadcast: send to multiple consumers
Rate limit: control request throughput
Timeout:   cancel if too slow
Retry:     backoff and retry on failure
Pool:      limit concurrent connections

─────────────────────────────────────
⚡ ASYNCIO TOOLS
─────────────────────────────────────
asyncio.gather()          → run concurrently, wait all
asyncio.wait()            → more control over completion
asyncio.as_completed()    → yield results as ready
asyncio.create_task()     → schedule background task
asyncio.TaskGroup (3.11+) → structured concurrency
asyncio.Semaphore         → limit concurrent tasks
asyncio.Queue             → producer/consumer
asyncio.Event             → signal between coroutines
asyncio.Lock              → async mutex

💻 CODE:
import asyncio
import time
import random
from typing import TypeVar, Callable, Any
from contextlib import asynccontextmanager
from dataclasses import dataclass, field

T = TypeVar("T")

# ── RATE LIMITER ──────────────────

class RateLimiter:
    """Limit to N calls per second using a token bucket."""

    def __init__(self, calls_per_second: float):
        self.rate = calls_per_second
        self.tokens = calls_per_second
        self.last_update = time.monotonic()
        self._lock = asyncio.Lock()

    async def acquire(self) -> None:
        async with self._lock:
            now = time.monotonic()
            elapsed = now - self.last_update
            self.tokens = min(
                self.rate,
                self.tokens + elapsed * self.rate
            )
            self.last_update = now

            if self.tokens < 1:
                wait = (1 - self.tokens) / self.rate
                await asyncio.sleep(wait)
                self.tokens = 0
            else:
                self.tokens -= 1

    async def __aenter__(self):
        await self.acquire()
        return self

    async def __aexit__(self, *args):
        pass

# ── RETRY WITH EXPONENTIAL BACKOFF ─

async def retry(
    coro_func: Callable,
    *args,
    max_attempts: int = 3,
    base_delay: float = 1.0,
    max_delay: float = 60.0,
    exceptions: tuple = (Exception,),
    **kwargs
) -> Any:
    """Retry a coroutine with exponential backoff."""
    last_exception = None
    for attempt in range(1, max_attempts + 1):
        try:
            return await coro_func(*args, **kwargs)
        except exceptions as e:
            last_exception = e
            if attempt == max_attempts:
                raise
            delay = min(base_delay * (2 ** (attempt - 1)), max_delay)
            # Add jitter to prevent thundering herd
            jitter = random.uniform(0, delay * 0.1)
            total_delay = delay + jitter
            print(f"Attempt {attempt} failed: {e}. Retrying in {total_delay:.2f}s...")
            await asyncio.sleep(total_delay)
    raise last_exception

# ── FAN-OUT / FAN-IN ───────────────

async def simulate_api_call(url: str, delay: float) -> dict:
    """Simulate an API call with variable latency."""
    await asyncio.sleep(delay)
    return {"url": url, "data": f"Response from {url}", "latency": delay}

async def fan_out_gather():
    """Run all tasks concurrently, wait for ALL to complete."""
    urls = [f"https://api.example.com/resource/{i}" for i in range(5)]
    delays = [random.uniform(0.1, 0.5) for _ in urls]

    start = time.perf_counter()
    results = await asyncio.gather(
        *[simulate_api_call(url, d) for url, d in zip(urls, delays)]
    )
    elapsed = time.perf_counter() - start

    print(f"Fan-out: fetched {len(results)} in {elapsed:.2f}s (max delay was {max(delays):.2f}s)")
    return results

async def fan_in_as_completed():
    """Process results as they arrive (fastest first)."""
    urls = [f"https://api.example.com/resource/{i}" for i in range(5)]
    delays = [random.uniform(0.1, 0.5) for _ in urls]

    tasks = [asyncio.create_task(simulate_api_call(url, d))
             for url, d in zip(urls, delays)]

    print("Processing results as they arrive:")
    async for task in asyncio.as_completed(tasks):
        result = await task
        print(f"  Received: {result['url'][-10:]} (latency: {result['latency']:.2f}s)")

# ── SEMAPHORE — LIMIT CONCURRENCY ─

async def limited_fetch(sem: asyncio.Semaphore, url: str) -> str:
    async with sem:   # only N concurrent at a time
        await asyncio.sleep(0.1)   # simulate I/O
        return f"Done: {url}"

async def fetch_with_limit(urls: list[str], max_concurrent: int = 3):
    sem = asyncio.Semaphore(max_concurrent)
    tasks = [limited_fetch(sem, url) for url in urls]
    results = await asyncio.gather(*tasks)
    return results

# ── TASK GROUP (Python 3.11+) ──────

async def task_group_example():
    """Structured concurrency — all tasks cancelled if one fails."""
    async with asyncio.TaskGroup() as tg:
        task1 = tg.create_task(simulate_api_call("url1", 0.1))
        task2 = tg.create_task(simulate_api_call("url2", 0.2))
        task3 = tg.create_task(simulate_api_call("url3", 0.15))
    # All tasks done here — exceptions propagated
    print(f"Results: {task1.result()['url']}, {task2.result()['url']}")

# ── PRODUCER / CONSUMER ────────────

async def producer(queue: asyncio.Queue, items: list) -> None:
    for item in items:
        await queue.put(item)
        print(f"Produced: {item}")
        await asyncio.sleep(0.05)
    # Signal done with sentinels
    await queue.put(None)

async def consumer(name: str, queue: asyncio.Queue) -> list:
    results = []
    while True:
        item = await queue.get()
        if item is None:
            queue.task_done()
            # Put sentinel back for other consumers
            await queue.put(None)
            break
        print(f"Consumer {name} processing: {item}")
        await asyncio.sleep(0.1)   # simulate work
        results.append(item * 2)
        queue.task_done()
    return results

async def producer_consumer_demo():
    queue = asyncio.Queue(maxsize=3)
    items = list(range(8))

    prod = asyncio.create_task(producer(queue, items))
    cons1 = asyncio.create_task(consumer("A", queue))
    cons2 = asyncio.create_task(consumer("B", queue))

    await prod
    results1 = await cons1
    results2 = await cons2
    print(f"Results: {sorted(results1 + results2)}")

# ── ASYNC CONTEXT MANAGER ──────────

class AsyncConnectionPool:
    def __init__(self, size: int = 5):
        self.size = size
        self._pool: asyncio.Queue = asyncio.Queue(maxsize=size)
        self._initialized = False

    async def initialize(self):
        for i in range(self.size):
            conn = {"id": i, "in_use": False}
            await self._pool.put(conn)
        self._initialized = True

    async def acquire(self):
        if not self._initialized:
            await self.initialize()
        conn = await self._pool.get()
        conn["in_use"] = True
        return conn

    async def release(self, conn):
        conn["in_use"] = False
        await self._pool.put(conn)

    @asynccontextmanager
    async def connection(self):
        conn = await self.acquire()
        try:
            yield conn
        finally:
            await self.release(conn)

pool = AsyncConnectionPool(3)

async def use_connection(task_id: int):
    async with pool.connection() as conn:
        print(f"Task {task_id} using connection {conn['id']}")
        await asyncio.sleep(0.1)

# ── RUN SYNC CODE IN ASYNC ─────────

def cpu_intensive(n: int) -> int:
    """A blocking, CPU-intensive function."""
    return sum(i**2 for i in range(n))

async def run_in_thread(n: int) -> int:
    """Run blocking code without freezing the event loop."""
    loop = asyncio.get_event_loop()
    result = await loop.run_in_executor(None, cpu_intensive, n)
    return result

# ── CANCELLATION ───────────────────

async def cancellable_task(name: str, duration: float):
    try:
        print(f"Task {name} starting...")
        await asyncio.sleep(duration)
        print(f"Task {name} completed!")
        return f"Result from {name}"
    except asyncio.CancelledError:
        print(f"Task {name} was cancelled!")
        raise   # always re-raise CancelledError!

async def timeout_example():
    try:
        result = await asyncio.wait_for(
            cancellable_task("slow", 10.0),
            timeout=0.5
        )
    except asyncio.TimeoutError:
        print("Task timed out!")

# ── MAIN RUNNER ────────────────────

async def main():
    print("=== Fan-out gather ===")
    await fan_out_gather()

    print("\\n=== Fan-in as_completed ===")
    await fan_in_as_completed()

    print("\\n=== Limited concurrency ===")
    urls = [f"url{i}" for i in range(10)]
    results = await fetch_with_limit(urls, max_concurrent=3)
    print(f"Fetched {len(results)} URLs with max 3 concurrent")

    print("\\n=== Producer/Consumer ===")
    await producer_consumer_demo()

    print("\\n=== Timeout ===")
    await timeout_example()

    print("\\n=== CPU task in thread pool ===")
    result = await run_in_thread(1_000_000)
    print(f"CPU task result: {result}")

asyncio.run(main())

📝 KEY POINTS:
✅ asyncio.gather() for fan-out: run all, wait for all
✅ asyncio.as_completed() for fan-in: process as each finishes
✅ Semaphore to limit concurrent operations (rate limiting, connection pools)
✅ TaskGroup (3.11+) for structured concurrency — cleaner error handling
✅ Always re-raise CancelledError — never swallow it
✅ Use run_in_executor() to run blocking/CPU code without freezing the event loop
✅ Add jitter to retry delays to prevent thundering herd
❌ Never call time.sleep() in async code — use asyncio.sleep()
❌ Never run CPU-intensive code directly in async — use run_in_executor
❌ Don't swallow CancelledError — structured concurrency depends on propagation
""",
  quiz: [
    Quiz(question: 'What is the difference between asyncio.gather() and asyncio.as_completed()?', options: [
      QuizOption(text: 'gather() is faster; as_completed() is safer', correct: false),
      QuizOption(text: 'gather() waits for ALL tasks and returns in order; as_completed() yields results as each task finishes', correct: true),
      QuizOption(text: 'as_completed() runs tasks sequentially; gather() runs them in parallel', correct: false),
      QuizOption(text: 'They are identical — just different names', correct: false),
    ]),
    Quiz(question: 'Why should you use asyncio.Semaphore when making many async requests?', options: [
      QuizOption(text: 'Semaphore makes requests faster', correct: false),
      QuizOption(text: 'To limit the number of concurrent requests and avoid overwhelming servers or hitting rate limits', correct: true),
      QuizOption(text: 'Semaphore is required for all async I/O operations', correct: false),
      QuizOption(text: 'Semaphore prevents duplicate requests', correct: false),
    ]),
    Quiz(question: 'Why must you always re-raise asyncio.CancelledError?', options: [
      QuizOption(text: 'It prevents memory leaks', correct: false),
      QuizOption(text: 'Swallowing CancelledError breaks task cancellation propagation and structured concurrency', correct: true),
      QuizOption(text: 'It is required by the async specification', correct: false),
      QuizOption(text: 'CancelledError contains important error information', correct: false),
    ]),
  ],
);
