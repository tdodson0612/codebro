import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson27 = Lesson(
  language: 'Java',
  title: 'Streams API',
  content: """
🎯 METAPHOR:
The Streams API is like a factory assembly line for data.
Raw materials (your collection) enter one end. Each station
(intermediate operation) does ONE thing: filter out defects,
reshape parts, sort them. The final station (terminal
operation) packages everything up and delivers the result.
The line doesn't START moving until you flip the switch
at the end (terminal operation) — that's LAZINESS.
Intermediate stations set up the pipeline. The terminal
station triggers everything. And the assembly line is
ONE-USE — once it runs, you need a new line for the next job.

📖 EXPLANATION:
Streams (java.util.stream) provide a declarative way to
process sequences of data. Introduced in Java 8.

─────────────────────────────────────
CREATING STREAMS:
─────────────────────────────────────
  collection.stream()          // from any Collection
  collection.parallelStream()  // parallel processing
  Arrays.stream(array)         // from array
  Stream.of(a, b, c)           // from values
  Stream.empty()               // empty stream
  Stream.generate(Supplier)    // infinite: () -> Math.random()
  Stream.iterate(seed, fn)     // infinite: 0, f(0), f(f(0))...
  IntStream.range(0, 10)       // 0 to 9
  IntStream.rangeClosed(1, 10) // 1 to 10

─────────────────────────────────────
INTERMEDIATE OPERATIONS (lazy):
─────────────────────────────────────
  filter(Predicate)        → keep matching elements
  map(Function)            → transform each element
  flatMap(Function)        → map then flatten
  mapToInt/Long/Double     → convert to primitive stream
  distinct()               → remove duplicates
  sorted()                 → sort natural order
  sorted(Comparator)       → sort with custom order
  peek(Consumer)           → debug: see each element
  limit(n)                 → take only first n
  skip(n)                  → skip first n elements
  takeWhile(Predicate)     → take while true (Java 9)
  dropWhile(Predicate)     → drop while true, then rest (Java 9)

─────────────────────────────────────
TERMINAL OPERATIONS (trigger processing):
─────────────────────────────────────
  collect(Collector)       → collect to collection/string/map
  forEach(Consumer)        → process each
  forEachOrdered           → ordered for parallel streams
  toList()                 → immutable List (Java 16+)
  toArray()                → Object[] or T[]
  reduce(identity, BinaryOp)→ fold to single value
  count()                  → count elements
  sum() / average()        → numeric streams
  min(Comparator)          → smallest element
  max(Comparator)          → largest element
  findFirst()              → first Optional<T>
  findAny()                → any Optional<T> (parallel-friendly)
  anyMatch(Predicate)      → true if any match
  allMatch(Predicate)      → true if all match
  noneMatch(Predicate)     → true if none match

─────────────────────────────────────
COLLECTORS (java.util.stream.Collectors):
─────────────────────────────────────
  toList()                        → List<T>
  toSet()                         → Set<T>
  toMap(keyFn, valueFn)           → Map<K, V>
  joining()                       → concatenate strings
  joining(", ", "[", "]")         → with delimiter and wrap
  groupingBy(classifier)          → Map<K, List<V>>
  groupingBy(cl, downstream)      → Map<K, R>
  partitioningBy(Predicate)       → Map<Boolean, List<T>>
  counting()                      → Long count
  summingInt(ToIntFunction)       → sum
  averagingInt(ToIntFunction)     → average
  summarizingInt(ToIntFunction)   → IntSummaryStatistics
  toUnmodifiableList()            → immutable

─────────────────────────────────────
PRIMITIVE STREAMS:
─────────────────────────────────────
  IntStream, LongStream, DoubleStream avoid boxing.
  .sum(), .average(), .min(), .max(), .summaryStatistics()
  .boxed() converts back to Stream<Integer> etc.

─────────────────────────────────────
PARALLEL STREAMS:
─────────────────────────────────────
  collection.parallelStream()  // uses ForkJoinPool
  stream.parallel()            // convert existing stream

  Use for CPU-bound operations on large datasets.
  NOT suitable for: I/O, small collections, ordered tasks.

💻 CODE:
import java.util.*;
import java.util.stream.*;
import java.util.function.*;

record Employee(String name, String dept, double salary, int years, String city) { }

public class StreamsAPI {
    public static void main(String[] args) {

        List<Employee> employees = Arrays.asList(
            new Employee("Alice",   "Engineering", 95_000, 6, "NYC"),
            new Employee("Bob",     "Marketing",   72_000, 3, "LA"),
            new Employee("Charlie", "Engineering", 110_000, 8, "NYC"),
            new Employee("Diana",   "Marketing",   68_000, 2, "Chicago"),
            new Employee("Eve",     "Engineering",  88_000, 4, "NYC"),
            new Employee("Frank",   "HR",           62_000, 5, "LA"),
            new Employee("Grace",   "Engineering", 120_000, 10, "Chicago"),
            new Employee("Henry",   "Marketing",   78_000, 6, "NYC"),
            new Employee("Ivy",     "HR",           58_000, 1, "LA"),
            new Employee("Jack",    "Engineering", 105_000, 7, "Chicago")
        );

        // ─── BASIC PIPELINE ───────────────────────────────
        System.out.println("=== Basic Pipeline ===");
        employees.stream()
            .filter(e -> e.dept().equals("Engineering"))
            .filter(e -> e.salary() > 90_000)
            .sorted(Comparator.comparingDouble(Employee::salary).reversed())
            .map(e -> String.format("  %-10s\$%,.0f (%dy)", e.name(), e.salary(), e.years()))
            .forEach(System.out::println);

        // ─── MAP / TRANSFORM ──────────────────────────────
        System.out.println("\n=== Map & Transform ===");
        List<String> namesCaps = employees.stream()
            .map(Employee::name)
            .map(String::toUpperCase)
            .sorted()
            .collect(Collectors.toList());
        System.out.println("  Names: " + namesCaps);

        // mapToDouble for numeric operations
        OptionalDouble avgSalary = employees.stream()
            .mapToDouble(Employee::salary)
            .average();
        System.out.printf("  Avg salary:\$%,.0f%n", avgSalary.orElse(0));

        // ─── COLLECTORS ───────────────────────────────────
        System.out.println("\n=== Collectors ===");

        // joining
        String names = employees.stream()
            .map(Employee::name)
            .sorted()
            .collect(Collectors.joining(", ", "[", "]"));
        System.out.println("  Names: " + names);

        // groupingBy
        Map<String, List<String>> byDept = employees.stream()
            .collect(Collectors.groupingBy(Employee::dept,
                     Collectors.mapping(Employee::name, Collectors.toList())));
        System.out.println("  By department:");
        new TreeMap<>(byDept).forEach((dept, ns) ->
            System.out.printf("    %-15s %s%n", dept, ns));

        // groupingBy with downstream collector
        Map<String, Double> avgByDept = employees.stream()
            .collect(Collectors.groupingBy(Employee::dept,
                     Collectors.averagingDouble(Employee::salary)));
        System.out.println("  Avg salary by dept:");
        new TreeMap<>(avgByDept).forEach((dept, avg) ->
            System.out.printf("    %-15s\$%,.0f%n", dept, avg));

        // partitioningBy
        Map<Boolean, List<String>> seniorJunior = employees.stream()
            .collect(Collectors.partitioningBy(
                e -> e.years() >= 5,
                Collectors.mapping(Employee::name, Collectors.toList())
            ));
        System.out.println("  Senior (5+ years): " + seniorJunior.get(true));
        System.out.println("  Junior (<5 years): " + seniorJunior.get(false));

        // toMap
        Map<String, Double> salaryMap = employees.stream()
            .collect(Collectors.toMap(Employee::name, Employee::salary));
        System.out.printf("  Alice's salary:\$%,.0f%n", salaryMap.get("Alice"));

        // ─── REDUCE ───────────────────────────────────────
        System.out.println("\n=== Reduce ===");
        double totalPayroll = employees.stream()
            .mapToDouble(Employee::salary)
            .reduce(0, Double::sum);
        System.out.printf("  Total payroll:\$%,.0f%n", totalPayroll);

        Optional<Employee> highest = employees.stream()
            .reduce((a, b) -> a.salary() > b.salary() ? a : b);
        highest.ifPresent(e ->
            System.out.printf("  Highest paid: %s (\$%,.0f)%n", e.name(), e.salary()));

        // ─── STATISTICS ───────────────────────────────────
        System.out.println("\n=== Summary Statistics ===");
        IntSummaryStatistics yearsStats = employees.stream()
            .collect(Collectors.summarizingInt(Employee::years));
        System.out.println("  Years stats: " + yearsStats);

        DoubleSummaryStatistics salaryStats = employees.stream()
            .collect(Collectors.summarizingDouble(Employee::salary));
        System.out.printf("  Salary — min:\$%,.0f  max:\$%,.0f  avg:\$%,.0f%n",
            salaryStats.getMin(), salaryStats.getMax(), salaryStats.getAverage());

        // ─── FLAT MAP ─────────────────────────────────────
        System.out.println("\n=== flatMap ===");
        List<List<Integer>> nested = Arrays.asList(
            Arrays.asList(1, 2, 3),
            Arrays.asList(4, 5, 6),
            Arrays.asList(7, 8, 9)
        );
        List<Integer> flat = nested.stream()
            .flatMap(Collection::stream)
            .collect(Collectors.toList());
        System.out.println("  Flattened: " + flat);

        // flatMap on strings
        List<String> sentences = Arrays.asList("hello world", "java streams", "are great");
        List<String> words = sentences.stream()
            .flatMap(s -> Arrays.stream(s.split(" ")))
            .distinct()
            .sorted()
            .collect(Collectors.toList());
        System.out.println("  Unique words sorted: " + words);

        // ─── INFINITE STREAMS ─────────────────────────────
        System.out.println("\n=== Infinite Streams ===");
        List<Integer> fibList = Stream.iterate(new int[]{0, 1}, f -> new int[]{f[1], f[0]+f[1]})
            .limit(12)
            .map(f -> f[0])
            .collect(Collectors.toList());
        System.out.println("  Fibonacci(12): " + fibList);

        List<Integer> powersOf2 = Stream.iterate(1, n -> n * 2)
            .limit(10)
            .collect(Collectors.toList());
        System.out.println("  Powers of 2:   " + powersOf2);

        // ─── PRIMITIVE STREAMS ────────────────────────────
        System.out.println("\n=== Primitive IntStream ===");
        IntStream.rangeClosed(1, 5).forEach(n ->
            System.out.printf("  %d² = %d%n", n, n * n));

        int sum = IntStream.rangeClosed(1, 100).sum();
        System.out.println("  Sum 1..100: " + sum);

        // ─── anyMatch / allMatch / findFirst ──────────────
        System.out.println("\n=== Matching & Finding ===");
        boolean hasHighEarner = employees.stream()
            .anyMatch(e -> e.salary() > 115_000);
        System.out.println("  Any earner >\$115k: " + hasHighEarner);

        boolean allHaveExp = employees.stream()
            .allMatch(e -> e.years() >= 1);
        System.out.println("  All have 1+ years: " + allHaveExp);

        Optional<Employee> firstNYC = employees.stream()
            .filter(e -> e.city().equals("NYC"))
            .findFirst();
        firstNYC.ifPresent(e ->
            System.out.println("  First NYC employee: " + e.name()));
    }
}

📝 KEY POINTS:
✅ Streams are lazy — intermediate ops only execute when a terminal op runs
✅ Streams are single-use — collect() or forEach() exhausts the stream
✅ filter() keeps, map() transforms, flatMap() maps then flattens
✅ collect(Collectors.groupingBy()) is the workhorse for grouping data
✅ partitioningBy() splits into two groups: true and false
✅ IntStream/DoubleStream avoid boxing overhead for numeric operations
✅ reduce() folds a stream to a single value; has identity and no-identity versions
✅ anyMatch/allMatch/noneMatch are short-circuit — stop early when possible
❌ Don't reuse streams — they're one-time use; create a new stream each time
❌ Avoid stateful lambdas in streams — side effects cause unpredictable behavior
❌ Don't use parallel streams for small datasets — overhead > benefit
❌ peek() is for debugging only — don't use it for side effects in production
""",
  quiz: [
    Quiz(question: 'What triggers the actual execution of a Java Stream pipeline?', options: [
      QuizOption(text: 'A terminal operation such as collect(), forEach(), or count()', correct: true),
      QuizOption(text: 'The first intermediate operation in the pipeline', correct: false),
      QuizOption(text: 'Calling stream() on the source collection', correct: false),
      QuizOption(text: 'The JVM starts processing lazily after a 1ms delay', correct: false),
    ]),
    Quiz(question: 'What does Collectors.groupingBy(Employee::dept) produce?', options: [
      QuizOption(text: 'A Map<String, List<Employee>> where each key is a department and the value is the list of employees in it', correct: true),
      QuizOption(text: 'A sorted list of employees ordered by department name', correct: false),
      QuizOption(text: 'A Set of unique department names found in the stream', correct: false),
      QuizOption(text: 'A Map<String, Long> counting employees per department', correct: false),
    ]),
    Quiz(question: 'What does flatMap() do differently from map()?', options: [
      QuizOption(text: 'flatMap() maps each element to a stream and then merges all those streams into one — flattening nested structure', correct: true),
      QuizOption(text: 'flatMap() applies the mapping function in parallel for better performance', correct: false),
      QuizOption(text: 'flatMap() maps elements and filters out null results automatically', correct: false),
      QuizOption(text: 'flatMap() preserves the original collection type while map() always returns a list', correct: false),
    ]),
  ],
);
