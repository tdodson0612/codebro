import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson15 = Lesson(
  language: 'Java',
  title: 'Inheritance',
  content: """
🎯 METAPHOR:
Inheritance is like family traits. A child inherits their
parents' eye color, height potential, and maybe their laugh.
But the child also develops their OWN personality, skills,
and quirks that the parents don't have. They can even do
something DIFFERENTLY than the parent — the same laugh,
but with their own twist. In Java, a subclass INHERITS
everything from its parent (except private members), can
ADD its own new methods and fields, and can OVERRIDE
the parent's methods with its own implementation.
The child IS-A parent — anywhere a parent is expected,
the child can stand in.

📖 EXPLANATION:
Inheritance lets one class (subclass/child) acquire all
accessible members of another class (superclass/parent).

─────────────────────────────────────
extends KEYWORD:
─────────────────────────────────────
  class Animal {
      String name;
      void eat() { System.out.println(name + " eats"); }
  }

  class Dog extends Animal {       // Dog IS-A Animal
      void bark() { System.out.println(name + " barks!"); }
  }

  Dog d = new Dog();
  d.name = "Rex";
  d.eat();    // ✅ inherited from Animal
  d.bark();   // ✅ Dog's own method

─────────────────────────────────────
WHAT IS INHERITED:
─────────────────────────────────────
  ✅ public fields and methods
  ✅ protected fields and methods
  ✅ package-private (same package only)
  ❌ private fields and methods
  ❌ constructors (NOT inherited, but can be called via super())

─────────────────────────────────────
@Override — overriding methods:
─────────────────────────────────────
  class Animal {
      void speak() { System.out.println("..."); }
  }

  class Dog extends Animal {
      @Override              // annotation — tells compiler to check
      void speak() {
          System.out.println("Woof!");
      }
  }

  @Override catches typos at compile time:
  @Override void speck() { }  // ❌ ERROR — no such method in parent

─────────────────────────────────────
super — calling parent implementation:
─────────────────────────────────────
  @Override
  void speak() {
      super.speak();          // call Animal's speak first
      System.out.println("Woof!");
  }

─────────────────────────────────────
SINGLE INHERITANCE:
─────────────────────────────────────
  Java allows only ONE parent class.
  class A extends B, C { }  // ❌ NOT ALLOWED

  BUT a class can implement multiple interfaces:
  class A extends B implements C, D, E { }  // ✅

─────────────────────────────────────
INHERITANCE CHAIN:
─────────────────────────────────────
  Object ← Animal ← Mammal ← Dog ← GoldenRetriever

  Every class ultimately inherits from Object.
  GoldenRetriever IS-A Dog, IS-A Mammal, IS-A Animal, IS-A Object.

─────────────────────────────────────
UPCASTING AND DOWNCASTING:
─────────────────────────────────────
  // Upcasting (always safe — implicit):
  Animal a = new Dog("Rex");    // Dog → Animal reference

  // Downcasting (must check — can fail):
  Dog d = (Dog) a;              // Animal → Dog (runtime check)

  // Safe pattern:
  if (a instanceof Dog dog) {
      dog.bark();               // pattern matching instanceof
  }

─────────────────────────────────────
WHEN NOT TO USE INHERITANCE:
─────────────────────────────────────
  ❌ "Kitchen is a Room" — just to reuse code
  ❌ "Employee is a Person AND Manager" — use interfaces for extra roles
  ❌ More than 3-4 levels deep — becomes hard to trace

  Prefer composition when the IS-A relationship isn't true.
  "A Stack IS-A Vector" — Java's Stack class is a famous mistake.

💻 CODE:
import java.util.ArrayList;
import java.util.List;

// ─── BASE CLASS ───────────────────────────────────────
abstract class Employee {
    private String name;
    private String id;
    private double baseSalary;

    public Employee(String name, String id, double baseSalary) {
        this.name       = name;
        this.id         = id;
        this.baseSalary = baseSalary;
    }

    public String getName()      { return name; }
    public String getId()        { return id; }
    public double getBaseSalary(){ return baseSalary; }

    // Template: subclasses define their own bonus logic
    public abstract double calculateBonus();

    public double totalCompensation() {
        return baseSalary + calculateBonus();
    }

    public void introduce() {
        System.out.printf("  👤 %s [%s] — Base: \$%,.0f | Bonus: \$%,.0f | Total: \$%,.0f%n",
            name, id, baseSalary, calculateBonus(), totalCompensation());
    }

    @Override
    public String toString() {
        return getClass().getSimpleName() + "{" + name + ", " + id + "}";
    }
}

// ─── SUBCLASSES ───────────────────────────────────────
class Engineer extends Employee {
    private String specialty;
    private int yearsExp;

    public Engineer(String name, String id, double salary, String specialty, int years) {
        super(name, id, salary);
        this.specialty = specialty;
        this.yearsExp  = years;
    }

    @Override
    public double calculateBonus() {
        // Engineers get 10% + 1% per year experience
        return getBaseSalary() * (0.10 + yearsExp * 0.01);
    }

    @Override
    public void introduce() {
        super.introduce();
        System.out.printf("     Specialty: %s | Experience: %d years%n",
            specialty, yearsExp);
    }
}

class Manager extends Employee {
    private List<Employee> reports;
    private int teamSize;

    public Manager(String name, String id, double salary, int teamSize) {
        super(name, id, salary);
        this.teamSize = teamSize;
        this.reports  = new ArrayList<>();
    }

    public void addReport(Employee e) { reports.add(e); }

    @Override
    public double calculateBonus() {
        // Managers get 20% + 2% per direct report
        return getBaseSalary() * (0.20 + teamSize * 0.02);
    }

    @Override
    public void introduce() {
        super.introduce();
        System.out.printf("     Team size: %d%n", teamSize);
    }

    public double totalTeamCompensation() {
        double total = totalCompensation();
        for (Employee e : reports) total += e.totalCompensation();
        return total;
    }
}

class Intern extends Employee {
    private String school;

    public Intern(String name, String id, double salary, String school) {
        super(name, id, salary);
        this.school = school;
    }

    @Override
    public double calculateBonus() {
        return 500.0;    // flat bonus for all interns
    }

    @Override
    public void introduce() {
        super.introduce();
        System.out.println("     School: " + school + " (Intern)");
    }
}

public class Inheritance {
    public static void main(String[] args) {

        // ─── CREATE HIERARCHY ─────────────────────────────
        System.out.println("=== Employee Hierarchy ===\n");

        Engineer e1 = new Engineer("Alice", "ENG-001", 120_000, "Backend", 6);
        Engineer e2 = new Engineer("Bob",   "ENG-002", 100_000, "Frontend", 3);
        Intern   i1 = new Intern("Carol", "INT-001", 50_000, "MIT");
        Manager  m1 = new Manager("Dave", "MGR-001", 150_000, 3);

        m1.addReport(e1);
        m1.addReport(e2);
        m1.addReport(i1);

        // ─── POLYMORPHISM: same method, different behavior ─
        System.out.println("--- Individual introductions ---");
        Employee[] team = {e1, e2, i1, m1};
        for (Employee emp : team) {
            emp.introduce();    // calls the correct override
        }

        // ─── UPCASTING & instanceof ───────────────────────
        System.out.println("\n--- Upcasting & instanceof ---");
        for (Employee emp : team) {
            if (emp instanceof Manager mgr) {
                System.out.printf("  Manager %s's team total:\$%,.0f%n",
                    mgr.getName(), mgr.totalTeamCompensation());
            } else if (emp instanceof Intern intern) {
                System.out.printf("  Intern %s from %s — limited bonus%n",
                    intern.getName(), intern.school);
            }
        }

        // ─── INHERITANCE CHAIN ────────────────────────────
        System.out.println("\n--- instanceof chain ---");
        Engineer eng = new Engineer("Test", "T-001", 90_000, "DevOps", 2);
        System.out.println("  Is Engineer: " + (eng instanceof Engineer));
        System.out.println("  Is Employee: " + (eng instanceof Employee));
        System.out.println("  Is Object  : " + (eng instanceof Object));
        System.out.println("  Is Manager : " + (eng instanceof Manager));

        // ─── TOTAL COMPENSATION SUMMARY ───────────────────
        System.out.println("\n--- Compensation Summary ---");
        double total = 0;
        for (Employee emp : team) {
            total += emp.totalCompensation();
            System.out.printf("  %-8s %-10s\$%,.0f%n",
                emp.getClass().getSimpleName(), emp.getName(), emp.totalCompensation());
        }
        System.out.printf("  %s%n", "─".repeat(35));
        System.out.printf("  %-18s\$%,.0f%n", "TOTAL PAYROLL:", total);
    }
}

📝 KEY POINTS:
✅ extends keyword creates a subclass: class Dog extends Animal
✅ Subclasses inherit public and protected members — not private
✅ @Override catches method name typos at compile time — always use it
✅ super.method() calls the parent's version of an overridden method
✅ super(args) in constructor calls the parent's constructor
✅ Java has SINGLE class inheritance but multiple interface implementation
✅ Every class ultimately inherits from Object
✅ Upcasting (Dog→Animal) is automatic; downcasting (Animal→Dog) needs a cast
✅ instanceof with pattern matching (Java 16+) casts safely in one step
❌ Don't override a method without @Override — mistyped names create new methods
❌ Constructors are NOT inherited — each class needs its own
❌ Avoid more than 3-4 levels of inheritance — use composition instead
❌ private members are NOT inherited — use protected for members subclasses need
""",
  quiz: [
    Quiz(question: 'What does the @Override annotation do in Java?', options: [
      QuizOption(text: 'It tells the compiler to verify the method actually overrides a parent method — catching typos', correct: true),
      QuizOption(text: 'It prevents the method from being overridden by any further subclasses', correct: false),
      QuizOption(text: 'It makes the method visible to all subclasses regardless of access modifier', correct: false),
      QuizOption(text: 'It automatically calls super() at the start of the method', correct: false),
    ]),
    Quiz(question: 'Which members are NOT inherited by a subclass in Java?', options: [
      QuizOption(text: 'private members and constructors are not inherited', correct: true),
      QuizOption(text: 'protected members are not inherited', correct: false),
      QuizOption(text: 'static members are not inherited', correct: false),
      QuizOption(text: 'All members including private are inherited', correct: false),
    ]),
    Quiz(question: 'What does upcasting mean in Java?', options: [
      QuizOption(text: 'Assigning a subclass object to a superclass reference — always safe and implicit', correct: true),
      QuizOption(text: 'Converting a primitive type to a larger primitive type', correct: false),
      QuizOption(text: 'Casting a superclass reference to a subclass type', correct: false),
      QuizOption(text: 'Calling a parent class method from a subclass', correct: false),
    ]),
  ],
);
