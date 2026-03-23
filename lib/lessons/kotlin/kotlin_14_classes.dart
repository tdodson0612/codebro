import '../../models/lesson.dart';
import '../../models/quiz.dart';

final kotlinLesson14 = Lesson(
  language: 'Kotlin',
  title: 'Classes and Objects',
  content: """
🎯 METAPHOR:
A class is a blueprint. A blueprint for a house tells you
how many rooms there are, where the doors go, what materials
to use. But a blueprint is not a house — you can't live in
a blueprint. An OBJECT is the actual house built from that
blueprint. You can build 100 different houses from the same
blueprint — each is its own object, with its own address,
its own furniture, its own front door color. The class is
the design; the object is the reality.

📖 EXPLANATION:
Kotlin is an object-oriented language. Classes define the
structure and behavior of objects. Kotlin's class syntax
is dramatically cleaner than Java's.

─────────────────────────────────────
BASIC CLASS SYNTAX:
─────────────────────────────────────
  class ClassName {
      // properties
      // functions (called methods in OOP)
  }

  val obj = ClassName()   // create an instance (no 'new' keyword!)

─────────────────────────────────────
PROPERTIES:
─────────────────────────────────────
  class Person {
      var name: String = ""
      var age: Int = 0
  }

Properties are variables that belong to a class.
Access them with dot notation: person.name

─────────────────────────────────────
PRIMARY CONSTRUCTOR:
─────────────────────────────────────
Kotlin's killer feature — define properties directly
in the constructor header:

  class Person(val name: String, var age: Int)

  val p = Person("Terry", 30)
  println(p.name)   // Terry
  println(p.age)    // 30

This is equivalent to MUCH more Java code. In one line,
Kotlin declares the constructor AND the properties.

  val = read-only property
  var = read-write property

─────────────────────────────────────
INIT BLOCK:
─────────────────────────────────────
Code that runs during construction (after parameters
are assigned):

  class Circle(val radius: Double) {
      val area: Double

      init {
          require(radius > 0) { "Radius must be positive" }
          area = Math.PI * radius * radius
      }
  }

─────────────────────────────────────
MEMBER FUNCTIONS (METHODS):
─────────────────────────────────────
Functions inside a class have access to its properties
via 'this':

  class BankAccount(val owner: String) {
      var balance = 0.0

      fun deposit(amount: Double) {
          balance += amount
      }

      fun withdraw(amount: Double): Boolean {
          if (amount > balance) return false
          balance -= amount
          return true
      }
  }

─────────────────────────────────────
CUSTOM GETTERS AND SETTERS:
─────────────────────────────────────
  class Rectangle(val width: Double, val height: Double) {
      val area: Double
          get() = width * height    // computed property

      var name: String = ""
          set(value) {              // custom setter
              field = value.trim()  // 'field' = backing field
          }
  }

─────────────────────────────────────
VISIBILITY MODIFIERS:
─────────────────────────────────────
  public    → visible everywhere (default in Kotlin)
  private   → visible only inside this class
  protected → visible in this class and subclasses
  internal  → visible within the same module

─────────────────────────────────────
COMPANION OBJECT (static members):
─────────────────────────────────────
Kotlin has no static keyword. Use companion object instead.

  class MathHelper {
      companion object {
          val PI = 3.14159
          fun square(x: Int) = x * x
      }
  }

  MathHelper.PI
  MathHelper.square(5)

💻 CODE:
class Person(val name: String, var age: Int) {
    // Additional property with default
    var email: String = ""

    // init block
    init {
        require(age >= 0) { "Age cannot be negative" }
        println("Person created: \$name")
    }

    // Computed property
    val isAdult: Boolean
        get() = age >= 18

    // Custom setter
    var displayName: String = name
        set(value) {
            field = if (value.isBlank()) name else value.trim()
        }

    // Methods
    fun greet() = "Hi, I'm \$name and I'm \$age years old."

    fun birthday() {
        age++
        println("\$name is now \$age!")
    }

    // toString override for readable printing
    override fun toString() = "Person(name=\$name, age=\$age)"
}

class BankAccount(val owner: String, initialBalance: Double = 0.0) {
    var balance = initialBalance
        private set   // only this class can set balance

    fun deposit(amount: Double) {
        require(amount > 0) { "Deposit must be positive" }
        balance += amount
        println("Deposited \${"%.2f".format(amount)} → Balance: \${"%.2f".format(balance)}")
    }

    fun withdraw(amount: Double): Boolean {
        if (amount > balance) {
            println("Insufficient funds")
            return false
        }
        balance -= amount
        println("Withdrew \${"%.2f".format(amount)} → Balance: \${"%.2f".format(balance)}")
        return true
    }
}

class Counter {
    companion object {
        private var instanceCount = 0
        fun getCount() = instanceCount
    }

    init {
        instanceCount++
    }
}

fun main() {
    // Create objects — no 'new' keyword
    val person = Person("Terry", 30)
    println(person.greet())
    println(person.isAdult)     // true
    person.birthday()

    person.displayName = "  T-Dog  "
    println(person.displayName) // T-Dog (trimmed)

    person.email = "terry@example.com"
    println(person)             // Person(name=Terry, age=31)

    // Bank account
    val account = BankAccount("Terry", 100.0)
    account.deposit(50.0)
    account.withdraw(30.0)
    account.withdraw(200.0)    // Insufficient funds
    println("Final: \${account.balance}")

    // Companion object (static-like)
    Counter()
    Counter()
    Counter()
    println("Instances created: \${Counter.getCount()}")  // 3
}

📝 KEY POINTS:
✅ No 'new' keyword — just call the class like a function
✅ Primary constructor in the class header is idiomatic Kotlin
✅ val in constructor = read-only property; var = read-write
✅ init blocks run during construction for validation/setup
✅ Computed properties use get() — recalculated each access
✅ private set restricts external modification of a property
✅ companion object replaces Java's static members
✅ override toString() for readable debugging output
❌ Don't put business logic in init — keep it for validation
❌ Don't access uninitialized properties in init
❌ companion object is NOT the same as a static class
❌ 'field' in a setter refers to the backing field — don't
   use the property name directly (causes infinite recursion)
""",
  quiz: [
    Quiz(question: 'In a Kotlin primary constructor, what does val vs var before a parameter mean?', options: [
      QuizOption(text: 'val creates a read-only property; var creates a read-write property', correct: true),
      QuizOption(text: 'val means the parameter is required; var means it has a default', correct: false),
      QuizOption(text: 'val is for primitive types; var is for objects', correct: false),
      QuizOption(text: 'There is no difference — both create identical properties', correct: false),
    ]),
    Quiz(question: 'What is the Kotlin equivalent of Java\'s static members?', options: [
      QuizOption(text: 'companion object', correct: true),
      QuizOption(text: 'static keyword', correct: false),
      QuizOption(text: 'object keyword at class level', correct: false),
      QuizOption(text: '@Static annotation', correct: false),
    ]),
    Quiz(question: 'What does the init block do in a Kotlin class?', options: [
      QuizOption(text: 'It runs code during object construction, after the constructor parameters are set', correct: true),
      QuizOption(text: 'It initializes the companion object', correct: false),
      QuizOption(text: 'It defines default values for all properties', correct: false),
      QuizOption(text: 'It runs once when the class is first loaded, like a static initializer', correct: false),
    ]),
  ],
);
