import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson18 = Lesson(
  language: 'Java',
  title: 'Interfaces',
  content: """
🎯 METAPHOR:
An interface is like a job contract, not a job description.
The contract says: "You MUST be able to drive a vehicle,
use GPS navigation, and accept card payments." It doesn't
care if you're an Uber driver, a pizza delivery person,
or a school bus driver — if you sign this contract, you
fulfill all those capabilities. A single driver can sign
MULTIPLE contracts: "I can drive AND I can give tours
AND I speak French." That's the power of interfaces —
multiple contracts, one person, each fulfilled in their
own way. In Java, a class can implement as many interfaces
as needed. That's the solution to single inheritance.

📖 EXPLANATION:
An interface is a pure CONTRACT — it defines what a class
CAN DO, not what it IS.

─────────────────────────────────────
INTERFACE SYNTAX:
─────────────────────────────────────
  public interface Flyable {
      void fly();                    // abstract (must implement)
      void land();                   // abstract (must implement)

      default void takeOff() {       // default — can override or inherit
          System.out.println("Taking off...");
      }

      static boolean canFly(Object o) {  // static — utility method
          return o instanceof Flyable;
      }
  }

  class Bird implements Flyable {
      @Override public void fly()  { System.out.println("Bird flying"); }
      @Override public void land() { System.out.println("Bird landing"); }
      // takeOff() inherited from interface
  }

─────────────────────────────────────
INTERFACE MEMBERS:
─────────────────────────────────────
  Before Java 8:
    → Only public abstract methods
    → public static final constants

  Java 8+:
    → default methods (with body — inheritable)
    → static methods (utility methods on the interface)

  Java 9+:
    → private methods (helper for default methods)

─────────────────────────────────────
MULTIPLE IMPLEMENTATION:
─────────────────────────────────────
  interface Flyable { void fly(); }
  interface Swimmable { void swim(); }
  interface Runnable { void run(); }

  class Duck implements Flyable, Swimmable, Runnable {
      @Override public void fly()  { System.out.println("Duck flies!"); }
      @Override public void swim() { System.out.println("Duck swims!"); }
      @Override public void run()  { System.out.println("Duck runs!"); }
  }

─────────────────────────────────────
INTERFACE EXTENDS INTERFACE:
─────────────────────────────────────
  interface Vehicle { void move(); }
  interface MotorVehicle extends Vehicle {
      void refuel();                // adds new requirement
  }

  class Car implements MotorVehicle {
      @Override public void move()   { ... }
      @Override public void refuel() { ... }
  }

─────────────────────────────────────
DEFAULT METHOD CONFLICTS:
─────────────────────────────────────
  interface A { default void greet() { println("A"); } }
  interface B { default void greet() { println("B"); } }

  class C implements A, B {
      @Override public void greet() {
          A.super.greet();   // must resolve conflict explicitly
      }
  }

─────────────────────────────────────
FUNCTIONAL INTERFACE (@FunctionalInterface):
─────────────────────────────────────
  An interface with exactly ONE abstract method.
  Can be represented as a lambda expression.

  @FunctionalInterface
  interface Calculator {
      int compute(int a, int b);
  }

  Calculator add = (a, b) -> a + b;
  Calculator mul = (a, b) -> a * b;
  add.compute(3, 4);   // 7

  Built-in functional interfaces (java.util.function):
  Function<T,R>, Consumer<T>, Supplier<T>, Predicate<T>,
  Runnable, Callable<T>, Comparator<T>

💻 CODE:
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

// ─── INTERFACES ───────────────────────────────────────
interface Printable {
    void print();
    default void printTwice() { print(); print(); }
}

interface Saveable {
    boolean save(String destination);
    default boolean saveToDefault() { return save("./output"); }
}

interface Exportable extends Printable, Saveable {  // extends multiple
    String export(String format);
    static boolean isFormatSupported(String fmt) {
        return Arrays.asList("PDF", "CSV", "JSON", "XML").contains(fmt.toUpperCase());
    }
}

// ─── FUNCTIONAL INTERFACES ────────────────────────────
@FunctionalInterface
interface Transformer<T> {
    T transform(T input);
}

@FunctionalInterface
interface Validator<T> {
    boolean validate(T input);
    default Validator<T> and(Validator<T> other) {
        return input -> this.validate(input) && other.validate(input);
    }
}

// ─── CONCRETE IMPLEMENTATIONS ─────────────────────────
class Document implements Exportable {
    private String title;
    private String content;

    public Document(String title, String content) {
        this.title   = title;
        this.content = content;
    }

    @Override
    public void print() {
        System.out.println("  📄 Document: " + title);
        System.out.println("  Content: " + content.substring(0,
            Math.min(content.length(), 50)) + "...");
    }

    @Override
    public boolean save(String destination) {
        System.out.println("  💾 Saved '" + title + "' to " + destination);
        return true;
    }

    @Override
    public String export(String format) {
        return switch (format.toUpperCase()) {
            case "JSON" -> "{\"title\":\"" + title + "\",\"content\":\"" + content + "\"}";
            case "CSV"  -> title + "," + content;
            case "XML"  -> "<doc><title>" + title + "</title></doc>";
            default     -> throw new IllegalArgumentException("Unknown format: " + format);
        };
    }
}

// Multiple interface implementation
interface Flyable  { void fly();  default String getMode() { return "Air"; } }
interface Swimmable{ void swim(); default String getMode() { return "Water"; } }

class FlyingFish implements Flyable, Swimmable {
    private String name;
    public FlyingFish(String name) { this.name = name; }

    @Override public void fly()  { System.out.println("  " + name + " leaps into the air! 🐟"); }
    @Override public void swim() { System.out.println("  " + name + " darts through water! 🐠"); }

    // Must resolve getMode() conflict
    @Override public String getMode() { return "Air and Water"; }

    public void showCapabilities() {
        System.out.println("  " + name + " can: " + getMode());
        System.out.println("  Implements Flyable: " + (this instanceof Flyable));
        System.out.println("  Implements Swimmable: " + (this instanceof Swimmable));
    }
}

// Interface hierarchy
interface Sensor { double read(); }
interface TemperatureSensor extends Sensor {
    default String unit() { return "°C"; }
}

class RoomThermometer implements TemperatureSensor {
    private double currentTemp;
    public RoomThermometer(double temp) { this.currentTemp = temp; }

    @Override public double read() { return currentTemp; }

    public String reading() {
        return String.format("%.1f%s", read(), unit());
    }
}

public class Interfaces {
    public static void main(String[] args) {

        // ─── DOCUMENT WITH MULTIPLE INTERFACES ───────────
        System.out.println("=== Document (Exportable) ===");
        Document doc = new Document("Annual Report",
            "This report covers Q1-Q4 performance metrics and analysis.");

        doc.print();             // own implementation
        doc.printTwice();        // default from Printable
        doc.save("./reports");   // own implementation
        doc.saveToDefault();     // default from Saveable

        System.out.println("\n  Export formats:");
        for (String fmt : new String[]{"JSON", "CSV", "XML"}) {
            if (Exportable.isFormatSupported(fmt)) {   // static interface method
                System.out.println("  " + fmt + ": " + doc.export(fmt));
            }
        }

        // ─── MULTIPLE INTERFACES ──────────────────────────
        System.out.println("\n=== Multiple Interface Implementation ===");
        FlyingFish fish = new FlyingFish("Exocoetus");
        fish.fly();
        fish.swim();
        fish.showCapabilities();

        // ─── INTERFACE HIERARCHY ──────────────────────────
        System.out.println("\n=== Interface Hierarchy ===");
        RoomThermometer thermo = new RoomThermometer(23.5);
        System.out.println("  Reading: " + thermo.reading());
        System.out.println("  Is Sensor: " + (thermo instanceof Sensor));
        System.out.println("  Is TemperatureSensor: " + (thermo instanceof TemperatureSensor));

        // ─── FUNCTIONAL INTERFACES + LAMBDAS ─────────────
        System.out.println("\n=== Functional Interfaces ===");

        // Lambda as Transformer
        Transformer<String> upper    = s -> s.toUpperCase();
        Transformer<String> trim     = s -> s.trim();
        Transformer<Integer> doubled = n -> n * 2;

        System.out.println("  upper(\"hello\")  : " + upper.transform("hello"));
        System.out.println("  trim(\" hi  \")   : '" + trim.transform(" hi  ") + "'");
        System.out.println("  doubled(21)      : " + doubled.transform(21));

        // Validator composition
        Validator<String> notEmpty  = s -> !s.isEmpty();
        Validator<String> notTooLong = s -> s.length() <= 20;
        Validator<String> hasAt     = s -> s.contains("@");

        Validator<String> emailValidator = notEmpty.and(notTooLong).and(hasAt);

        List<String> emails = List.of("terry@test.com", "", "a".repeat(25), "noatsign");
        System.out.println("\n  Email validation:");
        for (String email : emails) {
            System.out.printf("    %-25s → %s%n", email.isEmpty() ? "(empty)" : email,
                emailValidator.validate(email) ? "✅" : "❌");
        }

        // Using interface type for polymorphism
        System.out.println("\n=== Interface as type ===");
        List<Printable> printables = new ArrayList<>();
        printables.add(doc);
        printables.add(() -> System.out.println("  📋 Lambda printable!"));
        printables.add(() -> System.out.println("  📝 Another lambda!"));

        for (Printable p : printables) {
            p.print();   // polymorphism — each type prints differently
        }
    }
}

📝 KEY POINTS:
✅ Interfaces define WHAT a class can do — not what it IS
✅ A class can implement multiple interfaces (unlike extends)
✅ default methods in interfaces allow adding behavior without breaking implementations
✅ static methods in interfaces are utility methods on the interface itself
✅ @FunctionalInterface marks interfaces that can be used as lambdas
✅ Interfaces can extend multiple other interfaces
✅ Use interface reference type to leverage polymorphism
✅ Conflict between two default methods must be resolved explicitly
❌ Interfaces cannot have constructors or instance fields (only constants)
❌ All interface fields are implicitly public static final
❌ All abstract interface methods are implicitly public — can't be private/protected
❌ Don't use interface just to group constants — use an enum or class instead
""",
  quiz: [
    Quiz(question: 'What is a functional interface in Java?', options: [
      QuizOption(text: 'An interface with exactly one abstract method — can be implemented with a lambda', correct: true),
      QuizOption(text: 'An interface that only contains static methods', correct: false),
      QuizOption(text: 'An interface specifically designed for use with the Streams API', correct: false),
      QuizOption(text: 'An interface with no methods — used as a marker', correct: false),
    ]),
    Quiz(question: 'What happens when a class implements two interfaces that both have a default method with the same name?', options: [
      QuizOption(text: 'A compile error — the class must override the method to resolve the conflict', correct: true),
      QuizOption(text: 'The first interface listed wins automatically', correct: false),
      QuizOption(text: 'The last interface listed wins automatically', correct: false),
      QuizOption(text: 'Java throws a runtime exception when the method is called', correct: false),
    ]),
    Quiz(question: 'What is the implicit visibility of all methods declared in a Java interface?', options: [
      QuizOption(text: 'public — all interface methods are public by default', correct: true),
      QuizOption(text: 'package-private — visible only within the same package', correct: false),
      QuizOption(text: 'protected — visible to implementing classes only', correct: false),
      QuizOption(text: 'It depends on whether the interface is public or package-private', correct: false),
    ]),
  ],
);
