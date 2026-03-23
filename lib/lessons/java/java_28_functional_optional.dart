import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson28 = Lesson(
  language: 'Java',
  title: 'Functional Interfaces and Optional',
  content: """
🎯 METAPHOR:
Optional is like a gift box that might or might not contain
a gift. In the old days (null), you'd hand someone an empty
box and they'd reach in expecting something, find nothing,
and drop everything (NullPointerException). Optional says
"here's a LABELED box — I'm telling you upfront whether
there's a gift inside." If it's empty, you handle that
gracefully. You never reach in blindly. You check first,
or you say "if there's a gift, do this; otherwise, here's
a default." Optional is a contract that forces you to think
about the absence of a value rather than ignoring it.

📖 EXPLANATION:
This lesson covers advanced functional interfaces and
Optional — Java 8's answer to NullPointerException.

─────────────────────────────────────
FUNCTIONAL INTERFACES IN DEPTH:
─────────────────────────────────────
  Core package: java.util.function

  SINGLE PARAMETER:
  Function<T,R>          T → R              apply(T)
  Consumer<T>            T → void           accept(T)
  Supplier<T>            () → T             get()
  Predicate<T>           T → boolean        test(T)
  UnaryOperator<T>       T → T              apply(T)

  TWO PARAMETERS:
  BiFunction<T,U,R>      T,U → R            apply(T,U)
  BiConsumer<T,U>        T,U → void         accept(T,U)
  BiPredicate<T,U>       T,U → boolean      test(T,U)
  BinaryOperator<T>      T,T → T            apply(T,T)

  PRIMITIVE SPECIALIZATIONS (avoid boxing):
  IntFunction<R>         int → R
  ToIntFunction<T>       T → int
  IntUnaryOperator       int → int
  IntBinaryOperator      int,int → int
  IntConsumer            int → void
  IntSupplier            () → int
  IntPredicate           int → boolean
  (Same patterns for Long and Double)

─────────────────────────────────────
COMPOSING FUNCTIONS:
─────────────────────────────────────
  Function.andThen(after)  → apply this, then apply after
  Function.compose(before) → apply before, then apply this
  Predicate.and(other)     → both must be true
  Predicate.or(other)      → either must be true
  Predicate.negate()       → flip the result
  Consumer.andThen(after)  → run this, then run after

─────────────────────────────────────
Optional<T>:
─────────────────────────────────────
  An Optional is a container for a value that might be absent.
  
  CREATING:
  Optional.of(value)        → non-null value (throws on null)
  Optional.ofNullable(val)  → value or null (wraps either)
  Optional.empty()          → empty Optional

  CHECKING:
  opt.isPresent()           → true if value exists
  opt.isEmpty()             → true if no value (Java 11)

  GETTING:
  opt.get()                 → value, or NoSuchElementException
  opt.orElse(default)       → value or default
  opt.orElseGet(Supplier)   → value or compute default
  opt.orElseThrow()         → value or throw NoSuchElementException
  opt.orElseThrow(Supplier) → value or throw custom exception

  TRANSFORMING:
  opt.map(Function)         → transform value if present
  opt.flatMap(Function)     → transform to Optional if present
  opt.filter(Predicate)     → keep value if predicate passes
  opt.or(Supplier<Optional>)→ alternative Optional if empty

  CONSUMING:
  opt.ifPresent(Consumer)           → run if present
  opt.ifPresentOrElse(C, Runnable)  → run one of two (Java 9)

─────────────────────────────────────
OPTIONAL BEST PRACTICES:
─────────────────────────────────────
  ✅ Return Optional from methods that might not have a result
  ✅ Use orElse() / orElseGet() for defaults
  ✅ Use map() to transform without unwrapping
  ✅ Use ifPresentOrElse() for clean branching
  ❌ Don't use Optional as a method parameter
  ❌ Don't use Optional for class fields
  ❌ Don't call get() without checking isPresent() first
  ❌ Never return null from a method that returns Optional

💻 CODE:
import java.util.*;
import java.util.function.*;
import java.util.stream.*;

record User(String id, String name, String email, boolean active) { }
record Order(String id, String userId, double amount, String status) { }

// ─── REPOSITORY SIMULATION ────────────────────────────
class UserRepo {
    private static final Map<String, User> DB = Map.of(
        "U1", new User("U1", "Alice",   "alice@test.com", true),
        "U2", new User("U2", "Bob",     "bob@test.com",   false),
        "U3", new User("U3", "Charlie", "charlie@test.com", true)
    );

    public Optional<User> findById(String id) {
        return Optional.ofNullable(DB.get(id));
    }

    public Optional<User> findByEmail(String email) {
        return DB.values().stream()
            .filter(u -> u.email().equalsIgnoreCase(email))
            .findFirst();
    }

    public Optional<User> findActiveById(String id) {
        return findById(id).filter(User::active);
    }
}

// ─── FUNCTIONAL PIPELINE ──────────────────────────────
class DataPipeline {
    // Higher-order function that builds a transformation pipeline
    @SafeVarargs
    public static <T> Function<T, T> pipeline(Function<T, T>... stages) {
        return Arrays.stream(stages)
            .reduce(Function.identity(), Function::andThen);
    }

    // Retry with limit
    public static <T> Optional<T> tryGet(Supplier<T> supplier, int maxAttempts) {
        for (int i = 0; i < maxAttempts; i++) {
            try {
                T result = supplier.get();
                if (result != null) return Optional.of(result);
            } catch (Exception e) {
                System.out.println("  Attempt " + (i + 1) + " failed: " + e.getMessage());
            }
        }
        return Optional.empty();
    }
}

public class FunctionalAndOptional {
    public static void main(String[] args) {

        // ─── FUNCTIONAL INTERFACE DEEP DIVE ───────────────
        System.out.println("=== Functional Interface Composition ===");

        // Function composition
        Function<String, String> trim    = String::trim;
        Function<String, String> lower   = String::toLowerCase;
        Function<String, String> noSpace = s -> s.replace(" ", "_");
        Function<String, Integer> length = String::length;

        Function<String, String> normalize = DataPipeline.pipeline(trim, lower, noSpace);
        Function<String, Integer> normalizedLength = normalize.andThen(length);

        List<String> inputs = Arrays.asList("  Hello World  ", " JAVA STREAMS ", "  Optional API  ");
        inputs.forEach(s -> System.out.printf(
            "  '%-20s' → '%s' (len=%d)%n",
            s, normalize.apply(s), normalizedLength.apply(s)));

        // Predicate composition
        System.out.println("\n=== Predicate Composition ===");
        Predicate<String> notEmpty   = s -> !s.isEmpty();
        Predicate<String> noSpaces   = s -> !s.contains(" ");
        Predicate<String> minLength  = s -> s.length() >= 8;
        Predicate<String> hasDigit   = s -> s.chars().anyMatch(Character::isDigit);
        Predicate<String> hasUpper   = s -> s.chars().anyMatch(Character::isUpperCase);

        Predicate<String> strongPassword = notEmpty
            .and(noSpaces)
            .and(minLength)
            .and(hasDigit)
            .and(hasUpper);

        List<String> passwords = Arrays.asList(
            "password", "P@ssw0rd", "secret1A", "NoDigits!",
            "short", "ValidP4ss", "spaces here1A"
        );
        System.out.println("  Password strength check:");
        passwords.forEach(p ->
            System.out.printf("    %-20s → %s%n", p, strongPassword.test(p) ? "✅ Strong" : "❌ Weak"));

        // BiFunction and BiConsumer
        System.out.println("\n=== BiFunction / BiConsumer ===");
        BiFunction<String, Integer, String> repeat = (s, n) -> s.repeat(n);
        BiFunction<Double, Double, Double>  hyp    = (a, b) -> Math.sqrt(a*a + b*b);
        BiConsumer<String, Object>          log    = (label, val) ->
            System.out.printf("  [LOG] %-15s = %s%n", label, val);

        log.accept("repeat('ab',4)", repeat.apply("ab", 4));
        log.accept("hypotenuse(3,4)", String.format("%.2f", hyp.apply(3.0, 4.0)));

        // ─── OPTIONAL ─────────────────────────────────────
        System.out.println("\n=== Optional Usage ===");
        UserRepo repo = new UserRepo();

        // Basic Optional usage
        Optional<User> found    = repo.findById("U1");
        Optional<User> notFound = repo.findById("X9");

        System.out.println("  U1 present: " + found.isPresent());
        System.out.println("  X9 empty:   " + notFound.isEmpty());

        // orElse / orElseGet / orElseThrow
        User user1 = found.orElseThrow(() ->
            new IllegalStateException("User not found"));
        System.out.println("  Found: " + user1.name());

        User defaultUser = notFound.orElse(
            new User("GUEST", "Guest", "", false));
        System.out.println("  Default: " + defaultUser.name());

        User computed = notFound.orElseGet(() ->
            new User("DEFAULT", "Anonymous", "anon@app.com", false));
        System.out.println("  Computed default: " + computed.name());

        // map() — transform without unwrapping
        System.out.println("\n=== Optional.map() ===");
        Optional<String> email = repo.findById("U1").map(User::email);
        Optional<Integer> emailLen = email.map(String::length);
        System.out.println("  Email:   " + email.orElse("none"));
        System.out.println("  Length:  " + emailLen.orElse(0));

        // Chained map
        String result = repo.findById("U3")
            .map(User::name)
            .map(String::toUpperCase)
            .map(n -> "Hello, " + n + "!")
            .orElse("User not found");
        System.out.println("  Chained map: " + result);

        // filter()
        System.out.println("\n=== Optional.filter() ===");
        Optional<User> activeUser = repo.findActiveById("U1");
        Optional<User> inactiveUser = repo.findActiveById("U2"); // Bob is inactive

        activeUser.ifPresentOrElse(
            u -> System.out.println("  Active user: " + u.name()),
            () -> System.out.println("  No active user found")
        );
        inactiveUser.ifPresentOrElse(
            u -> System.out.println("  Active user: " + u.name()),
            () -> System.out.println("  Bob is inactive — not returned")
        );

        // or() — alternative Optional (Java 9)
        System.out.println("\n=== Optional.or() ===");
        Optional<User> primary   = repo.findById("X9");  // missing
        Optional<User> secondary = repo.findById("U2");  // Bob (inactive)
        Optional<User> fallback  = repo.findById("U1");  // Alice (active)

        Optional<User> resolved = primary
            .filter(User::active)
            .or(() -> secondary.filter(User::active))
            .or(() -> fallback.filter(User::active));

        resolved.ifPresent(u ->
            System.out.println("  Resolved active user: " + u.name())); // Alice

        // Stream from Optional (Java 9+)
        System.out.println("\n=== Optional.stream() ===");
        List<String> ids = Arrays.asList("U1", "X9", "U3", "U2", "Y0");
        List<User> activeUsers = ids.stream()
            .map(repo::findById)                   // Stream<Optional<User>>
            .flatMap(Optional::stream)             // Stream<User> — empty optionals removed
            .filter(User::active)
            .sorted(Comparator.comparing(User::name))
            .collect(Collectors.toList());

        System.out.println("  Active users from mixed IDs:");
        activeUsers.forEach(u ->
            System.out.printf("    %s (%s)%n", u.name(), u.email()));

        // ─── PRACTICAL: safe method chain ─────────────────
        System.out.println("\n=== Safe method chain ===");
        // Instead of null checks everywhere:
        // if (user != null && user.getEmail() != null && user.getEmail().contains("@"))
        // Use Optional:
        boolean isValidEmail = repo.findById("U1")
            .map(User::email)
            .filter(e -> e.contains("@"))
            .isPresent();
        System.out.println("  U1 has valid email: " + isValidEmail);
    }
}

📝 KEY POINTS:
✅ Optional.ofNullable() safely wraps a value that might be null
✅ orElse() computes the default eagerly; orElseGet() computes lazily (prefer for expensive defaults)
✅ map() transforms the value inside Optional without unwrapping
✅ filter() discards the value if the predicate fails
✅ flatMap() is for functions that already return Optional
✅ ifPresentOrElse() cleanly handles both present and absent cases
✅ or() provides an alternative Optional — great for fallback chains
✅ Optional.stream() integrates Optionals into stream pipelines cleanly
✅ Function composition with andThen/compose builds clean data pipelines
❌ Never use Optional as a method parameter or class field — use it as a return type only
❌ Never call get() without isPresent() — defeats the whole purpose
❌ Don't use orElse(expensiveOperation()) — use orElseGet(() -> expensive())
❌ Don't return null from a method declared to return Optional
""",
  quiz: [
    Quiz(question: 'What is the difference between Optional.orElse() and Optional.orElseGet()?', options: [
      QuizOption(text: 'orElse() always evaluates the default; orElseGet() only evaluates it when the Optional is empty', correct: true),
      QuizOption(text: 'orElse() throws if empty; orElseGet() returns null if empty', correct: false),
      QuizOption(text: 'orElseGet() is for primitive types; orElse() is for objects', correct: false),
      QuizOption(text: 'They are identical — the names are just for readability', correct: false),
    ]),
    Quiz(question: 'What does Optional.map() do?', options: [
      QuizOption(text: 'If a value is present, applies the function and returns Optional of the result; if empty, returns empty', correct: true),
      QuizOption(text: 'Converts the Optional to a List by applying the function to all elements', correct: false),
      QuizOption(text: 'Replaces the value if absent, keeping it unchanged if present', correct: false),
      QuizOption(text: 'Unwraps the value and applies the function, throwing if empty', correct: false),
    ]),
    Quiz(question: 'When should you NOT use Optional?', options: [
      QuizOption(text: 'As a method parameter or class field — use it only as a return type for methods that might not have a result', correct: true),
      QuizOption(text: 'When the value might be null — null should be used directly in that case', correct: false),
      QuizOption(text: 'In stream pipelines — Optional and streams are not compatible', correct: false),
      QuizOption(text: 'For simple string values — Optional should only wrap complex objects', correct: false),
    ]),
  ],
);
