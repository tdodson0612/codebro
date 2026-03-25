import '../../models/lesson.dart';
import '../../models/quiz.dart';

final dartLesson02 = Lesson(
  language: 'Dart',
  title: 'Installing Dart & the SDK',
  content: '''
🎯 METAPHOR:
Installing the Dart SDK is like setting up a workshop.
The SDK is your complete toolset: the compiler (your drill press),
the formatter (your sander), the analyzer (your level), and the
test runner (your quality inspector). You need all of them, and
they all come in one box. DartPad is like a pop-up workshop
in your browser — no installation needed, great for learning.

📖 EXPLANATION:
The Dart SDK contains everything needed to write, run,
analyze, and compile Dart programs. If you install Flutter,
the Dart SDK is included automatically.

─────────────────────────────────────
📦 INSTALLATION OPTIONS
─────────────────────────────────────

Option 1: Install Flutter (RECOMMENDED)
  Flutter includes Dart — install one, get both.
  https://flutter.dev/docs/get-started/install

Option 2: Install Dart SDK alone
  https://dart.dev/get-dart

─────────────────────────────────────
🖥️  PLATFORM-SPECIFIC
─────────────────────────────────────

macOS (with Homebrew):
  brew tap dart-lang/dart
  brew install dart

Windows (with Chocolatey):
  choco install dart-sdk

Linux (Debian/Ubuntu):
  sudo apt-get update
  sudo apt-get install dart

Or download directly from dart.dev/get-dart

─────────────────────────────────────
✅ VERIFY INSTALLATION
─────────────────────────────────────
After install, in your terminal:
  dart --version
  → Dart SDK version: 3.x.x

  dart
  → Opens interactive REPL (Read-Eval-Print Loop)

─────────────────────────────────────
🛠️  KEY DART CLI COMMANDS
─────────────────────────────────────
dart run file.dart          → run a Dart file
dart compile exe file.dart  → compile to native binary
dart compile js file.dart   → compile to JavaScript
dart analyze                → check for errors/warnings
dart format .               → auto-format all .dart files
dart test                   → run tests
dart pub get                → install packages from pubspec.yaml
dart pub add package_name   → add a package
dart create my_project      → create a new project
dart doc                    → generate API documentation

─────────────────────────────────────
📁 DART PROJECT STRUCTURE
─────────────────────────────────────
my_project/
├── bin/
│   └── main.dart       ← entry point for CLI apps
├── lib/
│   └── my_project.dart ← your library code
├── test/
│   └── my_project_test.dart
├── pubspec.yaml        ← project manifest
├── pubspec.lock        ← locked dependency versions
├── analysis_options.yaml → linter rules
└── .dart_tool/         → generated files (don't commit)

─────────────────────────────────────
📄 PUBSPEC.YAML
─────────────────────────────────────
The pubspec.yaml is Dart's project manifest
(like package.json for Node or pyproject.toml for Python).

name: my_app
description: A sample Dart application.
version: 1.0.0
environment:
  sdk: ">=3.0.0 <4.0.0"

dependencies:
  http: ^1.0.0
  intl: ^0.18.0

dev_dependencies:
  test: ^1.24.0
  lints: ^2.0.0

─────────────────────────────────────
🌐 DARTPAD — NO INSTALL NEEDED
─────────────────────────────────────
Try Dart instantly in your browser:
  https://dartpad.dev

DartPad supports:
  • Pure Dart code
  • Flutter UI previews
  • Sharing code via URLs
  • Running code examples from dart.dev

─────────────────────────────────────
📝 RECOMMENDED IDE SETUP
─────────────────────────────────────
VS Code:
  Extensions: "Dart" + "Flutter" by the Dart/Flutter team
  → Syntax highlighting, auto-complete, hot reload button

IntelliJ / Android Studio:
  Plugin: "Dart" by JetBrains
  → Full IDE support, Flutter run configs

Both IDEs provide:
  → dart analyze integration (red squiggles!)
  → dart format on save
  → Pub commands from the UI
  → Debugger with breakpoints

💻 CODE:
// Create a new Dart project from terminal:
// dart create hello_dart
// cd hello_dart
// dart run

// The generated bin/hello_dart.dart:
void main(List<String> arguments) {
  print('Hello, Dart SDK!');

  // Access command-line arguments
  if (arguments.isNotEmpty) {
    print('Arguments: \${arguments.join(', ')}');
  }

  // Check Dart version at runtime
  print('Platform.version would show SDK version');
}

// Minimal pubspec.yaml for a Dart CLI app:
/*
name: hello_dart
description: My first Dart app
version: 1.0.0
environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  # add packages here

dev_dependencies:
  lints: ^2.0.0  # recommended lint rules
*/

// analysis_options.yaml — enable lint rules:
/*
include: package:lints/recommended.yaml

analyzer:
  errors:
    missing_required_param: error
    missing_return: error
*/

// Run with: dart run bin/hello_dart.dart name1 name2

📝 KEY POINTS:
✅ Installing Flutter automatically installs the Dart SDK
✅ dart run file.dart — run any Dart file directly
✅ dart format — always auto-format before committing
✅ dart analyze — catch type errors and lint warnings
✅ pubspec.yaml is the project manifest — like package.json
✅ DartPad (dartpad.dev) lets you try Dart instantly in a browser
✅ dart pub get installs all packages listed in pubspec.yaml
❌ Don't manually edit pubspec.lock — it's auto-generated
❌ Don't commit the .dart_tool/ directory (add to .gitignore)
❌ Dart is NOT JavaScript — dart compile js produces JS from Dart source
''',
  quiz: [
    Quiz(question: 'What is the quickest way to try Dart without installing anything?', options: [
      QuizOption(text: 'Download the SDK from dart.dev', correct: false),
      QuizOption(text: 'Use DartPad at dartpad.dev — a browser-based Dart editor', correct: true),
      QuizOption(text: 'Install Node.js and run dart via npm', correct: false),
      QuizOption(text: 'Open terminal and type "dart"', correct: false),
    ]),
    Quiz(question: 'What command installs packages listed in pubspec.yaml?', options: [
      QuizOption(text: 'dart install', correct: false),
      QuizOption(text: 'dart pub get', correct: true),
      QuizOption(text: 'pub install', correct: false),
      QuizOption(text: 'dart packages install', correct: false),
    ]),
    Quiz(question: 'What does pubspec.yaml contain?', options: [
      QuizOption(text: 'The compiled Dart bytecode', correct: false),
      QuizOption(text: 'Project name, version, SDK constraints, and dependencies', correct: true),
      QuizOption(text: 'Only the list of Dart source files', correct: false),
      QuizOption(text: 'Generated lock file for reproducible builds', correct: false),
    ]),
  ],
);