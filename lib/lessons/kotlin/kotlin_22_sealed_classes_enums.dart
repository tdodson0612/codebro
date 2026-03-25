import '../../models/lesson.dart';
import '../../models/quiz.dart';

final kotlinLesson22 = Lesson(
  language: 'Kotlin',
  title: 'Sealed Classes and Enums',
  content: """
🎯 METAPHOR:
A sealed class is like a government-issued ID system.
The government (your file) decides EXACTLY what types of ID
exist: Passport, DriverLicense, StateID. Nobody outside
the system can invent a new ID type. When a security guard
checks an ID, they know for certain they've seen ALL possible
types — no surprise mystery cards. This "closed world"
guarantee lets Kotlin's compiler verify that you've handled
every case in a when expression — and alert you if you miss one.

Enums are simpler: like traffic light colors — RED, YELLOW,
GREEN. Fixed set of named values. Same concept, less power.

📖 EXPLANATION:
Both sealed classes and enums represent a restricted set of
types, but they serve different needs.

─────────────────────────────────────
ENUMS — named constants with behavior:
─────────────────────────────────────
  enum class Direction {
      NORTH, SOUTH, EAST, WEST
  }

  val dir = Direction.NORTH
  println(dir)         // NORTH
  println(dir.name)    // "NORTH"
  println(dir.ordinal) // 0 (index)

Enums can have properties and functions:

  enum class Planet(val mass: Double, val radius: Double) {
      MERCURY(3.303e+23, 2.4397e6),
      VENUS  (4.869e+24, 6.0518e6),
      EARTH  (5.976e+24, 6.37814e6);

      val gravity: Double
          get() = 6.67300E-11 * mass / (radius * radius)
  }

  Planet.EARTH.gravity   // 9.80...

─────────────────────────────────────
ENUM with when — exhaustive:
─────────────────────────────────────
  fun describe(dir: Direction) = when (dir) {
      Direction.NORTH -> "Heading up"
      Direction.SOUTH -> "Heading down"
      Direction.EAST  -> "Heading right"
      Direction.WEST  -> "Heading left"
      // No else needed — compiler knows all cases!
  }

─────────────────────────────────────
SEALED CLASSES — closed type hierarchy:
─────────────────────────────────────
All subclasses must be in the SAME FILE (or same package
in Kotlin 1.5+). The compiler knows every possible subclass.

  sealed class Result<out T> {
      data class Success<T>(val data: T) : Result<T>()
      data class Error(val message: String) : Result<Nothing>()
      object Loading : Result<Nothing>()
  }

Unlike enums, sealed class subclasses:
  ✅ Can hold different data in each subclass
  ✅ Can be data classes, objects, or regular classes
  ✅ Can have their own properties and methods

─────────────────────────────────────
when WITH SEALED CLASSES — exhaustive:
─────────────────────────────────────
  fun handleResult(result: Result<String>) = when (result) {
      is Result.Success -> println("Got: ${
result.data}")
      is Result.Error   -> println("Error: ${
result.message}")
      is Result.Loading -> println("Loading...")
      // No else needed — compiler verifies all branches!
  }

If you add a new subclass but forget to handle it in when,
the compiler gives a WARNING (expression) or ERROR (statement).

─────────────────────────────────────
ENUM vs SEALED CLASS:
─────────────────────────────────────
  Feature              Enum          Sealed Class
  ──────────────────────────────────────────────────
  Fixed instances      ✅ Yes        ✅ Yes (closed set)
  Data per instance    ✅ Same for   ✅ Different per subtype
                          all
  Is instances         ❌           ✅ Can be data/object/class
  Multiple instances   ❌ One each  ✅ Can create many
  Exhaustive when      ✅ Yes       ✅ Yes

  Use enum for: status flags, directions, modes, categories
  Use sealed for: operation results, UI states, events

─────────────────────────────────────
SEALED INTERFACE (Kotlin 1.5+):
─────────────────────────────────────
  sealed interface Shape
  data class Circle(val r: Double) : Shape
  data class Rect(val w: Double, val h: Double) : Shape

💻 CODE:
// Enum with properties and methods
enum class HttpStatus(val code: Int, val description: String) {
    OK(200, "Success"),
    CREATED(201, "Resource Created"),
    BAD_REQUEST(400, "Bad Request"),
    UNAUTHORIZED(401, "Unauthorized"),
    NOT_FOUND(404, "Not Found"),
    SERVER_ERROR(500, "Internal Server Error");

    val isSuccess: Boolean get() = code in 200..299
    val isError: Boolean get() = code >= 400

    fun display() = "\$code \$description"
}

// Sealed class for operation results
sealed class NetworkResult<out T> {
    data class Success<T>(val data: T, val statusCode: Int = 200) : NetworkResult<T>()
    data class Failure(val error: String, val statusCode: Int) : NetworkResult<Nothing>()
    object Loading : NetworkResult<Nothing>()
    object Empty : NetworkResult<Nothing>()
}

// Sealed class for UI state
sealed class UiState {
    object Idle : UiState()
    object Loading : UiState()
    data class Content(val items: List<String>) : UiState()
    data class Error(val message: String, val retryable: Boolean = true) : UiState()
}

fun handleNetworkResult(result: NetworkResult<String>) {
    when (result) {
        is NetworkResult.Success -> {
            println("✅ Success (${
result.statusCode}): ${
result.data}")
        }
        is NetworkResult.Failure -> {
            println("❌ Failed (${
result.statusCode}): ${
result.error}")
        }
        NetworkResult.Loading -> println("⏳ Loading...")
        NetworkResult.Empty   -> println("📭 No content")
    }
}

fun renderUi(state: UiState) {
    when (state) {
        is UiState.Idle    -> println("Waiting for input...")
        is UiState.Loading -> println("Spinner visible...")
        is UiState.Content -> println("Showing ${
state.items.size} items: ${
state.items}")
        is UiState.Error   -> {
            println("Error: ${
state.message}")
            if (state.retryable) println("  [Retry] button shown")
        }
    }
}

fun main() {
    // Enum usage
    val status = HttpStatus.NOT_FOUND
    println(status.display())        // 404 Not Found
    println(status.isError)          // true
    println(HttpStatus.OK.isSuccess) // true

    // Iterate all enum values
    println("\\nAll HTTP statuses:")
    HttpStatus.values().forEach { println("  ${
it.display()}") }

    // Get enum by name or value
    val found = HttpStatus.valueOf("CREATED")
    println("\\nFound: ${
found.display()}")

    println("\\n--- Network Results ---")
    handleNetworkResult(NetworkResult.Loading)
    handleNetworkResult(NetworkResult.Success("User data loaded", 200))
    handleNetworkResult(NetworkResult.Failure("Connection refused", 503))
    handleNetworkResult(NetworkResult.Empty)

    println("\\n--- UI States ---")
    renderUi(UiState.Idle)
    renderUi(UiState.Loading)
    renderUi(UiState.Content(listOf("Post 1", "Post 2", "Post 3")))
    renderUi(UiState.Error("Network unavailable", retryable = true))
    renderUi(UiState.Error("Permission denied", retryable = false))

    // Sealed class in a when expression — exhaustive
    val results: List<NetworkResult<String>> = listOf(
        NetworkResult.Success("Hello"),
        NetworkResult.Failure("Timeout", 408),
        NetworkResult.Empty
    )
    val summaries = results.map { result ->
        when (result) {
            is NetworkResult.Success -> "OK: ${
result.data}"
            is NetworkResult.Failure -> "FAIL: ${
result.error}"
            NetworkResult.Loading    -> "Loading"
            NetworkResult.Empty      -> "Empty"
        }
    }
    println("\\nSummaries: \$summaries")
}

📝 KEY POINTS:
✅ Enums: fixed set of named constants, can have properties/methods
✅ Sealed classes: closed type hierarchy with different data per type
✅ when on enum/sealed is exhaustive — no else needed
✅ Sealed class subclasses can be data class, object, or class
✅ Use enum for simple categories; sealed for result/state modeling
✅ NetworkResult / UiState are the canonical sealed class use cases
✅ HttpStatus.values() iterates all enum values
✅ HttpStatus.valueOf("NAME") gets enum by its string name
❌ Enums cannot hold different data per instance — use sealed for that
❌ Sealed class subclasses must be in the same package
❌ Don't add else to a when on sealed/enum — you lose exhaustiveness
❌ Sealed objects (singletons) vs sealed data classes — pick correctly
""",
  quiz: [
    Quiz(question: 'What is the key advantage of sealed classes over regular class hierarchies?', options: [
      QuizOption(text: 'The compiler knows all possible subtypes, enabling exhaustive when checks', correct: true),
      QuizOption(text: 'Sealed classes are more memory-efficient than open class hierarchies', correct: false),
      QuizOption(text: 'Sealed classes automatically generate equals and hashCode methods', correct: false),
      QuizOption(text: 'Sealed classes can implement multiple interfaces simultaneously', correct: false),
    ]),
    Quiz(question: 'When should you choose a sealed class over an enum?', options: [
      QuizOption(text: 'When each variant needs to carry different data or have multiple instances', correct: true),
      QuizOption(text: 'When you need exactly one instance of each variant', correct: false),
      QuizOption(text: 'When performance is critical — sealed classes are faster', correct: false),
      QuizOption(text: 'Sealed classes and enums are interchangeable — choose by preference', correct: false),
    ]),
    Quiz(question: 'What happens if you add a new subclass to a sealed class but forget to handle it in a when expression?', options: [
      QuizOption(text: 'The compiler gives a warning or error about a non-exhaustive when', correct: true),
      QuizOption(text: 'The program silently skips the new subclass at runtime', correct: false),
      QuizOption(text: 'The else branch automatically handles the new subclass', correct: false),
      QuizOption(text: 'Nothing — sealed classes do not enforce exhaustiveness in when', correct: false),
    ]),
  ],
);
