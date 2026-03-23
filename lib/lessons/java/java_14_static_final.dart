import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson14 = Lesson(
  language: 'Java',
  title: 'static and final Keywords',
  content: """
🎯 METAPHOR:
static is like the company logo on the front of a building.
Every office (object) inside the building is different, but
they all share the SAME logo — it belongs to the BUILDING
(the class), not any individual office. Change the logo and
ALL offices see the new logo. final is like a locked safe
— once you put something in and close it, no one can change
it. final on a variable means it's written in ink, not
pencil. final on a method means "no subclass can rewrite
this." final on a class means "this design is finished —
no building on top of it allowed."

📖 EXPLANATION:

─────────────────────────────────────
static — belongs to the CLASS:
─────────────────────────────────────
  Normal fields/methods belong to INSTANCES (objects).
  static fields/methods belong to the CLASS itself.

  static FIELDS:
  → One copy shared by ALL instances
  → Accessed via ClassName.field
  → Initialized when the class is first loaded

  static METHODS:
  → Can be called without creating an object
  → Cannot access instance fields (no 'this')
  → Math.sqrt(), Integer.parseInt() are static

  static BLOCKS:
  → Code that runs ONCE when the class is loaded
  → Used for complex static initialization

─────────────────────────────────────
final — cannot be changed:
─────────────────────────────────────
  final VARIABLES:
  → Must be assigned exactly ONCE
  → Can be assigned in constructor (for fields)
  → Once set, the reference cannot change
  → The OBJECT may still be mutable!

  final int MAX = 100;
  MAX = 200;    // ❌ compile error

  final List<String> list = new ArrayList<>();
  list.add("item");  // ✅ OK — list contents change
  list = new ArrayList<>();  // ❌ cannot reassign reference

  final METHODS:
  → Cannot be overridden by subclasses
  → Useful for security-critical logic

  final CLASSES:
  → Cannot be subclassed (no extends)
  → String, Integer, Math are all final

─────────────────────────────────────
CONSTANTS: static final:
─────────────────────────────────────
  public static final double PI = 3.14159265358979;
  public static final int MAX_SIZE = 1000;
  public static final String APP_NAME = "CodeBro";

  Naming convention: UPPER_SNAKE_CASE
  These are true compile-time constants.

─────────────────────────────────────
STATIC NESTED CLASS:
─────────────────────────────────────
  class Outer {
      static class Inner { }   // no Outer instance needed
      class NotStatic { }      // requires Outer instance
  }

  Outer.Inner inner = new Outer.Inner();     // static — no Outer
  Outer.NotStatic ns = new Outer().new NotStatic(); // needs Outer

─────────────────────────────────────
STATIC IMPORTS:
─────────────────────────────────────
  import static java.lang.Math.*;
  import static java.util.Collections.*;

  // Without static import:
  double x = Math.sqrt(Math.PI);
  Collections.sort(list);

  // With static import:
  double x = sqrt(PI);
  sort(list);

  Use sparingly — can reduce readability if overused.

💻 CODE:
import java.util.ArrayList;
import java.util.List;
import static java.lang.Math.*;

// ─── STATIC MEMBERS ───────────────────────────────────
class MathHelper {

    // Constants — static final
    public static final double TAX_RATE = 0.15;
    public static final int MAX_RETRIES = 3;
    public static final String VERSION = "1.0.0";

    // Static field — shared count
    private static int calculationCount = 0;

    // Static block — runs once when class is loaded
    static {
        System.out.println("  MathHelper class loaded (static block ran)");
    }

    // Static utility methods — called without an instance
    public static double circleArea(double radius) {
        calculationCount++;
        return PI * radius * radius;  // static import of Math.PI
    }

    public static double hypotenuse(double a, double b) {
        calculationCount++;
        return sqrt(a * a + b * b);  // static import of Math.sqrt
    }

    public static double applyTax(double amount) {
        calculationCount++;
        return amount * (1 + TAX_RATE);
    }

    public static int getCalculationCount() {
        return calculationCount;
    }

    // Cannot be subclassed — prevent modification
    public static final String getVersion() {
        return VERSION;
    }
}

// ─── INSTANCE COUNT WITH STATIC FIELD ─────────────────
class Product {
    private static int nextId = 1;         // shared counter
    private static int totalProducts = 0;  // shared count

    private final int id;          // final — set in constructor, never changes
    private final String name;     // final — immutable
    private double price;          // NOT final — price can change

    public Product(String name, double price) {
        this.id    = nextId++;
        this.name  = name;
        this.price = price;
        totalProducts++;
    }

    public int    getId()    { return id;    }
    public String getName()  { return name;  }
    public double getPrice() { return price; }
    public void   setPrice(double price) {
        if (price < 0) throw new IllegalArgumentException("Negative price");
        this.price = price;
    }

    public static int getTotalProducts() { return totalProducts; }

    @Override
    public String toString() {
        return String.format("[%d] %-15s $%.2f", id, name, price);
    }
}

// ─── final CLASS — cannot be subclassed ───────────────
final class Coordinate {
    private final double latitude;
    private final double longitude;

    public Coordinate(double lat, double lon) {
        if (lat < -90 || lat > 90)   throw new IllegalArgumentException("Invalid latitude");
        if (lon < -180 || lon > 180) throw new IllegalArgumentException("Invalid longitude");
        this.latitude  = lat;
        this.longitude = lon;
    }

    public double getLatitude()  { return latitude;  }
    public double getLongitude() { return longitude; }

    public double distanceTo(Coordinate other) {
        // Simplified — not actual haversine
        double dlat = this.latitude  - other.latitude;
        double dlon = this.longitude - other.longitude;
        return sqrt(dlat * dlat + dlon * dlon) * 111;  // ~km
    }

    @Override
    public String toString() {
        return String.format("(%.4f°, %.4f°)", latitude, longitude);
    }
}

// ─── FINAL METHOD — cannot be overridden ──────────────
class Template {
    // Template method — defines the algorithm structure
    public final void execute() {    // final — subclasses can't change the flow
        System.out.println("  [Template] Starting...");
        doWork();                    // hook — subclasses implement this
        System.out.println("  [Template] Done!");
    }

    protected void doWork() {
        System.out.println("  [Template] Default work");
    }
}

class ConcreteTask extends Template {
    @Override
    protected void doWork() {
        System.out.println("  [ConcreteTask] My custom work here!");
    }
    // Cannot override execute() — it's final
}

public class StaticAndFinal {
    public static void main(String[] args) {

        // ─── STATIC METHODS & CONSTANTS ───────────────────
        System.out.println("=== Static utility methods ===");
        // No instance needed — called on the class
        System.out.printf("  circleArea(5)   = %.4f%n", MathHelper.circleArea(5));
        System.out.printf("  hypotenuse(3,4) = %.4f%n", MathHelper.hypotenuse(3, 4));
        System.out.printf("  applyTax(100)   = %.2f%n", MathHelper.applyTax(100));
        System.out.println("  Calculations: " + MathHelper.getCalculationCount());
        System.out.println("  Tax rate: " + MathHelper.TAX_RATE);
        System.out.println("  Version: " + MathHelper.getVersion());

        // ─── SHARED STATIC FIELD ─────────────────────────
        System.out.println("\n=== Shared static field (instance count) ===");
        System.out.println("  Products before: " + Product.getTotalProducts());
        Product p1 = new Product("Keyboard", 79.99);
        Product p2 = new Product("Mouse", 29.99);
        Product p3 = new Product("Monitor", 299.99);
        System.out.println("  Products after:  " + Product.getTotalProducts());
        System.out.println("  " + p1);
        System.out.println("  " + p2);
        System.out.println("  " + p3);

        // final field — can't reassign id or name
        // p1.id = 99;   // ❌ compile error — id is final

        // Price CAN change — not final
        p1.setPrice(74.99);
        System.out.println("  Price updated: " + p1);

        // ─── final CLASS ──────────────────────────────────
        System.out.println("\n=== final class (Coordinate) ===");
        Coordinate london = new Coordinate(51.5074, -0.1278);
        Coordinate paris  = new Coordinate(48.8566, 2.3522);
        System.out.println("  London: " + london);
        System.out.println("  Paris:  " + paris);
        System.out.printf("  Distance: ~%.0f km%n", london.distanceTo(paris));

        // ─── final METHOD (Template Pattern) ──────────────
        System.out.println("\n=== final method (Template Pattern) ===");
        Template task = new ConcreteTask();
        task.execute();  // structure fixed, work customizable

        // ─── static final CONSTANTS ───────────────────────
        System.out.println("\n=== Constants ===");
        System.out.println("  PI       = " + PI);
        System.out.println("  E        = " + E);
        System.out.println("  TAX_RATE = " + MathHelper.TAX_RATE);
        System.out.println("  MAX_RETRY= " + MathHelper.MAX_RETRIES);
    }
}

📝 KEY POINTS:
✅ static belongs to the class — shared by all instances
✅ static methods cannot access instance fields (no 'this')
✅ Constants use static final with UPPER_SNAKE_CASE naming
✅ final variable: assigned once — reference cannot change
✅ final method: cannot be overridden by subclasses
✅ final class: cannot be subclassed (String, Integer, Math)
✅ Static blocks run once when the class is first loaded
✅ Static imports let you use static members without the class name prefix
❌ final on an object reference doesn't make the object immutable
❌ static methods can't use 'this' — they have no instance context
❌ Static fields are shared — be careful with mutation in multi-threaded code
❌ UPPER_SNAKE_CASE is for constants only — regular variables use camelCase
""",
  quiz: [
    Quiz(question: 'What does a static field in a Java class represent?', options: [
      QuizOption(text: 'A single shared value belonging to the class, not any individual object', correct: true),
      QuizOption(text: 'A field that cannot be modified after the class is loaded', correct: false),
      QuizOption(text: 'A field visible only within the same package', correct: false),
      QuizOption(text: 'A field automatically initialized to zero', correct: false),
    ]),
    Quiz(question: 'If a variable is declared final and holds an ArrayList reference, what is still allowed?', options: [
      QuizOption(text: 'Adding or removing elements from the ArrayList — only reassigning the reference is forbidden', correct: true),
      QuizOption(text: 'Nothing — final makes the object and all its contents immutable', correct: false),
      QuizOption(text: 'Reassigning the variable to a new ArrayList', correct: false),
      QuizOption(text: 'Reading the list but not modifying it', correct: false),
    ]),
    Quiz(question: 'What is the naming convention for static final constants in Java?', options: [
      QuizOption(text: 'UPPER_SNAKE_CASE — for example: MAX_SIZE, TAX_RATE', correct: true),
      QuizOption(text: 'camelCase — same as regular variables', correct: false),
      QuizOption(text: 'PascalCase — like class names', correct: false),
      QuizOption(text: 'lowercase with underscores — like Python constants', correct: false),
    ]),
  ],
);
