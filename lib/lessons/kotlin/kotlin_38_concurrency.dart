import '../../models/lesson.dart';
import '../../models/quiz.dart';

final kotlinLesson38 = Lesson(
  language: 'Kotlin',
  title: 'Concurrency and Thread Safety',
  content: """
🎯 METAPHOR:
Concurrency is like multiple chefs cooking in the same
kitchen at the same time. Usually this is faster — one
chops, one sauces, one plates. But if two chefs both reach
for the same knife at the same moment (shared mutable state),
chaos ensues. One might get cut, or the knife might end up
in the wrong place. Thread safety is like having clear
kitchen rules: "Only one chef at a time at the knife block"
(mutex lock), or "Each chef gets their own set of knives"
(thread-local state), or "We only use knives that are safe
for multiple simultaneous grabs" (atomic operations).

📖 EXPLANATION:
Concurrency means multiple tasks running simultaneously.
Thread safety means shared data stays consistent when
accessed by multiple threads at once.

─────────────────────────────────────
THREADS IN KOTLIN/JVM:
─────────────────────────────────────
  // Creating a thread (Java-style)
  val thread = Thread {
      println("Running on: ${
Thread.currentThread().name}")
  }
  thread.start()
  thread.join()

  // Kotlin thread helper
  val t = thread(start = true) {
      println("Kotlin thread shortcut")
  }

─────────────────────────────────────
THE PROBLEM — RACE CONDITIONS:
─────────────────────────────────────
  var counter = 0

  // 1000 threads all increment counter
  repeat(1000) {
      thread { counter++ }  // ❌ NOT thread-safe!
  }
  // counter likely NOT 1000 — race condition!

counter++ is three operations: read → increment → write.
Two threads can both read before either writes.

─────────────────────────────────────
SOLUTION 1 — AtomicInteger (lock-free):
─────────────────────────────────────
  val counter = java.util.concurrent.atomic.AtomicInteger(0)
  repeat(1000) {
      thread { counter.incrementAndGet() }
  }
  // counter.get() == 1000 ✅ — always correct

Atomic operations complete without locks — uses CPU
instructions that are inherently thread-safe.

─────────────────────────────────────
SOLUTION 2 — @Volatile:
─────────────────────────────────────
Ensures all threads see the latest written value.
Does NOT make compound operations atomic.

  @Volatile var isRunning = false

  // One thread sets it:
  isRunning = true

  // Other threads always see the latest value:
  while (isRunning) { /* work */ }

─────────────────────────────────────
SOLUTION 3 — synchronized:
─────────────────────────────────────
Only one thread at a time can execute a synchronized block
on the same lock object.

  val lock = Any()
  var counter = 0

  synchronized(lock) {
      counter++   // only one thread at a time
  }

  // On a function:
  @Synchronized
  fun increment() { counter++ }

─────────────────────────────────────
SOLUTION 4 — Mutex (coroutines):
─────────────────────────────────────
The coroutine-friendly equivalent of synchronized.
Does NOT block a thread — suspends the coroutine.

  import kotlinx.coroutines.sync.Mutex
  import kotlinx.coroutines.sync.withLock

  val mutex = Mutex()
  var counter = 0

  coroutineScope {
      repeat(1000) {
          launch {
              mutex.withLock {
                  counter++   // safe
              }
          }
      }
  }

─────────────────────────────────────
THREAD-SAFE COLLECTIONS:
─────────────────────────────────────
  // Java's concurrent collections — thread-safe
  val map = ConcurrentHashMap<String, Int>()
  val queue = LinkedBlockingQueue<Task>()
  val list = CopyOnWriteArrayList<String>()

  // Kotlin's collections are NOT thread-safe by default
  // listOf(), mutableListOf() — single-threaded use only

─────────────────────────────────────
COROUTINES vs THREADS:
─────────────────────────────────────
  Feature          Threads           Coroutines
  ─────────────────────────────────────────────────
  Weight           Heavy (MB each)   Lightweight (KB each)
  Blocking         Blocks OS thread  Suspends only
  Count            ~1000 max         Millions possible
  Switching        OS context switch Cooperative (cheap)
  API              Complex (locks)   Simple (suspend)

  For most Kotlin async work → prefer coroutines.
  For CPU-bound parallel work → threads or Dispatchers.Default.

─────────────────────────────────────
ACTORS (coroutine-based message passing):
─────────────────────────────────────
Instead of shared mutable state, use message passing.
One coroutine owns the state; others send messages.

  val counterActor = actor<Int> {
      var count = 0
      for (msg in channel) {
          count += msg
      }
  }
  counterActor.send(1)  // send a message — no shared state!

💻 CODE:
import java.util.concurrent.atomic.AtomicInteger
import java.util.concurrent.ConcurrentHashMap
import java.util.concurrent.CountDownLatch
import kotlinx.coroutines.*
import kotlinx.coroutines.sync.Mutex
import kotlinx.coroutines.sync.withLock
import kotlin.concurrent.thread

fun raceConditionDemo() {
    println("=== Race Condition Demo ===")

    // UNSAFE — race condition
    var unsafeCounter = 0
    val latch = CountDownLatch(100)
    repeat(100) {
        thread {
            repeat(100) { unsafeCounter++ }
            latch.countDown()
        }
    }
    latch.await()
    println("Unsafe counter: \$unsafeCounter (expected 10000, likely less)")

    // SAFE — atomic
    val safeCounter = AtomicInteger(0)
    val latch2 = CountDownLatch(100)
    repeat(100) {
        thread {
            repeat(100) { safeCounter.incrementAndGet() }
            latch2.countDown()
        }
    }
    latch2.await()
    println("Safe counter:   ${
safeCounter.get()} (expected 10000, always correct)")
}

fun synchronizedDemo() {
    println("\\n=== Synchronized Demo ===")

    class SafeCounter {
        private var count = 0
        private val lock = Any()

        fun increment() = synchronized(lock) { count++ }
        fun decrement() = synchronized(lock) { count-- }
        fun get() = synchronized(lock) { count }
    }

    val counter = SafeCounter()
    val latch = CountDownLatch(10)
    repeat(10) { i ->
        thread {
            repeat(1000) {
                if (it % 2 == 0) counter.increment() else counter.decrement()
            }
            latch.countDown()
        }
    }
    latch.await()
    println("Synchronized counter: ${
counter.get()} (operations balance to 0)")
}

fun volatileDemo() {
    println("\\n=== Volatile Demo ===")

    class Worker {
        @Volatile var running = false

        fun start() {
            running = true
            thread {
                var ops = 0
                while (running) { ops++ }
                println("Worker stopped after \$ops operations")
            }
        }

        fun stop() { running = false }
    }

    val worker = Worker()
    worker.start()
    Thread.sleep(10)
    worker.stop()
    Thread.sleep(50)  // give thread time to print
}

fun coroutineMutexDemo() = runBlocking {
    println("\\n=== Coroutine Mutex Demo ===")

    val mutex = Mutex()
    var sharedList = mutableListOf<Int>()

    // Multiple coroutines safely modifying shared list
    coroutineScope {
        repeat(10) { i ->
            launch {
                delay((Math.random() * 10).toLong())
                mutex.withLock {
                    sharedList.add(i)
                }
            }
        }
    }

    println("Shared list (10 items): ${
sharedList.sorted()}")

    // Counting with coroutines + mutex
    var counter = 0
    val counterMutex = Mutex()

    coroutineScope {
        repeat(1000) {
            launch(Dispatchers.Default) {
                counterMutex.withLock { counter++ }
            }
        }
    }
    println("Coroutine mutex counter: \$counter (expected 1000)")
}

fun threadSafeCollectionsDemo() {
    println("\\n=== Thread-Safe Collections ===")

    val map = ConcurrentHashMap<String, Int>()
    val latch = CountDownLatch(10)

    repeat(10) { threadId ->
        thread {
            repeat(100) { i ->
                map["thread\$threadId-item\$i"] = i
            }
            latch.countDown()
        }
    }
    latch.await()
    println("ConcurrentHashMap size: ${
map.size} (expected 1000)")

    // Atomic operations on ConcurrentHashMap
    val wordCount = ConcurrentHashMap<String, AtomicInteger>()
    val words = listOf("kotlin", "java", "kotlin", "python", "kotlin", "java")
    val latch2 = CountDownLatch(words.size)

    words.forEach { word ->
        thread {
            wordCount.getOrPut(word) { AtomicInteger(0) }.incrementAndGet()
            latch2.countDown()
        }
    }
    latch2.await()
    println("Word counts: ${
wordCount.mapValues { it.value.get() }}")
}

fun main() {
    raceConditionDemo()
    synchronizedDemo()
    volatileDemo()
    coroutineMutexDemo()
    threadSafeCollectionsDemo()
}

📝 KEY POINTS:
✅ Race conditions occur when multiple threads read-modify-write shared state
✅ AtomicInteger/AtomicReference provide lock-free thread-safe operations
✅ @Volatile ensures visibility of latest value across threads
✅ synchronized blocks mutual exclusion — only one thread at a time
✅ Mutex is the coroutine-friendly version of synchronized — suspends, not blocks
✅ ConcurrentHashMap and other java.util.concurrent types are thread-safe
✅ Prefer coroutines + Mutex for async code; Atomic types for simple counters
✅ CountDownLatch and other java.util.concurrent tools coordinate threads
❌ counter++ is NOT atomic — three operations under the hood
❌ @Volatile alone doesn't make compound operations safe
❌ synchronized on different lock objects provides NO mutual exclusion
❌ Kotlin's mutableListOf() is NOT thread-safe — use CopyOnWriteArrayList
""",
  quiz: [
    Quiz(question: 'Why is counter++ not thread-safe in a multi-threaded environment?', options: [
      QuizOption(text: 'It is actually three operations (read, increment, write) — two threads can both read before either writes', correct: true),
      QuizOption(text: 'The ++ operator is not supported in JVM bytecode for concurrent use', correct: false),
      QuizOption(text: 'Integer variables cannot be shared between threads on the JVM', correct: false),
      QuizOption(text: 'The JIT compiler optimizes away increments in concurrent code', correct: false),
    ]),
    Quiz(question: 'What is the key difference between synchronized and Mutex in Kotlin coroutines?', options: [
      QuizOption(text: 'synchronized blocks the OS thread; Mutex suspends the coroutine, freeing the thread for other work', correct: true),
      QuizOption(text: 'synchronized is for coroutines; Mutex is for raw threads', correct: false),
      QuizOption(text: 'Mutex is faster; synchronized is safer', correct: false),
      QuizOption(text: 'They are identical — Mutex is just a Kotlin wrapper around synchronized', correct: false),
    ]),
    Quiz(question: 'What does @Volatile guarantee on a variable?', options: [
      QuizOption(text: 'All threads always see the latest written value — but compound operations are still not atomic', correct: true),
      QuizOption(text: 'The variable cannot be modified after it is first assigned', correct: false),
      QuizOption(text: 'All operations on the variable are atomic and thread-safe', correct: false),
      QuizOption(text: 'The variable is stored in CPU registers for faster access', correct: false),
    ]),
  ],
);
