import '../../models/lesson.dart';
import '../../models/quiz.dart';

final kotlinLesson37 = Lesson(
  language: 'Kotlin',
  title: 'Inline Classes and Value Classes',
  content: """
🎯 METAPHOR:
A value class is like a name tag at a conference. The tag
says "Hello, my name is UserId: 42." Without the tag,
"42" is just a number — it could be an age, a score, a
count of anything. With the tag, it's SPECIFICALLY a user
ID. The tag adds meaning and prevents errors (you can't
accidentally pass a score where a user ID is expected).
But here's the magic: the compiler REMOVES the tag at
runtime and just uses the number underneath — zero overhead,
full safety. The tag is there for you at compile time
but vanishes in production.

📖 EXPLANATION:
Value classes (formerly called inline classes) wrap a single
value and give it a specific type, preventing misuse — while
being optimized by the compiler to use the raw value at
runtime, with zero boxing overhead.

─────────────────────────────────────
THE PROBLEM THEY SOLVE:
─────────────────────────────────────
  // All three are Strings — easy to mix up!
  fun sendEmail(userId: String, email: String, templateId: String) {}

  // Easy to accidentally call in wrong order:
  sendEmail(email, userId, templateId)   // WRONG — no compile error!

  // With value classes — type-safe!
  fun sendEmail(userId: UserId, email: Email, templateId: TemplateId) {}
  // Now the compiler catches argument order mistakes

─────────────────────────────────────
DECLARING A VALUE CLASS:
─────────────────────────────────────
  @JvmInline
  value class UserId(val value: Int)

  @JvmInline
  value class Email(val value: String)

  @JvmInline
  value class Kilograms(val value: Double)

  val id = UserId(42)
  val email = Email("terry@example.com")

  // At runtime: these are just Int and String
  // At compile time: they are distinct types

─────────────────────────────────────
VALUE CLASS FEATURES:
─────────────────────────────────────
  ✅ Can have functions (methods)
  ✅ Can implement interfaces
  ✅ Can have computed properties
  ✅ Can have an init block for validation
  ❌ Cannot have var properties
  ❌ Cannot have additional val properties (only one val)
  ❌ Cannot be extended (they are final)
  ❌ Cannot have a secondary constructor (only one val in primary)

─────────────────────────────────────
ADDING BEHAVIOR:
─────────────────────────────────────
  @JvmInline
  value class Temperature(val celsius: Double) {
      val fahrenheit: Double get() = celsius * 9 / 5 + 32
      val kelvin: Double get() = celsius + 273.15

      fun isAboveBoiling() = celsius > 100.0
      fun isBelowFreezing() = celsius < 0.0

      override fun toString() = "\${celsius}°C"
  }

─────────────────────────────────────
VALIDATION IN INIT:
─────────────────────────────────────
  @JvmInline
  value class Percentage(val value: Int) {
      init {
          require(value in 0..100) {
              "Percentage must be 0-100, got \$value"
          }
      }
  }

  Percentage(75)    // OK
  Percentage(150)   // throws IllegalArgumentException

─────────────────────────────────────
INTERFACE IMPLEMENTATION:
─────────────────────────────────────
  interface Displayable {
      fun display(): String
  }

  @JvmInline
  value class ProductCode(val code: String) : Displayable {
      override fun display() = "Product #\$code"
      fun isValid() = code.matches(Regex("[A-Z]{3}-\\d{4}"))
  }

─────────────────────────────────────
WHEN BOXING OCCURS:
─────────────────────────────────────
Value classes are unboxed (just the raw value) in most cases.
Boxing occurs when:
  • Used as a nullable type: UserId?
  • Used as a generic type: List<UserId>
  • Used where Any is expected

  val id: UserId = UserId(1)    // unboxed — just Int at runtime
  val id: UserId? = UserId(1)   // boxed — wrapped object at runtime

─────────────────────────────────────
TYPEALIAS vs VALUE CLASS:
─────────────────────────────────────
  typealias UserId = Int     // just a name alias — NOT a new type
  value class UserId(val value: Int)  // ACTUAL new type

  // typealias: UserId and Int are interchangeable — no safety
  // value class: UserId and Int are different types — compile errors on mixup

💻 CODE:
// ─── Domain value types ──────────────────────────────

@JvmInline
value class UserId(val value: Int) {
    init { require(value > 0) { "UserId must be positive" } }
    override fun toString() = "User#\$value"
}

@JvmInline
value class Email(val value: String) {
    init {
        require(value.contains("@") && value.contains(".")) {
            "Invalid email: \$value"
        }
    }
    val domain: String get() = value.substringAfter("@")
    override fun toString() = value
}

@JvmInline
value class Meters(val value: Double) {
    val kilometers: Double get() = value / 1000
    val miles: Double get() = value * 0.000621371
    operator fun plus(other: Meters) = Meters(value + other.value)
    operator fun minus(other: Meters) = Meters(value - other.value)
    operator fun times(factor: Double) = Meters(value * factor)
    override fun toString() = "\${value}m"
}

@JvmInline
value class Percentage(val value: Double) {
    init { require(value in 0.0..100.0) { "Percentage out of range: \$value" } }
    val asDecimal: Double get() = value / 100.0
    override fun toString() = "\${value}%"
}

@JvmInline
value class ProductCode(val code: String) {
    val isValid: Boolean get() = code.matches(Regex("[A-Z]{2}\\d{4}"))
    val category: String get() = code.take(2)
    val number: Int get() = code.drop(2).toInt()
    override fun toString() = code
}

// ─── Functions that CANNOT be called wrong ───────────

data class User(val id: UserId, val email: Email, val name: String)

fun sendEmail(to: Email, subject: String, body: String) {
    println("Sending '\$subject' to \$to")
}

fun processOrder(userId: UserId, productCode: ProductCode, discount: Percentage) {
    println("Order for \$userId: product=\$productCode, discount=\$discount")
    println("  Discount as decimal: \${discount.asDecimal}")
}

fun calculateDistance(from: Meters, to: Meters): Meters {
    return (to - from).let { diff ->
        Meters(Math.abs(diff.value))
    }
}

fun main() {
    // UserId
    println("=== UserId ===")
    val id = UserId(42)
    println(id)

    try { UserId(-1) } catch (e: IllegalArgumentException) { println("Caught: \${e.message}") }

    // Email
    println("\\n=== Email ===")
    val email = Email("terry@example.com")
    println("Email: \$email")
    println("Domain: \${email.domain}")

    try { Email("notanemail") } catch (e: IllegalArgumentException) { println("Caught: \${e.message}") }

    // Meters
    println("\\n=== Meters ===")
    val marathon = Meters(42195.0)
    println("Marathon: \$marathon")
    println("  = \${"%.3f".format(marathon.kilometers)} km")
    println("  = \${"%.3f".format(marathon.miles)} miles")

    val lap = Meters(400.0)
    val halfMarathon = marathon * 0.5
    println("Half marathon: \$halfMarathon")
    println("Laps to complete: \${"%.1f".format(halfMarathon.value / lap.value)}")

    // Type safety — compile-time errors prevent mixups
    println("\\n=== Type safety ===")
    val user = User(
        id = UserId(1),
        email = Email("terry@example.com"),
        name = "Terry"
    )
    println(user)

    // These calls are type-safe — wrong order = compile error
    sendEmail(
        to = Email("sam@example.com"),
        subject = "Hello!",
        body = "Kotlin value classes are great."
    )

    processOrder(
        userId = UserId(42),
        productCode = ProductCode("AB1234"),
        discount = Percentage(15.0)
    )

    // ProductCode
    println("\\n=== ProductCode ===")
    val codes = listOf(
        ProductCode("AB1234"),
        ProductCode("CD5678"),
        ProductCode("EF9999")
    )
    codes.forEach { code ->
        println("\$code → valid=\${code.isValid}, category=\${code.category}, number=\${code.number}")
    }

    // Distance calculation
    println("\\n=== Distance ===")
    val start = Meters(0.0)
    val end = Meters(5000.0)
    val dist = calculateDistance(start, end)
    println("Distance: \$dist (\${"%.2f".format(dist.kilometers)}km)")
}

📝 KEY POINTS:
✅ Value classes add compile-time type safety with zero runtime overhead
✅ @JvmInline is required on JVM targets
✅ Use init { require(...) } for validation at construction time
✅ Value classes can have computed properties and functions
✅ Value classes can implement interfaces
✅ typealias is just an alias — value class is a real new type
✅ Prevents argument order bugs for functions with multiple same-typed params
✅ Great for domain primitives: UserId, Email, Meters, Percentage
❌ Value classes must have exactly ONE val property in primary constructor
❌ Cannot extend from value classes — they are final
❌ Boxing happens when used as nullable or generic type — small cost
❌ Don't use value classes for everything — only where type safety adds value
""",
  quiz: [
    Quiz(question: 'What is the main advantage of a value class over a typealias?', options: [
      QuizOption(text: 'A value class creates a distinct new type, preventing accidental mixing; a typealias is just a name for the same type', correct: true),
      QuizOption(text: 'Value classes are faster at runtime than typealiases', correct: false),
      QuizOption(text: 'Value classes support null safety; typealiases do not', correct: false),
      QuizOption(text: 'Value classes can have multiple properties; typealiases cannot', correct: false),
    ]),
    Quiz(question: 'What annotation is required on value classes targeting the JVM?', options: [
      QuizOption(text: '@JvmInline', correct: true),
      QuizOption(text: '@JvmValue', correct: false),
      QuizOption(text: '@Inline', correct: false),
      QuizOption(text: '@Primitive', correct: false),
    ]),
    Quiz(question: 'When does a value class get "boxed" (wrapped as an object) at runtime?', options: [
      QuizOption(text: 'When used as a nullable type or as a generic type parameter', correct: true),
      QuizOption(text: 'Whenever the value class is passed to any function', correct: false),
      QuizOption(text: 'When the value class implements an interface', correct: false),
      QuizOption(text: 'Value classes are always boxed — the optimization is only at the source level', correct: false),
    ]),
  ],
);