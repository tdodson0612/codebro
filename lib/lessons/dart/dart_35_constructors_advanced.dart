import '../../models/lesson.dart';
import '../../models/quiz.dart';

final dartLesson35 = Lesson(
  language: 'Dart',
  title: 'Constructors: Named, Factory & Const',
  content: '''
🎯 METAPHOR:
Constructors are like entry doors to a building.
The main door (primary constructor) is the standard entrance.
Named constructors are specialty entrances — the staff door,
the loading dock, the VIP entrance — each providing a
different way in. The factory constructor is the front desk
that might redirect you: "Oh, you want that building?
Let me create the right room for you" — it can return a
cached instance, a subclass, or a pre-configured variant.
The const constructor is the hall of fame — all entries
with the same credentials are exactly the same person.

📖 EXPLANATION:
Dart has several constructor types, each serving a purpose:
primary, named, factory, redirecting, and const.
Together they provide flexible object creation patterns
while keeping instantiation type-safe and expressive.

─────────────────────────────────────
📐 CONSTRUCTOR TYPES
─────────────────────────────────────
Primary:
  class User { User(this.name); }

Named:
  class User { User.guest() : name = 'Guest'; }

Redirecting:
  class User { User.admin() : this('Admin'); }
  // delegates to another constructor

Factory:
  factory User.fromJson(Map json) {
    return User(json['name']);
  }
  // can return cached instance or subtype!

Const:
  class Point { const Point(this.x, this.y); }
  const p = Point(0, 0);  // compile-time constant

Forwarding to super (Dart 2.17+):
  class Admin extends User { Admin(super.name); }

─────────────────────────────────────
🔑 INITIALIZER LIST
─────────────────────────────────────
Runs BEFORE the constructor body.
Can call assert, set final fields, call super:

Point(double x, double y)
    : assert(x >= 0), assert(y >= 0),   // validation
      this.x = x,                        // set final fields
      this.y = y;

─────────────────────────────────────
⚡ FACTORY CONSTRUCTORS
─────────────────────────────────────
Factory constructors:
  • Don't create a new instance directly
  • Return value must be the class type or subtype
  • Cannot use this (no implicit instance)
  • Can return cached/existing instances (Singleton!)
  • Can do complex logic before construction
  • Can return different subclasses

─────────────────────────────────────
🔒 CONST CONSTRUCTORS
─────────────────────────────────────
• All fields must be final
• No constructor body allowed (only initializer list)
• Enables compile-time constants
• Same const values → same object (canonicalized)
• Dramatically improves performance for Value Objects

─────────────────────────────────────
📋 PRIVATE CONSTRUCTORS
─────────────────────────────────────
class Singleton {
  static final _instance = Singleton._();
  Singleton._();          // private named constructor
  factory Singleton() => _instance;
}

💻 CODE:
void main() {
  // ── PRIMARY CONSTRUCTOR ────────
  var user = User(name: 'Alice', age: 30);
  print(user);   // User(Alice, 30)

  // ── NAMED CONSTRUCTORS ─────────
  var guest = User.guest();
  print(guest);  // User(Guest, 0)

  var admin = User.admin('Bob');
  print(admin);  // User(Bob, 30) role=admin

  var fromJson = User.fromMap({
    'name': 'Carol',
    'age': 25,
  });
  print(fromJson);  // User(Carol, 25)

  // ── REDIRECTING CONSTRUCTOR ────
  var p = Point(3, 4);
  var origin = Point.origin();
  var fromPolar = Point.polar(1.0, 0.0);  // angle=0 → (1, 0)

  print(p);         // Point(3.0, 4.0)
  print(origin);    // Point(0.0, 0.0)
  print(fromPolar); // Point(1.0, 0.0)

  // ── FACTORY CONSTRUCTOR ────────
  // Singleton
  var s1 = Database.instance;
  var s2 = Database.instance;
  print(identical(s1, s2));   // true — same object!

  // Factory returning cached
  var shape1 = Shape.fromType('circle');
  var shape2 = Shape.fromType('rectangle');
  var shape3 = Shape.fromType('circle');
  print(shape1.runtimeType);    // Circle
  print(shape2.runtimeType);    // Rectangle
  print(identical(shape1, shape3));   // false (new each time — depends on implementation)

  // ── CONST CONSTRUCTOR ──────────
  const pt1 = ImmutablePoint(1, 2);
  const pt2 = ImmutablePoint(1, 2);
  const pt3 = ImmutablePoint(1, 3);

  print(identical(pt1, pt2));   // true — canonicalized!
  print(identical(pt1, pt3));   // false — different values

  // Const list of const objects
  const colors = [
    Color(255, 0, 0),    // red
    Color(0, 255, 0),    // green
    Color(0, 0, 255),    // blue
  ];
  print(colors[0].toHex());  // #ff0000

  // ── INITIALIZER LIST ───────────
  var validated = ValidatedUser(name: 'Dave', age: 25, email: 'dave@ex.com');
  print(validated.email);  // dave@ex.com

  try {
    ValidatedUser(name: '', age: 25, email: 'x@x.com');
  } catch (e) {
    print('Validation: \$e');
  }

  // ── PRIVATE CONSTRUCTOR ────────
  var singleton1 = AppConfig();
  var singleton2 = AppConfig();
  print(identical(singleton1, singleton2));  // true

  singleton1.apiUrl = 'https://api.prod.com';
  print(singleton2.apiUrl);   // https://api.prod.com — same object!
}

// ── USER CLASS ─────────────────
class User {
  final String name;
  final int age;
  final String role;

  // Primary constructor (required + optional named)
  User({
    required this.name,
    required this.age,
    this.role = 'user',
  });

  // Named constructors
  User.guest()
      : name = 'Guest',
        age = 0,
        role = 'guest';

  User.admin(String name)
      : name = name,
        age = 30,
        role = 'admin';

  // Factory from Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'] as String,
      age: map['age'] as int,
      role: map['role'] as String? ?? 'user',
    );
  }

  @override
  String toString() => 'User(\$name, \$age) role=\$role';
}

// ── POINT WITH REDIRECTING ──────
class Point {
  final double x, y;

  // Primary constructor with validation
  Point(num x, num y)
      : x = x.toDouble(),
        y = y.toDouble();

  // Redirecting constructors
  Point.origin() : this(0, 0);

  Point.polar(double radius, double angle)
      : this(
          radius * _cos(angle),
          radius * _sin(angle),
        );

  static double _cos(double r) {
    // simplified cos
    return 1 - r * r / 2 + r * r * r * r / 24;
  }
  static double _sin(double r) {
    return r - r * r * r / 6;
  }

  @override
  String toString() =>
      'Point(\${
x.toStringAsFixed(1)}, \${
y.toStringAsFixed(1)})';
}

// ── FACTORY: SINGLETON ──────────
class Database {
  static final Database _instance = Database._internal();

  factory Database.instance => _instance;

  Database._internal() {
    print('Database connection established');
  }

  void query(String sql) => print('Query: \$sql');
}

// ── FACTORY: SUBCLASS DISPATCH ──
abstract class Shape {
  double get area;

  factory Shape.fromType(String type) => switch (type) {
    'circle' => Circle(radius: 1.0),
    'rectangle' => Rectangle(width: 2.0, height: 3.0),
    _ => throw ArgumentError('Unknown shape: \$type'),
  };
}

class Circle extends Shape {
  final double radius;
  Circle({required this.radius});
  @override
  double get area => 3.14159 * radius * radius;
}

class Rectangle extends Shape {
  final double width, height;
  Rectangle({required this.width, required this.height});
  @override
  double get area => width * height;
}

// ── CONST CLASS ─────────────────
class ImmutablePoint {
  final int x, y;
  const ImmutablePoint(this.x, this.y);

  @override
  String toString() => '(\$x, \$y)';
}

class Color {
  final int r, g, b;
  const Color(this.r, this.g, this.b);

  String toHex() =>
      '#\${
r.toRadixString(16).padLeft(2, '0')}'
      '\${
g.toRadixString(16).padLeft(2, '0')}'
      '\${
b.toRadixString(16).padLeft(2, '0')}';
}

// ── INITIALIZER LIST ───────────
class ValidatedUser {
  final String name;
  final int age;
  final String email;

  ValidatedUser({
    required this.name,
    required this.age,
    required this.email,
  })  : assert(name.isNotEmpty, 'Name cannot be empty'),
        assert(age >= 0 && age <= 150, 'Age out of range'),
        assert(email.contains('@'), 'Invalid email');
}

// ── PRIVATE CONSTRUCTOR (SINGLETON) ──
class AppConfig {
  static final AppConfig _instance = AppConfig._();
  AppConfig._();
  factory AppConfig() => _instance;

  String apiUrl = 'https://api.dev.com';
  bool debugMode = false;
}

📝 KEY POINTS:
✅ Named constructors (Class.name()) provide alternate construction paths
✅ Redirecting constructors (: this(...)) delegate to another constructor
✅ Factory constructors can return ANY instance of the class or subtype
✅ Factories can return cached instances — perfect for Singleton pattern
✅ Const constructors require all fields final — enables object canonicalization
✅ Two identical const values are literally the same object (identical())
✅ Initializer lists run before the body — use for validation and final field init
✅ Private constructors (_name) enable controlled instantiation patterns
❌ Factory constructors cannot access this (no object being created yet)
❌ Const constructors cannot have a constructor body
❌ Factory return type must be the class or a subtype — cannot return unrelated type
''',
  quiz: [
    Quiz(question: 'What can a factory constructor do that a regular constructor cannot?', options: [
      QuizOption(text: 'Initialize final fields', correct: false),
      QuizOption(text: 'Return an existing cached instance or a different subclass', correct: true),
      QuizOption(text: 'Access private members', correct: false),
      QuizOption(text: 'Avoid calling super()', correct: false),
    ]),
    Quiz(question: 'Why are two identical const Point(1, 2) objects identical() in Dart?', options: [
      QuizOption(text: 'Because Point overrides the == operator', correct: false),
      QuizOption(text: 'Dart canonicalizes const objects with the same values — they are literally the same object in memory', correct: true),
      QuizOption(text: 'Because const objects cannot be compared with ==', correct: false),
      QuizOption(text: 'Only if Point implements the Const interface', correct: false),
    ]),
    Quiz(question: 'What is an initializer list in Dart?', options: [
      QuizOption(text: 'A list of default values for parameters', correct: false),
      QuizOption(text: 'Code after the : in a constructor that runs before the body — used for assertions and final field initialization', correct: true),
      QuizOption(text: 'A list of named constructors', correct: false),
      QuizOption(text: 'The list of super constructors to call', correct: false),
    ]),
  ],
);