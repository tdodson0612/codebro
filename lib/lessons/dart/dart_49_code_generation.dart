import '../../models/lesson.dart';
import '../../models/quiz.dart';

final dartLesson49 = Lesson(
  language: 'Dart',
  title: 'Code Generation: build_runner & json_serializable',
  content: '''
🎯 METAPHOR:
Code generation is like having a tireless intern who
writes boilerplate for you. You write the blueprint
(annotate your class with @JsonSerializable), the intern
(build_runner) reads your blueprint, and writes out all
the tedious, error-prone fromJson/toJson code that would
take you 20 minutes and might have a typo. You maintain
the blueprint; the intern regenerates the code every time
you change it. The generated files are real Dart code —
you can read them, they compile, they're type-safe. You
just don't write them by hand.

📖 EXPLANATION:
Code generation in Dart uses build_runner and source_gen to
read annotations and generate .g.dart files. Popular
generators: json_serializable (JSON parsing),
freezed (immutable value types), riverpod_generator
(state management), and more.

─────────────────────────────────────
📦 SETUP
─────────────────────────────────────
pubspec.yaml:

dependencies:
  json_annotation: ^4.8.0

dev_dependencies:
  build_runner: ^2.4.0
  json_serializable: ^6.7.0

Run code generation:
  dart run build_runner build         → generate once
  dart run build_runner watch         → watch & regenerate
  dart run build_runner build --delete-conflicting-outputs

─────────────────────────────────────
📋 JSON_SERIALIZABLE
─────────────────────────────────────
@JsonSerializable()           → annotate the class
part 'file.g.dart';           → include generated file
fromJson factory:  MyClass.fromJson(map)
toJson method:     instance.toJson()

Customization annotations:
@JsonKey(name: 'snake_case')  → custom JSON field name
@JsonKey(ignore: true)        → exclude from serialization
@JsonKey(defaultValue: 0)     → default if missing from JSON
@JsonKey(fromJson: parser)    → custom parse function

─────────────────────────────────────
❄️  FREEZED
─────────────────────────────────────
Generates immutable value types with:
  • copyWith()
  • == and hashCode
  • toString()
  • Union types (sealed classes)
  • Pattern matching

Setup:
  dependencies: freezed_annotation
  dev_deps: freezed, build_runner

─────────────────────────────────────
📁 GENERATED FILES
─────────────────────────────────────
Generated files end in .g.dart (json_serializable)
or .freezed.dart (freezed).
DO NOT edit generated files — they are overwritten.
DO add *.g.dart and *.freezed.dart to .gitignore? Debated.
(Many teams commit them for CI speed.)

─────────────────────────────────────
🔧 CUSTOM CODE GENERATORS
─────────────────────────────────────
Build custom generators with source_gen + build:
  1. Create a Generator class
  2. Create a Builder factory
  3. Configure in build.yaml
  Used by large teams for domain-specific codegen.

💻 CODE:
// ── JSON_SERIALIZABLE EXAMPLE ────

// user.dart (your source file):
/*
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';  // the generated part file

@JsonSerializable()
class User {
  final String name;
  final int age;

  @JsonKey(name: 'email_address')  // maps to "email_address" in JSON
  final String email;

  @JsonKey(ignore: true)  // not included in serialization
  String? sessionToken;

  @JsonKey(defaultValue: false)
  final bool isAdmin;

  const User({
    required this.name,
    required this.age,
    required this.email,
    this.sessionToken,
    this.isAdmin = false,
  });

  factory User.fromJson(Map<String, dynamic> json) =>
      _\$UserFromJson(json);          // generated function

  Map<String, dynamic> toJson() =>
      _\$UserToJson(this);            // generated function
}
*/

// user.g.dart (GENERATED — do not edit):
/*
part of 'user.dart';

User _\$UserFromJson(Map<String, dynamic> json) => User(
      name: json['name'] as String,
      age: json['age'] as int,
      email: json['email_address'] as String,
      isAdmin: json['isAdmin'] as bool? ?? false,
    );

Map<String, dynamic> _\$UserToJson(User instance) => <String, dynamic>{
      'name': instance.name,
      'age': instance.age,
      'email_address': instance.email,
      'isAdmin': instance.isAdmin,
    };
*/

// Usage (after generation):
void jsonSerializableExample() {
  // Parse JSON
  final json = {
    'name': 'Alice',
    'age': 30,
    'email_address': 'alice@example.com',
    'isAdmin': true,
  };

  // final user = User.fromJson(json);
  // print(user.name);       // Alice
  // print(user.email);      // alice@example.com
  // print(user.isAdmin);    // true

  // Convert back to JSON
  // final backToJson = user.toJson();
  // print(backToJson);
  // {name: Alice, age: 30, email_address: alice@example.com, isAdmin: true}
  print('See json_annotation package on pub.dev');
}

// ── NESTED OBJECTS ────────────────

/*
@JsonSerializable()
class Address {
  final String street;
  final String city;
  final String country;

  const Address({
    required this.street,
    required this.city,
    required this.country,
  });

  factory Address.fromJson(Map<String, dynamic> json) =>
      _\$AddressFromJson(json);
  Map<String, dynamic> toJson() => _\$AddressToJson(this);
}

@JsonSerializable()
class UserWithAddress {
  final String name;

  @JsonKey(name: 'home_address')
  final Address address;               // nested object

  final List<String> phoneNumbers;     // list of primitives

  @JsonKey(name: 'aliases')
  final List<Address> otherAddresses;  // list of objects

  const UserWithAddress({
    required this.name,
    required this.address,
    required this.phoneNumbers,
    required this.otherAddresses,
  });

  factory UserWithAddress.fromJson(Map<String, dynamic> json) =>
      _\$UserWithAddressFromJson(json);
  Map<String, dynamic> toJson() => _\$UserWithAddressToJson(this);
}
*/

// ── FREEZED EXAMPLE ──────────────

/*
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';  // needed for json if using @JsonSerializable

@freezed
class UserFrozen with _\$UserFrozen {
  const factory UserFrozen({
    required String name,
    required int age,
    String? email,
    @Default(false) bool isAdmin,
  }) = _UserFrozen;

  factory UserFrozen.fromJson(Map<String, dynamic> json) =>
      _\$UserFrozenFromJson(json);
}

// Generated gives you:
// - copyWith: user.copyWith(name: 'Bob', age: 25)
// - == and hashCode: user1 == user2 (by value)
// - toString: UserFrozen(name: Alice, age: 30, ...)
// - fromJson / toJson (if json: true)
*/

// ── FREEZED UNION TYPES ───────────

/*
@freezed
sealed class ApiResult<T> with _\$ApiResult<T> {
  const factory ApiResult.loading() = Loading;
  const factory ApiResult.success(T data) = Success;
  const factory ApiResult.error(String message) = Error;
}

// Usage with pattern matching:
void handleResult(ApiResult<User> result) {
  switch (result) {
    case Loading():
      print('Loading...');
    case Success(:final data):
      print('Got user: ${
data.name}');
    case Error(:final message):
      print('Error: \$message');
  }
}
*/

// ── RUNNING BUILD_RUNNER ──────────

String buildRunnerCommands = """
# One-time build:
dart run build_runner build

# Delete stale generated files and rebuild:
dart run build_runner build --delete-conflicting-outputs

# Watch mode (auto-regenerate on changes):
dart run build_runner watch

# In a Flutter project:
flutter pub run build_runner build
flutter pub run build_runner watch

# Common error: delete generated files and rebuild:
find . -name "*.g.dart" -delete
find . -name "*.freezed.dart" -delete
dart run build_runner build --delete-conflicting-outputs
""";

// ── OTHER POPULAR GENERATORS ──────

String otherGenerators = """
Package               → Generates
─────────────────────────────────────
json_serializable     → fromJson/toJson
freezed               → immutable value objects + unions
riverpod_generator    → Riverpod providers (@riverpod)
injectable            → dependency injection (@injectable)
auto_route            → type-safe navigation
floor                 → SQLite ORM
drift (moor)          → reactive SQLite database
isar                  → local database
mockito               → test mocks
retrofit              → type-safe HTTP client
openapi_generator     → from OpenAPI/Swagger spec
protoc                → from protobuf definitions
""";

void main() {
  jsonSerializableExample();
  print(buildRunnerCommands);
  print(otherGenerators);
}

📝 KEY POINTS:
✅ Code generation reads annotations and writes boilerplate .g.dart files
✅ json_serializable generates type-safe fromJson/toJson for every annotated class
✅ freezed generates immutable value types with copyWith, ==, hashCode, toString
✅ part 'file.g.dart'; includes the generated file in your library
✅ dart run build_runner watch auto-regenerates on every save
✅ @JsonKey(name: 'json_name') maps Dart field names to JSON field names
✅ Never edit generated .g.dart or .freezed.dart files — they'll be overwritten
✅ freezed union types are perfect for state management (loading/success/error)
❌ Forgetting the part 'file.g.dart'; line breaks the generated code
❌ Running build_runner before installing the packages causes cryptic errors
❌ Editing generated files manually — they will be overwritten on next build
''',
  quiz: [
    Quiz(question: 'What does "part \'user.g.dart\';" do in a Dart file?', options: [
      QuizOption(text: 'Imports the generated file as a separate library', correct: false),
      QuizOption(text: 'Includes the generated file as part of the same library — both files share the same namespace', correct: true),
      QuizOption(text: 'Exports the generated code to other files', correct: false),
      QuizOption(text: 'Tells the IDE to ignore the generated file', correct: false),
    ]),
    Quiz(question: 'What does @JsonKey(name: \'user_name\') do?', options: [
      QuizOption(text: 'Renames the Dart field to user_name', correct: false),
      QuizOption(text: 'Maps the Dart field to the JSON key "user_name" during serialization/deserialization', correct: true),
      QuizOption(text: 'Makes the field required in JSON', correct: false),
      QuizOption(text: 'Creates a validation rule for the field', correct: false),
    ]),
    Quiz(question: 'What command regenerates code AND removes stale files?', options: [
      QuizOption(text: 'dart run build_runner clean', correct: false),
      QuizOption(text: 'dart run build_runner build --delete-conflicting-outputs', correct: true),
      QuizOption(text: 'dart run build_runner rebuild', correct: false),
      QuizOption(text: 'dart pub generate', correct: false),
    ]),
  ],
);
