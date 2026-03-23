import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson12 = Lesson(
  language: 'Java',
  title: 'Constructors',
  content: """
🎯 METAPHOR:
A constructor is like the manufacturing settings on a
factory machine. When you press START (new), the machine
runs through its initialization steps — setting temperatures,
calibrating sensors, loading materials — before producing
the product. Without initialization, you'd get a half-baked,
unpredictable product. The constructor ensures every object
is properly set up from the moment it's born. Different
constructor models are like different factory configurations:
same machine, different settings for different products.

📖 EXPLANATION:
A constructor is a special method that runs automatically
when you create an object with new. It initializes the
object's state.

─────────────────────────────────────
CONSTRUCTOR RULES:
─────────────────────────────────────
  ✅ Same name as the class
  ✅ No return type (not even void)
  ✅ Called automatically by new
  ✅ Can be overloaded (multiple constructors)
  ✅ Can be public, private, protected, or package-private

─────────────────────────────────────
DEFAULT CONSTRUCTOR:
─────────────────────────────────────
  If you write NO constructor, Java provides a
  free no-arg constructor that does nothing:

  class Dog { }               // Java adds: Dog() { }
  Dog d = new Dog();          // works!

  If you write ANY constructor, the default is NOT provided:
  class Dog { Dog(String name) { } }
  Dog d = new Dog();          // ❌ ERROR — no no-arg constructor!

─────────────────────────────────────
CONSTRUCTOR OVERLOADING:
─────────────────────────────────────
  class Pizza {
      String size;
      String topping;
      boolean extraCheese;

      Pizza() { this("Medium", "Cheese"); }        // no-arg → delegates
      Pizza(String size) { this(size, "Cheese"); } // delegates
      Pizza(String size, String topping) {          // main constructor
          this.size = size;
          this.topping = topping;
          this.extraCheese = false;
      }
  }

─────────────────────────────────────
this() — CONSTRUCTOR DELEGATION:
─────────────────────────────────────
  this(args) calls another constructor IN THE SAME CLASS.
  Must be the FIRST statement in the constructor.
  Avoids code duplication — all initialization in one place.

─────────────────────────────────────
super() — CALLING PARENT CONSTRUCTOR:
─────────────────────────────────────
  class Animal { Animal(String name) { } }
  class Dog extends Animal {
      Dog(String name) {
          super(name);   // call Animal's constructor — MUST be first!
      }
  }

  If you don't call super() explicitly, Java automatically
  inserts super() — the no-arg parent constructor.
  If the parent has no no-arg constructor, you MUST call super().

─────────────────────────────────────
PRIVATE CONSTRUCTORS — Singleton pattern:
─────────────────────────────────────
  class Database {
      private static Database instance;
      private Database() { }   // private — only this class can instantiate

      public static Database getInstance() {
          if (instance == null) {
              instance = new Database();
          }
          return instance;
      }
  }

  Database db1 = Database.getInstance();  // always same object
  Database db2 = Database.getInstance();
  // db1 == db2 → true (same instance)

─────────────────────────────────────
RECORD CLASSES (Java 16+) — auto constructor:
─────────────────────────────────────
  record Point(double x, double y) { }
  // Java generates: constructor, getters, equals, hashCode, toString

  Point p = new Point(3.0, 4.0);
  System.out.println(p.x());     // getter auto-generated
  System.out.println(p);         // Point[x=3.0, y=4.0]

💻 CODE:
import java.util.Objects;

// Demonstrates all constructor patterns

class Vehicle {
    private String make;
    private String model;
    private int year;
    private String color;
    private double price;

    // ─── MAIN CONSTRUCTOR ────────────────────────────────
    public Vehicle(String make, String model, int year, String color, double price) {
        this.make  = make;
        this.model = model;
        this.year  = year;
        this.color = color;
        this.price = price;
    }

    // ─── OVERLOADED CONSTRUCTORS — delegate to main ───────
    public Vehicle(String make, String model, int year) {
        this(make, model, year, "White", 0.0);
    }

    public Vehicle(String make, String model) {
        this(make, model, 2024, "Black", 0.0);
    }

    public Vehicle() {
        this("Unknown", "Unknown", 2024, "Gray", 0.0);
    }

    public String getMake()   { return make;  }
    public String getModel()  { return model; }
    public int    getYear()   { return year;  }
    public String getColor()  { return color; }
    public double getPrice()  { return price; }

    @Override
    public String toString() {
        return String.format("%d %s %s (%s) — $%,.2f",
            year, make, model, color, price);
    }
}

// Subclass calls super()
class ElectricVehicle extends Vehicle {
    private int rangeKm;
    private String chargerType;

    public ElectricVehicle(String make, String model, int year,
                           String color, double price,
                           int rangeKm, String chargerType) {
        super(make, model, year, color, price);  // MUST be first
        this.rangeKm = rangeKm;
        this.chargerType = chargerType;
    }

    public ElectricVehicle(String make, String model, int rangeKm) {
        this(make, model, 2024, "White", 0.0, rangeKm, "Type 2");
    }

    @Override
    public String toString() {
        return super.toString() +
            String.format(" | Range: %dkm | Charger: %s", rangeKm, chargerType);
    }
}

// Singleton via private constructor
class AppSettings {
    private static AppSettings instance;
    private String theme = "Light";
    private int fontSize = 14;

    private AppSettings() {
        System.out.println("  AppSettings created (once)");
    }

    public static AppSettings getInstance() {
        if (instance == null) {
            instance = new AppSettings();
        }
        return instance;
    }

    public String getTheme()    { return theme; }
    public int    getFontSize() { return fontSize; }
    public void   setTheme(String t) { this.theme = t; }
}

// Record (Java 16+) — auto constructor
record Point(double x, double y) {
    // Compact canonical constructor with validation
    Point {
        if (Double.isNaN(x) || Double.isNaN(y))
            throw new IllegalArgumentException("Coordinates cannot be NaN");
    }

    // Custom method (records can have methods)
    public double distanceTo(Point other) {
        double dx = this.x - other.x;
        double dy = this.y - other.y;
        return Math.sqrt(dx * dx + dy * dy);
    }
}

public class Constructors {
    public static void main(String[] args) {

        // ─── CONSTRUCTOR OVERLOADING ──────────────────────
        System.out.println("=== Constructor Overloading ===");
        Vehicle v1 = new Vehicle("Tesla", "Model 3", 2023, "Red", 45000.0);
        Vehicle v2 = new Vehicle("Honda", "Civic", 2022);
        Vehicle v3 = new Vehicle("Toyota", "Camry");
        Vehicle v4 = new Vehicle();

        System.out.println("  " + v1);
        System.out.println("  " + v2);
        System.out.println("  " + v3);
        System.out.println("  " + v4);

        // ─── INHERITANCE + super() ────────────────────────
        System.out.println("\n=== super() constructor ===");
        ElectricVehicle ev1 = new ElectricVehicle(
            "Tesla", "Model S", 2024, "Pearl", 85000.0, 600, "CCS"
        );
        ElectricVehicle ev2 = new ElectricVehicle("NIO", "ET7", 500);
        System.out.println("  " + ev1);
        System.out.println("  " + ev2);

        // ─── SINGLETON ───────────────────────────────────
        System.out.println("\n=== Singleton Pattern ===");
        AppSettings s1 = AppSettings.getInstance();
        AppSettings s2 = AppSettings.getInstance();
        AppSettings s3 = AppSettings.getInstance();

        s1.setTheme("Dark");
        System.out.println("  s2 theme: " + s2.getTheme()); // Dark — same object!
        System.out.println("  s1 == s2: " + (s1 == s2));    // true

        // ─── RECORD ──────────────────────────────────────
        System.out.println("\n=== Record (Java 16+) ===");
        Point origin = new Point(0.0, 0.0);
        Point target = new Point(3.0, 4.0);
        System.out.println("  Origin: " + origin);   // Point[x=0.0, y=0.0]
        System.out.println("  Target: " + target);
        System.out.printf("  Distance: %.2f%n", origin.distanceTo(target)); // 5.0

        // Records have auto-generated equals
        Point p1 = new Point(1.0, 2.0);
        Point p2 = new Point(1.0, 2.0);
        System.out.println("  p1.equals(p2): " + p1.equals(p2)); // true

        // Validation in compact constructor
        try {
            new Point(Double.NaN, 0.0);
        } catch (IllegalArgumentException e) {
            System.out.println("  ❌ " + e.getMessage());
        }
    }
}

📝 KEY POINTS:
✅ A constructor has the same name as the class and no return type
✅ If no constructor is written, Java provides a free no-arg one
✅ Writing any constructor removes the default no-arg constructor
✅ this(args) delegates to another constructor — must be first statement
✅ super(args) calls the parent constructor — also must be first statement
✅ Private constructors prevent external instantiation (Singleton, factory)
✅ Records (Java 16+) auto-generate constructor, getters, equals, hashCode, toString
✅ Overloaded constructors should delegate to one "main" constructor
❌ You can't call both this() and super() — only one, and it must be first
❌ If the parent has no no-arg constructor, child MUST explicitly call super(args)
❌ Constructors are not inherited — each class needs its own
❌ Don't do heavy work in constructors — keep them for initialization only
""",
  quiz: [
    Quiz(question: 'What does Java provide if you write no constructor in a class?', options: [
      QuizOption(text: 'A default no-arg constructor that does nothing', correct: true),
      QuizOption(text: 'Nothing — the class cannot be instantiated', correct: false),
      QuizOption(text: 'A constructor that copies another instance of the same class', correct: false),
      QuizOption(text: 'A constructor matching the parent class\'s constructor', correct: false),
    ]),
    Quiz(question: 'What must be the first statement in a constructor that calls another constructor with this()?', options: [
      QuizOption(text: 'The this() call itself — it must appear before any other statements', correct: true),
      QuizOption(text: 'A null check on all parameters', correct: false),
      QuizOption(text: 'A call to super() to initialize the parent', correct: false),
      QuizOption(text: 'A field initialization statement', correct: false),
    ]),
    Quiz(question: 'What does a Java record automatically generate?', options: [
      QuizOption(text: 'A constructor, getters, equals(), hashCode(), and toString()', correct: true),
      QuizOption(text: 'Only getters and setters for each field', correct: false),
      QuizOption(text: 'A builder pattern and a copy() method', correct: false),
      QuizOption(text: 'Only equals() and hashCode() — toString() must be written manually', correct: false),
    ]),
  ],
);
