import '../../models/lesson.dart';
import '../../models/quiz.dart';

final kotlinLesson46 = Lesson(
  language: 'Kotlin',
  title: 'Packages, Imports, and Visibility Modifiers',
  content: """
🎯 METAPHOR:
Packages are like departments in a large corporation.
Marketing is one department, Engineering is another, Finance
is a third. Each department has its own filing system —
nobody from Marketing accidentally picks up an Engineering
report because they're in completely separate cabinets.
Imports are like internal transfer requests: "I need to
borrow something from Engineering — let me file a request
to access it." Visibility modifiers are the security badges:
some files are PUBLIC (anyone can see them), some are
INTERNAL (company employees only), some are PROTECTED
(managers and their teams only), and some are PRIVATE
(only the person who owns them can see them).

📖 EXPLANATION:
Packages organize code into namespaces. Visibility modifiers
control what can be accessed from where.

─────────────────────────────────────
PACKAGES:
─────────────────────────────────────
  // At the top of every file:
  package com.myapp.features.auth

  // Everything in this file belongs to that package.
  // You can access it from other files with the full name:
  // com.myapp.features.auth.AuthService

Files don't HAVE to match their directory — but they should.
By convention: package com.myapp.data lives in
src/main/kotlin/com/myapp/data/

─────────────────────────────────────
IMPORTS:
─────────────────────────────────────
  import kotlin.math.sqrt           // import one function
  import kotlin.math.*              // import all from package (star import)
  import java.util.ArrayList        // Java class
  import com.myapp.data.User        // your own class

  // Alias to avoid name conflict:
  import kotlin.math.PI as MathPI
  import com.myapp.PI as AppPI

  import java.util.Date as JavaDate
  import java.sql.Date as SqlDate

─────────────────────────────────────
DEFAULT IMPORTS — always available:
─────────────────────────────────────
These are imported automatically in every Kotlin file:
  kotlin.*
  kotlin.collections.*
  kotlin.comparisons.*
  kotlin.io.*
  kotlin.ranges.*
  kotlin.sequences.*
  kotlin.text.*
  kotlin.math.*      (on JVM)
  java.lang.*        (on JVM)

─────────────────────────────────────
VISIBILITY MODIFIERS:
─────────────────────────────────────
  Modifier    Visible to
  ─────────────────────────────────────────────────────
  public      Everyone (DEFAULT — Kotlin is open by default)
  internal    Same MODULE only (e.g., same Gradle/Maven module)
  protected   This class AND subclasses only
  private     This class or file ONLY

  // On class members:
  class BankAccount {
      public val owner: String = ""       // visible everywhere
      internal val accountId: Int = 0     // visible in same module
      protected var balance: Double = 0.0 // visible in subclasses
      private var pin: Int = 0            // visible only here
  }

  // On top-level declarations (functions, classes, properties):
  public fun globalUtil() { }        // visible everywhere
  internal fun moduleHelper() { }    // same module only
  private fun fileOnlyHelper() { }   // this file only
  // NOTE: protected is NOT allowed at top level

─────────────────────────────────────
MODULE — what is it?
─────────────────────────────────────
A "module" in Kotlin = a compilation unit:
  → An IntelliJ IDEA module
  → A Maven project
  → A Gradle source set
  → A single kotlinc compilation

internal is useful for library design: expose a public API
while keeping implementation helpers hidden from library users.

─────────────────────────────────────
VISIBILITY ON CONSTRUCTORS:
─────────────────────────────────────
  class Singleton private constructor() {
      companion object {
          val instance = Singleton()
      }
  }

  class Database internal constructor(val url: String)
  // Can only be constructed within the same module

─────────────────────────────────────
VISIBILITY AND INHERITANCE:
─────────────────────────────────────
  open class Parent {
      protected fun internalLogic() { }  // subclasses can see it
      private fun secretLogic() { }     // only Parent sees it
  }

  class Child : Parent() {
      fun doWork() {
          internalLogic()   // ✅ accessible — it's protected
          // secretLogic()  // ❌ NOT accessible — it's private
      }
  }

Overriding rules:
  ✅ Can make visibility MORE permissive (protected → public)
  ❌ Cannot make visibility LESS permissive (public → private)

─────────────────────────────────────
COMMON PATTERNS:
─────────────────────────────────────
  // Expose read-only property publicly, write only internally:
  var name: String = ""
      private set          // only this class can write

  // Public API with internal implementation:
  class UserRepository {
      fun getUser(id: Int): User? = fetchFromDb(id)   // public
      private fun fetchFromDb(id: Int): User? { ... } // private
  }

💻 CODE:
// Simulating a multi-file, multi-package structure in one file

// ─── PACKAGE: com.myapp.core ─────────────────────────

// Public — visible everywhere
class AppConfig {
    val version: String = "2.0.0"                    // public
    internal val buildNumber: Int = 42               // module only
    private val secretKey: String = "sk_live_abc123" // class only

    // Public getter for controlled access
    fun isProduction() = buildNumber > 100

    // Private implementation detail
    private fun loadSecrets() {
        println("Loading secrets... (private)")
    }

    fun initialize() {
        loadSecrets()   // private — only callable from here
        println("Initialized v\$version (build \$buildNumber)")
    }
}

// ─── VISIBILITY ON CONSTRUCTORS ───────────────────────

// Private constructor — only creatable via factory
class Token private constructor(val value: String, val expiresAt: Long) {

    val isExpired: Boolean
        get() = System.currentTimeMillis() > expiresAt

    companion object {
        fun create(value: String, ttlSeconds: Long): Token {
            val expiry = System.currentTimeMillis() + (ttlSeconds * 1000)
            return Token(value, expiry)
        }

        fun invalid(): Token = Token("", 0)
    }

    override fun toString() = "Token(\${value.take(8)}..., expired=\$isExpired)"
}

// ─── VISIBILITY IN CLASS HIERARCHY ───────────────────

open class Vehicle(val make: String) {
    val make2: String = make                         // public
    protected var fuelLevel: Double = 100.0          // subclasses only
    private var engineCode: String = "ENG-\$make"    // only Vehicle

    protected fun refuel(amount: Double) {
        fuelLevel = minOf(100.0, fuelLevel + amount)
        println("Refueled: now at \${"%.0f".format(fuelLevel)}%")
    }

    fun status(): String {
        // Can access all — we're inside Vehicle
        return "\$make | Fuel: \${"%.0f".format(fuelLevel)}% | Engine: \$engineCode"
    }
}

class ElectricCar(make: String) : Vehicle(make) {
    private var batteryLevel: Double = 95.0

    fun charge(amount: Double) {
        batteryLevel = minOf(100.0, batteryLevel + amount)
        fuelLevel = batteryLevel      // ✅ can access protected
        println("Charging \$make: battery at \${"%.0f".format(batteryLevel)}%")
    }

    override fun toString(): String {
        return "\$make Electric | Battery: \${"%.0f".format(batteryLevel)}% | Fuel level: \${"%.0f".format(fuelLevel)}%"
        // Cannot access engineCode — private to Vehicle ❌
    }
}

// ─── PRIVATE SET ──────────────────────────────────────

class Counter(initial: Int = 0) {
    var count: Int = initial
        private set   // external code can READ but not WRITE

    fun increment() { count++ }
    fun decrement() { if (count > 0) count-- }
    fun reset() { count = 0 }
}

// ─── IMPORT ALIAS SIMULATION ─────────────────────────

// Two different "User" classes from different "packages"
data class DatabaseUser(val id: Int, val name: String, val role: String)
data class ApiUser(val token: String, val name: String, val scopes: List<String>)

// Function that uses both — naming would clash without aliasing
fun syncUsers(dbUser: DatabaseUser, apiUser: ApiUser): Boolean {
    return dbUser.name == apiUser.name
}

fun main() {
    // Packages and visibility
    println("=== AppConfig visibility ===")
    val config = AppConfig()
    println("Version: \${config.version}")         // ✅ public
    println("Production: \${config.isProduction()}") // ✅ public method
    // config.secretKey — ❌ private, won't compile
    // config.buildNumber — ✅ accessible within same module
    config.initialize()

    // Private constructor
    println("\\n=== Private constructor ===")
    val token = Token.create("my_api_key_here", 3600)
    val expired = Token.invalid()
    println(token)
    println("Valid: \${!token.isExpired}")
    println(expired)
    println("Expired: \${expired.isExpired}")
    // Token("value", 0) — ❌ constructor is private

    // Inheritance and protected
    println("\\n=== Protected visibility ===")
    val car = ElectricCar("Tesla")
    println(car.status())     // ✅ public method
    car.charge(5.0)
    println(car)
    // car.fuelLevel — ❌ protected, not accessible here
    // car.refuel(10.0) — ❌ protected, not accessible here

    // Private set
    println("\\n=== Private set ===")
    val counter = Counter(10)
    println("Count: \${counter.count}")    // ✅ can read
    counter.increment()
    counter.increment()
    counter.increment()
    println("After 3 increments: \${counter.count}")
    // counter.count = 999 — ❌ private set, won't compile

    // Aliased types
    println("\\n=== Import aliases (simulated) ===")
    val dbUser = DatabaseUser(1, "Terry", "admin")
    val apiUser = ApiUser("tok_abc", "Terry", listOf("read", "write"))
    println("DB User:  \$dbUser")
    println("API User: \$apiUser")
    println("Names match: \${syncUsers(dbUser, apiUser)}")

    // Star imports — all of kotlin.math is available
    println("\\n=== Star import math functions ===")
    println("sqrt(144) = \${kotlin.math.sqrt(144.0)}")
    println("PI = \${"%.5f".format(kotlin.math.PI)}")
    println("abs(-42) = \${kotlin.math.abs(-42)}")
}

📝 KEY POINTS:
✅ Package declarations go at the top of every file
✅ Use import aliases (as) to resolve name conflicts
✅ public is the default modifier in Kotlin — not private like Java
✅ internal limits visibility to the same compilation module
✅ protected is only for class members — NOT for top-level declarations
✅ private on a top-level declaration = visible only in that file
✅ private set exposes a property as readable but not writable externally
✅ Private constructors enforce controlled construction (factory pattern)
✅ Overrides can widen visibility (protected → public) but not narrow it
❌ protected does NOT work on top-level functions or classes
❌ internal is not the same as package-private (Java) — it's module-scoped
❌ Star imports (import pkg.*) can cause name collisions — use selectively
❌ Don't expose more than necessary — default to private, open up as needed
""",
  quiz: [
    Quiz(question: 'What does the internal visibility modifier mean in Kotlin?', options: [
      QuizOption(text: 'The declaration is visible only within the same compilation module', correct: true),
      QuizOption(text: 'The declaration is visible only within the same package', correct: false),
      QuizOption(text: 'The declaration is visible only within the same file', correct: false),
      QuizOption(text: 'Internal is the same as protected — visible to subclasses', correct: false),
    ]),
    Quiz(question: 'What is the default visibility modifier in Kotlin?', options: [
      QuizOption(text: 'public — everything is visible everywhere by default', correct: true),
      QuizOption(text: 'private — everything is hidden by default', correct: false),
      QuizOption(text: 'internal — visible within the module by default', correct: false),
      QuizOption(text: 'protected — visible to subclasses by default', correct: false),
    ]),
    Quiz(question: 'What does private set on a property do?', options: [
      QuizOption(text: 'The property can be read publicly but only written within the class', correct: true),
      QuizOption(text: 'The property becomes completely private — read and write both restricted', correct: false),
      QuizOption(text: 'The property setter is hidden from subclasses only', correct: false),
      QuizOption(text: 'It makes the property val — preventing all reassignment', correct: false),
    ]),
  ],
);
