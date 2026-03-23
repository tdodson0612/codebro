import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson63 = Lesson(
  language: 'Java',
  title: 'Fork/Join Framework',
  content: """
🎯 METAPHOR:
The Fork/Join framework is like a recursive army of workers
attacking a huge task. The general looks at a pile of
10,000 letters to sort. Instead of sorting them all alone,
the general splits (forks) the pile in half and delegates
to two lieutenants. Each lieutenant splits again, and so on,
until the piles are small enough for one soldier to handle.
As each soldier finishes, results are collected back up
(join). The result: the full power of all available CPU
cores applied to a divide-and-conquer problem, with work
stolen between idle workers automatically.

📖 EXPLANATION:
The Fork/Join framework (java.util.concurrent.ForkJoinPool)
is designed for divide-and-conquer parallelism on
multi-core processors.

─────────────────────────────────────
KEY CLASSES:
─────────────────────────────────────
  ForkJoinPool       → the thread pool (uses all CPU cores)
  RecursiveTask<T>   → task that returns a result
  RecursiveAction    → task with no result (void)

  // Default pool (used by parallel streams too):
  ForkJoinPool.commonPool()

─────────────────────────────────────
RecursiveTask<T> PATTERN:
─────────────────────────────────────
  class SumTask extends RecursiveTask<Long> {
      private final int[] arr;
      private final int from, to;
      static final int THRESHOLD = 1000;

      @Override
      protected Long compute() {
          if (to - from <= THRESHOLD) {
              // Base case: small enough, compute directly
              long sum = 0;
              for (int i = from; i < to; i++) sum += arr[i];
              return sum;
          }
          // Split in half
          int mid = (from + to) / 2;
          SumTask left  = new SumTask(arr, from, mid);
          SumTask right = new SumTask(arr, mid, to);

          left.fork();               // submit left asynchronously
          long rightResult = right.compute(); // compute right in current thread
          long leftResult  = left.join();     // wait for left
          return leftResult + rightResult;
      }
  }

  ForkJoinPool pool = new ForkJoinPool();
  long result = pool.invoke(new SumTask(arr, 0, arr.length));

─────────────────────────────────────
RecursiveAction PATTERN (no result):
─────────────────────────────────────
  class SortAction extends RecursiveAction {
      @Override
      protected void compute() {
          if (to - from <= THRESHOLD) {
              Arrays.sort(arr, from, to);
              return;
          }
          int mid = (from + to) / 2;
          SortAction left  = new SortAction(arr, from, mid);
          SortAction right = new SortAction(arr, mid, to);
          invokeAll(left, right);   // convenience: fork both, join both
          merge(arr, from, mid, to);
      }
  }

─────────────────────────────────────
WORK STEALING:
─────────────────────────────────────
  Each worker thread has its own deque of tasks.
  When a thread runs out of work, it "steals" tasks
  from the END of another thread's deque.
  This keeps all threads busy automatically.

─────────────────────────────────────
PARALLEL STREAMS use Fork/Join:
─────────────────────────────────────
  // This uses ForkJoinPool.commonPool() internally:
  long sum = IntStream.range(0, 1_000_000)
      .parallel()
      .asLongStream()
      .sum();

  // Custom pool for parallel streams:
  ForkJoinPool custom = new ForkJoinPool(4);
  long result = custom.submit(() ->
      IntStream.range(0, N).parallel().sum()
  ).get();

─────────────────────────────────────
WHEN TO USE FORK/JOIN:
─────────────────────────────────────
  ✅ CPU-bound divide-and-conquer problems
  ✅ Array/collection processing (sort, search, transform)
  ✅ Recursive algorithms on large data sets
  ✅ Parallel streams (automatic)

  ❌ I/O-bound tasks (use virtual threads)
  ❌ Tasks that can't be divided
  ❌ Tasks with dependencies between subtasks

─────────────────────────────────────
THRESHOLD — the split decision:
─────────────────────────────────────
  Too small: overhead of task creation > benefit
  Too large: not enough parallelism
  Rule of thumb: ~500 to 10,000 elements per leaf task

💻 CODE:
import java.util.*;
import java.util.concurrent.*;
import java.util.concurrent.atomic.*;
import java.util.stream.*;
import java.time.*;
import java.time.temporal.ChronoUnit;

// ─── RECURSIVE TASKS ──────────────────────────────────
class ParallelSum extends RecursiveTask<Long> {
    private final long[] arr;
    private final int from, to;
    private static final int THRESHOLD = 10_000;

    ParallelSum(long[] arr, int from, int to) {
        this.arr = arr; this.from = from; this.to = to;
    }

    @Override
    protected Long compute() {
        if (to - from <= THRESHOLD) {
            long sum = 0;
            for (int i = from; i < to; i++) sum += arr[i];
            return sum;
        }
        int mid = (from + to) / 2;
        ParallelSum left  = new ParallelSum(arr, from, mid);
        ParallelSum right = new ParallelSum(arr, mid, to);
        left.fork();
        return right.compute() + left.join();
    }
}

class ParallelMax extends RecursiveTask<Long> {
    private final long[] arr;
    private final int from, to;
    private static final int THRESHOLD = 5_000;

    ParallelMax(long[] arr, int from, int to) {
        this.arr = arr; this.from = from; this.to = to;
    }

    @Override
    protected Long compute() {
        if (to - from <= THRESHOLD) {
            long max = arr[from];
            for (int i = from + 1; i < to; i++) if (arr[i] > max) max = arr[i];
            return max;
        }
        int mid = (from + to) / 2;
        ParallelMax left  = new ParallelMax(arr, from, mid);
        ParallelMax right = new ParallelMax(arr, mid, to);
        invokeAll(left, right);
        return Math.max(left.join(), right.join());
    }
}

// Count strings matching a predicate in parallel
class CountMatchingAction extends RecursiveTask<Integer> {
    private final String[] arr;
    private final int from, to;
    private final java.util.function.Predicate<String> pred;
    private static final int THRESHOLD = 100;

    CountMatchingAction(String[] arr, int from, int to,
                        java.util.function.Predicate<String> pred) {
        this.arr = arr; this.from = from; this.to = to; this.pred = pred;
    }

    @Override
    protected Integer compute() {
        if (to - from <= THRESHOLD) {
            int count = 0;
            for (int i = from; i < to; i++) if (pred.test(arr[i])) count++;
            return count;
        }
        int mid = (from + to) / 2;
        CountMatchingAction left  = new CountMatchingAction(arr, from, mid, pred);
        CountMatchingAction right = new CountMatchingAction(arr, mid, to, pred);
        left.fork();
        return right.compute() + left.join();
    }
}

public class ForkJoinDemo {
    public static void main(String[] args) throws Exception {
        ForkJoinPool pool = new ForkJoinPool();

        // ─── PARALLEL SUM ─────────────────────────────────
        System.out.println("=== Parallel Sum ===");
        int N = 10_000_000;
        long[] numbers = new long[N];
        Random rand = new Random(42);
        for (int i = 0; i < N; i++) numbers[i] = rand.nextInt(100) + 1;

        // Sequential
        Instant t1 = Instant.now();
        long seqSum = 0;
        for (long n : numbers) seqSum += n;
        long seqMs = ChronoUnit.MILLIS.between(t1, Instant.now());

        // Fork/Join
        Instant t2 = Instant.now();
        long forkSum = pool.invoke(new ParallelSum(numbers, 0, N));
        long forkMs = ChronoUnit.MILLIS.between(t2, Instant.now());

        // Parallel stream
        Instant t3 = Instant.now();
        long streamSum = Arrays.stream(numbers).parallel().sum();
        long streamMs = ChronoUnit.MILLIS.between(t3, Instant.now());

        System.out.printf("  N=%,d numbers%n", N);
        System.out.printf("  Sequential:     sum=%,d  (%dms)%n", seqSum, seqMs);
        System.out.printf("  Fork/Join:      sum=%,d  (%dms)%n", forkSum, forkMs);
        System.out.printf("  Parallel stream:sum=%,d  (%dms)%n", streamSum, streamMs);
        System.out.println("  CPU cores: " + Runtime.getRuntime().availableProcessors());

        // ─── PARALLEL MAX ─────────────────────────────────
        System.out.println("\n=== Parallel Max ===");
        long max = pool.invoke(new ParallelMax(numbers, 0, N));
        System.out.println("  Max value: " + max);

        // ─── COUNT WITH PREDICATE ─────────────────────────
        System.out.println("\n=== Parallel Count ===");
        String[] words = IntStream.range(0, 100_000)
            .mapToObj(i -> "word" + (i % 1000))
            .toArray(String[]::new);

        int countResult = pool.invoke(new CountMatchingAction(
            words, 0, words.length, s -> s.length() > 5));
        System.out.println("  Words with length > 5: " + countResult);

        // ─── FIBONACCI (recursive, instructive) ───────────
        System.out.println("\n=== Parallel Fibonacci (Fork/Join) ===");
        class FibTask extends RecursiveTask<Long> {
            private final int n;
            FibTask(int n) { this.n = n; }

            @Override protected Long compute() {
                if (n <= 1) return (long) n;
                if (n <= 20) {  // threshold: small → sequential
                    long a = 0, b = 1;
                    for (int i = 2; i <= n; i++) { long c = a+b; a = b; b = c; }
                    return b;
                }
                FibTask f1 = new FibTask(n - 1);
                FibTask f2 = new FibTask(n - 2);
                f1.fork();
                return f2.compute() + f1.join();
            }
        }

        for (int i : new int[]{10, 20, 30, 40}) {
            long result = pool.invoke(new FibTask(i));
            System.out.printf("  fib(%2d) = %,d%n", i, result);
        }

        // ─── POOL STATISTICS ──────────────────────────────
        System.out.println("\n=== ForkJoinPool Info ===");
        System.out.println("  Parallelism:  " + pool.getParallelism());
        System.out.println("  Pool size:    " + pool.getPoolSize());
        System.out.println("  Active:       " + pool.getActiveThreadCount());
        System.out.println("  Steal count:  " + pool.getStealCount());
        System.out.println("  Common pool:  " + ForkJoinPool.commonPool().getParallelism());

        // ─── PARALLEL STREAMS USE ForkJoin ────────────────
        System.out.println("\n=== Parallel Streams via Custom Pool ===");
        ForkJoinPool customPool = new ForkJoinPool(2);  // only 2 threads
        long customResult = customPool.submit(() ->
            LongStream.range(0, 1_000_000).parallel().sum()
        ).get();
        System.out.println("  Sum 0..999999 with custom pool(2): " + customResult);
        customPool.shutdown();

        pool.shutdown();
    }
}

📝 KEY POINTS:
✅ Fork/Join divides work recursively and recombines results (divide and conquer)
✅ RecursiveTask<T> returns a result; RecursiveAction has no result (void)
✅ fork() submits a subtask asynchronously; join() waits for its result
✅ invokeAll() forks all tasks and waits — convenient for symmetric splits
✅ Work stealing keeps all cores busy — idle threads steal work from busy ones
✅ Threshold determines when to stop splitting — test for your specific hardware
✅ ForkJoinPool.commonPool() is shared and used by parallel streams automatically
✅ Custom ForkJoinPool controls parallelism for parallel stream operations
✅ Pattern: fork left, compute right in current thread, join left — maximally efficient
❌ Don't use Fork/Join for I/O-bound tasks — use virtual threads instead
❌ Too-small threshold causes too much overhead from task creation
❌ Don't block inside Fork/Join tasks — it can starve the thread pool
❌ ForkJoinPool is not a drop-in replacement for ExecutorService for general use
""",
  quiz: [
    Quiz(question: 'What is the recommended pattern for forking two subtasks in Fork/Join?', options: [
      QuizOption(text: 'Fork the left subtask, compute the right in the current thread, then join the left — maximizes CPU utilization', correct: true),
      QuizOption(text: 'Fork both subtasks and join both immediately after — symmetric and simple', correct: false),
      QuizOption(text: 'Fork both subtasks and wait in a loop until both are done', correct: false),
      QuizOption(text: 'Compute both sequentially in the current thread — forking adds overhead', correct: false),
    ]),
    Quiz(question: 'What is work stealing in Fork/Join?', options: [
      QuizOption(text: 'Idle worker threads steal tasks from the tail of busy workers\' queues — keeping all cores utilized', correct: true),
      QuizOption(text: 'The main thread steals partially computed results from worker threads', correct: false),
      QuizOption(text: 'Worker threads steal CPU time from I/O-blocked threads', correct: false),
      QuizOption(text: 'Tasks steal thread priority from lower-priority work', correct: false),
    ]),
    Quiz(question: 'What does ForkJoinPool.commonPool() provide?', options: [
      QuizOption(text: 'A shared pool used by parallel streams and most Fork/Join tasks — one pool for the JVM', correct: true),
      QuizOption(text: 'A pool shared across all JVMs running on the same machine', correct: false),
      QuizOption(text: 'The pool used exclusively for garbage collection parallel phases', correct: false),
      QuizOption(text: 'A debugging pool that logs all task submissions and completions', correct: false),
    ]),
  ],
);
