import '../../models/lesson.dart';
import '../../models/quiz.dart';

final dartLesson30 = Lesson(
  language: 'Dart',
  title: 'Class Modifiers: final, interface, base & mixin',
  content: '''
🎯 METAPHOR:
Class modifiers are like different types of building permits.
A regular class has no restrictions — you can extend it,
implement it, mix it in. A final class is a heritage building
— you can USE it but cannot modify its structure (no subclassing).
An interface class is a standard template — you must follow
its blueprint exactly (implement all methods), but you can't
just add one floor and claim it's the same building.
A base class is a foundation — you can only BUILD ON TOP,
not just put a different facade on (no implementing without extending).
sealed covers the closed-hierarchy case we saw in lesson 29.

📖 EXPLANATION:
Dart 3 added class modifiers to give library authors precise
control over how their classes can be used. These modifiers
prevent misuse of APIs designed for specific usage patterns.

─────────────────────────────────────
📐 THE MODIFIERS
─────────────────────────────────────
(none)      → can extend, implement, or mixin anywhere
final       → cannot be extended or implemented OUTSIDE library
base        → can ONLY be extended (not implemented) outside library
              subclasses must also be base, final, or sealed
interface   → can ONLY be implemented (not extended) outside library
sealed      → closed hierarchy (same library only), exhaustiveness
abstract    → cannot be instantiated, no restriction on extend/implement
mixin       → can be mixed in with "with"; cannot be instantiated
mixin class → can be mixed in OR extended (like both mixin and class)

─────────────────────────────────────
🔑 COMBINATIONS THAT WORK
─────────────────────────────────────
abstract class         → common: can't instantiate, can extend/impl
abstract interface     → pure interface (like Java interface)
abstract base          → base class that can't be instantiated
final class            → no subclassing outside library
sealed class           → closed hierarchy + exhaustiveness

─────────────────────────────────────
🏭 WHEN TO USE WHICH
─────────────────────────────────────
interface:  "Implement this contract; don't extend my internals"
            Use for: public service contracts, plugin systems

base:       "Extend me; don't fake-implement me"
            Use for: base classes that need protected internals

final:      "Use me as-is; no subclassing"
            Use for: utility classes, value types

sealed:     "Exhaustive hierarchy; all cases known at compile time"
            Use for: state machines, algebraic data types

─────────────────────────────────────
📊 WHAT EACH MODIFIER ALLOWS
─────────────────────────────────────
Modifier    | Extend | Implement | Mix in
------------|--------|-----------|--------
(none)      |  ✅    |   ✅      |  ✅
abstract    |  ✅    |   ✅      |  ✅
final       |  ❌    |   ❌      |  ❌
base        |  ✅    |   ❌      |  ❌
interface   |  ❌    |   ✅      |  ❌
sealed      |  ✅*   |   ✅*     |  ❌  (* same library)
mixin       |  ❌    |   ✅      |  ✅
mixin class |  ✅    |   ✅      |  ✅

💻 CODE:
// ── INTERFACE CLASS ────────────
// Can only be IMPLEMENTED outside this library
abstract interface class Serializable {
  Map<String, dynamic> toJson();

  // Can have concrete methods that use the interface
  String toJsonString() {
    final json = toJson();
    return json.entries
        .map((e) => '"${e.key}": "${e.value}"')
        .join(', ');
  }
}

// Outside library: implement, never extend
class User implements Serializable {
  final String name;
  final int age;
  User({required this.name, required this.age});

  @override
  Map<String, dynamic> toJson() => {'name': name, 'age': age};
}

// ── BASE CLASS ─────────────────
// Can only be EXTENDED outside this library
abstract base class Animal {
  final String name;
  Animal(this.name);

  void breathe() => print('\$name breathes');

  // Subclasses provide this:
  void speak();
}

// Outside library: extend, never implement
final class Dog extends Animal {
  Dog(super.name);

  @override
  void speak() => print('\$name: Woof!');
}

// ❌ This would be a compile error outside the library:
// class FakeAnimal implements Animal { ... }

// ── FINAL CLASS ────────────────
// Cannot be extended or implemented outside this library
final class ImmutablePoint {
  final double x, y;
  const ImmutablePoint(this.x, this.y);

  double get magnitude => (x * x + y * y).sqrt();
  ImmutablePoint operator +(ImmutablePoint other) =>
      ImmutablePoint(x + other.x, y + other.y);

  @override
  String toString() => 'Point(\$x, \$y)';
}

// ❌ Compile error outside library:
// class MyPoint extends ImmutablePoint { ... }  // can't extend final

// ── ABSTRACT INTERFACE ─────────
// Pure contract — like a Java interface
abstract interface class Repository<T> {
  Future<T?> findById(String id);
  Future<List<T>> findAll();
  Future<void> save(T entity);
  Future<void> delete(String id);
}

// Implemented by concrete classes
class UserRepository implements Repository<User> {
  final Map<String, User> _store = {};

  @override
  Future<User?> findById(String id) async => _store[id];

  @override
  Future<List<User>> findAll() async => _store.values.toList();

  @override
  Future<void> save(User entity) async => _store[entity.name] = entity;

  @override
  Future<void> delete(String id) async => _store.remove(id);
}

// ── MIXIN CLASS ────────────────
// Can be both mixed in AND extended
mixin class Timestamped {
  DateTime? createdAt;
  DateTime? updatedAt;

  void markCreated() => createdAt = DateTime.now();
  void markUpdated() => updatedAt = DateTime.now();
}

// Use as mixin:
class Post with Timestamped {
  final String title;
  Post(this.title) { markCreated(); }
}

// Use as base class:
class AuditableEntity extends Timestamped {
  final String id;
  AuditableEntity(this.id) { markCreated(); }

  void update() {
    markUpdated();
  }
}

// ── ABSTRACT BASE ──────────────
abstract base class Validator<T> {
  bool validate(T value);

  void assertValid(T value) {
    if (!validate(value)) {
      throw ArgumentError('Invalid value: \$value');
    }
  }
}

final class EmailValidator extends Validator<String> {
  @override
  bool validate(String value) =>
      RegExp(r'^[\w-\.]+@[\w-]+\.[a-zA-Z]{2,}$').hasMatch(value);
}

final class AgeValidator extends Validator<int> {
  final int min, max;
  AgeValidator({this.min = 0, this.max = 150});

  @override
  bool validate(int value) => value >= min && value <= max;
}

void main() {
  // ── INTERFACE ─────────────────
  final user = User(name: 'Alice', age: 30);
  print(user.toJsonString());

  // ── BASE CLASS USAGE ──────────
  final dog = Dog('Rex');
  dog.speak();    // Rex: Woof!
  dog.breathe();  // Rex breathes (inherited from Animal)

  // ── FINAL CLASS ───────────────
  final p1 = ImmutablePoint(3, 4);
  final p2 = ImmutablePoint(1, 2);
  final p3 = p1 + p2;
  print(p3);               // Point(4.0, 6.0)
  print(p1.magnitude);     // 5.0

  // ── MIXIN CLASS ────────────────
  final post = Post('Dart 3 Features');
  print(post.createdAt != null);   // true

  final entity = AuditableEntity('user-001');
  entity.update();
  print(entity.updatedAt != null);   // true

  // ── VALIDATORS ────────────────
  final emailVal = EmailValidator();
  print(emailVal.validate('alice@example.com'));  // true
  print(emailVal.validate('not-an-email'));        // false

  final ageVal = AgeValidator(min: 18, max: 100);
  try {
    ageVal.assertValid(15);
  } on ArgumentError catch (e) {
    print('Age error: \$e');
  }
  ageVal.assertValid(25);   // passes
  print('All modifier examples complete!');
}

extension on double {
  double sqrt() {
    if (this <= 0) return 0;
    double g = this / 2;
    for (int i = 0; i < 20; i++) g = (g + this / g) / 2;
    return g;
  }
}

📝 KEY POINTS:
✅ interface: only implementable — callers write their own implementation
✅ base: only extendable — callers must build on your implementation
✅ final: neither extendable nor implementable — use as-is
✅ sealed: closed hierarchy in same library — enables exhaustiveness
✅ mixin class: can be both mixed in AND extended
✅ abstract interface: pure contract with no concrete members (like Java interface)
✅ Modifiers only restrict usage OUTSIDE the defining library
✅ Combine modifiers: abstract base, abstract interface, abstract final
❌ Outside the library: base classes can't be implemented, only extended
❌ Outside the library: interface classes can't be extended, only implemented
❌ final classes can have no subclasses at all outside the defining library
''',
  quiz: [
    Quiz(question: 'What does "interface class" prevent outside the library?', options: [
      QuizOption(text: 'It prevents the class from being instantiated', correct: false),
      QuizOption(text: 'It prevents extension (extending) — only implementation is allowed', correct: true),
      QuizOption(text: 'It prevents all usage of the class', correct: false),
      QuizOption(text: 'It prevents the class from having concrete methods', correct: false),
    ]),
    Quiz(question: 'What makes "mixin class" special compared to "mixin"?', options: [
      QuizOption(text: 'mixin class can have constructors; mixin cannot', correct: false),
      QuizOption(text: 'mixin class can be both mixed in with "with" AND extended with "extends"', correct: true),
      QuizOption(text: 'mixin class is only for abstract classes', correct: false),
      QuizOption(text: 'mixin class allows multiple inheritance', correct: false),
    ]),
    Quiz(question: 'A "base class" outside its library can be...', options: [
      QuizOption(text: 'Extended only', correct: true),
      QuizOption(text: 'Implemented only', correct: false),
      QuizOption(text: 'Both extended and implemented', correct: false),
      QuizOption(text: 'Neither extended nor implemented', correct: false),
    ]),
  ],
);
