import '../../models/lesson.dart';
import '../../models/quiz.dart';

final dartLesson01 = Lesson(
  language: 'Dart',
  title: 'What is Dart?',
  content: '''
🎯 METAPHOR:
Dart is like a purpose-built racing car.
Most general-purpose languages are designed to drive
everywhere — city streets, highways, off-road. Dart was
engineered for one race track: building fast, beautiful
apps that run on any screen. It has a turbocharged engine
(the JIT compiler for instant hot-reload during development),
a drag-racing mode (AOT compilation for blazing-fast
production apps), and it even runs in the pits (server-side).
It's opinionated, optimized, and built by Google to win.

📖 EXPLANATION:
Dart is a client-optimized programming language developed
by Google. It is the language behind Flutter — Google's UI
framework for building natively compiled apps across mobile,
web, desktop, and embedded from a single codebase.

─────────────────────────────────────
🕰️  A BRIEF HISTORY
─────────────────────────────────────
2011 — Dart announced at GOTO conference by Google
2013 — Dart 1.0 released
2018 — Dart 2.0: sound type system, major revamp
2020 — Dart 2.12: sound null safety added
2023 — Dart 3.0: records, patterns, sealed classes
Today — Dart powers Flutter, used by millions of devs

─────────────────────────────────────
⚡ TWO MODES OF EXECUTION
─────────────────────────────────────
JIT — Just-In-Time compilation (development)
  • Compiles code AS it runs
  • Enables hot reload (see changes instantly!)
  • Fast iteration, great for development

AOT — Ahead-Of-Time compilation (production)
  • Compiles to native machine code before running
  • Extremely fast startup, consistent performance
  • Used in production Flutter apps

─────────────────────────────────────
🌍 WHERE IS DART USED?
─────────────────────────────────────
📱 Mobile    → Flutter iOS & Android apps
🖥️  Desktop  → Flutter Windows, macOS, Linux
🌐 Web       → Flutter Web & Dart JS compilation
⚙️  Server   → Dart on the server (shelf package)
🔌 Embedded  → Flutter for embedded devices

─────────────────────────────────────
💡 WHAT MAKES DART SPECIAL?
─────────────────────────────────────
✅ Sound null safety  — nulls can't sneak in uninvited
✅ Strong static types — catch bugs before running
✅ Async-first        — futures & streams are first-class
✅ Garbage collected  — no manual memory management
✅ Tree shaking       — unused code removed at compile time
✅ Hot reload         — see changes instantly (dev mode)
✅ Single codebase    — one language for all platforms

─────────────────────────────────────
🆚 DART vs OTHER LANGUAGES
─────────────────────────────────────
vs JavaScript:  Strongly typed, AOT compiled, faster
vs Kotlin:      Runs on more platforms via Flutter
vs Swift:       Cross-platform, not Apple-only
vs Java:        More concise, modern null safety
vs Python:      Compiled, typed, much faster at runtime

─────────────────────────────────────
🛠️  THE DART ECOSYSTEM
─────────────────────────────────────
dart CLI         → run, compile, analyze, format
pub.dev          → the Dart package repository
pubspec.yaml     → project config (like package.json)
dart analyze     → static analysis (like a type checker)
dart format      → auto-formatter (like black/prettier)
dart test        → run tests
dart compile     → compile to native executable or JS
DartPad          → online Dart playground at dartpad.dev

💻 CODE:
// Your very first Dart program
void main() {
  print('Hello, Dart!');

  // Dart is strongly typed
  String name = 'Flutter Dev';
  int year = 2023;
  double version = 3.0;
  bool isAwesome = true;

  print('Welcome, \$name!');
  print('Dart \$version launched in \$year');
  print('Is Dart awesome? \$isAwesome');

  // var lets Dart infer the type
  var message = 'Type inference works!';
  print(message);

  // final = assign once, never reassign
  final String language = 'Dart';
  print('Language: \$language');

  // const = compile-time constant
  const double pi = 3.14159;
  print('Pi = \$pi');
}

// Functions are first-class citizens
String greet(String name) {
  return 'Hello, \$name!';
}

// Arrow function (single expression)
int square(int n) => n * n;

📝 KEY POINTS:
✅ Dart is Google's language powering Flutter on all platforms
✅ Two modes: JIT for development (hot reload), AOT for production (fast)
✅ Sound null safety — nulls must be explicit with ?
✅ Strongly and statically typed — types checked at compile time
✅ main() is the entry point — every Dart program starts here
✅ print() outputs to the console
✅ String interpolation with \$ — '\$variable' or '\${expression}'
❌ Dart is NOT JavaScript (though it can compile to it)
❌ Don't confuse final (runtime constant) with const (compile-time constant)
❌ Semicolons are required — unlike Python
''',
  quiz: [
    Quiz(question: 'What is Dart primarily designed for?', options: [
      QuizOption(text: 'Server-side scripting like Node.js', correct: false),
      QuizOption(text: 'Building natively compiled apps for mobile, web, and desktop via Flutter', correct: true),
      QuizOption(text: 'Data science and machine learning', correct: false),
      QuizOption(text: 'Systems programming like Rust or C++', correct: false),
    ]),
    Quiz(question: 'What is the difference between JIT and AOT compilation in Dart?', options: [
      QuizOption(text: 'JIT is for web, AOT is for mobile', correct: false),
      QuizOption(text: 'JIT compiles at runtime for hot reload during development; AOT compiles ahead of time for fast production apps', correct: true),
      QuizOption(text: 'They produce the same result — just different names', correct: false),
      QuizOption(text: 'JIT is faster in production; AOT is faster in development', correct: false),
    ]),
    Quiz(question: 'What does "sound null safety" mean in Dart?', options: [
      QuizOption(text: 'Variables are always null until assigned', correct: false),
      QuizOption(text: 'The type system guarantees that non-nullable variables can never contain null', correct: true),
      QuizOption(text: 'Dart automatically removes null values from collections', correct: false),
      QuizOption(text: 'Null safety is optional — you can turn it off', correct: false),
    ]),
  ],
);