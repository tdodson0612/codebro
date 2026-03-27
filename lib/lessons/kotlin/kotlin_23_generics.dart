import '../../models/lesson.dart';
import '../../models/quiz.dart';

final kotlinLesson23 = Lesson(
  language: 'Kotlin',
  title: 'Generics',
  content: """
🎯 METAPHOR:
Generics are like a universal shipping container. The
container doesn't care what's inside — cars, electronics,
furniture, food. The container works the same regardless.
But once you LABEL a container "Electronics Only," the
workers know exactly what to expect inside and can handle
it appropriately. Generics let you write code that works
for ANY type — and then, at the call site, you specify
exactly what type you're working with. One container design,
infinite contents. Complete type safety. No surprises.

📖 EXPLANATION:
Generics let you write code that works with different types
while maintaining type safety. Without generics, you'd either
need to write duplicate code for each type, or use Any and
lose all type checking.

─────────────────────────────────────
GENERIC FUNCTIONS:
─────────────────────────────────────
  fun <T> identity(value: T): T = value

  identity(42)        // returns Int
  identity("hello")   // returns String
  identity(3.14)      // returns Double

The <T> declares a type parameter. T is just a name —
by convention: T (type), E (element), K (key), V (value),
R (return).

─────────────────────────────────────
GENERIC CLASSES:
─────────────────────────────────────
  class Box<T>(val content: T) {
      fun get(): T = content
      fun describe() = "Box contains: \$content"
  }

  val intBox = Box(42)
  val strBox = Box("Hello")
  println(intBox.get())    // 42
  println(strBox.get())    // Hello

─────────────────────────────────────
TYPE CONSTRAINTS — upper bounds:
─────────────────────────────────────
Restrict what types can be used with <T : UpperBound>:

  fun <T : Comparable<T>> max(a: T, b: T): T {
      return if (a > b) a else b
  }

  max(3, 7)           // 7 — Int implements Comparable
  max("apple", "z")   // z — String implements Comparable
  // max(listOf(1), listOf(2))  // ERROR — List not Comparable

Multiple constraints with where:
  fun <T> process(item: T) where T : Serializable, T : Comparable<T>

─────────────────────────────────────
VARIANCE — in, out, and *:
─────────────────────────────────────
Variance controls how generic types relate to their
subtypes. This is one of the trickier parts of generics.

OUT (covariant) — producer:
  If a class only PRODUCES T (returns it, never takes it):
  class Producer<out T> { fun produce(): T }

  A Producer<String> can be used where Producer<Any> is expected.
  The 'out' means: "T only comes OUT."

IN (contravariant) — consumer:
  If a class only CONSUMES T (takes it, never returns it):
  class Consumer<in T> { fun consume(item: T) }

  A Consumer<Any> can be used where Consumer<String> is expected.
  The 'in' means: "T only goes IN."

Star projection (*):
  When you don't care about the type:
  fun printAll(list: List<*>) {
      list.forEach { println(it) }
  }

─────────────────────────────────────
REIFIED TYPE PARAMETERS:
─────────────────────────────────────
Normally, generic types are ERASED at runtime (JVM limitation).
With inline + reified, you can use the type at runtime:

  inline fun <reified T> List<*>.filterIsInstance(): List<T> {
      return this.filterIsInstance<T>()
  }

  val mixed: List<Any> = listOf(1, "hello", 2.0, "world")
  val strings = mixed.filterIsInstance<String>()
  // ["hello", "world"]

  // Also useful for type checking:
  inline fun <reified T> isType(value: Any): Boolean = value is T

💻 CODE:
// Generic function
fun <T> printItem(item: T) = println("Item: \$item (\${
item!!::class.simpleName})")

fun <T> List<T>.second(): T {
    if (size < 2) throw NoSuchElementException("List has fewer than 2 elements")
    return this[1]
}

// Generic class
class Pair<A, B>(val first: A, val second: B) {
    override fun toString() = "(\$first, \$second)"
    fun swap() = Pair(second, first)
}

// Generic with constraint
fun <T : Comparable<T>> clamp(value: T, min: T, max: T): T {
    return when {
        value < min -> min
        value > max -> max
        else -> value
    }
}

// Generic stack
class Stack<T> {
    private val elements = mutableListOf<T>()

    fun push(item: T) { elements.add(item) }

    fun pop(): T {
        if (elements.isEmpty()) throw EmptyStackException()
        return elements.removeAt(elements.size - 1)
    }

    fun peek(): T? = elements.lastOrNull()
    fun isEmpty() = elements.isEmpty()
    val size get() = elements.size

    override fun toString() = "Stack\$elements"
}

class EmptyStackException : Exception("Stack is empty")

// Covariant (out) — read-only producer
class ReadOnlyBox<out T>(private val value: T) {
    fun get(): T = value
}

// Generic result type with variance
sealed class ApiResult<out T> {
    data class Success<T>(val data: T) : ApiResult<T>()
    data class Error(val message: String) : ApiResult<Nothing>()
}

// Reified type — access type info at runtime
inline fun <reified T> List<Any>.ofType(): List<T> = filterIsInstance<T>()
inline fun <reified T> Any.isInstanceOf(): Boolean = this is T

fun main() {
    // Generic function
    printItem(42)
    printItem("Kotlin")
    printItem(3.14)

    val nums = listOf(10, 20, 30)
    println(nums.second())   // 20

    // Generic class — Pair
    val p1 = Pair("Terry", 30)
    val p2 = Pair(3.14, true)
    println(p1)           // (Terry, 30)
    println(p1.swap())    // (30, Terry)
    println(p2)           // (3.14, true)

    // Constrained generic
    println(clamp(5, 1, 10))      // 5
    println(clamp(-5, 1, 10))     // 1 (below min)
    println(clamp(100, 1, 10))    // 10 (above max)
    println(clamp("dog", "ant", "zebra"))  // dog

    // Generic stack
    val stack = Stack<String>()
    stack.push("first")
    stack.push("second")
    stack.push("third")
    println(stack)           // Stack[first, second, third]
    println(stack.pop())     // third
    println(stack.peek())    // second
    println(stack.size)      // 2

    // Covariant box
    val strBox: ReadOnlyBox<String> = ReadOnlyBox("Hello")
    val anyBox: ReadOnlyBox<Any> = strBox   // OK — out makes this safe
    println(anyBox.get())   // Hello

    // ApiResult
    fun fetchUser(id: Int): ApiResult<String> {
        return if (id > 0) ApiResult.Success("User #\$id")
        else ApiResult.Error("Invalid ID")
    }

    when (val result = fetchUser(5)) {
        is ApiResult.Success -> println("Got:\${
result.data}")
        is ApiResult.Error   -> println("Error:\${
result.message}")
    }

    // Reified types
    val mixed: List<Any> = listOf(1, "hello", 2.0, "world", 42, true)
    val strings = mixed.ofType<String>()
    val ints = mixed.ofType<Int>()
    println("Strings: \$strings")   // [hello, world]
    println("Ints: \$ints")         // [1, 42]

    println("hello".isInstanceOf<String>())   // true
    println(42.isInstanceOf<String>())        // false
}

📝 KEY POINTS:
✅ <T> declares a type parameter — T is just a conventional name
✅ Type constraints: <T : UpperBound> restricts what T can be
✅ out (covariant) — safe to produce T, use for read-only
✅ in (contravariant) — safe to consume T, use for write-only
✅ * (star projection) — use when you don't care about the type
✅ reified requires inline — lets you use T at runtime
✅ Generic classes work with any type while preserving type safety
❌ Generic type info is erased at runtime without reified
❌ Don't overuse generics — simple code beats clever code
❌ Variance mistakes cause compile errors — if in doubt, use *
❌ You cannot use T in is checks without reified: value is T fails
""",
  quiz: [
    Quiz(question: 'What does the out keyword mean on a generic type parameter?', options: [
      QuizOption(text: 'The type is covariant — the class only produces T, making it safe to use as a supertype', correct: true),
      QuizOption(text: 'The type parameter is optional and can be omitted at the call site', correct: false),
      QuizOption(text: 'The class outputs the type to standard output automatically', correct: false),
      QuizOption(text: 'The type is contravariant — safe to consume but not produce', correct: false),
    ]),
    Quiz(question: 'Why do you need the reified keyword with generic type parameters?', options: [
      QuizOption(text: 'Because generic types are erased at runtime — reified preserves the type for runtime use', correct: true),
      QuizOption(text: 'To make the generic function run faster by avoiding boxing', correct: false),
      QuizOption(text: 'To allow the generic type to be nullable', correct: false),
      QuizOption(text: 'reified is required whenever a generic function has more than one type parameter', correct: false),
    ]),
    Quiz(question: 'What does <T : Comparable<T>> mean in a generic function signature?', options: [
      QuizOption(text: 'T must implement Comparable<T>, restricting which types can be used', correct: true),
      QuizOption(text: 'T will be compared to its own type at compile time', correct: false),
      QuizOption(text: 'The function can only be called with Int or Double', correct: false),
      QuizOption(text: 'T is a type that extends from the Comparable class hierarchy', correct: false),
    ]),
  ],
);
