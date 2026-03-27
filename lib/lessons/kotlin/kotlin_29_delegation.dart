import '../../models/lesson.dart';
import '../../models/quiz.dart';

final kotlinLesson29 = Lesson(
  language: 'Kotlin',
  title: 'Delegation: by Keyword and Delegated Properties',
  content: """
🎯 METAPHOR:
Delegation is like a manager who delegates tasks to
specialists. The manager (your class) receives a request:
"Can you handle printing?" Instead of doing it themselves,
they point at the printing specialist (the delegate):
"This person handles all printing requests." The specialist
does the actual work, but from the outside it looks like
the manager is doing it. The manager just FORWARDS the call.
Delegated properties work the same way — instead of the
property storing a value itself, it delegates get/set to
a helper object that decides how the value is stored.

📖 EXPLANATION:
Kotlin's delegation support comes in two forms:
1. Class delegation — delegate interface implementations
2. Property delegation — delegate property get/set logic

Both use the by keyword.

─────────────────────────────────────
CLASS DELEGATION:
─────────────────────────────────────
Implement an interface by delegating to an instance:

  interface Printer {
      fun print(text: String)
  }

  class ConsolePrinter : Printer {
      override fun print(text: String) = println(text)
  }

  // Document delegates Printer to an instance
  class Document(text: String, printer: Printer)
      : Printer by printer {
      // All Printer methods forwarded to 'printer'
  }

  val doc = Document("hello", ConsolePrinter())
  doc.print("Hello!")   // calls ConsolePrinter.print()

This is "Composition over Inheritance" made trivially easy.

─────────────────────────────────────
PROPERTY DELEGATION:
─────────────────────────────────────
Instead of storing a value directly, delegate get/set:

  var name: String by SomeDelegateObject

When you read 'name', the delegate's getValue is called.
When you write 'name = ...', setValue is called.

─────────────────────────────────────
BUILT-IN DELEGATES:
─────────────────────────────────────

1. lazy { } — compute once, cache forever:
  val expensiveResult: String by lazy {
      println("Computing...")
      "Result"    // computed only when first accessed
  }
  // "Computing..." prints only on first access

2. observable — watch for changes:
  var name: String by Delegates.observable("initial") {
      prop, old, new -> println("\${
prop.name}: \$old → \$new")
  }

3. vetoable — conditionally allow changes:
  var age: Int by Delegates.vetoable(0) {
      _, _, new -> new >= 0   // reject negative ages
  }

4. Map delegation — store properties in a Map:
  class User(map: Map<String, Any?>) {
      val name: String by map
      val age: Int by map
  }
  val user = User(mapOf("name" to "Terry", "age" to 30))
  println(user.name)   // Terry

5. notNull — defer initialization, throw if unset:
  var db: Database by Delegates.notNull()

─────────────────────────────────────
CUSTOM PROPERTY DELEGATE:
─────────────────────────────────────
Implement ReadWriteProperty<ReceiverType, ValueType>:

  class LoggingDelegate<T>(initialValue: T) :
      ReadWriteProperty<Any?, T> {
      private var value = initialValue

      override fun getValue(thisRef: Any?, property: KProperty<*>): T {
          println("Getting\${
property.name}: \$value")
          return value
      }

      override fun setValue(thisRef: Any?, property: KProperty<*>, newValue: T) {
          println("Setting\${
property.name}: \$value → \$newValue")
          value = newValue
      }
  }

─────────────────────────────────────
provideDelegate — factory for delegates:
─────────────────────────────────────
Intercept delegate creation for validation/setup:

  operator fun provideDelegate(...): SomeDelegate { ... }

Used for advanced validation at property initialization time.

💻 CODE:
import kotlin.properties.Delegates
import kotlin.properties.ReadWriteProperty
import kotlin.reflect.KProperty

// ─── CLASS DELEGATION ───────────────────────────────

interface Logger {
    fun log(message: String)
    fun error(message: String)
}

class ConsoleLogger : Logger {
    override fun log(message: String) = println("[LOG]   \$message")
    override fun error(message: String) = println("[ERROR] \$message")
}

class FileLogger : Logger {
    private val logs = mutableListOf<String>()
    override fun log(message: String) { logs.add("[LOG] \$message") }
    override fun error(message: String) { logs.add("[ERROR] \$message") }
    fun dump() = logs.forEach { println(it) }
}

// UserService delegates Logger to whatever Logger is passed in
class UserService(logger: Logger) : Logger by logger {
    fun createUser(name: String) {
        log("Creating user: \$name")
        // ... logic
        log("User created: \$name")
    }
}

// ─── PROPERTY DELEGATION ────────────────────────────

// Custom delegate — clamped integer
class ClampedInt(
    private val min: Int,
    private val max: Int,
    initialValue: Int
) : ReadWriteProperty<Any?, Int> {
    private var value = initialValue.coerceIn(min, max)

    override fun getValue(thisRef: Any?, property: KProperty<*>) = value

    override fun setValue(thisRef: Any?, property: KProperty<*>, newValue: Int) {
        value = newValue.coerceIn(min, max)
    }
}

fun clampedInt(min: Int, max: Int, initial: Int) = ClampedInt(min, max, initial)

class GameCharacter(val name: String) {
    // lazy — computed only when first accessed
    val backstory: String by lazy {
        println("Generating backstory for \$name...")
        "A brave warrior from the northern mountains."
    }

    // observable — logs changes
    var health: Int by Delegates.observable(100) { prop, old, new ->
        println("\$name's\${
prop.name}: \$old → \$new")
        if (new <= 0) println("\$name has fallen!")
    }

    // Custom clamped delegate — stays between 0 and 100
    var stamina: Int by clampedInt(0, 100, 100)

    // vetoable — prevent negative gold
    var gold: Int by Delegates.vetoable(50) { _, _, new ->
        if (new < 0) { println("Not enough gold!"); false }
        else true
    }
}

// Map delegation — great for JSON-like config
class AppConfig(private val map: Map<String, Any?>) {
    val apiUrl: String by map
    val timeout: Int by map
    val debug: Boolean by map
    val version: String by map
}

fun main() {
    // Class delegation
    println("=== Class delegation ===")
    val consoleLogger = ConsoleLogger()
    val fileLogger = FileLogger()

    val service1 = UserService(consoleLogger)
    service1.createUser("Terry")

    println()
    val service2 = UserService(fileLogger)
    service2.createUser("Sam")
    fileLogger.dump()   // print accumulated logs

    // Property delegation
    println("\\n=== Property delegation ===")
    val hero = GameCharacter("Aria")

    // lazy — only computed on first access
    println("Hero:\${
hero.name}")
    println(hero.backstory)   // "Generating backstory..." prints once
    println(hero.backstory)   // cached — no re-computation

    // observable health
    hero.health = 75
    hero.health = 30
    hero.health = 0

    // clamped stamina
    hero.stamina = 50
    println("Stamina:\${
hero.stamina}")
    hero.stamina = 200   // clamped to 100
    println("Stamina:\${
hero.stamina}")
    hero.stamina = -50   // clamped to 0
    println("Stamina:\${
hero.stamina}")

    // vetoable gold
    hero.gold = 100
    println("Gold:\${
hero.gold}")
    hero.gold = -10    // vetoed
    println("Gold after veto:\${
hero.gold}")

    // Map delegation
    println("\\n=== Map delegation ===")
    val config = AppConfig(mapOf(
        "apiUrl" to "https://api.example.com",
        "timeout" to 30,
        "debug" to false,
        "version" to "2.0.1"
    ))
    println("URL:\${
config.apiUrl}")
    println("Timeout:\${
config.timeout}s")
    println("Debug:\${
config.debug}")
    println("Version:\${
config.version}")
}

📝 KEY POINTS:
✅ Class delegation with 'by' forwards interface calls to a delegate
✅ lazy { } computes a value once and caches it — thread-safe by default
✅ observable watches for property changes — great for logging/UI
✅ vetoable can reject a change by returning false
✅ Map delegation lets a Map back class properties — useful for configs
✅ Custom delegates implement ReadWriteProperty or ReadOnlyProperty
✅ Delegation is "composition over inheritance" made easy
✅ lazy is LAZY — the block runs only on first access, not at creation
❌ Avoid lazy for frequently-changing data — it only computes once
❌ Mutable class delegation requires careful design — mutability leaks
❌ Don't overuse delegation — simple classes don't need it
❌ Map delegation throws if a key is missing — ensure all keys exist
""",
  quiz: [
    Quiz(question: 'What does the by lazy { } delegate do?', options: [
      QuizOption(text: 'Computes the value on first access and caches it for all subsequent accesses', correct: true),
      QuizOption(text: 'Computes the value in a background thread and caches it', correct: false),
      QuizOption(text: 'Recomputes the value every time it is accessed', correct: false),
      QuizOption(text: 'Initializes the value at object creation time but stores it lazily', correct: false),
    ]),
    Quiz(question: 'What does Delegates.vetoable do when the lambda returns false?', options: [
      QuizOption(text: 'The assignment is rejected and the property keeps its old value', correct: true),
      QuizOption(text: 'An exception is thrown to signal the invalid assignment', correct: false),
      QuizOption(text: 'The property is set to its default value instead', correct: false),
      QuizOption(text: 'The value is clamped to the nearest valid value', correct: false),
    ]),
    Quiz(question: 'What is class delegation with "by" useful for?', options: [
      QuizOption(text: 'Implementing an interface by forwarding all calls to another object — composition over inheritance', correct: true),
      QuizOption(text: 'Automatically generating toString and equals for any class', correct: false),
      QuizOption(text: 'Creating lazy singletons that initialize on first use', correct: false),
      QuizOption(text: 'Forwarding constructor parameters to the superclass', correct: false),
    ]),
  ],
);
