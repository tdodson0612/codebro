import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson66 = Lesson(
  language: 'Java',
  title: 'Functional Programming Patterns in Java',
  content: """
🎯 METAPHOR:
Functional programming treats functions like data —
first-class citizens you can pass around, store, combine,
and compose. Instead of telling the computer HOW to do
something step by step (imperative), you describe WHAT
you want (declarative). A recipe vs. a list of cooking
steps: "give me the sorted, unique, long words from
this text" rather than "iterate through words, check
length, add to set, sort the set." Functional style
in Java uses lambdas, method references, and streams
to write code that reads like the problem description.

📖 EXPLANATION:
Java 8+ supports functional programming patterns through
lambdas, method references, streams, and the
java.util.function package.

─────────────────────────────────────
FUNCTION COMPOSITION:
─────────────────────────────────────
  Function<String, String> trim    = String::strip;
  Function<String, String> upper   = String::toUpperCase;
  Function<String, Integer> length = String::length;

  // andThen: first → second
  Function<String, String> trimThenUpper = trim.andThen(upper);
  trimThenUpper.apply("  hello  ")  → "HELLO"

  // compose: second → first (reversed)
  Function<String, String> upperThenTrim = trim.compose(upper);
  upperThenTrim.apply("  hello  ")  → "  HELLO  ".strip() = "HELLO"

  // Build a pipeline:
  Function<String, Integer> pipeline = trim.andThen(upper).andThen(length);
  pipeline.apply("  hi  ")  → 2

─────────────────────────────────────
CURRYING AND PARTIAL APPLICATION:
─────────────────────────────────────
  // Currying: f(a, b) → x → f(x, b)
  Function<Integer, Function<Integer, Integer>> curryAdd =
      a -> b -> a + b;

  Function<Integer, Integer> add5 = curryAdd.apply(5);
  add5.apply(3)   → 8
  add5.apply(10)  → 15

  // Partial application with BiFunction:
  BiFunction<String, Integer, String> repeat = (s, n) -> s.repeat(n);
  Function<Integer, String> repeatHello = n -> repeat.apply("hello", n);

─────────────────────────────────────
MEMOIZATION — cache function results:
─────────────────────────────────────
  static <T, R> Function<T, R> memoize(Function<T, R> fn) {
      Map<T, R> cache = new ConcurrentHashMap<>();
      return key -> cache.computeIfAbsent(key, fn);
  }

  Function<Integer, Long> memoFib = memoize(n ->
      n <= 1 ? n : slowFib(n - 1) + slowFib(n - 2));

─────────────────────────────────────
PREDICATE ALGEBRA:
─────────────────────────────────────
  Predicate<String> longWord  = s -> s.length() > 5;
  Predicate<String> startsA   = s -> s.startsWith("A");
  Predicate<String> notBlank  = s -> !s.isBlank();

  Predicate<String> longAndA  = longWord.and(startsA);
  Predicate<String> longOrA   = longWord.or(startsA);
  Predicate<String> notLong   = longWord.negate();

  // All-of and any-of composition:
  Predicate<String> allValid = Stream.of(notBlank, longWord, startsA)
      .reduce(x -> true, Predicate::and);

─────────────────────────────────────
MONAD-LIKE PATTERNS WITH OPTIONAL:
─────────────────────────────────────
  // Chain nullable operations without null checks:
  Optional<String> result = Optional.ofNullable(user)
      .map(User::getAddress)
      .map(Address::getCity)
      .map(String::toUpperCase)
      .filter(s -> !s.isBlank());

  // flatMap for Optional-returning methods:
  Optional<String> email = Optional.of(userId)
      .flatMap(repo::findUser)      // returns Optional<User>
      .flatMap(User::getEmail)      // returns Optional<String>
      .filter(e -> e.contains("@"));

─────────────────────────────────────
PURE FUNCTIONS:
─────────────────────────────────────
  A pure function:
  → Same inputs always produce same output
  → No side effects (no mutation, I/O, or global state)

  // Pure:
  static int add(int a, int b) { return a + b; }

  // Impure (mutates state):
  static int total = 0;
  static int addAndAccumulate(int a) { total += a; return total; }

  Prefer pure functions — easier to test, parallelize, memoize.

─────────────────────────────────────
LAZY EVALUATION WITH SUPPLIER:
─────────────────────────────────────
  // Expensive computation — don't run until needed:
  Supplier<BigInteger> lazyFib = () -> computeHugeFib(1000);

  // Only evaluated when you call .get():
  if (someCondition) {
      BigInteger result = lazyFib.get();
  }

  // Lazy initialization pattern:
  private Supplier<Config> config = () -> {
      Config c = loadConfig();      // expensive
      this.config = () -> c;        // memoize after first call
      return c;
  };

─────────────────────────────────────
PIPELINE PATTERN:
─────────────────────────────────────
  @SafeVarargs
  static <T> Function<T, T> pipeline(Function<T, T>... stages) {
      return Arrays.stream(stages)
          .reduce(Function.identity(), Function::andThen);
  }

  Function<String, String> normalize = pipeline(
      String::strip,
      String::toLowerCase,
      s -> s.replaceAll("\\\\s+", "_")
  );
  normalize.apply("  Hello World  ")  → "hello_world"

💻 CODE:
import java.util.*;
import java.util.concurrent.*;
import java.util.function.*;
import java.util.stream.*;

public class FunctionalPatterns {

    // Memoization
    static <T, R> Function<T, R> memoize(Function<T, R> fn) {
        Map<T, R> cache = new ConcurrentHashMap<>();
        return key -> cache.computeIfAbsent(key, fn);
    }

    // Pipeline builder
    @SafeVarargs
    static <T> Function<T, T> pipeline(Function<T, T>... stages) {
        return Arrays.stream(stages).reduce(Function.identity(), Function::andThen);
    }

    // Curry helper
    static <A, B, R> Function<A, Function<B, R>> curry(BiFunction<A, B, R> f) {
        return a -> b -> f.apply(a, b);
    }

    public static void main(String[] args) {

        // ─── FUNCTION COMPOSITION ─────────────────────────
        System.out.println("=== Function Composition ===");
        Function<String, String> trim  = String::strip;
        Function<String, String> upper = String::toUpperCase;
        Function<String, Integer> len  = String::length;

        Function<String, Integer> pipeline2 = trim.andThen(upper).andThen(len);
        List<String> words = List.of("  hello  ", " WORLD ", "  Java  ", "   ");
        words.forEach(w ->
            System.out.printf("  '%-12s' → %d%n", w, pipeline2.apply(w)));

        // ─── PIPELINE BUILDER ─────────────────────────────
        System.out.println("\n=== Pipeline Builder ===");
        Function<String, String> normalize = pipeline(
            String::strip,
            String::toLowerCase,
            s -> s.replaceAll("\\s+", "_"),
            s -> s.replaceAll("[^a-z0-9_]", "")
        );

        List<String> inputs = List.of("  Hello World  ", "  Java 21!  ", "  SLF4J logging  ");
        inputs.forEach(s -> System.out.printf("  '%-20s' → '%s'%n", s, normalize.apply(s)));

        // ─── CURRYING ─────────────────────────────────────
        System.out.println("\n=== Currying ===");
        Function<Integer, Function<Integer, Integer>> add = curry((a, b) -> a + b);
        Function<Integer, Function<Integer, Integer>> mul = curry((a, b) -> a * b);

        Function<Integer, Integer> add10 = add.apply(10);
        Function<Integer, Integer> times3 = mul.apply(3);
        Function<Integer, Integer> add10ThenTimes3 = add10.andThen(times3);

        List<Integer> nums = List.of(0, 1, 2, 3, 4, 5);
        System.out.println("  add10:  " + nums.stream().map(add10).toList());
        System.out.println("  times3: " + nums.stream().map(times3).toList());
        System.out.println("  +10*3:  " + nums.stream().map(add10ThenTimes3).toList());

        // ─── MEMOIZATION ──────────────────────────────────
        System.out.println("\n=== Memoization ===");
        // Naive recursive Fibonacci (exponential without memoization)
        Function<Integer, Long>[] fib = new Function[1];
        Map<Integer, Long> fibCache = new ConcurrentHashMap<>();
        fib[0] = n -> fibCache.computeIfAbsent(n, k ->
            k <= 1 ? k : fib[0].apply(k - 1) + fib[0].apply(k - 2));

        for (int i : new int[]{0, 1, 5, 10, 20, 30, 40}) {
            System.out.printf("  fib(%2d) = %,d%n", i, fib[0].apply(i));
        }

        // Memoized pure function
        Function<String, Integer> wordLength = memoize(String::length);
        List<String> repeated = List.of("hello", "hello", "world", "hello", "world");
        System.out.println("\n  Memoized word lengths:");
        repeated.forEach(w -> System.out.print(wordLength.apply(w) + " "));
        System.out.println();

        // ─── PREDICATE ALGEBRA ────────────────────────────
        System.out.println("\n=== Predicate Algebra ===");
        Predicate<String> notBlank  = Predicate.not(String::isBlank);
        Predicate<String> longWord  = s -> s.length() > 4;
        Predicate<String> startsUpper = s -> !s.isEmpty() && Character.isUpperCase(s.charAt(0));

        Predicate<String> valid = notBlank.and(longWord).and(startsUpper);

        List<String> candidates = List.of("Hello", "hi", "World", "", "Java", "ok", "Kotlin", "  ");
        System.out.println("  Valid (not blank, len>4, starts upper):");
        candidates.forEach(s ->
            System.out.printf("    %-10s → %s%n", "'" + s + "'", valid.test(s) ? "✅" : "❌"));

        // Compose predicates from a list
        List<Predicate<Integer>> checks = List.of(
            n -> n > 0,
            n -> n % 2 == 0,
            n -> n < 100
        );
        Predicate<Integer> allChecks = checks.stream().reduce(x -> true, Predicate::and);
        System.out.println("  Numbers passing all checks (>0, even, <100):");
        System.out.println("  " + IntStream.range(-5, 110).filter(allChecks::test)
            .limit(10).boxed().toList());

        // ─── OPTIONAL MONAD ───────────────────────────────
        System.out.println("\n=== Optional Monad Pattern ===");
        record Person2(String name, String email) {}
        Map<String, Person2> db = Map.of(
            "1", new Person2("Alice", "alice@example.com"),
            "2", new Person2("Bob", null)
        );

        for (String id : List.of("1", "2", "3")) {
            String domain = Optional.ofNullable(db.get(id))
                .map(Person2::email)
                .filter(e -> e.contains("@"))
                .map(e -> e.substring(e.indexOf('@') + 1))
                .orElse("(no email)");
            System.out.printf("  User %s domain: %s%n", id, domain);
        }

        // ─── LAZY EVALUATION ──────────────────────────────
        System.out.println("\n=== Lazy Evaluation ===");
        // Supplier defers computation
        Supplier<List<Integer>> lazyExpensive = () -> {
            System.out.println("  (Computing expensive list...)");
            return IntStream.range(0, 1000).filter(n -> isPrime(n)).boxed().toList();
        };

        System.out.println("  Supplier created — not computed yet");
        boolean condition = false;
        if (condition) {
            List<Integer> primes = lazyExpensive.get();  // only evaluated if needed
            System.out.println("  Primes count: " + primes.size());
        } else {
            System.out.println("  Condition false — expensive computation skipped!");
        }
    }

    static boolean isPrime(int n) {
        if (n < 2) return false;
        for (int i = 2; i <= Math.sqrt(n); i++) if (n % i == 0) return false;
        return true;
    }
}

📝 KEY POINTS:
✅ Function.andThen(f): apply this, then f. Function.compose(f): apply f, then this
✅ Currying converts (a, b) -> result into a -> b -> result — enables partial application
✅ Memoization caches function results — use ConcurrentHashMap for thread safety
✅ Predicate.and(), .or(), .negate() compose boolean conditions without if/else chains
✅ Predicate.not(method::ref) negates a method reference predicate (Java 11)
✅ Optional.flatMap() handles functions that return Optional (monadic chaining)
✅ Supplier<T> defers expensive computation until .get() is called (lazy evaluation)
✅ Pure functions have no side effects — easier to test, memoize, and parallelize
❌ Don't overuse functional style for simple loops — it can reduce readability
❌ Memoize only pure functions — memoizing impure functions gives wrong results
❌ Predicate.and() does NOT short-circuit by default — use conditional logic if needed
❌ Function composition creates new objects — avoid in tight inner loops
""",
  quiz: [
    Quiz(question: 'What is the difference between Function.andThen(f) and Function.compose(f)?', options: [
      QuizOption(text: 'andThen applies this then f; compose applies f first then this — they chain in opposite orders', correct: true),
      QuizOption(text: 'andThen is for Consumer; compose is for Function — different functional interface types', correct: false),
      QuizOption(text: 'compose is deprecated; andThen is the modern replacement', correct: false),
      QuizOption(text: 'They are identical — compose is just an alias for andThen', correct: false),
    ]),
    Quiz(question: 'What does currying a function mean?', options: [
      QuizOption(text: 'Converting a function that takes multiple arguments into a chain of functions each taking one argument', correct: true),
      QuizOption(text: 'Caching a function\'s return values for repeated calls with the same arguments', correct: false),
      QuizOption(text: 'Composing two functions to create a new combined function', correct: false),
      QuizOption(text: 'Converting an impure function into a pure function by removing side effects', correct: false),
    ]),
    Quiz(question: 'What is memoization and when is it safe to apply?', options: [
      QuizOption(text: 'Caching function results for repeated inputs — only safe for pure functions (same input always gives same output)', correct: true),
      QuizOption(text: 'Storing intermediate stream results to avoid re-computation in parallel streams', correct: false),
      QuizOption(text: 'Making a function lazy by wrapping it in a Supplier', correct: false),
      QuizOption(text: 'Converting a recursive function to an iterative one for better stack usage', correct: false),
    ]),
  ],
);
