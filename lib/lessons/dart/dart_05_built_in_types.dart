import '../../models/lesson.dart';
import '../../models/quiz.dart';

final dartLesson05 = Lesson(
  language: 'Dart',
  title: 'Built-in Types',
  content: '''
🎯 METAPHOR:
Dart's type system is like a well-organized toolbox.
Every tool (type) has a precise job. int is your whole-number
wrench. double is your precision measuring tape. String is
your label maker. bool is your on/off switch. num is a
universal adapter that works with both wrenches and tape.
Object is the toolbox itself — everything fits inside it.
dynamic is duct tape — holds anything, but gives up all
the precision guarantees of the other tools.

📖 EXPLANATION:
Dart's built-in types form the foundation of everything.
Unlike some languages, ALL Dart types — even int — are
objects with methods. There are no "primitive" types.

─────────────────────────────────────
🔢 NUMBERS
─────────────────────────────────────
int     → whole numbers: 42, -7, 0
           Dart integers are arbitrary precision (no overflow!)
           On native: 64-bit. On web: JS number limits apply.

double  → floating-point: 3.14, -0.5, 1.0e8
           IEEE 754 double precision (same as most languages)
           Always has a decimal point in the literal or .0

num     → supertype of int AND double
           Use when you want to accept either type:
           num result = isInt ? 42 : 3.14;

─────────────────────────────────────
📝 STRINGS
─────────────────────────────────────
String  → sequence of UTF-16 code units
          'Hello'  or  "Hello"  (both identical)
          \'''Multi
             line\'''   (triple quotes)
          r'Raw \$string \n'  (raw — no escaping)

─────────────────────────────────────
✅ BOOLEANS
─────────────────────────────────────
bool    → true or false (ONLY true values)
          Unlike JavaScript: 0, "", null are NOT false!
          if (1) {}      ❌ compile error in Dart
          if (true) {}   ✅

─────────────────────────────────────
📋 LISTS
─────────────────────────────────────
List<T> → ordered, indexed collection
          var names = <String>['Alice', 'Bob'];
          var nums = [1, 2, 3];       // inferred List<int>
          (Covered in detail in the Lists lesson)

─────────────────────────────────────
🗂️  MAPS
─────────────────────────────────────
Map<K,V> → key-value pairs
           var ages = {'Alice': 30, 'Bob': 25};
           (Covered in detail in the Collections lesson)

─────────────────────────────────────
🎯 SYMBOLS
─────────────────────────────────────
Symbol  → an operator or identifier in Dart
          #mySymbol, const Symbol('name')
          Used in reflection (dart:mirrors) and
          as identifier-safe keys

─────────────────────────────────────
🔝 TYPE HIERARCHY
─────────────────────────────────────
Object    ← the root of all non-null types
  ├── int
  ├── double
  ├── String
  ├── bool
  ├── List<T>
  ├── Map<K,V>
  ├── Set<T>
  ├── Function
  └── ... (everything else)

Object?   ← adds null to the hierarchy
  ├── Object (all above)
  └── Null (the type of null itself)

Never     ← a type that can never have a value
            Used for functions that always throw

dynamic   ← opts OUT of type checking entirely
            Like Object? but disables static analysis

─────────────────────────────────────
🔄 TYPE CONVERSION
─────────────────────────────────────
int → String:    42.toString()         → '42'
double → String: 3.14.toString()       → '3.14'
                 3.14.toStringAsFixed(1) → '3.1'
String → int:    int.parse('42')       → 42
String → double: double.parse('3.14') → 3.14
int → double:    42.toDouble()         → 42.0
double → int:    3.7.toInt()           → 3  (truncates!)
                 3.7.round()           → 4
                 3.7.floor()           → 3
                 3.7.ceil()            → 4
Safe parse:      int.tryParse('bad')   → null (not exception)

─────────────────────────────────────
🧩 RUNES & GRAPHEME CLUSTERS
─────────────────────────────────────
Dart String is UTF-16. Some characters (emoji, CJK)
need TWO code units (surrogate pairs).

'Hello'.length      → 5         (code units)
'Hello 😀'.length  → 8         (NOT 7! emoji = 2 units)
'Hello 😀'.runes.length → 7   (Unicode code points)

For user-visible characters, use package:characters.

💻 CODE:
void main() {
  // ── int ──────────────────────────────────────────
  int apples = 5;
  int negative = -42;
  int big = 1_000_000_000;   // underscores for readability
  int hex = 0xFF;             // 255
  int binary = 0b1010;        // 10

  print('Apples: \$apples');
  print('Hex 0xFF = \$hex');
  print('Binary 0b1010 = \$binary');

  // int methods
  print(42.isEven);        // true
  print(7.isOdd);          // true
  print((-5).abs());       // 5
  print(2.pow(10));        // 1024 — wait, int has no pow!
  // Use dart:math for pow:
  // import 'dart:math'; print(pow(2, 10));
  print(255.toRadixString(16));  // 'ff'
  print(255.toRadixString(2));   // '11111111'

  // ── double ───────────────────────────────────────
  double pi = 3.14159;
  double e = 2.71828;
  double tiny = 1.5e-10;     // scientific notation
  double huge = 1.5e10;

  print('Pi: \$pi, e: \$e');
  print('Tiny: \$tiny, Huge: \$huge');

  // double methods
  print(3.7.floor());        // 3
  print(3.7.ceil());         // 4
  print(3.7.round());        // 4
  print(3.14159.toStringAsFixed(2));  // '3.14'
  print(double.infinity);    // Infinity
  print(double.nan);         // NaN
  print(double.nan.isNaN);   // true

  // ── num — works with both ─────────────────────────
  num x = 42;          // could be int
  num y = 3.14;        // could be double
  num sum = x + y;
  print('Sum: \$sum');

  // ── bool ─────────────────────────────────────────
  bool isRaining = false;
  bool hasUmbrella = true;

  print('Take umbrella: \${!isRaining || hasUmbrella}');

  // Dart bool is STRICT — no truthy/falsy conversions
  // if (1) {}     ← COMPILE ERROR in Dart
  // if ("yes") {} ← COMPILE ERROR in Dart
  // Only true boolean values in conditions

  // ── String ───────────────────────────────────────
  String single = 'Hello, World!';
  String double_ = "Also works";
  String multiLine = """
Line one
Line two
Line three""";
  String raw = r'No \n escape here: \$variable';

  print(single);
  print(multiLine);
  print(raw);

  // String is immutable but has many methods
  print('hello'.toUpperCase());   // HELLO
  print('  spaces  '.trim());     // 'spaces'
  print('abc'.contains('b'));     // true

  // ── Type checking ─────────────────────────────────
  var values = [42, 3.14, 'hello', true, null];
  for (var v in values) {
    if (v is int)    print('\$v is int');
    if (v is double) print('\$v is double');
    if (v is String) print('\$v is String');
    if (v is bool)   print('\$v is bool');
    if (v == null)   print('null!');
  }

  // ── Type conversion ────────────────────────────────
  // String → Number
  int parsed = int.parse('42');
  double parsedD = double.parse('3.14');
  int? safe = int.tryParse('not a number');  // returns null

  print('Parsed: \$parsed, Safe: \$safe');

  // Number → String
  String s1 = 42.toString();
  String s2 = 3.14159.toStringAsFixed(2);

  print('Strings: \$s1, \$s2');

  // int ↔ double
  double d = 42.toDouble();
  int i = 3.7.toInt();     // truncates to 3
  int r = 3.7.round();     // rounds to 4

  print('Double: \$d, Int: \$i, Round: \$r');

  // ── Object and dynamic ────────────────────────────
  Object obj = 'Hello';   // any non-null value
  obj = 42;               // reassign to different type ✅
  // obj.toUpperCase();   // ❌ Object has no toUpperCase

  dynamic dyn = 'Hello';  // like Object? but no type checking
  dyn = 42;               // ✅
  // dyn.nonExistentMethod(); // no compile error, but runtime error

  // ── Symbol ───────────────────────────────────────
  Symbol sym = #myIdentifier;
  print(sym);             // Symbol("myIdentifier")

  // ── Null ─────────────────────────────────────────
  String? nullable = null;
  print(nullable);        // null
  print(nullable.runtimeType);  // Null
}

📝 KEY POINTS:
✅ ALL Dart types are objects — even int has methods like .isEven, .toString()
✅ num is the supertype of both int and double — use for "either type"
✅ Dart bool is STRICT — no truthy/falsy, only true/false in conditions
✅ int.tryParse() returns null on failure; int.parse() throws an exception
✅ double has .floor(), .ceil(), .round(), .toStringAsFixed()
✅ Object is the root non-null type; Object? includes null; dynamic bypasses checking
✅ String length in Dart counts UTF-16 code units — emoji take 2 units!
❌ 0, "", null are NOT falsy in Dart — using them in if() is a compile error
❌ double → int with .toInt() TRUNCATES (doesn't round) — use .round() if needed
❌ dynamic should be avoided — it disables all type safety
''',
  quiz: [
    Quiz(question: 'Why does \'Hello 😀\'.length return 8 instead of 7?', options: [
      QuizOption(text: 'Dart counts the space character differently', correct: false),
      QuizOption(text: 'Dart strings are UTF-16; the emoji requires two code units', correct: true),
      QuizOption(text: 'The exclamation mark at the end adds an extra unit', correct: false),
      QuizOption(text: 'This is a bug in Dart', correct: false),
    ]),
    Quiz(question: 'What is the difference between int.parse() and int.tryParse()?', options: [
      QuizOption(text: 'parse() is faster; tryParse() is more accurate', correct: false),
      QuizOption(text: 'parse() throws on bad input; tryParse() returns null on bad input', correct: true),
      QuizOption(text: 'tryParse() converts doubles too; parse() only handles integers', correct: false),
      QuizOption(text: 'They are identical', correct: false),
    ]),
    Quiz(question: 'What is num in Dart?', options: [
      QuizOption(text: 'A number formatting utility', correct: false),
      QuizOption(text: 'The supertype of both int and double', correct: true),
      QuizOption(text: 'An alias for dynamic that only accepts numbers', correct: false),
      QuizOption(text: 'A 32-bit integer type', correct: false),
    ]),
  ],
);
