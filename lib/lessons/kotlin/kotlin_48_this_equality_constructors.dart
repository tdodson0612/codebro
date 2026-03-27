import '../../models/lesson.dart';
import '../../models/quiz.dart';

final kotlinLesson48 = Lesson(
  language: 'Kotlin',
  title: 'this Expressions, Equality, and Secondary Constructors',
  content: """
🎯 METAPHOR:
'this' in a class is like a name badge that says "I am THIS
object, right here." In a crowded room of Person objects,
when one Person says "my name is Terry," the 'this' badge
tells everyone exactly which Person is talking.
When you're inside a nested scope or an extension function,
'this' can be ambiguous — you need a qualified badge:
"I'm THIS@Person" to clarify which object you mean.

Equality in Kotlin is like comparing twins. Two people can
look identical (same values) but still be two different
people (different objects in memory). == checks if they
LOOK the same (structural equality). === checks if they're
literally THE SAME PERSON (reference identity). For most
practical purposes, you want ==.

📖 EXPLANATION:

─────────────────────────────────────
this EXPRESSIONS:
─────────────────────────────────────
Inside a class, 'this' refers to the current instance:

  class Person(val name: String) {
      fun introduce() = "I am\${
this.name}"
      // 'this' is optional when there's no ambiguity:
      fun greet() = "Hello, my name is \$name"
  }

When parameter name shadows a property, use 'this':

  class Circle(val radius: Double) {
      fun setRadius(radius: Double): Circle {
          // 'radius' here would be the parameter!
          return Circle(this.radius + radius)
      }
  }

─────────────────────────────────────
QUALIFIED this — for nested scopes:
─────────────────────────────────────
When inside a lambda or inner class, this refers to the
innermost enclosing scope. Use @Label to qualify:

  class Outer {
      val value = "outer"

      inner class Inner {
          val value = "inner"

          fun show() {
              println(this.value)          // "inner"
              println(this@Outer.value)   // "outer" (qualified)
          }
      }
  }

In extension functions:
  fun String.prefix(pre: String): String {
      // this = the String being extended
      return pre + this
  }

In lambdas with receiver (DSL style):
  fun buildString(block: StringBuilder.() -> Unit): String {
      val sb = StringBuilder()
      sb.block()   // inside block, 'this' = sb
      return sb.toString()
  }

─────────────────────────────────────
EQUALITY — == vs ===:
─────────────────────────────────────
  ==  (structural equality)
      Calls equals() under the hood.
      Compares content/value.
      null-safe: null == null is true; null == "hello" is false.

  === (referential equality)
      Checks if two references point to the SAME object.
      null === null is true.

  // Regular class:
  class Point(val x: Int, val y: Int)
  val p1 = Point(1, 2)
  val p2 = Point(1, 2)
  println(p1 == p2)    // false — no equals() override
  println(p1 === p2)   // false — different objects

  // Data class (equals() auto-generated):
  data class DPoint(val x: Int, val y: Int)
  val d1 = DPoint(1, 2)
  val d2 = DPoint(1, 2)
  println(d1 == d2)    // true — data class compares by value
  println(d1 === d2)   // false — different objects in memory

─────────────────────────────────────
IMPLEMENTING equals() AND hashCode():
─────────────────────────────────────
For regular classes, implement them manually if needed:

  class Color(val r: Int, val g: Int, val b: Int) {
      override fun equals(other: Any?): Boolean {
          if (this === other) return true
          if (other !is Color) return false
          return r == other.r && g == other.g && b == other.b
      }

      override fun hashCode(): Int {
          var result = r
          result = 31 * result + g
          result = 31 * result + b
          return result
      }
  }

RULE: If you override equals(), ALWAYS override hashCode().
Objects that are equal must have the same hash code.

─────────────────────────────────────
SECONDARY CONSTRUCTORS:
─────────────────────────────────────
Most Kotlin classes only need a primary constructor.
But when you need multiple construction paths:

  class Rectangle(val width: Double, val height: Double) {

      // Secondary constructor — must delegate to primary
      constructor(side: Double) : this(side, side)

      // Another secondary — square from area
      constructor(area: Double, isSquare: Boolean) : this(
          if (isSquare) Math.sqrt(area) else area,
          if (isSquare) Math.sqrt(area) else 1.0
      )

      val area get() = width * height
  }

  val rect = Rectangle(5.0, 3.0)   // primary
  val square = Rectangle(4.0)       // secondary → (4.0, 4.0)

─────────────────────────────────────
WHEN TO USE SECONDARY CONSTRUCTORS:
─────────────────────────────────────
  ✅ When extending Java classes that require different constructor chains
  ✅ When construction logic varies significantly between paths
  ✅ When you need to call super() with different arguments

  Prefer in most Kotlin cases:
  → Default parameter values (cleaner, more idiomatic)
  → Factory functions in companion object

  constructor(name: String) vs fun create(name: String) = ...
  → Factory is usually better — more readable, more flexible

─────────────────────────────────────
CONSTRUCTOR DELEGATION CHAIN:
─────────────────────────────────────
  class User(val name: String, val age: Int, val email: String) {
      constructor(name: String, age: Int) : this(name, age, "")
      constructor(name: String) : this(name, 0, "")

      // Chain: constructor(name) → constructor(name, 0, "") → primary
  }

💻 CODE:
// ─── this EXPRESSIONS ────────────────────────────────

class Builder(private val name: String) {
    private val parts = mutableListOf<String>()

    // Returns 'this' for chaining
    fun add(part: String): Builder {
        parts.add(part)
        return this   // ← enables method chaining
    }

    fun addAll(vararg items: String): Builder {
        items.forEach { parts.add(it) }
        return this
    }

    fun build() = "\$name:\${
parts.joinToString(", ")}"
}

class Outer(private val id: String) {
    private val outerValue = "Outer-\$id"

    inner class Inner(private val innerValue: String) {
        fun report(): String {
            // 'this' = Inner, 'this@Outer' = Outer
            return "Inner(\${
this.innerValue}) inside\${
this@Outer.outerValue}"
        }

        // Extending a type inside inner class
        fun String.tagWith(): String = "[\${
this@Outer.id}] \$this"

        fun taggedValue() = innerValue.tagWith()
    }

    fun createInner(v: String) = Inner(v)
}

// ─── EQUALITY ────────────────────────────────────────

class Vector(val x: Double, val y: Double) {
    // Manual equals/hashCode for regular class
    override fun equals(other: Any?): Boolean {
        if (this === other) return true         // same reference
        if (other !is Vector) return false      // wrong type
        return x == other.x && y == other.y    // compare content
    }

    override fun hashCode(): Int {
        var result = x.hashCode()
        result = 31 * result + y.hashCode()
        return result
    }

    override fun toString() = "Vector(\$x, \$y)"
}

data class DataVector(val x: Double, val y: Double)  // auto equals/hashCode

// ─── SECONDARY CONSTRUCTORS ──────────────────────────

class HttpRequest(
    val method: String,
    val url: String,
    val headers: Map<String, String>,
    val body: String?
) {
    // Secondary: GET request (no body)
    constructor(url: String, headers: Map<String, String> = emptyMap())
        : this("GET", url, headers, null)

    // Secondary: POST request
    constructor(url: String, body: String, headers: Map<String, String> = emptyMap())
        : this("POST", url, headers, body)

    override fun toString(): String {
        val bodyStr = body?.let { " body=\${
it.take(20)}..." } ?: ""
        return "\$method \$url headers=\${
headers.keys}\$bodyStr"
    }
}

class Temperature private constructor(
    val celsius: Double
) {
    companion object {
        fun fromCelsius(c: Double) = Temperature(c)
        fun fromFahrenheit(f: Double) = Temperature((f - 32) * 5.0 / 9.0)
        fun fromKelvin(k: Double) = Temperature(k - 273.15)
    }

    val fahrenheit get() = celsius * 9.0 / 5.0 + 32
    val kelvin get() = celsius + 273.15

    override fun toString() = "\${
"%.2f".format(celsius)}°C"
    override fun equals(other: Any?) = other is Temperature && celsius == other.celsius
    override fun hashCode() = celsius.hashCode()
}

fun main() {
    // this — method chaining
    println("=== Method chaining with this ===")
    val result = Builder("Sandwich")
        .add("Bread")
        .add("Cheese")
        .addAll("Lettuce", "Tomato")
        .add("Mayo")
        .build()
    println(result)

    // Qualified this
    println("\\n=== Qualified this ===")
    val outer = Outer("X1")
    val inner = outer.createInner("MyValue")
    println(inner.report())
    println(inner.taggedValue())

    // Equality — regular class
    println("\\n=== Equality ===")
    val v1 = Vector(3.0, 4.0)
    val v2 = Vector(3.0, 4.0)
    val v3 = v1                    // same reference

    println("v1 == v2:\${
v1 == v2}")    // true (equals override)
    println("v1 === v2:\${
v1 === v2}")  // false (different objects)
    println("v1 === v3:\${
v1 === v3}")  // true (same reference)

    // Equality — data class
    val d1 = DataVector(3.0, 4.0)
    val d2 = DataVector(3.0, 4.0)
    println("data d1 == d2:\${
d1 == d2}")   // true
    println("data d1 === d2:\${
d1 === d2}") // false

    // Null equality
    val nullVec: Vector? = null
    println("null == null:\${
null == null}")         // true
    println("v1 == null:\${
v1 == null}")             // false
    println("nullVec == null:\${
nullVec == null}")   // true

    // In sets and maps (requires consistent equals/hashCode)
    val vectorSet = setOf(Vector(1.0, 0.0), Vector(0.0, 1.0), Vector(1.0, 0.0))
    println("\\nVector set size:\${
vectorSet.size}")  // 2 (duplicate removed)

    // Secondary constructors
    println("\\n=== Secondary constructors ===")
    val get = HttpRequest("https://api.example.com/users")
    val post = HttpRequest("https://api.example.com/users", '''{"name":"Terry"}''')
    val custom = HttpRequest("PUT", "https://api.example.com/users/1",
        mapOf("Auth" to "Bearer abc"), '''{"name":"Bob"}''')

    println(get)
    println(post)
    println(custom)

    // Factory pattern (preferred over secondary constructors in Kotlin)
    println("\\n=== Factory methods ===")
    val boiling = Temperature.fromCelsius(100.0)
    val bodyTemp = Temperature.fromFahrenheit(98.6)
    val absoluteZero = Temperature.fromKelvin(0.0)

    listOf(boiling, bodyTemp, absoluteZero).forEach { t ->
        println("\$t →\${
"%.2f".format(t.fahrenheit)}°F →\${
"%.2f".format(t.kelvin)}K")
    }

    println("\\nboiling == boiling:\${
boiling == Temperature.fromCelsius(100.0)}")  // true
}

📝 KEY POINTS:
✅ 'this' refers to the current instance — use when shadowing occurs
✅ this@OuterClass qualifies 'this' in nested/inner class contexts
✅ Return 'this' from methods to enable fluent/builder chaining
✅ == calls equals() — structural/content comparison
✅ === checks reference identity — same object in memory
✅ Always override hashCode() when you override equals()
✅ data classes auto-generate equals(), hashCode(), toString(), copy()
✅ Secondary constructors must delegate to the primary via this(...)
✅ Prefer factory functions in companion objects over secondary constructors
✅ null == null is true in Kotlin; null == anything-else is false
❌ Don't override equals() without also overriding hashCode() — breaks Sets/Maps
❌ Don't use === to compare values — it's for reference identity only
❌ Secondary constructors can't have property declarations (val/var)
❌ Qualified this@Label only works when the label matches the class name
""",
  quiz: [
    Quiz(question: 'What does this@Outer refer to inside an inner class?', options: [
      QuizOption(text: 'The instance of the outer class that contains this inner class instance', correct: true),
      QuizOption(text: 'A new instance of the Outer class created on the fly', correct: false),
      QuizOption(text: 'The companion object of the Outer class', correct: false),
      QuizOption(text: 'The superclass of Outer', correct: false),
    ]),
    Quiz(question: 'Why must you always override hashCode() when you override equals()?', options: [
      QuizOption(text: 'Objects that are equal must have the same hash code — breaking this corrupts Sets and Maps', correct: true),
      QuizOption(text: 'The compiler requires both to be overridden together as a language rule', correct: false),
      QuizOption(text: 'hashCode() is used by == internally and must match equals() logic', correct: false),
      QuizOption(text: 'Without hashCode(), the object cannot be serialized correctly', correct: false),
    ]),
    Quiz(question: 'What is the preferred Kotlin alternative to secondary constructors for multiple construction paths?', options: [
      QuizOption(text: 'Factory functions in a companion object', correct: true),
      QuizOption(text: 'Multiple primary constructors in the class header', correct: false),
      QuizOption(text: 'Default parameter values always cover all cases', correct: false),
      QuizOption(text: 'Extension functions that create instances', correct: false),
    ]),
  ],
);
