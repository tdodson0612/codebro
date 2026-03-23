import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson73 = Lesson(
  language: 'Java',
  title: 'Clean Code and SOLID Principles in Java',
  content: """
🎯 METAPHOR:
SOLID principles are the building codes for software
architecture. Just as building codes prevent structures
from collapsing — a wall that can't bear its load,
a circuit that can't handle its current — SOLID prevents
code from collapsing under its own weight. The Single
Responsibility rule says "every room has one purpose"
(a kitchen doesn't also serve as a bedroom). Open/Closed
says "you can add rooms without tearing down walls."
Liskov says "any room labeled bedroom must work as
a bedroom." Interface Segregation says "don't require
guests to use the pool just because they're staying in
a hotel." Dependency Inversion says "the hotel shouldn't
depend on one specific bed manufacturer."

📖 EXPLANATION:
SOLID is a set of five design principles for writing
maintainable, scalable, and testable object-oriented code.

─────────────────────────────────────
S — SINGLE RESPONSIBILITY PRINCIPLE:
─────────────────────────────────────
  A class should have only ONE reason to change.
  Each class does ONE thing and does it well.

  // ❌ Violates SRP — handles data, formatting, AND saving:
  class Report {
      void generateReport() { }
      void formatAsHtml() { }
      void saveToFile() { }
      void sendByEmail() { }
  }

  // ✅ SRP — each class has one job:
  class ReportGenerator { void generate() { } }
  class HtmlFormatter    { String format(Report r) { } }
  class FileSaver        { void save(String content) { } }
  class EmailSender      { void send(String content) { } }

─────────────────────────────────────
O — OPEN/CLOSED PRINCIPLE:
─────────────────────────────────────
  Open for extension, closed for modification.
  Add new behavior via new classes, not editing existing ones.

  // ❌ Violates OCP — must modify existing code to add shapes:
  double totalArea(List<Object> shapes) {
      double sum = 0;
      for (Object s : shapes) {
          if (s instanceof Circle c) sum += PI * c.r * c.r;
          else if (s instanceof Rect r) sum += r.w * r.h;
          // Must ADD else-if for every new shape!
      }
      return sum;
  }

  // ✅ OCP — add shapes by creating new class, no code change:
  interface Shape { double area(); }
  class Circle implements Shape { double area() {...} }
  class Rectangle implements Shape { double area() {...} }
  // Triangle — just add new class, totalArea() unchanged:
  double totalArea(List<Shape> shapes) {
      return shapes.stream().mapToDouble(Shape::area).sum();
  }

─────────────────────────────────────
L — LISKOV SUBSTITUTION PRINCIPLE:
─────────────────────────────────────
  Subtypes must be substitutable for their base types.
  If S extends T, code using T should work with S without knowing.

  // ❌ Violates LSP — Square IS-A Rectangle breaks behavior:
  class Rectangle { int w, h; void setWidth(int w){this.w=w;} }
  class Square extends Rectangle {
      @Override void setWidth(int w) { this.w = w; this.h = w; } // breaks rectangle!
  }
  // rectangle.setWidth(5); area = 5 * 3 = 15 ≠ 5 * 5 = 25

  // ✅ LSP — use composition or separate hierarchy:
  interface Shape { int area(); }
  record Rect(int w, int h) implements Shape { public int area(){return w*h;} }
  record Square(int side) implements Shape { public int area(){return side*side;} }

─────────────────────────────────────
I — INTERFACE SEGREGATION PRINCIPLE:
─────────────────────────────────────
  Don't force clients to depend on methods they don't use.
  Many small, specific interfaces > one large, general interface.

  // ❌ Fat interface — forces implementation of unused methods:
  interface Worker { void work(); void eat(); void sleep(); }
  class Robot implements Worker {
      void work() { ... }
      void eat()   { throw new UnsupportedOperationException(); } // robots don't eat!
      void sleep() { throw new UnsupportedOperationException(); }
  }

  // ✅ ISP — segregated interfaces:
  interface Workable { void work(); }
  interface Feedable { void eat(); }
  interface Restable { void sleep(); }
  class Human implements Workable, Feedable, Restable { ... }
  class Robot implements Workable { ... }  // only what it needs

─────────────────────────────────────
D — DEPENDENCY INVERSION PRINCIPLE:
─────────────────────────────────────
  High-level modules should not depend on low-level modules.
  Both should depend on abstractions.

  // ❌ Tight coupling to concrete implementation:
  class UserService {
      private MySQLUserRepo repo = new MySQLUserRepo(); // hard-coded!
  }
  // Can't test without a real MySQL database.

  // ✅ DIP — depend on abstraction:
  interface UserRepository { User findById(int id); }
  class MySQLUserRepo implements UserRepository { ... }
  class InMemoryUserRepo implements UserRepository { ... } // for tests!

  class UserService {
      private final UserRepository repo; // injected
      UserService(UserRepository repo) { this.repo = repo; }
  }
  // Test: new UserService(new InMemoryUserRepo())
  // Prod: new UserService(new MySQLUserRepo())

─────────────────────────────────────
CLEAN CODE ADDITIONAL RULES:
─────────────────────────────────────
  Naming:
  ✅ Intention-revealing names: getUserById() not getUsr()
  ✅ Pronounceable: customerId not cstmrId
  ✅ Searchable: MAX_CONNECTIONS not 10
  ✅ Avoid disinformation: accountList (even if it's a Map, don't call it accountList)

  Functions:
  ✅ Small — ideally < 20 lines
  ✅ Do one thing
  ✅ Descriptive names (verbs)
  ✅ Few parameters (< 3 ideally)
  ✅ No side effects

  Comments:
  ✅ Explain WHY, not WHAT (code explains WHAT)
  ❌ Don't comment out dead code — delete it
  ❌ Don't write obvious comments

  Error handling:
  ✅ Use exceptions over error codes
  ✅ Don't return null — use Optional
  ✅ Provide context in exceptions

💻 CODE:
import java.util.*;
import java.util.function.*;

// ─── SRP ──────────────────────────────────────────────
record Order(String id, String customer, double total, List<String> items) {}

class OrderValidator {   // validates only
    public List<String> validate(Order order) {
        List<String> errors = new ArrayList<>();
        if (order.customer().isBlank()) errors.add("Customer required");
        if (order.total() <= 0)         errors.add("Total must be positive");
        if (order.items().isEmpty())     errors.add("Order must have items");
        return errors;
    }
}

class OrderRepository {  // persists only
    private final Map<String, Order> store = new HashMap<>();
    public Order save(Order o) { store.put(o.id(), o); return o; }
    public Optional<Order> findById(String id) { return Optional.ofNullable(store.get(id)); }
}

class OrderNotifier {    // notifies only
    public void notifyCustomer(Order order) {
        System.out.println("  📧 Email sent to " + order.customer() + " for order " + order.id());
    }
}

// ─── OCP — pluggable discount strategy ────────────────
interface DiscountStrategy {
    double apply(double price);
    String name();
}

record PercentageDiscount(double percent) implements DiscountStrategy {
    public double apply(double price) { return price * (1 - percent/100); }
    public String name() { return percent + "% off"; }
}

record FixedDiscount(double amount) implements DiscountStrategy {
    public double apply(double price) { return Math.max(0, price - amount); }
    public String name() { return "$" + amount + " off"; }
}

record NoDiscount() implements DiscountStrategy {
    public double apply(double price) { return price; }
    public String name() { return "No discount"; }
}

// New discount: add class, no existing code changed
record BuyOneGetOne() implements DiscountStrategy {
    public double apply(double price) { return price / 2; }
    public String name() { return "BOGO (50% off)"; }
}

class PricingEngine {  // uses any strategy — OCP compliant
    public double calculate(double price, DiscountStrategy strategy) {
        return strategy.apply(price);
    }
}

// ─── DIP — repository abstraction ─────────────────────
interface ProductRepository {
    Optional<String> findById(int id);
    List<String> findAll();
}

class InMemoryProductRepo implements ProductRepository {
    private final Map<Integer, String> data = Map.of(
        1, "Laptop", 2, "Phone", 3, "Tablet");
    public Optional<String> findById(int id) { return Optional.ofNullable(data.get(id)); }
    public List<String> findAll() { return new ArrayList<>(data.values()); }
}

class ProductService {
    private final ProductRepository repo;  // depends on abstraction
    ProductService(ProductRepository repo) { this.repo = repo; }

    public String getProductName(int id) {
        return repo.findById(id).orElse("Unknown Product");
    }

    public void listAll() {
        repo.findAll().stream().sorted()
            .forEach(p -> System.out.println("  • " + p));
    }
}

public class SolidPrinciples {
    public static void main(String[] args) {

        // ─── SRP ──────────────────────────────────────────
        System.out.println("=== Single Responsibility Principle ===");
        Order order = new Order("ORD-001", "Alice", 99.99, List.of("Widget A", "Widget B"));

        OrderValidator validator = new OrderValidator();
        List<String> errors = validator.validate(order);
        if (errors.isEmpty()) {
            OrderRepository repo = new OrderRepository();
            repo.save(order);
            new OrderNotifier().notifyCustomer(order);
            System.out.println("  ✅ Order " + order.id() + " processed");
        } else {
            System.out.println("  ❌ Validation errors: " + errors);
        }

        // ─── OCP ──────────────────────────────────────────
        System.out.println("\n=== Open/Closed Principle ===");
        PricingEngine engine = new PricingEngine();
        double originalPrice = 100.0;
        List<DiscountStrategy> strategies = List.of(
            new NoDiscount(), new PercentageDiscount(15),
            new FixedDiscount(20), new BuyOneGetOne()
        );
        for (DiscountStrategy s : strategies) {
            System.out.printf("  %-20s $%.2f → $%.2f%n",
                s.name() + ":", originalPrice, engine.calculate(originalPrice, s));
        }

        // ─── DIP ──────────────────────────────────────────
        System.out.println("\n=== Dependency Inversion Principle ===");
        // Production code:
        ProductService prodService = new ProductService(new InMemoryProductRepo());
        System.out.println("  All products:");
        prodService.listAll();
        System.out.println("  Product 2: " + prodService.getProductName(2));
        System.out.println("  Product 9: " + prodService.getProductName(9));

        // Same service, different implementation (e.g., for testing):
        ProductService testService = new ProductService(new ProductRepository() {
            public Optional<String> findById(int id) { return Optional.of("Mock Product " + id); }
            public List<String> findAll() { return List.of("Mock A", "Mock B"); }
        });
        System.out.println("  Test product 5: " + testService.getProductName(5));

        // ─── CLEAN CODE — NAMING ──────────────────────────
        System.out.println("\n=== Clean Code Principles ===");
        System.out.println("  Naming:");
        System.out.println("    ❌ int d; // elapsed time in days");
        System.out.println("    ✅ int elapsedTimeInDays;");
        System.out.println("    ❌ List<int[]> theList;");
        System.out.println("    ✅ List<int[]> flaggedCells;");
        System.out.println("    ❌ getUsr()");
        System.out.println("    ✅ getUserById()");

        System.out.println("\n  Functions:");
        System.out.println("    ✅ Small, focused, one level of abstraction");
        System.out.println("    ✅ Max ~3 parameters — use a record/object for more");
        System.out.println("    ✅ No flag parameters (boolean inReport)");
        System.out.println("    ✅ Command-Query Separation: either DO or RETURN");

        System.out.println("\n  Comments:");
        System.out.println("    ❌ // increment i by 1");
        System.out.println("    ✅ // Retry needed due to downstream rate limiting (issue #1234)");
        System.out.println("    ❌ // TODO: fix this (from 2019)");
        System.out.println("    ✅ Create a ticket and link it");
    }
}

📝 KEY POINTS:
✅ SRP: each class has one reason to change — split concerns into separate classes
✅ OCP: add behavior via new classes (polymorphism) not by editing existing ones
✅ LSP: subclasses must be substitutable for their base — Square/Rectangle is a classic violation
✅ ISP: small focused interfaces > one large fat interface — clients only depend on what they use
✅ DIP: depend on abstractions (interfaces) not concretions — enables testing and flexibility
✅ Clean names explain intent: getUserById() not getUsr(), elapsedTimeInDays not d
✅ Functions should do ONE thing and be small — extract logic into well-named methods
✅ Comments should explain WHY not WHAT — the code should explain WHAT
❌ SOLID is a guide, not a religion — pragmatism beats dogma in small projects
❌ Over-engineering with too many interfaces/abstractions for simple cases adds complexity
❌ LSP violation: if a subclass throws UnsupportedOperationException for a base method — redesign
❌ ISP violation: implementing interface methods with empty bodies or exceptions
""",
  quiz: [
    Quiz(question: 'Which SOLID principle says you should depend on abstractions rather than concrete implementations?', options: [
      QuizOption(text: 'Dependency Inversion Principle — both high and low-level modules depend on interfaces, not each other', correct: true),
      QuizOption(text: 'Interface Segregation Principle — use many small interfaces instead of one large one', correct: false),
      QuizOption(text: 'Open/Closed Principle — extend behavior without modifying existing code', correct: false),
      QuizOption(text: 'Single Responsibility Principle — each class has one reason to change', correct: false),
    ]),
    Quiz(question: 'Why is the Square extends Rectangle relationship a classic LSP violation?', options: [
      QuizOption(text: 'Setting a Square\'s width also sets its height, breaking code that expects Rectangle\'s width and height to be independent', correct: true),
      QuizOption(text: 'Square cannot have the same methods as Rectangle because they are fundamentally different shapes', correct: false),
      QuizOption(text: 'Square\'s area calculation is more efficient than Rectangle\'s, changing performance expectations', correct: false),
      QuizOption(text: 'LSP only applies to interfaces — class inheritance is allowed to violate substitutability', correct: false),
    ]),
    Quiz(question: 'What does the Open/Closed Principle mean for adding new shape types to a drawing application?', options: [
      QuizOption(text: 'Create a new class implementing Shape.area() — existing code using Shape doesn\'t need modification', correct: true),
      QuizOption(text: 'Modify the existing Shape class to add new behavior when new shapes are needed', correct: false),
      QuizOption(text: 'Open the existing shape hierarchy for modification by removing the final modifier', correct: false),
      QuizOption(text: 'Close all shape classes to prevent extension by making them final', correct: false),
    ]),
  ],
);
