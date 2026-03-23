import '../../models/lesson.dart';
import '../../models/quiz.dart';

final kotlinLesson20 = Lesson(
  language: 'Kotlin',
  title: 'Extension Functions and Properties',
  content: """
🎯 METAPHOR:
Extension functions are like adding a new tool to a Swiss
Army knife — without opening the knife or touching the
factory that made it. Imagine you have a knife you love
but it's missing a screwdriver. Instead of sending it back
to the factory (editing the class) or buying a whole new
knife (subclassing), you just CLIP a screwdriver onto the
outside. It behaves exactly like it's part of the knife,
but you added it yourself, from the outside.
That's an extension function: bolt new functionality onto
an existing class without touching its source code.

📖 EXPLANATION:
Extension functions let you add new functions to ANY class —
even ones from the Kotlin standard library, Java, or
third-party libraries — without modifying the class itself
and without inheritance.

─────────────────────────────────────
SYNTAX:
─────────────────────────────────────
  fun ReceiverType.functionName(params): ReturnType {
      // 'this' refers to the receiver object
  }

  fun String.shout(): String = this.uppercase() + "!!!"
  fun Int.isEven(): Boolean = this % 2 == 0
  fun Double.round(decimals: Int): Double { ... }

  "hello".shout()   // HELLO!!!
  4.isEven()        // true

─────────────────────────────────────
this IN EXTENSION FUNCTIONS:
─────────────────────────────────────
Inside an extension function, 'this' refers to the
object the extension is called on (the "receiver"):

  fun List<Int>.secondOrNull(): Int? {
      return if (this.size >= 2) this[1] else null
  }

  listOf(10, 20, 30).secondOrNull()   // 20
  listOf(10).secondOrNull()           // null

─────────────────────────────────────
EXTENSION PROPERTIES:
─────────────────────────────────────
Add computed properties to existing classes:

  val String.wordCount: Int
      get() = this.split(" ").size

  val Int.isDivisibleByThree: Boolean
      get() = this % 3 == 0

  "hello world kotlin".wordCount   // 3
  9.isDivisibleByThree             // true

Extension properties CANNOT have backing fields —
they can only have getters (and sometimes setters).

─────────────────────────────────────
SCOPE OF EXTENSIONS:
─────────────────────────────────────
Extensions are resolved STATICALLY at compile time,
not dynamically at runtime. This means:

  ✅ Fast — no virtual dispatch overhead
  ❌ Cannot truly override a class's method
  ❌ If a class has a member with the same name, the
     MEMBER always wins over the extension

─────────────────────────────────────
EXTENSION FUNCTIONS ON NULLABLE TYPES:
─────────────────────────────────────
You can write extensions for nullable types — useful
for null-safe operations:

  fun String?.orDefault(default: String = ""): String {
      return this ?: default
  }

  val name: String? = null
  println(name.orDefault("Anonymous"))   // Anonymous

─────────────────────────────────────
COMMON KOTLIN STDLIB EXTENSIONS:
─────────────────────────────────────
Kotlin's standard library is largely built using
extensions on existing Java types:

  String:   .trim(), .split(), .toInt(), .padStart()
  Int:      .coerceIn(), .toDouble(), .toString()
  List:     .filter(), .map(), .first(), .zip()
  Any:      .also(), .let(), .run(), .apply(), .takeIf()

─────────────────────────────────────
SCOPE FUNCTIONS (quick preview):
─────────────────────────────────────
Kotlin has 5 scope functions — all extension-based:

  let    → transform the object, returns lambda result
  also   → side-effects on the object, returns the object
  apply  → configure the object, returns the object
  run    → transform, returns lambda result (like let but no 'it')
  with   → not an extension — but similar; used for grouping calls

These will be covered fully in the Scope Functions lesson.

💻 CODE:
// Extension functions on built-in types
fun String.isPalindrome(): Boolean {
    val cleaned = this.lowercase().filter { it.isLetter() }
    return cleaned == cleaned.reversed()
}

fun String.truncate(maxLength: Int, suffix: String = "..."): String {
    return if (this.length <= maxLength) this
    else this.take(maxLength) + suffix
}

fun Int.factorial(): Long {
    if (this < 0) throw IllegalArgumentException("No factorial for negative")
    var result = 1L
    for (i in 2..this) result *= i
    return result
}

fun Double.toCelsius(): Double = (this - 32) * 5 / 9
fun Double.toFahrenheit(): Double = this * 9 / 5 + 32

// Extension on a List
fun <T> List<T>.secondOrNull(): T? = if (size >= 2) this[1] else null
fun <T> List<T>.penultimateOrNull(): T? = if (size >= 2) this[size - 2] else null

// Extension property
val String.wordCount: Int
    get() = if (this.isBlank()) 0 else this.trim().split("\\s+".toRegex()).size

val String.initials: String
    get() = this.split(" ").filter { it.isNotBlank() }.map { it.first().uppercaseChar() }.joinToString("")

// Nullable extension
fun String?.orEmpty2(): String = this ?: ""
fun String?.isNullOrBlankSafe(): Boolean = this == null || this.isBlank()

// Extension on a custom class
data class Temperature(val value: Double, val unit: String)

fun Temperature.toKelvin(): Double {
    return when (unit) {
        "C" -> value + 273.15
        "F" -> (value - 32) * 5 / 9 + 273.15
        "K" -> value
        else -> throw IllegalArgumentException("Unknown unit: \$unit")
    }
}

fun main() {
    // String extensions
    println("racecar".isPalindrome())        // true
    println("Hello World".isPalindrome())    // false
    println("A man a plan a canal Panama".isPalindrome())  // true

    println("This is a very long sentence".truncate(15))   // This is a very...
    println("Short".truncate(20))   // Short

    println("Hello Kotlin World".wordCount)   // 3
    println("Terry Smith".initials)           // TS

    // Int extensions
    println(5.factorial())    // 120
    println(10.factorial())   // 3628800

    // Double extensions
    println(100.0.toCelsius())      // 37.77...
    println(37.78.toFahrenheit())   // 99.99...

    // List extensions
    val nums = listOf(10, 20, 30, 40, 50)
    println(nums.secondOrNull())       // 20
    println(nums.penultimateOrNull())  // 40
    println(emptyList<Int>().secondOrNull())   // null

    // Nullable extensions
    val nullStr: String? = null
    println(nullStr.orEmpty2())           // ""
    println(nullStr.isNullOrBlankSafe())  // true
    println("  ".isNullOrBlankSafe())     // true
    println("hello".isNullOrBlankSafe())  // false

    // Custom class extension
    val boilingC = Temperature(100.0, "C")
    val boilingF = Temperature(212.0, "F")
    println("\${boilingC.toKelvin()} K")   // 373.15 K
    println("\${boilingF.toKelvin()} K")   // 373.15 K
}

📝 KEY POINTS:
✅ Extension functions add functionality to ANY class externally
✅ 'this' inside the extension refers to the receiver object
✅ Extension properties can only have custom getters — no backing field
✅ Extensions are resolved statically — members always win over extensions
✅ You can write extensions for nullable types: fun String?.extension()
✅ Kotlin's stdlib (filter, map, etc.) is built largely on extensions
✅ Generic extensions work with any type: fun <T> List<T>.second()
❌ Extensions cannot access private members of the receiver class
❌ Extensions cannot truly override an existing member function
❌ Extension properties cannot store state — getters only
❌ Don't add extensions that should really be in the class itself
""",
  quiz: [
    Quiz(question: 'What does "this" refer to inside a Kotlin extension function?', options: [
      QuizOption(text: 'The object the extension function is called on (the receiver)', correct: true),
      QuizOption(text: 'The class where the extension function is defined', correct: false),
      QuizOption(text: 'The outer scope where the extension was declared', correct: false),
      QuizOption(text: 'The last argument passed to the extension function', correct: false),
    ]),
    Quiz(question: 'Can extension functions access private members of the class they extend?', options: [
      QuizOption(text: 'No — extensions are external and cannot access private members', correct: true),
      QuizOption(text: 'Yes — extension functions have full access to the class', correct: false),
      QuizOption(text: 'Only if the extension is defined in the same file as the class', correct: false),
      QuizOption(text: 'Only for extension properties, not extension functions', correct: false),
    ]),
    Quiz(question: 'If a class has a member function and an extension function with the same name and signature, which one wins?', options: [
      QuizOption(text: 'The member function always wins', correct: true),
      QuizOption(text: 'The extension function always wins', correct: false),
      QuizOption(text: 'The compiler throws an ambiguity error', correct: false),
      QuizOption(text: 'Whichever was defined last takes precedence', correct: false),
    ]),
  ],
);
