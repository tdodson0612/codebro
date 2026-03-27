import '../../models/lesson.dart';
import '../../models/quiz.dart';

final kotlinLesson40 = Lesson(
  language: 'Kotlin',
  title: 'Best Practices and Idiomatic Kotlin',
  content: """
🎯 METAPHOR:
Idiomatic code is like a local speaking their native language
vs. a tourist translating word-for-word from a phrasebook.
Both communicate, but the local sounds natural, fluent, and
efficient. The tourist says "I want to have the buying of
one coffee please." The local says "One coffee, please."
Idiomatic Kotlin is the difference between Java-style code
ported to Kotlin, and code written the way Kotlin was
designed to be written — concise, expressive, safe, and
leveraging the full power of the language. It's not just
making it work. It's making it feel at home.

📖 EXPLANATION:
Idiomatic Kotlin means using the language's features as
intended — readable, concise, and safe. Here are the
most important patterns, anti-patterns, and decisions
that separate good Kotlin from great Kotlin.

─────────────────────────────────────
PREFER val OVER var:
─────────────────────────────────────
  ❌ var name = "Terry"    // mutable — why?
  ✅ val name = "Terry"    // immutable by default

Use var only when the value genuinely needs to change.
Immutability prevents bugs from unexpected mutation.

─────────────────────────────────────
USE TYPE INFERENCE:
─────────────────────────────────────
  ❌ val name: String = "Terry"        // redundant
  ✅ val name = "Terry"                // inferred

  ❌ val list: List<Int> = listOf(1, 2, 3)
  ✅ val list = listOf(1, 2, 3)

But DO add types for public API functions:
  fun calculateTax(income: Double): Double  // clear intent

─────────────────────────────────────
EXPRESSION BODIES:
─────────────────────────────────────
  ❌ fun isEven(n: Int): Boolean { return n % 2 == 0 }
  ✅ fun isEven(n: Int) = n % 2 == 0

  ❌ fun greet(name: String): String { return "Hello, \$name!" }
  ✅ fun greet(name: String) = "Hello, \$name!"

─────────────────────────────────────
USE when INSTEAD OF LONG if/else CHAINS:
─────────────────────────────────────
  ❌
  fun describe(n: Int): String {
      if (n < 0) return "negative"
      else if (n == 0) return "zero"
      else if (n < 10) return "small"
      else return "large"
  }

  ✅
  fun describe(n: Int) = when {
      n < 0  -> "negative"
      n == 0 -> "zero"
      n < 10 -> "small"
      else   -> "large"
  }

─────────────────────────────────────
STRING TEMPLATES OVER CONCATENATION:
─────────────────────────────────────
  ❌ println("Hello, " + name + "! You are " + age + " years old.")
  ✅ println("Hello, \$name! You are \$age years old.")

─────────────────────────────────────
USE DATA CLASSES FOR SIMPLE MODELS:
─────────────────────────────────────
  ❌ class User { var name = ""; var age = 0 }   // lots of boilerplate needed
  ✅ data class User(val name: String, val age: Int)  // equals/toString/copy free

─────────────────────────────────────
EXTENSION FUNCTIONS OVER UTILITY CLASSES:
─────────────────────────────────────
  ❌ class StringUtils { fun isPalindrome(s: String): Boolean { ... } }
     StringUtils().isPalindrome("racecar")

  ✅ fun String.isPalindrome() = this == this.reversed()
     "racecar".isPalindrome()

─────────────────────────────────────
NULL SAFETY IDIOMS:
─────────────────────────────────────
  ❌ if (name != null) name.length else 0
  ✅ name?.length ?: 0

  ❌ if (user != null) { sendEmail(user.email) }
  ✅ user?.let { sendEmail(it.email) }

  ❌ var result = ""
     if (user != null) result = user.name else result = "Unknown"
  ✅ val result = user?.name ?: "Unknown"

─────────────────────────────────────
COLLECTIONS — use the right operations:
─────────────────────────────────────
  ❌ val filtered = mutableListOf<User>()
     for (user in users) { if (user.age > 18) filtered.add(user) }

  ✅ val filtered = users.filter { it.age > 18 }

  ❌ var sum = 0
     for (item in items) { sum += item.price }

  ✅ val sum = items.sumOf { it.price }

─────────────────────────────────────
APPLY FOR CONFIGURATION:
─────────────────────────────────────
  ❌ val config = Config()
     config.host = "localhost"
     config.port = 8080
     config.debug = true

  ✅ val config = Config().apply {
         host = "localhost"
         port = 8080
         debug = true
     }

─────────────────────────────────────
AVOID PLATFORM TYPES — assign to nullable:
─────────────────────────────────────
  ❌ val path = System.getenv("PATH")         // platform type String!
  ✅ val path: String? = System.getenv("PATH")  // explicit nullable

─────────────────────────────────────
USE require AND check FOR VALIDATION:
─────────────────────────────────────
  ❌ if (age < 0) throw IllegalArgumentException("Age must be non-negative")
  ✅ require(age >= 0) { "Age must be non-negative" }

  ❌ if (!initialized) throw IllegalStateException("Not ready")
  ✅ check(initialized) { "Not ready" }

─────────────────────────────────────
DESTRUCTURING:
─────────────────────────────────────
  ❌ val firstName = person.first
     val lastName = person.second

  ✅ val (firstName, lastName) = person

  ❌ for (entry in map.entries) { println(entry.key + ": " + entry.value) }
  ✅ for ((key, value) in map) { println("\$key: \$value") }

💻 CODE:
// Demonstrating idiomatic vs non-idiomatic Kotlin

data class Person(val name: String, val age: Int, val email: String?)
data class Order(val id: Int, val product: String, val amount: Double, val isPaid: Boolean)

// ❌ Non-idiomatic
class NonIdiomatic {
    fun processOrders(orders: List<Order>): Double {
        var total = 0.0
        val paidOrders = mutableListOf<Order>()
        for (order in orders) {
            if (order.isPaid == true) {
                paidOrders.add(order)
            }
        }
        for (order in paidOrders) {
            total = total + order.amount
        }
        return total
    }

    fun getGreeting(person: Person?): String {
        if (person != null) {
            return "Hello, " + person.name + "!"
        } else {
            return "Hello, stranger!"
        }
    }

    fun describeAge(age: Int): String {
        if (age < 0) {
            return "invalid"
        } else if (age < 13) {
            return "child"
        } else if (age < 18) {
            return "teenager"
        } else if (age < 65) {
            return "adult"
        } else {
            return "senior"
        }
    }
}

// ✅ Idiomatic
class Idiomatic {
    fun processOrders(orders: List<Order>): Double =
        orders.filter { it.isPaid }.sumOf { it.amount }

    fun getGreeting(person: Person?): String =
        person?.let { "Hello,\${
it.name}!" } ?: "Hello, stranger!"

    fun describeAge(age: Int) = when {
        age < 0  -> "invalid"
        age < 13 -> "child"
        age < 18 -> "teenager"
        age < 65 -> "adult"
        else     -> "senior"
    }
}

// Extension functions over utility classes
fun String.isPalindrome() = this.lowercase() == this.lowercase().reversed()
fun String.words() = this.trim().split("\\s+".toRegex())
fun Double.formatAsCurrency() = "\$\${
"%.2f".format(this)}"
fun Int.pluralize(word: String) = "\$this\${
if (this == 1) word else word + "s"}"

// Idiomatic null handling
fun sendNotification(person: Person?) {
    person?.email?.let { email ->
        println("Sending to: \$email")
    } ?: println("No email — skipping notification")
}

// Idiomatic collection operations
fun analyzeOrders(orders: List<Order>) {
    val (paid, unpaid) = orders.partition { it.isPaid }

    val paidTotal = paid.sumOf { it.amount }
    val unpaidTotal = unpaid.sumOf { it.amount }

    val byProduct = orders.groupBy { it.product }

    println("Paid:\${
paid.size.pluralize("order")} =\${
paidTotal.formatAsCurrency()}")
    println("Unpaid:\${
unpaid.size.pluralize("order")} =\${
unpaidTotal.formatAsCurrency()}")
    println("Products:\${
byProduct.keys.sorted().joinToString(", ")}")

    byProduct.forEach { (product, productOrders) ->
        val total = productOrders.sumOf { it.amount }
        println("  \$product:\${
productOrders.size.pluralize("order")},\${
total.formatAsCurrency()}")
    }
}

fun main() {
    val orders = listOf(
        Order(1, "Keyboard", 79.99, true),
        Order(2, "Mouse", 29.99, false),
        Order(3, "Monitor", 299.99, true),
        Order(4, "Keyboard", 79.99, true),
        Order(5, "Headphones", 149.99, false),
        Order(6, "Mouse", 29.99, true)
    )

    val nonIdiom = NonIdiomatic()
    val idiom = Idiomatic()

    println("=== Non-idiomatic vs Idiomatic ===")
    println("Paid total (non-idiomatic):\${
nonIdiom.processOrders(orders)}")
    println("Paid total (idiomatic):    \${
idiom.processOrders(orders)}")

    val people = listOf(
        Person("Terry", 30, "terry@example.com"),
        Person("Sam", 25, null),
        null
    )

    println("\\n=== Greetings ===")
    people.forEach { println(idiom.getGreeting(it)) }

    println("\\n=== Age descriptions ===")
    listOf(-1, 5, 15, 30, 70).forEach { age ->
        println("  \$age →\${
idiom.describeAge(age)}")
    }

    println("\\n=== Extension functions ===")
    println("'racecar'.isPalindrome():\${
"racecar".isPalindrome()}")
    println("'hello'.isPalindrome():  \${
"hello".isPalindrome()}")
    println("Word count:\${
"Hello Kotlin World".words().size.pluralize("word")}")
    println("Price:\${
299.99.formatAsCurrency()}")

    println("\\n=== Notifications ===")
    people.forEach { sendNotification(it) }

    println("\\n=== Order analysis ===")
    analyzeOrders(orders)

    println("\\n=== Idiomatic tips summary ===")
    val tips = listOf(
        "Prefer val over var",
        "Use type inference",
        "Expression bodies for single-expression functions",
        "when over long if/else chains",
        "String templates over concatenation",
        "data class for models",
        "Extension functions over utility classes",
        "?.let {} for null-safe operations",
        "filter/map/sumOf over manual loops",
        "apply for object configuration",
        "require/check for validation",
        "Destructuring for pairs and data classes"
    )
    tips.forEachIndexed { i, tip -> println(" \${
i + 1}. \$tip") }
}

📝 KEY POINTS:
✅ val over var — immutability is default, mutation is explicit
✅ Type inference reduces noise — add types for public APIs only
✅ Expression bodies make simple functions one-liners
✅ when is more readable than long if/else chains
✅ String templates are cleaner than concatenation
✅ data class gives equals, hashCode, toString, copy for free
✅ Extension functions read like the type's own methods
✅ ?.let and ?: handle null checks expressively
✅ filter/map/sumOf are clearer than manual accumulation loops
✅ require/check are idiomatic validation — not raw throw
❌ Don't port Java patterns to Kotlin — learn the Kotlin way
❌ Don't use !! unless you're absolutely certain — it defeats null safety
❌ Don't ignore warnings — they usually point to non-idiomatic code
❌ Don't sacrifice readability for cleverness — idiomatic ≠ shortest
""",
  quiz: [
    Quiz(question: 'What is the idiomatic way to provide a default value when a nullable is null?', options: [
      QuizOption(text: 'Use the Elvis operator: value ?: default', correct: true),
      QuizOption(text: 'Use an if/else: if (value != null) value else default', correct: false),
      QuizOption(text: 'Use value.orDefault(default)', correct: false),
      QuizOption(text: 'Use value!! to force-unwrap and let it throw', correct: false),
    ]),
    Quiz(question: 'When should you prefer a when expression over an if/else chain?', options: [
      QuizOption(text: 'When there are 3 or more branches — when is more readable and exhaustive-checkable', correct: true),
      QuizOption(text: 'Only when matching against a single variable with exact values', correct: false),
      QuizOption(text: 'Never — if/else is always preferred for consistency', correct: false),
      QuizOption(text: 'Only inside lambda expressions — when cannot be used at the top level', correct: false),
    ]),
    Quiz(question: 'What is the idiomatic way to validate function arguments in Kotlin?', options: [
      QuizOption(text: 'require(condition) { "message" } — throws IllegalArgumentException if false', correct: true),
      QuizOption(text: 'assert(condition) — the standard validation mechanism', correct: false),
      QuizOption(text: 'if (!condition) throw Exception() — the explicit approach', correct: false),
      QuizOption(text: '@Validated annotation on the parameter', correct: false),
    ]),
  ],
);
