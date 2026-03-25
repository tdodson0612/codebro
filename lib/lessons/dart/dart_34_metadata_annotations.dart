import '../../models/lesson.dart';
import '../../models/quiz.dart';

final dartLesson34 = Lesson(
  language: 'Dart',
  title: 'Metadata & Annotations',
  content: '''
🎯 METAPHOR:
Annotations are like sticky notes attached to code.
The code itself runs the program. The sticky notes tell
TOOLS (analyzers, code generators, frameworks) something
extra: "this is deprecated, warn users," "this method
overrides a parent method," "this class should be
serialized to JSON," "this test should be skipped."
The sticky notes don't change what the code does —
they change what TOOLS do WITH the code. @override is a
sticky note to the compiler: "verify I'm actually overriding
something." @JsonSerializable is a note to build_runner:
"generate serialization code for this class."

📖 EXPLANATION:
Metadata (annotations) in Dart are @expression applied to
declarations. Built-in annotations: @override, @deprecated,
@pragma. Custom annotations are classes used as metadata.
Annotations are read by tools, code generators, and
at runtime via dart:mirrors (limited in Flutter).

─────────────────────────────────────
📦 BUILT-IN ANNOTATIONS
─────────────────────────────────────
@override           → verifies method overrides parent
@deprecated         → marks API as deprecated
@Deprecated("msg")  → deprecated with message + since
@pragma(...)        → hints to compiler/tools

Analysis annotations (from package:meta):
@required           → required parameter (pre-null-safety)
@visibleForTesting  → internal but accessible for tests
@protected          → only for subclasses
@immutable          → all fields should be final
@sealed             → like sealed class but via annotation
@experimental       → API may change
@nonVirtual         → method should not be overridden
@mustCallSuper      → overrides must call super
@internal           → not for public API use
@useResult          → return value must be used
@factory            → method is a factory

─────────────────────────────────────
🏗️  CUSTOM ANNOTATIONS
─────────────────────────────────────
class Route {
  final String path;
  final String method;
  const Route(this.path, {this.method = 'GET'});
}

@Route('/users', method: 'POST')
void createUser() { ... }

// Annotations must be:
//   • const constructors
//   • Created with const expressions

─────────────────────────────────────
🔧 CODE GENERATION ANNOTATIONS
─────────────────────────────────────
Many popular packages use annotations + build_runner
to generate code:

json_serializable:
  @JsonSerializable()
  class User { ... }
  → generates user.g.dart with fromJson/toJson

freezed:
  @freezed
  class User with _\$User { ... }
  → generates immutable classes with copyWith, ==, toString

injectable:
  @injectable
  @singleton
  class ApiService { ... }
  → generates dependency injection code

─────────────────────────────────────
🔍 READING ANNOTATIONS
─────────────────────────────────────
At compile time: tools like dart analyze, build_runner
At runtime: dart:mirrors (limited, not in Flutter)
  reflectable package for Flutter reflection

💻 CODE:
// ── BUILT-IN ANNOTATIONS ───────

class Animal {
  String get name => 'Animal';
  void speak() => print('...');
}

class Dog extends Animal {
  @override                    // tells compiler: verify this overrides
  String get name => 'Dog';

  @override
  void speak() => print('Woof!');
}

// @deprecated and @Deprecated
@deprecated                    // simple deprecation (no message)
void oldFunction() {}

@Deprecated('Use newFunction() instead. Will be removed in 2.0')
void oldFunctionWithMessage() {}

void newFunction() {}

// Usage:
// oldFunctionWithMessage();  // Shows deprecation warning in IDE

// ── PACKAGE:META ANNOTATIONS ───
// (import 'package:meta/meta.dart';)

// @immutable — all fields should be final
// @immutable
class Point {
  final double x, y;
  const Point(this.x, this.y);  // ✅ immutable, all final
}

// Violation would be warned:
// @immutable
// class BadPoint {
//   double x, y;  // ⚠️ non-final in @immutable class
//   BadPoint(this.x, this.y);
// }

// @protected — only for use by the class or subclasses
class Base {
  // @protected  // (commented — needs package:meta import)
  void internalOperation() => print('Internal op');

  void publicMethod() => internalOperation();   // ✅ from same class
}

class Child extends Base {
  void doSomething() => internalOperation();  // ✅ from subclass
}

// @mustCallSuper — overrides must call super
class Widget {
  // @mustCallSuper
  void initState() {
    print('Base initState');
    // Do important initialization
  }
}

class MyWidget extends Widget {
  @override
  void initState() {
    super.initState();   // ✅ must call this
    print('MyWidget initState');
  }
}

// @visibleForTesting — not for production use
class DataService {
  final List<String> _cache = [];

  // @visibleForTesting
  List<String> get cacheForTesting => List.unmodifiable(_cache);

  void addToCache(String item) => _cache.add(item);
}

// ── CUSTOM ANNOTATIONS ─────────

// Annotation class (must be const-constructable)
class Route {
  final String path;
  final String method;
  final bool requiresAuth;

  const Route(
    this.path, {
    this.method = 'GET',
    this.requiresAuth = false,
  });
}

class Validate {
  final String field;
  final dynamic min;
  final dynamic max;
  final bool required;

  const Validate(
    this.field, {
    this.min,
    this.max,
    this.required = true,
  });
}

class TestTag {
  final String name;
  const TestTag(this.name);
}

// Using custom annotations:
@Route('/api/users')
List<dynamic> getUsers() => [];

@Route('/api/users', method: 'POST', requiresAuth: true)
dynamic createUser(@Validate('name', min: 1) String name) => null;

@Route('/api/users/:id', method: 'DELETE', requiresAuth: true)
bool deleteUser(String id) => true;

@TestTag('integration')
void testUserCreation() {
  // test code...
}

// ── JSON SERIALIZATION PATTERN ─
// This is how json_serializable works
// (without the actual code generation):

class JsonKey {
  final String? name;
  final bool? includeIfNull;
  const JsonKey({this.name, this.includeIfNull});
}

class JsonSerializable {
  const JsonSerializable();
}

// Annotated model:
// @JsonSerializable()
class UserModel {
  // @JsonKey(name: 'user_name')
  final String userName;

  // @JsonKey(name: 'email_address', includeIfNull: false)
  final String? emailAddress;

  final int age;

  const UserModel({
    required this.userName,
    this.emailAddress,
    required this.age,
  });

  // Generated code would add these:
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    userName: json['user_name'] as String,
    emailAddress: json['email_address'] as String?,
    age: json['age'] as int,
  );

  Map<String, dynamic> toJson() => {
    'user_name': userName,
    if (emailAddress != null) 'email_address': emailAddress,
    'age': age,
  };
}

// ── READING ANNOTATIONS AT RUNTIME ─
// In pure Dart (not Flutter), you can use dart:mirrors:
/*
import 'dart:mirrors';

void printAnnotations(Object obj) {
  final mirror = reflect(obj);
  final classMirror = mirror.type;

  for (final metadata in classMirror.metadata) {
    print('Annotation: \${
metadata.reflectee}');
  }
}
*/

// ── PRAGMA ANNOTATION ──────────
// @pragma hints to the compiler/tools:
@pragma('vm:prefer-inline')   // tell VM to inline this function
int add(int a, int b) => a + b;

@pragma('vm:never-inline')    // prevent inlining
void neverInlined() { print('not inlined'); }

void main() {
  // ── USAGE DEMO ─────────────────
  final dog = Dog();
  dog.speak();     // Woof!
  print(dog.name); // Dog

  // Deprecated API usage (shows warning in IDE):
  // oldFunction();  // ⚠️ Deprecated

  final user = UserModel(
    userName: 'alice',
    emailAddress: 'alice@example.com',
    age: 30,
  );

  print(user.toJson());
  // {user_name: alice, email_address: alice@example.com, age: 30}

  final parsed = UserModel.fromJson({
    'user_name': 'bob',
    'age': 25,
  });
  print(parsed.userName);   // bob

  print('Annotations demo complete!');
}

📝 KEY POINTS:
✅ @override is the most important annotation — use it whenever overriding
✅ @Deprecated("msg") with a message helps users migrate away from old APIs
✅ Custom annotations are const-constructable classes
✅ Annotations don't change runtime behavior — they're metadata for tools
✅ Code generation frameworks (json_serializable, freezed) use annotations extensively
✅ package:meta provides professional-grade annotations for API design
✅ @visibleForTesting exposes internals without making them truly public
✅ @pragma provides compiler/VM hints for optimization
❌ Annotations without a tool to read them have no effect
❌ Annotation classes must have const constructors
❌ dart:mirrors (runtime reflection) is not available in Flutter — use codegen instead
''',
  quiz: [
    Quiz(question: 'What does the @override annotation do?', options: [
      QuizOption(text: 'Forces the method to override the parent implementation', correct: false),
      QuizOption(text: 'Tells the compiler to verify the method actually overrides a parent — a compile error if it doesn\'t', correct: true),
      QuizOption(text: 'Makes the method call super automatically', correct: false),
      QuizOption(text: 'Prevents the method from being overridden further', correct: false),
    ]),
    Quiz(question: 'What is required for a class to be used as an annotation?', options: [
      QuizOption(text: 'It must extend Annotation', correct: false),
      QuizOption(text: 'It must have a const constructor', correct: true),
      QuizOption(text: 'It must implement the Metadata interface', correct: false),
      QuizOption(text: 'It must have no fields', correct: false),
    ]),
    Quiz(question: 'How do annotations like @JsonSerializable() work in practice?', options: [
      QuizOption(text: 'They modify the class at runtime', correct: false),
      QuizOption(text: 'They are read by tools like build_runner to generate additional code', correct: true),
      QuizOption(text: 'They inject methods into the class automatically', correct: false),
      QuizOption(text: 'They are only hints for documentation tools', correct: false),
    ]),
  ],
);