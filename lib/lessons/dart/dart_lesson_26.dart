import '../../models/lesson.dart';
import '../../models/quiz.dart';

final dartLesson26 = Lesson(
  language: 'Dart',
  title: 'Typedefs & Function Types',
  content: '''
🎯 METAPHOR:
A typedef is like giving a nickname to a complex job title.
Instead of writing "Senior Full-Stack Software Engineer
specializing in distributed systems with 10 years experience"
every time you post a job ad, you write "SeniorEngineer."
The full description is still there — you've just created
a convenient alias. In Dart, typedef names function types
(and any type!), so you write Callback instead of
void Function(String message) everywhere it's needed.
Same type, cleaner code.

📖 EXPLANATION:
typedef creates a named alias for any type in Dart —
most commonly for function types. This improves readability,
enables reuse, and allows you to name complex type signatures.
Dart 2.13+ extended typedef to work with ANY type, not
just function types.

─────────────────────────────────────
📐 TYPEDEF FOR FUNCTION TYPES
─────────────────────────────────────
typedef Callback = void Function(String message);
typedef Predicate<T> = bool Function(T value);
typedef Transformer<T, R> = R Function(T input);
typedef JsonMap = Map<String, dynamic>;  // non-function!

─────────────────────────────────────
🔑 OLD vs NEW SYNTAX
─────────────────────────────────────
// Old (Dart 1/2 style — only for function types):
typedef bool Predicate(int n);

// New (Dart 2+, preferred — any type):
typedef Predicate = bool Function(int n);
typedef Predicate<T> = bool Function(T n);  // generic!

─────────────────────────────────────
🎯 NON-FUNCTION TYPEDEFS (Dart 2.13+)
─────────────────────────────────────
typedef JsonMap = Map<String, dynamic>;
typedef StringList = List<String>;
typedef Point = ({double x, double y});   // record type!

// Generic:
typedef Nullable<T> = T?;
typedef ListOf<T> = List<T>;
typedef ListPair<T> = (List<T>, List<T>);

─────────────────────────────────────
📋 WHERE TYPEDEFS SHINE
─────────────────────────────────────
1. Named callback types in APIs
2. Complex Map/List types used everywhere
3. Generic type aliases for cleaner code
4. Platform-specific type definitions
5. Documenting intent of a function signature

─────────────────────────────────────
🔒 TYPEDEF vs INLINE
─────────────────────────────────────
Without typedef:
  void listen(void Function(String, int, bool) handler) { ... }

With typedef:
  typedef EventHandler = void Function(String type, int code, bool flag);
  void listen(EventHandler handler) { ... }

The second is MUCH clearer — the type has a name and intent.

💻 CODE:
// ── FUNCTION TYPE TYPEDEFS ──────

// Simple callback
typedef VoidCallback = void Function();
typedef Callback = void Function(String message);
typedef ErrorCallback = void Function(Object error, StackTrace stack);

// With generics
typedef Predicate<T> = bool Function(T value);
typedef Transformer<T, R> = R Function(T input);
typedef Comparator<T> = int Function(T a, T b);
typedef Producer<T> = T Function();
typedef Consumer<T> = void Function(T value);

// More complex
typedef JsonParser<T> = T Function(Map<String, dynamic> json);
typedef AsyncTransformer<T, R> = Future<R> Function(T input);

// ── NON-FUNCTION TYPEDEFS ───────
typedef JsonMap = Map<String, dynamic>;
typedef StringList = List<String>;
typedef IntPair = (int, int);  // record type
typedef NamedPoint = ({double x, double y});

// Generic non-function
typedef Nullable<T> = T?;
typedef Pair<A, B> = (A, B);
typedef MapOf<K, V> = Map<K, V>;

void main() {
  // ── USING FUNCTION TYPEDEFS ───

  // Without typedef (hard to read):
  void listenOld(void Function(String type, int code, bool urgent) h) {
    h('click', 200, false);
  }

  // With typedef (clean!):
  typedef EventHandler = void Function(String type, int code, bool urgent);

  void listen(EventHandler handler) {
    handler('click', 200, false);
  }

  listen((type, code, urgent) {
    print('Event: \$type (\$code)\${urgent ? ' URGENT' : ''}');
  });

  // ── PREDICATE TYPEDEF ─────────
  Predicate<int> isEven = (n) => n % 2 == 0;
  Predicate<String> isLong = (s) => s.length > 10;

  print(isEven(4));           // true
  print(isLong('hello'));     // false

  List<int> nums = [1, 2, 3, 4, 5, 6];
  List<int> evens = nums.where(isEven).toList();
  print(evens);   // [2, 4, 6]

  // ── TRANSFORMER TYPEDEF ───────
  Transformer<String, int> stringToInt = int.parse;
  Transformer<int, String> intToString = (n) => n.toString();
  Transformer<String, String> shout = (s) => s.toUpperCase() + '!';

  List<String> strings = ['1', '2', '3'];
  List<int> ints = strings.map(stringToInt).toList();
  print(ints);   // [1, 2, 3]

  // ── COMPARATOR TYPEDEF ────────
  Comparator<String> byLength = (a, b) => a.length.compareTo(b.length);
  Comparator<String> alphabetical = (a, b) => a.compareTo(b);

  List<String> words = ['banana', 'apple', 'kiwi', 'cherry'];
  words.sort(byLength);
  print(words);   // [kiwi, apple, banana, cherry]

  words.sort(alphabetical);
  print(words);   // [apple, banana, cherry, kiwi]

  // ── JSON TYPEDEF ──────────────
  JsonMap userJson = {
    'id': 1,
    'name': 'Alice',
    'email': 'alice@example.com',
    'age': 30,
  };

  JsonParser<User> parseUser = User.fromJson;
  User user = parseUser(userJson);
  print(user.name);   // Alice

  // ── CALLBACK PATTERN ──────────
  final button = Button(label: 'Click Me');
  button.onPressed = () => print('Button pressed!');
  button.onLongPress = () => print('Long pressed!');
  button.simulatePress();     // Button pressed!
  button.simulateLongPress(); // Long pressed!

  // ── HIGHER-ORDER FUNCTIONS ────
  List<int> numbers = [3, 1, 4, 1, 5, 9, 2, 6];

  // applyFilter takes a Predicate<int>
  print(applyFilter(numbers, isEven));       // [4, 2, 6]
  print(applyFilter(numbers, (n) => n > 4)); // [5, 9, 6]

  // transform takes Transformer<int, String>
  print(transform(numbers, intToString));  // ['3','1','4',...]

  // ── TYPEDEF WITH RECORDS ──────
  NamedPoint origin = (x: 0.0, y: 0.0);
  NamedPoint p = (x: 3.0, y: 4.0);

  double distance = computeDistance(origin, p);
  print('Distance: \$distance');  // 5.0

  // ── TYPEDEF FOR PLATFORM CODE ─
  // Common pattern: define a type alias that resolves differently
  // on different platforms via conditional imports:
  //
  // platform_types.dart:
  //   typedef PlatformFile = io.File;
  //
  // platform_types_web.dart:
  //   typedef PlatformFile = html.File;
  //
  // In your code: just use PlatformFile everywhere!

  print('Typedefs make Dart code much more readable!');
}

// ── USER MODEL WITH JSON ────────
class User {
  final int id;
  final String name;
  final String email;
  final int age;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
  });

  factory User.fromJson(JsonMap json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      age: json['age'] as int,
    );
  }

  JsonMap toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'age': age,
  };
}

// ── BUTTON CLASS WITH CALLBACKS ─
typedef VoidCallback = void Function();

class Button {
  final String label;
  VoidCallback? onPressed;
  VoidCallback? onLongPress;

  Button({required this.label});

  void simulatePress() => onPressed?.call();
  void simulateLongPress() => onLongPress?.call();
}

// ── HIGHER-ORDER FUNCTIONS ──────
List<T> applyFilter<T>(List<T> list, Predicate<T> predicate) {
  return list.where(predicate).toList();
}

List<R> transform<T, R>(List<T> list, Transformer<T, R> transformer) {
  return list.map(transformer).toList();
}

// ── RECORD TYPEDEF ─────────────
typedef NamedPoint = ({double x, double y});

double computeDistance(NamedPoint a, NamedPoint b) {
  final dx = a.x - b.x;
  final dy = a.y - b.y;
  return (dx * dx + dy * dy).sqrt();
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
✅ typedef creates named aliases for function types — improves readability enormously
✅ Generic typedefs: typedef Predicate<T> = bool Function(T value)
✅ Non-function typedefs (Dart 2.13+): typedef JsonMap = Map<String, dynamic>
✅ typedef for records: typedef Point = ({double x, double y})
✅ Function type aliases make APIs self-documenting
✅ Use typedef for common function signatures used in multiple places
✅ typedef is an alias, not a new type — same type, different name
✅ Old typedef syntax (typedef bool Pred(int n)) still works but is outdated
❌ typedef doesn't create a new type — it's purely an alias for readability
❌ Don't overuse typedef for every type — only where it adds clarity
❌ Typedef doesn't add runtime behavior — it's purely a compile-time concept
''',
  quiz: [
    Quiz(question: 'What does typedef Predicate<T> = bool Function(T value) create?', options: [
      QuizOption(text: 'A new class that wraps a bool function', correct: false),
      QuizOption(text: 'A named alias for the type "a function taking T and returning bool"', correct: true),
      QuizOption(text: 'An abstract class with a single method', correct: false),
      QuizOption(text: 'A generic constraint for type T', correct: false),
    ]),
    Quiz(question: 'Is typedef in Dart limited to function types?', options: [
      QuizOption(text: 'Yes — typedef only works for function types', correct: false),
      QuizOption(text: 'No — since Dart 2.13, typedef works for any type including Map, List, Records, etc.', correct: true),
      QuizOption(text: 'Only in Dart 3+', correct: false),
      QuizOption(text: 'Only for types that contain generics', correct: false),
    ]),
    Quiz(question: 'Does typedef create a new distinct type in Dart?', options: [
      QuizOption(text: 'Yes — it creates a completely new type with its own identity', correct: false),
      QuizOption(text: 'No — typedef is purely an alias; the underlying type is identical', correct: true),
      QuizOption(text: 'Only for function types, not other types', correct: false),
      QuizOption(text: 'Yes, but only when the typedef is generic', correct: false),
    ]),
  ],
);
