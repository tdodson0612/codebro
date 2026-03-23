import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson70 = Lesson(
  language: 'Java',
  title: 'Java Memory Model and Happens-Before',
  content: """
🎯 METAPHOR:
The Java Memory Model is like a company's information
security policy. Without it, different departments
(CPU cores/threads) work on their own private notepads
(CPU caches) and update the shared bulletin board
(main memory) only when convenient — which means
one department might act on stale information posted
by another. The memory model defines WHEN changes
must be published to the bulletin board for all
departments to see. "Happens-before" is the binding
order: "Team A's announcement officially precedes
Team B's response" — no ambiguity about which information
was current when Team B responded.

📖 EXPLANATION:
The Java Memory Model (JMM) defines how threads interact
through shared memory and what behaviors are guaranteed.

─────────────────────────────────────
THE PROBLEM — MEMORY VISIBILITY:
─────────────────────────────────────
  Modern CPUs have multiple levels of cache (L1, L2, L3).
  Each thread may see a cached version of a variable,
  not the latest value in main memory.

  // Thread A:
  boolean flag = false;  // in Thread A's cache

  // Thread B (running concurrently):
  while (!flag) { }     // may NEVER see flag become true!

  Without synchronization, Java makes NO GUARANTEE
  that Thread B will ever see Thread A's write to flag.

─────────────────────────────────────
HAPPENS-BEFORE — the formal guarantee:
─────────────────────────────────────
  Action X "happens-before" Action Y means:
  → X's effects are visible to Y
  → Y cannot see a state before X happened

  Built-in happens-before relationships:
  1. Same thread: each action HB the next action
  2. Monitor lock: unlock HB subsequent lock of same monitor
  3. volatile write HB subsequent read of same variable
  4. Thread.start() HB all actions in the started thread
  5. All actions in thread HB Thread.join() returning
  6. Object construction HB finalizer
  7. Static initializer HB first access to the class

─────────────────────────────────────
VOLATILE — visibility guarantee:
─────────────────────────────────────
  volatile boolean flag = false;

  // Thread A:
  // ... do some work ...
  flag = true;   // write → immediately flushed to main memory

  // Thread B:
  while (!flag) { }   // read → always fetches from main memory
  // flag is guaranteed to be true here

  volatile guarantees:
  ✅ Visibility: writes immediately visible to all threads
  ✅ Ordering: no reordering across volatile access

  volatile does NOT guarantee:
  ❌ Atomicity of compound operations (i++ is still 3 ops)

─────────────────────────────────────
REORDERING — the subtle danger:
─────────────────────────────────────
  The JVM and CPU are allowed to REORDER instructions
  for performance, as long as the result is correct
  within a SINGLE thread.

  // Thread A:
  a = 1;
  b = 2;   // may execute before a = 1!

  // Thread B:
  if (b == 2) {
      // a might still be 0 from Thread B's perspective!
  }

  synchronized, volatile, and Lock prevent problematic reordering.

─────────────────────────────────────
DOUBLE-CHECKED LOCKING — classic pitfall:
─────────────────────────────────────
  // ❌ BROKEN without volatile (reordering issue):
  if (instance == null) {
      synchronized (this) {
          if (instance == null) {
              instance = new Singleton();  // may be partially constructed!
          }
      }
  }

  // ✅ Fixed with volatile:
  private volatile static Singleton instance;
  if (instance == null) {
      synchronized (Singleton.class) {
          if (instance == null) {
              instance = new Singleton();
          }
      }
  }

  // ✅ Better: initialization-on-demand holder:
  private static class Holder {
      static final Singleton INSTANCE = new Singleton();
  }
  public static Singleton getInstance() { return Holder.INSTANCE; }

─────────────────────────────────────
ATOMIC VARIABLES — lock-free:
─────────────────────────────────────
  AtomicInteger counter = new AtomicInteger(0);
  counter.incrementAndGet()  // atomic: read-modify-write
  counter.compareAndSet(expected, newValue)  // CAS
  counter.getAndAdd(5)
  counter.updateAndGet(n -> n * 2)

  AtomicReference<T>, AtomicLong, AtomicBoolean,
  AtomicIntegerArray, AtomicReferenceArray

─────────────────────────────────────
SAFE PUBLICATION:
─────────────────────────────────────
  An object is "safely published" when it becomes visible
  to other threads in a fully constructed state.

  Safe publication mechanisms:
  ✅ Via static final field (class initialization)
  ✅ Via volatile write
  ✅ Via synchronized write (then read under same lock)
  ✅ Via AtomicReference
  ✅ Via thread-safe collections (ConcurrentHashMap.put)

  ❌ Unsafe: leaking 'this' reference in constructor

─────────────────────────────────────
MEMORY CONSISTENCY ERRORS IN PRACTICE:
─────────────────────────────────────
  // ❌ Race condition — incorrect, no synchronization:
  int count = 0;
  // Thread A: count++
  // Thread B: count++
  // Final count might be 1, not 2 (lost update)

  // ✅ Fixes:
  AtomicInteger count = new AtomicInteger();
  count.incrementAndGet();  // atomic — always correct

  // OR:
  synchronized(lock) { count++; }

  // OR (for long accumulation):
  LongAdder adder = new LongAdder();
  adder.increment();
  long total = adder.sum();  // read at end

💻 CODE:
import java.util.concurrent.*;
import java.util.concurrent.atomic.*;

public class JavaMemoryModel {
    // ─── VISIBILITY PROBLEM DEMO ──────────────────────────
    static boolean flag = false;          // ❌ no guarantee
    static volatile boolean vFlag = false; // ✅ guaranteed visible

    // ─── DOUBLE-CHECKED LOCKING (correct version) ─────────
    static volatile JavaMemoryModel instance;

    static JavaMemoryModel getInstance() {
        if (instance == null) {
            synchronized (JavaMemoryModel.class) {
                if (instance == null) {
                    instance = new JavaMemoryModel();
                }
            }
        }
        return instance;
    }

    // ─── INITIALIZATION-ON-DEMAND HOLDER ──────────────────
    static class SafeSingleton {
        private static final class Holder {
            static final SafeSingleton INSTANCE = new SafeSingleton();
        }
        public static SafeSingleton get() { return Holder.INSTANCE; }
    }

    public static void main(String[] args) throws Exception {

        // ─── ATOMIC OPERATIONS ────────────────────────────
        System.out.println("=== Atomic Variables ===");
        AtomicInteger counter = new AtomicInteger(0);
        AtomicLong    longVal = new AtomicLong(0L);
        AtomicBoolean boolVal = new AtomicBoolean(false);

        int threads = 10, iterations = 10_000;
        ExecutorService pool = Executors.newFixedThreadPool(threads);
        CountDownLatch latch = new CountDownLatch(threads);

        for (int t = 0; t < threads; t++) {
            pool.submit(() -> {
                for (int i = 0; i < iterations; i++) {
                    counter.incrementAndGet();
                }
                latch.countDown();
            });
        }
        latch.await();
        pool.shutdown();
        System.out.printf("  Expected: %,d%n", threads * iterations);
        System.out.printf("  Got:      %,d (%s)%n", counter.get(),
            counter.get() == threads * iterations ? "✅ correct" : "❌ race condition");

        // ─── COMPARE AND SWAP ─────────────────────────────
        System.out.println("\n=== Compare-and-Set (CAS) ===");
        AtomicReference<String> ref = new AtomicReference<>("initial");
        System.out.println("  Value: " + ref.get());

        boolean set1 = ref.compareAndSet("initial", "updated");
        System.out.println("  CAS 'initial'→'updated': " + set1 + " → " + ref.get());

        boolean set2 = ref.compareAndSet("initial", "again");  // wrong expected value
        System.out.println("  CAS 'initial'→'again':   " + set2 + " → " + ref.get());

        // ─── ATOMIC UPDATE PATTERNS ───────────────────────
        System.out.println("\n=== Atomic Update Patterns ===");
        AtomicInteger ai = new AtomicInteger(10);
        System.out.println("  getAndIncrement: " + ai.getAndIncrement() + " (was 10, now " + ai.get() + ")");
        System.out.println("  updateAndGet(×2):" + ai.updateAndGet(n -> n * 2));
        System.out.println("  accumulateAndGet:" + ai.accumulateAndGet(5, Integer::sum));
        System.out.println("  getAndSet(100):  " + ai.getAndSet(100));
        System.out.println("  Final:           " + ai.get());

        // ─── LONGADDER — HIGH CONTENTION COUNTER ──────────
        System.out.println("\n=== LongAdder (high-contention) ===");
        LongAdder adder = new LongAdder();
        ExecutorService pool2 = Executors.newFixedThreadPool(8);
        CountDownLatch latch2 = new CountDownLatch(8);

        for (int t = 0; t < 8; t++) {
            pool2.submit(() -> {
                for (int i = 0; i < 100_000; i++) adder.increment();
                latch2.countDown();
            });
        }
        latch2.await();
        pool2.shutdown();
        System.out.printf("  LongAdder result: %,d (expected %,d) %s%n",
            adder.sum(), 800_000L,
            adder.sum() == 800_000L ? "✅" : "❌");

        // ─── VOLATILE VISIBILITY ──────────────────────────
        System.out.println("\n=== Volatile Visibility ===");
        vFlag = false;
        Thread writer = new Thread(() -> {
            try { Thread.sleep(100); } catch (InterruptedException e) {}
            vFlag = true;
            System.out.println("  Writer: vFlag set to true");
        });

        Thread reader = new Thread(() -> {
            int spins = 0;
            while (!vFlag) { spins++; }   // volatile read — will see the update
            System.out.println("  Reader: saw vFlag=true after " + spins + " spins");
        });

        writer.start();
        reader.start();
        writer.join();
        reader.join();

        // ─── SINGLETON PATTERNS ───────────────────────────
        System.out.println("\n=== Thread-Safe Singleton Patterns ===");
        System.out.println("  1. volatile double-checked locking: getInstance()");
        System.out.println("  2. Initialization-on-demand holder: SafeSingleton.get()");
        System.out.println("  3. Enum singleton (best!): AppConfig.INSTANCE");
        System.out.println();
        System.out.println("  Enum singleton (preferred):");
        System.out.println("    enum MySingleton {");
        System.out.println("        INSTANCE;");
        System.out.println("        // fields and methods here");
        System.out.println("    }");
        System.out.println("    // Thread-safe, serialization-safe, reflection-safe!");

        // ─── HAPPENS-BEFORE SUMMARY ───────────────────────
        System.out.println("\n=== Happens-Before Summary ===");
        String[] hbRules = {
            "Thread start: all actions before start() HB all actions in the thread",
            "Thread join:  all actions in thread HB Thread.join() returning",
            "Volatile write HB subsequent volatile read of same variable",
            "Unlock HB subsequent lock of same monitor (synchronized)",
            "Static init HB first access to static field/method",
            "Object construction HB Object.finalize()",
        };
        for (String rule : hbRules) {
            System.out.println("  • " + rule);
        }
    }
}

📝 KEY POINTS:
✅ volatile guarantees visibility AND ordering — but NOT atomicity of compound ops
✅ volatile write happens-before volatile read of the same variable
✅ synchronized unlock happens-before subsequent lock of the same monitor
✅ Thread.start() happens-before all actions in the started thread
✅ AtomicInteger.incrementAndGet() is truly atomic — no race condition
✅ CAS (compareAndSet) is the foundation of lock-free data structures
✅ LongAdder outperforms AtomicLong under high contention (separate cells per thread)
✅ Safe publication: publish objects via final fields, volatile, or synchronized
✅ Enum singleton is the safest pattern — handles serialization and reflection
❌ volatile on int does NOT make i++ atomic (it's read + increment + write)
❌ Without synchronization, the JVM can reorder instructions across threads
❌ Double-checked locking without volatile is broken — partially constructed objects
❌ Never let 'this' escape from a constructor — other threads may see partial state
""",
  quiz: [
    Quiz(question: 'What does volatile guarantee that it does NOT guarantee?', options: [
      QuizOption(text: 'volatile guarantees visibility and ordering, but NOT atomicity — i++ on a volatile int is still a race condition', correct: true),
      QuizOption(text: 'volatile guarantees thread-safety for all operations on the variable', correct: false),
      QuizOption(text: 'volatile guarantees the variable is stored only in main memory with no caching', correct: false),
      QuizOption(text: 'volatile guarantees that only one thread can access the variable at a time', correct: false),
    ]),
    Quiz(question: 'What is the "happens-before" relationship?', options: [
      QuizOption(text: 'A formal guarantee that one action\'s effects are visible to another — preventing stale data across threads', correct: true),
      QuizOption(text: 'A thread scheduling rule that determines which thread executes first', correct: false),
      QuizOption(text: 'A performance hint to the JVM about instruction ordering optimization', correct: false),
      QuizOption(text: 'A compile-time check that ensures dependencies between methods are respected', correct: false),
    ]),
    Quiz(question: 'Why is LongAdder faster than AtomicLong under high contention?', options: [
      QuizOption(text: 'LongAdder uses separate cells per thread — reducing CAS failures; AtomicLong uses a single value all threads compete for', correct: true),
      QuizOption(text: 'LongAdder uses hardware-specific SIMD instructions unavailable to AtomicLong', correct: false),
      QuizOption(text: 'LongAdder skips overflow checking that AtomicLong performs on every operation', correct: false),
      QuizOption(text: 'LongAdder batches updates and writes once per second rather than immediately', correct: false),
    ]),
  ],
);
