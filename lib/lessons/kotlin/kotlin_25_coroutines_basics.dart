import '../../models/lesson.dart';
import '../../models/quiz.dart';

final kotlinLesson25 = Lesson(
  language: 'Kotlin',
  title: 'Coroutines: Basics',
  content: """
🎯 METAPHOR:
A coroutine is like a chef in a restaurant who doesn't
stand at the stove WAITING for water to boil. Instead, they
put the pot on, then go chop vegetables, then check back
when the water is boiling. They "suspend" the boiling task
and work on other things. A traditional thread, by contrast,
is a chef who stands at the stove doing NOTHING until the
water boils — completely blocked. Coroutines let you write
code that LOOKS sequential but behaves asynchronously —
reading top to bottom like normal code, but not blocking
the thread while waiting for slow things (network, disk).

📖 EXPLANATION:
Coroutines are Kotlin's solution to asynchronous programming.
They let you write async code that reads like synchronous
code, without callbacks or complex state machines.

─────────────────────────────────────
THE PROBLEM COROUTINES SOLVE:
─────────────────────────────────────
Without coroutines, async code uses callbacks:
  fetchUser(id) { user ->
      fetchPosts(user) { posts ->
          fetchComments(posts[0]) { comments ->
              // deeply nested callback hell
          }
      }
  }

With coroutines:
  val user = fetchUser(id)      // suspends, not blocks
  val posts = fetchPosts(user)  // suspends, not blocks
  val comments = fetchComments(posts[0])
  // Reads like sequential code!

─────────────────────────────────────
KEY CONCEPTS:
─────────────────────────────────────
  suspend function → can be paused and resumed
  coroutine        → a lightweight thread-like task
  CoroutineScope   → defines the lifetime of coroutines
  Job              → represents a running coroutine
  Deferred<T>      → a coroutine that returns a value

─────────────────────────────────────
suspend FUNCTIONS:
─────────────────────────────────────
A suspend function can pause execution without blocking:

  suspend fun fetchData(): String {
      delay(1000)   // suspend for 1 second — doesn't block!
      return "Data loaded"
  }

suspend functions can ONLY be called from:
  1. Other suspend functions
  2. Inside a coroutine

─────────────────────────────────────
LAUNCHING COROUTINES:
─────────────────────────────────────
  launch { }       → fire and forget, returns Job
  async { }        → returns Deferred<T> — call .await() for result
  runBlocking { }  → bridges blocking and coroutine world
                     (use for main() and tests ONLY)

  // launch — no return value
  val job = scope.launch {
      delay(1000)
      println("Done!")
  }

  // async — has a return value
  val deferred = scope.async {
      delay(1000)
      "result"
  }
  val result = deferred.await()

─────────────────────────────────────
COROUTINE BUILDERS:
─────────────────────────────────────
  runBlocking { }        → main entry point for coroutines
  GlobalScope.launch { } → app-wide coroutine (avoid in production)
  coroutineScope { }     → creates child scope, suspends until done
  supervisorScope { }    → like coroutineScope but children fail independently

─────────────────────────────────────
DELAY vs SLEEP:
─────────────────────────────────────
  Thread.sleep(1000)   → blocks the entire thread ❌
  delay(1000)          → suspends the coroutine only ✅
                         the thread is free to do other work

─────────────────────────────────────
COROUTINE DISPATCHERS:
─────────────────────────────────────
  Dispatchers.Main       → main/UI thread (Android)
  Dispatchers.IO         → for file/network I/O (large thread pool)
  Dispatchers.Default    → for CPU-intensive work
  Dispatchers.Unconfined → starts in caller's thread (rarely used)

  launch(Dispatchers.IO) {
      val data = readFile()   // runs on IO thread pool
  }

─────────────────────────────────────
STRUCTURED CONCURRENCY:
─────────────────────────────────────
Kotlin's coroutines enforce structured concurrency:
a parent coroutine waits for all its children to finish.
If a parent is cancelled, ALL children are cancelled.
This prevents coroutine leaks — the bane of async code.

💻 CODE:
import kotlinx.coroutines.*

// Simulate slow operations
suspend fun fetchUser(id: Int): String {
    delay(500)   // simulate network delay
    return "User#\$id"
}

suspend fun fetchPosts(user: String): List<String> {
    delay(300)
    return listOf("Post1 by \$user", "Post2 by \$user")
}

suspend fun fetchWeather(city: String): String {
    delay(400)
    return "Sunny in \$city"
}

fun main() = runBlocking {
    // Basic coroutine with launch
    println("Start")

    val job = launch {
        delay(1000)
        println("Coroutine done!")
    }

    println("Launched — main continues")
    job.join()   // wait for the coroutine to finish
    println("After join")

    // Sequential suspending calls
    println("\\n--- Sequential ---")
    val start = System.currentTimeMillis()
    val user = fetchUser(1)
    val posts = fetchPosts(user)
    println("Got\${
posts.size} posts for \$user")
    println("Sequential time:\${
System.currentTimeMillis() - start}ms")
    // ~800ms (500 + 300 sequential)

    // Parallel with async
    println("\\n--- Parallel with async ---")
    val start2 = System.currentTimeMillis()

    val userDeferred = async { fetchUser(2) }
    val weatherDeferred = async { fetchWeather("Portland") }

    val user2 = userDeferred.await()
    val weather = weatherDeferred.await()
    println("User: \$user2, Weather: \$weather")
    println("Parallel time:\${
System.currentTimeMillis() - start2}ms")
    // ~500ms (both run simultaneously)

    // coroutineScope — structured
    println("\\n--- coroutineScope ---")
    coroutineScope {
        launch { delay(200); println("Child 1 done") }
        launch { delay(100); println("Child 2 done") }
        println("Children launched, waiting...")
    }
    println("coroutineScope done — all children finished")

    // Dispatcher
    println("\\n--- Dispatchers ---")
    launch(Dispatchers.Default) {
        val result = (1..1_000_000).sum()
        println("CPU work result: \$result")
    }.join()

    // Multiple async with awaitAll
    println("\\n--- awaitAll ---")
    val users = (1..5).map { id ->
        async { fetchUser(id) }
    }.awaitAll()
    println("Fetched: \$users")

    // Cancellation
    println("\\n--- Cancellation ---")
    val cancelJob = launch {
        repeat(10) { i ->
            delay(200)
            println("  Tick \$i")
        }
    }
    delay(550)   // let it tick a few times
    cancelJob.cancel()
    println("Job cancelled")
    cancelJob.join()
    println("Done")
}

📝 KEY POINTS:
✅ suspend functions can pause without blocking the thread
✅ launch → fire and forget; async → returns a value via await()
✅ delay() suspends the coroutine — does NOT block the thread
✅ runBlocking is for main() and tests — not for production async code
✅ Structured concurrency: parent waits for all children
✅ Use Dispatchers.IO for network/file, Dispatchers.Default for CPU
✅ awaitAll() runs multiple async tasks in parallel
✅ Cancelling a parent cancels all its child coroutines
❌ Never use Thread.sleep() inside a coroutine — use delay()
❌ Avoid GlobalScope — it bypasses structured concurrency
❌ Don't call .await() immediately after async — that defeats parallelism
❌ suspend functions can only be called from coroutines or other suspend fns
""",
  quiz: [
    Quiz(question: 'What is the key difference between delay() and Thread.sleep() inside a coroutine?', options: [
      QuizOption(text: 'delay() suspends only the coroutine, freeing the thread; Thread.sleep() blocks the entire thread', correct: true),
      QuizOption(text: 'delay() is more accurate; Thread.sleep() can drift by milliseconds', correct: false),
      QuizOption(text: 'Thread.sleep() works inside coroutines; delay() only works in suspend functions', correct: false),
      QuizOption(text: 'They are identical inside a coroutine — both free the thread', correct: false),
    ]),
    Quiz(question: 'What is the difference between launch and async?', options: [
      QuizOption(text: 'launch fires and forgets (returns Job); async returns a Deferred<T> you await for a result', correct: true),
      QuizOption(text: 'launch runs in parallel; async runs sequentially', correct: false),
      QuizOption(text: 'launch is for IO operations; async is for CPU work', correct: false),
      QuizOption(text: 'async is faster than launch because it skips structured concurrency', correct: false),
    ]),
    Quiz(question: 'What happens to child coroutines when a parent coroutine is cancelled?', options: [
      QuizOption(text: 'All child coroutines are also cancelled — this is structured concurrency', correct: true),
      QuizOption(text: 'Child coroutines continue running until they finish naturally', correct: false),
      QuizOption(text: 'Only children that are in a delay() are cancelled; active children continue', correct: false),
      QuizOption(text: 'Children are paused until the parent is restarted', correct: false),
    ]),
  ],
);
