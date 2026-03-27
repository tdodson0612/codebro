import '../../models/lesson.dart';
import '../../models/quiz.dart';

final kotlinLesson45 = Lesson(
  language: 'Kotlin',
  title: 'lateinit, Arrays, and Nested Classes',
  content: """
🎯 METAPHOR:
lateinit is like a reserved parking spot with a sign that
says "Coming Soon." The spot exists, it has a name, it's
allocated — but the car hasn't arrived yet. You can't USE
the spot until the car shows up. If you try to park someone
else there before the car arrives, you get an error. The
key is that you KNOW the car will eventually come — you're
just not ready to park it at construction time.

Arrays are like a fixed-size egg carton. You decide up front
that it holds exactly 12 eggs. You can't add a 13th. Every
slot is pre-allocated. Lists are flexible bags — throw in
as many as you want. Egg cartons are faster to access and
use less memory, but you're locked into the size.

Nested classes are like departments inside a company. An
inner class is a team that knows who the CEO is (has a
reference to the outer class). A static nested class is
a contractor office in the building — it's physically
inside, but it doesn't report to the CEO.

📖 EXPLANATION:

─────────────────────────────────────
lateinit — deferred property initialization:
─────────────────────────────────────
Normally Kotlin requires properties to be initialized at
declaration or in init. lateinit says: "I'll initialize
this before I use it — trust me."

  class MyService {
      lateinit var database: Database   // not yet initialized

      fun start() {
          database = Database.connect()  // initialized here
      }

      fun query(sql: String) = database.execute(sql)
  }

Rules for lateinit:
  ✅ Only for var (not val)
  ✅ Only for non-nullable types
  ✅ Only for reference types (not Int, Boolean, etc.)
  ❌ Cannot be nullable (use null instead)
  ❌ Cannot be primitive types

CHECKING if initialized:
  if (::database.isInitialized) {
      println(database.status)
  }

If you access a lateinit property before initializing it:
  → UninitializedPropertyAccessException (NOT NullPointerException)

─────────────────────────────────────
ARRAYS — fixed-size, typed containers:
─────────────────────────────────────
Arrays have a fixed size set at creation. They're faster
than lists for primitive types.

  val arr = arrayOf(1, 2, 3, 4, 5)       // Array<Int>
  val arr2 = Array(5) { it * 2 }         // [0, 2, 4, 6, 8]
  val zeros = IntArray(5)                // [0, 0, 0, 0, 0]
  val filled = IntArray(5) { 1 }         // [1, 1, 1, 1, 1]

PRIMITIVE ARRAY TYPES (avoid boxing):
  IntArray     → int[]    in Java
  LongArray    → long[]
  DoubleArray  → double[]
  FloatArray   → float[]
  BooleanArray → boolean[]
  CharArray    → char[]
  ByteArray    → byte[]

  // Use primitive arrays for numeric performance:
  val scores = IntArray(1000)   // more efficient than Array<Int>

ARRAY OPERATIONS:
  arr[0]              → first element
  arr[arr.size - 1]   → last element
  arr.size            → number of elements
  arr.indices         → 0 until arr.size
  arr.toList()        → convert to List
  arr.sorted()        → new sorted List
  arr.contentToString() → "[1, 2, 3, 4, 5]"
  arr.contentEquals(other) → compare arrays by content

MULTI-DIMENSIONAL ARRAYS:
  val matrix = Array(3) { IntArray(3) }
  matrix[0][0] = 1
  matrix[1][1] = 5
  matrix[2][2] = 9

─────────────────────────────────────
NESTED CLASSES:
─────────────────────────────────────
A class declared inside another class.

  class Outer {
      private val secret = "outer secret"

      class Nested {
          // Does NOT have access to Outer's members
          fun show() = println("I am nested")
      }

      inner class Inner {
          // HAS access to Outer's members via outer reference
          fun show() = println("I can see: \$secret")
      }
  }

  val nested = Outer.Nested()    // no Outer instance needed
  val inner = Outer().Inner()    // requires an Outer instance

─────────────────────────────────────
NESTED vs INNER:
─────────────────────────────────────
  class Nested  → like Java's static nested class
                  no implicit reference to outer instance
                  more memory efficient

  inner class   → has implicit reference to outer instance
                  can access outer's private members
                  carries slight memory overhead

─────────────────────────────────────
LOCAL CLASSES:
─────────────────────────────────────
A class defined inside a function — only visible there:

  fun buildProcessor(): Processor {
      class LocalProcessor : Processor {
          override fun process(data: String) = data.uppercase()
      }
      return LocalProcessor()
  }

─────────────────────────────────────
ANONYMOUS CLASSES (object expressions):
─────────────────────────────────────
  val comparator = object : Comparator<Int> {
      override fun compare(a: Int, b: Int) = b - a   // reverse
  }
  // Already covered in lesson 18 — just noting the connection

💻 CODE:
// ─── lateinit ────────────────────────────────────────

class DatabaseService {
    lateinit var connectionString: String
    lateinit var tableName: String
    private var connected = false

    fun initialize(host: String, table: String) {
        connectionString = "jdbc:postgresql://\$host/mydb"
        tableName = table
        connected = true
        println("Initialized: \$connectionString, table: \$tableName")
    }

    fun query(): String {
        check(connected) { "Call initialize() first" }
        // Safe — we check before accessing
        return "SELECT * FROM \$tableName WHERE active = true"
    }

    fun status(): String {
        return if (::connectionString.isInitialized)
            "Connected to \$connectionString"
        else
            "Not yet initialized"
    }
}

// ─── Arrays ──────────────────────────────────────────

fun arrayDemo() {
    println("\\n=== Arrays ===")

    // Creating arrays
    val names = arrayOf("Alice", "Bob", "Charlie")
    val squares = Array(6) { i -> i * i }
    val scores = IntArray(5) { 10 * (it + 1) }

    println("Names:\${
names.contentToString()}")
    println("Squares:\${
squares.contentToString()}")
    println("Scores:\${
scores.contentToString()}")

    // Access and modify
    names[1] = "Barbara"
    println("After update:\${
names.contentToString()}")

    // Iteration
    println("Iterating:")
    for ((index, name) in names.withIndex()) {
        println("  \$index: \$name")
    }

    // Array operations
    println("Sorted:\${
scores.sorted()}")
    println("Sum:\${
scores.sum()}")
    println("Max:\${
scores.max()}")
    println("Contains 30:\${
30 in scores}")

    // Multi-dimensional
    println("\\n=== Matrix ===")
    val size = 3
    val matrix = Array(size) { row -> IntArray(size) { col -> row * size + col + 1 } }

    for (row in matrix) {
        println(row.contentToString())
    }
    println("Center:\${
matrix[1][1]}")

    // Convert between arrays and lists
    val list = names.toList()
    val backToArray = list.toTypedArray()
    println("Array → List → Array:\${
backToArray.contentToString()}")

    // Primitive arrays for efficiency
    val bigData = LongArray(5) { it.toLong() * 1_000_000L }
    println("\\nLong array:\${
bigData.contentToString()}")

    val bytes = ByteArray(4) { (it * 64).toByte() }
    println("Byte array:\${
bytes.contentToString()}")
}

// ─── Nested classes ───────────────────────────────────

class Computer(val brand: String) {
    private val serialNumber = "SN-\${
brand.uppercase()}-001"

    // Nested class — no access to Computer's members
    class Specs(val cpu: String, val ram: Int, val storage: Int) {
        fun summary() = "CPU: \$cpu | RAM:\${
ram}GB | Storage:\${
storage}GB"
        // Cannot access 'brand' or 'serialNumber' here
    }

    // Inner class — HAS access to Computer's members
    inner class SystemInfo {
        fun report(): String {
            // Can access outer class private members
            return "[\$brand] Serial: \$serialNumber |\${
getSpecs()}"
        }

        private fun getSpecs() = "Status: Online"
    }

    fun createInfo() = SystemInfo()
}

// Nested class in a sealed hierarchy (common pattern)
sealed class Result<out T> {
    data class Success<T>(val value: T) : Result<T>()
    data class Failure(val error: String, val code: Int = 0) : Result<Nothing>()
    object Empty : Result<Nothing>()

    // Nested utility class
    class Builder<T> {
        fun success(value: T): Result<T> = Success(value)
        fun failure(error: String, code: Int = 0): Result<T> = Failure(error, code)
        fun empty(): Result<T> = Empty
    }
}

// Local class example
fun createSorter(descending: Boolean): Comparator<Int> {
    class AscendingSorter : Comparator<Int> {
        override fun compare(a: Int, b: Int) = a - b
    }
    class DescendingSorter : Comparator<Int> {
        override fun compare(a: Int, b: Int) = b - a
    }
    return if (descending) DescendingSorter() else AscendingSorter()
}

fun main() {
    // lateinit
    println("=== lateinit ===")
    val service = DatabaseService()
    println(service.status())   // Not yet initialized

    try {
        service.query()         // throws before initialize
    } catch (e: IllegalStateException) {
        println("Caught:\${
e.message}")
    }

    service.initialize("localhost:5432", "users")
    println(service.status())
    println(service.query())

    // isInitialized check
    println("\\n=== isInitialized ===")
    class Config {
        lateinit var apiKey: String
        fun setup() { apiKey = "abc-123-secret" }
        fun isReady() = ::apiKey.isInitialized
    }
    val config = Config()
    println("Ready before setup:\${
config.isReady()}")
    config.setup()
    println("Ready after setup: \${
config.isReady()}")
    println("Key:\${
config.apiKey}")

    // Arrays
    arrayDemo()

    // Nested classes
    println("\\n=== Nested classes ===")

    // Nested — no outer instance needed
    val specs = Computer.Specs("Intel i9", 32, 1000)
    println(specs.summary())

    // Inner — requires outer instance
    val computer = Computer("Dell")
    val info = computer.createInfo()   // or computer.SystemInfo()
    println(info.report())

    // Sealed class with nested types
    println("\\n=== Sealed with nested ===")
    val builder = Result.Builder<String>()
    val results = listOf(
        builder.success("Data loaded"),
        builder.failure("Timeout", 408),
        builder.empty()
    )
    results.forEach { result ->
        when (result) {
            is Result.Success  -> println("✅\${
result.value}")
            is Result.Failure  -> println("❌\${
result.error} (\${
result.code})")
            is Result.Empty    -> println("📭 Empty")
        }
    }

    // Local class sorter
    println("\\n=== Local class sorter ===")
    val numbers = listOf(5, 2, 8, 1, 9, 3, 7)
    println("Ascending: \${
numbers.sortedWith(createSorter(false))}")
    println("Descending:\${
numbers.sortedWith(createSorter(true))}")
}

📝 KEY POINTS:
✅ lateinit allows non-null var properties to be initialized after construction
✅ Use ::property.isInitialized to safely check before access
✅ lateinit only works for reference types (not Int, Boolean, etc.)
✅ Arrays have fixed size; use IntArray/DoubleArray for primitive efficiency
✅ Array(n) { it * 2 } generates an array with a formula
✅ contentToString() gives readable array output (not toString())
✅ contentEquals() compares array contents (not references)
✅ Nested class = no outer reference; inner class = has outer reference
✅ inner class can access private members of the enclosing class
❌ Accessing uninitialized lateinit throws UninitializedPropertyAccessException
❌ lateinit cannot be used with val, nullable types, or primitives
❌ Arrays are NOT resizable — use MutableList when size may change
❌ Array<Int> boxes integers — use IntArray for numeric performance
""",
  quiz: [
    Quiz(question: 'What is the difference between a nested class and an inner class in Kotlin?', options: [
      QuizOption(text: 'A nested class has no reference to the outer class; an inner class holds a reference and can access outer members', correct: true),
      QuizOption(text: 'A nested class is abstract; an inner class is concrete', correct: false),
      QuizOption(text: 'An inner class cannot be instantiated; a nested class can', correct: false),
      QuizOption(text: 'They are identical — inner and nested are synonyms in Kotlin', correct: false),
    ]),
    Quiz(question: 'What happens if you access a lateinit property before it is initialized?', options: [
      QuizOption(text: 'UninitializedPropertyAccessException is thrown', correct: true),
      QuizOption(text: 'NullPointerException is thrown', correct: false),
      QuizOption(text: 'The property returns null silently', correct: false),
      QuizOption(text: 'The compiler prevents access at compile time', correct: false),
    ]),
    Quiz(question: 'Why should you use IntArray instead of Array<Int> for large numeric data?', options: [
      QuizOption(text: 'IntArray stores primitive ints with no boxing overhead; Array<Int> boxes each integer as an object', correct: true),
      QuizOption(text: 'IntArray is resizable; Array<Int> has a fixed size', correct: false),
      QuizOption(text: 'Array<Int> does not support arithmetic operations; IntArray does', correct: false),
      QuizOption(text: 'IntArray supports null elements; Array<Int> does not', correct: false),
    ]),
  ],
);
