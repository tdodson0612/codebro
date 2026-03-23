import '../../models/lesson.dart';
import '../../models/quiz.dart';

final kotlinLesson06 = Lesson(
  language: 'Kotlin',
  title: 'Control Flow: if and when',
  content: """
🎯 METAPHOR:
if/when are the decision-makers of your program — like a
traffic cop at a busy intersection. A car (value) arrives,
the cop looks at it, and directs it: "Red car? Go left.
Blue truck? Go right. Everything else? Straight ahead."
Without decision-making code, your program would do the
same thing every single time — no matter what input it gets.
if and when give your program the ability to react.

📖 EXPLANATION:
Kotlin has two conditional constructs: if and when.
Both are EXPRESSIONS — meaning they return a value.
This is different from Java, where if is a statement only.

─────────────────────────────────────
IF AS A STATEMENT:
─────────────────────────────────────
  if (condition) {
      // runs when true
  } else if (otherCondition) {
      // runs when otherCondition is true
  } else {
      // runs when all others are false
  }

─────────────────────────────────────
IF AS AN EXPRESSION:
─────────────────────────────────────
In Kotlin, if can return a value — so you don't need
the ternary operator (?:) that Java and C have.

  val max = if (a > b) a else b
  
  This replaces Java's:  int max = (a > b) ? a : b;

When used as an expression, the else branch is required.

─────────────────────────────────────
WHEN — Kotlin's switch statement (but better):
─────────────────────────────────────
when is far more powerful than Java's switch:

  when (value) {
      1       -> "one"
      2, 3    -> "two or three"      // multiple values!
      in 4..9 -> "four to nine"      // ranges!
      else    -> "something else"    // default
  }

when can also be used WITHOUT an argument — like a
chain of if/else if:

  when {
      x < 0  -> println("negative")
      x == 0 -> println("zero")
      else   -> println("positive")
  }

─────────────────────────────────────
WHEN AS AN EXPRESSION:
─────────────────────────────────────
Like if, when can return a value:

  val grade = when (score) {
      in 90..100 -> "A"
      in 80..89  -> "B"
      in 70..79  -> "C"
      else       -> "F"
  }

When used as an expression, else is required.

─────────────────────────────────────
WHEN WITH TYPE CHECKING:
─────────────────────────────────────
when can check the TYPE of a variable — very powerful
when dealing with different types:

  when (obj) {
      is String -> println("It's a string: \$obj")
      is Int    -> println("It's an int: \$obj")
      else      -> println("Unknown type")
  }

💻 CODE:
fun main() {
    val temperature = 72

    // Basic if/else
    if (temperature > 80) {
        println("Hot day!")
    } else if (temperature > 60) {
        println("Nice day!")
    } else {
        println("Cold day!")
    }

    // if as expression — replaces ternary operator
    val weather = if (temperature > 70) "warm" else "cool"
    println("It is \$weather outside.")

    // Multi-line if expression
    val description = if (temperature > 90) {
        "Extremely hot — stay hydrated"
    } else if (temperature > 70) {
        "Comfortable — great day to go out"
    } else {
        "Chilly — grab a jacket"
    }
    println(description)

    // when as a statement
    val dayNum = 3
    when (dayNum) {
        1 -> println("Monday")
        2 -> println("Tuesday")
        3 -> println("Wednesday")
        4 -> println("Thursday")
        5 -> println("Friday")
        6, 7 -> println("Weekend!")
        else -> println("Invalid day")
    }

    // when as an expression
    val score = 87
    val grade = when (score) {
        in 90..100 -> "A"
        in 80..89  -> "B"
        in 70..79  -> "C"
        in 60..69  -> "D"
        else       -> "F"
    }
    println("Grade: \$grade")

    // when without argument
    val x = -5
    when {
        x < 0  -> println("\$x is negative")
        x == 0 -> println("\$x is zero")
        else   -> println("\$x is positive")
    }

    // when with type checking
    val items = listOf("hello", 42, 3.14, true)
    for (item in items) {
        val result = when (item) {
            is String  -> "String: \$item"
            is Int     -> "Int: \$item"
            is Double  -> "Double: \$item"
            is Boolean -> "Boolean: \$item"
            else       -> "Unknown"
        }
        println(result)
    }
}

📝 KEY POINTS:
✅ if is an expression in Kotlin — it can return a value
✅ when replaces switch — and is far more powerful
✅ when can match ranges: in 1..10 ->
✅ when can match multiple values: 1, 2, 3 ->
✅ when can match types: is String ->
✅ when can work without an argument (like if/else chain)
✅ else is required when if or when is used as an expression
❌ No ternary operator in Kotlin — use if as expression instead
❌ when branches don't fall through (no need for break!)
❌ when else is only optional when used as a statement,
   and when the compiler can verify all cases are covered
""",
  quiz: [
    Quiz(question: 'What makes Kotlin\'s if special compared to Java\'s if?', options: [
      QuizOption(text: 'In Kotlin, if is an expression and can return a value', correct: true),
      QuizOption(text: 'Kotlin\'s if supports more comparison operators', correct: false),
      QuizOption(text: 'Kotlin\'s if requires curly braces on all branches', correct: false),
      QuizOption(text: 'Kotlin\'s if automatically handles null checks', correct: false),
    ]),
    Quiz(question: 'In a Kotlin when expression, what does the else branch represent?', options: [
      QuizOption(text: 'The default case when no other branch matches', correct: true),
      QuizOption(text: 'An error handler that runs when an exception occurs', correct: false),
      QuizOption(text: 'A branch that always runs after the matching branch', correct: false),
      QuizOption(text: 'The first branch to be evaluated', correct: false),
    ]),
    Quiz(question: 'Which of these is a valid when branch in Kotlin?', options: [
      QuizOption(text: 'in 1..10 -> "small number"', correct: true),
      QuizOption(text: 'case 1..10: "small number"', correct: false),
      QuizOption(text: 'between(1, 10) -> "small number"', correct: false),
      QuizOption(text: '1 to 10 -> "small number"', correct: false),
    ]),
  ],
);
