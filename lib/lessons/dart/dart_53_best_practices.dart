import '../../models/lesson.dart';
import '../../models/quiz.dart';

final dartLesson53 = Lesson(
  language: 'Dart',
  title: 'Dart Best Practices & Style Guide',
  content: '''
🎯 METAPHOR:
Code style is like the dress code at a company.
Individual preference is fine at home, but at work,
consistency lets everyone collaborate smoothly. When your
Dart code follows the official style guide, any teammate
can read it immediately — no "deciphering" someone else's
formatting decisions. dart format is the automatic tailor
who enforces the dress code so humans don't have to argue
about whether to use tabs or spaces (the answer is always
2 spaces). The linter is HR — it flags rule violations
before they become problems.

📖 EXPLANATION:
The official Dart style guide (dart.dev/guides/language/effective-dart)
covers naming, types, usage, and design. dart format enforces
formatting automatically. The lints package provides recommended
lint rules. Following these makes your code idiomatic Dart.

─────────────────────────────────────
📝 NAMING CONVENTIONS
─────────────────────────────────────
UpperCamelCase:   classes, enums, typedefs, extensions
  class UserProfile { }
  enum Status { }
  typedef Predicate<T> = bool Function(T);

lowerCamelCase:   variables, functions, parameters
  var itemCount = 0;
  void calculateTotal() { }
  String firstName;

lowercase_with_underscores: files, libraries, packages
  user_profile.dart
  dart_tutorial

SCREAMING_SNAKE: constants (optional — lowerCamelCase also OK)
  const maxRetries = 3;       // preferred
  const MAX_RETRIES = 3;      // acceptable

─────────────────────────────────────
📋 TYPE ANNOTATIONS
─────────────────────────────────────
✅ Annotate public API types (always)
✅ Annotate when inference is unclear
✅ Use var for local variables where type is obvious
❌ Don't annotate things that are obviously inferred

// Obvious — use var:
var name = 'Alice';         // clearly String
var items = <int>[1, 2, 3]; // clearly List<int>

// Not obvious — annotate:
String processData(Map<String, dynamic> raw) { ... }

─────────────────────────────────────
🔑 PREFER FINAL
─────────────────────────────────────
Prefer final over var for things that don't change.
Prefer const wherever possible.
Make fields final unless they NEED to be mutable.

─────────────────────────────────────
✅ EFFECTIVE DART RULES
─────────────────────────────────────
DO:
  • Use ?. before calling methods on nullable types
  • Use => for simple one-line functions
  • Use collection literals over constructors
  • Prefer const constructors
  • Throw Error for programming errors; Exception for runtime errors
  • Document public APIs with ///

DON'T:
  • Use dynamic unless truly needed
  • Use late unless necessary
  • Cast (as) without checking first
  • Ignore lint warnings

─────────────────────────────────────
🔧 LINT SETUP
─────────────────────────────────────
analysis_options.yaml:
  include: package:lints/recommended.yaml
  # or stricter:
  include: package:flutter_lints/flutter.yaml
  # or even stricter:
  include: package:very_good_analysis/analysis_options.yaml

Popular extra rules:
  - always_use_package_imports
  - prefer_final_locals
  - avoid_dynamic
  - sort_pub_dependencies

─────────────────────────────────────
📐 FORMATTING RULES (dart format)
─────────────────────────────────────
• 80-character line limit
• 2-space indentation
• Single blank line between members
• Trailing commas on multi-line collections (prevents diffs)
• Always use curly braces, even for single-line if
• Spaces around operators and after commas

💻 CODE:
// ── NAMING ────────────────────────

// ✅ GOOD
class UserRepository {
  final String userId;
  UserRepository({required this.userId});

  Future<User> fetchUser() async => User(id: userId, name: 'Alice');
}

typedef JsonMap = Map<String, dynamic>;

enum OrderStatus { pending, processing, shipped, delivered }

// ❌ BAD
// class user_repository { }
// class USERREPOSITORY { }
// var UserName = 'Alice';

// ── CONST & FINAL ─────────────────

// ✅ Use const for compile-time constants
const int kMaxRetries = 3;
const Duration kRequestTimeout = Duration(seconds: 30);
const String kBaseUrl = 'https://api.example.com';

class Config {
  // ✅ Final fields
  final String host;
  final int port;
  final bool useHttps;

  const Config({
    required this.host,
    this.port = 443,
    this.useHttps = true,
  });
}

// ── COLLECTION LITERALS ───────────

// ✅ GOOD — use literals
var list = <int>[1, 2, 3];
var map = <String, int>{'a': 1, 'b': 2};
var set = <String>{'alpha', 'beta'};

// ❌ AVOID
// var list = List<int>.from([1, 2, 3]);
// var map = Map<String, int>.fromEntries([MapEntry('a', 1)]);

// ── FUNCTION STYLE ────────────────

// ✅ Arrow for single expressions
String greet(String name) => 'Hello, \$name!';

int square(int n) => n * n;

// ✅ Block for complex logic
Future<User> loadUser(String id) async {
  final json = await fetchJson('/users/\$id');
  return User.fromJson(json);
}

// ❌ AVOID arrow on multi-line
// String process(String s) =>
//   s.trim().toLowerCase().replaceAll(' ', '_'); // OK but limit complexity

// ── NULL SAFETY PATTERNS ──────────

class Profile {
  final String name;
  final String? bio;         // nullable — truly optional
  final String email;        // non-nullable — always required

  Profile({required this.name, required this.email, this.bio});

  // ✅ Use ?? for null-aware defaults
  String get displayBio => bio ?? 'No bio provided';

  // ✅ Null check before use
  int? get bioLength => bio?.length;

  // ✅ Prefer null-safe operations over !
  // ❌ Avoid: bio!.length  (throws if null)
  // ✅ Do:    bio?.length  (returns null)
}

// ── PREFER INTERFACES ─────────────

// ✅ Program to interfaces, not implementations
abstract interface class UserStorage {
  Future<User?> find(String id);
  Future<void> save(User user);
  Future<void> delete(String id);
}

class DatabaseStorage implements UserStorage {
  @override Future<User?> find(String id) async { return null; }
  @override Future<void> save(User user) async { }
  @override Future<void> delete(String id) async { }
}

class CacheStorage implements UserStorage {
  final Map<String, User> _cache = {};
  @override Future<User?> find(String id) async => _cache[id];
  @override Future<void> save(User user) async => _cache[user.id] = user;
  @override Future<void> delete(String id) async => _cache.remove(id);
}

// ── ERROR HANDLING ────────────────

// ✅ Throw Exception for expected failures (caller should handle)
class UserNotFoundException implements Exception {
  final String userId;
  UserNotFoundException(this.userId);

  @override
  String toString() => 'UserNotFoundException: User \$userId not found';
}

// ✅ Throw Error for programming mistakes (bugs)
class InvalidStateError extends Error {
  final String message;
  InvalidStateError(this.message);

  @override
  String toString() => 'InvalidStateError: \$message';
}

// ✅ Always handle specific exceptions
Future<User> getUser(String id) async {
  try {
    return await fetchUser(id);
  } on UserNotFoundException {
    rethrow;   // expected — let caller handle
  } on NetworkException catch (e) {
    throw ServiceException('Failed to fetch user: \$e');
  }
  // Don't catch Exception or Error broadly without rethrowing
}

// ── DOCUMENTATION ─────────────────

/// A repository for managing [User] entities.
///
/// Example usage:
/// ```dart
/// final repo = UserRepository(storage: DatabaseStorage());
/// final user = await repo.findUser('alice-id');
/// ```
class UserRepository {
  final UserStorage _storage;

  /// Creates a [UserRepository] with the given [storage] backend.
  UserRepository({required UserStorage storage}) : _storage = storage;

  /// Finds a user by [id].
  ///
  /// Returns null if the user doesn't exist.
  /// Throws [NetworkException] if the storage is unavailable.
  Future<User?> findUser(String id) => _storage.find(id);

  /// Saves [user] to storage.
  ///
  /// Overwrites any existing user with the same id.
  Future<void> saveUser(User user) => _storage.save(user);
}

// ── TRAILING COMMAS ───────────────

// ✅ Always use trailing commas in multi-line calls
// They prevent git diff noise and enable better formatting
Widget buildButton({
  required String label,
  required VoidCallback onPressed,
  bool enabled = true,     // ← trailing comma
}) {
  return ElevatedButton(
    onPressed: enabled ? onPressed : null,
    style: ButtonStyle(),
    child: Text(label),   // ← trailing comma
  );
}

// ── ANALYSIS_OPTIONS.YAML ─────────

String analysisOptionsExample = '''
# analysis_options.yaml
include: package:lints/recommended.yaml

analyzer:
  exclude:
    - '**/*.g.dart'
    - '**/*.freezed.dart'
  errors:
    missing_required_param: error
    missing_return: error
    dead_code: warning
  language:
    strict-casts: true
    strict-raw-types: true

linter:
  rules:
    - always_use_package_imports
    - prefer_final_locals
    - prefer_const_constructors
    - avoid_print         # use logging instead
    - no_leading_underscores_for_local_identifiers
    - prefer_relative_imports
''';

// Placeholder classes for compilation
class User { final String id; final String name; const User({required this.id, required this.name}); }
class Widget { }
class ElevatedButton extends Widget { ElevatedButton({dynamic onPressed, dynamic style, dynamic child}); }
class Text extends Widget { Text(String t); }
class ButtonStyle { }
typedef VoidCallback = void Function();
Future<Map<String, dynamic>> fetchJson(String url) async => {};
Future<User> fetchUser(String id) async => User(id: id, name: '');
class NetworkException implements Exception { }
class ServiceException implements Exception { final String msg; ServiceException(this.msg); }

void main() {
  print('Run: dart analyze  → check for issues');
  print('Run: dart format . → auto-format all files');
}

📝 KEY POINTS:
✅ UpperCamelCase for types; lowerCamelCase for variables/functions
✅ Files and packages use lowercase_with_underscores
✅ Prefer final over var; prefer const over final when possible
✅ Use collection literals []; <> rather than constructors List.from()
✅ Use /// for documentation comments — they appear in IDEs and dart doc
✅ Always add trailing commas in multi-line argument lists
✅ Throw Exception for expected runtime errors; Error for programming bugs
✅ dart analyze catches issues; dart format enforces formatting automatically
❌ Don't use dynamic unless absolutely necessary — it kills type safety
❌ Don't catch and swallow exceptions without logging or rethrowing
❌ Don't skip the analysis_options.yaml — lint rules catch real bugs
''',
  quiz: [
    Quiz(question: 'What naming convention does Dart use for class names?', options: [
      QuizOption(text: 'lowercase_with_underscores like file names', correct: false),
      QuizOption(text: 'UpperCamelCase like UserProfile', correct: true),
      QuizOption(text: 'SCREAMING_SNAKE_CASE', correct: false),
      QuizOption(text: 'lowerCamelCase like variable names', correct: false),
    ]),
    Quiz(question: 'When should you throw an Error versus an Exception in Dart?', options: [
      QuizOption(text: 'Errors for all failures; Exceptions are only for network issues', correct: false),
      QuizOption(text: 'Throw Exception for expected runtime failures callers should handle; Error for programming bugs', correct: true),
      QuizOption(text: 'They are the same — use either interchangeably', correct: false),
      QuizOption(text: 'Throw Error for async functions; Exception for sync functions', correct: false),
    ]),
    Quiz(question: 'Why should you add trailing commas to multi-line function arguments?', options: [
      QuizOption(text: 'Trailing commas are required syntax in Dart', correct: false),
      QuizOption(text: 'They allow dart format to format each argument on its own line, keeping git diffs clean', correct: true),
      QuizOption(text: 'They improve runtime performance', correct: false),
      QuizOption(text: 'They prevent null safety errors', correct: false),
    ]),
  ],
);
