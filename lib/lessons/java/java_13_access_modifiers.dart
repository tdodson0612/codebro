import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson13 = Lesson(
  language: 'Java',
  title: 'Access Modifiers and Encapsulation',
  content: """
🎯 METAPHOR:
Access modifiers are like security clearance levels in a
government building. public means anyone from the street
can walk in. protected means employees and their direct
reports (subclasses) only. package-private (default)
means employees in this department only. private means
only you — not even your assistant can see it.
Encapsulation is why these levels exist: the building
has secure rooms (private fields) that even employees
can't just wander into. They submit requests through
the front desk (public methods), which checks, validates,
and controls what happens. Without access control,
anyone could walk into the server room and pull cables.

📖 EXPLANATION:

─────────────────────────────────────
THE 4 ACCESS MODIFIERS:
─────────────────────────────────────
  Modifier         Same Class  Same Package  Subclass  Anywhere
  ─────────────────────────────────────────────────────────────
  private          ✅           ❌             ❌        ❌
  (no modifier)    ✅           ✅             ❌        ❌
  protected        ✅           ✅             ✅        ❌
  public           ✅           ✅             ✅        ✅

  private      → most restrictive — only THIS class
  (default)    → package-private — only THIS package
  protected    → package + subclasses
  public       → everywhere

─────────────────────────────────────
ENCAPSULATION — WHY IT MATTERS:
─────────────────────────────────────
  Without encapsulation:
    account.balance = -1_000_000;  // ❌ anyone can corrupt data

  With encapsulation:
    account.withdraw(1_000_000);   // ✅ method validates first

  Benefits:
  → Data validation (setAge checks 0–150)
  → Read-only properties (getter only, no setter)
  → Write-only properties (setter only, no getter)
  → Change internal implementation without breaking callers
  → Thread safety (synchronize in one place)

─────────────────────────────────────
TYPICAL CLASS DESIGN:
─────────────────────────────────────
  public class BankAccount {
      private double balance;         // private — hidden
      private String owner;           // private — hidden
      private List<String> log;       // private — hidden

      public BankAccount(String owner, double init) { ... }

      public double getBalance() { return balance; }  // read-only
      public String getOwner()   { return owner; }    // read-only

      public void deposit(double amount) {            // controlled write
          if (amount <= 0) throw new ...;
          balance += amount;
          log.add("Deposit: " + amount);
      }

      public boolean withdraw(double amount) { ... }  // returns success
  }

─────────────────────────────────────
PACKAGE-PRIVATE (no modifier):
─────────────────────────────────────
  The default when no modifier is written.
  Visible within the same package — useful for internal
  helper classes that shouldn't be part of the public API.

  class InternalHelper { }         // package-private
  void internalMethod() { }        // package-private

─────────────────────────────────────
protected — for inheritance:
─────────────────────────────────────
  public class Shape {
      protected double area;       // subclasses can access
      protected void draw() { }   // subclasses can call/override
      private void internalCalc() { }  // only Shape can call
  }

  public class Circle extends Shape {
      @Override
      public void draw() {
          super.draw();    // ✅ can call protected parent method
          // internalCalc();  ❌ cannot call private parent method
      }
  }

─────────────────────────────────────
IMMUTABLE CLASSES:
─────────────────────────────────────
  An immutable class cannot be changed after construction.
  Rules:
    1. All fields private and final
    2. No setters
    3. Class declared final (no subclassing)
    4. Return defensive copies of mutable fields

  public final class Money {
      private final long cents;
      private final String currency;

      public Money(long cents, String currency) {
          this.cents = cents;
          this.currency = currency;
      }
      public long   getCents()    { return cents; }
      public String getCurrency() { return currency; }

      public Money add(Money other) {          // returns NEW Money
          return new Money(cents + other.cents, currency);
      }
  }

  String, Integer, LocalDate are all immutable in Java.

💻 CODE:
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

// ─── ENCAPSULATED CLASS ───────────────────────────────
class BankAccount {
    private final String accountId;
    private final String owner;
    private double balance;
    private final List<String> transactions;

    public BankAccount(String accountId, String owner, double initialBalance) {
        if (initialBalance < 0) throw new IllegalArgumentException("Initial balance cannot be negative");
        this.accountId    = accountId;
        this.owner        = owner;
        this.balance      = initialBalance;
        this.transactions = new ArrayList<>();
        transactions.add(String.format("OPEN: %.2f", initialBalance));
    }

    // Read-only — no setter
    public String getAccountId() { return accountId; }
    public String getOwner()     { return owner; }
    public double getBalance()   { return balance; }

    // Returns a copy — protects internal list
    public List<String> getTransactions() {
        return Collections.unmodifiableList(transactions);
    }

    // Controlled deposit
    public void deposit(double amount) {
        if (amount <= 0) throw new IllegalArgumentException("Deposit must be positive");
        balance += amount;
        transactions.add(String.format("DEP: +%.2f → %.2f", amount, balance));
    }

    // Controlled withdraw — returns success flag
    public boolean withdraw(double amount) {
        if (amount <= 0) throw new IllegalArgumentException("Amount must be positive");
        if (amount > balance) {
            transactions.add(String.format("DEC: %.2f FAILED — insufficient", amount));
            return false;
        }
        balance -= amount;
        transactions.add(String.format("WD:  -%.2f → %.2f", amount, balance));
        return true;
    }

    @Override
    public String toString() {
        return String.format("Account[%s, %s, balance=%.2f]",
            accountId, owner, balance);
    }
}

// ─── IMMUTABLE CLASS ──────────────────────────────────
final class Money {
    private final long cents;
    private final String currency;

    public Money(long cents, String currency) {
        if (cents < 0) throw new IllegalArgumentException("Negative money");
        this.cents    = cents;
        this.currency = currency;
    }

    public long   getCents()    { return cents; }
    public String getCurrency() { return currency; }

    public Money add(Money other) {
        if (!currency.equals(other.currency))
            throw new IllegalArgumentException("Currency mismatch");
        return new Money(cents + other.cents, currency);
    }

    public Money multiply(double factor) {
        return new Money((long)(cents * factor), currency);
    }

    @Override
    public String toString() {
        return String.format("%s %.2f", currency, cents / 100.0);
    }
}

// ─── PROTECTED EXAMPLE ────────────────────────────────
class Animal {
    private String name;
    protected String species;        // subclasses can access directly

    public Animal(String name, String species) {
        this.name    = name;
        this.species = species;
    }

    public String getName() { return name; }

    protected String describe() {    // subclasses can override
        return name + " (" + species + ")";
    }
}

class Dog extends Animal {
    private String breed;

    public Dog(String name, String breed) {
        super(name, "Canis lupus familiaris");
        this.breed = breed;
    }

    @Override
    protected String describe() {
        return super.describe() + " — Breed: " + breed; // can call protected
    }

    public void bark() {
        System.out.println("  " + getName() + " says: Woof! 🐕");
        System.out.println("  " + describe());
        // Can access species (protected) directly:
        System.out.println("  Species: " + species);
    }
}

public class AccessModifiers {
    public static void main(String[] args) {

        // ─── ENCAPSULATION ────────────────────────────────
        System.out.println("=== Bank Account (Encapsulation) ===");
        BankAccount acc = new BankAccount("ACC-001", "Terry", 1000.0);
        System.out.println(acc);

        acc.deposit(500.0);
        acc.deposit(250.0);
        System.out.println("After deposits: " + acc);

        boolean ok1 = acc.withdraw(200.0);
        boolean ok2 = acc.withdraw(2000.0);   // should fail
        System.out.println("Withdraw 200:  " + (ok1 ? "✅" : "❌"));
        System.out.println("Withdraw 2000: " + (ok2 ? "✅" : "❌"));
        System.out.println("Final balance: " + acc);

        System.out.println("\nTransaction history:");
        acc.getTransactions().forEach(t -> System.out.println("  " + t));

        // ─── IMMUTABILITY ─────────────────────────────────
        System.out.println("\n=== Immutable Money ===");
        Money price = new Money(1999, "USD");  // $19.99
        Money tax   = new Money(160, "USD");   //  $1.60
        Money total = price.add(tax);
        Money discounted = total.multiply(0.9);

        System.out.println("Price:      " + price);
        System.out.println("Tax:        " + tax);
        System.out.println("Total:      " + total);
        System.out.println("10% off:    " + discounted);
        System.out.println("Original unchanged: " + price); // still $19.99

        // ─── PROTECTED ────────────────────────────────────
        System.out.println("\n=== Protected access ===");
        Dog dog = new Dog("Rex", "German Shepherd");
        dog.bark();
    }
}

📝 KEY POINTS:
✅ private: class only; (default): package; protected: package+subclasses; public: everywhere
✅ Fields should almost always be private — expose via methods
✅ Getters can be public while setters are private or omitted (read-only)
✅ Encapsulation enables validation, read-only access, thread safety
✅ Immutable classes: all fields private final, no setters, class final
✅ String, Integer, LocalDate are examples of immutable classes in Java
✅ protected lets subclasses access members while hiding from everyone else
✅ Return unmodifiableList() instead of the internal list directly
❌ Making fields public breaks encapsulation — anyone can corrupt state
❌ Don't use protected as "slightly less private" — use it intentionally for inheritance
❌ Returning the internal mutable list exposes internal state — return a copy
❌ Package-private (no modifier) is NOT private — entire package can access it
""",
  quiz: [
    Quiz(question: 'Which access modifier makes a member visible only within the same class?', options: [
      QuizOption(text: 'private', correct: true),
      QuizOption(text: 'protected', correct: false),
      QuizOption(text: 'package (no modifier)', correct: false),
      QuizOption(text: 'internal', correct: false),
    ]),
    Quiz(question: 'What makes a Java class immutable?', options: [
      QuizOption(text: 'All fields are private final, no setters exist, and the class is declared final', correct: true),
      QuizOption(text: 'The class is declared abstract', correct: false),
      QuizOption(text: 'All methods are declared static', correct: false),
      QuizOption(text: 'The class implements the Immutable interface', correct: false),
    ]),
    Quiz(question: 'What is the visibility of a member with no access modifier in Java?', options: [
      QuizOption(text: 'Package-private — visible only within the same package', correct: true),
      QuizOption(text: 'Private — visible only within the same class', correct: false),
      QuizOption(text: 'Public — visible from anywhere', correct: false),
      QuizOption(text: 'Protected — visible to subclasses', correct: false),
    ]),
  ],
);
