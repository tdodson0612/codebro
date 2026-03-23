import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson11 = Lesson(
  language: 'Java',
  title: 'Classes and Objects',
  content: """
🎯 METAPHOR:
A class is a cookie cutter. An object is a cookie made FROM
that cutter. Every cookie from the same cutter has the same
shape (structure), but each can have its own frosting color,
sprinkles, and decorations (its own STATE — field values).
You can make as many cookies as you want from one cutter.
Each cookie is independent — eating one doesn't affect
the others. And the cutter itself just sits on the shelf,
unchanged. That's a class: the template. The cookies are
the objects.

📖 EXPLANATION:
A class defines the structure and behavior of objects.
In Java, EVERYTHING lives inside a class.

─────────────────────────────────────
ANATOMY OF A CLASS:
─────────────────────────────────────
  public class ClassName {

      // FIELDS — the state (data the object holds)
      private String name;
      private int age;

      // CONSTRUCTOR — creates objects
      public ClassName(String name, int age) {
          this.name = name;
          this.age = age;
      }

      // METHODS — the behavior
      public String getName() { return name; }
      public void setName(String name) { this.name = name; }
      public void greet() {
          System.out.println("Hi, I'm " + name);
      }

      // toString — human-readable representation
      @Override
      public String toString() {
          return "ClassName{name='" + name + "', age=" + age + "}";
      }
  }

─────────────────────────────────────
CREATING OBJECTS:
─────────────────────────────────────
  ClassName obj = new ClassName("Terry", 30);
  //  ↑ type   ↑ name     ↑ calls constructor

  obj.greet();            // call a method
  obj.getName();          // read a field (via getter)
  obj.setName("Sam");     // write a field (via setter)

  System.out.println(obj); // calls toString() automatically

─────────────────────────────────────
this KEYWORD:
─────────────────────────────────────
  'this' refers to the CURRENT OBJECT INSTANCE.

  Uses:
  1. Distinguish field from parameter:
     this.name = name;  // this.name = field, name = parameter

  2. Call another constructor:
     public Person() { this("Unknown", 0); }

  3. Return the current object (for chaining):
     public Person setName(String n) { this.name = n; return this; }

─────────────────────────────────────
GETTERS AND SETTERS (JavaBeans convention):
─────────────────────────────────────
  private String name;

  public String getName() { return name; }         // getter
  public void setName(String name) {               // setter
      this.name = name;
  }

  boolean fields use isX() convention:
  private boolean active;
  public boolean isActive() { return active; }
  public void setActive(boolean active) { this.active = active; }

─────────────────────────────────────
equals() and hashCode():
─────────────────────────────────────
  By default, equals() checks REFERENCE (same as ==).
  Override it to compare by VALUE:

  @Override
  public boolean equals(Object o) {
      if (this == o) return true;
      if (!(o instanceof Person p)) return false;
      return age == p.age && name.equals(p.name);
  }

  @Override
  public int hashCode() {
      return Objects.hash(name, age);
  }

  RULE: Always override both together. Objects that are
  equals() MUST have the same hashCode().

─────────────────────────────────────
STATIC FIELDS AND METHODS:
─────────────────────────────────────
  Belong to the CLASS, not individual objects.
  Shared across ALL instances.

  class Counter {
      private static int count = 0;    // shared by ALL Counter objects
      private int id;

      public Counter() {
          count++;
          this.id = count;
      }

      public static int getCount() { return count; }
  }

💻 CODE:
import java.util.Objects;

class Person {
    // ─── FIELDS ─────────────────────────────────────────
    private String name;
    private int age;
    private String email;
    private static int instanceCount = 0;  // shared across all instances

    // ─── CONSTRUCTORS ────────────────────────────────────
    public Person(String name, int age, String email) {
        this.name = name;
        this.age = age;
        this.email = email;
        instanceCount++;
    }

    // Overloaded constructor — delegates to main constructor
    public Person(String name, int age) {
        this(name, age, "");   // calls main constructor
    }

    // ─── GETTERS AND SETTERS ─────────────────────────────
    public String getName()  { return name; }
    public int    getAge()   { return age; }
    public String getEmail() { return email; }

    public void setName(String name) {
        if (name == null || name.isBlank())
            throw new IllegalArgumentException("Name cannot be blank");
        this.name = name;
    }

    public void setAge(int age) {
        if (age < 0 || age > 150)
            throw new IllegalArgumentException("Age out of range: " + age);
        this.age = age;
    }

    public void setEmail(String email) { this.email = email; }

    // ─── BEHAVIOR ────────────────────────────────────────
    public void greet() {
        System.out.printf("  👋 Hi! I'm %s, %d years old.%n", name, age);
    }

    public boolean isAdult() { return age >= 18; }

    // Builder-style method chaining (returns this)
    public Person withEmail(String email) {
        this.email = email;
        return this;
    }

    // ─── STATIC METHOD ───────────────────────────────────
    public static int getInstanceCount() { return instanceCount; }

    // ─── equals, hashCode, toString ──────────────────────
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Person p)) return false;
        return age == p.age && Objects.equals(name, p.name);
    }

    @Override
    public int hashCode() {
        return Objects.hash(name, age);
    }

    @Override
    public String toString() {
        return String.format("Person{name='%s', age=%d, email='%s'}",
            name, age, email.isEmpty() ? "none" : email);
    }
}

public class ClassesAndObjects {
    public static void main(String[] args) {

        // ─── CREATING OBJECTS ─────────────────────────────
        System.out.println("=== Creating Objects ===");
        Person p1 = new Person("Terry", 30, "terry@example.com");
        Person p2 = new Person("Sam", 25);
        Person p3 = new Person("Alice", 28, "alice@example.com");

        System.out.println(p1);
        System.out.println(p2);
        System.out.println(p3);

        // ─── CALLING METHODS ──────────────────────────────
        System.out.println("\n=== Methods ===");
        p1.greet();
        p2.greet();
        System.out.println("  " + p1.getName() + " is adult? " + p1.isAdult());
        System.out.println("  " + p2.getName() + " is adult? " + p2.isAdult());

        // ─── SETTERS WITH VALIDATION ──────────────────────
        System.out.println("\n=== Setters with validation ===");
        p2.setName("Samuel");
        p2.setAge(26);
        System.out.println(p2);

        try {
            p2.setAge(-5);   // triggers validation
        } catch (IllegalArgumentException e) {
            System.out.println("  ❌ " + e.getMessage());
        }

        // ─── METHOD CHAINING ──────────────────────────────
        System.out.println("\n=== Method chaining ===");
        Person p4 = new Person("Bob", 22)
                        .withEmail("bob@example.com");
        System.out.println(p4);

        // ─── EQUALS AND HASHCODE ──────────────────────────
        System.out.println("\n=== equals() ===");
        Person a = new Person("Terry", 30);
        Person b = new Person("Terry", 30);
        Person c = new Person("Sam",   25);

        System.out.println("  a == b (reference) : " + (a == b));          // false
        System.out.println("  a.equals(b)         : " + a.equals(b));      // true ✅
        System.out.println("  a.equals(c)         : " + a.equals(c));      // false
        System.out.println("  Same hashCode (a,b) : " + (a.hashCode() == b.hashCode()));

        // ─── STATIC FIELDS ────────────────────────────────
        System.out.println("\n=== Static fields ===");
        System.out.println("  Persons created: " + Person.getInstanceCount());

        // ─── OBJECT ARRAY ─────────────────────────────────
        System.out.println("\n=== Working with object arrays ===");
        Person[] team = {
            new Person("Alice", 28, "alice@co.com"),
            new Person("Bob",   32, "bob@co.com"),
            new Person("Carol", 25, "carol@co.com"),
        };

        System.out.println("  Team members:");
        for (Person member : team) {
            System.out.printf("    %-8s age %d%n",
                member.getName(), member.getAge());
        }

        // Find oldest
        Person oldest = team[0];
        for (Person member : team) {
            if (member.getAge() > oldest.getAge()) {
                oldest = member;
            }
        }
        System.out.println("  Oldest: " + oldest.getName());
    }
}

📝 KEY POINTS:
✅ Fields should be private; expose via getters and setters
✅ 'this' disambiguates between fields and parameters with the same name
✅ this(args) delegates to another constructor in the same class
✅ Always override both equals() and hashCode() together
✅ Objects.hash() and Objects.equals() are convenient null-safe helpers
✅ Static fields and methods belong to the class — shared by all instances
✅ toString() is called automatically when you print an object
✅ Boolean getters use isX() convention: isActive(), isValid()
❌ Don't access fields directly from outside — breaks encapsulation
❌ Never override equals() without overriding hashCode() — breaks Sets/Maps
❌ Don't confuse == (reference equality) with equals() (value equality)
❌ Static methods cannot access instance fields (no 'this' in static context)
""",
  quiz: [
    Quiz(question: 'What does the this keyword refer to inside an instance method?', options: [
      QuizOption(text: 'The current object instance that the method was called on', correct: true),
      QuizOption(text: 'The class that contains the method', correct: false),
      QuizOption(text: 'The parent class of the current class', correct: false),
      QuizOption(text: 'The first parameter passed to the method', correct: false),
    ]),
    Quiz(question: 'Why should you always override hashCode() when you override equals()?', options: [
      QuizOption(text: 'Objects that are equal must have the same hash code — violating this breaks HashSets and HashMaps', correct: true),
      QuizOption(text: 'The compiler requires both to be overridden together', correct: false),
      QuizOption(text: 'hashCode() is called internally by equals() and must match', correct: false),
      QuizOption(text: 'Without hashCode(), the object cannot be stored in an array', correct: false),
    ]),
    Quiz(question: 'What is a static field in a Java class?', options: [
      QuizOption(text: 'A field shared by all instances of the class — one copy exists per class, not per object', correct: true),
      QuizOption(text: 'A field that cannot be modified after initialization', correct: false),
      QuizOption(text: 'A field that is only accessible within the same package', correct: false),
      QuizOption(text: 'A field that is created each time a new instance is constructed', correct: false),
    ]),
  ],
);
