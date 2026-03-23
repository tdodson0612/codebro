import '../../models/lesson.dart';
import '../../models/quiz.dart';

final kotlinLesson31 = Lesson(
  language: 'Kotlin',
  title: 'Functional Programming Patterns',
  content: """
🎯 METAPHOR:
Functional programming is like an assembly line where every
station is a PURE machine — put in raw material, get out
a finished part, and the machine never changes the original
material or affects other machines. There are no side
effects: a station that paints parts doesn't secretly also
drill holes. Pure functions are these honest machines —
same input always produces same output, and nothing outside
the machine is affected. When every function is honest
and side-effect-free, you can rearrange, combine, and test
them in isolation without surprises.

📖 EXPLANATION:
Kotlin is not a purely functional language, but it has
first-class support for functional patterns. These patterns
lead to more testable, predictable, and composable code.

─────────────────────────────────────
PURE FUNCTIONS:
─────────────────────────────────────
A pure function:
  ✅ Always returns the same output for the same input
  ✅ Has no side effects (no mutations, no I/O, no state)

  // Pure
  fun add(a: Int, b: Int) = a + b
  fun double(list: List<Int>) = list.map { it * 2 }

  // Impure (modifies external state)
  var count = 0
  fun incrementCount() { count++ }   // side effect!

─────────────────────────────────────
IMMUTABILITY:
─────────────────────────────────────
Prefer val over var. Prefer immutable collections.
When you need to "change" data, create a new copy.

  // Mutable — fragile
  val list = mutableListOf(1, 2, 3)
  list.add(4)

  // Immutable — safe to share
  val list = listOf(1, 2, 3)
  val newList = list + 4   // new list, original unchanged

─────────────────────────────────────
FUNCTION COMPOSITION:
─────────────────────────────────────
Build complex behavior by combining simple functions.
Each function does one thing well.

  val trim: (String) -> String = { it.trim() }
  val upper: (String) -> String = { it.uppercase() }
  val exclaim: (String) -> String = { "\$it!" }

  // Manual composition
  fun compose(f: (String) -> String, g: (String) -> String)
      : (String) -> String = { f(g(it)) }

  val shoutTrimmed = compose(upper, trim)
  shoutTrimmed("  hello  ")   // "HELLO"

─────────────────────────────────────
PARTIAL APPLICATION and CURRYING:
─────────────────────────────────────
Currying: transform a multi-argument function into a
chain of single-argument functions.

  // Normal function
  fun multiply(a: Int, b: Int) = a * b

  // Curried version
  fun curriedMultiply(a: Int): (Int) -> Int = { b -> a * b }

  val double = curriedMultiply(2)
  val triple = curriedMultiply(3)
  println(double(5))   // 10
  println(triple(5))   // 15

─────────────────────────────────────
MEMOIZATION:
─────────────────────────────────────
Cache the results of expensive pure function calls.

  fun <T, R> memoize(fn: (T) -> R): (T) -> R {
      val cache = mutableMapOf<T, R>()
      return { input -> cache.getOrPut(input) { fn(input) } }
  }

  val memoFib = memoize { n: Int ->
      // expensive computation
  }

─────────────────────────────────────
RAILWAY ORIENTED PROGRAMMING:
─────────────────────────────────────
Chain operations that can fail, using Result or sealed class.
Think of it as two parallel tracks: success and failure.
Once you're on the failure track, all subsequent steps
are skipped and the error propagates to the end.

  fun validateName(name: String): Result<String> =
      if (name.isNotBlank()) Result.success(name)
      else Result.failure(Exception("Name is blank"))

  fun validateAge(age: Int): Result<Int> =
      if (age in 0..150) Result.success(age)
      else Result.failure(Exception("Age out of range"))

  fun createUser(name: String, age: Int): Result<String> =
      validateName(name)
          .mapCatching { n ->
              validateAge(age).getOrThrow()
              "User(\$n, \$age)"
          }

─────────────────────────────────────
FOLD — the universal aggregator:
─────────────────────────────────────
fold is the most powerful list operation. Every other
aggregation (sum, count, filter, map) can be expressed
as a fold. It processes a list into a single value.

  val sum = listOf(1, 2, 3, 4, 5).fold(0) { acc, n -> acc + n }
  val product = listOf(1, 2, 3, 4, 5).fold(1) { acc, n -> acc * n }

  // Implement filter with fold
  fun <T> List<T>.myFilter(pred: (T) -> Boolean): List<T> =
      fold(emptyList()) { acc, item ->
          if (pred(item)) acc + item else acc
      }

💻 CODE:
// Pure functions
fun factorial(n: Long): Long = if (n <= 1L) 1L else n * factorial(n - 1)

fun isPrime(n: Int): Boolean {
    if (n < 2) return false
    return (2..Math.sqrt(n.toDouble()).toInt()).none { n % it == 0 }
}

// Immutable data transformation pipeline
data class Employee(
    val name: String,
    val department: String,
    val salary: Double,
    val yearsExp: Int
)

// Function composition utility
fun <A, B, C> compose(f: (B) -> C, g: (A) -> B): (A) -> C = { f(g(it)) }
fun <A, B, C> pipe(g: (A) -> B, f: (B) -> C): (A) -> C = { f(g(it)) }

// Memoization
fun <T, R> memoize(fn: (T) -> R): (T) -> R {
    val cache = mutableMapOf<T, R>()
    return { input ->
        cache.getOrPut(input) {
            println("  Computing for \$input...")
            fn(input)
        }
    }
}

// Currying
fun <A, B, C> curry(fn: (A, B) -> C): (A) -> (B) -> C = { a -> { b -> fn(a, b) } }

// Railway: Result chaining
data class UserInput(val name: String, val age: String, val email: String)

fun validateName(name: String): Result<String> =
    if (name.length >= 2) Result.success(name.trim())
    else Result.failure(IllegalArgumentException("Name too short"))

fun validateAge(ageStr: String): Result<Int> =
    ageStr.toIntOrNull()
        ?.takeIf { it in 0..150 }
        ?.let { Result.success(it) }
        ?: Result.failure(IllegalArgumentException("Invalid age: '\$ageStr'"))

fun validateEmail(email: String): Result<String> =
    if (email.contains("@") && email.contains(".")) Result.success(email)
    else Result.failure(IllegalArgumentException("Invalid email"))

fun validateUser(input: UserInput): Result<String> =
    validateName(input.name)
        .mapCatching { name ->
            val age = validateAge(input.age).getOrThrow()
            val email = validateEmail(input.email).getOrThrow()
            "User(name=\$name, age=\$age, email=\$email)"
        }

fun main() {
    val employees = listOf(
        Employee("Alice", "Engineering", 95000.0, 5),
        Employee("Bob", "Marketing", 75000.0, 3),
        Employee("Charlie", "Engineering", 110000.0, 8),
        Employee("Dave", "Marketing", 80000.0, 6),
        Employee("Eve", "Engineering", 98000.0, 4),
        Employee("Frank", "HR", 70000.0, 2)
    )

    // Immutable pipeline — chain pure transformations
    println("=== Functional Pipeline ===")
    val engineeringSummary = employees
        .filter { it.department == "Engineering" }
        .sortedByDescending { it.salary }
        .map { "\${it.name}: \$\${"%.0f".format(it.salary)} (\${it.yearsExp}y)" }
    println("Engineering (by salary):")
    engineeringSummary.forEach { println("  \$it") }

    // fold for aggregation
    println("\\n=== Fold aggregations ===")
    val totalSalary = employees.fold(0.0) { acc, e -> acc + e.salary }
    val deptSalaries = employees.fold(mutableMapOf<String, Double>()) { acc, e ->
        acc[e.department] = (acc[e.department] ?: 0.0) + e.salary
        acc
    }
    println("Total payroll: \$\${"%.0f".format(totalSalary)}")
    deptSalaries.forEach { (dept, total) ->
        println("  \$dept: \$\${"%.0f".format(total)}")
    }

    // Function composition
    println("\\n=== Composition ===")
    val trim: (String) -> String = { it.trim() }
    val capitalize: (String) -> String = { it.replaceFirstChar { c -> c.uppercase() } }
    val exclaim: (String) -> String = { "\$it!" }

    val process = pipe(pipe(trim, capitalize), exclaim)
    listOf("  hello  ", "  kotlin  ", "  world  ").forEach {
        println("'\$it' → '\${process(it)}'")
    }

    // Currying
    println("\\n=== Currying ===")
    val curriedAdd = curry { a: Int, b: Int -> a + b }
    val add10 = curriedAdd(10)
    val add100 = curriedAdd(100)
    println(listOf(1, 2, 3, 4, 5).map(add10))
    println(listOf(1, 2, 3, 4, 5).map(add100))

    // Memoization
    println("\\n=== Memoization ===")
    val memoFactorial = memoize<Long, Long> { n -> factorial(n) }
    println("5! = \${memoFactorial(5L)}")   // computes
    println("5! = \${memoFactorial(5L)}")   // cached
    println("7! = \${memoFactorial(7L)}")   // computes
    println("7! = \${memoFactorial(7L)}")   // cached

    // Railway / Result chaining
    println("\\n=== Railway (Result) ===")
    val inputs = listOf(
        UserInput("Terry", "30", "terry@example.com"),
        UserInput("X", "30", "terry@example.com"),      // name too short
        UserInput("Sam", "abc", "sam@example.com"),    // bad age
        UserInput("Bob", "25", "not-an-email")         // bad email
    )
    inputs.forEach { input ->
        validateUser(input)
            .onSuccess { println("✅ \$it") }
            .onFailure { println("❌ \${it.message}") }
    }

    // Prime numbers (pure function)
    println("\\n=== Primes up to 50 ===")
    println((2..50).filter(::isPrime))
}

📝 KEY POINTS:
✅ Pure functions: same input → same output, no side effects
✅ Prefer val and immutable collections to prevent shared-state bugs
✅ Function composition builds complex behavior from simple functions
✅ Currying creates specialized functions from general ones
✅ Memoization caches results of expensive pure functions
✅ fold is the universal aggregation — filter/map are special cases
✅ Result chaining (railway) keeps error handling flat and readable
✅ Functional pipelines are easy to test — each step in isolation
❌ Don't force functional style when imperative is clearer
❌ Avoid deep recursion without tail recursion — use tailrec
❌ Memoization only works correctly with pure functions
❌ Immutability has trade-offs — copying data has cost at scale
""",
  quiz: [
    Quiz(question: 'What defines a pure function?', options: [
      QuizOption(text: 'It always returns the same output for the same input and has no side effects', correct: true),
      QuizOption(text: 'It is declared with the pure keyword and cannot access global state', correct: false),
      QuizOption(text: 'It only works with immutable data types', correct: false),
      QuizOption(text: 'It cannot call other functions or use lambda expressions', correct: false),
    ]),
    Quiz(question: 'What does memoization do to a function?', options: [
      QuizOption(text: 'Caches results so the same input never causes recomputation', correct: true),
      QuizOption(text: 'Makes the function run concurrently on all available CPU cores', correct: false),
      QuizOption(text: 'Converts the function to a tail-recursive form for stack safety', correct: false),
      QuizOption(text: 'Logs every call to the function for debugging purposes', correct: false),
    ]),
    Quiz(question: 'What is currying in functional programming?', options: [
      QuizOption(text: 'Transforming a multi-argument function into a chain of single-argument functions', correct: true),
      QuizOption(text: 'Combining two functions so the output of one feeds into the other', correct: false),
      QuizOption(text: 'Running a function partially and deferring the rest until more args are available', correct: false),
      QuizOption(text: 'A pattern for handling errors without throwing exceptions', correct: false),
    ]),
  ],
);
