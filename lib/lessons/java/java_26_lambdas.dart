import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson26 = Lesson(
  language: 'Java',
  title: 'Lambda Expressions',
  content: """
🎯 METAPHOR:
A lambda expression is like a sticky note with instructions.
Before lambdas, if you wanted to give someone instructions,
you had to write a whole formal letter (create an anonymous
class, implement an interface, override the method, write
the body). With a lambda, you just hand them a sticky note:
"Sort these by name" → (a, b) -> a.getName().compareTo(b.getName()).
Same instructions. One sticky note instead of five pages.
The instructions are inline — right where you need them —
not buried in a separate class file somewhere.

📖 EXPLANATION:
Lambdas (introduced in Java 8) are anonymous functions —
functions without a name that can be stored in variables,
passed as arguments, and returned from methods.
They enable functional programming patterns in Java.

─────────────────────────────────────
LAMBDA SYNTAX:
─────────────────────────────────────
  (parameters) -> expression
  (parameters) -> { statements; return value; }

  Examples:
  () -> System.out.println("Hello!")         // no params
  x -> x * x                                // one param (no parens needed)
  (x, y) -> x + y                           // two params
  (String s) -> s.toUpperCase()             // with explicit type
  (int a, int b) -> { return a + b; }       // block body with return
  (a, b) -> {                               // multi-line
      System.out.println("Computing...");
      return a + b;
  }

─────────────────────────────────────
FUNCTIONAL INTERFACE REQUIREMENT:
─────────────────────────────────────
  A lambda can be used anywhere a FUNCTIONAL INTERFACE
  is expected. A functional interface has exactly ONE
  abstract method (SAM — Single Abstract Method).

  @FunctionalInterface
  interface Greeter {
      String greet(String name);
  }

  Greeter formal = name -> "Good day, " + name;
  Greeter casual = name -> "Hey, " + name + "!";

  formal.greet("Terry")  → "Good day, Terry"
  casual.greet("Terry")  → "Hey, Terry!"

─────────────────────────────────────
BUILT-IN FUNCTIONAL INTERFACES (java.util.function):
─────────────────────────────────────
  Interface           Method         Input → Output
  ──────────────────────────────────────────────────
  Function<T,R>       R apply(T)     T → R
  Consumer<T>         void accept(T) T → void
  Supplier<T>         T get()        () → T
  Predicate<T>        boolean test(T) T → boolean
  BiFunction<T,U,R>   R apply(T,U)   T,U → R
  UnaryOperator<T>    T apply(T)     T → T
  BinaryOperator<T>   T apply(T,T)   T,T → T
  Runnable            void run()     () → void
  Callable<V>         V call()       () → V (throws)
  Comparator<T>       int compare(T,T) T,T → int

─────────────────────────────────────
METHOD REFERENCES — shorthand lambdas:
─────────────────────────────────────
  Type              Syntax                   Lambda equivalent
  ─────────────────────────────────────────────────────────────
  Static method     ClassName::method        x -> ClassName.method(x)
  Instance method   obj::method              () -> obj.method()
  Instance method   ClassName::method        (x) -> x.method()
  Constructor       ClassName::new           () -> new ClassName()

  Examples:
  list.forEach(System.out::println)         // instance on System.out
  list.stream().map(String::toUpperCase)    // instance on each string
  list.stream().filter(Objects::nonNull)    // static method
  stream.map(Person::new)                   // constructor

─────────────────────────────────────
VARIABLE CAPTURE:
─────────────────────────────────────
  Lambdas can capture variables from the enclosing scope,
  but only if those variables are EFFECTIVELY FINAL —
  never reassigned after initialization.

  String prefix = "Hello, ";          // effectively final
  Greeter g = name -> prefix + name;  // ✅ captured
  // prefix = "Hi"; // ❌ would break — prefix must be final

─────────────────────────────────────
FUNCTION COMPOSITION:
─────────────────────────────────────
  Function<String, String> trim   = String::trim;
  Function<String, String> upper  = String::toUpperCase;
  Function<String, String> exclaim = s -> s + "!";

  Function<String, String> process = trim
      .andThen(upper)
      .andThen(exclaim);

  process.apply("  hello  ")  → "HELLO!"

  Predicate<Integer> isPositive = n -> n > 0;
  Predicate<Integer> isEven     = n -> n % 2 == 0;
  Predicate<Integer> posEven    = isPositive.and(isEven);

💻 CODE:
import java.util.*;
import java.util.function.*;
import java.util.stream.*;

record Person(String name, int age, String city) { }

public class LambdaExpressions {

    // Method that accepts a functional interface
    static <T> List<T> filterList(List<T> list, Predicate<T> predicate) {
        return list.stream().filter(predicate).collect(Collectors.toList());
    }

    static <T, R> List<R> mapList(List<T> list, Function<T, R> mapper) {
        return list.stream().map(mapper).collect(Collectors.toList());
    }

    static void printWithLabel(String label, Object value) {
        System.out.printf("  %-25s %s%n", label + ":", value);
    }

    public static void main(String[] args) {

        // ─── BASIC LAMBDA SYNTAX ──────────────────────────
        System.out.println("=== Lambda Syntax ===");

        Runnable sayHello = () -> System.out.println("  Hello, World!");
        sayHello.run();

        Function<Integer, Integer> square = x -> x * x;
        Function<Integer, Integer> cube   = x -> x * x * x;
        printWithLabel("square(7)", square.apply(7));
        printWithLabel("cube(4)",   cube.apply(4));

        BiFunction<Integer, Integer, Integer> add = (a, b) -> a + b;
        BiFunction<String, Integer, String> repeat = (s, n) -> s.repeat(n);
        printWithLabel("add(10, 20)",          add.apply(10, 20));
        printWithLabel("repeat(\"ha\", 3)",    repeat.apply("ha", 3));

        // ─── PREDICATE ────────────────────────────────────
        System.out.println("\n=== Predicate ===");
        Predicate<String> isLong    = s -> s.length() > 5;
        Predicate<String> startsA   = s -> s.startsWith("A");
        Predicate<String> combined  = isLong.and(startsA);
        Predicate<String> either    = isLong.or(startsA);
        Predicate<String> notLong   = isLong.negate();

        List<String> words = Arrays.asList("Apple", "Ant", "Algorithm", "Bear", "Cat");
        printWithLabel("long words",       filterList(words, isLong));
        printWithLabel("starts with A",    filterList(words, startsA));
        printWithLabel("long AND starts A",filterList(words, combined));
        printWithLabel("long OR starts A", filterList(words, either));
        printWithLabel("NOT long",         filterList(words, notLong));

        // ─── CONSUMER ─────────────────────────────────────
        System.out.println("\n=== Consumer ===");
        Consumer<String> print     = s -> System.out.println("  → " + s);
        Consumer<String> upper     = s -> System.out.println("  → " + s.toUpperCase());
        Consumer<String> both      = print.andThen(upper);  // chain

        System.out.println("  Single consumer:");
        words.forEach(print);
        System.out.println("  Chained consumer (first 2):");
        words.stream().limit(2).forEach(both);

        // ─── SUPPLIER ─────────────────────────────────────
        System.out.println("\n=== Supplier ===");
        Supplier<List<String>> listFactory = ArrayList::new;     // constructor ref
        Supplier<Double>       random      = Math::random;
        Supplier<String>       greeting    = () -> "Hello @ " + System.currentTimeMillis();

        List<String> newList = listFactory.get();
        newList.add("created by supplier");
        printWithLabel("Supplier<List>",    newList);
        printWithLabel("Supplier<Double>",  String.format("%.4f", random.get()));
        printWithLabel("Supplier<String>",  greeting.get());

        // ─── METHOD REFERENCES ────────────────────────────
        System.out.println("\n=== Method References ===");
        List<String> names = Arrays.asList("alice", "BOB", "Charlie", "diana");

        // Static method reference
        List<String> upperNames = mapList(names, String::toUpperCase);
        printWithLabel("String::toUpperCase", upperNames);

        // Instance method reference (on each element)
        List<Integer> lengths = mapList(names, String::length);
        printWithLabel("String::length", lengths);

        // Static method as predicate
        List<String> nonNull = Arrays.asList("a", null, "b", null, "c");
        printWithLabel("non-null only", nonNull.stream()
            .filter(Objects::nonNull).collect(Collectors.toList()));

        // Constructor reference
        List<String> personNames = Arrays.asList("Alice", "Bob", "Charlie");
        // Supplier<Person> = Person::new (needs matching constructor)
        System.out.println("  Constructor ref: ArrayList::new creates " +
            (new ArrayList<String>()).getClass().getSimpleName());

        // ─── FUNCTION COMPOSITION ─────────────────────────
        System.out.println("\n=== Function Composition ===");
        Function<String, String> trim    = String::trim;
        Function<String, String> upper2  = String::toUpperCase;
        Function<String, String> exclaim = s -> s + "!";

        Function<String, String> pipeline = trim.andThen(upper2).andThen(exclaim);
        List<String> messy = Arrays.asList("  hello  ", "  world  ", " java  ");
        printWithLabel("andThen pipeline", mapList(messy, pipeline));

        // compose (reversed order — inner executes first)
        Function<Integer, Integer> times2 = x -> x * 2;
        Function<Integer, Integer> plus3  = x -> x + 3;
        Function<Integer, Integer> times2ThenPlus3 = plus3.compose(times2);
        printWithLabel("compose(times2, plus3)(5)", times2ThenPlus3.apply(5)); // (5*2)+3=13

        // ─── REAL-WORLD USAGE ─────────────────────────────
        System.out.println("\n=== Real-World Lambda Usage ===");
        List<Person> people = Arrays.asList(
            new Person("Alice", 28, "London"),
            new Person("Bob",   34, "Paris"),
            new Person("Carol", 22, "London"),
            new Person("Dave",  45, "Berlin"),
            new Person("Eve",   31, "Paris")
        );

        // Sort by age ascending
        people.sort(Comparator.comparingInt(Person::age));
        System.out.println("  Sorted by age:");
        people.forEach(p -> System.out.printf("    %-8s %3d  %s%n", p.name(), p.age(), p.city()));

        // Filter + map + sort
        List<String> londonUnder35 = people.stream()
            .filter(p -> p.city().equals("London") && p.age() < 35)
            .sorted(Comparator.comparing(Person::name))
            .map(p -> p.name() + " (" + p.age() + ")")
            .collect(Collectors.toList());
        printWithLabel("London, under 35", londonUnder35);

        // Group by city
        Map<String, Long> countByCity = people.stream()
            .collect(Collectors.groupingBy(Person::city, Collectors.counting()));
        printWithLabel("Count by city", new TreeMap<>(countByCity));
    }
}

📝 KEY POINTS:
✅ Lambdas are anonymous functions: (params) -> expression or { block }
✅ Lambdas work with functional interfaces — interfaces with one abstract method
✅ @FunctionalInterface annotation enforces the single-abstract-method rule
✅ Built-in: Function, Consumer, Supplier, Predicate, BiFunction, etc.
✅ Method references (::) are shorthand for simple lambdas
✅ Lambdas capture effectively final variables from enclosing scope
✅ Predicate.and(), .or(), .negate() compose predicates logically
✅ Function.andThen() chains: applies first function, then second
✅ Function.compose() reverses: applies argument function first
❌ Lambdas cannot mutate captured local variables — must be effectively final
❌ Don't use lambdas for complex multi-step logic — extract to named methods
❌ Lambda doesn't introduce new scope — 'this' still refers to enclosing class
❌ Overloaded methods with lambda params can cause ambiguity — be explicit
""",
  quiz: [
    Quiz(question: 'What is a functional interface in Java?', options: [
      QuizOption(text: 'An interface with exactly one abstract method — making it compatible with lambda expressions', correct: true),
      QuizOption(text: 'An interface that can only be used with the java.util.function package', correct: false),
      QuizOption(text: 'An interface implemented using functional programming syntax only', correct: false),
      QuizOption(text: 'An interface with no methods — used as a marker for lambda-compatible types', correct: false),
    ]),
    Quiz(question: 'What does String::toUpperCase mean as a method reference?', options: [
      QuizOption(text: 'A reference to the toUpperCase() instance method — equivalent to s -> s.toUpperCase()', correct: true),
      QuizOption(text: 'A static call to String.toUpperCase() with no arguments', correct: false),
      QuizOption(text: 'A constructor reference that creates a String in uppercase', correct: false),
      QuizOption(text: 'A reference to the String class that converts its field toUpperCase', correct: false),
    ]),
    Quiz(question: 'What restriction applies to variables captured by a lambda from the enclosing scope?', options: [
      QuizOption(text: 'They must be effectively final — never reassigned after the lambda is created', correct: true),
      QuizOption(text: 'They must be declared static', correct: false),
      QuizOption(text: 'They must be primitive types — objects cannot be captured', correct: false),
      QuizOption(text: 'They must be passed as parameters — local variables cannot be captured', correct: false),
    ]),
  ],
);
