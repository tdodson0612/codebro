import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson22 = Lesson(
  language: 'Java',
  title: 'Generics',
  content: """
🎯 METAPHOR:
Generics are like a vending machine with typed slots.
A normal vending machine just takes your money and gives
SOMETHING — you might get a drink, a snack, or a toy.
No type safety. A generic vending machine has a TYPE LABEL
on it: "DRINK MACHINE<Soda>." Now you know exactly what
you're getting. You can't accidentally put a sandwich in
a soda machine. Generics put this type label on your
data structures and methods — a Box<Apple> only holds
apples. A List<String> only holds Strings. The compiler
enforces this at compile time, so you never get a
ClassCastException surprise at runtime.

📖 EXPLANATION:
Generics allow classes, interfaces, and methods to work
with any type while maintaining type safety at compile time.
Before generics (Java 1.4), collections stored Object,
requiring unsafe casts everywhere.

─────────────────────────────────────
WHY GENERICS EXIST:
─────────────────────────────────────
  // Without generics (pre-Java 5) — unsafe:
  List list = new ArrayList();
  list.add("hello");
  list.add(42);           // no type check!
  String s = (String) list.get(1);  // ❌ ClassCastException at runtime!

  // With generics — type-safe:
  List<String> list = new ArrayList<>();
  list.add("hello");
  // list.add(42);        // ❌ compile error — caught early!
  String s = list.get(0); // no cast needed ✅

─────────────────────────────────────
GENERIC CLASS:
─────────────────────────────────────
  class Box<T> {        // T = Type parameter
      private T content;

      public Box(T content) { this.content = content; }
      public T get() { return content; }
      public void set(T content) { this.content = content; }
      public boolean isEmpty() { return content == null; }
  }

  Box<String>  strBox = new Box<>("Hello");
  Box<Integer> intBox = new Box<>(42);
  Box<Double>  dblBox = new Box<>(3.14);

  String s = strBox.get();   // no cast needed
  int n = intBox.get();      // unboxing happens, no cast

─────────────────────────────────────
TYPE PARAMETER CONVENTIONS:
─────────────────────────────────────
  T   → Type (general purpose)
  E   → Element (collections)
  K   → Key (maps)
  V   → Value (maps)
  N   → Number
  R   → Return type
  S,U → Second/third type parameters

─────────────────────────────────────
GENERIC METHOD:
─────────────────────────────────────
  public static <T> T last(List<T> list) {
      return list.get(list.size() - 1);
  }

  public static <T extends Comparable<T>> T max(T a, T b) {
      return a.compareTo(b) >= 0 ? a : b;
  }

  last(List.of("a", "b", "c"))  → "c"
  max(10, 20)                    → 20
  max("apple", "mango")          → "mango"

─────────────────────────────────────
BOUNDED TYPE PARAMETERS:
─────────────────────────────────────
  <T extends Number>       → T must be Number or subclass
  <T extends Comparable<T>> → T must implement Comparable
  <T extends Animal & Flyable> → T must extend AND implement

─────────────────────────────────────
WILDCARDS:
─────────────────────────────────────
  ?                     → unknown type (any)
  ? extends Number      → upper bound — Number or subclass
  ? super Integer       → lower bound — Integer or superclass

  // upper bound — read from collection:
  void printAll(List<? extends Number> nums) {
      for (Number n : nums) System.out.println(n);
  }
  // accepts List<Integer>, List<Double>, List<Float>, etc.

  // lower bound — write to collection:
  void addIntegers(List<? super Integer> list) {
      list.add(1); list.add(2); list.add(3);
  }

─────────────────────────────────────
TYPE ERASURE:
─────────────────────────────────────
  Generics exist at compile time ONLY. At runtime,
  all type parameters are erased — List<String>
  and List<Integer> are both just List in bytecode.

  This means:
  → Cannot create generic arrays: new T[10]  ❌
  → Cannot use instanceof with generics: x instanceof List<String> ❌
  → Cannot create instances: new T() ❌

💻 CODE:
import java.util.*;
import java.util.function.Function;

// ─── GENERIC CLASS ────────────────────────────────────
class Pair<A, B> {
    private final A first;
    private final B second;

    public Pair(A first, B second) {
        this.first  = first;
        this.second = second;
    }

    public A getFirst()  { return first;  }
    public B getSecond() { return second; }

    public Pair<B, A> swap() { return new Pair<>(second, first); }

    @Override
    public String toString() { return "(" + first + ", " + second + ")"; }

    // Static factory method
    public static <A, B> Pair<A, B> of(A a, B b) { return new Pair<>(a, b); }
}

// ─── GENERIC STACK ────────────────────────────────────
class Stack<T> {
    private final List<T> elements = new ArrayList<>();

    public void push(T item) { elements.add(item); }

    public T pop() {
        if (isEmpty()) throw new EmptyStackException();
        return elements.remove(elements.size() - 1);
    }

    public T peek() {
        if (isEmpty()) throw new EmptyStackException();
        return elements.get(elements.size() - 1);
    }

    public boolean isEmpty() { return elements.isEmpty(); }
    public int size()        { return elements.size(); }

    @Override public String toString() { return "Stack" + elements; }
}

// ─── BOUNDED GENERIC ──────────────────────────────────
class Statistics<T extends Number> {
    private final List<T> values;

    public Statistics(List<T> values) {
        if (values.isEmpty()) throw new IllegalArgumentException("Empty list");
        this.values = new ArrayList<>(values);
    }

    public double sum() {
        return values.stream().mapToDouble(Number::doubleValue).sum();
    }

    public double average() { return sum() / values.size(); }

    public T min() {
        return values.stream()
            .min((a, b) -> Double.compare(a.doubleValue(), b.doubleValue()))
            .orElseThrow();
    }

    public T max() {
        return values.stream()
            .max((a, b) -> Double.compare(a.doubleValue(), b.doubleValue()))
            .orElseThrow();
    }

    public double standardDeviation() {
        double avg = average();
        double variance = values.stream()
            .mapToDouble(n -> Math.pow(n.doubleValue() - avg, 2))
            .average().orElse(0);
        return Math.sqrt(variance);
    }
}

// ─── GENERIC METHODS ──────────────────────────────────
public class Generics {

    // Generic method with bounded type
    public static <T extends Comparable<T>> T max(T a, T b) {
        return a.compareTo(b) >= 0 ? a : b;
    }

    public static <T extends Comparable<T>> T clamp(T value, T min, T max) {
        if (value.compareTo(min) < 0) return min;
        if (value.compareTo(max) > 0) return max;
        return value;
    }

    // Upper wildcard — can READ from
    public static double sumAll(List<? extends Number> numbers) {
        double total = 0;
        for (Number n : numbers) total += n.doubleValue();
        return total;
    }

    // Generic transform
    public static <T, R> List<R> transform(List<T> list, Function<T, R> mapper) {
        List<R> result = new ArrayList<>();
        for (T item : list) result.add(mapper.apply(item));
        return result;
    }

    // Generic filter
    public static <T> List<T> filter(List<T> list, java.util.function.Predicate<T> pred) {
        List<T> result = new ArrayList<>();
        for (T item : list) if (pred.test(item)) result.add(item);
        return result;
    }

    public static void main(String[] args) {

        // ─── PAIR ─────────────────────────────────────────
        System.out.println("=== Generic Pair ===");
        Pair<String, Integer> person = Pair.of("Terry", 30);
        Pair<String, String>  coords = Pair.of("40.7128°N", "74.0060°W");

        System.out.println("  Person: " + person);
        System.out.println("  Coords: " + coords);
        System.out.println("  Swapped: " + person.swap());

        List<Pair<String, Integer>> pairs = Arrays.asList(
            Pair.of("Alice", 28), Pair.of("Bob", 34), Pair.of("Carol", 22)
        );
        pairs.forEach(p ->
            System.out.printf("  %s is %d years old%n", p.getFirst(), p.getSecond()));

        // ─── GENERIC STACK ────────────────────────────────
        System.out.println("\n=== Generic Stack ===");
        Stack<String> stringStack = new Stack<>();
        stringStack.push("first");
        stringStack.push("second");
        stringStack.push("third");
        System.out.println("  " + stringStack);
        System.out.println("  pop: " + stringStack.pop());
        System.out.println("  peek: " + stringStack.peek());
        System.out.println("  " + stringStack);

        Stack<Integer> intStack = new Stack<>();
        for (int i = 1; i <= 5; i++) intStack.push(i * i);
        System.out.print("  Pop all: ");
        while (!intStack.isEmpty()) System.out.print(intStack.pop() + " ");
        System.out.println();

        // ─── BOUNDED GENERIC (Statistics) ─────────────────
        System.out.println("\n=== Bounded Generic (Statistics) ===");
        Statistics<Integer> intStats = new Statistics<>(
            Arrays.asList(4, 7, 2, 9, 1, 5, 8, 3, 6));
        System.out.printf("  Sum: %.0f | Avg: %.2f | Min: %s | Max: %s | Std: %.2f%n",
            intStats.sum(), intStats.average(),
            intStats.min(), intStats.max(), intStats.standardDeviation());

        Statistics<Double> dblStats = new Statistics<>(
            Arrays.asList(3.14, 2.72, 1.62, 1.41, 2.30));
        System.out.printf("  Avg: %.4f | Std: %.4f%n",
            dblStats.average(), dblStats.standardDeviation());

        // ─── GENERIC METHODS ──────────────────────────────
        System.out.println("\n=== Generic Methods ===");
        System.out.println("  max(10, 20)         = " + max(10, 20));
        System.out.println("  max(\"apple\",\"mango\")= " + max("apple", "mango"));
        System.out.println("  clamp(150, 0, 100)  = " + clamp(150, 0, 100));
        System.out.println("  clamp(-5, 0, 100)   = " + clamp(-5, 0, 100));
        System.out.println("  clamp(50, 0, 100)   = " + clamp(50, 0, 100));

        // ─── WILDCARDS ────────────────────────────────────
        System.out.println("\n=== Wildcards ===");
        List<Integer> ints    = Arrays.asList(1, 2, 3, 4, 5);
        List<Double>  doubles = Arrays.asList(1.1, 2.2, 3.3);
        List<Long>    longs   = Arrays.asList(100L, 200L, 300L);

        // All accepted by List<? extends Number>:
        System.out.println("  Sum of ints:    " + sumAll(ints));
        System.out.println("  Sum of doubles: " + sumAll(doubles));
        System.out.println("  Sum of longs:   " + sumAll(longs));

        // ─── TRANSFORM & FILTER ───────────────────────────
        System.out.println("\n=== Generic transform & filter ===");
        List<String> names = Arrays.asList("Alice", "Bob", "Charlie", "Diana", "Eve");

        List<Integer> lengths = transform(names, String::length);
        System.out.println("  Lengths: " + lengths);

        List<String> longNames = filter(names, s -> s.length() > 4);
        System.out.println("  Long names: " + longNames);

        List<String> upperNames = transform(names, String::toUpperCase);
        System.out.println("  Uppercase: " + upperNames);
    }
}

📝 KEY POINTS:
✅ Generics provide compile-time type safety — no ClassCastException surprises
✅ Generic classes use <T>; generic methods declare <T> before the return type
✅ T extends Number constrains T to Number and its subclasses
✅ List<? extends Number> reads from it; List<? super Integer> writes to it
✅ Type parameters by convention: T (type), E (element), K/V (key/value)
✅ Type erasure means generics only exist at compile time — erased in bytecode
✅ Generic methods can infer types — no need to specify: max(10, 20) not max<Integer>(10, 20)
✅ Wildcards (?) allow flexible APIs that accept families of types
❌ Cannot create generic arrays: new T[n] — use List<T> instead
❌ Cannot use instanceof with parameterized types: list instanceof List<String> won't compile
❌ Primitives cannot be type parameters — use Integer, Double, not int, double
❌ Cannot call new T() — type parameter has no accessible constructor
""",
  quiz: [
    Quiz(question: 'What problem did generics solve that existed in pre-Java-5 collections?', options: [
      QuizOption(text: 'Collections stored Object, requiring unsafe casts that could fail at runtime with ClassCastException', correct: true),
      QuizOption(text: 'Collections could not store more than 100 elements without generics', correct: false),
      QuizOption(text: 'Collections could only be accessed by a single thread without generics', correct: false),
      QuizOption(text: 'Collections could not serialize their contents without type parameters', correct: false),
    ]),
    Quiz(question: 'What does List<? extends Number> mean in terms of what operations are allowed?', options: [
      QuizOption(text: 'You can READ from it as Number but cannot add elements to it', correct: true),
      QuizOption(text: 'You can add any Number subclass to it but cannot read individual elements', correct: false),
      QuizOption(text: 'The list can only contain exactly one type that is specified at runtime', correct: false),
      QuizOption(text: 'The list is read-only and no operations are allowed', correct: false),
    ]),
    Quiz(question: 'What is type erasure in Java generics?', options: [
      QuizOption(text: 'Generic type parameters are removed at compile time — at runtime List<String> is just List', correct: true),
      QuizOption(text: 'Assigning a generic to a non-generic variable removes the type information', correct: false),
      QuizOption(text: 'The JVM erases generic types to improve garbage collection performance', correct: false),
      QuizOption(text: 'Type erasure only applies to wildcards (?) not concrete type parameters', correct: false),
    ]),
  ],
);
