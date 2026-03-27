import '../../models/lesson.dart';
import '../../models/quiz.dart';

final kotlinLesson41 = Lesson(
  language: 'Kotlin',
  title: 'Standard Library Overview',
  content: """
🎯 METAPHOR:
The Kotlin standard library is like a fully stocked
professional kitchen. You could technically build everything
from scratch — forge your own knives, grow your own herbs,
make your own pots. But why would you? The kitchen already
has everything a professional needs, organized and ready.
Every great dish starts with the same mise en place:
ingredients prepared, tools within reach. The standard
library is your mise en place — the pre-prepared essentials
so you spend time cooking, not forging knives.

📖 EXPLANATION:
Kotlin's standard library (kotlin-stdlib) is extensive.
It adds thousands of useful extension functions and utilities
on top of the JVM's Java standard library.

─────────────────────────────────────
STRING UTILITIES:
─────────────────────────────────────
  "hello".capitalize()          → "Hello" (deprecated, use replaceFirstChar)
  "hello".replaceFirstChar { it.uppercase() }  → "Hello"
  "  hello  ".trim()            → "hello"
  "  hello  ".trimStart()       → "hello  "
  "  hello  ".trimEnd()         → "  hello"
  "hello".padStart(8, '*')      → "***hello"
  "hello".padEnd(8, '.')        → "hello..."
  "hello world".split(" ")      → ["hello", "world"]
  "a,b,,c".split(",")           → ["a", "b", "", "c"]
  "hello".repeat(3)             → "hellohellohello"
  "hello".reversed()            → "olleh"
  "hello world".count { it == 'l' } → 3
  "123".all { it.isDigit() }    → true
  "abc123".filter { it.isLetter() } → "abc"
  "Hello\nWorld".lines()        → ["Hello", "World"]
  buildString { append("A"); append("B") }  → "AB"

─────────────────────────────────────
NUMBER UTILITIES:
─────────────────────────────────────
  42.coerceIn(0, 100)       → 42
  200.coerceIn(0, 100)      → 100
  (-5).coerceAtLeast(0)     → 0
  200.coerceAtMost(100)     → 100
  Math.abs(-5)              → 5
  5.0.pow(2.0)              → 25.0
  Math.sqrt(16.0)           → 4.0
  (1..10).random()          → random Int in 1..10
  listOf(3,1,4,1,5).min()   → 1
  listOf(3,1,4,1,5).max()   → 5

─────────────────────────────────────
COLLECTION UTILITIES:
─────────────────────────────────────
  listOf(1,2,3).zip(listOf("a","b","c"))
      → [(1,a), (2,b), (3,c)]

  listOf(1,2,3).zipWithNext()
      → [(1,2), (2,3)]

  listOf(1,2,3,4,5).chunked(2)
      → [[1,2], [3,4], [5]]

  listOf(1,2,3,4,5).windowed(3)
      → [[1,2,3], [2,3,4], [3,4,5]]

  listOf(listOf(1,2), listOf(3,4)).flatten()
      → [1, 2, 3, 4]

  listOf(1,2,2,3,3,3).groupingBy { it }.eachCount()
      → {1=1, 2=2, 3=3}

  (1..5).associate { it to it * it }
      → {1=1, 2=4, 3=9, 4=16, 5=25}

  listOf(1,2,3).runningFold(0) { acc, n -> acc + n }
      → [0, 1, 3, 6]

─────────────────────────────────────
SEQUENCE — LAZY EVALUATION:
─────────────────────────────────────
  Sequences are lazy versions of collections.
  Operations are only computed when needed (terminal op).

  // Eager (processes all elements at each step)
  listOf(1..1_000_000)
      .filter { it % 2 == 0 }
      .map { it * it }
      .take(5)

  // Lazy (only computes as many as needed)
  (1..1_000_000).asSequence()
      .filter { it % 2 == 0 }
      .map { it * it }
      .take(5)
      .toList()   // ← terminal — triggers computation

  Use sequences for:
  ✅ Large or infinite data
  ✅ Multiple chained operations
  ❌ Small collections (overhead not worth it)

─────────────────────────────────────
RANGE UTILITIES:
─────────────────────────────────────
  1..10                   → IntRange (inclusive)
  1 until 10              → 1..9 (exclusive end)
  10 downTo 1             → descending
  1..10 step 2            → 1, 3, 5, 7, 9
  'a'..'z'                → CharRange
  "apple".."mango"        → StringRange (lexicographic)

─────────────────────────────────────
TIME MEASUREMENT:
─────────────────────────────────────
  val time = measureTimeMillis {
      // code to measure
  }
  println("Took:\${
time}ms")

  val (result, time2) = measureTimedValue {
      someComputation()
  }
  println("Result: \$result, Time:\${
time2.inWholeMilliseconds}ms")

─────────────────────────────────────
MISCELLANEOUS UTILITIES:
─────────────────────────────────────
  repeat(5) { println(it) }     // 0,1,2,3,4
  check(condition) { "msg" }    // StateException if false
  require(condition) { "msg" }  // ArgException if false
  error("message")              // throws IllegalStateException
  TODO("implement this")        // throws NotImplementedError

  // Identity functions that return their receiver
  42.also { println(it) }       // returns 42
  "hello".let { it.length }     // returns 5

  // Pair and Triple
  val pair = 1 to "one"
  val (n, s) = pair             // destructure

  val triple = Triple(1, "one", true)
  val (a, b, c) = triple

💻 CODE:
import kotlin.math.*
import kotlin.system.measureTimeMillis
import kotlin.time.measureTimedValue

fun stringUtilitiesDemo() {
    println("=== String utilities ===")

    // Building strings
    val report = buildString {
        appendLine("Name: Terry")
        appendLine("Score: 95")
        append("Grade: ")
        append("A")
    }
    println(report)

    // String operations
    val sentence = "  the quick brown fox jumps over the lazy dog  "
    println(sentence.trim().split(" ").count())                // 9 words
    println(sentence.trim().words().map { it.replaceFirstChar { c -> c.uppercase() } }.joinToString(" "))

    // Padding
    println("42".padStart(6, '0'))      // 000042
    println("Done".padEnd(10, '.'))     // Done......

    // Character analysis
    val mixed = "Hello123!@#"
    println("Letters:\${
mixed.filter { it.isLetter() }}")     // Hello
    println("Digits: \${
mixed.filter { it.isDigit() }}")      // 123
    println("Specials:\${
mixed.filter { !it.isLetterOrDigit() }}")  // !@#

    // lines()
    val multiline = "Line 1\nLine 2\nLine 3"
    println("Lines:\${
multiline.lines().size}")  // 3
}

fun numberUtilitiesDemo() {
    println("\\n=== Number utilities ===")

    // Clamping
    println(150.coerceIn(0, 100))       // 100
    println((-5).coerceAtLeast(0))      // 0
    println(200.coerceAtMost(100))      // 100

    // Math functions
    println(sqrt(144.0))                // 12.0
    println(2.0.pow(10.0))             // 1024.0
    println(abs(-42))                   // 42
    println(ceil(3.2))                  // 4.0
    println(floor(3.8))                 // 3.0
    println(round(3.5))                 // 4.0

    // Random
    val random = (1..100).random()
    println("Random 1-100: \$random")

    // Formatting
    val pi = PI
    println("\${
"%.5f".format(pi)}")    // 3.14159
}

fun collectionUtilitiesDemo() {
    println("\\n=== Collection utilities ===")

    val numbers = (1..10).toList()

    // zip and zipWithNext
    val letters = ('a'..'j').toList()
    val zipped = numbers.zip(letters)
    println("Zipped:\${
zipped.take(3)}")   // [(1, a), (2, b), (3, c)]

    val consecutive = numbers.zipWithNext { a, b -> b - a }
    println("Differences: \$consecutive")   // [1, 1, 1, ...] (all 1)

    // chunked and windowed
    println("Chunks of 3:\${
numbers.chunked(3)}")
    println("Windows of 3:\${
numbers.windowed(3).take(4)}")

    // Running totals
    val runningSum = numbers.runningFold(0) { acc, n -> acc + n }
    println("Running sum: \$runningSum")   // [0, 1, 3, 6, 10, ...]

    // associate
    val squares = numbers.associate { it to it * it }
    println("Squares:\${
squares.entries.take(5).map { "\${
it.key}=\${
it.value}" }}")

    // groupingBy eachCount — frequency map
    val words = "the quick brown fox jumps over the lazy fox".split(" ")
    val freq = words.groupingBy { it }.eachCount()
    println("Word frequencies: \$freq")

    // flatten
    val nested = listOf(listOf(1, 2), listOf(3, 4, 5), listOf(6))
    println("Flattened:\${
nested.flatten()}")
}

fun sequenceDemo() {
    println("\\n=== Sequences (lazy evaluation) ===")

    // Infinite sequence — only processes as many as needed
    val fibSequence = generateSequence(Pair(0L, 1L)) { (a, b) -> Pair(b, a + b) }
        .map { it.first }

    println("First 10 Fibonacci:\${
fibSequence.take(10).toList()}")

    // Performance comparison
    val eagerTime = measureTimeMillis {
        (1..1_000_000).filter { it % 2 == 0 }.map { it * it }.take(5).toList()
    }

    val lazyTime = measureTimeMillis {
        (1..1_000_000).asSequence().filter { it % 2 == 0 }.map { it * it }.take(5).toList()
    }

    println("Eager:\${
eagerTime}ms, Lazy:\${
lazyTime}ms")

    // Custom infinite sequence
    val naturals = generateSequence(1) { it + 1 }
    val firstPrimesSquared = naturals
        .filter { n -> (2 until n).none { n % it == 0 } && n > 1 }
        .map { it * it }
        .take(8)
        .toList()
    println("First 8 prime squares: \$firstPrimesSquared")
}

fun miscUtilitiesDemo() {
    println("\\n=== Miscellaneous ===")

    // repeat
    val repeated = buildString { repeat(5) { append("*") } }
    println(repeated)   // *****

    // measureTimedValue
    val (result, duration) = measureTimedValue {
        (1..100_000).filter { it % 7 == 0 }.sum()
    }
    println("Sum of multiples of 7 up to 100,000: \$result")
    println("Computed in:\${
duration.inWholeMilliseconds}ms")

    // Pairs and Triples
    val coords = listOf(1 to 5, 2 to 3, 4 to 1)
    val sorted = coords.sortedBy { (x, y) -> x + y }
    println("Sorted by sum: \$sorted")

    // also for debugging pipelines
    val processed = listOf(1, 2, 3, 4, 5)
        .also { println("Input: \$it") }
        .filter { it % 2 != 0 }
        .also { println("After filter: \$it") }
        .map { it * it }
        .also { println("After map: \$it") }
    println("Final: \$processed")
}

fun String.words() = trim().split("\\s+".toRegex())

fun main() {
    stringUtilitiesDemo()
    numberUtilitiesDemo()
    collectionUtilitiesDemo()
    sequenceDemo()
    miscUtilitiesDemo()
}

📝 KEY POINTS:
✅ buildString is the idiomatic way to build strings piece by piece
✅ coerceIn/coerceAtLeast/coerceAtMost clamp values without if/else
✅ Sequences are lazy — use for large data or multiple chained ops
✅ generateSequence creates infinite lazy sequences safely
✅ runningFold produces cumulative results at each step
✅ groupingBy { }.eachCount() is the idiom for frequency maps
✅ associate { it to transform } builds maps from collections
✅ measureTimeMillis / measureTimedValue benchmark code inline
✅ zipWithNext pairs consecutive elements — great for differences
❌ Don't use sequences for small collections — overhead outweighs benefit
❌ Sequences need a terminal operator (toList, first, etc.) to produce results
❌ generateSequence infinite sequences must use take() or find to terminate
❌ String.repeat() is different from List.repeat() — know your type
""",
  quiz: [
    Quiz(question: 'What is the key advantage of using a Sequence over a List for chained operations?', options: [
      QuizOption(text: 'Sequences are lazy — they only compute values when needed, avoiding processing the entire collection', correct: true),
      QuizOption(text: 'Sequences are always faster than lists for any size of data', correct: false),
      QuizOption(text: 'Sequences are thread-safe; lists are not', correct: false),
      QuizOption(text: 'Sequences support more operators than lists', correct: false),
    ]),
    Quiz(question: 'What does coerceIn(min, max) do to a number?', options: [
      QuizOption(text: 'Returns the number if it is within range, otherwise clamps it to the nearest boundary', correct: true),
      QuizOption(text: 'Throws an exception if the number is outside the range', correct: false),
      QuizOption(text: 'Wraps the number around the range using modulo arithmetic', correct: false),
      QuizOption(text: 'Returns null if the number is outside the specified range', correct: false),
    ]),
    Quiz(question: 'What does generateSequence(seed) { next } produce?', options: [
      QuizOption(text: 'A lazy infinite sequence where each value is computed from the previous one', correct: true),
      QuizOption(text: 'A fixed-length list generated from a seed and transformation function', correct: false),
      QuizOption(text: 'A random sequence of values bounded by the seed', correct: false),
      QuizOption(text: 'A sequence that repeats the seed value indefinitely', correct: false),
    ]),
  ],
);
