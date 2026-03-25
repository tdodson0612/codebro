import '../../models/lesson.dart';
import '../../models/quiz.dart';

final dartLesson03 = Lesson(
  language: 'Dart',
  title: 'Your First Dart Program',
  content: '''
🎯 METAPHOR:
A Dart program is like a theater performance.
main() is the stage director who calls the shots —
everything begins and is orchestrated from there.
Functions are the actors, each with their own role.
Variables are the props on stage. Comments are the
stage directions in the script (invisible to the audience,
but vital for the crew). Every performance needs a
director — every Dart program needs a main().

📖 EXPLANATION:
Every Dart program starts at the main() function.
Dart's syntax is C-style: curly braces for blocks,
semicolons to end statements, and strict typing.
But it's also modern: type inference, string interpolation,
async/await, and null safety built in from the start.

─────────────────────────────────────
📐 DART PROGRAM ANATOMY
─────────────────────────────────────
// 1. Top-level imports
import 'dart:math';

// 2. Top-level variables (avoid if possible)
const appName = 'My App';

// 3. Top-level functions
void greet(String name) {
  print('Hello, \$name!');
}

// 4. The entry point — REQUIRED
void main() {
  greet('Dart');    // function call
}

─────────────────────────────────────
💬 COMMENTS
─────────────────────────────────────
// Single-line comment

/* Multi-line
   comment */

/// Documentation comment — shows in IDE hover
/// and dart doc output
/// Supports [markdown] and [CrossReferences]

─────────────────────────────────────
📝 STATEMENTS & EXPRESSIONS
─────────────────────────────────────
Statement:  complete instruction ending in ;
  print('hello');
  var x = 5;

Expression: produces a value
  42
  'hello'
  x + 1
  isReady ? 'yes' : 'no'

Dart programs are lists of statements.
Everything that produces a value is an expression.

─────────────────────────────────────
📤 PRINTING OUTPUT
─────────────────────────────────────
print('Hello');          → Hello
print(42);               → 42
print(3.14);             → 3.14
print(true);             → true
print([1, 2, 3]);        → [1, 2, 3]
print(null);             → null

stdout.write('no newline');  → dart:io
stderr.write('error!');      → dart:io

─────────────────────────────────────
🔤 STRING INTERPOLATION
─────────────────────────────────────
String name = 'Dart';
int version = 3;

print('Hello, \$name!');        → Hello, Dart!
print('Version \$version');     → Version 3
print('\${name.length} chars'); → 4 chars
print('\${3 + 4}');             → 7

Use \$variable for simple variables.
Use \${expression} for any expression.

─────────────────────────────────────
🔢 BASIC DATA
─────────────────────────────────────
int    → whole numbers        42, -7, 0
double → decimal numbers      3.14, -0.5
String → text                 'hello', "world"
bool   → true or false        true, false
null   → absence of value     null

💻 CODE:
// The complete anatomy of a Dart program

/// A simple greeting function.
/// [name] is the person to greet.
/// Returns a formatted greeting string.
String greet(String name) {
  return 'Hello, \$name! Welcome to Dart.';
}

/// Calculates the area of a rectangle.
double rectangleArea(double width, double height) {
  return width * height;
}

// Arrow function — same as rectangleArea but shorter
double circleArea(double radius) => 3.14159 * radius * radius;

// The entry point
void main() {
  // ── Variables ─────────────────
  String language = 'Dart';
  int year = 2023;
  double pi = 3.14159;
  bool isTyped = true;

  // ── Print statements ──────────
  print('Hello, World!');
  print(language);      // Dart
  print(year);          // 2023

  // ── String interpolation ──────
  print('Language: \$language');
  print('Version: Dart \${year - 2011 + 1}.0');
  print('Pi is approximately \${pi.toStringAsFixed(2)}');
  print('Is Dart typed? \$isTyped');

  // ── Calling functions ─────────
  String greeting = greet('Flutter Developer');
  print(greeting);

  double area = rectangleArea(10.0, 5.0);
  print('Rectangle area: \$area');    // 50.0

  print('Circle area: \${circleArea(7.0).toStringAsFixed(2)}');

  // ── Multi-line string ─────────
  String multiLine = """
  Dart features:
  - Sound null safety
  - Strong static types
  - Async/await
  - Compiles to native & JS
  """;
  print(multiLine);

  // ── String operations ─────────
  String word = 'Dart';
  print(word.toUpperCase());      // DART
  print(word.toLowerCase());      // dart
  print(word.length);             // 4
  print(word.contains('ar'));     // true
  print(word.replaceAll('a','@')); // D@rt

  // ── Type information ──────────
  print(language.runtimeType);    // String
  print(year.runtimeType);        // int
  print(pi.runtimeType);          // double

  // ── Basic arithmetic ──────────
  print(10 + 3);   // 13
  print(10 - 3);   // 7
  print(10 * 3);   // 30
  print(10 / 3);   // 3.3333...
  print(10 ~/ 3);  // 3   (integer division)
  print(10 % 3);   // 1   (modulo)
  print(2 << 3);   // 16  (bit shift left)
}

📝 KEY POINTS:
✅ Every Dart program must have a void main() function
✅ Statements end with semicolons ;
✅ String interpolation: '\$variable' or '\${expression}'
✅ Use triple quotes (3x single or 3x double) for multiline strings
✅ print() adds a newline; stdout.write() does not
✅ /// is a documentation comment — shows in IDEs
✅ .runtimeType gives the runtime type of any object
✅ ~/ is integer division (produces int, not double)
❌ Missing main() → "No 'main' method found" error
❌ Missing semicolons → compile error
❌ Don't confuse / (double division) with ~/ (int division)
''',
  quiz: [
    Quiz(question: 'What is required in every Dart program?', options: [
      QuizOption(text: 'An import statement', correct: false),
      QuizOption(text: 'A void main() function — the entry point', correct: true),
      QuizOption(text: 'At least one class definition', correct: false),
      QuizOption(text: 'A return statement', correct: false),
    ]),
    Quiz(question: 'What does "Dart \${2023 - 2011}" produce in a string?', options: [
      QuizOption(text: 'Dart \${2023 - 2011}', correct: false),
      QuizOption(text: 'Dart 12', correct: true),
      QuizOption(text: 'A SyntaxError', correct: false),
      QuizOption(text: 'Dart 2023 - 2011', correct: false),
    ]),
    Quiz(question: 'What does the ~/ operator do in Dart?', options: [
      QuizOption(text: 'Bitwise NOT followed by division', correct: false),
      QuizOption(text: 'Integer division — divides and truncates to an int', correct: true),
      QuizOption(text: 'Modulo (remainder) operation', correct: false),
      QuizOption(text: 'Floating-point division', correct: false),
    ]),
  ],
);