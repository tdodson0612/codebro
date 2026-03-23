import '../../models/lesson.dart';
import '../../models/quiz.dart';

final kotlinLesson18 = Lesson(
  language: 'Kotlin',
  title: 'Object Declarations and Companion Objects',
  content: """
🎯 METAPHOR:
An object declaration is like the one and only key to a
city. There's exactly one Mayor's Office — not a blueprint
for mayor's offices, just THE office. You don't create
instances of it. You just walk in. In programming, some
things should only ever exist once: a database connection
pool, an app configuration, a logging system. The Singleton
pattern guarantees this. Kotlin bakes it into the language
with the object keyword — no boilerplate, no double-checked
locking, no getInstance() method. Just: object.

📖 EXPLANATION:
Kotlin has three uses of the object keyword, all related
to the idea of a single instance:

  1. object declaration  → Singleton
  2. companion object    → "Static" members of a class
  3. object expression   → Anonymous object (one-off)

─────────────────────────────────────
1. OBJECT DECLARATION — Singleton:
─────────────────────────────────────
  object AppConfig {
      val baseUrl = "https://api.example.com"
      var timeout = 30

      fun printConfig() {
          println("URL: \$baseUrl, Timeout: \${timeout}s")
      }
  }

  AppConfig.printConfig()      // access directly
  AppConfig.timeout = 60       // modify directly

Kotlin creates exactly ONE instance, lazily, thread-safely.
No getInstance(), no companion, no static — just use it.

─────────────────────────────────────
2. COMPANION OBJECT — "Static" members:
─────────────────────────────────────
Each class can have ONE companion object. Its members
are accessed on the CLASS NAME, like static in Java.

  class User(val name: String) {
      companion object {
          const val MAX_NAME_LENGTH = 50

          fun create(name: String): User? {
              return if (name.length <= MAX_NAME_LENGTH)
                  User(name) else null
          }
      }
  }

  User.MAX_NAME_LENGTH     // 50
  User.create("Terry")     // returns User or null

companion object can also be named:
  companion object Factory { ... }
  User.Factory.create(...)

─────────────────────────────────────
const val vs val in companion:
─────────────────────────────────────
  const val → compile-time constant (primitives/String only)
             inlined at call sites — no runtime overhead
  val       → runtime constant — computed when accessed

  companion object {
      const val MAX_RETRIES = 3          // compile-time
      val DEFAULT_TIMEOUT = computeTimeout()  // runtime
  }

─────────────────────────────────────
3. OBJECT EXPRESSION — Anonymous Object:
─────────────────────────────────────
Create a one-off implementation without declaring a class.
Common for listeners and callbacks.

  val listener = object : ClickListener {
      override fun onClick() = println("Clicked!")
  }

  // Anonymous object with no interface
  val point = object {
      val x = 3
      val y = 4
  }
  println(point.x)   // 3

─────────────────────────────────────
OBJECT vs COMPANION OBJECT:
─────────────────────────────────────
  object Singleton   → standalone, no associated class
  companion object   → lives inside a class, accessed via class name

─────────────────────────────────────
WHEN TO USE EACH:
─────────────────────────────────────
  object declaration  → app-wide singletons (logger, config)
  companion object    → factory methods, constants for a class
  object expression   → one-time interface implementations

💻 CODE:
// Singleton — one instance ever
object Logger {
    private val logs = mutableListOf<String>()

    fun log(message: String) {
        val entry = "[LOG] \$message"
        logs.add(entry)
        println(entry)
    }

    fun printAll() {
        println("--- All logs (\${logs.size}) ---")
        logs.forEach { println(it) }
    }
}

// Singleton implementing an interface
interface Configurable {
    fun reset()
}

object AppConfig : Configurable {
    var theme = "Light"
    var language = "English"
    const val VERSION = "1.0.0"

    override fun reset() {
        theme = "Light"
        language = "English"
        println("Config reset to defaults")
    }

    fun describe() = "App v\$VERSION | Theme: \$theme | Lang: \$language"
}

// Class with companion object
class Database private constructor(val url: String) {
    companion object Factory {
        private var instance: Database? = null
        const val DEFAULT_PORT = 5432

        fun getInstance(url: String): Database {
            return instance ?: Database(url).also { instance = it }
        }

        fun isConnected() = instance != null
    }

    fun query(sql: String) = println("Querying '\$sql' on \$url")
}

// Interface for object expression
interface EventHandler {
    fun onStart()
    fun onStop()
    fun onError(msg: String) = println("Error: \$msg")  // default
}

fun startProcess(handler: EventHandler) {
    handler.onStart()
    println("Process running...")
    handler.onStop()
}

fun main() {
    // Singleton usage
    Logger.log("App started")
    Logger.log("User logged in")
    Logger.log("Data loaded")
    Logger.printAll()

    println()

    // AppConfig
    println(AppConfig.describe())
    AppConfig.theme = "Dark"
    AppConfig.language = "Spanish"
    println(AppConfig.describe())
    AppConfig.reset()
    println(AppConfig.describe())
    println("Version: \${AppConfig.VERSION}")

    println()

    // Companion object / factory
    val db1 = Database.getInstance("postgresql://localhost:\${Database.DEFAULT_PORT}/mydb")
    val db2 = Database.getInstance("postgresql://other")   // same instance returned
    println(db1 === db2)     // true — same object
    println(Database.isConnected())
    db1.query("SELECT * FROM users")

    println()

    // Object expression — one-time EventHandler
    startProcess(object : EventHandler {
        override fun onStart() = println("Process started!")
        override fun onStop() = println("Process stopped cleanly.")
        override fun onError(msg: String) = println("CRITICAL: \$msg")
    })

    // Anonymous object with no interface
    val dimensions = object {
        val width = 1920
        val height = 1080
    }
    println("Resolution: \${dimensions.width}x\${dimensions.height}")
}

📝 KEY POINTS:
✅ object declaration creates a thread-safe, lazy singleton
✅ companion object provides class-level (static-like) access
✅ const val is inlined at compile time — best for constants
✅ object expression creates one-off implementations inline
✅ Singletons can implement interfaces
✅ companion object can be named: companion object Factory
✅ private constructor + companion factory = controlled creation
❌ Don't use singletons for everything — they make testing hard
❌ Singletons hold state globally — be careful with mutability
❌ companion object is not the same as a Java static inner class
❌ object expressions captured in local scope are local type only
   — you cannot return an anonymous object as a specific named type
""",
  quiz: [
    Quiz(question: 'What does an object declaration in Kotlin create?', options: [
      QuizOption(text: 'A thread-safe singleton — exactly one instance ever created', correct: true),
      QuizOption(text: 'A factory that creates new instances each time it is called', correct: false),
      QuizOption(text: 'An anonymous class that can only be used once', correct: false),
      QuizOption(text: 'A static nested class inside the enclosing class', correct: false),
    ]),
    Quiz(question: 'What is the difference between const val and val in a companion object?', options: [
      QuizOption(text: 'const val is a compile-time constant inlined at call sites; val is computed at runtime', correct: true),
      QuizOption(text: 'const val is immutable; val can be changed after initialization', correct: false),
      QuizOption(text: 'const val works for all types; val only works for primitives', correct: false),
      QuizOption(text: 'They are identical — const is just a style hint', correct: false),
    ]),
    Quiz(question: 'When would you use an object expression?', options: [
      QuizOption(text: 'To create a one-off implementation of an interface without declaring a full class', correct: true),
      QuizOption(text: 'To create a singleton that persists across the entire app lifecycle', correct: false),
      QuizOption(text: 'To define static members accessible on the class name', correct: false),
      QuizOption(text: 'To create a data class with auto-generated equals and copy methods', correct: false),
    ]),
  ],
);
