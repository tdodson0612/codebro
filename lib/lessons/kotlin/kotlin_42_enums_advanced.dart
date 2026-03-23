import '../../models/lesson.dart';
import '../../models/quiz.dart';

final kotlinLesson42 = Lesson(
  language: 'Kotlin',
  title: 'Enum Classes: Advanced Features',
  content: """
🎯 METAPHOR:
Advanced enums are like a professional card game's suit
system. The four suits (♠ ♥ ♦ ♣) are fixed — you can't
invent a fifth suit. But each suit isn't JUST a name: it
has a color (red/black), a symbol, a scoring value in some
games, and behavior ("trump" in bridge). Kotlin enums work
the same way — the values are fixed and named, but each
one can carry its own data, implement abstract behaviors
differently, and expose properties. The enum is both a
category AND a rich object.

📖 EXPLANATION:
Kotlin enum classes go far beyond simple constants.
They can carry state, implement interfaces, define abstract
methods that each variant implements differently, and
interact powerfully with when expressions.

─────────────────────────────────────
ENUM WITH PROPERTIES:
─────────────────────────────────────
  enum class Season(val monthRange: IntRange) {
      SPRING(3..5),
      SUMMER(6..8),
      AUTUMN(9..11),
      WINTER(12..2)     // wraps around — handle specially
  }

  Season.SUMMER.monthRange   // 6..8

─────────────────────────────────────
ENUM WITH ABSTRACT FUNCTIONS:
─────────────────────────────────────
Each variant can implement an abstract method differently:

  enum class Operation(val symbol: String) {
      PLUS("+") {
          override fun apply(a: Double, b: Double) = a + b
      },
      MINUS("-") {
          override fun apply(a: Double, b: Double) = a - b
      },
      TIMES("*") {
          override fun apply(a: Double, b: Double) = a * b
      },
      DIVIDE("/") {
          override fun apply(a: Double, b: Double) = a / b
      };

      abstract fun apply(a: Double, b: Double): Double
  }

  Operation.PLUS.apply(3.0, 4.0)   // 7.0
  println(Operation.PLUS.symbol)   // +

─────────────────────────────────────
ENUM IMPLEMENTING AN INTERFACE:
─────────────────────────────────────
  interface Printable {
      fun print()
  }

  enum class Color(val hex: String) : Printable {
      RED("#FF0000"),
      GREEN("#00FF00"),
      BLUE("#0000FF");

      override fun print() = println("Color: \$name (\$hex)")
  }

─────────────────────────────────────
BUILT-IN ENUM PROPERTIES AND METHODS:
─────────────────────────────────────
  Direction.NORTH.name       // "NORTH" (String)
  Direction.NORTH.ordinal    // 0 (position in declaration)

  // All values as an array:
  Direction.values()         // [NORTH, SOUTH, EAST, WEST]
  Direction.entries          // List<Direction> (Kotlin 1.9+)

  // Get by name:
  Direction.valueOf("NORTH")  // Direction.NORTH
  // Throws IllegalArgumentException if name not found

  // Safely get by name:
  enumValueOf<Direction>("NORTH")
  enumValues<Direction>()

─────────────────────────────────────
ENUM IN when EXPRESSIONS:
─────────────────────────────────────
  fun message(day: DayOfWeek) = when (day) {
      DayOfWeek.MONDAY    -> "Start of the grind"
      DayOfWeek.FRIDAY    -> "Almost there!"
      DayOfWeek.SATURDAY,
      DayOfWeek.SUNDAY    -> "Weekend!"
      else                -> "Keep going"
  }

─────────────────────────────────────
ENUM COMPANION OBJECT:
─────────────────────────────────────
  enum class StatusCode(val code: Int) {
      OK(200), NOT_FOUND(404), ERROR(500);

      companion object {
          fun fromCode(code: Int): StatusCode? =
              values().find { it.code == code }
      }
  }

  StatusCode.fromCode(404)   // StatusCode.NOT_FOUND

─────────────────────────────────────
ENUM VS SEALED CLASS — when to use which:
─────────────────────────────────────
  Use enum when:
  ✅ Fixed set of named constants
  ✅ All instances are known at compile time
  ✅ Each instance has same shape (same properties)

  Use sealed class when:
  ✅ Each subtype has DIFFERENT data/properties
  ✅ You need multiple instances of a variant
  ✅ Variants need different constructor parameters

💻 CODE:
// Enum with properties and functions
enum class Planet(
    val mass: Double,      // kg
    val radius: Double     // m
) {
    MERCURY(3.303e+23, 2.4397e6),
    VENUS(4.869e+24, 6.0518e6),
    EARTH(5.976e+24, 6.37814e6),
    MARS(6.421e+23, 3.3972e6),
    JUPITER(1.9e+27, 7.1492e7),
    SATURN(5.688e+26, 6.0268e7),
    URANUS(8.686e+25, 2.5559e7),
    NEPTUNE(1.024e+26, 2.4746e7);

    companion object {
        private const val G = 6.67300E-11  // gravitational constant
    }

    val surfaceGravity: Double
        get() = G * mass / (radius * radius)

    fun weightOn(earthWeight: Double): Double {
        val earthGravity = 9.80665
        return earthWeight * surfaceGravity / earthGravity
    }
}

// Enum with abstract method
enum class Operation(val symbol: String) {
    ADD("+") {
        override fun apply(a: Double, b: Double) = a + b
    },
    SUBTRACT("-") {
        override fun apply(a: Double, b: Double) = a - b
    },
    MULTIPLY("*") {
        override fun apply(a: Double, b: Double) = a * b
    },
    DIVIDE("/") {
        override fun apply(a: Double, b: Double) =
            if (b != 0.0) a / b else Double.NaN
    },
    POWER("^") {
        override fun apply(a: Double, b: Double) = Math.pow(a, b)
    };

    abstract fun apply(a: Double, b: Double): Double

    override fun toString() = symbol
}

// Enum implementing interface with companion factory
interface HttpCode {
    val code: Int
    val message: String
    val isSuccess: Boolean
}

enum class HttpStatus(
    override val code: Int,
    override val message: String
) : HttpCode {
    OK(200, "OK"),
    CREATED(201, "Created"),
    NO_CONTENT(204, "No Content"),
    BAD_REQUEST(400, "Bad Request"),
    UNAUTHORIZED(401, "Unauthorized"),
    FORBIDDEN(403, "Forbidden"),
    NOT_FOUND(404, "Not Found"),
    UNPROCESSABLE(422, "Unprocessable Entity"),
    SERVER_ERROR(500, "Internal Server Error"),
    SERVICE_UNAVAILABLE(503, "Service Unavailable");

    override val isSuccess: Boolean get() = code in 200..299

    fun toDisplayString() = "\$code \$message"

    companion object {
        fun fromCode(code: Int): HttpStatus? = values().find { it.code == code }

        fun fromCodeOrDefault(code: Int, default: HttpStatus = SERVER_ERROR): HttpStatus =
            fromCode(code) ?: default
    }
}

// Enum with multiple pieces of state
enum class CardSuit(
    val symbol: String,
    val color: String,
    val isRed: Boolean
) {
    SPADES("♠", "Black", false),
    HEARTS("♥", "Red", true),
    DIAMONDS("♦", "Red", true),
    CLUBS("♣", "Black", false);

    val isBlack get() = !isRed
    override fun toString() = symbol
}

enum class CardRank(val value: Int, val display: String) {
    TWO(2, "2"), THREE(3, "3"), FOUR(4, "4"), FIVE(5, "5"),
    SIX(6, "6"), SEVEN(7, "7"), EIGHT(8, "8"), NINE(9, "9"),
    TEN(10, "10"), JACK(10, "J"), QUEEN(10, "Q"), KING(10, "K"),
    ACE(11, "A");

    override fun toString() = display
}

data class Card(val rank: CardRank, val suit: CardSuit) {
    override fun toString() = "\${rank}\${suit}"
}

fun main() {
    // Planet enum
    println("=== Planet weights ===")
    val earthWeight = 75.0  // kg
    Planet.values().forEach { planet ->
        println("\${planet.name.padEnd(8)}: \${"%.2f".format(planet.weightOn(earthWeight))} kg" +
            " (gravity: \${"%.2f".format(planet.surfaceGravity)} m/s²)")
    }

    // Operation enum
    println("\\n=== Operations ===")
    val a = 10.0
    val b = 3.0
    Operation.values().forEach { op ->
        println("\$a \$op \$b = \${"%.4f".format(op.apply(a, b))}")
    }

    // Enum iteration with ordinal and name
    println("\\n=== Enum metadata ===")
    HttpStatus.values().forEach { status ->
        println("[\${status.ordinal}] \${status.name} → \${status.toDisplayString()} (success: \${status.isSuccess})")
    }

    // Companion factory
    println("\\n=== Lookup by code ===")
    listOf(200, 404, 503, 999).forEach { code ->
        val status = HttpStatus.fromCodeOrDefault(code)
        println("\$code → \${status.toDisplayString()}")
    }

    // Card suit enum
    println("\\n=== Card suits ===")
    CardSuit.values().forEach { suit ->
        println("\$suit \${suit.name.padEnd(8)} → \${suit.color}")
    }

    // Build a hand of cards
    println("\\n=== Sample hand ===")
    val hand = listOf(
        Card(CardRank.ACE, CardSuit.SPADES),
        Card(CardRank.KING, CardSuit.HEARTS),
        Card(CardRank.TEN, CardSuit.DIAMONDS),
        Card(CardRank.JACK, CardSuit.CLUBS),
        Card(CardRank.TWO, CardSuit.HEARTS)
    )
    val handValue = hand.sumOf { it.rank.value }
    println("Hand: \${hand.joinToString(" ")} = \$handValue points")

    // Enum.valueOf and enumValueOf
    println("\\n=== Enum lookup by name ===")
    val north = enumValueOf<CardSuit>("HEARTS")
    println("Looked up: \$north")

    // Safe lookup
    val allOps = enumValues<Operation>()
    println("All operations: \${allOps.map { it.symbol }}")
}

📝 KEY POINTS:
✅ Enums can have properties, functions, and companion objects
✅ Abstract functions let each variant define its own behavior
✅ Enums can implement interfaces — useful for typed contracts
✅ values() returns all variants as Array; entries returns List (1.9+)
✅ valueOf("NAME") gets by name; find { it.code == x } by property
✅ ordinal is the 0-based position in the declaration
✅ Enum constants are singletons — not created on every call
✅ Companion objects in enums are great for factory methods
❌ Enum abstract methods mean EVERY variant MUST implement them
❌ Don't use enums when variants need different constructor shapes
❌ valueOf() throws on unknown name — use find/firstOrNull for safety
❌ Enum ordinal values are fragile — don't store them in databases
   (reordering enums changes all ordinals)
""",
  quiz: [
    Quiz(question: 'How do you give each enum variant its own implementation of a method?', options: [
      QuizOption(text: 'Declare an abstract method in the enum body and override it in each variant\'s {} block', correct: true),
      QuizOption(text: 'Declare the method with the open keyword and override in subclasses', correct: false),
      QuizOption(text: 'Use a when expression inside a regular method to dispatch per variant', correct: false),
      QuizOption(text: 'Annotate the method with @PerVariant and provide a map of implementations', correct: false),
    ]),
    Quiz(question: 'Why should you avoid storing enum ordinal values in a database?', options: [
      QuizOption(text: 'Reordering enum constants changes all ordinal values, breaking stored data', correct: true),
      QuizOption(text: 'Ordinal values are not serializable to common database formats', correct: false),
      QuizOption(text: 'Ordinals start at 1 in Kotlin but 0 in databases, causing off-by-one errors', correct: false),
      QuizOption(text: 'The ordinal property is deprecated and will be removed in future Kotlin versions', correct: false),
    ]),
    Quiz(question: 'What is the safe way to look up an enum by a custom property value?', options: [
      QuizOption(text: 'Use values().find { it.property == target } which returns null if not found', correct: true),
      QuizOption(text: 'Use valueOf(target) which handles missing values gracefully', correct: false),
      QuizOption(text: 'Use enumOf<MyEnum>(target) from the standard library', correct: false),
      QuizOption(text: 'Use entries[target] with a bounds check', correct: false),
    ]),
  ],
);
