import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson77 = Lesson(
  language: 'Java',
  title: 'Java Interview Preparation',
  content: """
🎯 METAPHOR:
A Java interview is like a driver's license test.
The examiner doesn't care if you've driven for years —
they want to confirm you know the rules, can handle
edge cases, and won't endanger others. They'll ask
about parallel parking (threading), reversing
(recursion), emergency stops (exception handling),
and the highway code (Java specification). Knowing
HOW to drive isn't enough — you need to articulate
WHY: why this gear, why this distance, why this lane.
Preparation means drilling both the mechanics AND
the reasoning behind them.

📖 EXPLANATION:
The most commonly asked Java interview questions,
grouped by category, with concise answers.

─────────────────────────────────────
CORE JAVA FUNDAMENTALS:
─────────────────────────────────────
  Q: What is the difference between == and .equals()?
  A: == compares references (same object in memory).
     .equals() compares values (must be overridden).
     String, Integer: always use .equals().

  Q: What is the String pool?
  A: JVM caches String literals. "hello" == "hello" is true
     (same pooled object). new String("hello") bypasses pool.
     Always use .equals() for String comparison.

  Q: Difference between StringBuilder and StringBuffer?
  A: StringBuffer is synchronized (thread-safe, slower).
     StringBuilder is not synchronized (faster).
     Use StringBuilder; StringBuffer is legacy.

  Q: What is autoboxing?
  A: Auto-conversion between primitives and wrapper types.
     int → Integer (boxing), Integer → int (unboxing).
     Integer cache: -128 to 127 are cached — == works there.
     Outside that range: use .equals().

  Q: What does final mean on class/method/field?
  A: final class: cannot be subclassed (String, Integer)
     final method: cannot be overridden
     final field: cannot be reassigned after construction

─────────────────────────────────────
OOP AND DESIGN:
─────────────────────────────────────
  Q: Difference between abstract class and interface?
  A: Abstract class: can have state, constructors, concrete
     methods. One parent only.
     Interface: no state (pre-Java 8), multiple implement.
     Java 8+: default and static methods in interfaces.
     Use interface for pure API; abstract for partial impl.

  Q: What is polymorphism?
  A: One interface, multiple implementations. Dynamic
     dispatch: method called depends on actual runtime type,
     not the declared type. Animal.sound() → Dog barks.

  Q: Explain the SOLID principles briefly.
  A: S=one reason to change, O=extend not modify,
     L=subclasses substitutable, I=small interfaces,
     D=depend on abstractions.

  Q: What is the difference between composition and
     inheritance?
  A: Inheritance = IS-A (tight coupling, fragile).
     Composition = HAS-A (flexible, prefer this).
     "Favor composition over inheritance."

─────────────────────────────────────
COLLECTIONS:
─────────────────────────────────────
  Q: ArrayList vs LinkedList?
  A: ArrayList: O(1) get, O(n) insert/delete (shifts).
     LinkedList: O(n) get, O(1) insert/delete at position.
     Prefer ArrayList unless many mid-list insertions.

  Q: HashMap vs TreeMap vs LinkedHashMap?
  A: HashMap: O(1) get/put, unordered.
     TreeMap: O(log n), sorted by key.
     LinkedHashMap: O(1), maintains insertion order.

  Q: How does HashMap work internally?
  A: Array of buckets + hashCode() → bucket index.
     Collision: chaining (linked list, trees if >8).
     Load factor 0.75 → resize at 75% capacity.
     hashCode() and equals() must be consistent.

  Q: Fail-fast vs fail-safe iterators?
  A: Fail-fast (ArrayList, HashMap): throw
     ConcurrentModificationException if modified during iter.
     Fail-safe (CopyOnWriteArrayList, ConcurrentHashMap):
     iterate a snapshot, no exception.

─────────────────────────────────────
CONCURRENCY:
─────────────────────────────────────
  Q: Difference between synchronized and volatile?
  A: synchronized: mutual exclusion + visibility.
     volatile: visibility only, no atomicity.
     i++ is not atomic even on volatile int.

  Q: What is a deadlock?
  A: Thread A holds lock 1, waits for lock 2.
     Thread B holds lock 2, waits for lock 1.
     Both wait forever. Prevent: always acquire locks
     in the same order.

  Q: What is a race condition?
  A: Two threads read-modify-write shared state without
     synchronization. Result depends on timing.
     Fix: AtomicInteger, synchronized, Lock.

  Q: ExecutorService vs creating threads manually?
  A: ExecutorService manages thread lifecycle, pool reuse,
     task queuing. Manual threads: no reuse, no control.
     Always prefer ExecutorService.

─────────────────────────────────────
MODERN JAVA (8-21):
─────────────────────────────────────
  Q: What are lambda expressions?
  A: Anonymous functions that implement functional interfaces
     (single abstract method). Enable functional programming.

  Q: What is a Stream?
  A: Lazy sequence of data from a source. Pipeline of
     filter/map/reduce operations. Triggered by terminal op.
     Not a data structure — single-use.

  Q: What is Optional?
  A: Container for a value that might be absent.
     Replaces null returns. Forces callers to handle absence.

  Q: What are virtual threads (Java 21)?
  A: Lightweight JVM-managed threads. Millions possible.
     Unmount from carrier thread during blocking I/O.
     Write blocking code that scales like async code.

─────────────────────────────────────
EXCEPTIONS:
─────────────────────────────────────
  Q: Checked vs unchecked exceptions?
  A: Checked: must be caught or declared (IOException).
     Unchecked: RuntimeException, no requirement.
     New APIs often throw unchecked for flexibility.

  Q: Can finally block be skipped?
  A: Yes: System.exit(), JVM crash, infinite loop,
     OutOfMemoryError. Otherwise finally ALWAYS runs.

─────────────────────────────────────
MEMORY AND GC:
─────────────────────────────────────
  Q: What is the difference between heap and stack?
  A: Stack: method frames, local vars, LIFO.
     Heap: objects (GC managed). All new X() goes to heap.

  Q: What causes a memory leak in Java?
  A: Reachable objects that should have been released:
     static collections, event listeners not removed,
     caches without eviction, unclosed resources.

  Q: What is stop-the-world?
  A: GC pauses all threads to safely collect garbage.
     G1GC: typically <200ms. ZGC: <1ms concurrent.

💻 CODE:
import java.util.*;
import java.util.concurrent.*;
import java.util.concurrent.atomic.*;
import java.util.stream.*;
import java.util.function.*;

public class InterviewPrep {
    public static void main(String[] args) throws Exception {

        System.out.println("=== Java Interview Demo Code ===\n");

        // 1. == vs equals
        System.out.println("1. == vs .equals()");
        String s1 = "hello", s2 = "hello", s3 = new String("hello");
        System.out.println("   s1 == s2:        " + (s1 == s2));   // true (pool)
        System.out.println("   s1 == s3:        " + (s1 == s3));   // false (new)
        System.out.println("   s1.equals(s3):   " + s1.equals(s3));// true

        // 2. Integer cache trap
        System.out.println("\n2. Integer Cache");
        Integer a = 127, b = 127, c = 128, d = 128;
        System.out.println("   127 == 127:  " + (a == b)); // true
        System.out.println("   128 == 128:  " + (c == d)); // false!
        System.out.println("   128 eq 128:  " + c.equals(d)); // true

        // 3. HashMap internals
        System.out.println("\n3. HashMap — must override hashCode AND equals");
        class BadKey {
            int id;
            BadKey(int id) { this.id = id; }
            // No hashCode/equals — default Object ones
        }
        Map<BadKey, String> badMap = new HashMap<>();
        BadKey key = new BadKey(1);
        badMap.put(key, "value");
        System.out.println("   Same ref: " + badMap.get(key));
        System.out.println("   New obj:  " + badMap.get(new BadKey(1))); // null!

        // 4. Fail-fast iterator
        System.out.println("\n4. Fail-fast vs Fail-safe");
        List<Integer> list = new ArrayList<>(List.of(1, 2, 3, 4, 5));
        try {
            for (Integer i : list) {
                if (i == 3) list.remove(i); // throws!
            }
        } catch (ConcurrentModificationException e) {
            System.out.println("   Fail-fast: " + e.getClass().getSimpleName());
        }
        // Fix: use removeIf
        list.removeIf(i -> i == 3);
        System.out.println("   After removeIf: " + list);

        // 5. Race condition
        System.out.println("\n5. Race Condition and Fix");
        int threads = 10, iterations = 1000;
        int[] unsafe = {0};
        AtomicInteger safe = new AtomicInteger(0);
        ExecutorService pool = Executors.newFixedThreadPool(threads);
        CountDownLatch latch = new CountDownLatch(threads);

        for (int t = 0; t < threads; t++) {
            pool.submit(() -> {
                for (int i = 0; i < iterations; i++) {
                    unsafe[0]++;                // race condition
                    safe.incrementAndGet();      // atomic
                }
                latch.countDown();
            });
        }
        latch.await(); pool.shutdown();
        System.out.printf("   Expected %,d: unsafe=%,d safe=%,d%n",
            threads * iterations, unsafe[0], safe.get());

        // 6. Stream pipeline
        System.out.println("\n6. Stream Pipeline");
        List<String> words = List.of("apple", "banana", "cherry", "apricot", "blueberry");
        Map<Character, Long> startCount = words.stream()
            .collect(Collectors.groupingBy(s -> s.charAt(0), Collectors.counting()));
        System.out.println("   By first char: " + new TreeMap<>(startCount));

        String longest = words.stream()
            .max(Comparator.comparingInt(String::length)).orElse("none");
        System.out.println("   Longest: " + longest);

        // 7. Optional
        System.out.println("\n7. Optional usage");
        Optional<String> opt = Optional.of("hello");
        System.out.println("   map toUpper: " + opt.map(String::toUpperCase));
        System.out.println("   empty orElse: " + Optional.<String>empty().orElse("default"));

        // 8. Deadlock prevention
        System.out.println("\n8. Deadlock Prevention");
        Object lockA = new Object();
        Object lockB = new Object();

        // Always acquire in same order to prevent deadlock:
        Thread t1 = new Thread(() -> {
            synchronized (lockA) {
                try { Thread.sleep(10); } catch (InterruptedException e) {}
                synchronized (lockB) {
                    System.out.println("   Thread 1 got both locks");
                }
            }
        });
        Thread t2 = new Thread(() -> {
            synchronized (lockA) {  // same order as T1!
                synchronized (lockB) {
                    System.out.println("   Thread 2 got both locks");
                }
            }
        });
        t1.start(); t2.start();
        t1.join(); t2.join();

        // ─── COMMON INTERVIEW PATTERNS ────────────────────
        System.out.println("\n=== Common Coding Patterns ===");

        // Reverse a linked list
        System.out.println("Reverse linked list:");
        int[] nums = {1, 2, 3, 4, 5};
        int left = 0, right = nums.length - 1;
        while (left < right) {
            int tmp = nums[left]; nums[left++] = nums[right]; nums[right--] = tmp;
        }
        System.out.println("   " + Arrays.toString(nums));

        // Two sum
        System.out.println("Two sum [2,7,11,15], target=9:");
        int[] twoSum = {2, 7, 11, 15};
        int target = 9;
        Map<Integer, Integer> seen = new HashMap<>();
        for (int i = 0; i < twoSum.length; i++) {
            int complement = target - twoSum[i];
            if (seen.containsKey(complement)) {
                System.out.println("   Indices [" + seen.get(complement) + ", " + i + "]");
                break;
            }
            seen.put(twoSum[i], i);
        }

        // FizzBuzz
        System.out.println("FizzBuzz 1-20:");
        System.out.println("   " + IntStream.rangeClosed(1, 20)
            .mapToObj(n -> n % 15 == 0 ? "FizzBuzz" : n % 3 == 0 ? "Fizz" : n % 5 == 0 ? "Buzz" : String.valueOf(n))
            .collect(Collectors.joining(", ")));
    }
}

📝 KEY POINTS:
✅ Always use .equals() for String/Integer comparison — never == (except booleans)
✅ HashMap requires consistent hashCode() AND equals() — override both together
✅ ArrayList O(1) get vs LinkedList O(n) get — know when to use each
✅ Checked exceptions must be handled; unchecked extend RuntimeException
✅ volatile = visibility only; synchronized = visibility + mutual exclusion
✅ AtomicInteger.incrementAndGet() is truly atomic — volatile int++ is not
✅ Deadlock prevention: always acquire multiple locks in the same order
✅ Stream is lazy and single-use; Optional forces callers to handle absence
✅ StringBuilder for concatenation in loops; StringBuffer only for thread-safety (rare)
❌ Don't say "I'd never use X" — explain tradeoffs thoughtfully
❌ Don't forget to handle the "what if null" case in interview solutions
❌ Generic answers without specifics won't impress — give concrete examples
❌ Never claim synchronized solves all concurrency — mention performance tradeoffs
""",
  quiz: [
    Quiz(question: 'In a Java interview, what is the correct answer to "How does HashMap work internally?"', options: [
      QuizOption(text: 'Array of buckets, hashCode() selects bucket, equals() resolves collisions; chaining converts to tree at >8 entries; resizes at 75% load', correct: true),
      QuizOption(text: 'A balanced binary tree that sorts keys by hashCode for O(log n) access', correct: false),
      QuizOption(text: 'A linked list of key-value pairs scanned linearly on each get()', correct: false),
      QuizOption(text: 'A concurrent hash map that uses lock striping for thread-safe access', correct: false),
    ]),
    Quiz(question: 'What is the difference between a checked and unchecked exception in Java?', options: [
      QuizOption(text: 'Checked exceptions must be caught or declared with throws; unchecked (RuntimeException) have no such requirement', correct: true),
      QuizOption(text: 'Checked exceptions are faster at runtime; unchecked exceptions carry more information', correct: false),
      QuizOption(text: 'Checked exceptions occur at compile time; unchecked occur at runtime', correct: false),
      QuizOption(text: 'Unchecked exceptions cannot be caught; checked exceptions can always be handled', correct: false),
    ]),
    Quiz(question: 'Why must hashCode() and equals() be overridden together in Java?', options: [
      QuizOption(text: 'HashMap uses hashCode() to find the bucket and equals() to confirm the key — inconsistency causes objects to be "lost" in the map', correct: true),
      QuizOption(text: 'Java requires both methods to be implemented as part of the Comparable interface', correct: false),
      QuizOption(text: 'equals() is only called when hashCode() returns 0 — so they must match', correct: false),
      QuizOption(text: 'They are defined in separate interfaces and must be synchronized for thread safety', correct: false),
    ]),
  ],
);
