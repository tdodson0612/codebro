import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson31 = Lesson(
  language: 'Java',
  title: 'Concurrency and Threads',
  content: """
🎯 METAPHOR:
Threads are like cooks working in the same kitchen at the
same time. One chops vegetables, another stirs the sauce,
a third plates the food — simultaneously. This speeds up
the meal (concurrency). BUT: if two cooks both grab the
same knife at the same moment (shared mutable state), chaos
ensues — the knife is dropped, someone gets hurt. Thread
safety is the kitchen protocol: "Only one cook at the knife
block at a time" (synchronized), or "each cook gets their
own set of knives" (thread-local). Ignoring these rules
leads to race conditions — bugs that only appear under
specific timing, which are the hardest bugs to reproduce
and fix.

📖 EXPLANATION:
Java has built-in multithreading support. Threads allow
multiple tasks to run concurrently in the same JVM process.

─────────────────────────────────────
CREATING THREADS — TWO WAYS:
─────────────────────────────────────
  1. Extend Thread:
     class MyThread extends Thread {
         @Override
         public void run() { System.out.println("Running!"); }
     }
     new MyThread().start();

  2. Implement Runnable (preferred — separates task from thread):
     Runnable task = () -> System.out.println("Running!");
     new Thread(task).start();

     // Or with name:
     new Thread(task, "worker-1").start();

─────────────────────────────────────
THREAD LIFECYCLE:
─────────────────────────────────────
  NEW → RUNNABLE → RUNNING → (BLOCKED/WAITING) → TERMINATED

  Thread states:
  NEW        → created, not started
  RUNNABLE   → ready to run (scheduler decides when)
  RUNNING    → currently executing
  BLOCKED    → waiting for a monitor lock
  WAITING    → waiting indefinitely (join, wait)
  TIMED_WAIT → waiting for a timeout (sleep, wait(ms))
  TERMINATED → finished (run() returned or threw)

─────────────────────────────────────
THREAD CONTROL:
─────────────────────────────────────
  thread.start()          → start execution (calls run())
  thread.join()           → wait for thread to finish
  thread.join(timeout)    → wait up to timeout ms
  Thread.sleep(ms)        → pause current thread
  Thread.yield()          → hint to scheduler to switch
  thread.interrupt()      → signal thread to stop
  Thread.currentThread()  → reference to current thread
  thread.getName()        → thread's name
  thread.setDaemon(true)  → daemon thread (JVM won't wait)
  thread.setPriority(n)   → priority 1 (low) to 10 (high)

─────────────────────────────────────
RACE CONDITIONS AND SYNCHRONIZATION:
─────────────────────────────────────
  // ❌ UNSAFE — race condition on counter++:
  int counter = 0;
  // Multiple threads doing counter++ simultaneously → wrong!

  // ✅ SAFE 1 — synchronized method:
  synchronized void increment() { counter++; }

  // ✅ SAFE 2 — synchronized block:
  synchronized (this) { counter++; }

  // ✅ SAFE 3 — AtomicInteger (lock-free):
  AtomicInteger counter = new AtomicInteger(0);
  counter.incrementAndGet();

─────────────────────────────────────
VOLATILE:
─────────────────────────────────────
  Guarantees visibility — all threads see the latest write.
  Does NOT make compound operations atomic.

  volatile boolean running = true;
  // Thread A: running = false;
  // Thread B: while (running) { ... }  ← sees updated value

─────────────────────────────────────
ExecutorService — better than raw threads:
─────────────────────────────────────
  // Thread pool — reuses threads:
  ExecutorService pool = Executors.newFixedThreadPool(4);
  pool.submit(() -> doWork());          // fire and forget
  Future<Result> f = pool.submit(() -> compute()); // get result
  Result r = f.get();                   // blocks until done
  pool.shutdown();                      // graceful shutdown

  Executors.newFixedThreadPool(n)    → n threads, queue rest
  Executors.newCachedThreadPool()    → grow/shrink as needed
  Executors.newSingleThreadExecutor()→ one thread, serial
  Executors.newScheduledThreadPool(n)→ scheduled tasks

─────────────────────────────────────
JAVA MEMORY MODEL BASICS:
─────────────────────────────────────
  Each thread has its own CPU cache — may see stale data.
  synchronized and volatile flush changes to main memory.
  Without synchronization: NO GUARANTEES of visibility.

💻 CODE:
import java.util.*;
import java.util.concurrent.*;
import java.util.concurrent.atomic.*;

public class ConcurrencyThreads {

    // ─── RACE CONDITION DEMO ──────────────────────────
    static int unsafeCounter = 0;
    static AtomicInteger safeCounter = new AtomicInteger(0);
    static final Object lock = new Object();
    static int syncCounter = 0;

    static void raceConditionDemo() throws InterruptedException {
        System.out.println("=== Race Condition Demo ===");
        int threadCount = 100, iterations = 1000;

        // UNSAFE — multiple threads increment without sync
        unsafeCounter = 0;
        List<Thread> threads = new ArrayList<>();
        for (int i = 0; i < threadCount; i++) {
            Thread t = new Thread(() -> {
                for (int j = 0; j < iterations; j++) unsafeCounter++;
            });
            threads.add(t);
            t.start();
        }
        for (Thread t : threads) t.join();
        System.out.printf("  Unsafe  (expected %,d): %,d%n",
            threadCount * iterations, unsafeCounter);

        // SAFE — AtomicInteger
        safeCounter.set(0);
        threads.clear();
        for (int i = 0; i < threadCount; i++) {
            Thread t = new Thread(() -> {
                for (int j = 0; j < iterations; j++) safeCounter.incrementAndGet();
            });
            threads.add(t);
            t.start();
        }
        for (Thread t : threads) t.join();
        System.out.printf("  Atomic  (expected %,d): %,d ✅%n",
            threadCount * iterations, safeCounter.get());

        // SAFE — synchronized block
        syncCounter = 0;
        threads.clear();
        for (int i = 0; i < threadCount; i++) {
            Thread t = new Thread(() -> {
                for (int j = 0; j < iterations; j++) {
                    synchronized (lock) { syncCounter++; }
                }
            });
            threads.add(t);
            t.start();
        }
        for (Thread t : threads) t.join();
        System.out.printf("  Synced  (expected %,d): %,d ✅%n",
            threadCount * iterations, syncCounter);
    }

    // ─── EXECUTOR SERVICE ─────────────────────────────
    static void executorDemo() throws InterruptedException, ExecutionException {
        System.out.println("\n=== ExecutorService ===");

        ExecutorService pool = Executors.newFixedThreadPool(4);

        // Submit tasks — fire and forget
        for (int i = 1; i <= 6; i++) {
            final int taskId = i;
            pool.submit(() -> {
                System.out.printf("  Task %d started on %s%n",
                    taskId, Thread.currentThread().getName());
                try { Thread.sleep(50); } catch (InterruptedException e) {}
                System.out.printf("  Task %d done%n", taskId);
            });
        }

        // Submit tasks with results — Future<T>
        System.out.println("\n  Tasks with results (Future):");
        List<Future<Integer>> futures = new ArrayList<>();
        for (int i = 1; i <= 5; i++) {
            final int n = i;
            futures.add(pool.submit(() -> {
                Thread.sleep(10 * n);     // simulate varying work time
                return n * n;             // return n²
            }));
        }

        for (Future<Integer> f : futures) {
            System.out.println("  Result: " + f.get()); // blocks until done
        }

        pool.shutdown();
        pool.awaitTermination(5, TimeUnit.SECONDS);
    }

    // ─── CALLABLE AND FUTURE ──────────────────────────
    static void callableDemo() throws Exception {
        System.out.println("\n=== Callable + invokeAll ===");

        ExecutorService pool = Executors.newFixedThreadPool(3);

        // invokeAll — submit all and wait for all
        List<Callable<String>> tasks = Arrays.asList(
            () -> { Thread.sleep(100); return "Task A: " + (3*3); },
            () -> { Thread.sleep(50);  return "Task B: " + (4*4); },
            () -> { Thread.sleep(75);  return "Task C: " + (5*5); }
        );

        List<Future<String>> results = pool.invokeAll(tasks);
        for (Future<String> f : results) {
            System.out.println("  " + f.get());
        }

        // invokeAny — return first to complete
        String first = pool.invokeAny(tasks);
        System.out.println("  First completed: " + first);

        pool.shutdown();
    }

    // ─── THREAD-SAFE COLLECTIONS ──────────────────────
    static void threadSafeCollections() throws InterruptedException {
        System.out.println("\n=== Thread-Safe Collections ===");

        // ConcurrentHashMap — thread-safe map
        ConcurrentHashMap<String, Integer> wordCount = new ConcurrentHashMap<>();
        String[] words = {"java", "thread", "java", "concurrent", "thread", "java"};

        ExecutorService pool = Executors.newFixedThreadPool(3);
        for (String word : words) {
            pool.submit(() ->
                wordCount.merge(word, 1, Integer::sum));
        }
        pool.shutdown();
        pool.awaitTermination(1, TimeUnit.SECONDS);
        System.out.println("  Word counts: " + new TreeMap<>(wordCount));

        // BlockingQueue — producer-consumer
        System.out.println("\n  Producer-Consumer (BlockingQueue):");
        BlockingQueue<Integer> queue = new LinkedBlockingQueue<>(5);
        AtomicBoolean done = new AtomicBoolean(false);

        Thread producer = new Thread(() -> {
            try {
                for (int i = 1; i <= 8; i++) {
                    queue.put(i);
                    System.out.println("    Produced: " + i);
                    Thread.sleep(20);
                }
                done.set(true);
            } catch (InterruptedException e) {}
        }, "Producer");

        Thread consumer = new Thread(() -> {
            try {
                while (!done.get() || !queue.isEmpty()) {
                    Integer item = queue.poll(100, TimeUnit.MILLISECONDS);
                    if (item != null)
                        System.out.println("    Consumed: " + item);
                }
            } catch (InterruptedException e) {}
        }, "Consumer");

        producer.start();
        consumer.start();
        producer.join();
        consumer.join();
    }

    // ─── SCHEDULED EXECUTOR ───────────────────────────
    static void scheduledDemo() throws InterruptedException {
        System.out.println("\n=== ScheduledExecutorService ===");
        ScheduledExecutorService scheduler = Executors.newScheduledThreadPool(2);

        AtomicInteger tickCount = new AtomicInteger(0);

        ScheduledFuture<?> periodic = scheduler.scheduleAtFixedRate(() -> {
            int tick = tickCount.incrementAndGet();
            System.out.println("  Tick #" + tick + " at " +
                System.currentTimeMillis() % 10000);
        }, 0, 100, TimeUnit.MILLISECONDS);

        Thread.sleep(350);   // let it tick a few times
        periodic.cancel(false);
        scheduler.shutdown();
        System.out.println("  Scheduled task cancelled after " +
            tickCount.get() + " ticks");
    }

    public static void main(String[] args) throws Exception {
        raceConditionDemo();
        executorDemo();
        callableDemo();
        threadSafeCollections();
        scheduledDemo();
    }
}

📝 KEY POINTS:
✅ Prefer Runnable/Callable over extending Thread — separates task from mechanism
✅ ExecutorService manages thread pools — reuse threads instead of creating new ones
✅ Future<T> represents a pending result — call get() to wait for it
✅ AtomicInteger/AtomicLong provide lock-free thread-safe operations
✅ synchronized ensures only one thread enters a block at a time
✅ volatile ensures visibility — all threads see the latest written value
✅ ConcurrentHashMap is thread-safe and much faster than synchronized HashMap
✅ BlockingQueue enables clean producer-consumer patterns
✅ Always shutdown() ExecutorService — leaked pools block JVM exit
❌ Extending Thread is discouraged — implement Runnable instead
❌ volatile alone doesn't make compound operations atomic (read-modify-write)
❌ Deadlock: thread A holds lock 1, waits for lock 2; thread B holds lock 2, waits for lock 1
❌ Don't call Thread.sleep() inside synchronized blocks — holds the lock while sleeping
""",
  quiz: [
    Quiz(question: 'Why is using AtomicInteger safer than a plain int for a shared counter?', options: [
      QuizOption(text: 'AtomicInteger uses CPU-level atomic instructions, making increment() indivisible — no race condition', correct: true),
      QuizOption(text: 'AtomicInteger automatically creates a new thread for each operation', correct: false),
      QuizOption(text: 'AtomicInteger is immutable, so concurrent access is always safe', correct: false),
      QuizOption(text: 'AtomicInteger uses synchronized internally, making it equivalent to a lock', correct: false),
    ]),
    Quiz(question: 'What does Future.get() do when called on a submitted task?', options: [
      QuizOption(text: 'Blocks the calling thread until the task completes and returns the result', correct: true),
      QuizOption(text: 'Returns immediately with null if the task hasn\'t finished yet', correct: false),
      QuizOption(text: 'Cancels the task and returns the partial result', correct: false),
      QuizOption(text: 'Polls the task status without blocking', correct: false),
    ]),
    Quiz(question: 'What does volatile guarantee about a shared variable?', options: [
      QuizOption(text: 'All threads always see the latest written value — but compound operations are still not atomic', correct: true),
      QuizOption(text: 'All operations on the variable are atomic and thread-safe', correct: false),
      QuizOption(text: 'The variable is stored in a special memory-mapped region shared by all threads', correct: false),
      QuizOption(text: 'The variable cannot be modified by more than one thread simultaneously', correct: false),
    ]),
  ],
);
