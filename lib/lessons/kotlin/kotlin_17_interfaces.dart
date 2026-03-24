import '../../models/lesson.dart';
import '../../models/quiz.dart';

final kotlinLesson17 = Lesson(
  language: 'Kotlin',
  title: 'Interfaces',
  content: """
🎯 METAPHOR:
An interface is like a job description posted by a company.
The job description says: "This role MUST be able to write
reports, run meetings, and analyze data." It doesn't say
HOW — that's up to the person who gets the job. One person
might write reports in Word, another in Google Docs.
One might run meetings over Zoom, another in person.
The WHAT is defined by the interface. The HOW is up to
the class that implements it. A class can hold multiple
job titles (implement multiple interfaces) — unlike
inheritance where you can only have one parent.

📖 EXPLANATION:
Interfaces define a CONTRACT — a set of functions a class
promises to implement. Unlike abstract classes:

  ✅ A class can implement MULTIPLE interfaces
  ✅ Interfaces cannot store state (no backing fields)
  ✅ Interfaces can have default implementations
  ✅ Interfaces cannot have constructors

─────────────────────────────────────
BASIC INTERFACE:
─────────────────────────────────────
  interface Drawable {
      fun draw()              // abstract — must implement
      fun hide() = println("Hiding...")  // default — optional override
  }

  class Circle : Drawable {
      override fun draw() = println("Drawing a circle")
      // hide() inherited from interface — don't need to override
  }

─────────────────────────────────────
IMPLEMENTING MULTIPLE INTERFACES:
─────────────────────────────────────
  interface Flyable {
      fun fly()
  }

  interface Swimmable {
      fun swim()
  }

  class Duck : Flyable, Swimmable {
      override fun fly() = println("Duck flies!")
      override fun swim() = println("Duck swims!")
  }

─────────────────────────────────────
INTERFACE PROPERTIES:
─────────────────────────────────────
Interfaces can declare properties — implementing classes
must provide them (or the interface provides a getter).

  interface Named {
      val name: String         // abstract property
      val greeting: String     // with default getter
          get() = "Hello, I'm \$name"
  }

  class Person(override val name: String) : Named

Note: Interface properties have no backing field —
they're computed or must be overridden by the class.

─────────────────────────────────────
INTERFACE vs ABSTRACT CLASS:
─────────────────────────────────────
  Feature              Interface       Abstract Class
  ────────────────────────────────────────────────────
  Multiple inheritance ✅ Yes          ❌ No (one parent)
  Constructor          ❌ No           ✅ Yes
  State (fields)       ❌ No*          ✅ Yes
  Default methods      ✅ Yes          ✅ Yes

  * Interface properties have no backing field

  Rule of thumb:
  → Use interface for CAPABILITIES (can fly, can draw)
  → Use abstract class for a BASE TYPE with shared state

─────────────────────────────────────
RESOLVING CONFLICTS (diamond problem):
─────────────────────────────────────
If two interfaces have the same default method, the
implementing class MUST override it and choose:

  interface A {
      fun greet() = println("Hello from A")
  }
  interface B {
      fun greet() = println("Hello from B")
  }
  class C : A, B {
      override fun greet() {
          super<A>.greet()   // explicitly choose A's version
      }
  }

─────────────────────────────────────
FUNCTIONAL INTERFACE (SAM):
─────────────────────────────────────
An interface with exactly ONE abstract function is a
functional interface (Single Abstract Method = SAM).
Kotlin lets you pass a lambda wherever a SAM is expected.

  fun interface Validator {
      fun validate(input: String): Boolean
  }

  val emailValidator = Validator { it.contains("@") }
  println(emailValidator.validate("terry@email.com"))  // true

💻 CODE:
interface Drawable {
    fun draw()
    fun erase() = println("Erasing...")   // default
}

interface Resizable {
    val minSize: Int
        get() = 1
    fun resize(factor: Double)
}

interface Clickable {
    fun onClick()
    fun onLongClick() = println("Long click — no action defined")
}

// Implementing multiple interfaces
class Button(val label: String, var size: Double = 1.0)
    : Drawable, Resizable, Clickable {

    override fun draw() = println("Drawing button: [\$label] (size \${"%.1f".format(size)}x)")

    override fun resize(factor: Double) {
        size *= factor
        println("Button resized to \${"%.1f".format(size)}x")
    }

    override fun onClick() = println("Button '\$label' clicked!")

    // onLongClick() inherited from Clickable
    // erase() inherited from Drawable
}

// Interface with abstract property
interface Vehicle {
    val speed: Int
    val fuelType: String
    fun describe() = "\$fuelType vehicle, top speed: \$speed km/h"
}

class ElectricCar(override val speed: Int) : Vehicle {
    override val fuelType = "Electric"
}

class GasCar(override val speed: Int, val engineSize: Double) : Vehicle {
    override val fuelType = "Gasoline"
    override fun describe() = "\${super.describe()}, \${engineSize}L engine"
}

// Functional interface
fun interface Predicate<T> {
    fun test(value: T): Boolean
}

fun <T> filterWith(list: List<T>, pred: Predicate<T>): List<T> {
    return list.filter { pred.test(it) }
}

fun main() {
    val btn = Button("Submit")
    btn.draw()
    btn.onClick()
    btn.onLongClick()   // default implementation
    btn.resize(1.5)
    btn.draw()
    btn.erase()

    println()

    // Polymorphism via interface
    val vehicles: List<Vehicle> = listOf(
        ElectricCar(200),
        GasCar(180, 2.0),
        ElectricCar(250)
    )

    for (v in vehicles) {
        println(v.describe())
    }

    println()

    // Functional interface with lambda
    val numbers = listOf(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
    val evens = filterWith(numbers) { it % 2 == 0 }
    val bigOnes = filterWith(numbers) { it > 7 }
    println("Evens: \$evens")
    println("Greater than 7: \$bigOnes")

    // Type checking
    val drawables: List<Any> = listOf(btn, "text", 42, Button("Cancel"))
    val onlyDrawable = drawables.filterIsInstance<Drawable>()
    println("Drawables found: \${onlyDrawable.size}")
}

📝 KEY POINTS:
✅ A class can implement multiple interfaces
✅ Interfaces can have default method implementations
✅ Interface properties have no backing field — override or use getter
✅ Use super<InterfaceName>.method() to resolve conflicts
✅ fun interface enables SAM conversion — pass a lambda directly
✅ Use interfaces for capabilities; abstract classes for base types
✅ filterIsInstance<T>() filters a list to a specific type
❌ Interfaces cannot have constructors or stored state
❌ Don't put too much logic in interface defaults — keep them minimal
❌ Implementing classes MUST override all abstract interface members
❌ Forgetting to resolve conflicting defaults causes a compile error
""",
  quiz: [
    Quiz(question: 'What is the key advantage of interfaces over abstract classes in Kotlin?', options: [
      QuizOption(text: 'A class can implement multiple interfaces but can only extend one abstract class', correct: true),
      QuizOption(text: 'Interfaces are faster at runtime than abstract classes', correct: false),
      QuizOption(text: 'Interfaces allow constructors; abstract classes do not', correct: false),
      QuizOption(text: 'Interfaces can store mutable state; abstract classes cannot', correct: false),
    ]),
    Quiz(question: 'What is a functional interface (SAM interface) in Kotlin?', options: [
      QuizOption(text: 'An interface with exactly one abstract function, allowing lambda substitution', correct: true),
      QuizOption(text: 'An interface that only contains default method implementations', correct: false),
      QuizOption(text: 'An interface designed specifically for use with collections', correct: false),
      QuizOption(text: 'An interface annotated with @Functional to enable optimization', correct: false),
    ]),
    Quiz(question: 'How do you resolve a conflict when two interfaces provide the same default method?', options: [
      QuizOption(text: 'Override the method and use super<InterfaceName>.method() to call the desired one', correct: true),
      QuizOption(text: 'The last interface listed in the class declaration wins automatically', correct: false),
      QuizOption(text: 'Kotlin throws a compile error — conflicting defaults cannot be resolved', correct: false),
      QuizOption(text: 'Use @Override(from = InterfaceName::class) to specify which to use', correct: false),
    ]),
  ],
);
