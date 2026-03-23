import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson40 = Lesson(
  language: 'Java',
  title: 'Best Practices and Java Idioms',
  content: """
🎯 METAPHOR:
Best practices are like the rules of a professional kitchen
that experienced chefs follow not because they're forced to,
but because they've learned — sometimes painfully — why each
rule exists. "Always cut away from your body" isn't an
arbitrary rule; someone got cut learning it. "Mise en place"
(prepare everything before you start) isn't OCD — it's the
difference between a smooth service and chaos. Java best
practices are the same: accumulated wisdom from decades of
developers hitting the same pitfalls. Following them doesn't
make you a rule-follower — it makes you a professional.

📖 EXPLANATION:
These are the most impactful Java best practices drawn from
Effective Java (Joshua Bloch), Oracle's Java coding standards,
and industry experience.

─────────────────────────────────────
1. PREFER IMMUTABILITY:
─────────────────────────────────────
  ✅ Use final fields when possible
  ✅ Return defensive copies of mutable objects
  ✅ Use unmodifiableList() for getters returning collections
  ✅ Use records for pure data holders (Java 16+)

  // ❌ Exposes internal state:
  public List<String> getItems() { return items; }

  // ✅ Returns defensive copy:
  public List<String> getItems() {
      return Collections.unmodifiableList(items);
  }

─────────────────────────────────────
2. USE INTERFACES AS TYPES:
─────────────────────────────────────
  // ❌ Coupled to implementation:
  ArrayList<String> list = new ArrayList<>();

  // ✅ Flexible — can swap to LinkedList without changing code:
  List<String> list = new ArrayList<>();

  Same for Map (not HashMap), Set (not HashSet), etc.

─────────────────────────────────────
3. PREFER COMPOSITION OVER INHERITANCE:
─────────────────────────────────────
  // ❌ Inheritance: Stack IS-A Vector (wrong — Stack has 3 ops, Vector has 100)
  public class Stack<E> extends Vector<E> { }  // Java's mistake

  // ✅ Composition: Stack HAS-A container
  public class Stack<E> {
      private final List<E> elements = new ArrayList<>();
      public void push(E item) { elements.add(item); }
      public E pop() { return elements.remove(elements.size()-1); }
  }

─────────────────────────────────────
4. OBEY THE CONTRACT — equals, hashCode, compareTo:
─────────────────────────────────────
  If equals() is overridden: override hashCode() too.
  If Comparable<T> is implemented: be consistent with equals().
  If used as a map key: implement equals() and hashCode().

─────────────────────────────────────
5. MINIMISE SCOPE OF VARIABLES:
─────────────────────────────────────
  // ❌ Declared before needed:
  Iterator<String> it;
  // ... 20 lines of unrelated code ...
  it = list.iterator();

  // ✅ Declared where needed:
  for (var it = list.iterator(); it.hasNext(); ) { ... }

─────────────────────────────────────
6. AVOID NULL — USE Optional INSTEAD:
─────────────────────────────────────
  // ❌ Null return forces callers to null-check:
  public String findEmail(int id) { return null; }

  // ✅ Optional makes absence explicit:
  public Optional<String> findEmail(int id) { return Optional.empty(); }

─────────────────────────────────────
7. HANDLE EXCEPTIONS PROPERLY:
─────────────────────────────────────
  ❌ catch (Exception e) { }          // silently swallowed!
  ❌ catch (Exception e) { e.printStackTrace(); }  // lazy
  ✅ catch (SpecificException e) {
         logger.error("Context: {}", context, e);
         throw new DomainException("What failed", e);
     }

─────────────────────────────────────
8. FAVOR STATIC FACTORY METHODS:
─────────────────────────────────────
  // ✅ More readable, can cache, can return subtypes:
  Integer.valueOf(42)         // may return cached instance
  List.of("a", "b")           // returns immutable list
  Optional.of(value)          // clear intent

  vs new Integer(42) — always creates new, deprecated

─────────────────────────────────────
9. CLOSE RESOURCES WITH try-with-resources:
─────────────────────────────────────
  // ❌ Potential resource leak:
  Connection conn = ds.getConnection();
  // ...exception here → conn never closed!
  conn.close();

  // ✅ Always closed:
  try (Connection conn = ds.getConnection()) {
      // ...
  }

─────────────────────────────────────
10. USE THE RIGHT COLLECTION:
─────────────────────────────────────
  Need fast lookup?      → HashMap / HashSet
  Need sorted order?     → TreeMap / TreeSet
  Need insertion order?  → LinkedHashMap / LinkedHashSet
  Need a queue/stack?    → ArrayDeque
  Need thread safety?    → ConcurrentHashMap

─────────────────────────────────────
11. DON'T OPTIMIZE PREMATURELY:
─────────────────────────────────────
  Write clear code first. Profile before optimizing.
  "Premature optimization is the root of all evil." — Knuth

─────────────────────────────────────
12. USE ENUMS INSTEAD OF int CONSTANTS:
─────────────────────────────────────
  // ❌ Magic numbers — what is 1? 2?
  public static final int STATUS_PENDING = 1;
  if (status == 1) { ... }

  // ✅ Self-documenting:
  enum Status { PENDING, ACTIVE, CANCELLED }
  if (status == Status.PENDING) { ... }

💻 CODE:
import java.util.*;
import java.util.function.*;
import java.util.stream.*;

// ─── DEMONSTRATING BEST PRACTICES ─────────────────────

// ✅ IMMUTABLE VALUE CLASS with factory method
final class Money {
    private final long cents;
    private final Currency currency;

    private Money(long cents, Currency currency) {
        this.cents    = cents;
        this.currency = Objects.requireNonNull(currency);
    }

    // Static factory — clear intent, can validate
    public static Money of(long cents, Currency currency) {
        if (cents < 0) throw new IllegalArgumentException("Negative money");
        return new Money(cents, currency);
    }

    public static Money zero(Currency currency) {
        return new Money(0, currency);
    }

    public Money add(Money other) {
        if (!currency.equals(other.currency))
            throw new IllegalArgumentException("Currency mismatch");
        return new Money(cents + other.cents, currency);
    }

    public Money multiply(double factor) {
        return new Money(Math.round(cents * factor), currency);
    }

    public long getCents()        { return cents; }
    public Currency getCurrency() { return currency; }

    @Override
    public boolean equals(Object o) {
        if (!(o instanceof Money m)) return false;
        return cents == m.cents && currency.equals(m.currency);
    }

    @Override public int hashCode() { return Objects.hash(cents, currency); }

    @Override public String toString() {
        return currency.getCurrencyCode() + " " +
            String.format("%.2f", cents / 100.0);
    }
}

// ✅ USE INTERFACES AS TYPES
class DataProcessor {
    // All return types are interfaces — not implementations
    public List<String> process(List<String> input) {
        return input.stream()
            .filter(s -> !s.isBlank())
            .map(String::strip)
            .map(String::toUpperCase)
            .collect(Collectors.toList());
    }

    public Map<String, Long> countByFirstChar(List<String> words) {
        return words.stream()
            .collect(Collectors.groupingBy(
                w -> String.valueOf(w.charAt(0)),
                Collectors.counting()
            ));
    }
}

// ✅ COMPOSITION OVER INHERITANCE
class ValidatedStack<T> {  // HAS-A, not IS-A
    private final Deque<T> storage = new ArrayDeque<>();  // interface!
    private final Predicate<T> validator;
    private int rejectedCount = 0;

    public ValidatedStack(Predicate<T> validator) {
        this.validator = validator;
    }

    public boolean push(T item) {
        if (!validator.test(item)) { rejectedCount++; return false; }
        storage.push(item);
        return true;
    }

    public Optional<T> pop() {
        return Optional.ofNullable(storage.isEmpty() ? null : storage.pop());
    }

    public Optional<T> peek() {
        return Optional.ofNullable(storage.peek());
    }

    public int size()          { return storage.size(); }
    public int getRejected()   { return rejectedCount; }
    public boolean isEmpty()   { return storage.isEmpty(); }
}

public class BestPractices {
    public static void main(String[] args) {

        // ─── IMMUTABLE MONEY ──────────────────────────────
        System.out.println("=== Immutable Money with static factory ===");
        var usd = Currency.getInstance("USD");
        var price  = Money.of(1999, usd);   // $19.99
        var tax    = Money.of(160, usd);    //  $1.60
        var total  = price.add(tax);
        var discount = total.multiply(0.9);

        System.out.println("  Price:    " + price);
        System.out.println("  Tax:      " + tax);
        System.out.println("  Total:    " + total);
        System.out.println("  Discount: " + discount);
        System.out.println("  Original unchanged: " + price);  // immutable!

        // Equals/hashCode
        var price2 = Money.of(1999, usd);
        System.out.println("  price.equals(price2): " + price.equals(price2));

        Set<Money> set = new HashSet<>();
        set.add(price); set.add(price2);  // same value
        System.out.println("  Set size (should be 1): " + set.size());

        // ─── INTERFACE TYPES ──────────────────────────────
        System.out.println("\n=== Interface types ===");
        DataProcessor processor = new DataProcessor();
        List<String> rawWords = Arrays.asList("  hello  ", "WORLD", "", "  java  ", "  ");
        List<String> processed = processor.process(rawWords);
        System.out.println("  Processed: " + processed);

        Map<String, Long> counts = processor.countByFirstChar(
            Arrays.asList("apple", "ant", "bear", "avocado", "banana"));
        System.out.println("  By first char: " + new TreeMap<>(counts));

        // ─── COMPOSITION ──────────────────────────────────
        System.out.println("\n=== Composition (ValidatedStack) ===");
        ValidatedStack<Integer> stack = new ValidatedStack<>(n -> n > 0 && n <= 100);
        int[] candidates = {42, -1, 100, 0, 75, 200, 50, 99};

        for (int n : candidates) {
            boolean accepted = stack.push(n);
            System.out.printf("  push(%3d): %s%n", n, accepted ? "✅" : "❌ rejected");
        }
        System.out.println("  Size:     " + stack.size());
        System.out.println("  Rejected: " + stack.getRejected());
        System.out.println("  Peek:     " + stack.peek());

        while (!stack.isEmpty()) {
            stack.pop().ifPresent(n -> System.out.print("  " + n));
        }
        System.out.println();

        // ─── ENUM vs INT CONSTANTS ────────────────────────
        System.out.println("\n=== Enum over int constants ===");
        enum Priority { LOW, MEDIUM, HIGH, CRITICAL }
        enum Category { BUG, FEATURE, DOCS, SECURITY }

        record Issue(String title, Priority priority, Category category) { }

        List<Issue> issues = Arrays.asList(
            new Issue("Login crash",     Priority.CRITICAL, Category.BUG),
            new Issue("Dark mode",       Priority.LOW,      Category.FEATURE),
            new Issue("SQL injection",   Priority.CRITICAL, Category.SECURITY),
            new Issue("Update README",   Priority.LOW,      Category.DOCS),
            new Issue("Slow search",     Priority.HIGH,     Category.BUG)
        );

        System.out.println("  Critical issues:");
        issues.stream()
            .filter(i -> i.priority() == Priority.CRITICAL)
            .forEach(i -> System.out.printf("    [%s] %s%n", i.category(), i.title()));

        System.out.println("  By priority:");
        issues.stream()
            .sorted(Comparator.comparing(Issue::priority).reversed())
            .forEach(i -> System.out.printf("    %-10s [%s] %s%n",
                i.priority(), i.category(), i.title()));

        // ─── OPTIONAL OVER NULL ───────────────────────────
        System.out.println("\n=== Optional over null ===");
        Map<String, String> config = Map.of("host", "localhost", "port", "8080");

        // ❌ Old null-based approach:
        String host = config.get("host");
        if (host != null) {
            System.out.println("  host (null-check): " + host);
        }

        // ✅ Optional approach:
        Optional.ofNullable(config.get("host"))
            .map(String::toUpperCase)
            .ifPresent(h -> System.out.println("  host (optional): " + h));

        String timeout = Optional.ofNullable(config.get("timeout"))
            .orElse("30s");
        System.out.println("  timeout default: " + timeout);

        // ─── PROPER EXCEPTION HANDLING ────────────────────
        System.out.println("\n=== Exception handling ===");
        List<String> inputs = Arrays.asList("42", "abc", "100", "xyz", "7");

        List<Integer> parsed = inputs.stream()
            .map(s -> {
                try {
                    return Optional.of(Integer.parseInt(s));
                } catch (NumberFormatException e) {
                    System.out.println("  ⚠️  Could not parse: " + s);
                    return Optional.<Integer>empty();
                }
            })
            .filter(Optional::isPresent)
            .map(Optional::get)
            .collect(Collectors.toList());

        System.out.println("  Parsed successfully: " + parsed);
        System.out.println("  Sum: " + parsed.stream().mapToInt(i->i).sum());
    }
}

📝 KEY POINTS:
✅ Prefer immutability — final fields, defensive copies, unmodifiable collections
✅ Use interfaces as types: List not ArrayList, Map not HashMap
✅ Composition over inheritance — HAS-A is more flexible than IS-A
✅ Always override hashCode() when overriding equals()
✅ Use Optional instead of returning null from methods
✅ Use enums instead of int constants — type-safe and self-documenting
✅ try-with-resources for all AutoCloseable resources
✅ Static factory methods over public constructors
✅ Minimize variable scope — declare where used, not at top of method
✅ Catch specific exceptions, not Exception — handle or re-throw with context
❌ Don't optimize prematurely — clarity first, then profile
❌ Never silently swallow exceptions: catch(e) { } hides bugs
❌ Don't expose mutable internal state through getters
❌ Don't use raw types (List without <>) — use generics everywhere
""",
  quiz: [
    Quiz(question: 'Why should you declare variables as List<T> rather than ArrayList<T>?', options: [
      QuizOption(text: 'Using the interface type allows swapping implementations without changing dependent code', correct: true),
      QuizOption(text: 'ArrayList is deprecated — List is its replacement', correct: false),
      QuizOption(text: 'List<T> performs better than ArrayList<T> at runtime', correct: false),
      QuizOption(text: 'The compiler requires interface types for generics to work correctly', correct: false),
    ]),
    Quiz(question: 'What is a defensive copy in the context of encapsulation?', options: [
      QuizOption(text: 'Returning a copy of a mutable field instead of the field itself, preventing external modification', correct: true),
      QuizOption(text: 'Making a backup of an object before it is passed to an unsafe method', correct: false),
      QuizOption(text: 'Cloning all objects in a collection before returning them', correct: false),
      QuizOption(text: 'Wrapping method calls in try-catch to defend against exceptions', correct: false),
    ]),
    Quiz(question: 'What is the main reason to prefer enums over int constants for status codes?', options: [
      QuizOption(text: 'Enums are type-safe — you cannot accidentally pass an invalid value where a status is expected', correct: true),
      QuizOption(text: 'Enums are faster than integer comparisons at runtime', correct: false),
      QuizOption(text: 'Int constants cannot be used in switch statements', correct: false),
      QuizOption(text: 'Enums are automatically serialized to JSON by all frameworks', correct: false),
    ]),
  ],
);
