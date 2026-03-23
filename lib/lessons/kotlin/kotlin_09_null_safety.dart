import '../../models/lesson.dart';
import '../../models/quiz.dart';

final kotlinLesson09 = Lesson(
  language: 'Kotlin',
  title: 'Null Safety',
  content: """
🎯 METAPHOR:
Null is like an empty package on a conveyor belt.
Every worker (function) on the line expects a box with
something in it. When an empty package arrives, they reach
in, find nothing, and the entire factory line CRASHES —
that's a NullPointerException. Java lets empty packages
slip through undetected. Kotlin installs a scanner at the
START of the line: "Is this package possibly empty?
Mark it clearly — and every worker downstream must check
before opening it." The scanner catches the problem at the
ENTRY POINT, not when it's too late.

📖 EXPLANATION:
Null safety is Kotlin's single biggest improvement over Java.
Tony Hoare, who invented null references in 1965, called it
his "billion-dollar mistake" — it has caused countless
crashes and bugs. Kotlin fixes this at the language level.

─────────────────────────────────────
NON-NULLABLE vs NULLABLE:
─────────────────────────────────────
  var name: String = "Terry"    // CANNOT be null
  var name: String? = null      // CAN be null

  name = null    // ❌ COMPILE ERROR — name is non-nullable
  
The ? after the type is the signal. Without it, null is
rejected at compile time — not at runtime.

─────────────────────────────────────
SAFE CALL OPERATOR: ?.
─────────────────────────────────────
Call a method or access a property on a nullable variable.
If the variable is null, returns null instead of crashing.

  val name: String? = null
  println(name?.length)   // prints: null (no crash)
  
  val upper = name?.uppercase()   // null if name is null

Think of ?. as: "If not null, do this. Otherwise, skip."

─────────────────────────────────────
ELVIS OPERATOR: ?:
─────────────────────────────────────
Provide a default value when something is null.

  val name: String? = null
  val display = name ?: "Anonymous"   // "Anonymous"

  val length = name?.length ?: 0      // 0 if name is null

Combine safe call with Elvis for clean null handling:
  expression?.property ?: defaultValue

─────────────────────────────────────
NON-NULL ASSERTION: !!
─────────────────────────────────────
Forces a nullable type to be treated as non-nullable.
If the value IS null, throws NullPointerException.

  val name: String? = "Terry"
  val upper = name!!.uppercase()   // OK — name is not null

  val nullName: String? = null
  nullName!!.uppercase()   // ❌ THROWS NullPointerException

Use !! only when you are 100% certain it's not null.
It's the "I know what I'm doing, compiler — trust me" button.
Overusing !! defeats the purpose of Kotlin's null safety.

─────────────────────────────────────
SMART CASTS:
─────────────────────────────────────
After you check for null with if, Kotlin automatically
treats the variable as non-nullable inside that block.

  val name: String? = "Terry"
  
  if (name != null) {
      println(name.length)  // no ?. needed — Kotlin knows!
  }

This is called a smart cast — Kotlin tracks what you've
checked and adjusts the type accordingly.

─────────────────────────────────────
let WITH NULLABLE TYPES:
─────────────────────────────────────
Use let to run a block only when a value is non-null.

  val email: String? = "terry@email.com"
  email?.let {
      println("Sending to: \$it")   // only runs if non-null
  }

─────────────────────────────────────
NULLABLE IN COLLECTIONS:
─────────────────────────────────────
  List<String?>  → list of nullable strings
  List<String>?  → nullable list of non-nullable strings
  List<String?>? → nullable list of nullable strings

  // Filter out nulls from a nullable list
  val items: List<String?> = listOf("a", null, "b", null)
  val nonNull: List<String> = items.filterNotNull()

💻 CODE:
fun main() {
    // Non-nullable — cannot assign null
    var name: String = "Terry"
    // name = null  // ❌ COMPILE ERROR

    // Nullable — can be null
    var nickname: String? = null

    // Safe call — no crash
    println(nickname?.length)         // null
    println(nickname?.uppercase())    // null

    nickname = "Terry"
    println(nickname?.length)         // 5

    // Elvis operator — provide default
    val display = nickname ?: "Anonymous"
    println(display)                  // Terry

    val nullNick: String? = null
    val fallback = nullNick ?: "Guest"
    println(fallback)                 // Guest

    // Chained safe call + Elvis
    val user: String? = null
    val len = user?.length ?: -1
    println(len)                      // -1

    // Smart cast
    val maybeNull: String? = "Kotlin"
    if (maybeNull != null) {
        println(maybeNull.uppercase()) // Smart cast — no ?. needed
    }

    // let block — only runs when non-null
    val email: String? = "terry@example.com"
    email?.let {
        println("Email found: \$it")
        println("Domain: \${it.substringAfter('@')}")
    }

    val noEmail: String? = null
    noEmail?.let {
        println("This won't print")   // skipped
    }

    // Non-null assertion !!
    val certain: String? = "definitely not null"
    println(certain!!.length)   // 22

    // filterNotNull
    val mixed: List<String?> = listOf("apple", null, "banana", null)
    val clean: List<String> = mixed.filterNotNull()
    println(clean)   // [apple, banana]
}

📝 KEY POINTS:
✅ Add ? after a type to make it nullable: String?
✅ Use ?. (safe call) to access nullable properties safely
✅ Use ?: (Elvis) to provide a fallback when null
✅ Smart casts eliminate the need for repeated null checks
✅ Use let to execute a block only when a value is non-null
✅ filterNotNull() removes nulls from a list
✅ Non-nullable by default is Kotlin's biggest safety win
❌ Avoid !! unless you are absolutely sure the value is non-null
❌ Never chain multiple !! operators — one null = crash
❌ List<String?> and List<String>? are different things
❌ Don't confuse ?. (safe call) with ?: (Elvis operator)
""",
  quiz: [
    Quiz(question: 'What does the safe call operator ?. do when the variable is null?', options: [
      QuizOption(text: 'It returns null instead of throwing a NullPointerException', correct: true),
      QuizOption(text: 'It throws a NullPointerException immediately', correct: false),
      QuizOption(text: 'It uses the default value defined by the class', correct: false),
      QuizOption(text: 'It calls the function with an empty string instead', correct: false),
    ]),
    Quiz(question: 'What does the !! operator do in Kotlin?', options: [
      QuizOption(text: 'Asserts the value is non-null — throws NullPointerException if it is null', correct: true),
      QuizOption(text: 'Converts a nullable type to a non-nullable type safely', correct: false),
      QuizOption(text: 'Checks for null and provides a default value', correct: false),
      QuizOption(text: 'Prints a warning if the value might be null', correct: false),
    ]),
    Quiz(question: 'What is a "smart cast" in Kotlin?', options: [
      QuizOption(text: 'After a null check, Kotlin automatically treats the variable as non-nullable', correct: true),
      QuizOption(text: 'Kotlin automatically converts Int to Double when needed', correct: false),
      QuizOption(text: 'The compiler casts types at compile time to avoid runtime overhead', correct: false),
      QuizOption(text: 'Kotlin infers the type of a variable from its first assignment', correct: false),
    ]),
  ],
);
