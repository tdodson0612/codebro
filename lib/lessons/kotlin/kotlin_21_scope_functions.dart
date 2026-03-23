import '../../models/lesson.dart';
import '../../models/quiz.dart';

final kotlinLesson21 = Lesson(
  language: 'Kotlin',
  title: 'Scope Functions: let, apply, run, also, with',
  content: """
🎯 METAPHOR:
Scope functions are like hiring a personal assistant for an
object — temporarily. You hand your object to the assistant
and say: "While you have it, do these things." The assistant
works, then hands something back — either the SAME object
(apply, also) or the RESULT of the work (let, run, with).
The difference between them is: do they use 'this' or 'it'
to refer to the object? And what do they return?
Five assistants, five slightly different job descriptions.

📖 EXPLANATION:
Scope functions execute a block of code with an object
in scope, eliminating repeated variable references and
enabling expressive configuration chains.

─────────────────────────────────────
THE FIVE SCOPE FUNCTIONS:
─────────────────────────────────────
  Function  Object ref  Returns          Use for
  ──────────────────────────────────────────────────
  let       it          lambda result    null checks, transforms
  also      it          the object       side effects, debugging
  apply     this        the object       object configuration
  run       this        lambda result    init + compute result
  with      this        lambda result    grouping calls (not ext)

─────────────────────────────────────
let — transform or null-check:
─────────────────────────────────────
Object referenced as 'it'. Returns lambda result.
Most common use: safe null handling with ?.let { }

  val name: String? = "Terry"
  val length = name?.let {
      println("Name is: \$it")
      it.length            // returned from let
  }
  // length = 5, or null if name was null

Also great for chaining transformations:
  val result = "  hello world  "
      .let { it.trim() }
      .let { it.split(" ") }
      .let { it.map { word -> word.uppercase() } }

─────────────────────────────────────
also — side effects, keep the object:
─────────────────────────────────────
Object referenced as 'it'. Returns THE OBJECT.
Use for debugging, logging — "do this too, then continue."

  val list = mutableListOf(1, 2, 3)
      .also { println("Before: \$it") }

  list.add(4)
  list.also { println("After: \$it") }

Think of also as "and also do this while you're at it."

─────────────────────────────────────
apply — configure an object:
─────────────────────────────────────
Object referenced as 'this'. Returns THE OBJECT.
Perfect for configuring/building an object.
'this' is implicit — you can omit it.

  val user = User().apply {
      name = "Terry"       // this.name = "Terry"
      age = 30             // this.age = 30
      email = "t@t.com"    // this.email = "..."
  }

This is the builder pattern without a builder class.

─────────────────────────────────────
run — initialize and compute:
─────────────────────────────────────
Object referenced as 'this'. Returns LAMBDA RESULT.
Like apply but you care about the return value.

  val greeting = user.run {
      "Hello, \$name! You are \$age years old."
  }

Also works as a standalone block (not extension):
  val result = run {
      val x = 10
      val y = 20
      x + y   // returns 30
  }

─────────────────────────────────────
with — grouping calls on an object:
─────────────────────────────────────
NOT an extension function — takes the object as first arg.
Object referenced as 'this'. Returns LAMBDA RESULT.
Best for: "With this object, do all these things."

  val info = with(user) {
      "Name: \$name, Age: \$age"   // this.name, this.age
  }

─────────────────────────────────────
CHOOSING THE RIGHT ONE:
─────────────────────────────────────
  Configure an object?          → apply
  Transform and return result?  → let or run
  Add side effects (log/debug)? → also
  Group operations, get result? → run or with
  Null-safe transformation?     → ?.let { }

─────────────────────────────────────
CHAINING SCOPE FUNCTIONS:
─────────────────────────────────────
  val result = fetchUser()
      ?.also { log("Fetched: \$it") }
      ?.let { processUser(it) }
      ?: defaultUser()

💻 CODE:
data class User(
    var name: String = "",
    var age: Int = 0,
    var email: String = "",
    var isVerified: Boolean = false
)

data class Config(
    var host: String = "localhost",
    var port: Int = 8080,
    var timeout: Int = 30,
    var debug: Boolean = false
)

fun fetchUser(id: Int): User? = if (id > 0) User("Terry", 30, "t@t.com") else null

fun main() {
    // apply — configure objects (returns the object)
    val user = User().apply {
        name = "Terry"
        age = 30
        email = "terry@example.com"
        isVerified = true
    }
    println(user)

    val config = Config().apply {
        host = "api.myapp.com"
        port = 443
        timeout = 60
        debug = false
    }
    println(config)

    // let — null-safe transform (returns lambda result)
    val maybeUser: User? = fetchUser(1)
    val greeting = maybeUser?.let {
        "Welcome back, \${it.name}! (age \${it.age})"
    } ?: "No user found"
    println(greeting)

    val noUser: User? = fetchUser(-1)
    val msg = noUser?.let { "Found: \${it.name}" } ?: "User not found"
    println(msg)

    // also — side effects (returns the object)
    val numbers = mutableListOf(3, 1, 4, 1, 5, 9, 2, 6)
        .also { println("Original: \$it") }
    numbers.sort()
    numbers.also { println("Sorted:   \$it") }

    // run — init and compute result
    val summary = user.run {
        val ageStatus = if (age >= 18) "adult" else "minor"
        val verifyStatus = if (isVerified) "✅ verified" else "❌ unverified"
        "\$name is a \$ageStatus — \$verifyStatus"
    }
    println(summary)

    // run as standalone block
    val distance = run {
        val dx = 3.0
        val dy = 4.0
        Math.sqrt(dx * dx + dy * dy)   // Pythagorean theorem
    }
    println("Distance: \$distance")   // 5.0

    // with — group operations, get result
    val report = with(user) {
        buildString {
            appendLine("=== User Report ===")
            appendLine("Name:     \$name")
            appendLine("Age:      \$age")
            appendLine("Email:    \$email")
            appendLine("Verified: \$isVerified")
        }
    }
    println(report)

    // Chaining scope functions
    val processedName = fetchUser(1)
        ?.also { println("Fetched user: \${it.name}") }
        ?.let { it.name.uppercase() }
        ?.also { println("Processed name: \$it") }
        ?: "UNKNOWN"
    println("Final: \$processedName")

    // apply for building — very common in Android
    val configuredList = mutableListOf<String>().apply {
        add("first")
        add("second")
        add("third")
        sortDescending()
    }
    println(configuredList)   // [third, second, first]
}

📝 KEY POINTS:
✅ apply → configure object, returns object, uses this
✅ let → transform, returns result, uses it — best for ?.let {}
✅ also → side effects, returns object, uses it
✅ run → compute result, returns result, uses this
✅ with → group calls on object, returns result, uses this
✅ Chain scope functions for readable data pipelines
✅ also is perfect for inserting logging/debugging mid-chain
✅ apply is the idiomatic Kotlin way to configure objects
❌ Don't use scope functions just to show off — use when they
   genuinely improve readability
❌ Avoid nesting scope functions more than 2 levels deep
❌ Don't mix up which functions use 'it' vs 'this'
❌ run and with are easy to confuse — run is an extension,
   with takes the object as its first argument
""",
  quiz: [
    Quiz(question: 'Which scope function is best for configuring an object after creation?', options: [
      QuizOption(text: 'apply — it returns the object and uses this for the receiver', correct: true),
      QuizOption(text: 'let — it returns the object and uses it for the receiver', correct: false),
      QuizOption(text: 'also — it returns the result of the lambda', correct: false),
      QuizOption(text: 'run — it takes the object as the first argument', correct: false),
    ]),
    Quiz(question: 'What does ?.let { } accomplish that a plain if-check does not?', options: [
      QuizOption(text: 'It executes a block only if the value is non-null and returns the lambda result or null', correct: true),
      QuizOption(text: 'It throws an exception if the value is null instead of skipping', correct: false),
      QuizOption(text: 'It automatically converts the nullable type to a non-nullable one', correct: false),
      QuizOption(text: 'It is just stylistic — there is no functional difference from if-not-null', correct: false),
    ]),
    Quiz(question: 'Which scope function is best for adding a logging or debugging step in the middle of a chain?', options: [
      QuizOption(text: 'also — it performs a side effect and passes the original object through unchanged', correct: true),
      QuizOption(text: 'let — it transforms the value and passes the result through', correct: false),
      QuizOption(text: 'apply — it configures the object and returns it', correct: false),
      QuizOption(text: 'run — it executes a block and returns the result', correct: false),
    ]),
  ],
);
