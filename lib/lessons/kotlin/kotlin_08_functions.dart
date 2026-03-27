import '../../models/lesson.dart';
import '../../models/quiz.dart';

final kotlinLesson08 = Lesson(
  language: 'Kotlin',
  title: 'Functions',
  content: """
🎯 METAPHOR:
A function is like a recipe card in a cookbook. You write
the recipe once — ingredients (parameters), steps (body),
result (return value) — and you can use it as many times as
you want without rewriting it. "Make pizza" means the same
thing whether you make it Monday or Friday, for 2 people
or 20. You just call the recipe and it runs. Functions are
the recipe cards of programming.

📖 EXPLANATION:
Functions in Kotlin are declared with the fun keyword.
They can take parameters, return values, have default
argument values, accept named arguments, and can be
written as single-line expressions.

─────────────────────────────────────
BASIC FUNCTION SYNTAX:
─────────────────────────────────────
  fun functionName(param: Type, param2: Type): ReturnType {
      // body
      return value
  }

  fun add(a: Int, b: Int): Int {
      return a + b
  }

─────────────────────────────────────
SINGLE-EXPRESSION FUNCTIONS:
─────────────────────────────────────
If the function body is one expression, Kotlin lets you
write it on one line with =. The return type is inferred.

  fun add(a: Int, b: Int) = a + b
  fun square(x: Int) = x * x
  fun greet(name: String) = "Hello, \$name!"

This is not just shorthand — it's idiomatic Kotlin.

─────────────────────────────────────
UNIT — the "void" of Kotlin:
─────────────────────────────────────
Functions that don't return a meaningful value return Unit.
You don't have to write it explicitly (like void in Java).

  fun printHello(): Unit { println("Hello") }
  fun printHello() { println("Hello") }   // same thing

─────────────────────────────────────
DEFAULT PARAMETER VALUES:
─────────────────────────────────────
Parameters can have default values — callers can omit them.

  fun greet(name: String, greeting: String = "Hello") {
      println("\$greeting, \$name!")
  }

  greet("Terry")             // Hello, Terry!
  greet("Terry", "Hey")      // Hey, Terry!

This replaces Java's method overloading in most cases.

─────────────────────────────────────
NAMED ARGUMENTS:
─────────────────────────────────────
Call functions with argument names for clarity.
Order doesn't matter when using named args.

  fun createUser(name: String, age: Int, admin: Boolean = false)

  createUser(name = "Terry", age = 30)
  createUser(age = 25, name = "Sam", admin = true)  // order changed

─────────────────────────────────────
VARARG — variable number of arguments:
─────────────────────────────────────
Accept any number of arguments of the same type.

  fun sum(vararg numbers: Int): Int {
      return numbers.sum()
  }
  sum(1, 2, 3, 4, 5)   // 15

Use the spread operator * to pass an array as vararg:
  val nums = intArrayOf(1, 2, 3)
  sum(*nums)

─────────────────────────────────────
FUNCTION SCOPE:
─────────────────────────────────────
Functions can be declared at the top level (no class needed),
inside a class (member functions), or inside other functions
(local functions — for helper logic that only belongs inside).

  fun outerFunction() {
      fun helperFunction() {    // local function
          println("I only exist in here")
      }
      helperFunction()
  }

─────────────────────────────────────
NOTHING RETURN TYPE:
─────────────────────────────────────
Nothing means the function NEVER returns normally
(it always throws or loops forever).

  fun fail(message: String): Nothing {
      throw IllegalStateException(message)
  }

💻 CODE:
// Top-level functions — no class required
fun add(a: Int, b: Int): Int {
    return a + b
}

// Single-expression function
fun multiply(a: Int, b: Int) = a * b

// Default parameters
fun greet(name: String, greeting: String = "Hello") {
    println("\$greeting, \$name!")
}

// Named arguments + defaults
fun createProfile(
    username: String,
    level: Int = 1,
    isAdmin: Boolean = false
) {
    println("User: \$username | Level: \$level | Admin: \$isAdmin")
}

// Vararg
fun logAll(vararg messages: String) {
    for (msg in messages) println("[LOG] \$msg")
}

// Local function
fun processData(data: List<Int>): Int {
    fun isValid(n: Int) = n > 0   // helper — only accessible here
    return data.filter { isValid(it) }.sum()
}

fun main() {
    // Basic call
    println(add(3, 4))            // 7
    println(multiply(5, 6))       // 30

    // Default args
    greet("Terry")                // Hello, Terry!
    greet("Sam", "Hey")           // Hey, Sam!

    // Named args
    createProfile(username = "terry99")
    createProfile(username = "admin_sam", level = 10, isAdmin = true)
    createProfile(isAdmin = false, username = "bob", level = 3)

    // Vararg
    logAll("App started", "User logged in", "Data loaded")

    // Local function usage
    val data = listOf(-3, 5, -1, 8, 2, 0)
    println("Sum of positives:\${
processData(data)}")   // 15

    // Spread operator with vararg
    val extras = arrayOf("Config loaded", "Ready")
    logAll(*extras)
}

📝 KEY POINTS:
✅ fun is the keyword for all functions in Kotlin
✅ Single-expression functions with = are idiomatic
✅ Default parameter values reduce need for overloading
✅ Named arguments make calls self-documenting
✅ vararg accepts any number of args; use * to spread arrays
✅ Local functions are useful for internal helper logic
✅ Unit is Kotlin's void — you rarely need to write it
✅ Top-level functions don't require a class wrapper
❌ Don't name parameters the same as outer variables — confusing
❌ vararg must be the last parameter (or use named args)
❌ Don't overuse default parameters as a replacement for
   proper architecture — too many defaults = confusing API
""",
  quiz: [
    Quiz(question: 'What is the Kotlin equivalent of void for a function that returns nothing meaningful?', options: [
      QuizOption(text: 'Unit', correct: true),
      QuizOption(text: 'Void', correct: false),
      QuizOption(text: 'Nothing', correct: false),
      QuizOption(text: 'null', correct: false),
    ]),
    Quiz(question: 'Which syntax correctly defines a single-expression function in Kotlin?', options: [
      QuizOption(text: 'fun square(x: Int) = x * x', correct: true),
      QuizOption(text: 'fun square(x: Int) => x * x', correct: false),
      QuizOption(text: 'fun square(x: Int) { return x * x }', correct: false),
      QuizOption(text: 'fun square(x: Int): x * x', correct: false),
    ]),
    Quiz(question: 'What is the purpose of named arguments when calling a function?', options: [
      QuizOption(text: 'They allow passing arguments in any order and improve readability', correct: true),
      QuizOption(text: 'They are required when a function has more than two parameters', correct: false),
      QuizOption(text: 'They prevent the function from using default parameter values', correct: false),
      QuizOption(text: 'They make the function run faster by skipping type checking', correct: false),
    ]),
  ],
);
