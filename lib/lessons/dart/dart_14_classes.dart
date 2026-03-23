import '../../models/lesson.dart';
import '../../models/quiz.dart';

final dartLesson14 = Lesson(
  language: 'Dart',
  title: 'Classes: Fields, Methods & Constructors',
  content: '''
🎯 METAPHOR:
A class is like a blueprint for a building.
The blueprint defines the structure: how many rooms
(fields), what services are available (methods), and
how to construct the building (constructor). Each actual
building (instance/object) follows the blueprint but
has its own state — Room 101 might be painted blue
while Room 102 is green (different field values).
In Dart, classes are especially clean: initializing
formals (this.name) let you initialize fields in the
constructor parameter list itself — no boilerplate needed.

📖 EXPLANATION:
Classes in Dart are blueprints for objects. A class defines
fields (state), constructors (how to create), methods
(behavior), and getters/setters (computed properties).
Dart has concise syntax for common patterns: initializing
formals, initializer lists, and const constructors.

─────────────────────────────────────
📐 CLASS ANATOMY
─────────────────────────────────────
class ClassName {
  // Fields (state)
  Type fieldName;

  // Constructor
  ClassName(this.fieldName);    // initializing formal!

  // Getter (computed property)
  Type get computed => expression;

  // Setter
  set computed(Type value) { ... }

  // Method
  ReturnType methodName(params) { body }

  // Static method (on the class itself)
  static ReturnType staticMethod() { ... }
}

─────────────────────────────────────
🏗️  CONSTRUCTORS
─────────────────────────────────────
Default constructor:
  class Point { Point(this.x, this.y); }

Named constructor:
  class Point { Point.origin() : x = 0, y = 0; }

Factory constructor:
  factory Point.fromMap(Map m) => Point(m['x'], m['y']);

Const constructor:
  const Point(this.x, this.y);  // all fields must be final

Initializer list (runs before body):
  Point(double x, double y) : this.x = x, this.y = y;

─────────────────────────────────────
🔑 INITIALIZING FORMALS (this.field)
─────────────────────────────────────
Instead of:
  class User { String name; User(String name) { this.name = name; } }

Use:
  class User { String name; User(this.name); }

Both are identical — this.name in the constructor parameter
list automatically assigns the passed value to the field.

─────────────────────────────────────
🔒 GETTERS & SETTERS
─────────────────────────────────────
Computed properties that look like fields:
  double get area => width * height;
  set area(double a) => width = a / height;

─────────────────────────────────────
🌐 STATIC MEMBERS
─────────────────────────────────────
static fields and methods belong to the CLASS, not instances.
Accessed via ClassName.member, not via this.

💻 CODE:
void main() {
  // ── BASIC CLASS USAGE ─────────
  var p = Point(3.0, 4.0);
  print(p);              // Point(3.0, 4.0)
  print(p.x);            // 3.0
  print(p.y);            // 4.0
  print(p.distanceTo(Point(0, 0)));  // 5.0
  print(p.magnitude);    // 5.0 (getter)

  p.x = 6.0;
  print(p.magnitude);    // ~7.2

  // Named constructor
  var origin = Point.origin();
  print(origin);         // Point(0.0, 0.0)

  var fromList = Point.fromList([1.0, 2.0]);
  print(fromList);       // Point(1.0, 2.0)

  // ── CONST CONSTRUCTOR ─────────
  const cp1 = ImmutablePoint(1, 2);
  const cp2 = ImmutablePoint(1, 2);
  print(identical(cp1, cp2));  // true — same object!

  // ── GETTERS & SETTERS ─────────
  var rect = Rectangle(10.0, 5.0);
  print(rect.area);       // 50.0
  print(rect.perimeter);  // 30.0

  rect.area = 100.0;      // use the setter
  print(rect.width);      // 20.0 (area/height = 100/5)

  // ── STATIC MEMBERS ────────────
  print(MathUtils.pi);         // 3.141592653589793
  print(MathUtils.square(5));  // 25
  MathUtils.instanceCount++;   // only works on an instance

  // ── FULL CLASS EXAMPLE ─────────
  var alice = Person(name: 'Alice', age: 30, email: 'alice@ex.com');
  print(alice);             // Person(Alice, 30)
  print(alice.greeting);    // Hello, I'm Alice!
  alice.birthday();
  print(alice.age);         // 31

  var bob = Person(name: 'Bob', age: 25);
  print(bob);               // Person(Bob, 25)
  print(bob.email);         // null
  
  alice.compareTo(bob);

  // ── CASCADE ON CLASS ──────────
  var sb = StringBuffer()
    ..write('Hello')
    ..write(', ')
    ..write('World!');
  print(sb.toString());   // Hello, World!
}

// ── POINT CLASS ────────────────
class Point {
  // Fields
  double x;
  double y;

  // Primary constructor using initializing formals
  Point(this.x, this.y);

  // Named constructor
  Point.origin() : x = 0, y = 0;

  // Named constructor with initializer list
  Point.fromList(List<double> coords)
      : x = coords[0],
        y = coords[1];

  // Getter
  double get magnitude => _distance(x, y, 0, 0);

  // Method
  double distanceTo(Point other) => _distance(x, y, other.x, other.y);

  static double _distance(double x1, double y1, double x2, double y2) {
    final dx = x1 - x2;
    final dy = y1 - y2;
    return (dx * dx + dy * dy).sqrt();
  }

  // toString for print()
  @override
  String toString() => 'Point(\$x, \$y)';

  // == and hashCode for equality
  @override
  bool operator ==(Object other) =>
      other is Point && x == other.x && y == other.y;

  @override
  int get hashCode => Object.hash(x, y);
}

// Extension on double (dart:math not imported for brevity)
extension on double {
  double sqrt() => this < 0 ? double.nan : _sqrt(this);
  static double _sqrt(double x) {
    if (x == 0) return 0;
    double guess = x / 2;
    for (int i = 0; i < 20; i++) guess = (guess + x / guess) / 2;
    return guess;
  }
}

// ── CONST CLASS ───────────────
class ImmutablePoint {
  final int x;
  final int y;

  const ImmutablePoint(this.x, this.y);  // const constructor

  @override
  String toString() => 'ImmutablePoint(\$x, \$y)';
}

// ── RECTANGLE WITH GETTERS/SETTERS ──
class Rectangle {
  double width;
  double height;

  Rectangle(this.width, this.height);

  // Getter
  double get area => width * height;
  double get perimeter => 2 * (width + height);

  // Setter — area can be set (adjusts width)
  set area(double newArea) {
    width = newArea / height;
  }

  @override
  String toString() => 'Rectangle(\$width × \$height)';
}

// ── STATIC MEMBERS ─────────────
class MathUtils {
  static const double pi = 3.141592653589793;
  int instanceCount = 0;   // instance field

  static int square(int n) => n * n;
  static double circleArea(double r) => pi * r * r;
}

// ── FULL-FEATURED CLASS ─────────
class Person {
  // Fields
  final String name;
  int age;
  final String? email;    // nullable optional field

  // Private field (leading _)
  String _nickname;

  // Primary constructor
  Person({
    required this.name,
    required this.age,
    this.email,
    String? nickname,
  }) : _nickname = nickname ?? name;   // initializer list!

  // Computed property
  String get greeting => "Hello, I'm \$_nickname!";

  // Method
  void birthday() {
    age++;
    print('\$name is now \$age!');
  }

  int compareTo(Person other) => name.compareTo(other.name);

  // toString
  @override
  String toString() => 'Person(\$name, \$age)';

  // == and hashCode
  @override
  bool operator ==(Object other) =>
      other is Person && name == other.name && age == other.age;

  @override
  int get hashCode => Object.hash(name, age);
}

📝 KEY POINTS:
✅ Use this.field in constructor params for concise initializing formals
✅ Initializer lists (after :) run BEFORE the constructor body
✅ Named constructors (ClassName.name()) create alternate ways to construct
✅ const constructors require all fields to be final
✅ Two const objects with the same values are identical (same memory)
✅ Override toString(), ==, and hashCode for useful classes
✅ Private members use _ prefix: _fieldName, _methodName
✅ static members belong to the class; access via ClassName.member
❌ Don't forget to override hashCode when overriding ==
❌ const constructors cannot have bodies — only initializer lists
❌ _private fields can be accessed within the same LIBRARY, not just the class
''',
  quiz: [
    Quiz(question: 'What does Person(this.name, this.age) do in a constructor?', options: [
      QuizOption(text: 'Creates a new Person variable named "this"', correct: false),
      QuizOption(text: 'Automatically assigns the constructor arguments to the name and age fields', correct: true),
      QuizOption(text: 'Copies the name and age from another Person', correct: false),
      QuizOption(text: 'Declares name and age as local variables', correct: false),
    ]),
    Quiz(question: 'When are two const objects with identical values identical() in Dart?', options: [
      QuizOption(text: 'Never — each object always has a unique identity', correct: false),
      QuizOption(text: 'Always — Dart canonicalizes const objects with the same values to a single instance', correct: true),
      QuizOption(text: 'Only if they are assigned to the same variable', correct: false),
      QuizOption(text: 'Only if the class overrides ==', correct: false),
    ]),
    Quiz(question: 'What does a leading underscore (_) mean on a field in Dart?', options: [
      QuizOption(text: 'The field is completely inaccessible outside the class', correct: false),
      QuizOption(text: 'The field is private to the library (not just the class)', correct: true),
      QuizOption(text: 'The field is deprecated', correct: false),
      QuizOption(text: 'The field is static', correct: false),
    ]),
  ],
);
