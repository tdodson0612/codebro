import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson10 = Lesson(
  language: 'Java',
  title: 'OOP Concepts Overview',
  content: """
🎯 METAPHOR:
Object-Oriented Programming is like building with LEGO.
Each LEGO brick is an OBJECT — it has a shape (state/fields)
and connection points (behavior/methods). Bricks of the same
design come from the same MOLD (class). You can snap bricks
together (composition), make specialized bricks based on
a general design (inheritance), and use a brick without
knowing exactly what kind it is (polymorphism). Real cities
aren't built one brick at a time from raw plastic — they're
built from designed, reusable, specialized components.
OOP brings that engineering discipline to software.

📖 EXPLANATION:
OOP organizes code around OBJECTS rather than functions.
Java is built entirely on this model — everything lives
inside a class.

─────────────────────────────────────
THE 4 PILLARS OF OOP:
─────────────────────────────────────

1️⃣  ENCAPSULATION — hide internal details
   Bundle data (fields) and behavior (methods) together.
   Hide the internal state from the outside world.
   Expose only what's needed via public methods.

   class BankAccount {
       private double balance;        // hidden
       public void deposit(double n)  // controlled access
           { balance += n; }
       public double getBalance()     // read-only access
           { return balance; }
   }

2️⃣  INHERITANCE — reuse and extend
   A child class inherits fields and methods from a parent.
   The child can ADD new behavior and OVERRIDE existing.

   class Animal { void eat() { ... } }
   class Dog extends Animal {
       void bark() { ... }   // added
       @Override void eat()  // overridden
           { System.out.println("Dog eating"); }
   }

3️⃣  POLYMORPHISM — one interface, many forms
   The same method name behaves differently for different types.
   A Dog and a Cat are both Animals — both can eat() and speak()
   but they do it differently.

   Animal a = new Dog();   // Dog IS-A Animal ✅
   a.speak();              // calls Dog's speak(), not Animal's

4️⃣  ABSTRACTION — simplify complexity
   Show only what's necessary, hide the complexity.
   A car's gas pedal accelerates the car — you don't need to
   know the internal combustion cycle to drive.

   abstract class Shape {
       abstract double area();   // contract — no implementation
   }

─────────────────────────────────────
CLASS vs OBJECT:
─────────────────────────────────────
  Class  → blueprint (template, design)
  Object → instance (a specific thing built from the blueprint)

  Class: Car (blueprint for all cars)
  Objects: myRedCar, yourBlueCar, taxiYellowCar

  Car myCar = new Car("Tesla", "Red");  // create an object
  //  ↑ type   ↑ variable name   ↑ calls constructor

─────────────────────────────────────
IS-A vs HAS-A:
─────────────────────────────────────
  IS-A   → Inheritance: Dog IS-A Animal
  HAS-A  → Composition: Car HAS-A Engine

  Prefer HAS-A (composition) over IS-A (inheritance)
  when possible — composition is more flexible.

─────────────────────────────────────
JAVA's OOP RULES:
─────────────────────────────────────
  ✅ Single inheritance (one parent class only)
  ✅ Multiple interface implementation
  ✅ Everything is an object (except primitives)
  ✅ All classes implicitly extend Object
  ✅ Object has: equals(), hashCode(), toString()

💻 CODE:
// Demonstrates all 4 OOP pillars in one cohesive example

// ABSTRACTION — abstract contract
abstract class Shape {
    private String color;       // ENCAPSULATION — private field

    public Shape(String color) { this.color = color; }

    public String getColor() { return color; }  // controlled access

    // abstract — each shape MUST implement this
    public abstract double area();
    public abstract double perimeter();

    // Non-abstract — shared behavior
    public void describe() {
        System.out.printf("  %-10s %s | Area: %7.2f | Perimeter: %7.2f%n",
            getClass().getSimpleName(), color, area(), perimeter());
    }
}

// INHERITANCE — Circle IS-A Shape
class Circle extends Shape {
    private double radius;    // Circle's own field

    public Circle(String color, double radius) {
        super(color);         // call parent constructor
        this.radius = radius;
    }

    @Override public double area()      { return Math.PI * radius * radius; }
    @Override public double perimeter() { return 2 * Math.PI * radius; }
}

// INHERITANCE — Rectangle IS-A Shape
class Rectangle extends Shape {
    private double width, height;

    public Rectangle(String color, double width, double height) {
        super(color);
        this.width = width;
        this.height = height;
    }

    @Override public double area()      { return width * height; }
    @Override public double perimeter() { return 2 * (width + height); }
}

// HAS-A composition — Engine is a component
class Engine {
    private int horsepower;
    public Engine(int hp) { this.horsepower = hp; }
    public int getHorsepower() { return horsepower; }
    public void start() { System.out.println("  Engine starts: vroom! (" + horsepower + " HP)"); }
}

// Car HAS-A Engine (composition)
class Car {
    private String brand;
    private Engine engine;  // HAS-A relationship

    public Car(String brand, int hp) {
        this.brand = brand;
        this.engine = new Engine(hp);
    }

    public void drive() {
        engine.start();
        System.out.println("  " + brand + " is driving!");
    }
}

public class OOPConcepts {
    public static void main(String[] args) {

        System.out.println("=== POLYMORPHISM — one interface, many forms ===");
        Shape[] shapes = {
            new Circle("Red", 5),
            new Rectangle("Blue", 4, 6),
            new Circle("Green", 3),
            new Rectangle("Purple", 10, 2)
        };

        // Same method call, different behavior per type
        for (Shape s : shapes) {
            s.describe();   // calls Circle.area() or Rectangle.area()
        }

        // Totals using polymorphism
        double totalArea = 0;
        for (Shape s : shapes) totalArea += s.area();
        System.out.printf("%nTotal area of all shapes: %.2f%n", totalArea);

        System.out.println("\n=== ENCAPSULATION — controlled access ===");
        // BankAccount controls its own state
        // balance is private — we can't do account.balance = -1000
        System.out.println("  (See BankAccount in Lesson 11 for full demo)");

        System.out.println("\n=== COMPOSITION (HAS-A) ===");
        Car tesla = new Car("Tesla", 450);
        Car honda = new Car("Honda", 180);
        tesla.drive();
        honda.drive();

        System.out.println("\n=== instanceof — type checking ===");
        for (Shape s : shapes) {
            if (s instanceof Circle c) {
                System.out.println("  Circle with color: " + c.getColor());
            } else if (s instanceof Rectangle r) {
                System.out.println("  Rectangle with color: " + r.getColor());
            }
        }
    }
}

📝 KEY POINTS:
✅ Encapsulation: private fields + public getters/setters
✅ Inheritance: child class extends parent, IS-A relationship
✅ Polymorphism: same method call → different behavior per type
✅ Abstraction: abstract classes/interfaces define contracts
✅ Java allows single class inheritance but multiple interface implementation
✅ All Java classes implicitly extend Object
✅ Composition (HAS-A) is often preferable to inheritance (IS-A)
✅ @Override annotation prevents typos in overridden method names
❌ Don't inherit just to share code — use composition for that
❌ Deep inheritance chains (>3 levels) are a design smell
❌ Don't expose fields directly — encapsulate with methods
❌ Polymorphism only works through references of the parent type
""",
  quiz: [
    Quiz(question: 'What does encapsulation mean in OOP?', options: [
      QuizOption(text: 'Hiding internal state and exposing only controlled access through methods', correct: true),
      QuizOption(text: 'Wrapping a class in a package to protect it from other classes', correct: false),
      QuizOption(text: 'Making all methods private to prevent external access', correct: false),
      QuizOption(text: 'Using final classes to prevent modification', correct: false),
    ]),
    Quiz(question: 'What is the difference between IS-A and HAS-A relationships?', options: [
      QuizOption(text: 'IS-A is inheritance (Dog extends Animal); HAS-A is composition (Car has an Engine)', correct: true),
      QuizOption(text: 'IS-A uses interfaces; HAS-A uses abstract classes', correct: false),
      QuizOption(text: 'IS-A is for primitives; HAS-A is for objects', correct: false),
      QuizOption(text: 'They are the same relationship described differently', correct: false),
    ]),
    Quiz(question: 'How many parent classes can a Java class directly extend?', options: [
      QuizOption(text: 'One — Java only supports single class inheritance', correct: true),
      QuizOption(text: 'Multiple — Java supports multiple inheritance', correct: false),
      QuizOption(text: 'Two — Java supports dual inheritance', correct: false),
      QuizOption(text: 'Unlimited — as many as needed', correct: false),
    ]),
  ],
);
