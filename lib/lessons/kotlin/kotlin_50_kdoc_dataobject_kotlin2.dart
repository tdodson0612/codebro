import '../../models/lesson.dart';
import '../../models/quiz.dart';

final kotlinLesson50 = Lesson(
  language: 'Kotlin',
  title: 'KDoc, data object, and Kotlin 2.0 Features',
  content: """
🎯 METAPHOR:
KDoc is like the instruction manual that ships with your
product — written specifically so that tools (IDEs, doc
generators) can read it and display helpful context.
Without it, your code is a device with no manual: it works,
but nobody knows HOW to use it without reading the source.
With KDoc, hovering over a function in an IDE shows the
description, parameter explanations, return value, and
examples — instantly. Your future self (and your teammates)
will be very grateful.

data object is the rare case where a singleton ALSO needs
to look good in logs — it gets toString() for free, just
like data class.

Kotlin 2.0 is the biggest Kotlin release in years —
a new compiler, smarter type inference, and new language
features that clean up common pain points.

📖 EXPLANATION:

─────────────────────────────────────
KDoc — Kotlin's documentation format:
─────────────────────────────────────
KDoc uses /** ... */ block comments with special tags.
Processed by Dokka (Kotlin's doc generator → HTML docs).

  /**
   * Brief one-line summary.
   *
   * Longer explanation here if needed.
   * Can span multiple paragraphs.
   *
   * @param name The user's display name
   * @param age The user's age in years
   * @return A formatted greeting string
   * @throws IllegalArgumentException if name is blank
   * @sample com.example.UserSamples.greetExample
   * @see User
   * @since 1.2.0
   */
  fun greet(name: String, age: Int): String { ... }

TAGS:
  @param name    → parameter description
  @return        → return value description
  @throws / @exception → exception that can be thrown
  @see           → cross-reference to other element
  @sample        → reference to a code sample
  @since         → version when feature was added
  @deprecated    → mark as deprecated with explanation
  @suppress      → suppress Dokka warning

MARKDOWN in KDoc:
  KDoc supports Markdown formatting:
  **bold**, *italic*, `code`, [links](url)
  ```kotlin
  // code blocks
  ```

─────────────────────────────────────
data object — Kotlin 1.9+:
─────────────────────────────────────
Before 1.9, a plain object had a confusing toString():
  object Loading → toString() = "Loading@7c30a502"

data object fixes this by generating a proper toString():
  data object Loading → toString() = "Loading"

  sealed class UiState {
      data object Idle : UiState()
      data object Loading : UiState()
      data class Success(val items: List<String>) : UiState()
      data class Error(val message: String) : UiState()
  }

  println(UiState.Loading)   // "Loading" (not the weird hash)

data object also:
  ✅ Generates toString() with the object's name
  ✅ Implements equals() and hashCode() consistently
  ✅ Works correctly across serialization (kotlinx.serialization)

─────────────────────────────────────
KOTLIN 2.0 — KEY CHANGES:
─────────────────────────────────────
Released May 2024. The K2 compiler is now stable.

1. K2 COMPILER — faster and smarter:
   → Up to 2x faster compilation
   → Improved type inference
   → More consistent behavior across platforms

2. SMART CAST IMPROVEMENTS:
   // Pre-2.0 — couldn't smart cast local var captured in lambda
   var x: Any = "hello"
   val check = { x is String }
   if (check()) println(x.length)  // error before 2.0

   // 2.0 — smarter flow analysis, more cases just work

3. NON-LOCAL BREAK AND CONTINUE (2.0):
   // Can now use break/continue inside lambdas passed to inline functions
   for (item in list) {
       items.forEach {
           if (it == target) break  // was an error before 2.0
       }
   }

4. CONTEXT RECEIVERS (experimental → stable path):
   context(Logger, Database)
   fun processUser(id: Int) {
       log("Processing \$id")     // Logger in context
       query("SELECT...")         // Database in context
   }

5. GUARD CONDITIONS IN when (2.1):
   when (result) {
       is Success if result.value > 0 -> println("Positive success")
       is Success -> println("Zero or negative success")
       is Error -> println("Error")
   }

6. KOTLIN 2.0 MULTIPLATFORM STABLE:
   → KMP is now officially stable (not experimental)
   → Better tooling and IDE support

─────────────────────────────────────
BEST PRACTICES FOR DOCUMENTATION:
─────────────────────────────────────
  ✅ Document public API (public/internal functions and classes)
  ✅ Focus on WHY and HOW TO USE, not just WHAT
  ✅ Include @throws when exceptions are expected
  ✅ Keep @param and @return concise
  ✅ Use @sample to link to runnable examples
  ❌ Don't document private implementation details
  ❌ Don't just repeat the function name: "Gets the name" for getName()
  ❌ Don't let docs go stale — keep them with code changes

💻 CODE:
// ─── KDoc examples ───────────────────────────────────

/**
 * Represents a monetary amount with a specific currency.
 *
 * Money is immutable — all arithmetic operations return new instances.
 * Amounts are stored as Long cents to avoid floating-point precision issues.
 *
 * @property amount The amount in the smallest currency unit (e.g., cents for USD)
 * @property currency The ISO 4217 currency code (e.g., "USD", "EUR")
 * @since 1.0.0
 * @see CurrencyConverter
 */
data class Money(val amount: Long, val currency: String) {

    /**
     * Adds another monetary amount to this one.
     *
     * @param other The amount to add
     * @return A new [Money] instance with the combined amount
     * @throws IllegalArgumentException if currencies don't match
     */
    operator fun plus(other: Money): Money {
        require(currency == other.currency) {
            "Cannot add \$currency and \${other.currency}"
        }
        return Money(amount + other.amount, currency)
    }

    /**
     * Applies a percentage discount to this amount.
     *
     * @param percent The discount percentage (0.0 to 100.0)
     * @return A new [Money] with the discounted amount
     * @throws IllegalArgumentException if percent is not in 0..100
     */
    fun discount(percent: Double): Money {
        require(percent in 0.0..100.0) { "Percent must be 0-100" }
        val discounted = (amount * (1 - percent / 100)).toLong()
        return Money(discounted, currency)
    }

    /**
     * Returns a human-readable string representation.
     *
     * Example output: "USD 12.99"
     */
    override fun toString(): String {
        val dollars = amount / 100
        val cents = amount % 100
        return "\$currency \$dollars.\${cents.toString().padStart(2, '0')}"
    }
}

/**
 * Extension function to parse a money string.
 *
 * @receiver A string in the format "USD 12.99"
 * @return A [Money] instance, or null if parsing fails
 */
fun String.toMoneyOrNull(): Money? {
    return try {
        val (currency, amount) = split(" ")
        val cents = (amount.toDouble() * 100).toLong()
        Money(cents, currency)
    } catch (e: Exception) {
        null
    }
}

// ─── data object (Kotlin 1.9+) ───────────────────────

sealed class NetworkState {
    data object Idle : NetworkState()
    data object Loading : NetworkState()
    data class Success(val data: String, val code: Int = 200) : NetworkState()
    data class Error(val message: String, val code: Int) : NetworkState()
}

sealed class AppEvent {
    data object AppStarted : AppEvent()
    data object UserLoggedOut : AppEvent()
    data class UserLoggedIn(val userId: String) : AppEvent()
    data class NavigateTo(val screen: String) : AppEvent()
}

// ─── Kotlin 2.0 smart casts demo ─────────────────────

interface Shape {
    val area: Double
}

data class Circle(val radius: Double) : Shape {
    override val area get() = kotlin.math.PI * radius * radius
}

data class Rectangle(val width: Double, val height: Double) : Shape {
    override val area get() = width * height
}

// 2.0-style: smarter flow analysis in when
fun describeShape(shape: Shape): String = when (shape) {
    is Circle    -> "Circle r=\${"%.2f".format(shape.radius)}, area=\${"%.2f".format(shape.area)}"
    is Rectangle -> "Rect \${shape.width}x\${shape.height}, area=\${"%.2f".format(shape.area)}"
    else         -> "Unknown shape"
}

// Guard-like conditions (simulating 2.1 guard conditions)
fun categorizeNumber(n: Int): String = when {
    n < 0         -> "negative"
    n == 0        -> "zero"
    n < 10        -> "single digit"
    n < 100       -> "double digit"
    n.isPrime()   -> "large prime"
    else          -> "large composite"
}

fun Int.isPrime(): Boolean {
    if (this < 2) return false
    return (2..kotlin.math.sqrt(this.toDouble()).toInt()).none { this % it == 0 }
}

fun main() {
    // KDoc — used by IDE, shown in hover tooltips
    println("=== Money with KDoc ===")
    val price = Money(1299, "USD")    // \$12.99
    val tax   = Money(104, "USD")     //  \$1.04
    val total = price + tax

    println("Price:    \$price")
    println("Tax:      \$tax")
    println("Total:    \$total")
    println("Discount: \${total.discount(10.0)}")

    val parsed = "EUR 49.99".toMoneyOrNull()
    println("Parsed:   \$parsed")
    println("Invalid: \${"not money".toMoneyOrNull()}")

    // data object
    println("\\n=== data object toString ===")
    val states: List<NetworkState> = listOf(
        NetworkState.Idle,
        NetworkState.Loading,
        NetworkState.Success("User data", 200),
        NetworkState.Error("Timeout", 408)
    )

    states.forEach { state ->
        val description = when (state) {
            is NetworkState.Idle    -> "\$state → waiting"
            is NetworkState.Loading -> "\$state → spinner"
            is NetworkState.Success -> "\$state → show content"
            is NetworkState.Error   -> "\$state → show error"
        }
        println(description)
    }

    println("\\n=== data object equality ===")
    println(NetworkState.Idle == NetworkState.Idle)       // true
    println(NetworkState.Loading == NetworkState.Loading)  // true

    // Events
    println("\\n=== AppEvent dispatch ===")
    val events: List<AppEvent> = listOf(
        AppEvent.AppStarted,
        AppEvent.UserLoggedIn("user_42"),
        AppEvent.NavigateTo("HomeScreen"),
        AppEvent.UserLoggedOut
    )
    events.forEach { event ->
        when (event) {
            AppEvent.AppStarted       -> println("App initialized")
            is AppEvent.UserLoggedIn  -> println("User \${event.userId} logged in")
            is AppEvent.NavigateTo    -> println("Navigating to: \${event.screen}")
            AppEvent.UserLoggedOut    -> println("User logged out")
        }
    }

    // Shape smart casts (2.0 improvements)
    println("\\n=== Smart casts ===")
    val shapes: List<Shape> = listOf(
        Circle(5.0),
        Rectangle(4.0, 6.0),
        Circle(1.0),
        Rectangle(10.0, 2.0)
    )
    shapes.forEach { println(describeShape(it)) }

    // Number categorization
    println("\\n=== Number categorization ===")
    listOf(-5, 0, 7, 42, 97, 100, 1009).forEach { n ->
        println("  \$n → \${categorizeNumber(n)}")
    }
}

📝 KEY POINTS:
✅ KDoc uses /** */ with @param, @return, @throws, @since tags
✅ KDoc supports Markdown — use **bold**, `code`, and links
✅ data object (1.9+) generates a clean toString() showing the name
✅ Use data object for singleton sealed class variants that need good logging
✅ data object equals/hashCode work correctly for serialization and comparison
✅ Kotlin 2.0 K2 compiler is faster (up to 2x) with smarter type inference
✅ KMP became officially stable in Kotlin 2.0
✅ Guard conditions in when (2.1): is Success if result.value > 0 ->
✅ Document your public API — KDoc is read by IDEs and Dokka
❌ Don't use plain object in sealed classes where toString() will be logged
❌ KDoc tags are case-sensitive: @param not @Param
❌ Kotlin 2.0 context receivers are still experimental — use cautiously
❌ Don't skip documentation for public libraries — Dokka generates your website
""",
  quiz: [
    Quiz(question: 'What does data object provide that a plain object does not?', options: [
      QuizOption(text: 'A clean toString() showing the object\'s name, plus consistent equals() and hashCode()', correct: true),
      QuizOption(text: 'The ability to have properties and functions', correct: false),
      QuizOption(text: 'A copy() function for creating modified versions', correct: false),
      QuizOption(text: 'Automatic serialization support without any configuration', correct: false),
    ]),
    Quiz(question: 'What KDoc tag documents the value a function returns?', options: [
      QuizOption(text: '@return', correct: true),
      QuizOption(text: '@returns', correct: false),
      QuizOption(text: '@result', correct: false),
      QuizOption(text: '@output', correct: false),
    ]),
    Quiz(question: 'What was the headline improvement in the Kotlin 2.0 release?', options: [
      QuizOption(text: 'The K2 compiler became stable, delivering up to 2x faster compilation and smarter type inference', correct: true),
      QuizOption(text: 'Kotlin gained full support for native iOS development without any wrappers', correct: false),
      QuizOption(text: 'Coroutines were added to the standard library for the first time', correct: false),
      QuizOption(text: 'Kotlin added Python-style syntax for variable declarations', correct: false),
    ]),
  ],
);