import '../../models/lesson.dart';
import '../../models/quiz.dart';

final dartLesson31 = Lesson(
  language: 'Dart',
  title: 'Extension Types (Dart 3.3)',
  content: '''
🎯 METAPHOR:
Extension types are like branded wrappers.
A plain int is just a number. But "UserId" is semantically
different from "ProductId" — even though both are ints.
Without extension types, nothing stops you from passing a
ProductId where a UserId is expected. With extension types,
you CREATE a new compile-time type "UserId" that IS an int
underneath — but the type system treats them as different.
At runtime, the wrapper disappears completely (zero cost),
but at compile time, you have full type safety.
It's the best of both worlds: zero overhead AND type safety.

📖 EXPLANATION:
Extension types (Dart 3.3) create NEW compile-time types
backed by an existing type. Unlike extension methods, these
ARE new types — you can't accidentally mix them up.
The underlying representation is erased at runtime (no
boxing, no allocation), making them truly zero-cost.

─────────────────────────────────────
📐 SYNTAX
─────────────────────────────────────
extension type UserId(int value) {
  // 'value' is the representation field
  // UserId IS an int at runtime, but NOT at compile time

  UserId.fromString(String s) : this(int.parse(s));

  String get display => 'user-\$value';
}

// Usage:
UserId id = UserId(42);
int n = id.value;        // access underlying int
// int bad = id;         // ❌ UserId is not int (compile error)
// UserId id2 = 42;      // ❌ int is not UserId (compile error)

─────────────────────────────────────
🔑 KEY FEATURES
─────────────────────────────────────
• Extension types are zero-cost — no boxing at runtime
• They ARE a new type — type system enforces distinction
• They cannot have mutable state beyond the representation
• Can define methods, getters, operators, constructors
• The representation field gives access to underlying value
• Can implement interfaces
• Can call representation type methods directly

─────────────────────────────────────
🆚 EXTENSION TYPE vs EXTENSION METHOD
─────────────────────────────────────
Extension method: adds methods to existing type, NOT a new type
Extension type:   IS a new type at compile time, zero-cost at runtime

─────────────────────────────────────
🔒 IMPLEMENTING INTERFACES
─────────────────────────────────────
extension type UserId(int value) implements int {
  // Now UserId IS an int — all int methods available
  // But type system still distinguishes UserId from int
}

With implements, the extension type IS a subtype of the
interface, so it can be used where the interface is expected.

─────────────────────────────────────
🎯 PRIMARY USE CASES
─────────────────────────────────────
1. Type-safe IDs (UserId vs ProductId vs OrderId)
2. Units of measure (Meters vs Feet, Celsius vs Fahrenheit)
3. Validated values (Email, PhoneNumber, Url)
4. Zero-cost wrappers for existing types
5. Interop types (JS interop uses extension types)

💻 CODE:
// ── TYPE-SAFE IDs ──────────────
extension type UserId(int value) {
  UserId.fromString(String s) : this(int.parse(s));
  String get display => 'user-\$value';
}

extension type ProductId(int value) {
  ProductId.fromString(String s) : this(int.parse(s));
  String get display => 'product-\$value';
}

extension type OrderId(String value) {
  bool get isValid => RegExp(r'^ORD-\\d{6}$').hasMatch(value);
}

// ── UNITS OF MEASURE ───────────
extension type Celsius(double value) {
  Fahrenheit toFahrenheit() => Fahrenheit(value * 9 / 5 + 32);
  Kelvin toKelvin() => Kelvin(value + 273.15);
  bool get isBoiling => value >= 100;
  bool get isFreezing => value <= 0;
}

extension type Fahrenheit(double value) {
  Celsius toCelsius() => Celsius((value - 32) * 5 / 9);
}

extension type Kelvin(double value) {
  Celsius toCelsius() => Celsius(value - 273.15);
}

// ── VALIDATED TYPES ─────────────
extension type Email(String value) {
  Email.validate(String s) : this(_validate(s));

  static String _validate(String s) {
    if (!RegExp(r'^[\\w-\\.]+@[\\w-]+\\.[a-zA-Z]{2,}$').hasMatch(s)) {
      throw ArgumentError('Invalid email: \$s');
    }
    return s;
  }

  String get domain => value.split('@').last;
  String get local => value.split('@').first;
}

// ── IMPLEMENTS (subtype) ────────
extension type Meters(double value) implements double {
  // implements double → Meters IS a double (can be used where double expected)
  Feet toFeet() => Feet(value * 3.28084);
  Kilometers toKilometers() => Kilometers(value / 1000);
}

extension type Feet(double value) implements double {
  Meters toMeters() => Meters(value / 3.28084);
}

extension type Kilometers(double value) implements double {
  Meters toMeters() => Meters(value * 1000);
}

// ── NON-NULLABLE WRAPPER ────────
extension type NonEmptyString(String value) {
  NonEmptyString.create(String s) : this(_validate(s));

  static String _validate(String s) {
    if (s.isEmpty) throw ArgumentError('String cannot be empty');
    return s;
  }

  int get length => value.length;
  NonEmptyString toUpperCase() => NonEmptyString(value.toUpperCase());
}

void main() {
  // ── TYPE SAFETY ────────────────
  final userId = UserId(42);
  final productId = ProductId(42);

  print(userId.display);       // user-42
  print(productId.display);    // product-42

  // These are DIFFERENT types — can't mix them up!
  // processUser(productId);  // ❌ Compile error!
  processUser(userId);         // ✅

  // ── TEMPERATURE CONVERSIONS ────
  final bodyTemp = Celsius(37.0);
  print('\$bodyTemp°C = \${bodyTemp.toFahrenheit().value}°F');
  print('\$bodyTemp°C = \${bodyTemp.toKelvin().value}K');

  final boiling = Celsius(100.0);
  print('100°C is boiling: \${boiling.isBoiling}');   // true
  print('100°C is freezing: \${boiling.isFreezing}'); // false

  final fahrenheit = Fahrenheit(212.0);
  print('212°F = \${fahrenheit.toCelsius().value}°C');   // 100°C

  // ── VALIDATED EMAIL ───────────
  try {
    final email = Email.validate('alice@example.com');
    print('Valid email: \${email.value}');
    print('Domain: \${email.domain}');   // example.com
    print('Local: \${email.local}');     // alice
  } catch (e) {
    print('Invalid: \$e');
  }

  try {
    Email.validate('not-an-email');  // ❌ throws
  } catch (e) {
    print('Caught: \$e');
  }

  // ── IMPLEMENTS DOUBLE ──────────
  final marathon = Meters(42195.0);
  print('\${marathon.value}m marathon');
  print('= \${marathon.toKilometers().value}km');    // 42.195km
  print('= \${marathon.toFeet().value.toStringAsFixed(0)}ft');

  // Because Meters implements double:
  double distance = marathon;   // ✅ Meters IS a double here
  print(distance > 40000);     // true

  // ── NON-EMPTY STRING ───────────
  try {
    final name = NonEmptyString.create('Alice');
    print(name.length);                 // 5
    print(name.toUpperCase().value);    // ALICE
  } catch (e) {
    print(e);
  }

  try {
    NonEmptyString.create('');  // ❌ throws
  } catch (e) {
    print('Empty string caught: \$e');
  }

  // ── ZERO COST ─────────────────
  // At runtime, UserId IS an int — no boxing, no allocation
  // Extension types are ERASED at compile time
  // This is truly zero overhead!
  print(UserId(100).runtimeType);  // int (NOT UserId!)

  // But the type system treats them as different AT COMPILE TIME
  // That's the magic of extension types.
}

void processUser(UserId id) {
  print('Processing user: \${id.display}');
}

// ── JS INTEROP (common use case) ─
// Extension types are used extensively for JavaScript interop:
// extension type HTMLElement(JSObject _) implements JSObject {
//   external String get innerHTML;
//   external void click();
// }

📝 KEY POINTS:
✅ Extension types create NEW compile-time types with ZERO runtime overhead
✅ The underlying representation is erased — no boxing, no allocation
✅ Type system treats extension types as distinct — prevents accidental mixing
✅ implements keyword makes an extension type a subtype of the interface
✅ Great for type-safe IDs, units of measure, and validated values
✅ Extension types cannot have mutable state beyond their representation
✅ Construction happens through the primary constructor (representation)
✅ .runtimeType shows the underlying type — extension type is invisible at runtime
❌ Extension types are not subclasses — no inheritance hierarchy
❌ Cannot have instance variables beyond the representation
❌ Extension types with implements CAN be confused with the implemented type
''',
  quiz: [
    Quiz(question: 'What is the key difference between extension methods and extension types?', options: [
      QuizOption(text: 'Extension methods are faster; extension types add more methods', correct: false),
      QuizOption(text: 'Extension methods add methods to an existing type; extension types CREATE a new distinct compile-time type', correct: true),
      QuizOption(text: 'Extension types are only for primitive types', correct: false),
      QuizOption(text: 'They are identical — just different syntax', correct: false),
    ]),
    Quiz(question: 'What does "zero-cost" mean for extension types?', options: [
      QuizOption(text: 'They are free to use from pub.dev', correct: false),
      QuizOption(text: 'At runtime, the extension type wrapper is completely erased — no boxing, no allocation overhead', correct: true),
      QuizOption(text: 'They compile faster than regular classes', correct: false),
      QuizOption(text: 'They use no memory at all', correct: false),
    ]),
    Quiz(question: 'What does "extension type Meters(double value) implements double" enable?', options: [
      QuizOption(text: 'Meters can now be extended like a class', correct: false),
      QuizOption(text: 'Meters IS a subtype of double — can be used where double is expected', correct: true),
      QuizOption(text: 'Meters gains all double methods', correct: false),
      QuizOption(text: 'double can be used where Meters is expected', correct: false),
    ]),
  ],
);
