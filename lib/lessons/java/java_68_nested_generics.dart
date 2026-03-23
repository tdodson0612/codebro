import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson68 = Lesson(
  language: 'Java',
  title: 'Nested Generics, Wildcards, and PECS',
  content: """
🎯 METAPHOR:
Generics wildcards are like elevator access rules in a
skyscraper. <? extends Building> means "any floor in
this building or its sub-buildings" — you can look at
what's there (read) but you can't add a new room
(write) because you don't know exactly what kind of
building it is. <? super Floor> means "this floor or
any floor above it" — you CAN add rooms (write) on
your floor or anything above, but reading gives you
only the most general view (Object). The PECS principle —
Producer Extends, Consumer Super — is the shorthand
rule: if a collection GIVES you things, use extends;
if it TAKES things from you, use super.

📖 EXPLANATION:
Generics in depth: bounded wildcards, PECS, type tokens,
and complex generic type signatures.

─────────────────────────────────────
WILDCARD TYPES:
─────────────────────────────────────
  ?                    → unknown type (any type)
  ? extends T          → T or any subtype (upper bound)
  ? super T            → T or any supertype (lower bound)

─────────────────────────────────────
PECS — Producer Extends, Consumer Super:
─────────────────────────────────────
  // PRODUCER (gives you values) → use extends:
  void printAll(List<? extends Number> numbers) {
      for (Number n : numbers) System.out.println(n);
      // numbers.add(1.0);  // ❌ can't add — don't know exact type
  }
  printAll(List.of(1, 2, 3));        // works with List<Integer>
  printAll(List.of(1.1, 2.2));       // works with List<Double>

  // CONSUMER (accepts values you give it) → use super:
  void addNumbers(List<? super Integer> list) {
      list.add(1); list.add(2); list.add(3);
      // Integer n = list.get(0);  // ❌ can't read as Integer
  }
  addNumbers(new ArrayList<Integer>());
  addNumbers(new ArrayList<Number>());
  addNumbers(new ArrayList<Object>());

  // BOTH: copy one collection into another:
  static <T> void copy(List<? extends T> src, List<? super T> dst) {
      for (T item : src) dst.add(item);
  }

─────────────────────────────────────
MULTIPLE BOUNDS:
─────────────────────────────────────
  // T must extend A AND implement B:
  <T extends Comparable<T> & Cloneable>
  <T extends Number & Comparable<T>>

  // Only ONE class bound (must be first), rest interfaces:
  <T extends AbstractList<E> & Serializable & Cloneable>

─────────────────────────────────────
RECURSIVE TYPE BOUNDS:
─────────────────────────────────────
  // T is comparable to itself:
  <T extends Comparable<T>> T max(List<T> list) { ... }

  // Builder pattern — return Self:
  abstract class Builder<T, B extends Builder<T, B>> {
      @SuppressWarnings("unchecked")
      protected B self() { return (B) this; }
      public B name(String n) { this.name = n; return self(); }
  }

─────────────────────────────────────
NESTED GENERIC TYPES:
─────────────────────────────────────
  Map<String, List<Integer>>
  Map<String, Map<String, List<Double>>>
  Function<List<? extends T>, Optional<T>>
  Comparator<Map.Entry<String, Integer>>

  // Method with complex signature:
  static <K, V extends Comparable<V>> Map.Entry<K, V>
      maxByValue(Map<K, V> map) {
      return map.entrySet().stream()
          .max(Map.Entry.comparingByValue())
          .orElseThrow();
  }

─────────────────────────────────────
TYPE TOKENS — Class<T> as parameter:
─────────────────────────────────────
  // Avoid unchecked cast by passing Class<T>:
  static <T> T parseAs(String json, Class<T> type) {
      // ... use type for reflection/deserialization
  }

  String result = parseAs(json, String.class);
  Integer num   = parseAs(json, Integer.class);

  // Type-safe heterogeneous container:
  class TypeSafeMap {
      private Map<Class<?>, Object> store = new HashMap<>();

      public <T> void put(Class<T> type, T value) {
          store.put(type, value);
      }

      public <T> T get(Class<T> type) {
          return type.cast(store.get(type));
      }
  }

─────────────────────────────────────
GENERIC METHODS vs WILDCARDS:
─────────────────────────────────────
  // These are equivalent:
  static <T> void swap(List<T> list, int i, int j) { }
  static void swap(List<?> list, int i, int j) { }

  Use wildcards when T is only used once.
  Use generic methods when T appears in multiple places.

─────────────────────────────────────
TYPE ERASURE AND RESTRICTIONS:
─────────────────────────────────────
  Due to type erasure (generics only exist at compile time):
  ❌ new T()              // can't create generic instances
  ❌ new T[10]            // can't create generic arrays
  ❌ x instanceof List<String>  // can't check parameterized type
  ❌ catch (E e)          // can't catch generic exceptions

  Workarounds:
  ✅ Pass Class<T> and call clazz.getDeclaredConstructor().newInstance()
  ✅ Use List<T> instead of T[]
  ✅ Use instanceof List<?> then suppress warning and cast

💻 CODE:
import java.util.*;
import java.util.function.*;
import java.util.stream.*;

public class NestedGenericsWildcards {

    // PECS in action
    static <T> void copy(List<? extends T> src, List<? super T> dst) {
        for (T item : src) dst.add(item);
    }

    // Upper bound — read-only
    static double sumNumbers(List<? extends Number> numbers) {
        return numbers.stream().mapToDouble(Number::doubleValue).sum();
    }

    // Lower bound — write-only  
    static void addIntegers(List<? super Integer> list, int n) {
        for (int i = 1; i <= n; i++) list.add(i);
    }

    // Recursive bound — T comparable to itself
    static <T extends Comparable<T>> T max(List<T> list) {
        return list.stream().max(Comparator.naturalOrder()).orElseThrow();
    }

    // Complex nested generics — max map entry by value
    static <K, V extends Comparable<V>> Map.Entry<K, V>
            maxByValue(Map<K, V> map) {
        return map.entrySet().stream()
            .max(Map.Entry.comparingByValue())
            .orElseThrow();
    }

    // Type-safe heterogeneous container
    static class TypeSafeRegistry {
        private final Map<Class<?>, Object> registry = new LinkedHashMap<>();

        public <T> void register(Class<T> type, T value) {
            registry.put(type, type.cast(value));
        }

        public <T> Optional<T> get(Class<T> type) {
            return Optional.ofNullable(type.cast(registry.get(type)));
        }

        public void printAll() {
            registry.forEach((type, value) ->
                System.out.printf("  %-10s → %s%n",
                    type.getSimpleName(), value));
        }
    }

    // Wildcard capture helper (allows modifying List<?>)
    static <T> void swapHelper(List<T> list, int i, int j) {
        T temp = list.get(i);
        list.set(i, list.get(j));
        list.set(j, temp);
    }
    static void swap(List<?> list, int i, int j) {
        swapHelper(list, i, j);  // capture wildcard in helper
    }

    public static void main(String[] args) {

        // ─── PECS DEMO ────────────────────────────────────
        System.out.println("=== PECS: Producer Extends, Consumer Super ===");

        // Upper bound — accepts List<Integer>, List<Double>, List<Number>
        System.out.println("  Sum of integers:  " + sumNumbers(List.of(1, 2, 3, 4, 5)));
        System.out.println("  Sum of doubles:   " + sumNumbers(List.of(1.5, 2.5, 3.0)));
        System.out.println("  Sum of mixed:     " + sumNumbers(List.of(1, 2.5, 3L)));

        // Lower bound — accepts List<Integer>, List<Number>, List<Object>
        List<Number> numList = new ArrayList<>();
        addIntegers(numList, 5);
        System.out.println("  Added to Number list: " + numList);

        List<Object> objList = new ArrayList<>();
        addIntegers(objList, 3);
        System.out.println("  Added to Object list: " + objList);

        // copy — uses both bounds
        List<Integer> ints  = List.of(10, 20, 30);
        List<Number>  nums  = new ArrayList<>();
        copy(ints, nums);   // List<Integer> (extends Number) → List<Number> (super Integer)
        System.out.println("  Copied ints to nums: " + nums);

        // ─── MULTIPLE BOUNDS ──────────────────────────────
        System.out.println("\n=== Multiple Bounds ===");
        System.out.println("  max of strings: " + max(List.of("banana", "apple", "cherry")));
        System.out.println("  max of integers:" + max(List.of(3, 1, 4, 1, 5, 9, 2, 6)));
        System.out.println("  max of doubles: " + max(List.of(3.14, 2.71, 1.41)));

        // ─── NESTED GENERICS ──────────────────────────────
        System.out.println("\n=== Nested Generic Types ===");
        Map<String, List<Integer>> groupedScores = new LinkedHashMap<>();
        groupedScores.put("Engineering", List.of(95, 88, 92, 97));
        groupedScores.put("Marketing",   List.of(82, 75, 79));
        groupedScores.put("HR",          List.of(85, 90));

        // Map<String, List<Integer>> → Map<String, Double> (avg per group)
        Map<String, Double> averages = groupedScores.entrySet().stream()
            .collect(Collectors.toMap(
                Map.Entry::getKey,
                e -> e.getValue().stream()
                    .mapToInt(Integer::intValue).average().orElse(0)));

        new TreeMap<>(averages).forEach((dept, avg) ->
            System.out.printf("  %-15s → avg=%.1f%n", dept, avg));

        // Max by value
        Map.Entry<String, Double> topDept = maxByValue(averages);
        System.out.println("  Top dept: " + topDept.getKey() + " (avg=" + topDept.getValue() + ")");

        // ─── TYPE-SAFE REGISTRY ───────────────────────────
        System.out.println("\n=== Type-Safe Heterogeneous Container ===");
        TypeSafeRegistry registry = new TypeSafeRegistry();
        registry.register(String.class,  "Hello, Generics!");
        registry.register(Integer.class, 42);
        registry.register(Double.class,  3.14);
        registry.register(Boolean.class, true);

        registry.printAll();
        System.out.println("  Get String:  " + registry.get(String.class).orElse("none"));
        System.out.println("  Get Integer: " + registry.get(Integer.class).orElse(0));
        System.out.println("  Get Float:   " + registry.get(Float.class).orElse("missing"));

        // ─── WILDCARD CAPTURE ─────────────────────────────
        System.out.println("\n=== Wildcard Capture (swap) ===");
        List<String> words = new ArrayList<>(List.of("banana", "apple", "cherry", "date"));
        System.out.println("  Before: " + words);
        swap(words, 0, 2);  // swap first and third
        System.out.println("  After:  " + words);

        // ─── COMPLEX FUNCTIONAL GENERICS ──────────────────
        System.out.println("\n=== Complex Generic Functional Types ===");
        // Function<List<? extends T>, Optional<T>> — find max in list
        Function<List<? extends Integer>, Optional<Integer>> findMax =
            list -> list.stream().max(Comparator.naturalOrder());

        System.out.println("  Max of [3,1,4,1,5]: " + findMax.apply(List.of(3, 1, 4, 1, 5)));

        // Comparator<Map.Entry<String, Integer>>
        Map<String, Integer> scores = Map.of("Alice", 95, "Bob", 82, "Carol", 91);
        Comparator<Map.Entry<String, Integer>> byValue =
            Map.Entry.comparingByValue(Comparator.reverseOrder());

        scores.entrySet().stream()
            .sorted(byValue)
            .forEach(e -> System.out.printf("  %-8s %d%n", e.getKey(), e.getValue()));
    }
}

📝 KEY POINTS:
✅ PECS: use <? extends T> when reading (producer); <? super T> when writing (consumer)
✅ Upper bound (extends): can read as T, cannot add elements (don't know exact type)
✅ Lower bound (super): can add T elements, can only read as Object
✅ copy(src, dst) is the canonical PECS example: src extends T, dst super T
✅ Multiple bounds: <T extends A & B> — class first, then interfaces
✅ Recursive bounds: <T extends Comparable<T>> — T must be comparable to itself
✅ Type-safe heterogeneous container: Map<Class<?>, Object> with cast in get()
✅ Wildcard capture: use a generic helper method to work with List<?>
❌ Cannot add elements to List<? extends T> — you don't know what subtype it is
❌ Cannot read as T from List<? super T> — could be any supertype
❌ Due to erasure: cannot do instanceof List<String> — only instanceof List<?>
❌ Generic arrays forbidden: new T[10] won't compile — use List<T> instead
""",
  quiz: [
    Quiz(question: 'According to PECS, when should you use <? extends T>?', options: [
      QuizOption(text: 'When the collection is a producer — you read from it (e.g., summing numbers from a list)', correct: true),
      QuizOption(text: 'When the collection is a consumer — you add elements to it', correct: false),
      QuizOption(text: 'When you need both read and write access to the collection', correct: false),
      QuizOption(text: 'When T has multiple bounds that extend different superclasses', correct: false),
    ]),
    Quiz(question: 'Why can\'t you add elements to a List<? extends Number>?', options: [
      QuizOption(text: 'The compiler doesn\'t know the exact subtype — it could be List<Integer> or List<Double>, so adding any Number is unsafe', correct: true),
      QuizOption(text: 'Lists with extends bounds are immutable and reject all mutations', correct: false),
      QuizOption(text: 'The extends keyword makes the list read-only by convention', correct: false),
      QuizOption(text: 'You can add null only — all other additions throw UnsupportedOperationException', correct: false),
    ]),
    Quiz(question: 'What is the purpose of a recursive type bound like <T extends Comparable<T>>?', options: [
      QuizOption(text: 'It ensures T can be compared to itself — preventing comparison of incompatible types like comparing Strings to Integers', correct: true),
      QuizOption(text: 'It allows T to reference itself in recursive data structures like trees', correct: false),
      QuizOption(text: 'It creates a circular generic dependency that enables bidirectional conversion', correct: false),
      QuizOption(text: 'It restricts T to only primitive wrapper types which all implement Comparable', correct: false),
    ]),
  ],
);
