import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson75 = Lesson(
  language: 'Java',
  title: 'Performance Tuning and Profiling',
  content: """
🎯 METAPHOR:
Performance tuning without profiling is like a doctor
prescribing medication without running tests. "Your
app is slow — add more RAM!" might be completely wrong
if the real problem is an O(n²) algorithm, a blocking
I/O call on the main thread, or a memory leak causing
constant GC pressure. Profiling is the diagnostic test
that tells you WHERE time is actually being spent.
Once you know the bottleneck — the 5% of code that
consumes 95% of time — you fix THAT, not everything else.
"Premature optimization is the root of all evil" because
it wastes effort optimizing non-bottlenecks that the
user will never notice.

📖 EXPLANATION:
Systematic performance optimization: measure first,
optimize the bottleneck, measure again.

─────────────────────────────────────
THE PERFORMANCE WORKFLOW:
─────────────────────────────────────
  1. DEFINE: what is "fast enough"? (SLA, latency budget)
  2. MEASURE: find actual bottlenecks (don't guess!)
  3. OPTIMIZE: the hottest path only
  4. VERIFY: did it help? (measure again)
  5. REPEAT

─────────────────────────────────────
PROFILING TOOLS:
─────────────────────────────────────
  JVM-native:
  jvisualvm          → GUI profiler (bundled with JDK pre-9)
  jconsole           → lightweight JMX monitoring
  async-profiler     → low-overhead CPU + memory profiling
  Java Flight Recorder (JFR) → production-safe continuous recording

  IDE-integrated:
  IntelliJ Profiler  → built-in CPU + memory profiler
  Eclipse MAT        → memory analysis tool (heap dumps)

  Benchmarking:
  JMH (Java Microbenchmark Harness) → accurate micro-benchmarks
                                       avoids JIT/JVM warmup pitfalls

─────────────────────────────────────
JAVA FLIGHT RECORDER (JFR):
─────────────────────────────────────
  Low-overhead, production-safe profiling built into JDK:

  Start at launch:
  java -XX:+FlightRecorder
       -XX:StartFlightRecording=duration=60s,filename=app.jfr
       MyApp

  Or at runtime (Java 11+):
  jcmd <pid> JFR.start duration=60s filename=app.jfr
  jcmd <pid> JFR.stop

  View in: JDK Mission Control (JMC)
  Shows: CPU hotspots, GC events, thread states, I/O, locks

─────────────────────────────────────
COMMON JAVA PERFORMANCE ISSUES:
─────────────────────────────────────
  1. ALGORITHMIC — worst impact
     O(n²) where O(n log n) is possible
     Fix: better algorithm or data structure

  2. STRING CONCATENATION IN LOOPS
     String s = "";
     for (...) s += x;  // O(n²)!
     Fix: StringBuilder, String.join(), Collectors.joining()

  3. BOXING/UNBOXING IN HOT PATHS
     List<Integer> instead of int[]
     Fix: use primitives and primitive arrays/streams

  4. UNNECESSARY OBJECT CREATION
     new BigDecimal("0.1") in a loop
     Fix: cache and reuse, use primitive alternatives

  5. EXCESSIVE GC — memory pressure
     Many short-lived objects → frequent minor GC
     Fix: object pooling, reduce allocation rate

  6. BLOCKING I/O ON WRONG THREAD
     HTTP call on a UI/event thread
     Fix: async, virtual threads

  7. LOCK CONTENTION
     synchronized on hot path
     Fix: ConcurrentHashMap, atomic vars, reduced lock scope

  8. DATABASE — often the real bottleneck
     N+1 queries, missing indexes
     Fix: JOIN instead of loops, connection pool, query analysis

─────────────────────────────────────
MEASURING WITH System.nanoTime():
─────────────────────────────────────
  // Always use nanoTime(), NOT currentTimeMillis() for timing:
  long start = System.nanoTime();
  doWork();
  long elapsedNs = System.nanoTime() - start;
  double elapsedMs = elapsedNs / 1_000_000.0;

  // Pitfall: JVM warmup means first runs are slower
  // Always warm up before measuring:
  for (int i = 0; i < 10_000; i++) doWork();  // warmup
  start = System.nanoTime();
  for (int i = 0; i < 100_000; i++) doWork();  // measure
  // average over many iterations

─────────────────────────────────────
JMH — ACCURATE MICROBENCHMARKS:
─────────────────────────────────────
  @BenchmarkMode(Mode.AverageTime)
  @OutputTimeUnit(TimeUnit.MICROSECONDS)
  @Warmup(iterations = 5)
  @Measurement(iterations = 10)
  @Fork(2)
  public class MyBenchmark {
      @Benchmark
      public String stringConcatBad() {
          String s = "";
          for (int i = 0; i < 100; i++) s += i;
          return s;
      }

      @Benchmark
      public String stringBuilderGood() {
          StringBuilder sb = new StringBuilder();
          for (int i = 0; i < 100; i++) sb.append(i);
          return sb.toString();
      }
  }

─────────────────────────────────────
HEAP DUMP ANALYSIS:
─────────────────────────────────────
  // Trigger heap dump:
  jmap -dump:format=b,file=heap.hprof <pid>
  // Or on OOM:
  -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/tmp/

  Open heap.hprof in:
  → Eclipse MAT (Memory Analyzer Tool)
  → IntelliJ IDEA Profiler
  → jvisualvm

  Look for:
  → Objects with unexpectedly high retained heap
  → Growing data structures (memory leaks)
  → Duplicate large objects

─────────────────────────────────────
THREAD DUMP — diagnose deadlocks/hangs:
─────────────────────────────────────
  // Generate thread dump:
  jstack <pid>         → to stdout
  jcmd <pid> Thread.print → more structured

  Look for:
  → Threads in BLOCKED state (lock contention)
  → Deadlock: Thread A waits for B, B waits for A
  → Threads in WAITING (possible leak/stuck)

─────────────────────────────────────
QUICK WINS — highest ROI:
─────────────────────────────────────
  1. Right algorithm and data structure first
  2. SQL query optimization + indexes
  3. Cache frequently computed results
  4. Connection pooling (HikariCP)
  5. Async I/O or virtual threads for I/O-bound work
  6. Avoid N+1 query patterns
  7. Use StringBuilder for string building in loops

💻 CODE:
import java.util.*;
import java.util.stream.*;

public class PerformanceTuning {

    // ─── STRING CONCATENATION ─────────────────────────────
    static String concatWithPlus(int n) {
        String s = "";
        for (int i = 0; i < n; i++) s += i;
        return s;
    }

    static String concatWithBuilder(int n) {
        StringBuilder sb = new StringBuilder(n * 3);
        for (int i = 0; i < n; i++) sb.append(i);
        return sb.toString();
    }

    static String concatWithStream(int n) {
        return IntStream.range(0, n)
            .mapToObj(Integer::toString)
            .collect(Collectors.joining());
    }

    // ─── BOXING OVERHEAD ──────────────────────────────────
    static long sumBoxed(int n) {
        List<Integer> list = new ArrayList<>(n);
        for (int i = 0; i < n; i++) list.add(i);
        long sum = 0;
        for (Integer x : list) sum += x;
        return sum;
    }

    static long sumPrimitive(int n) {
        int[] arr = new int[n];
        for (int i = 0; i < n; i++) arr[i] = i;
        long sum = 0;
        for (int x : arr) sum += x;
        return sum;
    }

    static long sumStream(int n) {
        return IntStream.range(0, n).asLongStream().sum();
    }

    // ─── CACHING ──────────────────────────────────────────
    static Map<Integer, Long> fibCache = new HashMap<>();

    static long fibNaive(int n) {
        if (n <= 1) return n;
        return fibNaive(n - 1) + fibNaive(n - 2);
    }

    static long fibMemo(int n) {
        if (n <= 1) return n;
        return fibCache.computeIfAbsent(n, k -> fibMemo(k-1) + fibMemo(k-2));
    }

    static long time(Runnable r) {
        long t = System.nanoTime();
        r.run();
        return System.nanoTime() - t;
    }

    static void benchmark(String name, Runnable r, int warmup, int measure) {
        for (int i = 0; i < warmup; i++) r.run();
        long total = 0;
        for (int i = 0; i < measure; i++) total += time(r);
        System.out.printf("  %-35s %,6.0f ns/op%n", name + ":", (double)total / measure);
    }

    public static void main(String[] args) {

        // ─── STRING BENCHMARK ─────────────────────────────
        System.out.println("=== String Building Performance (n=1000) ===");
        int N = 1000;
        benchmark("String + concat",   () -> concatWithPlus(N),    5, 20);
        benchmark("StringBuilder",     () -> concatWithBuilder(N), 5, 100);
        benchmark("Collectors.joining",() -> concatWithStream(N),  5, 100);

        // ─── BOXING BENCHMARK ─────────────────────────────
        System.out.println("\n=== Boxing vs Primitive (n=100,000) ===");
        int M = 100_000;
        benchmark("List<Integer> sum", () -> sumBoxed(M),     3, 20);
        benchmark("int[] sum",         () -> sumPrimitive(M), 3, 50);
        benchmark("IntStream sum",     () -> sumStream(M),    3, 50);

        // ─── CACHING BENCHMARK ────────────────────────────
        System.out.println("\n=== Fibonacci Caching ===");
        // fib(30) naive vs memoized
        long t1 = System.nanoTime();
        long r1 = fibNaive(35);
        long t1ns = System.nanoTime() - t1;

        fibCache.clear();
        long t2 = System.nanoTime();
        long r2 = fibMemo(35);
        long t2ns = System.nanoTime() - t2;

        System.out.printf("  fib(35) naive:    %,d ns → %,d%n", t1ns, r1);
        System.out.printf("  fib(35) memoized: %,d ns → %,d%n", t2ns, r2);
        System.out.printf("  Speedup: %.0fx%n", (double)t1ns / t2ns);

        // ─── DATA STRUCTURE CHOICE ────────────────────────
        System.out.println("\n=== Data Structure Choice (1M lookups) ===");
        int SIZE = 100_000;
        List<Integer> list = IntStream.range(0, SIZE).boxed().collect(Collectors.toList());
        Set<Integer> set  = new HashSet<>(list);
        int target = SIZE / 2;

        benchmark("List.contains (O(n))",
            () -> list.contains(target), 3, 10);
        benchmark("HashSet.contains (O(1))",
            () -> set.contains(target), 3, 1000);

        // ─── COMMON PERF PATTERNS ─────────────────────────
        System.out.println("\n=== Performance Patterns Reference ===");
        String[][] patterns = {
            { "Algorithm/DS",     "Wrong algorithm is the #1 perf issue — fix first" },
            { "StringBuilder",    "String + in loops is O(n²) — use StringBuilder" },
            { "Primitives",       "Use int[] over List<Integer> in hot paths" },
            { "Caching",          "computeIfAbsent() for expensive repeated computations" },
            { "HashSet lookup",   "O(1) vs List.contains() O(n) — huge difference at scale" },
            { "Connection pool",  "HikariCP — don't create DB connections per request" },
            { "Virtual threads",  "For I/O-bound: newVirtualThreadPerTaskExecutor()" },
            { "Lazy init",        "Supplier<T> defers expensive work until needed" },
            { "JFR profiling",    "Enable in prod with < 1% overhead to find hotspots" },
        };
        for (String[] p : patterns) {
            System.out.printf("  %-18s → %s%n", p[0], p[1]);
        }

        // ─── JVM FLAGS FOR PROFILING ──────────────────────
        System.out.println("\n=== JVM Flags for Performance Diagnosis ===");
        String[][] flags = {
            { "-verbose:gc",            "Basic GC event logging" },
            { "-Xlog:gc*",              "Detailed GC logging (Java 9+)" },
            { "-XX:+PrintGCDetails",    "GC with cause and timing (pre-9)" },
            { "-XX:+PrintCompilation",  "Log JIT compiled methods" },
            { "-XX:+HeapDumpOnOutOfMemoryError", "Capture heap on OOME" },
            { "jstack <pid>",           "Thread dump — deadlocks and contention" },
            { "jcmd <pid> VM.info",     "JVM configuration summary" },
            { "jcmd <pid> GC.heap_info","Heap usage per region" },
        };
        for (String[] f : flags) {
            System.out.printf("  %-40s → %s%n", f[0], f[1]);
        }
    }
}

📝 KEY POINTS:
✅ Profile FIRST — identify actual bottlenecks before optimizing anything
✅ Use System.nanoTime() for timing; never currentTimeMillis() for micro-benchmarks
✅ Warm up the JVM before measuring — JIT compilation takes time to kick in
✅ JMH is the correct tool for accurate microbenchmarks in Java
✅ Java Flight Recorder: <1% overhead, safe for production, captures real workload data
✅ jstack thread dumps reveal deadlocks and lock contention instantly
✅ HashSet.contains() is O(1) — prefer it over List.contains() for repeated lookups
✅ StringBuilder over + concat in loops; IntStream over List<Integer> for numeric work
✅ Connection pooling (HikariCP) is often the single biggest win for DB-heavy apps
❌ Never optimize without measuring — you'll fix the wrong thing
❌ Micro-benchmarks without JMH are often misleading — JIT distorts naive timing
❌ The biggest bottleneck is almost always the database or I/O, not Java code
❌ Premature optimization introduces bugs and complexity before performance is even a problem
""",
  quiz: [
    Quiz(question: 'Why should you warm up the JVM before measuring Java performance?', options: [
      QuizOption(text: 'The JIT compiler optimizes "hot" methods over time — early iterations are slower and unrepresentative of steady-state performance', correct: true),
      QuizOption(text: 'The JVM requires warm-up time to load libraries from disk into RAM', correct: false),
      QuizOption(text: 'The garbage collector runs aggressively during startup and skews measurements', correct: false),
      QuizOption(text: 'Java threads need time to reach full CPU frequency before measurements are valid', correct: false),
    ]),
    Quiz(question: 'What does Java Flight Recorder (JFR) provide that makes it suitable for production?', options: [
      QuizOption(text: 'Continuous low-overhead profiling (<1% overhead) with CPU, GC, I/O, and thread data captured in the running application', correct: true),
      QuizOption(text: 'A complete record of every method call and object creation for full audit trails', correct: false),
      QuizOption(text: 'Real-time performance corrections that fix bottlenecks automatically', correct: false),
      QuizOption(text: 'A lock-free profiler that pauses the application to capture perfect snapshots', correct: false),
    ]),
    Quiz(question: 'What is the most common root cause of poor Java application performance in practice?', options: [
      QuizOption(text: 'Database queries — N+1 patterns, missing indexes, or inefficient queries dominate in most applications', correct: true),
      QuizOption(text: 'Excessive object creation and garbage collection pressure', correct: false),
      QuizOption(text: 'Java bytecode interpretation overhead compared to native code', correct: false),
      QuizOption(text: 'Thread context switching from too many platform threads', correct: false),
    ]),
  ],
);
