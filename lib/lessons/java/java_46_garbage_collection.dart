import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson46 = Lesson(
  language: 'Java',
  title: 'Garbage Collection and JVM Memory',
  content: """
🎯 METAPHOR:
The JVM's garbage collector is like an invisible janitor
in an extremely busy hotel. Guests (objects) check in
(are created), use their rooms (are referenced), and
eventually leave (become unreachable). The janitor doesn't
evict guests — they just clean up the rooms after guests
have already LEFT. The janitor notices when a room has
had no activity and the key has been turned in (no
references remaining), then marks that room for cleaning.
Occasionally the hotel does a deep clean (major GC),
temporarily closing some floors (stop-the-world pause).
Good GC tuning is about minimizing how long the hotel
stays closed and how often it needs a deep clean.

📖 EXPLANATION:
Java's JVM manages memory automatically. Understanding this
helps you write memory-efficient code and diagnose issues.

─────────────────────────────────────
JVM MEMORY STRUCTURE:
─────────────────────────────────────
  ┌─────────────────────────────────────┐
  │              HEAP                   │
  │  ┌──────────────────────────────┐   │
  │  │   Young Generation           │   │
  │  │  ┌──────┐  ┌────┐  ┌────┐  │   │
  │  │  │ Eden │  │ S0 │  │ S1 │  │   │
  │  │  └──────┘  └────┘  └────┘  │   │
  │  └──────────────────────────────┘   │
  │  ┌──────────────────────────────┐   │
  │  │   Old Generation (Tenured)   │   │
  │  └──────────────────────────────┘   │
  └─────────────────────────────────────┘
  ┌─────────────┐  ┌──────────────────┐
  │  Metaspace  │  │   Stack (per     │
  │ (class data)│  │    thread)       │
  └─────────────┘  └──────────────────┘

  Eden          → new objects allocated here
  Survivor (S0/S1) → objects surviving minor GC
  Old Gen       → long-lived objects promoted here
  Metaspace     → class metadata (replaced PermGen in Java 8)
  Stack         → local variables, method frames (per thread)

─────────────────────────────────────
HOW GC WORKS:
─────────────────────────────────────
  MINOR GC (Young Generation):
  1. Eden fills up
  2. Live objects from Eden + one Survivor → other Survivor
  3. Objects surviving N cycles → promoted to Old Gen
  4. Fast (milliseconds), frequent

  MAJOR/FULL GC (Old Generation):
  1. Old Gen fills up
  2. "Stop-the-world" — all threads pause
  3. Slower (ms to seconds), infrequent

─────────────────────────────────────
GARBAGE COLLECTORS IN JAVA:
─────────────────────────────────────
  Serial GC          → single-threaded, small heaps
  Parallel GC        → multi-threaded, throughput-focused
  G1 GC (default)   → balanced latency + throughput (Java 9+)
  ZGC (Java 15+)    → ultra-low latency (<1ms pauses)
  Shenandoah        → similar to ZGC, Red Hat-developed

  For most applications: G1GC is fine.
  For latency-sensitive: ZGC or Shenandoah.

─────────────────────────────────────
KEY JVM FLAGS:
─────────────────────────────────────
  -Xms512m          → initial heap size 512MB
  -Xmx2g            → max heap size 2GB
  -Xss256k          → stack size per thread
  -XX:+UseG1GC      → use G1 garbage collector
  -XX:+UseZGC       → use ZGC
  -verbose:gc       → print GC events
  -XX:+PrintGCDetails → detailed GC output
  -XX:MaxGCPauseMillis=200 → target max pause time

─────────────────────────────────────
OBJECT LIFECYCLE:
─────────────────────────────────────
  Created (new) → referenced → unreachable → GC eligible → collected

  An object becomes unreachable when:
  → No variable holds a reference to it
  → No other reachable object has a reference to it

  // When is "hello" GC eligible?
  String s = new String("hello");
  s = null;   // now eligible — no references remain

─────────────────────────────────────
COMMON MEMORY ISSUES:
─────────────────────────────────────
  MEMORY LEAK: objects stay reachable longer than needed.
  Most common causes:
  → Static collections holding objects
  → Listeners never removed
  → Caches without eviction
  → ThreadLocal not cleaned up
  → Inner classes holding outer reference

  OutOfMemoryError: Java heap space
  → Heap is too small or you have a memory leak

  OutOfMemoryError: GC overhead limit exceeded
  → GC is spending > 98% of time collecting < 2% memory

─────────────────────────────────────
REFERENCE TYPES:
─────────────────────────────────────
  Strong (default)  → object never GC'd while referenced
  Soft              → GC'd under memory pressure (cache use)
  Weak              → GC'd at next collection
  Phantom           → for post-mortem finalization actions

  WeakHashMap → keys are weakly referenced — auto-evicted
  SoftReference → good for caches

💻 CODE:
import java.lang.ref.*;
import java.util.*;
import java.util.concurrent.*;

public class GCAndMemory {
    public static void main(String[] args) throws Exception {

        // ─── JVM MEMORY INFO ──────────────────────────────
        System.out.println("=== JVM Memory Information ===");
        Runtime runtime = Runtime.getRuntime();

        long maxMemory   = runtime.maxMemory();
        long totalMemory = runtime.totalMemory();
        long freeMemory  = runtime.freeMemory();
        long usedMemory  = totalMemory - freeMemory;

        System.out.printf("  Max heap:   %,d MB%n",   maxMemory   / 1_000_000);
        System.out.printf("  Total heap: %,d MB%n",   totalMemory / 1_000_000);
        System.out.printf("  Used heap:  %,d MB%n",   usedMemory  / 1_000_000);
        System.out.printf("  Free heap:  %,d MB%n",   freeMemory  / 1_000_000);
        System.out.printf("  Processors: %d%n",       runtime.availableProcessors());

        // ─── WEAK REFERENCE ───────────────────────────────
        System.out.println("\n=== Weak References ===");
        Object obj = new Object();
        WeakReference<Object> weakRef = new WeakReference<>(obj);

        System.out.println("  Before null: weakRef.get() = " + weakRef.get());
        obj = null;   // remove strong reference

        // May or may not be collected here — suggest GC
        System.gc();
        Thread.sleep(100);

        System.out.println("  After GC:    weakRef.get() = " + weakRef.get());
        // Likely null now — weak references are collected eagerly

        // ─── SOFT REFERENCE (for caches) ──────────────────
        System.out.println("\n=== Soft Reference (cache pattern) ===");
        class SimpleCache<K, V> {
            private final Map<K, SoftReference<V>> cache = new HashMap<>();

            public void put(K key, V value) {
                cache.put(key, new SoftReference<>(value));
            }

            public V get(K key) {
                SoftReference<V> ref = cache.get(key);
                return ref != null ? ref.get() : null;
            }

            public int size() {
                return (int) cache.values().stream()
                    .filter(r -> r.get() != null).count();
            }
        }

        SimpleCache<String, byte[]> cache = new SimpleCache<>();
        cache.put("data1", new byte[1_000]);
        cache.put("data2", new byte[1_000]);
        System.out.println("  Cache size: " + cache.size());
        System.out.println("  data1: " + (cache.get("data1") != null ? "present" : "evicted"));

        // ─── WEAKHASHMAP ──────────────────────────────────
        System.out.println("\n=== WeakHashMap ===");
        Map<Object, String> weakMap = new WeakHashMap<>();
        Object key1 = new Object();
        Object key2 = new Object();

        weakMap.put(key1, "value1");
        weakMap.put(key2, "value2");
        System.out.println("  Before: size = " + weakMap.size());

        key1 = null;   // remove strong reference to key1
        System.gc();
        Thread.sleep(100);

        System.out.println("  After GC: size = " + weakMap.size());
        // key1's entry may have been removed

        // ─── MEMORY LEAK DEMO (and fix) ───────────────────
        System.out.println("\n=== Memory Leak Pattern ===");

        class EventSource {
            private final List<Runnable> listeners = new ArrayList<>();

            // ❌ This is a memory leak — listeners never removed!
            public void addListener(Runnable listener) { listeners.add(listener); }
            public void removeListener(Runnable listener) { listeners.remove(listener); }
            public void fire() { listeners.forEach(Runnable::run); }
        }

        EventSource source = new EventSource();
        // ❌ Anonymous class holds reference to outer scope
        // In a real app, if 'source' stays alive, these listeners never GC:
        source.addListener(() -> System.out.println("  Listener 1 fired"));
        source.addListener(() -> System.out.println("  Listener 2 fired"));
        source.fire();
        System.out.println("  Listener count: " + 2);

        // ─── OBJECT CREATION RATE ─────────────────────────
        System.out.println("\n=== Object Creation Rate ===");
        Runtime rt = Runtime.getRuntime();
        rt.gc();
        long before = rt.totalMemory() - rt.freeMemory();

        // Create many short-lived objects
        List<String> temp = new ArrayList<>();
        for (int i = 0; i < 100_000; i++) {
            temp.add("item-" + i);   // creates 100k Strings
        }
        long after = rt.totalMemory() - rt.freeMemory();
        System.out.printf("  Memory used by 100k strings: ~%,d bytes%n", after - before);
        temp = null;  // eligible for GC

        // ─── MEMORY-EFFICIENT PATTERNS ────────────────────
        System.out.println("\n=== Memory-Efficient Patterns ===");

        // StringBuilder vs String concatenation
        long start = System.nanoTime();
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < 10_000; i++) sb.append("x");
        String built = sb.toString();
        long sbTime = System.nanoTime() - start;

        start = System.nanoTime();
        String concat = "";
        for (int i = 0; i < 1_000; i++) concat += "x";  // 1k only — would be very slow for 10k
        long concatTime = System.nanoTime() - start;

        System.out.printf("  StringBuilder (10k): %,d ns%n", sbTime);
        System.out.printf("  Concatenation (1k):  %,d ns%n", concatTime);
        System.out.println("  (StringBuilder scales linearly; concat scales quadratically)");

        // Reuse objects vs create new
        System.out.println("\n  Integer caching:");
        Integer a = 100, b = 100;   // cached (-128 to 127)
        Integer c = 200, d = 200;   // NOT cached

        System.out.println("  100 == 100 (same object): " + (a == b));   // true (cached)
        System.out.println("  200 == 200 (same object): " + (c == d));   // false (not cached)
        System.out.println("  200 equals 200:           " + c.equals(d)); // true

        // ─── GC FLAGS REFERENCE ───────────────────────────
        System.out.println("\n=== JVM Flags Reference ===");
        String[] flags = {
            "-Xms512m          → initial heap size",
            "-Xmx4g            → max heap size",
            "-Xss256k          → thread stack size",
            "-XX:+UseG1GC      → G1 collector (default in Java 9+)",
            "-XX:+UseZGC       → ZGC (low latency, Java 15+)",
            "-verbose:gc       → print GC events",
            "-XX:MaxGCPauseMillis=100 → target max pause",
            "-XX:+HeapDumpOnOutOfMemoryError → dump on OOME",
            "-XX:HeapDumpPath=/tmp/dump.hprof → dump location"
        };
        for (String flag : flags) {
            System.out.println("  " + flag);
        }
    }
}

📝 KEY POINTS:
✅ The JVM heap has Young (Eden + Survivors) and Old Generations
✅ Minor GC is fast and frequent; Major/Full GC is slower and rarer
✅ G1GC is the default since Java 9; ZGC offers <1ms pauses (Java 15+)
✅ Objects are GC eligible when NO reachable references point to them
✅ Soft references survive until memory pressure; Weak references are collected eagerly
✅ WeakHashMap allows entries to be GC'd when keys are no longer referenced
✅ Memory leaks in Java: static collections, unremoved listeners, caches without eviction
✅ StringBuilder is O(n) for concatenation; String + in loops is O(n²)
✅ Integers -128 to 127 are cached — use equals() not == for Integer comparison
❌ Don't rely on System.gc() — it's a hint, not a command
❌ OutOfMemoryError is NOT catchable in a meaningful way — prevent it
❌ Don't use finalizers — they're deprecated; use Cleaner or try-with-resources
❌ ThreadLocal leaks in thread pools — always call remove() when done
""",
  quiz: [
    Quiz(question: 'What happens to an object during a minor GC?', options: [
      QuizOption(text: 'Live objects in Eden are copied to a Survivor space; objects surviving enough cycles are promoted to Old Gen', correct: true),
      QuizOption(text: 'All objects in the heap are checked and unreachable ones are collected', correct: false),
      QuizOption(text: 'The entire Young Generation is cleared and rebuilt from scratch', correct: false),
      QuizOption(text: 'Objects are moved from Old Generation back to Young to make space', correct: false),
    ]),
    Quiz(question: 'What is the difference between a WeakReference and a SoftReference?', options: [
      QuizOption(text: 'WeakReference is collected at the next GC; SoftReference is kept until memory is needed (good for caches)', correct: true),
      QuizOption(text: 'SoftReference prevents GC entirely; WeakReference allows GC immediately', correct: false),
      QuizOption(text: 'WeakReference is for primitives; SoftReference is for objects', correct: false),
      QuizOption(text: 'They are identical — the names reflect their strength, not different behavior', correct: false),
    ]),
    Quiz(question: 'Why is string concatenation with + in a loop a performance problem?', options: [
      QuizOption(text: 'Each + creates a new String object — O(n²) memory and CPU as the string grows', correct: true),
      QuizOption(text: 'The JVM limits string concatenation to 1000 characters per operation', correct: false),
      QuizOption(text: '+ is not allowed in loops — the compiler rejects it at high iteration counts', correct: false),
      QuizOption(text: 'String + uses synchronized access which blocks all other threads', correct: false),
    ]),
  ],
);
