import '../../models/lesson.dart';
import '../../models/quiz.dart';

final kotlinLesson34 = Lesson(
  language: 'Kotlin',
  title: 'Kotlin and Java Interoperability',
  content: """
🎯 METAPHOR:
Kotlin/Java interop is like a bilingual office where some
employees speak English (Java) and some speak French
(Kotlin). They work in the same building, share the same
files, and can collaborate on any project. A French speaker
can read any English document and vice versa. Sometimes
a bilingual person (Kotlin's @Jvm annotations) has to do
a bit of translation to make a memo written in French
perfectly clear to the English readers, and the other way
around. The whole office runs smoothly — but knowing the
translation rules prevents misunderstandings.

📖 EXPLANATION:
Kotlin compiles to JVM bytecode and is 100% interoperable
with Java. You can call Java code from Kotlin and Kotlin
code from Java seamlessly — with a few caveats.

─────────────────────────────────────
CALLING JAVA FROM KOTLIN:
─────────────────────────────────────
Just use Java classes directly — no import tricks needed.

  // Using Java's ArrayList
  val list = java.util.ArrayList<String>()
  list.add("Hello")

  // Using Java's Date
  val now = java.util.Date()
  println(now)

  // Java standard library is available everywhere
  import java.io.File
  import java.util.concurrent.ConcurrentHashMap
  import java.time.LocalDate

  val today = LocalDate.now()
  println(today)

─────────────────────────────────────
NULL HANDLING — Platform Types:
─────────────────────────────────────
Java has no null safety. When you call Java code that
returns an object, Kotlin doesn't know if it's nullable.
These are called "platform types" — written as T! in
error messages.

  val javaString: String! = someJavaMethod()  // T! = could be null

  // Options:
  val safe: String? = javaString   // treat as nullable (safe)
  val unsafe: String = javaString  // treat as non-null (risky!)

Best practice: assign Java returns to nullable Kotlin types.

─────────────────────────────────────
CALLING KOTLIN FROM JAVA — common issues:
─────────────────────────────────────
Some Kotlin features need help to be Java-friendly:

1. Top-level functions → compiled as static methods
   in a class named FileNameKt:
   // Kotlin: myUtils.kt
   fun greet() = println("Hello")

   // Java:
   MyUtilsKt.greet();

2. Companion object functions → not static by default:
   // Kotlin:
   class User { companion object { fun create() = User() } }

   // Java:
   User.Companion.create();  // awkward!

   // Fix with @JvmStatic:
   class User { companion object { @JvmStatic fun create() = User() } }
   User.create();  // now works like Java static

3. Default parameters → Java sees ONE overload only:
   // Fix with @JvmOverloads
   @JvmOverloads fun greet(name: String = "World") = "Hello, \$name!"

4. Properties → compiled to get/set methods:
   // Kotlin property 'name' becomes getName()/setName() in Java

─────────────────────────────────────
KEY @Jvm ANNOTATIONS:
─────────────────────────────────────
  @JvmStatic    → expose companion member as Java static method
  @JvmField     → expose property as public field (no getter/setter)
  @JvmOverloads → generate Java overloads for default parameters
  @JvmName      → rename the compiled class or method for Java
  @JvmDefault   → interface method with default implementation
  @Throws       → declare checked exceptions for Java callers

  @Throws(IOException::class)
  fun readFile(path: String): String = File(path).readText()

─────────────────────────────────────
KOTLIN-SPECIFIC FEATURES IN JAVA:
─────────────────────────────────────
  Kotlin feature   → How Java sees it
  ─────────────────────────────────────────
  data class       → Java class with equals/hashCode/toString
  object (singleton) → class with INSTANCE static field
  extension fn     → static method with receiver as first param
  sealed class     → abstract class with nested subclasses
  inline class     → typically the wrapped type directly

─────────────────────────────────────
USING JAVA COLLECTIONS IN KOTLIN:
─────────────────────────────────────
Kotlin's List, Map, Set are backed by Java's collections.
There's no conversion needed in most cases:

  val javaList: java.util.List<String> = arrayListOf("a", "b")
  val kotlinList: List<String> = javaList  // direct assignment

  // But Java collections are always mutable
  // Kotlin's read-only view doesn't prevent mutation via Java

─────────────────────────────────────
COMMON JAVA TYPES IN KOTLIN:
─────────────────────────────────────
  Java           Kotlin equivalent
  ──────────────────────────────────
  int            Int
  Integer        Int? (nullable)
  String         String
  Object         Any
  void           Unit
  Throwable      Throwable

💻 CODE:
import java.time.LocalDate
import java.time.format.DateTimeFormatter
import java.util.concurrent.ConcurrentHashMap
import java.util.regex.Pattern

// Kotlin code designed to be Java-friendly
class ApiClient(val baseUrl: String) {

    companion object {
        // @JvmStatic makes this callable as ApiClient.create() from Java
        @JvmStatic
        fun create(baseUrl: String) = ApiClient(baseUrl)

        @JvmField
        val DEFAULT_TIMEOUT = 30_000  // Java sees this as a plain field
    }

    // @JvmOverloads generates Java overloads for default params
    @JvmOverloads
    fun get(endpoint: String, timeout: Int = DEFAULT_TIMEOUT, retries: Int = 3): String {
        return "GET \$baseUrl/\$endpoint (timeout=\${timeout}ms, retries=\$retries)"
    }

    // @Throws declares checked exceptions Java callers must handle
    @Throws(IllegalArgumentException::class)
    fun post(endpoint: String, body: String): String {
        require(body.isNotBlank()) { "Body cannot be blank" }
        return "POST \$baseUrl/\$endpoint with body: \$body"
    }
}

// Using Java types naturally in Kotlin
fun javaTypesDemo() {
    println("=== Java types in Kotlin ===")

    // Java's LocalDate
    val today = LocalDate.now()
    val formatter = DateTimeFormatter.ofPattern("MMMM d, yyyy")
    println("Today: \${today.format(formatter)}")

    val birthday = LocalDate.of(1990, 6, 15)
    val age = today.year - birthday.year
    println("Age: ~\$age years")

    // ConcurrentHashMap (thread-safe map from Java)
    val cache = ConcurrentHashMap<String, Int>()
    cache["users"] = 150
    cache["products"] = 4200
    cache["orders"] = 830
    println("\\nCache: \$cache")
    println("Users: \${cache["users"]}")

    // Java regex
    val emailPattern = Pattern.compile("[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}")
    val emails = listOf("valid@test.com", "invalid-email", "another@valid.org")
    emails.forEach { email ->
        val valid = emailPattern.matcher(email).matches()
        println("\$email: \${if (valid) "✅" else "❌"}")
    }

    // Java's StringBuilder
    val sb = StringBuilder()
    repeat(5) { i ->
        sb.append("Item \${i + 1}")
        if (i < 4) sb.append(", ")
    }
    println("\\nBuilt: \$sb")
}

// Handling platform types safely
fun platformTypeSafety() {
    println("\\n=== Platform type safety ===")

    // System.getenv() returns String? in reality
    val path: String? = System.getenv("PATH")
    println("PATH exists: \${path != null}")
    println("PATH length: \${path?.length ?: 0}")

    // System.getProperty returns String?
    val osName: String? = System.getProperty("os.name")
    val javaVersion: String? = System.getProperty("java.version")
    println("OS: \${osName ?: "Unknown"}")
    println("Java: \${javaVersion ?: "Unknown"}")
}

fun main() {
    // ApiClient — Kotlin class with Java-friendly annotations
    println("=== ApiClient demo ===")
    val client = ApiClient("https://api.example.com")
    // or from Java: ApiClient.create("https://api.example.com")

    println(client.get("users"))
    println(client.get("products", timeout = 5000))
    println(client.get("orders", timeout = 10000, retries = 5))

    try {
        println(client.post("data", ""))
    } catch (e: IllegalArgumentException) {
        println("Caught: \${e.message}")
    }

    println(client.post("data", "{\\"key\\": \\"value\\"}"))

    javaTypesDemo()
    platformTypeSafety()

    // Extension function on Java class
    println("\\n=== Extensions on Java types ===")
    fun String.isValidEmail(): Boolean =
        contains("@") && contains(".") && length > 5

    fun Int.toBinaryString(): String = Integer.toBinaryString(this)

    println("terry@email.com".isValidEmail())   // true
    println("notanemail".isValidEmail())         // false
    println(42.toBinaryString())                 // 101010
    println(255.toBinaryString())                // 11111111

    // Java collections used directly
    println("\\n=== Java collections ===")
    val javaArrayList = java.util.ArrayList<String>()
    javaArrayList.add("Kotlin")
    javaArrayList.add("is")
    javaArrayList.add("awesome")

    // Use Kotlin extension functions on Java collections!
    println(javaArrayList.filter { it.length > 2 })
    println(javaArrayList.map { it.uppercase() })
    println(javaArrayList.joinToString(" "))
}

📝 KEY POINTS:
✅ Kotlin and Java code work together seamlessly on the JVM
✅ Assign Java returns to String? not String — platform types can be null
✅ @JvmStatic exposes companion functions as Java static methods
✅ @JvmOverloads generates overloads for Kotlin default parameters
✅ @JvmField exposes a property as a plain Java field (no getter/setter)
✅ @Throws tells Java callers which checked exceptions to expect
✅ Kotlin extension functions work on Java types transparently
✅ Kotlin's collection functions work on Java collections directly
❌ Companion functions are NOT static by default — Java sees .Companion
❌ Java's platform types bypass Kotlin null safety — assign carefully
❌ Kotlin's read-only List doesn't prevent mutation through Java references
❌ Top-level functions appear in Java as FileNameKt.method()
""",
  quiz: [
    Quiz(question: 'What is a "platform type" in Kotlin?', options: [
      QuizOption(text: 'A type returned from Java code where Kotlin cannot determine nullability — could be null or non-null', correct: true),
      QuizOption(text: 'A type that works across Kotlin/JVM, Kotlin/JS, and Kotlin/Native', correct: false),
      QuizOption(text: 'A primitive type like Int or Boolean that maps directly to a Java primitive', correct: false),
      QuizOption(text: 'A type defined in a shared Kotlin Multiplatform module', correct: false),
    ]),
    Quiz(question: 'Why is @JvmStatic needed when calling companion object functions from Java?', options: [
      QuizOption(text: 'Without it, Java must call User.Companion.create() — @JvmStatic allows the cleaner User.create()', correct: true),
      QuizOption(text: 'Without it, companion functions are not compiled into the .class file', correct: false),
      QuizOption(text: '@JvmStatic is required for all Kotlin functions called from Java', correct: false),
      QuizOption(text: 'Without it, companion functions throw an error when called from Java', correct: false),
    ]),
    Quiz(question: 'What does @JvmOverloads do for a Kotlin function with default parameters?', options: [
      QuizOption(text: 'Generates multiple Java method overloads so Java callers can use the function without named arguments', correct: true),
      QuizOption(text: 'Overrides the function in all subclasses automatically', correct: false),
      QuizOption(text: 'Makes all parameters optional from the Kotlin side as well', correct: false),
      QuizOption(text: 'Generates overloads for both Kotlin and Java callers simultaneously', correct: false),
    ]),
  ],
);
