import '../../models/lesson.dart';
import '../../models/quiz.dart';

final kotlinLesson05 = Lesson(
  language: 'Kotlin',
  title: 'Operators',
  content: """
🎯 METAPHOR:
Operators are the verbs of programming — they DO things.
Just like English has action verbs (run, jump, compare),
operators perform actions on values: add them, subtract them,
compare them, combine logic. The operands are the nouns
(the things being acted on). "5 + 3" is a tiny sentence:
noun, verb, noun. Every expression you write is built from
these atomic building blocks.

📖 EXPLANATION:
Kotlin has all the standard operators you'd expect, plus
some smart extras. They fall into clear categories.

─────────────────────────────────────
ARITHMETIC OPERATORS:
─────────────────────────────────────
  Operator  Meaning         Example     Result
  ──────────────────────────────────────────
  +         addition        5 + 3       8
  -         subtraction     10 - 4      6
  *         multiplication  3 * 4       12
  /         division        10 / 3      3   (integer division!)
  %         modulo (remain) 10 % 3      1
  
⚠️ Integer division: 10 / 3 = 3, not 3.33
   To get decimal: 10.0 / 3 = 3.333...
   Or: 10.toDouble() / 3

─────────────────────────────────────
ASSIGNMENT OPERATORS:
─────────────────────────────────────
  =     assign            x = 5
  +=    add and assign    x += 3   → x = x + 3
  -=    sub and assign    x -= 2   → x = x - 2
  *=    mul and assign    x *= 4   → x = x * 4
  /=    div and assign    x /= 2   → x = x / 2
  %=    mod and assign    x %= 3   → x = x % 3

─────────────────────────────────────
COMPARISON OPERATORS:
─────────────────────────────────────
  ==    equal to          5 == 5    → true
  !=    not equal         5 != 3    → true
  >     greater than      7 > 4     → true
  <     less than         3 < 9     → true
  >=    greater or equal  5 >= 5    → true
  <=    less or equal     4 <= 6    → true

All comparisons return Boolean (true or false).

─────────────────────────────────────
LOGICAL OPERATORS:
─────────────────────────────────────
  &&    AND — both must be true
  ||    OR  — at least one must be true
  !     NOT — flips true/false

  Think of && as "AND in a contract" — ALL conditions met.
  Think of || as "OR on a menu" — ANY option qualifies.
  Think of ! as a light switch flip.

  true && true   → true
  true && false  → false
  false || true  → true
  !true          → false

Short-circuit evaluation:
  && stops at first false (no point checking the rest)
  || stops at first true  (no point checking the rest)

─────────────────────────────────────
INCREMENT / DECREMENT:
─────────────────────────────────────
  ++    increment by 1   (x++ or ++x)
  --    decrement by 1   (x-- or --x)

  val a = 5
  println(a++)   // prints 5, THEN increments → a is now 6
  println(++a)   // increments FIRST, then prints → prints 7

─────────────────────────────────────
RANGE OPERATOR:
─────────────────────────────────────
Unique to Kotlin — creates a range of values.

  1..10       → 1 to 10 inclusive
  1 until 10  → 1 to 9  (excludes 10)
  10 downTo 1 → 10 to 1 descending

─────────────────────────────────────
in and !in OPERATORS:
─────────────────────────────────────
Check if a value is inside a range or collection.

  5 in 1..10       → true
  15 in 1..10      → false
  'a' in 'a'..'z' → true

─────────────────────────────────────
KOTLIN-SPECIFIC: ELVIS OPERATOR ?:
─────────────────────────────────────
Named after Elvis Presley's hair (seriously).
Returns the left side if not null, right side if null.

  val name: String? = null
  val display = name ?: "Anonymous"   // "Anonymous"

Like saying: "use this value — or ELSE use this default."

💻 CODE:
fun main() {
    // Arithmetic
    val a = 17
    val b = 5
    println(a + b)     // 22
    println(a - b)     // 12
    println(a * b)     // 85
    println(a / b)     // 3  (integer division)
    println(a % b)     // 2  (remainder)
    println(a.toDouble() / b)  // 3.4

    // Compound assignment
    var score = 100
    score += 50
    score -= 20
    score *= 2
    println(score)     // 260

    // Comparison
    println(10 > 5)    // true
    println(3 == 3)    // true
    println(7 != 7)    // false

    // Logical
    val hot = true
    val sunny = true
    println(hot && sunny)   // true — both true
    println(hot && !sunny)  // false
    println(!hot || sunny)  // true

    // Range and in
    val grade = 85
    println(grade in 80..89)    // true — B range
    println(grade in 90..100)   // false

    for (i in 1..5) print("\$i ")    // 1 2 3 4 5
    println()
    for (i in 1 until 5) print("\$i ") // 1 2 3 4
    println()
    for (i in 5 downTo 1) print("\$i ") // 5 4 3 2 1
    println()

    // Elvis operator
    val nickname: String? = null
    val displayName = nickname ?: "Guest"
    println(displayName)    // Guest

    val realName: String? = "Terry"
    val name = realName ?: "Guest"
    println(name)           // Terry
}

📝 KEY POINTS:
✅ Integer division truncates — 7 / 2 = 3, not 3.5
✅ Use .toDouble() to get decimal division results
✅ && and || are short-circuit — they stop early
✅ .. creates inclusive ranges; until creates exclusive
✅ in checks membership in ranges and collections
✅ ?: (Elvis) is the null-coalescing operator
✅ == checks value equality; === checks reference identity
❌ Don't forget % is modulo (remainder), not percentage
❌ x++ and ++x behave differently when used in expressions
❌ Don't use & or | (single) for logical ops — those are bitwise
""",
  quiz: [
    Quiz(question: 'What does 10 / 3 evaluate to in Kotlin when both are Int?', options: [
      QuizOption(text: '3 — integer division truncates the decimal', correct: true),
      QuizOption(text: '3.33 — Kotlin always returns a decimal', correct: false),
      QuizOption(text: '4 — it rounds up', correct: false),
      QuizOption(text: 'An error — division requires Doubles', correct: false),
    ]),
    Quiz(question: 'What does the Elvis operator ?: do?', options: [
      QuizOption(text: 'Returns the left side if not null, otherwise returns the right side', correct: true),
      QuizOption(text: 'Throws an exception if the left side is null', correct: false),
      QuizOption(text: 'Compares two nullable values for equality', correct: false),
      QuizOption(text: 'Converts a nullable type to a non-nullable type forcefully', correct: false),
    ]),
    Quiz(question: 'What is the difference between 1..10 and 1 until 10?', options: [
      QuizOption(text: '1..10 includes 10; 1 until 10 excludes 10', correct: true),
      QuizOption(text: 'They are identical', correct: false),
      QuizOption(text: '1 until 10 includes 10; 1..10 excludes 10', correct: false),
      QuizOption(text: '1..10 is for Ints only; until works for any Comparable', correct: false),
    ]),
  ],
);
