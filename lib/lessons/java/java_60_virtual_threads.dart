import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson60 = Lesson(
  language: 'Java',
  title: 'Virtual Threads (Java 21)',
  content: """
🎯 METAPHOR:
Traditional platform threads are like hotel rooms —
limited, expensive, each needing its own room permanently
reserved. If 10,000 guests check in simultaneously, the
hotel can only handle as many as it has rooms (usually
hundreds, not thousands). Virtual threads are like hotel
keys that get re-assigned: when a guest leaves their room
temporarily (blocks on I/O), another guest gets the key
instantly. The hotel can now handle millions of "guests"
with a handful of actual rooms — because most guests are
away from their rooms most of the time (blocked on network,
database, or files). Same building, dramatically more capacity.

📖 EXPLANATION:
Virtual threads (Project Loom, finalized in Java 21) are
lightweight threads managed by the JVM, not the OS.
They enable writing simple blocking code that scales like
non-blocking code.

─────────────────────────────────────
PLATFORM THREADS vs VIRTUAL THREADS:
─────────────────────────────────────
  Platform thread:
  → 1:1 mapping to OS thread
  → ~2MB stack memory each
  → Typically hundreds to low thousands
  → OS context switch on blocking

  Virtual thread:
  → M:N mapping: many virtual → few carrier (OS) threads
  → ~few KB on heap
  → Millions possible
  → JVM handles parking/unmounting on blocking

─────────────────────────────────────
CREATING VIRTUAL THREADS:
─────────────────────────────────────
  // Single virtual thread:
  Thread vt = Thread.ofVirtual().start(() -> doWork());
  Thread vt = Thread.ofVirtual().name("worker").start(runnable);

  // Virtual thread executor (one virtual thread per task):
  ExecutorService exec = Executors.newVirtualThreadPerTaskExecutor();
  exec.submit(() -> doWork());
  exec.shutdown();

  // Using thread factory:
  ThreadFactory factory = Thread.ofVirtual().factory();
  ExecutorService pool = Executors.newThreadPerTaskExecutor(factory);

─────────────────────────────────────
WHEN VIRTUAL THREADS SHINE:
─────────────────────────────────────
  ✅ I/O-bound tasks: HTTP calls, database queries, file I/O
  ✅ Thread-per-request servers (web servers, APIs)
  ✅ Anywhere you'd previously use async/reactive to avoid thread limits

  ❌ CPU-bound tasks (no benefit — uses CPU regardless)
  ❌ Synchronized blocks with long holds (pinning issue)

─────────────────────────────────────
PINNING — the key gotcha:
─────────────────────────────────────
  A virtual thread is "pinned" to its carrier thread when:
  → Inside a synchronized method or block
  → Calling native methods

  When pinned, blocking I/O DOES block the carrier thread.
  Solution: use java.util.concurrent locks (ReentrantLock)
  instead of synchronized for long-held locks.

─────────────────────────────────────
STRUCTURED CONCURRENCY (Java 21 preview):
─────────────────────────────────────
  A pattern for managing groups of virtual threads:

  try (var scope = new StructuredTaskScope.ShutdownOnFailure()) {
      Future<String>  user  = scope.fork(() -> fetchUser(id));
      Future<Integer> score = scope.fork(() -> fetchScore(id));
      scope.join();           // wait for all
      scope.throwIfFailed();  // propagate any exception
      return new Result(user.get(), score.get());
  }

  ShutdownOnFailure: cancel all if any fails
  ShutdownOnSuccess: cancel all when first succeeds

─────────────────────────────────────
THREAD LOCALS WITH VIRTUAL THREADS:
─────────────────────────────────────
  ThreadLocal still works but can be expensive with millions
  of virtual threads (each gets its own copy).

  Java 21 introduces ScopedValue as a lighter alternative:
  static final ScopedValue<String> USER_ID = ScopedValue.newInstance();

  ScopedValue.where(USER_ID, "alice").run(() -> {
      System.out.println(USER_ID.get()); // "alice"
  });

─────────────────────────────────────
MONITORING VIRTUAL THREADS:
─────────────────────────────────────
  Thread.currentThread().isVirtual()   → true if virtual
  Thread.currentThread().getName()     → name (if set)
  Thread.activeCount()                 → platform threads only

  JVM args for virtual thread debugging:
  -Djdk.tracePinnedThreads=full        → log pinning events

💻 CODE:
import java.util.concurrent.*;
import java.util.*;
import java.util.stream.*;
import java.time.*;
import java.time.temporal.*;

public class VirtualThreads {

    // Simulate blocking I/O (e.g., network call, DB query)
    static String simulateIO(String task, long delayMs) {
        try {
            Thread.sleep(delayMs);    // Virtual thread unmounts during sleep!
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
        return task + " completed by " + Thread.currentThread().getName()
            + " (virtual=" + Thread.currentThread().isVirtual() + ")";
    }

    public static void main(String[] args) throws Exception {

        // ─── SINGLE VIRTUAL THREAD ────────────────────────
        System.out.println("=== Single Virtual Thread ===");
        Thread vt = Thread.ofVirtual()
            .name("my-virtual-thread")
            .start(() -> {
                System.out.println("  Running: " + Thread.currentThread());
                System.out.println("  Is virtual: " + Thread.currentThread().isVirtual());
            });
        vt.join();

        // ─── PLATFORM vs VIRTUAL COMPARISON ──────────────
        System.out.println("\n=== Platform vs Virtual Thread Performance ===");
        int taskCount = 1_000;
        long delayMs  = 100; // simulated I/O delay per task

        // Platform threads (limited pool)
        Instant start1 = Instant.now();
        try (ExecutorService platform = Executors.newFixedThreadPool(50)) {
            List<Future<String>> futures = IntStream.range(0, taskCount)
                .mapToObj(i -> platform.submit(
                    () -> simulateIO("Task-" + i, delayMs)))
                .collect(Collectors.toList());
            for (Future<String> f : futures) f.get();
        }
        long platformMs = ChronoUnit.MILLIS.between(start1, Instant.now());

        // Virtual threads (one per task)
        Instant start2 = Instant.now();
        try (ExecutorService virtual = Executors.newVirtualThreadPerTaskExecutor()) {
            List<Future<String>> futures = IntStream.range(0, taskCount)
                .mapToObj(i -> virtual.submit(
                    () -> simulateIO("Task-" + i, delayMs)))
                .collect(Collectors.toList());
            for (Future<String> f : futures) f.get();
        }
        long virtualMs = ChronoUnit.MILLIS.between(start2, Instant.now());

        System.out.printf("  %d tasks with %dms I/O each:%n", taskCount, delayMs);
        System.out.printf("  Platform threads (pool=50): %,d ms%n", platformMs);
        System.out.printf("  Virtual threads (unlimited): %,d ms%n", virtualMs);
        System.out.printf("  Virtual speedup: ~%.1fx%n", (double)platformMs / virtualMs);

        // ─── CREATING MANY VIRTUAL THREADS ────────────────
        System.out.println("\n=== Creating Many Virtual Threads ===");
        int millionCount = 100_000;  // 100k to keep demo fast
        Instant start3 = Instant.now();

        List<Thread> vThreads = new ArrayList<>();
        for (int i = 0; i < millionCount; i++) {
            Thread t = Thread.ofVirtual().unstarted(() -> {
                try { Thread.sleep(1000); } catch (InterruptedException e) {}
            });
            vThreads.add(t);
        }
        vThreads.forEach(Thread::start);
        System.out.printf("  Started %,d virtual threads in %dms%n",
            millionCount,
            ChronoUnit.MILLIS.between(start3, Instant.now()));
        // Don't join them all — just show creation is cheap
        vThreads.forEach(Thread::interrupt);

        // ─── VIRTUAL THREAD NAMES ─────────────────────────
        System.out.println("\n=== Named Virtual Threads ===");
        var factory = Thread.ofVirtual()
            .name("worker-", 1)   // auto-numbered: worker-1, worker-2...
            .factory();

        List<Future<String>> named = new ArrayList<>();
        try (ExecutorService exec = Executors.newThreadPerTaskExecutor(factory)) {
            for (int i = 0; i < 5; i++) {
                named.add(exec.submit(() ->
                    "Done: " + Thread.currentThread().getName()));
            }
            for (Future<String> f : named) System.out.println("  " + f.get());
        }

        // ─── IS VIRTUAL CHECK ─────────────────────────────
        System.out.println("\n=== isVirtual() ===");
        Thread platformThread = new Thread(() ->
            System.out.println("  Platform: isVirtual=" + Thread.currentThread().isVirtual()));
        Thread virtualThread = Thread.ofVirtual().start(() ->
            System.out.println("  Virtual:  isVirtual=" + Thread.currentThread().isVirtual()));
        platformThread.start();
        platformThread.join();
        virtualThread.join();

        // ─── THREAD EXECUTOR PATTERNS ─────────────────────
        System.out.println("\n=== Common Usage Patterns ===");
        System.out.println("""
          // Web server handler (one virtual thread per request):
          ExecutorService handler = Executors.newVirtualThreadPerTaskExecutor();
          server.onRequest(req -> handler.submit(() -> handleRequest(req)));

          // Database query pool:
          try (ExecutorService exec = Executors.newVirtualThreadPerTaskExecutor()) {
              List<Future<User>> queries = userIds.stream()
                  .map(id -> exec.submit(() -> db.findUser(id)))
                  .collect(Collectors.toList());
              // All queries run concurrently — minimal latency
          }

          // Replace cached thread pool for I/O work:
          // Before: Executors.newCachedThreadPool()
          // After:  Executors.newVirtualThreadPerTaskExecutor()
          """);

        // ─── PINNING DEMO (avoid synchronized) ───────────
        System.out.println("=== Pinning: synchronized vs ReentrantLock ===");
        System.out.println("  // ❌ AVOID: synchronized pins virtual thread to carrier");
        System.out.println("  synchronized(lock) { doLongBlockingWork(); }");
        System.out.println();
        System.out.println("  // ✅ PREFER: ReentrantLock allows unmounting");
        System.out.println("  lock.lock();");
        System.out.println("  try { doLongBlockingWork(); }");
        System.out.println("  finally { lock.unlock(); }");
    }
}

📝 KEY POINTS:
✅ Virtual threads are lightweight — millions can exist where thousands of platform threads cannot
✅ Use Executors.newVirtualThreadPerTaskExecutor() to run one virtual thread per task
✅ Virtual threads shine for I/O-bound work — each unmounts during blocking operations
✅ Thread.ofVirtual().start(runnable) creates a single virtual thread
✅ Thread.currentThread().isVirtual() detects if running on a virtual thread
✅ Virtual threads use standard blocking APIs — no need for reactive/async patterns
✅ CPU-bound tasks get no benefit from virtual threads — use a fixed thread pool
✅ Use ReentrantLock instead of synchronized to avoid pinning
✅ Virtual threads make thread-per-request servers practical at scale
❌ Don't use synchronized with long-held locks in virtual threads — causes pinning
❌ Virtual threads don't improve CPU-bound tasks — they only help I/O-bound work
❌ ThreadLocal is costly with millions of virtual threads — consider ScopedValue (Java 21)
❌ -Djdk.tracePinnedThreads=full reveals pinning issues during development
""",
  quiz: [
    Quiz(question: 'What is the key advantage of virtual threads over platform threads for I/O-bound tasks?', options: [
      QuizOption(text: 'Virtual threads unmount from carrier threads during blocking I/O — allowing millions to wait simultaneously with minimal resources', correct: true),
      QuizOption(text: 'Virtual threads run I/O operations in parallel using multiple CPU cores', correct: false),
      QuizOption(text: 'Virtual threads bypass the operating system for all I/O, making it non-blocking', correct: false),
      QuizOption(text: 'Virtual threads have larger stack sizes that prevent I/O buffer overflows', correct: false),
    ]),
    Quiz(question: 'What causes a virtual thread to be "pinned" to its carrier thread?', options: [
      QuizOption(text: 'Entering a synchronized block or calling a native method — blocking I/O while pinned blocks the carrier thread too', correct: true),
      QuizOption(text: 'Using Thread.sleep() — sleep always pins the virtual thread', correct: false),
      QuizOption(text: 'Calling another virtual thread from within a virtual thread', correct: false),
      QuizOption(text: 'Creating too many virtual threads simultaneously — the JVM pins some to prevent memory overflow', correct: false),
    ]),
    Quiz(question: 'Which executor is best suited for running many concurrent I/O-bound tasks with virtual threads?', options: [
      QuizOption(text: 'Executors.newVirtualThreadPerTaskExecutor() — creates one virtual thread per submitted task', correct: true),
      QuizOption(text: 'Executors.newFixedThreadPool(n) — a fixed pool is more efficient than unlimited threads', correct: false),
      QuizOption(text: 'Executors.newCachedThreadPool() — it already handles virtual threads automatically', correct: false),
      QuizOption(text: 'Executors.newSingleThreadExecutor() — one thread handles all tasks sequentially', correct: false),
    ]),
  ],
);
