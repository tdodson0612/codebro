import '../../models/lesson.dart';
import '../../models/quiz.dart';

final kotlinLesson15 = Lesson(
  language: 'Kotlin',
  title: 'Data Classes',
  content: """
🎯 METAPHOR:
A data class is like a shipping label. A shipping label
exists purely to HOLD information: sender, recipient,
weight, tracking number. You don't need a shipping label
to DO complex things — you need it to hold data, compare
it to other labels, copy it, and print it in a readable
format. Kotlin looks at a class marked data and says:
"I know what you need. You need equals, hashCode, toString,
and copy — I'll write all of that for you." It's Kotlin
doing the boilerplate so you don't have to.

📖 EXPLANATION:
Data classes are regular classes with one keyword added:
the data modifier. In exchange, Kotlin auto-generates five
critical methods that would require 50+ lines in Java.

─────────────────────────────────────
WHAT data CLASS GENERATES:
─────────────────────────────────────
  toString()   → readable string representation
  equals()     → compares by property values, not reference
  hashCode()   → consistent hash based on properties
  copy()       → create a modified copy
  componentN() → destructuring support

ALL of these are generated from the PRIMARY CONSTRUCTOR
properties only.

─────────────────────────────────────
SYNTAX:
─────────────────────────────────────
  data class User(val id: Int, val name: String, val email: String)

That's it. Three lines of Java turned into one.

─────────────────────────────────────
toString():
─────────────────────────────────────
  val u = User(1, "Terry", "terry@email.com")
  println(u)
  // User(id=1, name=Terry, email=terry@email.com)

No more "User@7ef88735" garbage output.

─────────────────────────────────────
equals() — value-based comparison:
─────────────────────────────────────
  val a = User(1, "Terry", "terry@email.com")
  val b = User(1, "Terry", "terry@email.com")

  println(a == b)    // true  — same properties ✅
  println(a === b)   // false — different objects in memory

Regular classes compare by reference — == would be false.
Data classes compare by value — what matters is CONTENT.

─────────────────────────────────────
copy() — create a modified clone:
─────────────────────────────────────
One of the most useful features. Create a new instance
with some properties changed, others kept.

  val original = User(1, "Terry", "terry@email.com")
  val updated = original.copy(email = "new@email.com")

  // original is unchanged:
  println(original)  // User(id=1, name=Terry, email=terry@email.com)
  println(updated)   // User(id=1, name=Terry, email=new@email.com)

This is the KEY pattern for working with immutable data.
Instead of mutating an object, you create a modified copy.

─────────────────────────────────────
DESTRUCTURING:
─────────────────────────────────────
Data classes support destructuring declarations —
pull out multiple properties at once:

  val (id, name, email) = User(1, "Terry", "terry@email.com")
  println(id)     // 1
  println(name)   // Terry

  // In a for loop:
  for ((id, name) in users) {
      println("\$id: \$name")
  }

─────────────────────────────────────
REQUIREMENTS FOR DATA CLASSES:
─────────────────────────────────────
  ✅ Must have at least one parameter in primary constructor
  ✅ All primary constructor parameters must be val or var
  ✅ Cannot be abstract, open, sealed, or inner
  ✅ Can extend other classes and implement interfaces

─────────────────────────────────────
DATA CLASS vs REGULAR CLASS:
─────────────────────────────────────
  Use data class when:
    → The class exists to hold data
    → You need value equality (== compares content)
    → You want readable toString() output
    → You want copy() functionality

  Use regular class when:
    → The class has complex behavior
    → Identity matters (two objects aren't equal even if
      they have the same values — e.g. database entities)

💻 CODE:
// Simple data class
data class Point(val x: Double, val y: Double)

// More complex data class
data class User(
    val id: Int,
    val name: String,
    val email: String,
    val age: Int = 0    // default values work fine
)

data class Product(
    val id: String,
    val name: String,
    val price: Double,
    val inStock: Boolean = true
)

fun main() {
    // toString — automatic, readable
    val point = Point(3.0, 4.0)
    println(point)    // Point(x=3.0, y=4.0)

    // equals — value-based
    val p1 = Point(1.0, 2.0)
    val p2 = Point(1.0, 2.0)
    val p3 = Point(9.0, 9.0)
    println(p1 == p2)     // true
    println(p1 == p3)     // false
    println(p1 === p2)    // false (different objects)

    // copy
    val user1 = User(1, "Terry", "terry@old.com", 30)
    val user2 = user1.copy(email = "terry@new.com")
    val user3 = user1.copy(name = "Sam", age = 25)
    println(user1)   // User(id=1, name=Terry, email=terry@old.com, age=30)
    println(user2)   // User(id=1, name=Terry, email=terry@new.com, age=30)
    println(user3)   // User(id=1, name=Sam, email=terry@old.com, age=25)

    // Destructuring
    val (x, y) = point
    println("x=\$x, y=\$y")

    val (id, name, email) = user1
    println("User #\$id: \$name (\$email)")

    // In collections
    val products = listOf(
        Product("A1", "Keyboard", 79.99),
        Product("A2", "Mouse", 29.99, inStock = false),
        Product("A3", "Monitor", 299.99)
    )

    val available = products.filter { it.inStock }
    println("In stock:\${
available.map { it.name }}")

    val priceSummary = products
        .sortedBy { it.price }
        .map { "\${
it.name}: \$\${
it.price}" }
    println(priceSummary)

    // hashCode — data classes work correctly in sets/maps
    val userSet = setOf(
        User(1, "Terry", "t@t.com"),
        User(1, "Terry", "t@t.com"),  // duplicate — ignored
        User(2, "Sam", "s@s.com")
    )
    println(userSet.size)    // 2 — not 3
}

📝 KEY POINTS:
✅ data modifier auto-generates equals, hashCode, toString, copy
✅ Equality is value-based — two objects with same data are equal
✅ copy() creates a new object with selective changes
✅ Destructuring pulls multiple properties out at once
✅ Data classes work correctly in Sets and as Map keys
✅ Default parameters work in data class constructors
✅ Properties OUTSIDE the primary constructor are NOT in
   equals/hashCode/toString/copy — put everything important there
❌ Don't use data class for entities where identity matters
❌ Don't use mutable var properties if you rely on hashCode in Sets
   (mutating the key breaks the set)
❌ Data classes can't be abstract or open (unless parent is abstract)
""",
  quiz: [
    Quiz(question: 'What does the copy() function on a data class do?', options: [
      QuizOption(text: 'Creates a new instance with optionally modified properties — the original is unchanged', correct: true),
      QuizOption(text: 'Creates a deep clone of the object including nested objects', correct: false),
      QuizOption(text: 'Returns a mutable version of an immutable data class', correct: false),
      QuizOption(text: 'Copies all properties to a Map for serialization', correct: false),
    ]),
    Quiz(question: 'What is automatically generated for a data class in Kotlin?', options: [
      QuizOption(text: 'equals(), hashCode(), toString(), copy(), and componentN() functions', correct: true),
      QuizOption(text: 'Only toString() and equals()', correct: false),
      QuizOption(text: 'A JSON serializer and deserializer', correct: false),
      QuizOption(text: 'A builder pattern for constructing instances', correct: false),
    ]),
    Quiz(question: 'If two data class instances have identical property values, what does == return?', options: [
      QuizOption(text: 'true — data classes use value-based equality', correct: true),
      QuizOption(text: 'false — == always checks reference identity in Kotlin', correct: false),
      QuizOption(text: 'It depends on whether the properties are val or var', correct: false),
      QuizOption(text: 'It throws an exception if the objects are not the same instance', correct: false),
    ]),
  ],
);
