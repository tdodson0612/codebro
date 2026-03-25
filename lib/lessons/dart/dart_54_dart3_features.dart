import '../../models/lesson.dart';
import '../../models/quiz.dart';

final dartLesson54 = Lesson(
  language: 'Dart',
  title: 'Dart 3: All the New Features',
  content: '''
🎯 METAPHOR:
Dart 3 is like a city that added a subway system.
The city (Dart 2) already had roads (classes, functions,
generics) that worked well. Then Dart 3 added a complete
subway network: records (the express train — fast, direct,
efficient), patterns (smart ticket gates that check your
ticket AND send you to the right platform), sealed classes
(turnstiles that guarantee you can only go through approved
exits), class modifiers (different station types — some
transfer-only, some terminal, some hub). Everything
connects and the city moves faster than ever.

📖 EXPLANATION:
Dart 3.0 (May 2023) introduced the most significant set of
language features since Dart 2's null safety. The four
headline features: Records, Patterns, Sealed Classes, and
Class Modifiers. Together they enable powerful new patterns
for safe, expressive code.

─────────────────────────────────────
📦 DART 3 HEADLINE FEATURES
─────────────────────────────────────
1. Records              → anonymous typed tuples
2. Patterns             → destructuring + matching
3. Sealed Classes       → exhaustive sum types
4. Class Modifiers      → control class capabilities

─────────────────────────────────────
📋 1. RECORDS (detailed in lesson 13)
─────────────────────────────────────
(int, String) point = (42, 'origin');
({String name, int age}) person = (name: 'Alice', age: 30);

Key: structural equality, immutable, lightweight.

─────────────────────────────────────
🔀 2. PATTERNS (detailed in lesson 20)
─────────────────────────────────────
Patterns work in:
  switch statements / expressions
  if-case statements
  variable declarations
  for loops

Types: literal, variable, type, record, list, map,
       null-check, null-assert, cast, object, wildcard

─────────────────────────────────────
🔒 3. SEALED CLASSES (lesson 29)
─────────────────────────────────────
sealed class Shape { }
class Circle extends Shape { }
class Rectangle extends Shape { }

switch (shape) {
  case Circle c: ...
  case Rectangle r: ...
  // No default needed — exhaustive!
}

─────────────────────────────────────
🏗️  4. CLASS MODIFIERS (lesson 30)
─────────────────────────────────────
base class     → can be extended but not implemented
interface class → can be implemented but not extended
final class    → can't be extended or implemented
sealed class   → closed hierarchy, exhaustive switching
mixin class    → both a mixin and a class

─────────────────────────────────────
🆕 DART 3.x ADDITIONS
─────────────────────────────────────
Dart 3.3 (Feb 2024): Extension Types
  • Zero-cost wrappers for type safety
  extension type UserId(String _) implements String {}

Dart 3.4: Wildcard variables
  • _ can be used for unused variables
  var (_, second) = record;  // ignore first

Dart 3.6+: Digit separators
  • 1_000_000 and 0xFF_AA_BB for readability

─────────────────────────────────────
🧮 PATTERNS IN DEPTH
─────────────────────────────────────
Literal pattern:    case 42:
Variable pattern:   case var x:    // captures value
Type pattern:       case String s: // type check + bind
Record pattern:     case (int x, int y):
List pattern:       case [first, ...rest]:
Map pattern:        case {'key': var val}:
Object pattern:     case Point(x: var x):
Wildcard:           case _:         // match anything
Null check:         case String? s?: // non-null check
Guard (when):       case int n when n > 0:

💻 CODE:
void main() {
  print('=== Dart 3 Features Demo ===\n');

  // ── 1. RECORDS ────────────────
  print('--- Records ---');

  // Anonymous tuples
  (int, String, bool) tuple = (42, 'hello', true);
  print(tuple.\$1);  // 42
  print(tuple.\$2);  // hello

  // Named records
  ({String name, int score}) result = (name: 'Alice', score: 95);
  print('\${
result.name}: \${
result.score}');

  // Multiple return values
  var (min, max) = minMax([3, 1, 4, 1, 5, 9, 2]);
  print('Min: \$min, Max: \$max');

  // Structural equality
  print((1, 'a') == (1, 'a'));   // true

  // ── 2. PATTERNS ───────────────
  print('\n--- Patterns ---');

  // In switch expression
  Object value = 42;
  String description = switch (value) {
    int n when n > 100  => 'large number',
    int n when n > 0    => 'small positive: \$n',
    int n               => 'non-positive: \$n',
    String s            => 'string: \$s',
    _                   => 'unknown',
  };
  print(description);  // small positive: 42

  // Destructuring in variable declaration
  var (x, y) = (10.0, 20.0);
  print('x=\$x, y=\$y');

  var (:name, :score) = (name: 'Bob', score: 88);
  print('\$name: \$score');

  // List patterns
  List<int> nums = [1, 2, 3, 4, 5];
  if (nums case [int first, int second, ...]) {
    print('Starts with \$first, \$second');
  }

  // Map patterns
  Map<String, dynamic> config = {'host': 'localhost', 'port': 5432};
  if (config case {'host': String host, 'port': int port}) {
    print('Connecting to \$host:\$port');
  }

  // Object patterns
  var point = Point(3.0, 4.0);
  if (point case Point(x: var px, y: var py) when px > 0) {
    print('Positive x: \$px, y: \$py');
  }

  // Pattern in for loop
  List<(String, int)> entries = [('Alice', 92), ('Bob', 78)];
  for (var (name, score) in entries) {
    print('\$name scored \$score');
  }

  // ── 3. SEALED CLASSES ─────────
  print('\n--- Sealed Classes ---');

  List<Shape> shapes = [Circle(5.0), Rectangle(4.0, 6.0), Triangle(3.0, 4.0, 5.0)];

  for (final shape in shapes) {
    // Exhaustive switch — no default needed!
    double area = switch (shape) {
      Circle(:var radius) => 3.14159 * radius * radius,
      Rectangle(:var width, :var height) => width * height,
      Triangle(:var a, :var b, :var c) => _triangleArea(a, b, c),
    };
    print('\${
shape.runtimeType}: area = \${
area.toStringAsFixed(2)}');
  }

  // ── 4. CLASS MODIFIERS ────────
  print('\n--- Class Modifiers ---');

  // base: can extend but not implement directly
  // interface: can implement but not extend
  // final: can neither extend nor implement
  // sealed: closed hierarchy with exhaustive switch

  // Using them:
  var dog = Dog('Rex');
  print(dog.sound);  // Woof

  // final class — can't be subclassed
  // var s = SizedBox(width: 10);   // use as-is

  // ── 5. EXTENSION TYPES (3.3) ──
  print('\n--- Extension Types ---');

  UserId id = UserId('user-123');
  print(id);           // user-123
  print(id.length);    // 8 (String methods work!)

  // Type safety without runtime cost
  processUser(id);     // ✅ accepts UserId
  // processUser('raw-string');  // ❌ compile error

  Celsius temp = Celsius(100);
  print(temp.toFahrenheit());   // 212.0

  // ── DART 3 SUMMARY ────────────
  print('\n--- Feature Summary ---');
  final features = [
    'Records: anonymous immutable typed tuples',
    'Patterns: destructuring + pattern matching',
    'Sealed classes: closed hierarchies + exhaustive switch',
    'Class modifiers: base, interface, final, sealed, mixin',
    'Extension types (3.3): zero-cost type wrappers',
  ];

  for (final (i, feature) in features.indexed) {
    print('\${
i + 1}. \$feature');
  }
}

// Helper function
(int, int) minMax(List<int> list) {
  return (list.reduce((a, b) => a < b ? a : b),
          list.reduce((a, b) => a > b ? a : b));
}

double _triangleArea(double a, double b, double c) {
  final s = (a + b + c) / 2;
  return (s * (s-a) * (s-b) * (s-c)).abs().toDouble();
}

class Point {
  final double x, y;
  Point(this.x, this.y);
}

// ── SEALED CLASS HIERARCHY ────────
sealed class Shape { }

class Circle extends Shape {
  final double radius;
  Circle(this.radius);
}

class Rectangle extends Shape {
  final double width, height;
  Rectangle(this.width, this.height);
}

class Triangle extends Shape {
  final double a, b, c;
  Triangle(this.a, this.b, this.c);
}

// ── BASE CLASS ────────────────────
base class Animal {
  final String name;
  Animal(this.name);
  String get sound => '...';
}

class Dog extends Animal {  // ✅ can extend base
  Dog(super.name);
  @override
  String get sound => 'Woof';
}

// class FakeAnimal implements Animal { }  // ❌ can't implement base

// ── EXTENSION TYPE ────────────────
extension type UserId(String _) implements String { }

void processUser(UserId id) {
  print('Processing user: \$id');
}

extension type Celsius(double value) {
  Celsius.fromFahrenheit(double f) : this((f - 32) * 5 / 9);

  double toFahrenheit() => value * 9 / 5 + 32;
  double toKelvin() => value + 273.15;

  bool get isFreezing => value <= 0;
  bool get isBoiling  => value >= 100;
}

📝 KEY POINTS:
✅ Dart 3's four pillars: Records, Patterns, Sealed Classes, Class Modifiers
✅ Records enable returning multiple typed values without creating a class
✅ Patterns work in switch, if-case, variable declarations, and for loops
✅ Sealed classes enable exhaustive switch — compiler checks all cases covered
✅ Class modifiers (base/interface/final) give library authors control over extensibility
✅ Extension types are zero-cost — no runtime overhead, just compile-time safety
✅ .indexed gives (index, value) record pairs in for-in loops (Dart 3.7+)
✅ Wildcard _ in patterns ignores a value without creating a variable
❌ Sealed classes can only be extended within the same library file
❌ base class prevents implementing but allows extending (the reverse of interface)
❌ extension type operators must be declared explicitly — they're not inherited from the underlying type
''',
  quiz: [
    Quiz(question: 'What are the four headline features of Dart 3.0?', options: [
      QuizOption(text: 'Null safety, async/await, generics, and extensions', correct: false),
      QuizOption(text: 'Records, Patterns, Sealed Classes, and Class Modifiers', correct: true),
      QuizOption(text: 'Mixins, enums, typedefs, and extension types', correct: false),
      QuizOption(text: 'Sound typing, hot reload, AOT compilation, and tree shaking', correct: false),
    ]),
    Quiz(question: 'What makes sealed class switches special compared to regular switches?', options: [
      QuizOption(text: 'They are faster at runtime', correct: false),
      QuizOption(text: 'The compiler performs exhaustiveness checking — if any subclass is missing, it is a compile warning/error', correct: true),
      QuizOption(text: 'They support more pattern types', correct: false),
      QuizOption(text: 'They do not require break statements', correct: false),
    ]),
    Quiz(question: 'What is the runtime cost of an extension type?', options: [
      QuizOption(text: 'High — each extension type creates a wrapper object', correct: false),
      QuizOption(text: 'Zero — extension types are erased at runtime and have no overhead', correct: true),
      QuizOption(text: 'Low — a small wrapper is created', correct: false),
      QuizOption(text: 'It depends on the underlying type', correct: false),
    ]),
  ],
);
