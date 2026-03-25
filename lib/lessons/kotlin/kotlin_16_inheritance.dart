import '../../models/lesson.dart';
import '../../models/quiz.dart';

final kotlinLesson16 = Lesson(
  language: 'Kotlin',
  title: 'Inheritance',
  content: """
🎯 METAPHOR:
Inheritance is like a family recipe book. Grandma's recipe
for tomato sauce is the base — it has the core steps every
sauce needs. Your mom inherited that recipe and added her
own twist: more garlic, a splash of wine. You inherited
your mom's version and added chili flakes. Each generation
EXTENDS the previous one — keeps everything that worked,
adds what's new, optionally changes what isn't right.
The base recipe (parent class) doesn't change.
The child recipe builds ON TOP of it.

📖 EXPLANATION:
Inheritance lets one class (child/subclass) inherit
properties and functions from another (parent/superclass).
Kotlin makes inheritance EXPLICIT — you must OPT IN.

─────────────────────────────────────
CLASSES ARE FINAL BY DEFAULT:
─────────────────────────────────────
In Kotlin, classes cannot be subclassed unless marked open.
This is the opposite of Java.

  class Dog { }          // CANNOT be inherited from
  open class Animal { }  // CAN be inherited from

Why? Because inheritance is a powerful tool that's easy to
misuse. Kotlin makes you explicitly say "I designed this
for extension."

─────────────────────────────────────
EXTENDING A CLASS:
─────────────────────────────────────
  open class Animal(val name: String) {
      fun breathe() = println("\$name breathes")
  }

  class Dog(name: String) : Animal(name) {
      fun bark() = println("\$name barks!")
  }

The : Animal(name) means "extend Animal, pass name to
Animal's constructor."

─────────────────────────────────────
OVERRIDING FUNCTIONS:
─────────────────────────────────────
To override a function, the parent must mark it open,
and the child must use the override keyword.

  open class Animal {
      open fun speak() = println("...")
  }

  class Cat : Animal() {
      override fun speak() = println("Meow!")
  }

  class Dog : Animal() {
      override fun speak() = println("Woof!")
  }

─────────────────────────────────────
OVERRIDING PROPERTIES:
─────────────────────────────────────
Properties can also be overridden if marked open:

  open class Shape {
      open val sides: Int = 0
  }

  class Triangle : Shape() {
      override val sides: Int = 3
  }

─────────────────────────────────────
super — calling the parent:
─────────────────────────────────────
Use super to access the parent class's implementation:

  class Dog : Animal() {
      override fun speak() {
          super.speak()        // call Animal's speak first
          println("Woof!")     // then add Dog's own behavior
      }
  }

─────────────────────────────────────
CALLING PARENT CONSTRUCTOR:
─────────────────────────────────────
  open class Vehicle(val make: String, val year: Int)

  class Car(make: String, year: Int, val doors: Int)
      : Vehicle(make, year)   // passes args to Vehicle

─────────────────────────────────────
ABSTRACT CLASSES:
─────────────────────────────────────
Abstract classes cannot be instantiated — they exist to
be subclassed. Abstract functions have no body — subclasses
MUST implement them.

  abstract class Shape {
      abstract fun area(): Double    // no body — must override
      abstract fun perimeter(): Double

      fun describe() = "I am a shape with area ${
area()}"
  }

  class Circle(val radius: Double) : Shape() {
      override fun area() = Math.PI * radius * radius
      override fun perimeter() = 2 * Math.PI * radius
  }

Abstract class vs Interface — covered in next lesson.

─────────────────────────────────────
SEALED CLASSES (preview):
─────────────────────────────────────
A restricted class hierarchy — all subclasses must be in
the same file. Covered in depth in the Sealed Classes lesson.

💻 CODE:
open class Animal(val name: String, val sound: String) {
    open fun speak() {
        println("\$name says: \$sound")
    }

    open fun describe() {
        println("I am \$name, an animal.")
    }
}

class Dog(name: String) : Animal(name, "Woof") {
    override fun speak() {
        super.speak()   // call Animal.speak()
        println("\$name wags tail enthusiastically!")
    }

    fun fetch(item: String) = println("\$name fetches the \$item!")
}

class Cat(name: String, val isIndoor: Boolean) : Animal(name, "Meow") {
    override fun speak() = println("\$name purrs... then says Meow.")

    override fun describe() {
        super.describe()
        println("${
if (isIndoor) "Indoor" else "Outdoor"} cat.")
    }
}

abstract class Shape(val color: String) {
    abstract fun area(): Double
    abstract fun perimeter(): Double

    fun describe() {
        println("\$color shape | Area: ${
"%.2f".format(area())} | Perimeter: ${
"%.2f".format(perimeter())}")
    }
}

class Rectangle(color: String, val width: Double, val height: Double) : Shape(color) {
    override fun area() = width * height
    override fun perimeter() = 2 * (width + height)
}

class Circle(color: String, val radius: Double) : Shape(color) {
    override fun area() = Math.PI * radius * radius
    override fun perimeter() = 2 * Math.PI * radius
}

fun main() {
    val dog = Dog("Rex")
    val cat = Cat("Whiskers", isIndoor = true)

    dog.speak()
    dog.fetch("ball")
    cat.speak()
    cat.describe()

    // Polymorphism — treat as base type
    val animals: List<Animal> = listOf(dog, cat, Dog("Buddy"), Cat("Luna", false))
    println("\\n--- All animals speak ---")
    for (animal in animals) {
        animal.speak()   // calls the correct override for each
    }

    // Abstract shapes
    val shapes: List<Shape> = listOf(
        Rectangle("Red", 5.0, 3.0),
        Circle("Blue", 4.0),
        Rectangle("Green", 2.0, 8.0)
    )
    println("\\n--- Shape descriptions ---")
    for (shape in shapes) {
        shape.describe()
    }

    // Type checking with is
    for (animal in animals) {
        when (animal) {
            is Dog -> println("${
animal.name} is a Dog")
            is Cat -> println("${
animal.name} is a Cat")
        }
    }
}

📝 KEY POINTS:
✅ Classes are final by default — mark open to allow inheritance
✅ Functions must be marked open to allow overriding
✅ Always use override keyword when overriding — enforced
✅ Use super.function() to call the parent's version
✅ Abstract classes cannot be instantiated directly
✅ Abstract functions have no body — all subclasses must implement
✅ is operator checks if an object is a specific subtype
❌ Don't inherit just to reuse code — prefer composition
❌ Avoid deep inheritance chains (more than 2–3 levels)
❌ Don't forget to call super() if the parent has meaningful init
❌ You cannot override a final (non-open) function
""",
  quiz: [
    Quiz(question: 'In Kotlin, what must you do to allow a class to be subclassed?', options: [
      QuizOption(text: 'Mark the class with the open keyword', correct: true),
      QuizOption(text: 'Mark the class with the inheritable keyword', correct: false),
      QuizOption(text: 'Nothing — all Kotlin classes are inheritable by default', correct: false),
      QuizOption(text: 'Mark the class with the abstract keyword', correct: false),
    ]),
    Quiz(question: 'What is the difference between an open function and an abstract function?', options: [
      QuizOption(text: 'An open function has a body that can optionally be overridden; an abstract function has no body and must be overridden', correct: true),
      QuizOption(text: 'An abstract function can be called directly; an open function cannot', correct: false),
      QuizOption(text: 'open functions are for classes; abstract functions are for interfaces', correct: false),
      QuizOption(text: 'They are identical — open and abstract are interchangeable', correct: false),
    ]),
    Quiz(question: 'How do you call the parent class\'s version of an overridden function?', options: [
      QuizOption(text: 'super.functionName()', correct: true),
      QuizOption(text: 'parent.functionName()', correct: false),
      QuizOption(text: 'base.functionName()', correct: false),
      QuizOption(text: 'this.super.functionName()', correct: false),
    ]),
  ],
);
