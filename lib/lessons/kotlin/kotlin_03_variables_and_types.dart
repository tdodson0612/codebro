import '../../models/lesson.dart';
import '../../models/quiz.dart';

final kotlinLesson03 = Lesson(
  language: 'Kotlin',
  title: 'Variables and Data Types',
  content: """
🎯 METAPHOR:
Variables in Kotlin are like labeled storage bins in a
warehouse. val bins are locked after you put something in —
you can look inside, but you cannot swap out the contents.
var bins are open — you can swap contents any time.
The data type is like the BIN SIZE: a bin sized for
"whole numbers" won't fit a decimal, and a bin sized for
a single character won't fit a whole word. Kotlin is smart
enough to look at what you put in and figure out the bin
size automatically — that's called type inference.

📖 EXPLANATION:
Kotlin is statically typed — every variable has a type
that is determined at compile time. But unlike Java,
you usually don't have to write the type yourself.
Kotlin's compiler infers it from the value you assign.

─────────────────────────────────────
TWO KINDS OF VARIABLES:
─────────────────────────────────────
  val → immutable reference (assign once, cannot reassign)
  var → mutable reference (can reassign anytime)

  val pi = 3.14159      // cannot do pi = 3.0 later
  var count = 0         // can do count = 10 later

PREFER val by default. Only use var when you truly need
to change the value. This prevents bugs.

─────────────────────────────────────
BASIC DATA TYPES:
─────────────────────────────────────
  Type        Size      Range / Use
  ──────────────────────────────────
  Int         32-bit    whole numbers (-2B to 2B)
  Long        64-bit    very large whole numbers
  Short       16-bit    small whole numbers
  Byte        8-bit     tiny numbers (-128 to 127)
  Double      64-bit    decimals (default for decimals)
  Float       32-bit    less precise decimals
  Boolean     1-bit     true or false
  Char        16-bit    single character: 'A'
  String      varies    text: "Hello"

─────────────────────────────────────
TYPE INFERENCE vs EXPLICIT TYPE:
─────────────────────────────────────
  val age = 25            // inferred as Int
  val age: Int = 25       // explicit — same result

  val price = 9.99        // inferred as Double
  val price: Double = 9.99

  val letter = 'K'        // inferred as Char
  val name = "Kotlin"     // inferred as String

─────────────────────────────────────
NULLABLE TYPES — Kotlin's superpower:
─────────────────────────────────────
In Kotlin, a variable CANNOT hold null by default.
You must explicitly declare it nullable with a ?

  var name: String = "Terry"   // cannot be null
  var name: String? = null     // can be null

This eliminates the #1 cause of crashes in Java:
the NullPointerException. Kotlin catches null issues
at compile time instead of at runtime.

─────────────────────────────────────
NUMBER LITERALS — readability helpers:
─────────────────────────────────────
  val million = 1_000_000       // underscores for readability
  val hex = 0xFF                // hexadecimal
  val binary = 0b1010_1010      // binary
  val big = 9_999_999_999L      // Long (note the L suffix)
  val precise = 3.14f           // Float (note the f suffix)

💻 CODE:
fun main() {
    // val — immutable
    val language = "Kotlin"
    val year = 2016
    val isAwesome = true

    // var — mutable
    var score = 0
    score = 100
    score += 50    // score is now 150

    // Explicit types
    val pi: Double = 3.14159
    val grade: Char = 'A'

    // Nullable variable
    var nickname: String? = null
    nickname = "Terry"
    // nickname = null   // still OK — it's nullable

    // Non-nullable — this would be a compile error:
    // var username: String = null  // ❌ ERROR

    // Type conversions — must be explicit in Kotlin
    val x: Int = 42
    val y: Long = x.toLong()      // convert Int to Long
    val z: Double = x.toDouble()  // convert Int to Double
    val s: String = x.toString()  // convert to String

    // Readable number literals
    val population = 8_000_000_000L
    val byteVal: Byte = 127

    println("\$language released in \$year")
    println("Score: \$score")
    println("Pi: \$pi")
    println("Population: \$population")
    println("Nickname: \$nickname")
}

📝 KEY POINTS:
✅ Use val by default — switch to var only when needed
✅ Kotlin infers types — you rarely need to write them
✅ String? means nullable String — String means never null
✅ Use _ in large numbers for readability: 1_000_000
✅ Long literals need L suffix: 9_999_999L
✅ Float literals need f suffix: 3.14f
✅ Type conversions are EXPLICIT — no silent casting
❌ val does not make the object immutable — only the reference
❌ Never use Java's null-unsafe patterns in Kotlin
❌ Int and Long are not interchangeable — use .toLong()
❌ Kotlin has no primitive types — everything is an object
   (the compiler optimizes to primitives under the hood)
""",
  quiz: [
    Quiz(question: 'What is the difference between val and var in Kotlin?', options: [
      QuizOption(text: 'val cannot be reassigned; var can be reassigned', correct: true),
      QuizOption(text: 'val is for numbers; var is for strings', correct: false),
      QuizOption(text: 'val is mutable; var is immutable', correct: false),
      QuizOption(text: 'There is no difference — they are aliases', correct: false),
    ]),
    Quiz(question: 'How do you declare a nullable String in Kotlin?', options: [
      QuizOption(text: 'String?', correct: true),
      QuizOption(text: 'String!', correct: false),
      QuizOption(text: 'Nullable<String>', correct: false),
      QuizOption(text: 'Optional<String>', correct: false),
    ]),
    Quiz(question: 'What is the default type inferred for 3.14 in Kotlin?', options: [
      QuizOption(text: 'Double', correct: true),
      QuizOption(text: 'Float', correct: false),
      QuizOption(text: 'Decimal', correct: false),
      QuizOption(text: 'Number', correct: false),
    ]),
  ],
);
