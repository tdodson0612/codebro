import '../../models/lesson.dart';
import '../../models/quiz.dart';

final dartLesson29 = Lesson(
  language: 'Dart',
  title: 'Sealed Classes (Dart 3)',
  content: '''
🎯 METAPHOR:
A sealed class is like a closed union of possibilities —
a locked box that contains exactly the types you declare,
and no others can be added from outside. Think of a traffic
light: it can ONLY be Red, Yellow, or Green. Nothing else
can claim to be a TrafficLight. When you write code that
handles a TrafficLight, Dart knows all three cases at
compile time, so it can WARN you if you forgot to handle
one. This exhaustiveness checking is the killer feature —
your switch has no surprises waiting in a dark corner.

📖 EXPLANATION:
sealed classes (Dart 3) define a closed hierarchy.
Only types in the same library can extend/implement them.
This enables exhaustiveness checking in switch statements —
the compiler verifies all cases are handled. Sealed classes
are the foundation of algebraic data types (ADTs) in Dart.

─────────────────────────────────────
📐 SYNTAX
─────────────────────────────────────
sealed class Shape {}    // sealed class

class Circle extends Shape { final double radius; ... }
class Rectangle extends Shape { final double width, height; ... }
class Triangle extends Shape { ... }

// Now switch MUST cover all subclasses:
double area(Shape s) => switch (s) {
  Circle(:final radius) => pi * radius * radius,
  Rectangle(:final width, :final height) => width * height,
  Triangle(...) => ...,
  // No default needed — and compiler errors if you miss one!
};

─────────────────────────────────────
🔑 SEALED vs OTHER MODIFIERS
─────────────────────────────────────
sealed:    closed hierarchy, enables exhaustiveness
           cannot be instantiated directly
           subclasses must be in the SAME library

abstract:  can't be instantiated, can be extended anywhere
           NO exhaustiveness checking

final:     can't be extended at all (no subclasses)

base:      can only be EXTENDED (not implemented)
           must be subclassed with base or final or sealed

interface: can only be IMPLEMENTED (not extended)

─────────────────────────────────────
🎯 ALGEBRAIC DATA TYPES WITH SEALED
─────────────────────────────────────
This is the Dart idiomatic way to represent sum types:

sealed class Result<T> {}
class Success<T> extends Result<T> { final T value; ... }
class Failure<T> extends Result<T> { final String message; ... }

// Exhaustive handling guaranteed:
switch (result) {
  case Success(:final value) => process(value),
  case Failure(:final message) => showError(message),
}

─────────────────────────────────────
🔄 SEALED + PATTERN MATCHING
─────────────────────────────────────
Sealed classes SHINE with pattern matching.
The combination gives you:
  ✅ Compile-time exhaustiveness check
  ✅ Type-safe field access via patterns
  ✅ No default case needed
  ✅ IDE warns when new subclass is added to sealed class

💻 CODE:
import 'dart:math' show pi;

void main() {
  // ── BASIC SEALED CLASS ─────────
  List<Shape> shapes = [
    Circle(radius: 5.0),
    Rectangle(width: 4.0, height: 6.0),
    Triangle(base: 3.0, height: 4.0),
  ];

  for (final shape in shapes) {
    print('\${shape.runtimeType}: area=\${computeArea(shape).toStringAsFixed(2)}');
  }

  // Exhaustiveness — ALL cases must be covered:
  for (final shape in shapes) {
    String desc = describe(shape);
    print(desc);
  }

  // ── RESULT TYPE (ADT) ──────────
  final results = [
    fetchData(true),
    fetchData(false),
  ];

  for (final result in results) {
    switch (result) {
      case Success(:final data):
        print('✅ Got data: \$data');
      case Failure(:final message, :final code):
        print('❌ Error \$code: \$message');
      case Loading():
        print('⏳ Loading...');
    }
    // Dart GUARANTEES all three cases are handled
  }

  // ── SWITCH EXPRESSION WITH SEALED ─
  String status = switch (fetchData(true)) {
    Success() => 'success',
    Failure() => 'failed',
    Loading() => 'loading',
  };
  print(status);   // success

  // ── JSON-LIKE SEALED TYPE ──────
  JsonValue json = JsonObject({
    'name': JsonString('Alice'),
    'age': JsonNumber(30),
    'scores': JsonArray([JsonNumber(92), JsonNumber(88)]),
    'active': JsonBool(true),
    'nickname': JsonNull(),
  });

  print(prettyPrint(json, 0));

  // ── STATE MACHINE WITH SEALED ──
  OrderState state = OrderPlaced(orderId: 'ORD-001');
  print('Initial: \${describeState(state)}');

  state = OrderShipped(orderId: 'ORD-001', trackingNumber: 'TRK-123');
  print('After ship: \${describeState(state)}');

  state = OrderDelivered(orderId: 'ORD-001', deliveredAt: DateTime.now());
  print('After delivery: \${describeState(state)}');
}

// ── BASIC SEALED CLASS ──────────
sealed class Shape {}

class Circle extends Shape {
  final double radius;
  Circle({required this.radius});
}

class Rectangle extends Shape {
  final double width, height;
  Rectangle({required this.width, required this.height});
}

class Triangle extends Shape {
  final double base, height;
  Triangle({required this.base, required this.height});
}

// Exhaustive switch — no default needed
double computeArea(Shape shape) => switch (shape) {
  Circle(:final radius) => pi * radius * radius,
  Rectangle(:final width, :final height) => width * height,
  Triangle(:final base, :final height) => 0.5 * base * height,
};

String describe(Shape shape) => switch (shape) {
  Circle(:final radius) => 'Circle with radius \$radius',
  Rectangle(:final width, :final height) =>
      'Rectangle \${width}×\$height',
  Triangle(:final base, :final height) =>
      'Triangle (base=\$base, h=\$height)',
};

// ── RESULT ADT ─────────────────
sealed class NetworkResult<T> {}

class Success<T> extends NetworkResult<T> {
  final T data;
  Success(this.data);
}

class Failure<T> extends NetworkResult<T> {
  final String message;
  final int code;
  Failure(this.message, {this.code = 500});
}

class Loading<T> extends NetworkResult<T> {
  Loading();
}

NetworkResult<String> fetchData(bool succeed) {
  if (succeed) return Success('{"users": [...]}');
  return Failure('Server error', code: 503);
}

// ── JSON VALUE SEALED TYPE ──────
sealed class JsonValue {}
class JsonString extends JsonValue { final String value; JsonString(this.value); }
class JsonNumber extends JsonValue { final num value; JsonNumber(this.value); }
class JsonBool extends JsonValue { final bool value; JsonBool(this.value); }
class JsonNull extends JsonValue { JsonNull(); }
class JsonArray extends JsonValue { final List<JsonValue> elements; JsonArray(this.elements); }
class JsonObject extends JsonValue { final Map<String, JsonValue> fields; JsonObject(this.fields); }

String prettyPrint(JsonValue value, int indent) {
  final pad = '  ' * indent;
  return switch (value) {
    JsonString(:final value) => '"$value"',
    JsonNumber(:final value) => '\$value',
    JsonBool(:final value) => '\$value',
    JsonNull() => 'null',
    JsonArray(:final elements) =>
        '[\n\${elements.map((e) => '\$pad  \${prettyPrint(e, indent+1)}').join(',\n')}\n\$pad]',
    JsonObject(:final fields) =>
        '{\n\${fields.entries.map((e) => '\$pad  "\${e.key}": \${prettyPrint(e.value, indent+1)}').join(',\n')}\n\$pad}',
  };
}

// ── ORDER STATE MACHINE ─────────
sealed class OrderState {
  final String orderId;
  OrderState(this.orderId);
}

class OrderPlaced extends OrderState {
  OrderPlaced({required String orderId}) : super(orderId);
}

class OrderShipped extends OrderState {
  final String trackingNumber;
  OrderShipped({required String orderId, required this.trackingNumber})
      : super(orderId);
}

class OrderDelivered extends OrderState {
  final DateTime deliveredAt;
  OrderDelivered({required String orderId, required this.deliveredAt})
      : super(orderId);
}

class OrderCancelled extends OrderState {
  final String reason;
  OrderCancelled({required String orderId, required this.reason})
      : super(orderId);
}

String describeState(OrderState state) => switch (state) {
  OrderPlaced(:final orderId) =>
      'Order \$orderId has been placed',
  OrderShipped(:final orderId, :final trackingNumber) =>
      'Order \$orderId shipped — tracking: \$trackingNumber',
  OrderDelivered(:final orderId, :final deliveredAt) =>
      'Order \$orderId delivered at \$deliveredAt',
  OrderCancelled(:final orderId, :final reason) =>
      'Order \$orderId cancelled: \$reason',
};

📝 KEY POINTS:
✅ sealed creates a closed hierarchy — only this library's types can extend it
✅ sealed enables exhaustiveness checking in switch statements
✅ No default needed when all sealed subclasses are handled
✅ Adding a new subclass to a sealed class makes the compiler flag all switch sites
✅ sealed + patterns = type-safe algebraic data types in Dart
✅ The Result/Either/Option pattern is a common sealed class use case
✅ Sealed classes cannot be instantiated directly — only their subclasses
✅ Combine sealed with object patterns for clean field extraction
❌ Sealed class subclasses must be in the same library file (or part-of)
❌ Don't confuse sealed (closed hierarchy) with abstract (open hierarchy)
❌ sealed classes cannot be mixed in — only extended or implemented
''',
  quiz: [
    Quiz(question: 'What is the key benefit of sealed classes for switch statements?', options: [
      QuizOption(text: 'They make switch statements run faster', correct: false),
      QuizOption(text: 'The compiler can verify all subclasses are handled — no missing cases', correct: true),
      QuizOption(text: 'They allow default cases to be omitted', correct: false),
      QuizOption(text: 'They prevent switch statements from throwing exceptions', correct: false),
    ]),
    Quiz(question: 'Where must subclasses of a sealed class be defined?', options: [
      QuizOption(text: 'Anywhere in the package', correct: false),
      QuizOption(text: 'In the same library (file or part-of files)', correct: true),
      QuizOption(text: 'Only in the same class', correct: false),
      QuizOption(text: 'There is no restriction on subclass location', correct: false),
    ]),
    Quiz(question: 'What happens when you add a new subclass to a sealed class?', options: [
      QuizOption(text: 'All existing code still works unchanged', correct: false),
      QuizOption(text: 'The compiler flags all switch statements that don\'t handle the new case', correct: true),
      QuizOption(text: 'A runtime error is thrown', correct: false),
      QuizOption(text: 'The new subclass is automatically added to all switches', correct: false),
    ]),
  ],
);
