import '../../models/lesson.dart';
import '../../models/quiz.dart';

final kotlinLesson27 = Lesson(
  language: 'Kotlin',
  title: 'Type System: Any, Unit, Nothing, and Type Casting',
  content: """
🎯 METAPHOR:
Kotlin's type hierarchy is like a corporate org chart.
Any is the CEO at the top — every single employee (type)
reports up to the CEO eventually. Unit is like the
Head of Admin — their job is supporting others, they don't
produce anything themselves, but their work is essential.
Nothing is the opposite of a job — it's the fire exit sign.
It points to the way out (a crash, an exception, an infinite
loop) — a path that NEVER returns to the building.
Type casting is like showing your employee badge at a door:
"I claim I'm from Engineering (Int)" — safe cast checks
the badge, unsafe cast trusts you without looking.

📖 EXPLANATION:
Kotlin's type system has a clear hierarchy with special types
at the extremes that every Kotlin developer should understand.

─────────────────────────────────────
ANY — the root of all types:
─────────────────────────────────────
Every Kotlin type (except nullable types) is a subtype of Any.
Similar to Object in Java.

  val anything: Any = 42
  val anything2: Any = "Hello"
  val anything3: Any = listOf(1, 2, 3)

Any has three methods all objects inherit:
  equals(other: Any?): Boolean
  hashCode(): Int
  toString(): String

Any? (nullable Any) is the absolute supertype — even null
fits into Any?.

─────────────────────────────────────
UNIT — the "nothing meaningful" return:
─────────────────────────────────────
Unit is the return type of functions that don't return
a meaningful value. Like void in Java, but Unit is a real
type with one value — also called Unit.

  fun printHello(): Unit { println("Hello") }
  fun printHello() { println("Hello") }   // Unit implied

Why is this useful? Because Kotlin treats everything as
an expression. A lambda that returns Unit is a valid value
of type () -> Unit.

─────────────────────────────────────
NOTHING — the "never returns" type:
─────────────────────────────────────
Nothing is the subtype of ALL types. A function that returns
Nothing NEVER returns normally — it either:
  • Always throws an exception
  • Loops forever

  fun fail(message: String): Nothing {
      throw IllegalStateException(message)
  }

  fun infiniteLoop(): Nothing {
      while (true) { /* forever */ }
  }

Why is this useful? After calling fail(), the compiler
knows the next line is UNREACHABLE — it can check this.
Also: null has type Nothing? — which is why null can be
assigned to any nullable type.

─────────────────────────────────────
TYPE CHECKING: is and !is:
─────────────────────────────────────
  val obj: Any = "Hello"

  if (obj is String) {
      println(obj.length)  // Smart cast! obj is String here
  }

  if (obj !is Int) {
      println("Not an Int")
  }

─────────────────────────────────────
SMART CASTS:
─────────────────────────────────────
After an is check, Kotlin automatically casts within that scope:

  fun processAny(obj: Any) {
      when (obj) {
          is String  -> println("String of length \${obj.length}")
          is Int     -> println("Int times 2: \${obj * 2}")
          is List<*> -> println("List with \${obj.size} items")
          else       -> println("Unknown: \$obj")
      }
  }

─────────────────────────────────────
EXPLICIT CASTING: as and as?:
─────────────────────────────────────
  as  → unsafe cast — throws ClassCastException if wrong type
  as? → safe cast — returns null if wrong type

  val obj: Any = "Hello"

  val str: String = obj as String          // safe here
  val num: Int? = obj as? Int              // null — not an Int

  // Dangerous:
  val bad: Int = obj as Int    // throws ClassCastException!

  // Safe pattern:
  val safeNum = (obj as? Int) ?: 0   // 0 if not an Int

─────────────────────────────────────
TYPE ALIASES:
─────────────────────────────────────
Create readable names for complex types:

  typealias UserMap = Map<String, List<User>>
  typealias ClickHandler = (View) -> Unit
  typealias Predicate<T> = (T) -> Boolean

  fun processUsers(users: UserMap) { }
  fun onClick(handler: ClickHandler) { }

─────────────────────────────────────
TYPE HIERARCHY SUMMARY:
─────────────────────────────────────
  Any?                ← absolute top (includes null)
  ├── Any             ← top of non-null types
  │   ├── Int
  │   ├── String
  │   ├── List<T>
  │   └── ... all other types
  └── Nothing?        ← null
      └── Nothing     ← absolute bottom (never exists)

💻 CODE:
// Nothing return type
fun fail(message: String): Nothing = throw IllegalStateException(message)

fun getConfigValue(key: String): String {
    return when (key) {
        "host" -> "api.example.com"
        "port" -> "8080"
        else   -> fail("Unknown config key: \$key")
        // After fail(), compiler knows we never reach here
    }
}

// Working with Any
fun describe(value: Any): String = when (value) {
    is Int     -> "Integer: \$value (doubled: \${value * 2})"
    is Double  -> "Double: \${"%.2f".format(value)}"
    is String  -> "String of \${value.length} chars: '\$value'"
    is Boolean -> "Boolean: \$value"
    is List<*> -> "List with \${value.size} items"
    is Map<*, *> -> "Map with \${value.size} entries"
    else       -> "Unknown type: \${value::class.simpleName}"
}

// Safe vs unsafe casting
fun safeDivide(a: Any, b: Any): Double? {
    val numA = a as? Number ?: return null
    val numB = b as? Number ?: return null
    if (numB.toDouble() == 0.0) return null
    return numA.toDouble() / numB.toDouble()
}

// Type aliases
typealias StringTransformer = (String) -> String
typealias IntPredicate = (Int) -> Boolean
typealias NamedValue = Pair<String, Any>

fun applyTransformers(input: String, vararg transformers: StringTransformer): String {
    return transformers.fold(input) { acc, transform -> transform(acc) }
}

fun main() {
    // Any
    val items: List<Any> = listOf(42, "Hello", 3.14, true, listOf(1, 2, 3))
    for (item in items) {
        println(describe(item))
    }

    // Smart casts
    println("\\n--- Smart casts ---")
    val values: List<Any> = listOf("kotlin", 42, null, 3.14, "language")
    for (v in values) {
        when {
            v is String && v.length > 5 -> println("Long string: \$v")
            v is String                 -> println("Short string: \$v")
            v is Int                    -> println("Int x3: \${v * 3}")
            v == null                   -> println("null value")
            else                        -> println("Other: \$v")
        }
    }

    // Safe casting with as?
    println("\\n--- Safe casting ---")
    val mixed: List<Any> = listOf("hello", 42, "world", 3.14, 99)
    val stringsOnly = mixed.mapNotNull { it as? String }
    val intsOnly = mixed.mapNotNull { it as? Int }
    println("Strings: \$stringsOnly")
    println("Ints: \$intsOnly")

    // safeDivide
    println("\\n--- Safe divide ---")
    println(safeDivide(10, 3))     // 3.333...
    println(safeDivide(10, 0))     // null
    println(safeDivide("x", 3))   // null

    // Nothing — config lookup
    println("\\n--- Nothing/fail ---")
    println(getConfigValue("host"))
    println(getConfigValue("port"))
    try {
        println(getConfigValue("secret"))
    } catch (e: IllegalStateException) {
        println("Caught: \${e.message}")
    }

    // Type aliases
    println("\\n--- Type aliases ---")
    val trimmer: StringTransformer = { it.trim() }
    val shout: StringTransformer = { it.uppercase() }
    val exclaim: StringTransformer = { "\$it!" }

    val result = applyTransformers("  hello world  ", trimmer, shout, exclaim)
    println(result)   // HELLO WORLD!

    val isLong: IntPredicate = { it > 100 }
    println(isLong(50))     // false
    println(isLong(200))    // true

    // NamedValue alias
    val namedValues: List<NamedValue> = listOf(
        "score" to 95,
        "name" to "Terry",
        "active" to true
    )
    namedValues.forEach { (name, value) -> println("\$name = \$value") }
}

📝 KEY POINTS:
✅ Any is the root of all non-null types in Kotlin
✅ Any? is the root of ALL types including nullable
✅ Unit is a real type returned by functions with no meaningful value
✅ Nothing means a function NEVER returns — always throws or loops
✅ is performs type checking and triggers smart cast in scope
✅ as? is the safe cast — returns null instead of throwing
✅ typealias gives readable names to complex function/collection types
✅ null has type Nothing? — that's why it fits any nullable type
❌ Avoid as (unsafe cast) — prefer as? with a null check
❌ Don't use Any when you can use a specific type — lose type safety
❌ Nothing is not the same as Unit — Nothing never returns, Unit returns nothing
❌ Smart casts don't work on mutable vars — use val or a local copy
""",
  quiz: [
    Quiz(question: 'What does a function return type of Nothing mean?', options: [
      QuizOption(text: 'The function never returns normally — it always throws or runs forever', correct: true),
      QuizOption(text: 'The function returns no value, like void in Java', correct: false),
      QuizOption(text: 'The function returns null under all circumstances', correct: false),
      QuizOption(text: 'Nothing is an alias for Unit in Kotlin', correct: false),
    ]),
    Quiz(question: 'What is the difference between as and as? when casting types?', options: [
      QuizOption(text: 'as throws ClassCastException on failure; as? returns null on failure', correct: true),
      QuizOption(text: 'as? is faster; as performs a runtime check each time', correct: false),
      QuizOption(text: 'as works at compile time; as? works at runtime', correct: false),
      QuizOption(text: 'as is for primitive types; as? is for objects', correct: false),
    ]),
    Quiz(question: 'Why can smart casts fail on mutable var properties?', options: [
      QuizOption(text: 'Another thread or accessor could change the var between the check and the use', correct: true),
      QuizOption(text: 'var properties do not support the is operator', correct: false),
      QuizOption(text: 'Smart casts only work on local variables, not class properties', correct: false),
      QuizOption(text: 'The compiler treats var as Any by default, disabling smart casts', correct: false),
    ]),
  ],
);
