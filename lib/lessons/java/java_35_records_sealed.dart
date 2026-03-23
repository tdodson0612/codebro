import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson35 = Lesson(
  language: 'Java',
  title: 'Records and Sealed Classes (Java 16-17)',
  content: """
🎯 METAPHOR:
Records are like the data equivalent of Post-it notes.
A Post-it is designed for ONE purpose: hold a message.
It doesn't need to be encrypted, thread-safe, or extensible.
It just needs to hold its content, let you read it, compare
it to other notes, and show what it says. Java records are
Post-it notes for your data: they declare their fields,
and Java writes equals(), hashCode(), toString(), and
accessor methods automatically. What used to take 50 lines
now takes 1.

Sealed classes are like a controlled vocabulary.
A sealed Shape can only be Circle, Rectangle, or Triangle —
no wildcards, no surprises. Every time you switch on a
Shape, you KNOW what options exist. The compiler holds you
to it. It's the enum concept generalized to class hierarchies.

📖 EXPLANATION:

─────────────────────────────────────
RECORDS (Java 16):
─────────────────────────────────────
  // Traditional data class (50+ lines in Java):
  public class Point {
      private final double x, y;
      public Point(double x, double y) { this.x=x; this.y=y; }
      public double x() { return x; }
      public double y() { return y; }
      @Override public boolean equals(Object o) { ... }
      @Override public int hashCode() { ... }
      @Override public String toString() { ... }
  }

  // Record (1 line!):
  record Point(double x, double y) { }

  Auto-generated from record header:
  → Canonical constructor (all components as params)
  → Accessor methods matching component names: x(), y()
  → equals() based on all components
  → hashCode() based on all components
  → toString(): "Point[x=3.0, y=4.0]"

─────────────────────────────────────
RECORDS — additional features:
─────────────────────────────────────
  // Compact canonical constructor (validation):
  record Range(int min, int max) {
      Range {   // compact constructor — no params!
          if (min > max) throw new IllegalArgumentException(
              "min > max: " + min + " > " + max);
      }
  }

  // Custom constructor:
  record Circle(double radius) {
      Circle(double radius) {    // standard constructor
          if (radius < 0) throw new IllegalArgumentException();
          this.radius = radius;
      }
  }

  // Additional methods:
  record Point(double x, double y) {
      double distanceTo(Point other) {
          double dx = this.x - other.x;
          double dy = this.y - other.y;
          return Math.sqrt(dx*dx + dy*dy);
      }

      // Static factory:
      static Point origin() { return new Point(0, 0); }
  }

  // Implementing interfaces:
  record Name(String first, String last) implements Comparable<Name> {
      @Override public int compareTo(Name other) {
          int c = this.last.compareTo(other.last);
          return c != 0 ? c : this.first.compareTo(other.first);
      }
  }

  // Records are:
  ✅ Implicitly final (cannot be extended)
  ✅ Implicitly has all-args constructor
  ✅ Components are private final fields
  ❌ Cannot extend another class (records extend java.lang.Record)
  ❌ Cannot add mutable instance fields

─────────────────────────────────────
SEALED CLASSES (Java 17):
─────────────────────────────────────
  A sealed class restricts which classes can extend it.
  Declared with 'sealed' and 'permits'.

  sealed interface Shape permits Circle, Rectangle, Triangle { }

  final class Circle    implements Shape { ... }
  final class Rectangle implements Shape { ... }
  final class Triangle  implements Shape { ... }
  // No other class can implement Shape!

  // Subclasses must be:
  final    → no further extension
  sealed   → further restricted extension
  non-sealed → open to anyone (opt-out of sealing)

─────────────────────────────────────
SEALED + switch = exhaustive:
─────────────────────────────────────
  double area(Shape shape) {
      return switch (shape) {
          case Circle c    -> Math.PI * c.radius() * c.radius();
          case Rectangle r -> r.width() * r.height();
          case Triangle t  -> t.base() * t.height() / 2;
          // No default needed — compiler knows all cases!
      };
  }

─────────────────────────────────────
GUARDED PATTERNS (Java 21):
─────────────────────────────────────
  String describe(Shape s) {
      return switch (s) {
          case Circle c when c.radius() > 10  -> "Large circle";
          case Circle c                        -> "Small circle";
          case Rectangle r when r.width() == r.height() -> "Square";
          case Rectangle r                     -> "Rectangle";
          default                              -> "Other";
      };
  }

💻 CODE:
import java.util.*;
import java.util.stream.*;

// ─── RECORDS ──────────────────────────────────────────
record Point(double x, double y) {
    // Compact canonical constructor with validation
    Point {
        if (Double.isNaN(x) || Double.isNaN(y))
            throw new IllegalArgumentException("NaN coordinates");
    }

    // Custom methods on records
    double distanceTo(Point other) {
        return Math.sqrt(Math.pow(x - other.x, 2) + Math.pow(y - other.y, 2));
    }

    double magnitude() { return distanceTo(origin()); }

    Point translate(double dx, double dy) { return new Point(x + dx, y + dy); }

    // Static factory
    static Point origin() { return new Point(0, 0); }
    static Point of(double x, double y) { return new Point(x, y); }
}

record Employee(String id, String name, String dept, double salary) implements Comparable<Employee> {
    // Compact constructor with validation
    Employee {
        Objects.requireNonNull(id, "ID required");
        Objects.requireNonNull(name, "Name required");
        if (salary < 0) throw new IllegalArgumentException("Negative salary");
        name = name.strip();   // normalize in constructor
    }

    @Override
    public int compareTo(Employee other) {
        return this.name.compareTo(other.name);
    }

    // Computed property
    boolean isSenior() { return salary > 100_000; }

    // "Copy with change"
    Employee withSalary(double newSalary) {
        return new Employee(id, name, dept, newSalary);
    }
}

record Address(String street, String city, String country) {
    // Override toString for custom format
    @Override
    public String toString() {
        return street + ", " + city + ", " + country;
    }
}

// ─── SEALED CLASSES ───────────────────────────────────
sealed interface Shape permits Circle, Rect, Triangle, RegularPolygon { }

record Circle(double radius) implements Shape { }

record Rect(double width, double height) implements Shape { }

record Triangle(double base, double height, double hypotenuse) implements Shape { }

// Non-sealed — anyone can extend this
non-sealed class RegularPolygon implements Shape {
    protected final int sides;
    protected final double sideLength;

    public RegularPolygon(int sides, double sideLength) {
        this.sides = sides;
        this.sideLength = sideLength;
    }

    public int getSides() { return sides; }
    public double getSideLength() { return sideLength; }
}

// Sealed for result types
sealed interface Result<T> permits Result.Success, Result.Failure {
    record Success<T>(T value) implements Result<T> { }
    record Failure<T>(String error, int code) implements Result<T> { }
}

public class RecordsAndSealed {

    // Exhaustive switch on sealed type
    static double area(Shape shape) {
        return switch (shape) {
            case Circle c    -> Math.PI * c.radius() * c.radius();
            case Rect r      -> r.width() * r.height();
            case Triangle t  -> t.base() * t.height() / 2.0;
            case RegularPolygon p -> {
                double apothem = p.getSideLength() / (2 * Math.tan(Math.PI / p.getSides()));
                yield 0.5 * p.getSides() * p.getSideLength() * apothem;
            }
        };
    }

    static String describe(Shape shape) {
        return switch (shape) {
            case Circle c when c.radius() > 10  -> "Large circle (r=" + c.radius() + ")";
            case Circle c                        -> "Small circle (r=" + c.radius() + ")";
            case Rect r when r.width() == r.height() -> "Square (" + r.width() + "×" + r.height() + ")";
            case Rect r                          -> "Rectangle (" + r.width() + "×" + r.height() + ")";
            case Triangle t                      -> "Triangle (base=" + t.base() + ")";
            case RegularPolygon p                -> p.getSides() + "-sided polygon";
        };
    }

    static <T> void handleResult(Result<T> result) {
        switch (result) {
            case Result.Success<T> s -> System.out.println("  ✅ Success: " + s.value());
            case Result.Failure<T> f -> System.out.println("  ❌ Error " + f.code() + ": " + f.error());
        }
    }

    public static void main(String[] args) {

        // ─── RECORDS IN ACTION ────────────────────────────
        System.out.println("=== Records ===");
        Point p1 = new Point(3.0, 4.0);
        Point p2 = Point.of(6.0, 8.0);
        Point origin = Point.origin();

        System.out.println("  p1: " + p1);     // Point[x=3.0, y=4.0]
        System.out.println("  p2: " + p2);
        System.out.printf("  Distance p1→p2:     %.2f%n", p1.distanceTo(p2));
        System.out.printf("  Magnitude of p1:    %.2f%n", p1.magnitude());
        System.out.println("  Translated p1+2,+3: " + p1.translate(2, 3));

        // Record equality (value-based)
        Point p1copy = new Point(3.0, 4.0);
        System.out.println("  p1 == p1copy:        " + (p1 == p1copy));      // false
        System.out.println("  p1.equals(p1copy):   " + p1.equals(p1copy));   // true ✅

        // Records in collections
        System.out.println("\n  Employees:");
        List<Employee> employees = Arrays.asList(
            new Employee("E1", "  Alice  ", "Engineering", 95_000),
            new Employee("E2", "Bob",       "Marketing",   72_000),
            new Employee("E3", "Charlie",   "Engineering", 115_000),
            new Employee("E4", "Diana",     "HR",          65_000)
        );

        employees.stream()
            .sorted()
            .forEach(e -> System.out.printf("    %-10s %-12s\$%,.0f %s%n",
                e.name(), e.dept(), e.salary(), e.isSenior() ? "⭐" : ""));

        // "Copy with modification"
        Employee promoted = employees.get(1).withSalary(85_000);
        System.out.println("  Promoted: " + promoted);

        // Grouping records
        Map<String, Double> avgByDept = employees.stream()
            .collect(java.util.stream.Collectors.groupingBy(
                Employee::dept,
                java.util.stream.Collectors.averagingDouble(Employee::salary)));
        System.out.println("  Avg by dept: " + new TreeMap<>(avgByDept));

        // ─── SEALED CLASSES ───────────────────────────────
        System.out.println("\n=== Sealed Classes ===");
        List<Shape> shapes = Arrays.asList(
            new Circle(5.0),
            new Circle(15.0),
            new Rect(4.0, 6.0),
            new Rect(5.0, 5.0),
            new Triangle(3.0, 4.0, 5.0),
            new RegularPolygon(6, 4.0)
        );

        for (Shape shape : shapes) {
            System.out.printf("  %-45s area=%.2f%n",
                describe(shape), area(shape));
        }

        // Total area — works because all Shape types are covered
        double total = shapes.stream().mapToDouble(RecordsAndSealed::area).sum();
        System.out.printf("  Total area: %.2f%n", total);

        // ─── RESULT TYPE ──────────────────────────────────
        System.out.println("\n=== Sealed Result Type ===");
        List<Result<String>> results = Arrays.asList(
            new Result.Success<>("User data loaded"),
            new Result.Failure<>("Database timeout", 503),
            new Result.Success<>("Cache hit"),
            new Result.Failure<>("Not authorized", 401)
        );
        results.forEach(RecordsAndSealed::handleResult);
    }
}

📝 KEY POINTS:
✅ Records auto-generate constructor, accessors (x() not getX()), equals, hashCode, toString
✅ Compact canonical constructor { } validates/normalizes without parameter list
✅ Records are implicitly final — they cannot be subclassed
✅ Records can implement interfaces and have static/instance methods
✅ Use withX() pattern for "copy with changes" on records
✅ Sealed classes restrict which classes can implement/extend them
✅ Subclasses of sealed types must be final, sealed, or non-sealed
✅ switch on sealed types is exhaustive — no default needed
✅ Guarded patterns (case X x when condition ->) add conditions to type patterns
❌ Records cannot have mutable instance fields beyond the header
❌ Records cannot extend another class (they implicitly extend Record)
❌ Sealed class permits list must match the actual subclasses exactly
❌ non-sealed breaks the sealing — anyone can extend that subclass
""",
  quiz: [
    Quiz(question: 'What does Java automatically generate for a record?', options: [
      QuizOption(text: 'A canonical constructor, component accessors, equals(), hashCode(), and toString()', correct: true),
      QuizOption(text: 'Getters, setters, a builder, and a copy() method', correct: false),
      QuizOption(text: 'Only equals() and hashCode() — toString() must be written manually', correct: false),
      QuizOption(text: 'A serialization proxy and all abstract methods from implemented interfaces', correct: false),
    ]),
    Quiz(question: 'What must all direct subclasses of a sealed class be?', options: [
      QuizOption(text: 'final, sealed, or non-sealed — and must appear in the permits list', correct: true),
      QuizOption(text: 'abstract or final — sealed classes cannot have concrete subclasses', correct: false),
      QuizOption(text: 'public — sealed class subclasses cannot have restricted visibility', correct: false),
      QuizOption(text: 'They must extend Object directly — multi-level hierarchies are not allowed', correct: false),
    ]),
    Quiz(question: 'How do accessor methods work in Java records?', options: [
      QuizOption(text: 'They match the component name: record Point(double x) gives x() not getX()', correct: true),
      QuizOption(text: 'They follow JavaBeans convention: getX() and setX()', correct: false),
      QuizOption(text: 'Accessors are public static methods on the record class', correct: false),
      QuizOption(text: 'There are no accessor methods — fields are public in records', correct: false),
    ]),
  ],
);
