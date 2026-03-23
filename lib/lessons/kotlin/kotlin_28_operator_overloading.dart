import '../../models/lesson.dart';
import '../../models/quiz.dart';

final kotlinLesson28 = Lesson(
  language: 'Kotlin',
  title: 'Operator Overloading',
  content: """
🎯 METAPHOR:
Operator overloading is like teaching the same word to
mean different things in different contexts. In English,
"+" means addition for numbers: "3 + 4 = 7." But for
words, "+" means concatenation: "Hello" + " World" =
"Hello World." The symbol is the same; the behavior
depends on the context (the type). Kotlin lets you teach
YOUR custom types what +, -, *, /, ==, >, <, [], and more
mean for THEM. A Vector + Vector adds coordinates.
A Color * 0.5 darkens it. The math notation becomes
natural for your domain.

📖 EXPLANATION:
Operator overloading lets you define what standard operators
mean for your custom classes. Kotlin does this with special
named functions marked with the operator keyword.

─────────────────────────────────────
OPERATOR FUNCTIONS:
─────────────────────────────────────
  Operator   Function name    Example
  ──────────────────────────────────────────
  +          plus             a + b
  -          minus            a - b
  *          times            a * b
  /          div              a / b
  %          rem              a % b
  -a         unaryMinus       -a
  +a         unaryPlus        +a
  !a         not              !a
  ++         inc              a++
  --         dec              a--
  +=         plusAssign       a += b
  -=         minusAssign      a -= b
  ==         equals           a == b
  <, >       compareTo        a < b
  []         get/set          a[i]
  in         contains         b in a
  ..         rangeTo          a..b
  ()         invoke           a()

─────────────────────────────────────
BASIC EXAMPLE:
─────────────────────────────────────
  data class Vector(val x: Double, val y: Double) {

      operator fun plus(other: Vector) =
          Vector(x + other.x, y + other.y)

      operator fun times(scalar: Double) =
          Vector(x * scalar, y * scalar)

      operator fun unaryMinus() = Vector(-x, -y)
  }

  val v1 = Vector(1.0, 2.0)
  val v2 = Vector(3.0, 4.0)
  println(v1 + v2)      // Vector(x=4.0, y=6.0)
  println(v1 * 2.0)     // Vector(x=2.0, y=4.0)
  println(-v1)          // Vector(x=-1.0, y=-2.0)

─────────────────────────────────────
INDEX OPERATOR: get and set:
─────────────────────────────────────
  operator fun get(index: Int): T
  operator fun set(index: Int, value: T)

  class Matrix(val rows: Int, val cols: Int) {
      private val data = Array(rows) { DoubleArray(cols) }

      operator fun get(row: Int, col: Int) = data[row][col]
      operator fun set(row: Int, col: Int, value: Double) {
          data[row][col] = value
      }
  }

  val m = Matrix(3, 3)
  m[0, 0] = 1.0
  println(m[0, 0])   // 1.0

─────────────────────────────────────
INVOKE OPERATOR: make objects callable:
─────────────────────────────────────
  class Multiplier(val factor: Int) {
      operator fun invoke(value: Int) = value * factor
  }

  val triple = Multiplier(3)
  println(triple(5))    // 15 — object called like a function!
  println(triple(10))   // 30

─────────────────────────────────────
compareTo — enabling ordering:
─────────────────────────────────────
  class Version(val major: Int, val minor: Int, val patch: Int)
      : Comparable<Version> {

      override operator fun compareTo(other: Version): Int {
          return compareValuesBy(this, other,
              { it.major }, { it.minor }, { it.patch })
      }
  }

  val v1_0 = Version(1, 0, 0)
  val v2_0 = Version(2, 0, 0)
  println(v1_0 < v2_0)    // true
  println(v2_0 > v1_0)    // true

─────────────────────────────────────
contains — enabling 'in' operator:
─────────────────────────────────────
  class NumberRange(val start: Int, val end: Int) {
      operator fun contains(value: Int) = value in start..end
  }

  val range = NumberRange(1, 100)
  println(50 in range)    // true
  println(150 in range)   // false

─────────────────────────────────────
DESTRUCTURING with componentN:
─────────────────────────────────────
  class Color(val r: Int, val g: Int, val b: Int) {
      operator fun component1() = r
      operator fun component2() = g
      operator fun component3() = b
  }

  val (r, g, b) = Color(255, 128, 0)
  // data classes get these automatically!

💻 CODE:
data class Vector2D(val x: Double, val y: Double) {
    operator fun plus(other: Vector2D) = Vector2D(x + other.x, y + other.y)
    operator fun minus(other: Vector2D) = Vector2D(x - other.x, y - other.y)
    operator fun times(scalar: Double) = Vector2D(x * scalar, y * scalar)
    operator fun div(scalar: Double) = Vector2D(x / scalar, y / scalar)
    operator fun unaryMinus() = Vector2D(-x, -y)

    val magnitude get() = Math.sqrt(x * x + y * y)

    override fun toString() = "(\${"%.2f".format(x)}, \${"%.2f".format(y)})"
}

// Invokable function object
class Transformation(val name: String, val transform: (Double) -> Double) {
    operator fun invoke(value: Double) = transform(value)
}

// Matrix with get/set
class Matrix2x2(
    var a: Double, var b: Double,
    var c: Double, var d: Double
) {
    operator fun get(row: Int, col: Int): Double = when {
        row == 0 && col == 0 -> a
        row == 0 && col == 1 -> b
        row == 1 && col == 0 -> c
        row == 1 && col == 1 -> d
        else -> throw IndexOutOfBoundsException("Invalid index: [\$row, \$col]")
    }

    operator fun times(other: Matrix2x2) = Matrix2x2(
        a * other.a + b * other.c,   a * other.b + b * other.d,
        c * other.a + d * other.c,   c * other.b + d * other.d
    )

    override fun toString() = "[\$a, \$b | \$c, \$d]"
}

// Comparable version class
data class Version(val major: Int, val minor: Int, val patch: Int = 0)
    : Comparable<Version> {
    override fun compareTo(other: Version) =
        compareValuesBy(this, other, { it.major }, { it.minor }, { it.patch })

    override fun toString() = "\$major.\$minor.\$patch"
}

fun main() {
    // Vector arithmetic
    val v1 = Vector2D(3.0, 4.0)
    val v2 = Vector2D(1.0, 2.0)

    println("v1 = \$v1, magnitude = \${"%.2f".format(v1.magnitude)}")
    println("v1 + v2 = \${v1 + v2}")
    println("v1 - v2 = \${v1 - v2}")
    println("v1 * 2.0 = \${v1 * 2.0}")
    println("v1 / 2.0 = \${v1 / 2.0}")
    println("-v1 = \${-v1}")

    // Invoke operator
    println("\\n--- Invoke ---")
    val doubler = Transformation("double") { it * 2 }
    val squarer = Transformation("square") { it * it }

    println("doubler(5) = \${doubler(5.0)}")
    println("squarer(4) = \${squarer(4.0)}")

    // Matrix multiplication
    println("\\n--- Matrix ---")
    val identity = Matrix2x2(1.0, 0.0, 0.0, 1.0)
    val rotate90 = Matrix2x2(0.0, -1.0, 1.0, 0.0)
    println("Identity: \$identity")
    println("Rotate90: \$rotate90")
    println("[0,0] = \${rotate90[0, 0]}, [0,1] = \${rotate90[0, 1]}")

    // Comparable versions
    println("\\n--- Version comparison ---")
    val versions = listOf(
        Version(2, 0, 0),
        Version(1, 9, 5),
        Version(1, 10, 0),
        Version(2, 1, 0)
    )
    val sorted = versions.sorted()
    println("Sorted: \$sorted")
    println("Min: \${sorted.first()}, Max: \${sorted.last()}")
    println("1.9.5 < 2.0.0: \${Version(1, 9, 5) < Version(2, 0, 0)}")
}

📝 KEY POINTS:
✅ Mark operator functions with the operator keyword
✅ Use operator overloading when it makes domain code more readable
✅ data classes automatically get component1(), component2() etc.
✅ invoke() makes objects callable like functions
✅ compareTo() enables all comparison operators (<, >, <=, >=)
✅ contains() enables the in operator
✅ get()/set() enables index operators: obj[i] and obj[i] = value
✅ Keep overloaded operators behaving like their math counterparts
❌ Don't overload operators in surprising ways — principle of least surprise
❌ operator functions must match the expected signature exactly
❌ plusAssign (+=) and plus (+) should be consistent — if you define both,
   += should behave like a = a + b
❌ Don't overload every operator just because you can
""",
  quiz: [
    Quiz(question: 'What keyword must precede operator function definitions in Kotlin?', options: [
      QuizOption(text: 'operator', correct: true),
      QuizOption(text: 'override', correct: false),
      QuizOption(text: 'infix', correct: false),
      QuizOption(text: 'custom', correct: false),
    ]),
    Quiz(question: 'What function name do you implement to make objects callable with ()?', options: [
      QuizOption(text: 'invoke', correct: true),
      QuizOption(text: 'call', correct: false),
      QuizOption(text: 'execute', correct: false),
      QuizOption(text: 'run', correct: false),
    ]),
    Quiz(question: 'Which operator function enables the use of the in operator with your class?', options: [
      QuizOption(text: 'contains', correct: true),
      QuizOption(text: 'includes', correct: false),
      QuizOption(text: 'has', correct: false),
      QuizOption(text: 'within', correct: false),
    ]),
  ],
);
