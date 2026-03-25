import '../../models/lesson.dart';
import '../../models/quiz.dart';

final kotlinLesson19 = Lesson(
  language: 'Kotlin',
  title: 'Lambdas and Higher-Order Functions',
  content: """
🎯 METAPHOR:
A lambda is like a sticky note with instructions on it.
Instead of writing a full formal letter (a named function),
you scribble the instructions on a sticky note and hand it
to someone. "When you get to step 3, do THIS." The sticky
note (lambda) travels with the code and gets executed at
the right moment. A higher-order function is a function
that ACCEPTS sticky notes — it says: "Give me your
instructions and I'll decide when to run them."
filter, map, and forEach are all higher-order functions —
they take your lambda sticky note and apply it to data.

📖 EXPLANATION:
In Kotlin, functions are first-class citizens — they can
be stored in variables, passed as arguments, and returned
from other functions. Lambdas are the anonymous (unnamed)
version of functions.

─────────────────────────────────────
LAMBDA SYNTAX:
─────────────────────────────────────
  { parameters -> body }

  val greet = { name: String -> "Hello, \$name!" }
  println(greet("Terry"))   // Hello, Terry!

  val add = { a: Int, b: Int -> a + b }
  println(add(3, 4))        // 7

  val sayHi = { println("Hi!") }   // no params, no return
  sayHi()

─────────────────────────────────────
FUNCTION TYPES:
─────────────────────────────────────
A function type describes what a function accepts and returns:

  (Int, Int) -> Int      // takes two Ints, returns Int
  (String) -> Boolean    // takes String, returns Boolean
  () -> Unit             // takes nothing, returns nothing

  val multiply: (Int, Int) -> Int = { a, b -> a * b }

─────────────────────────────────────
it — the implicit single parameter:
─────────────────────────────────────
When a lambda has exactly ONE parameter, you can omit the
parameter declaration and use 'it':

  val double = { x: Int -> x * 2 }    // explicit
  val double2: (Int) -> Int = { it * 2 }  // using 'it'

  listOf(1, 2, 3).map { it * 2 }   // [2, 4, 6]

─────────────────────────────────────
HIGHER-ORDER FUNCTIONS:
─────────────────────────────────────
A function that takes another function as parameter
or returns a function.

  fun operate(a: Int, b: Int, op: (Int, Int) -> Int): Int {
      return op(a, b)
  }

  operate(5, 3) { x, y -> x + y }   // 8
  operate(5, 3) { x, y -> x * y }   // 15

─────────────────────────────────────
TRAILING LAMBDA SYNTAX:
─────────────────────────────────────
If the LAST parameter is a function, you can move the
lambda OUTSIDE the parentheses — this is idiomatic Kotlin:

  // These are identical:
  list.filter({ it > 5 })
  list.filter { it > 5 }       // trailing lambda — preferred

  // If the only parameter is a lambda, drop the parens:
  run { println("Running!") }

─────────────────────────────────────
RETURNING FUNCTIONS:
─────────────────────────────────────
  fun multiplier(factor: Int): (Int) -> Int {
      return { number -> number * factor }
  }

  val triple = multiplier(3)
  println(triple(5))    // 15
  println(triple(10))   // 30

This creates a "factory" of functions — each customized
with a different factor. This pattern is called a closure:
the returned lambda "closes over" (captures) the factor
variable from the outer scope.

─────────────────────────────────────
CLOSURES — capturing variables:
─────────────────────────────────────
  fun makeCounter(): () -> Int {
      var count = 0
      return {
          count++
          count
      }
  }

  val counter = makeCounter()
  println(counter())   // 1
  println(counter())   // 2
  println(counter())   // 3

Each call to counter() remembers 'count' from its scope.

─────────────────────────────────────
INLINE FUNCTIONS:
─────────────────────────────────────
Higher-order functions have overhead — the lambda is
wrapped in an object. inline functions copy the lambda
body at the call site — zero overhead.

  inline fun measure(block: () -> Unit): Long {
      val start = System.currentTimeMillis()
      block()
      return System.currentTimeMillis() - start
  }

Most Kotlin standard library higher-order functions
(filter, map, etc.) are already inline.

💻 CODE:
// Higher-order function
fun applyTwice(x: Int, f: (Int) -> Int): Int = f(f(x))

fun buildGreeter(greeting: String): (String) -> String {
    return { name -> "\$greeting, \$name!" }
}

fun filterAndTransform(
    list: List<Int>,
    predicate: (Int) -> Boolean,
    transform: (Int) -> Int
): List<Int> {
    return list.filter(predicate).map(transform)
}

// Inline function
inline fun timed(label: String, block: () -> Unit) {
    val start = System.currentTimeMillis()
    block()
    println("\$label took ${
System.currentTimeMillis() - start}ms")
}

fun main() {
    // Basic lambda
    val square: (Int) -> Int = { it * it }
    val isEven: (Int) -> Boolean = { it % 2 == 0 }
    val shout: (String) -> String = { it.uppercase() + "!" }

    println(square(7))        // 49
    println(isEven(4))        // true
    println(shout("hello"))   // HELLO!

    // Passing lambdas
    println(applyTwice(3, square))   // 81 (square twice)
    println(applyTwice(3) { it + 10 })  // 23 (add 10 twice)

    // Returning functions
    val hi = buildGreeter("Hi")
    val hey = buildGreeter("Hey")
    println(hi("Terry"))     // Hi, Terry!
    println(hey("Sam"))      // Hey, Sam!

    // Multiple lambda parameters
    val numbers = listOf(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
    val result = filterAndTransform(
        numbers,
        { it % 2 == 0 },    // keep evens
        { it * it }          // square them
    )
    println(result)   // [4, 16, 36, 64, 100]

    // Closure — counter
    fun makeCounter(start: Int = 0): () -> Int {
        var count = start
        return { ++count }
    }

    val c1 = makeCounter()
    val c2 = makeCounter(10)
    println(c1())   // 1
    println(c1())   // 2
    println(c2())   // 11
    println(c1())   // 3

    // Trailing lambda
    val evens = numbers.filter { it % 2 == 0 }
    val squared = evens.map { it * it }
    println(squared)   // [4, 16, 36, 64, 100]

    // run and also
    val greeting = run {
        val base = "Hello"
        val suffix = " World"
        base + suffix
    }
    println(greeting)   // Hello World

    // Inline timed
    timed("Sorting 1000 numbers") {
        (1..1000).shuffled().sorted()
    }
}

📝 KEY POINTS:
✅ Lambda syntax: { params -> body } — concise, powerful
✅ Use 'it' for single-parameter lambdas
✅ Function type: (ParamType) -> ReturnType
✅ Trailing lambda syntax: move last lambda outside parens
✅ Closures capture variables from their enclosing scope
✅ inline functions eliminate lambda object overhead
✅ Higher-order functions enable reusable, composable logic
✅ Returning a function creates a customized function factory
❌ Avoid deep nesting of lambdas — extract to named functions
❌ Don't use non-local returns inside lambdas (only in inline fns)
❌ Mutable state captured in closures can cause confusing bugs
❌ Avoid side effects inside map/filter — they should be pure
""",
  quiz: [
    Quiz(question: 'What does "it" refer to inside a Kotlin lambda?', options: [
      QuizOption(text: 'The implicit name for the single parameter when there is only one', correct: true),
      QuizOption(text: 'The return value of the previous lambda in a chain', correct: false),
      QuizOption(text: 'A reference to the outer class or object', correct: false),
      QuizOption(text: 'The index of the current element in a collection', correct: false),
    ]),
    Quiz(question: 'What is a higher-order function?', options: [
      QuizOption(text: 'A function that takes another function as a parameter or returns a function', correct: true),
      QuizOption(text: 'A function defined at the top level outside any class', correct: false),
      QuizOption(text: 'A function with more than three parameters', correct: false),
      QuizOption(text: 'A function that calls itself recursively', correct: false),
    ]),
    Quiz(question: 'What is the trailing lambda convention in Kotlin?', options: [
      QuizOption(text: 'When the last parameter is a function, the lambda can be placed outside the parentheses', correct: true),
      QuizOption(text: 'Lambdas must always be placed after the function call', correct: false),
      QuizOption(text: 'The last lambda in a chain is automatically returned', correct: false),
      QuizOption(text: 'Trailing lambdas are only valid inside inline functions', correct: false),
    ]),
  ],
);
