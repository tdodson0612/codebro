import '../../models/lesson.dart';
import '../../models/quiz.dart';

final dartLesson15 = Lesson(
  language: 'Dart',
  title: 'Inheritance, Abstract Classes & Interfaces',
  content: '''
🎯 METAPHOR:
Inheritance is a family tree of behavior.
A Vehicle is the great-grandparent — it has an engine,
can move, and has a fuel tank. Car extends Vehicle —
it gets all of Vehicle's capabilities AND adds four
wheels, a trunk, and a stereo. ElectricCar extends Car —
but overrides the engine with a motor and replaces
the fuel tank with a battery. The family traits flow
down, but each generation can change what it inherited.

Abstract classes are like job descriptions —
they define what skills are required (abstract methods),
but don't implement them. The class that extends the
job description must provide the actual implementation.

📖 EXPLANATION:
Dart supports single inheritance (extends), multiple
interface implementation (implements), and mixin
composition (with). Abstract classes define contracts.
Every class implicitly defines an interface.

─────────────────────────────────────
📐 EXTENDS — INHERITANCE
─────────────────────────────────────
class Child extends Parent {
  // inherits all non-private fields and methods
  // can override methods with @override
  // must call super() if parent has non-default constructor
}

─────────────────────────────────────
🔑 SUPER
─────────────────────────────────────
super.method()   → call parent's version of method
super(args)      → call parent's constructor

// Named super constructor parameter (Dart 2.17+):
Child(super.x, super.y) { ... }   // passes x,y to parent

─────────────────────────────────────
🏛️  ABSTRACT CLASSES
─────────────────────────────────────
abstract class Shape {
  double get area;           // abstract getter
  void draw();               // abstract method
  String describe() { ... }  // concrete method (can have body!)
}

• Cannot be instantiated directly
• Subclasses must implement abstract members
• Can have concrete methods shared by all subclasses

─────────────────────────────────────
🤝 IMPLEMENTS — INTERFACES
─────────────────────────────────────
Dart doesn't have an "interface" keyword.
Every class defines an interface.
Any class can implement any other class.

class Dog implements Animal {
  // Must implement ALL public members of Animal
  // No inherited implementation — must write it yourself
}

─────────────────────────────────────
🔀 IMPLEMENTS vs EXTENDS
─────────────────────────────────────
extends: inherits implementation, is-a relationship
implements: must provide own implementation, contract only

Multiple implements:
  class Amphibian implements Land, Water { ... }

─────────────────────────────────────
🔄 COVARIANT PARAMETERS
─────────────────────────────────────
covariant allows a parameter type to be narrowed:
  void feed(covariant Cat food); // accepts Cat, not Animal
  // override can use stricter type than parent declared

💻 CODE:
void main() {
  // ── BASIC INHERITANCE ─────────
  var dog = Dog('Rex', 'Husky');
  print(dog.name);          // Rex
  print(dog.describe());    // Rex is a Husky dog
  dog.speak();              // Rex says: Woof!
  dog.eat();                // Rex eats (inherited from Animal)

  var cat = Cat('Whiskers');
  cat.speak();              // Whiskers says: Meow~

  // ── POLYMORPHISM ──────────────
  List<Animal> animals = [Dog('Buddy', 'Poodle'), Cat('Luna')];
  for (var animal in animals) {
    animal.speak();   // calls the right speak() for each type
  }

  // ── TYPE CHECKING ─────────────
  print(dog is Animal);   // true
  print(dog is Dog);      // true
  print(dog is Cat);      // false

  // ── ABSTRACT CLASS ────────────
  var circle = Circle(5.0);
  var rect = Rect(4.0, 6.0);

  print(circle.area);         // ~78.54
  print(rect.area);           // 24.0
  print(circle.describe());   // Circle: area=78.54
  print(rect.describe());     // Rectangle: area=24.00

  // Polymorphism with abstract class
  List<Shape> shapes = [Circle(3), Rect(4, 5), Circle(1)];
  double total = shapes.fold(0.0, (sum, s) => sum + s.area);
  print('Total area: \$total');

  // ── IMPLEMENTS ────────────────
  var frog = Frog();
  frog.swim();    // Frog swims
  frog.jump();    // Frog jumps on land
  frog.breathe(); // Frog breathes

  // Frog satisfies both interfaces
  Swimmer swimmer = frog;
  LandAnimal land = frog;
  swimmer.swim();   // ✅
  land.jump();      // ✅

  // ── SUPER CONSTRUCTOR ─────────
  var truck = Truck('Red Truck', 500);
  truck.describe();   // Red Truck can carry 500kg
}

// ── BASE CLASS ─────────────────
class Animal {
  final String name;

  Animal(this.name);

  void eat() => print('\$name eats');

  void speak() => print('\$name makes a sound');

  @override
  String toString() => name;
}

// ── EXTENDS ────────────────────
class Dog extends Animal {
  final String breed;

  Dog(super.name, this.breed);   // super.name passes to Animal(name)

  // Override parent method
  @override
  void speak() => print('\$name says: Woof!');

  // New method not in parent
  String describe() => '\$name is a \$breed dog';

  void fetch() => print('\$name fetches the ball!');
}

class Cat extends Animal {
  Cat(super.name);

  @override
  void speak() => print('\$name says: Meow~');

  void purr() => print('\$name purrs...');
}

// ── ABSTRACT CLASS ─────────────
abstract class Shape {
  // Abstract members — subclasses MUST implement
  double get area;
  double get perimeter;

  // Concrete method — shared by all shapes
  String describe() =>
      '\${runtimeType}: area=\${area.toStringAsFixed(2)}';

  // Abstract method
  void draw();
}

class Circle extends Shape {
  final double radius;
  Circle(this.radius);

  @override
  double get area => 3.14159 * radius * radius;

  @override
  double get perimeter => 2 * 3.14159 * radius;

  @override
  void draw() => print('Drawing circle with radius \$radius');
}

class Rect extends Shape {
  final double width, height;
  Rect(this.width, this.height);

  @override
  double get area => width * height;

  @override
  double get perimeter => 2 * (width + height);

  @override
  void draw() => print('Drawing \${width}x\${height} rectangle');

  @override
  String describe() => 'Rectangle: area=\${area.toStringAsFixed(2)}';
}

// ── IMPLEMENTING INTERFACES ────
// Any class can be used as an interface

abstract interface class Swimmer {
  void swim();
}

abstract interface class LandAnimal {
  void jump();
  void breathe();
}

// Frog implements both interfaces
class Frog implements Swimmer, LandAnimal {
  @override
  void swim() => print('Frog swims');

  @override
  void jump() => print('Frog jumps on land');

  @override
  void breathe() => print('Frog breathes');
}

// ── SUPER CONSTRUCTORS ─────────
class Vehicle {
  final String name;

  Vehicle(this.name);

  void describe() => print(name);
}

class Truck extends Vehicle {
  final int maxLoad;

  Truck(super.name, this.maxLoad);

  @override
  void describe() => print('\$name can carry \${maxLoad}kg');
}

// ── CALLING SUPER METHODS ──────
class Logger extends Animal {
  Logger(super.name);

  @override
  void eat() {
    print('[LOG] \$name is about to eat');
    super.eat();   // call parent's eat()
    print('[LOG] \$name finished eating');
  }
}

📝 KEY POINTS:
✅ extends gives your class all of the parent's public/protected members
✅ @override is required when overriding parent methods — catches typos
✅ super.method() calls the parent's version of a method
✅ super.field in constructor params is shorthand for passing to parent
✅ Abstract classes can't be instantiated but can have concrete methods
✅ implements requires reimplementing everything — no inherited code
✅ Dart has single inheritance (one extends) but multiple implements
✅ Every class implicitly defines an interface (all public members)
❌ Don't override without @override — the annotation catches bugs
❌ implements inherits NO implementation — you must write it all yourself
❌ Abstract methods have no body — even no empty body {}
''',
  quiz: [
    Quiz(question: 'What is the difference between extends and implements in Dart?', options: [
      QuizOption(text: 'extends is for classes; implements is for interfaces', correct: false),
      QuizOption(text: 'extends inherits implementation; implements only inherits the contract (must reimplement everything)', correct: true),
      QuizOption(text: 'implements allows multiple inheritance; extends does not', correct: false),
      QuizOption(text: 'They are identical in Dart — just different keywords', correct: false),
    ]),
    Quiz(question: 'Can you instantiate an abstract class directly?', options: [
      QuizOption(text: 'Yes — abstract is just a hint to the developer', correct: false),
      QuizOption(text: 'No — abstract classes cannot be instantiated directly', correct: true),
      QuizOption(text: 'Yes, but only the concrete methods work', correct: false),
      QuizOption(text: 'Only if you pass all abstract method implementations', correct: false),
    ]),
    Quiz(question: 'What does super.name in a constructor parameter list do?', options: [
      QuizOption(text: 'Creates a field named "super" in the parent class', correct: false),
      QuizOption(text: 'Passes the argument directly to the parent class constructor parameter "name"', correct: true),
      QuizOption(text: 'Accesses the parent\'s name field', correct: false),
      QuizOption(text: 'Calls the parent\'s toString()', correct: false),
    ]),
  ],
);
