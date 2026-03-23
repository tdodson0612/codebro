import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson16 = Lesson(
  language: 'Java',
  title: 'Polymorphism',
  content: """
🎯 METAPHOR:
Polymorphism is like a universal remote control.
You press PLAY on the remote, and it plays — but WHAT it
plays depends on which device is connected: the TV plays
video, the stereo plays music, the Blu-ray player plays
a disc. Same button, same action name (play), completely
different behavior depending on the actual device.
In Java, you call speak() on an Animal reference, and it
does whatever THAT SPECIFIC ANIMAL does — a Dog barks,
a Cat meows, a Bird chirps. One interface. Many forms.
That's polymorphism — from Greek: "many shapes."

📖 EXPLANATION:
Polymorphism lets a single reference type be used for
different object types, with each type responding to the
same method call in its own way.

─────────────────────────────────────
TWO TYPES OF POLYMORPHISM:
─────────────────────────────────────
  1. COMPILE-TIME (static) — Method Overloading
     Same method name, different parameter types.
     Java picks the right one at compile time.

     add(int, int)      → picks int version
     add(double, double) → picks double version

  2. RUNTIME (dynamic) — Method Overriding
     Subclass overrides parent method.
     JVM picks the correct implementation at RUNTIME,
     based on the actual object type — not the reference type.

     Animal a = new Dog();
     a.speak();   // JVM calls Dog.speak() at RUNTIME

─────────────────────────────────────
DYNAMIC DISPATCH — how Java picks the method:
─────────────────────────────────────
  Animal[] animals = {new Dog(), new Cat(), new Bird()};
  for (Animal a : animals) {
      a.speak();   // each call goes to THAT object's speak()
  }

  The reference type (Animal) determines WHAT METHODS are
  available. The actual object type determines WHICH
  IMPLEMENTATION runs.

─────────────────────────────────────
POLYMORPHISM ENABLES:
─────────────────────────────────────
  → Treating a collection of different objects uniformly
  → Adding new types without changing existing code (Open/Closed)
  → Dependency injection — pass any subtype
  → Strategy, Template Method design patterns

─────────────────────────────────────
COVARIANT RETURN TYPE (Java 5+):
─────────────────────────────────────
  An overriding method can return a MORE SPECIFIC type:

  class Animal { Animal clone() { ... } }
  class Dog extends Animal {
      @Override Dog clone() { ... }  // more specific — OK!
  }

─────────────────────────────────────
VIRTUAL METHODS:
─────────────────────────────────────
  In Java, ALL non-static, non-private, non-final instance
  methods are "virtual" — they use dynamic dispatch by default.
  This is the opposite of C++ where you must opt in with 'virtual'.

─────────────────────────────────────
OPEN/CLOSED PRINCIPLE:
─────────────────────────────────────
  Polymorphism enables the Open/Closed Principle:
  Code should be OPEN for extension (add new types)
  but CLOSED for modification (don't change existing code).

  Adding a new Animal subclass → works automatically.
  No need to modify the loop that calls speak().

💻 CODE:
import java.util.ArrayList;
import java.util.List;

// ─── BASE CLASSES ─────────────────────────────────────
abstract class Shape {
    protected String name;
    protected String color;

    public Shape(String name, String color) {
        this.name  = name;
        this.color = color;
    }

    // Abstract — every Shape MUST implement these
    public abstract double area();
    public abstract double perimeter();

    // Non-abstract — shared behavior
    public void describe() {
        System.out.printf("  %-12s %-8s | Area: %8.3f | Perimeter: %8.3f%n",
            name, color, area(), perimeter());
    }

    // Covariant return — can return more specific type
    public Shape withColor(String newColor) {
        this.color = newColor;
        return this;
    }
}

// ─── CONCRETE SHAPES ──────────────────────────────────
class Circle extends Shape {
    private double radius;

    public Circle(double radius, String color) {
        super("Circle", color);
        this.radius = radius;
    }

    @Override public double area()      { return Math.PI * radius * radius; }
    @Override public double perimeter() { return 2 * Math.PI * radius; }

    // Covariant return — returns Circle, not Shape
    @Override public Circle withColor(String c) { super.withColor(c); return this; }
}

class Rectangle extends Shape {
    protected double width, height;

    public Rectangle(double width, double height, String color) {
        super("Rectangle", color);
        this.width = width; this.height = height;
    }

    @Override public double area()      { return width * height; }
    @Override public double perimeter() { return 2 * (width + height); }
}

class Square extends Rectangle {
    public Square(double side, String color) {
        super(side, side, color);
        this.name = "Square";   // override name
    }
    // Inherits area() and perimeter() — no need to override
}

class Triangle extends Shape {
    private double a, b, c;   // three sides

    public Triangle(double a, double b, double c, String color) {
        super("Triangle", color);
        this.a = a; this.b = b; this.c = c;
    }

    @Override public double perimeter() { return a + b + c; }
    @Override public double area() {
        double s = perimeter() / 2;   // Heron's formula
        return Math.sqrt(s * (s-a) * (s-b) * (s-c));
    }
}

// ─── PAYMENT SYSTEM — runtime polymorphism ────────────
interface PaymentProcessor {
    boolean process(double amount);
    String getProviderName();
}

class CreditCard implements PaymentProcessor {
    private String cardNumber;
    @Override
    public boolean process(double amount) {
        System.out.printf("    💳 Credit Card (****%s): $%.2f — Approved%n",
            cardNumber.substring(cardNumber.length() - 4), amount);
        return true;
    }
    public CreditCard(String num) { this.cardNumber = num; }
    @Override public String getProviderName() { return "Visa/MC"; }
}

class PayPal implements PaymentProcessor {
    private String email;
    @Override
    public boolean process(double amount) {
        System.out.printf("    🅿️  PayPal (%s): $%.2f — Processed%n", email, amount);
        return true;
    }
    public PayPal(String email) { this.email = email; }
    @Override public String getProviderName() { return "PayPal"; }
}

class Crypto implements PaymentProcessor {
    private String wallet;
    @Override
    public boolean process(double amount) {
        System.out.printf("    ₿  Crypto (%s...): $%.2f — Broadcasting%n",
            wallet.substring(0, 6), amount);
        return true;
    }
    public Crypto(String wallet) { this.wallet = wallet; }
    @Override public String getProviderName() { return "Bitcoin"; }
}

// Method that accepts ANY PaymentProcessor — open/closed
class Checkout {
    public void pay(PaymentProcessor processor, double amount) {
        System.out.printf("  Checkout via %s:%n", processor.getProviderName());
        boolean success = processor.process(amount);
        System.out.println("  Status: " + (success ? "✅ Success" : "❌ Failed"));
    }
}

public class Polymorphism {
    public static void main(String[] args) {

        // ─── SHAPE POLYMORPHISM ───────────────────────────
        System.out.println("=== Shape Polymorphism ===");
        List<Shape> shapes = new ArrayList<>();
        shapes.add(new Circle(5.0, "Red"));
        shapes.add(new Rectangle(4.0, 6.0, "Blue"));
        shapes.add(new Square(4.0, "Green"));
        shapes.add(new Triangle(3.0, 4.0, 5.0, "Purple"));
        shapes.add(new Circle(2.5, "Orange"));

        // One loop handles ALL shape types — true polymorphism
        for (Shape s : shapes) {
            s.describe();   // calls the right area()/perimeter() each time
        }

        // Aggregate with polymorphism
        double totalArea = shapes.stream()
            .mapToDouble(Shape::area)
            .sum();
        System.out.printf("%n  Total area: %.3f%n", totalArea);

        Shape largest = shapes.get(0);
        for (Shape s : shapes) {
            if (s.area() > largest.area()) largest = s;
        }
        System.out.println("  Largest: " + largest.name + " (area=" +
            String.format("%.3f", largest.area()) + ")");

        // ─── instanceof TYPE CHECK ────────────────────────
        System.out.println("\n=== instanceof dispatch ===");
        for (Shape s : shapes) {
            String extra = switch (s) {
                case Circle c   -> "radius data available";
                case Square sq  -> "square — width == height";
                case Rectangle r-> "rectangular area";
                default         -> "other shape";
            };
            System.out.printf("  %-10s → %s%n", s.name, extra);
        }

        // ─── PAYMENT POLYMORPHISM ─────────────────────────
        System.out.println("\n=== Payment Polymorphism ===");
        Checkout checkout = new Checkout();
        List<PaymentProcessor> processors = List.of(
            new CreditCard("1234567890123456"),
            new PayPal("terry@email.com"),
            new Crypto("1A2B3C4D5E6F7G8H9I")
        );

        double[] amounts = {29.99, 149.95, 999.00};
        for (int i = 0; i < processors.size(); i++) {
            checkout.pay(processors.get(i), amounts[i]);
        }

        // ─── COMPILE-TIME vs RUNTIME ──────────────────────
        System.out.println("\n=== Method Overloading (compile-time) ===");
        printType(42);
        printType(3.14);
        printType("hello");
        printType(true);
    }

    // Overloaded — compiler picks the right one at compile time
    static void printType(int x)    { System.out.println("  int:    " + x); }
    static void printType(double x) { System.out.println("  double: " + x); }
    static void printType(String x) { System.out.println("  String: " + x); }
    static void printType(boolean x){ System.out.println("  bool:   " + x); }
}

📝 KEY POINTS:
✅ Runtime polymorphism: the JVM calls the correct override based on the actual object
✅ Compile-time polymorphism: Java picks the correct overload at compile time
✅ The reference type determines WHAT methods are available
✅ The actual object type determines WHICH implementation runs
✅ All non-static, non-private, non-final instance methods use dynamic dispatch
✅ Polymorphism enables the Open/Closed Principle — add types without modifying existing code
✅ A List<Shape> can hold Circle, Rectangle, Triangle — process them uniformly
✅ Covariant return types allow overrides to return more specific types
❌ Static methods are NOT polymorphic — they bind at compile time, not runtime
❌ Private methods are NOT polymorphic — they're hidden, not overridable
❌ You cannot call subclass-specific methods through a parent reference without casting
❌ Method hiding (static methods in subclasses) is NOT the same as overriding
""",
  quiz: [
    Quiz(question: 'When you call a.speak() where a is declared as Animal but holds a Dog object, which speak() runs?', options: [
      QuizOption(text: 'Dog\'s speak() — the JVM uses the actual object type at runtime', correct: true),
      QuizOption(text: 'Animal\'s speak() — the reference type determines which method runs', correct: false),
      QuizOption(text: 'Both — super.speak() is called automatically before Dog\'s', correct: false),
      QuizOption(text: 'It depends on whether speak() is declared abstract in Animal', correct: false),
    ]),
    Quiz(question: 'What is the difference between method overloading and method overriding?', options: [
      QuizOption(text: 'Overloading is compile-time (same name, different params); overriding is runtime (subclass redefines parent\'s method)', correct: true),
      QuizOption(text: 'Overloading is for abstract classes; overriding is for interfaces', correct: false),
      QuizOption(text: 'They are the same concept — just different terminology', correct: false),
      QuizOption(text: 'Overriding changes the return type; overloading changes the method name', correct: false),
    ]),
    Quiz(question: 'Which types of methods use dynamic dispatch (runtime polymorphism) in Java?', options: [
      QuizOption(text: 'Non-static, non-private, non-final instance methods', correct: true),
      QuizOption(text: 'All methods including static and private', correct: false),
      QuizOption(text: 'Only methods declared in abstract classes', correct: false),
      QuizOption(text: 'Only methods annotated with @Override', correct: false),
    ]),
  ],
);
