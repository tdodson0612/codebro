import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson17 = Lesson(
  language: 'Java',
  title: 'Abstract Classes',
  content: """
🎯 METAPHOR:
An abstract class is like a job description template at a
staffing agency. The template says: "Every candidate MUST
be able to write reports, conduct interviews, and manage
budgets." But the template itself isn't a person — you
can't hire the template. You hire specific people (Manager,
Director, Analyst) who each fulfill those requirements in
their own way. The template enforces the CONTRACT — every
hired person has the required skills — but each implements
them differently. The abstract class is the unfillable
template; concrete subclasses are the actual hires.

📖 EXPLANATION:
An abstract class is a class that CANNOT be instantiated
directly — it exists only to be subclassed. It can contain:
  ✅ Abstract methods (no body — subclasses MUST implement)
  ✅ Concrete methods (with body — subclasses inherit)
  ✅ Fields (including final and static)
  ✅ Constructors (called by subclass via super())

─────────────────────────────────────
abstract CLASS SYNTAX:
─────────────────────────────────────
  abstract class Animal {
      // Abstract — subclasses MUST provide implementation
      public abstract String speak();
      public abstract double weight();

      // Concrete — shared implementation inherited by all
      public void breathe() {
          System.out.println(getClass().getSimpleName() + " breathes");
      }
  }

  class Dog extends Animal {
      @Override public String speak()  { return "Woof!"; }
      @Override public double weight() { return 30.5; }
  }

  // new Animal();  // ❌ CANNOT instantiate abstract class!
  Animal a = new Dog();   // ✅ OK — reference is Animal

─────────────────────────────────────
ABSTRACT vs INTERFACE:
─────────────────────────────────────
  Feature                 Abstract Class   Interface
  ──────────────────────────────────────────────────────
  Instantiate directly?   ❌ No            ❌ No
  Multiple inheritance?   ❌ One only      ✅ Many
  Constructors?           ✅ Yes           ❌ No
  Fields?                 ✅ Yes (any)     ✅ Only constants
  Concrete methods?       ✅ Yes           ✅ default methods
  Access modifiers?       ✅ Any           public only

  USE ABSTRACT CLASS WHEN:
  → Subclasses share STATE (fields) and behavior
  → You need a constructor with initialization
  → Subclasses are in an IS-A relationship

  USE INTERFACE WHEN:
  → Defining a capability/contract (can-do)
  → Multiple "inheritance" needed
  → Unrelated classes need the same capability

─────────────────────────────────────
TEMPLATE METHOD PATTERN:
─────────────────────────────────────
  The abstract class defines the ALGORITHM STRUCTURE
  (template method). Subclasses fill in the STEPS.

  abstract class DataProcessor {
      // Template method — final = can't reorder steps
      public final void process() {
          readData();      // step 1 — abstract, must implement
          transform();     // step 2 — abstract, must implement
          writeOutput();   // step 3 — has default, can override
          cleanup();       // step 4 — always same, final
      }

      protected abstract void readData();
      protected abstract void transform();
      protected void writeOutput() { ... }  // default
      private void cleanup() { ... }        // fixed
  }

─────────────────────────────────────
PARTIAL IMPLEMENTATION:
─────────────────────────────────────
  An abstract class can implement SOME but not all of
  an interface's methods — leaving the rest for subclasses:

  interface Drawable { void draw(); void resize(double); }

  abstract class Widget implements Drawable {
      @Override public void draw() { ... }  // implemented
      // resize() left abstract — subclasses implement it
  }

  class Button extends Widget {
      @Override public void resize(double factor) { ... }
  }

💻 CODE:
import java.util.List;
import java.util.ArrayList;

// ─── ABSTRACT BASE CLASS ──────────────────────────────
abstract class Report {
    protected String title;
    protected String author;
    protected List<String> sections;

    public Report(String title, String author) {
        this.title    = title;
        this.author   = author;
        this.sections = new ArrayList<>();
    }

    // Abstract — each report format handles differently
    protected abstract String formatHeader();
    protected abstract String formatSection(String section);
    protected abstract String formatFooter();

    // Template method — defines the report structure (FINAL)
    public final String generate() {
        StringBuilder sb = new StringBuilder();
        sb.append(formatHeader()).append("\n");
        for (String section : sections) {
            sb.append(formatSection(section)).append("\n");
        }
        sb.append(formatFooter());
        return sb.toString();
    }

    // Concrete methods — shared by all report types
    public Report addSection(String content) {
        sections.add(content);
        return this;
    }

    public int getSectionCount() { return sections.size(); }

    public String getTitle()  { return title; }
    public String getAuthor() { return author; }
}

// ─── CONCRETE IMPLEMENTATIONS ─────────────────────────
class TextReport extends Report {
    public TextReport(String title, String author) {
        super(title, author);
    }

    @Override
    protected String formatHeader() {
        return "═".repeat(50) + "\n" +
               String.format("  %s%n  Author: %s", title, author) + "\n" +
               "═".repeat(50);
    }

    @Override
    protected String formatSection(String section) {
        return "\n  • " + section;
    }

    @Override
    protected String formatFooter() {
        return "\n" + "─".repeat(50) + "\n" +
               String.format("  Total sections: %d%n", sections.size()) +
               "─".repeat(50);
    }
}

class HtmlReport extends Report {
    public HtmlReport(String title, String author) {
        super(title, author);
    }

    @Override
    protected String formatHeader() {
        return String.format(
            "<html><head><title>%s</title></head><body>\n" +
            "<h1>%s</h1><p><em>by %s</em></p><ul>",
            title, title, author);
    }

    @Override
    protected String formatSection(String section) {
        return "  <li>" + section + "</li>";
    }

    @Override
    protected String formatFooter() {
        return "</ul>\n<footer>Sections: " + sections.size() + "</footer>\n</body></html>";
    }
}

class MarkdownReport extends Report {
    public MarkdownReport(String title, String author) {
        super(title, author);
    }

    @Override
    protected String formatHeader() {
        return String.format("# %s%n_%s_%n%n---", title, author);
    }

    @Override
    protected String formatSection(String section) {
        return "- " + section;
    }

    @Override
    protected String formatFooter() {
        return "\n---\n*" + sections.size() + " sections total*";
    }
}

// ─── ABSTRACT CLASS WITH PARTIAL INTERFACE IMPL ───────
interface Measurable {
    double getLength();
    double getWeight();
    String getUnit();
}

abstract class Parcel implements Measurable {
    protected double weight;
    protected String trackingId;

    public Parcel(double weight, String trackingId) {
        this.weight     = weight;
        this.trackingId = trackingId;
    }

    @Override public double getWeight() { return weight; }
    @Override public String getUnit()   { return "kg"; }
    // getLength() still abstract — each parcel type implements

    public abstract double calculateShippingCost();

    public void printLabel() {
        System.out.printf("  📦 Tracking: %s | %.1f%s | Cost: $%.2f%n",
            trackingId, getWeight(), getUnit(), calculateShippingCost());
    }
}

class SmallBox extends Parcel {
    public SmallBox(double weight, String id) { super(weight, id); }
    @Override public double getLength() { return 30.0; }
    @Override public double calculateShippingCost() { return weight * 3.5; }
}

class LargeBox extends Parcel {
    private double length;
    public LargeBox(double weight, double length, String id) {
        super(weight, id);
        this.length = length;
    }
    @Override public double getLength() { return length; }
    @Override public double calculateShippingCost() {
        return weight * 5.0 + length * 0.5;
    }
}

public class AbstractClasses {
    public static void main(String[] args) {

        // ─── TEMPLATE METHOD PATTERN ─────────────────────
        System.out.println("=== Report Generator (Template Method) ===\n");

        Report textReport = new TextReport("Q4 Summary", "Terry Smith")
            .addSection("Revenue increased 15% YoY")
            .addSection("New markets: Brazil, India, Japan")
            .addSection("Team grew from 50 to 75 members")
            .addSection("Product lines expanded by 8 items");

        System.out.println(textReport.generate());

        System.out.println("\n--- HTML Report ---");
        Report htmlReport = new HtmlReport("Annual Report", "Finance Team")
            .addSection("Net profit: $2.4M")
            .addSection("EBITDA: 18%")
            .addSection("Cash reserves: $5M");

        System.out.println(htmlReport.generate());

        System.out.println("\n--- Markdown Report ---");
        Report mdReport = new MarkdownReport("Sprint Retrospective", "Dev Team")
            .addSection("Shipped 12 features")
            .addSection("Fixed 34 bugs")
            .addSection("Velocity: +20%");

        System.out.println(mdReport.generate());

        // ─── ABSTRACT + PARTIAL INTERFACE IMPL ───────────
        System.out.println("\n=== Parcel Shipping ===");
        List<Parcel> parcels = List.of(
            new SmallBox(0.5, "TRK-001"),
            new SmallBox(2.0, "TRK-002"),
            new LargeBox(5.0, 80.0, "TRK-003"),
            new LargeBox(3.5, 60.0, "TRK-004")
        );

        for (Parcel p : parcels) {
            p.printLabel();
        }

        double totalCost = parcels.stream()
            .mapToDouble(Parcel::calculateShippingCost)
            .sum();
        System.out.printf("  Total shipping cost: $%.2f%n", totalCost);

        // ─── CANNOT INSTANTIATE ABSTRACT CLASS ───────────
        // new Report("x", "y");  // ❌ compile error
        // new Parcel(1.0, "X");  // ❌ compile error
        System.out.println("\n  ✅ Cannot instantiate Report or Parcel directly");
        System.out.println("  ✅ Only concrete subclasses can be instantiated");
    }
}

📝 KEY POINTS:
✅ Abstract classes cannot be instantiated — use them as base types only
✅ Abstract methods have no body — all non-abstract subclasses MUST implement them
✅ Concrete methods in abstract classes provide shared behavior to all subclasses
✅ Abstract classes can have constructors — called by subclasses via super()
✅ Template Method pattern: abstract class defines algorithm, subclasses fill steps
✅ Use abstract class when subclasses share STATE and behavior
✅ Use interface when defining capabilities across unrelated classes
✅ An abstract class can partially implement an interface
❌ If a subclass doesn't implement ALL abstract methods, it must also be abstract
❌ You cannot mark a class both abstract and final
❌ Abstract classes can't be anonymous (new AbstractClass() { }) without implementing all abstract methods
❌ Static methods cannot be abstract
""",
  quiz: [
    Quiz(question: 'What is an abstract method in Java?', options: [
      QuizOption(text: 'A method with no body that subclasses are required to implement', correct: true),
      QuizOption(text: 'A private method that cannot be called from outside the class', correct: false),
      QuizOption(text: 'A method that returns an abstract data type', correct: false),
      QuizOption(text: 'A static method that belongs to the abstract class only', correct: false),
    ]),
    Quiz(question: 'When should you use an abstract class instead of an interface?', options: [
      QuizOption(text: 'When subclasses share STATE (fields) and behavior, and need a common constructor', correct: true),
      QuizOption(text: 'When you need multiple types to implement the same capability', correct: false),
      QuizOption(text: 'When you want to prevent all instantiation of the type hierarchy', correct: false),
      QuizOption(text: 'Abstract classes and interfaces serve the same purpose — choose either', correct: false),
    ]),
    Quiz(question: 'What happens if a concrete class extends an abstract class but doesn\'t implement all abstract methods?', options: [
      QuizOption(text: 'A compile error — the class must either implement all abstract methods or be declared abstract itself', correct: true),
      QuizOption(text: 'The unimplemented methods default to doing nothing', correct: false),
      QuizOption(text: 'The class becomes abstract automatically', correct: false),
      QuizOption(text: 'A runtime UnsupportedOperationException is thrown when the method is called', correct: false),
    ]),
  ],
);
