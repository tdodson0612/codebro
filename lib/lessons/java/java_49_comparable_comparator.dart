import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson49 = Lesson(
  language: 'Java',
  title: 'Comparable, Comparator, and Sorting',
  content: """
🎯 METAPHOR:
Comparable is like a person who knows their place in line —
they carry their own ordering logic. "I'm taller than you,
so I go after you." Comparator is like a judge at a
competition who decides ordering based on a specific
criterion: "For this round, we rank by speed. For the
next round, we rank by accuracy." The person (object)
doesn't change — the ranking criterion does. Comparator
is the external judge. Comparable is the built-in preference.
Java sorting uses either: if an object knows its order
(Comparable), or if an external rule (Comparator) is provided.

📖 EXPLANATION:
Sorting in Java uses two mechanisms:
→ Comparable<T>: the class defines its "natural" ordering
→ Comparator<T>: an external object defines ordering for a purpose

─────────────────────────────────────
Comparable<T>:
─────────────────────────────────────
  Implement on the class itself to define NATURAL ordering.
  One method: compareTo(T other)

  Return value:
    negative → this comes BEFORE other
    zero     → this equals other (for ordering purposes)
    positive → this comes AFTER other

  class Student implements Comparable<Student> {
      private String name;
      private int grade;

      @Override
      public int compareTo(Student other) {
          return Integer.compare(this.grade, other.grade);
          // or: return this.grade - other.grade; (overflow risk!)
      }
  }

  // Now Collections.sort() and Arrays.sort() work automatically:
  Collections.sort(students);   // uses compareTo()
  students.sort(null);          // null = use natural ordering

─────────────────────────────────────
Comparator<T>:
─────────────────────────────────────
  External ordering — doesn't require changing the class.
  Use when you need multiple sort orders, or can't modify
  the class, or want to sort by different criteria.

  // Old style (anonymous class):
  Comparator<Student> byName = new Comparator<Student>() {
      @Override
      public int compare(Student a, Student b) {
          return a.name.compareTo(b.name);
      }
  };

  // Modern style (lambda):
  Comparator<Student> byName = (a, b) -> a.getName().compareTo(b.getName());

  // Method reference style:
  Comparator<Student> byName = Comparator.comparing(Student::getName);

─────────────────────────────────────
COMPARATOR COMPOSITION:
─────────────────────────────────────
  Comparator<Student> byGradeDesc = Comparator
      .comparingInt(Student::getGrade)
      .reversed();

  Comparator<Student> byGradeThenName = Comparator
      .comparingInt(Student::getGrade)
      .reversed()
      .thenComparing(Student::getName);

  Comparator<String> byLengthThenAlpha = Comparator
      .comparingInt(String::length)
      .thenComparing(Comparator.naturalOrder());

  // Null-safe comparator:
  Comparator<String> nullLast = Comparator.nullsLast(
      Comparator.naturalOrder());

─────────────────────────────────────
SORTING METHODS:
─────────────────────────────────────
  Arrays.sort(arr)                    // natural order
  Arrays.sort(arr, comparator)        // custom order
  Collections.sort(list)             // natural order
  Collections.sort(list, comparator) // custom order
  list.sort(comparator)              // List method (Java 8)
  list.sort(null)                    // natural order
  stream.sorted()                    // natural in stream
  stream.sorted(comparator)          // custom in stream

─────────────────────────────────────
COMPARABLE CONTRACT:
─────────────────────────────────────
  Consistent with equals (recommended):
  a.compareTo(b) == 0 → a.equals(b) should be true

  Must be:
  → Reflexive: a.compareTo(a) == 0
  → Antisymmetric: sgn(a.compareTo(b)) == -sgn(b.compareTo(a))
  → Transitive: if a < b and b < c then a < c

  BigDecimal violates consistency with equals:
  new BigDecimal("1.0").compareTo(new BigDecimal("1.00")) == 0
  new BigDecimal("1.0").equals(new BigDecimal("1.00")) == false

💻 CODE:
import java.util.*;
import java.util.stream.*;
import java.util.function.*;

// ─── COMPARABLE (natural ordering) ───────────────────
class Temperature implements Comparable<Temperature> {
    private final double celsius;
    private final String label;

    public Temperature(double celsius, String label) {
        this.celsius = celsius;
        this.label   = label;
    }

    public double getCelsius()    { return celsius; }
    public double getFahrenheit() { return celsius * 9.0/5.0 + 32; }
    public String getLabel()      { return label; }

    @Override
    public int compareTo(Temperature other) {
        // Natural order: coldest first
        return Double.compare(this.celsius, other.celsius);
    }

    @Override
    public boolean equals(Object o) {
        if (!(o instanceof Temperature t)) return false;
        return Double.compare(celsius, t.celsius) == 0;
    }

    @Override
    public int hashCode() { return Double.hashCode(celsius); }

    @Override
    public String toString() {
        return String.format("%s (%.1f°C / %.1f°F)", label, celsius, getFahrenheit());
    }
}

// ─── MULTI-FIELD COMPARABLE ───────────────────────────
record Person(String lastName, String firstName, int age)
        implements Comparable<Person> {

    @Override
    public int compareTo(Person other) {
        // Natural order: last name, then first name, then age
        int c = this.lastName.compareTo(other.lastName);
        if (c != 0) return c;
        c = this.firstName.compareTo(other.firstName);
        if (c != 0) return c;
        return Integer.compare(this.age, other.age);
    }

    @Override public String toString() {
        return String.format("%-10s %-10s %3d", lastName, firstName, age);
    }
}

// ─── RICH PRODUCT CLASS FOR COMPARATOR DEMO ──────────
record Product(String name, String category, double price, int stock, double rating) {
    @Override public String toString() {
        return String.format("%-15s %-10s\$%6.2f stock=%-4d ★%.1f",
            name, category, price, stock, rating);
    }
}

public class ComparableComparator {
    public static void main(String[] args) {

        // ─── COMPARABLE (natural ordering) ───────────────
        System.out.println("=== Comparable — Natural Ordering ===");
        List<Temperature> temps = new ArrayList<>(Arrays.asList(
            new Temperature(100, "Boiling"),
            new Temperature(-40, "Extreme cold"),
            new Temperature(37, "Body temp"),
            new Temperature(0, "Freezing"),
            new Temperature(20, "Room temp"),
            new Temperature(-273.15, "Absolute zero")
        ));

        System.out.println("  Unsorted:");
        temps.forEach(t -> System.out.println("    " + t));

        Collections.sort(temps);  // uses compareTo() — coldest first
        System.out.println("\n  Sorted (natural — coldest first):");
        temps.forEach(t -> System.out.println("    " + t));

        // Min/Max
        System.out.println("\n  Min: " + Collections.min(temps));
        System.out.println("  Max: " + Collections.max(temps));

        // ─── MULTI-FIELD COMPARABLE ───────────────────────
        System.out.println("\n=== Multi-field Comparable (Person) ===");
        List<Person> people = new ArrayList<>(Arrays.asList(
            new Person("Smith",   "Alice",   28),
            new Person("Smith",   "Bob",     34),
            new Person("Johnson", "Carol",   22),
            new Person("Smith",   "Alice",   32),  // same name, diff age
            new Person("Brown",   "Dave",    45),
            new Person("Johnson", "Anna",    29)
        ));

        Collections.sort(people);
        System.out.println("  Sorted (last, first, age):");
        people.forEach(p -> System.out.println("    " + p));

        // ─── COMPARATOR (flexible external ordering) ──────
        System.out.println("\n=== Comparator — Multiple Orders ===");
        List<Product> products = Arrays.asList(
            new Product("Laptop",    "Electronics", 999.99, 5,  4.7),
            new Product("Phone",     "Electronics", 699.99, 12, 4.5),
            new Product("Headphones","Electronics", 149.99, 0,  4.8),
            new Product("T-Shirt",   "Clothing",     29.99, 50, 4.2),
            new Product("Jeans",     "Clothing",     79.99, 20, 4.4),
            new Product("Jacket",    "Clothing",    199.99, 8,  4.6),
            new Product("Novel",     "Books",        14.99, 100,4.3),
            new Product("Textbook",  "Books",        89.99, 15, 3.9)
        );

        // Define multiple comparators
        Comparator<Product> byPrice        = Comparator.comparingDouble(Product::price);
        Comparator<Product> byPriceDesc    = byPrice.reversed();
        Comparator<Product> byRating       = Comparator.comparingDouble(Product::rating).reversed();
        Comparator<Product> byStock        = Comparator.comparingInt(Product::stock);
        Comparator<Product> byCategoryThenPrice = Comparator
            .comparing(Product::category)
            .thenComparing(byPrice);
        Comparator<Product> byValueScore   = Comparator
            .comparingDouble(p -> p.rating() / p.price() * 100);

        System.out.println("  By price (ascending):");
        products.stream().sorted(byPrice)
            .forEach(p -> System.out.println("    " + p));

        System.out.println("\n  By rating (descending):");
        products.stream().sorted(byRating)
            .forEach(p -> System.out.println("    " + p));

        System.out.println("\n  By category then price:");
        products.stream().sorted(byCategoryThenPrice)
            .forEach(p -> System.out.println("    " + p));

        System.out.println("\n  Best value (rating/price ratio):");
        products.stream()
            .sorted(byValueScore.reversed())
            .limit(3)
            .forEach(p -> System.out.printf("    %s  ratio=%.4f%n",
                p, p.rating() / p.price() * 100));

        // ─── NULL-SAFE COMPARATOR ─────────────────────────
        System.out.println("\n=== Null-safe Comparator ===");
        List<String> withNulls = Arrays.asList("banana", null, "apple", null, "cherry");

        Comparator<String> nullFirst = Comparator.nullsFirst(Comparator.naturalOrder());
        Comparator<String> nullLast  = Comparator.nullsLast(Comparator.naturalOrder());

        System.out.println("  Nulls first: " + withNulls.stream()
            .sorted(nullFirst).collect(Collectors.toList()));
        System.out.println("  Nulls last:  " + withNulls.stream()
            .sorted(nullLast).collect(Collectors.toList()));

        // ─── TreeSet and TreeMap with Comparator ──────────
        System.out.println("\n=== TreeSet/TreeMap with Comparator ===");

        // TreeSet sorted by length, then alphabetically
        TreeSet<String> byLength = new TreeSet<>(
            Comparator.comparingInt(String::length)
                      .thenComparing(Comparator.naturalOrder()));

        byLength.addAll(Arrays.asList(
            "banana", "apple", "fig", "cherry", "date", "kiwi", "mango"));
        System.out.println("  By length then alpha: " + byLength);

        // TreeMap sorted by value (requires wrapper)
        Map<String, Integer> scores = new HashMap<>();
        scores.put("Alice", 95); scores.put("Bob", 82);
        scores.put("Carol", 91); scores.put("Dave", 78);

        // Sort by value
        System.out.println("\n  Map entries sorted by value (desc):");
        scores.entrySet().stream()
            .sorted(Map.Entry.<String, Integer>comparingByValue().reversed())
            .forEach(e -> System.out.printf("    %-8s %d%n", e.getKey(), e.getValue()));

        // ─── COMPARING INTEGERS SAFELY ────────────────────
        System.out.println("\n=== Safe Integer Comparison ===");
        System.out.println("  Integer.compare(3, 5) = " + Integer.compare(3, 5));
        System.out.println("  Integer.compare(5, 5) = " + Integer.compare(5, 5));
        System.out.println("  Integer.compare(7, 5) = " + Integer.compare(7, 5));
        System.out.println("  Use Integer.compare() not a-b (overflow risk with MIN_VALUE)");
        System.out.println("  MIN_VALUE - 1 = " + (Integer.MIN_VALUE - 1) + " ← overflow!");
    }
}

📝 KEY POINTS:
✅ Comparable defines the NATURAL ordering of a class (one ordering)
✅ Comparator provides an EXTERNAL ordering (many possible orderings)
✅ Use Integer.compare(a, b) not a-b — subtraction can overflow with MIN_VALUE
✅ Comparator.comparing(fn).reversed().thenComparing(fn2) chains multi-field sorts
✅ Comparator.nullsFirst() / nullsLast() handles null elements safely
✅ TreeSet/TreeMap can take a Comparator to define their sort order
✅ Map.Entry.comparingByValue() sorts a map's entries by value
✅ stream.sorted() uses natural order; stream.sorted(comparator) uses custom
✅ Collections.min/max use Comparable; they can also take a Comparator
❌ Don't return a-b in compareTo — overflow with extreme values (use Integer.compare)
❌ Don't implement Comparable if you have no clear "natural" ordering — use Comparator
❌ BigDecimal's compareTo is inconsistent with equals (by design) — a known exception
❌ Comparator created with Comparator.comparing() doesn't handle null values — add nullsFirst()
""",
  quiz: [
    Quiz(question: 'What is the key difference between Comparable and Comparator?', options: [
      QuizOption(text: 'Comparable is implemented by the class to define its natural ordering; Comparator is an external object that defines a specific ordering', correct: true),
      QuizOption(text: 'Comparable works for primitives; Comparator works for objects', correct: false),
      QuizOption(text: 'Comparable is for ascending order; Comparator is for descending order', correct: false),
      QuizOption(text: 'Comparable is used by Collections.sort(); Comparator is used only by TreeSet and TreeMap', correct: false),
    ]),
    Quiz(question: 'Why should you use Integer.compare(a, b) instead of a - b in compareTo()?', options: [
      QuizOption(text: 'a - b can overflow with extreme values like Integer.MIN_VALUE, producing wrong results', correct: true),
      QuizOption(text: 'Integer.compare() is faster because it uses native CPU comparison instructions', correct: false),
      QuizOption(text: 'a - b only works for positive integers; Integer.compare() works for all ranges', correct: false),
      QuizOption(text: 'The compiler rejects arithmetic inside compareTo() as a safety measure', correct: false),
    ]),
    Quiz(question: 'How do you sort a List by multiple fields in Java?', options: [
      QuizOption(text: 'Use Comparator.comparing(fn1).thenComparing(fn2) to chain comparators', correct: true),
      QuizOption(text: 'Implement Comparable with multiple if statements checking each field', correct: false),
      QuizOption(text: 'Call Collections.sort() multiple times, once per field', correct: false),
      QuizOption(text: 'Use Arrays.sort() with a two-dimensional array of comparators', correct: false),
    ]),
  ],
);
