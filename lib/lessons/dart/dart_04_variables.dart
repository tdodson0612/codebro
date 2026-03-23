import '../../models/lesson.dart';
import '../../models/quiz.dart';

final dartLesson04 = Lesson(
  language: 'Dart',
  title: 'Variables: var, final & const',
  content: '''
🎯 METAPHOR:
Think of Dart's three variable keywords as three types of signs.
var is a dry-erase whiteboard — you can write, erase, and
rewrite anytime. final is a laminated sign — printed once,
never changed, but made at runtime when you decide what it says.
const is a sign carved in stone at compile time — the engraver
decided the text before the building even opened, and it will
never change no matter what.

📖 EXPLANATION:
Dart has three keywords for declaring variables:
  var   → mutable, type inferred from assignment
  final → immutable after first assignment (runtime value)
  const → compile-time constant (must be known at compile time)

And explicit type annotations can be used with any of them.

─────────────────────────────────────
📐 DECLARATION SYNTAX
─────────────────────────────────────
var name = 'Alice';          // inferred as String
String name = 'Alice';       // explicit type annotation
final name = 'Alice';        // immutable, inferred type
final String name = 'Alice'; // immutable, explicit type
const pi = 3.14159;          // compile-time constant
const double pi = 3.14159;   // explicit type

─────────────────────────────────────
🔤 var — MUTABLE WITH TYPE INFERENCE
─────────────────────────────────────
var is NOT dynamic — the type is FIXED at assignment.
Once you assign a String, it's always a String.
You can reassign, but only with the same type.

var x = 42;      // x is int
x = 100;         // ✅ fine — still int
x = 'hello';     // ❌ Error! x is int, not String

─────────────────────────────────────
🔒 final — RUNTIME IMMUTABLE
─────────────────────────────────────
final can be set once. After that, it cannot change.
The value is determined at RUNTIME (not compile time).

final name = getName();    // ✅ runtime value OK
final list = [1, 2, 3];   // ✅ list reference is fixed
list.add(4);               // ✅ the LIST CONTENTS can change!
list = [5, 6];             // ❌ can't reassign the reference

─────────────────────────────────────
⚡ const — COMPILE-TIME CONSTANT
─────────────────────────────────────
const values must be known at COMPILE TIME.
They cannot depend on runtime values.
const objects are deeply immutable and canonicalized
(identical const objects share memory).

const pi = 3.14159;        // ✅ literal value
const area = pi * 4 * 4;   // ✅ computed from const
const name = getName();     // ❌ runtime function call!
const list = [1, 2, 3];    // ✅ const list (immutable!)
list.add(4);               // ❌ Error! const list is immutable

─────────────────────────────────────
🚫 LATE VARIABLES
─────────────────────────────────────
late declares a non-nullable variable that you promise
to initialize before using. If you use it before
initializing — runtime error.

late String description;     // declared but not initialized
description = compute();     // initialized later — OK
print(description);          // ✅ safe to use now

late String bad;
print(bad);                  // ❌ LateInitializationError!

─────────────────────────────────────
💡 WHEN TO USE WHICH?
─────────────────────────────────────
const → mathematical constants, string literals,
        config values known at compile time
        PREFER const whenever possible!

final → values that are set once but computed at runtime:
        DateTime.now(), user input, API responses

var   → mutable loop variables, local variables that change

Type annotation → makes code more readable for complex types,
                  required for class fields without initializers

─────────────────────────────────────
🌐 TOP-LEVEL VARIABLES
─────────────────────────────────────
Variables declared outside classes and functions
are top-level. They are lazily initialized.

String? globalName;   // nullable top-level
const version = '3.0'; // constant top-level

💻 CODE:
void main() {
  // ── var — mutable, type inferred ─
  var greeting = 'Hello';     // String
  var count = 0;              // int
  var price = 9.99;           // double
  var isReady = false;        // bool

  greeting = 'Hi';            // ✅ reassign same type
  count = count + 1;          // ✅ mutate
  // greeting = 42;           // ❌ type error

  print(greeting);   // Hi
  print(count);      // 1

  // ── Explicit type annotations ──
  String language = 'Dart';
  int year = 2023;
  double version = 3.0;
  bool isTyped = true;

  print('\$language \$version (\$year)');

  // ── final — immutable reference ─
  final now = DateTime.now();         // runtime value ✅
  final String appName = 'CodeBro';
  final List<int> scores = [90, 85, 92];

  // appName = 'Other';  // ❌ can't reassign
  scores.add(88);        // ✅ list content can change!
  print(scores);         // [90, 85, 92, 88]

  // ── const — compile-time constant ─
  const double pi = 3.14159265358979;
  const int maxItems = 100;
  const String appVersion = '1.0.0';

  // Const collections are truly immutable:
  const List<String> colors = ['red', 'green', 'blue'];
  // colors.add('yellow');  // ❌ Unsupported operation

  print('Pi = \$pi');
  print('Colors: \$colors');

  // ── const vs final difference ──
  // const: value known at compile time
  // final: value set at runtime, not changeable after

  final int randomNum = DateTime.now().millisecond;  // runtime OK
  // const int badConst = DateTime.now().millisecond; // ❌ not const!

  // ── LATE variables ─────────────
  late String expensiveResult;

  // ... do other work ...
  expensiveResult = _computeExpensiveOperation();
  print(expensiveResult);

  // late + final — lazy initialization
  late final String cachedValue = _computeOnce();
  print(cachedValue);  // computed now, cached forever

  // ── var with explicit type ──────
  var dynamic1 = 'hello';    // inferred as String
  String explicit1 = 'hello'; // same result, more explicit

  // ── Null-related (preview) ──────
  String? nullableName = null;    // ? makes it nullable
  nullableName = 'Alice';          // fine
  print(nullableName?.length);     // 5 (null-safe access)

  // ── Uninitialized (nullable only) ─
  String? lateInit;   // null by default (nullable)
  print(lateInit);    // null
  lateInit = 'now set';
  print(lateInit);    // now set

  // ── Type checking at runtime ────
  var x = 42;
  print(x is int);          // true
  print(x is String);       // false
  print(x.runtimeType);     // int
}

String _computeExpensiveOperation() => 'computed!';
String _computeOnce() => 'cached!';

// ── Top-level constants ─────────
const String kApiBase = 'https://api.example.com';
const int kMaxRetries = 3;
const double kGoldenRatio = 1.618033988749895;

// ── Top-level final (lazy init) ──
final startupTime = DateTime.now();  // initialized when first accessed

📝 KEY POINTS:
✅ var infers type at assignment — the type is then FIXED (not dynamic!)
✅ final = set once at runtime; const = set once at compile time
✅ Prefer const wherever possible — enables optimizations
✅ final lists/maps: the reference is fixed but contents can change
✅ const lists/maps: truly immutable — nothing can change
✅ late declares non-nullable variables that you'll initialize later
✅ Use ? after a type to make it nullable: String?
✅ Top-level variables in Dart are lazily initialized
❌ var is NOT dynamic — you can't change the type after assignment
❌ const can't hold runtime values (DateTime.now(), user input, etc.)
❌ late variables cause LateInitializationError if read before assigned
''',
  quiz: [
    Quiz(question: 'What is the difference between final and const in Dart?', options: [
      QuizOption(text: 'final is for numbers; const is for strings', correct: false),
      QuizOption(text: 'final is set once at runtime; const must be known at compile time', correct: true),
      QuizOption(text: 'const can be reassigned; final cannot', correct: false),
      QuizOption(text: 'They are identical — just style preferences', correct: false),
    ]),
    Quiz(question: 'Given: var x = 42; Can you then do x = "hello"?', options: [
      QuizOption(text: 'Yes — var is dynamic in Dart', correct: false),
      QuizOption(text: 'No — var infers the type as int, and it stays int', correct: true),
      QuizOption(text: 'Yes, but only if you cast it first', correct: false),
      QuizOption(text: 'Only if x was declared with dynamic', correct: false),
    ]),
    Quiz(question: 'What does late do in Dart?', options: [
      QuizOption(text: 'Makes a variable initialize to null automatically', correct: false),
      QuizOption(text: 'Declares a non-nullable variable that will be initialized before its first use', correct: true),
      QuizOption(text: 'Makes a variable initialize after a delay', correct: false),
      QuizOption(text: 'It is equivalent to final', correct: false),
    ]),
  ],
);
