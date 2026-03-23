import '../../models/lesson.dart';
import '../../models/quiz.dart';

final dartLesson25 = Lesson(
  language: 'Dart',
  title: 'Packages & pubspec.yaml',
  content: '''
🎯 METAPHOR:
pub.dev is like Amazon for Dart code.
pubspec.yaml is your shopping list — you list what you need,
specify acceptable versions (like ordering size M or L but
not XS), and "dart pub get" is pressing the order button.
The packages arrive in your .dart_tool/package_config.json,
and pubspec.lock is your order confirmation with exact
versions. Semantic versioning (^1.2.3) is like saying
"give me version 1.2.3 or anything newer, but don't break
my project with version 2.0." The ^ means compatible updates,
not any wild new version.

📖 EXPLANATION:
pub.dev is Dart and Flutter's official package repository.
pubspec.yaml defines your project and its dependencies.
pub CLI manages downloading, upgrading, and publishing packages.

─────────────────────────────────────
📄 PUBSPEC.YAML ANATOMY
─────────────────────────────────────
name: my_app              # package name (snake_case)
description: My app       # human description
version: 1.0.0            # your app's version
homepage: https://...     # optional

environment:
  sdk: ">=3.0.0 <4.0.0"  # Dart SDK version range

dependencies:             # runtime dependencies
  http: ^1.1.0
  shared_preferences: ^2.2.0

dev_dependencies:         # only used during development
  test: ^1.24.0
  lint: ^2.1.0
  build_runner: ^2.4.0

flutter:                  # Flutter-specific section
  assets:
    - assets/images/
  fonts:
    - family: MyFont
      fonts:
        - asset: fonts/MyFont.ttf

─────────────────────────────────────
📦 VERSION CONSTRAINTS
─────────────────────────────────────
"1.2.3"      → exact version only
">=1.2.3"    → 1.2.3 or higher
"<2.0.0"     → below 2.0.0
">=1.2.0 <2.0.0" → range
"^1.2.3"     → >=1.2.3 <2.0.0  (compatible with 1.x)
              (most commonly used!)
"any"        → any version (avoid)

─────────────────────────────────────
🛠️  PUB CLI COMMANDS
─────────────────────────────────────
dart pub get             → install dependencies
dart pub upgrade         → upgrade to latest compatible
dart pub outdated        → see what has updates
dart pub add http         → add http to dependencies
dart pub add --dev lint   → add to dev_dependencies
dart pub remove http      → remove a package
dart pub publish         → publish to pub.dev
dart pub global activate  → install global CLI tool
dart pub cache clean     → clear local cache

─────────────────────────────────────
📋 PUBSPEC.LOCK
─────────────────────────────────────
Auto-generated, DO commit to version control.
Contains exact resolved versions for all dependencies.
Ensures every team member and CI build uses same versions.

─────────────────────────────────────
🌟 POPULAR PACKAGES
─────────────────────────────────────
HTTP & Networking:
  http            → basic HTTP client
  dio             → advanced HTTP (interceptors, etc.)
  web_socket_channel → WebSocket support

Data:
  json_annotation → JSON serialization annotation
  json_serializable → code generation for JSON
  freezed          → immutable model classes
  drift (moor)     → SQLite ORM
  hive             → fast NoSQL database
  shared_preferences → key-value storage

State Management (Flutter):
  provider        → InheritedWidget wrapper
  riverpod        → improved provider
  bloc            → BLoC pattern
  get_it          → service locator

Utilities:
  equatable       → value equality for classes
  intl            → internationalization, date formatting
  path            → file path manipulation
  rxdart          → ReactiveX streams
  collection      → additional collection utilities
  crypto          → cryptographic functions
  uuid            → UUID generation
  logger          → logging utilities

Code Generation:
  build_runner    → runs code generators
  source_gen      → toolkit for code generators

─────────────────────────────────────
📊 PUB SCORE FACTORS
─────────────────────────────────────
When choosing a package from pub.dev, check:
  Pub points  → documentation, analysis, platform support
  Popularity  → usage across Dart/Flutter ecosystem
  Likes       → community endorsement
  Maintenance → recent updates
  Publisher   → team.dart.dev = Google-verified

💻 CODE:
// ── PUBSPEC.YAML EXAMPLES ──────

// Basic Dart CLI app:
const dartAppPubspec = """
name: my_cli_app
description: A command-line application
version: 1.0.0

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  args: ^2.4.0          # CLI argument parsing
  path: ^1.8.0          # Path manipulation
  http: ^1.1.0          # HTTP requests
  intl: ^0.18.0         # Internationalization

dev_dependencies:
  test: ^1.24.0
  lints: ^3.0.0
""";

// Flutter app:
const flutterAppPubspec = """
name: my_flutter_app
description: A Flutter application
publish_to: 'none'     # Don't publish to pub.dev
version: 1.0.0+1       # version_name+build_number

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  
  # UI
  cached_network_image: ^3.3.0
  
  # State management
  flutter_riverpod: ^2.4.0
  
  # HTTP
  dio: ^5.3.0
  
  # Storage
  hive_flutter: ^1.1.0
  
  # Utilities
  freezed_annotation: ^2.4.0
  json_annotation: ^4.8.0
  intl: ^0.18.0
  equatable: ^2.0.5

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
  build_runner: ^2.4.0
  freezed: ^2.4.0
  json_serializable: ^6.7.0

flutter:
  uses-material-design: true
  
  assets:
    - assets/images/
    - assets/icons/
    
  fonts:
    - family: MyCustomFont
      fonts:
        - asset: fonts/MyCustomFont-Regular.ttf
        - asset: fonts/MyCustomFont-Bold.ttf
          weight: 700
""";

void main() {
  // ── USING INSTALLED PACKAGES ──
  // After: dart pub get

  // Using the 'http' package:
  // import 'package:http/http.dart' as http;
  // final response = await http.get(Uri.parse('https://api.example.com'));

  // Using 'intl' for date formatting:
  // import 'package:intl/intl.dart';
  // final formatter = DateFormat('MMM d, yyyy');
  // print(formatter.format(DateTime.now())); // Mar 15, 2024

  // Using 'path' package:
  // import 'package:path/path.dart' as path;
  // print(path.join('/home', 'user', 'docs', 'file.txt'));
  // → /home/user/docs/file.txt

  print('pubspec.yaml examples shown above');
  print('Run: dart pub get to install dependencies');
  print('Run: dart pub add http to add a package');
  print('Browse: https://pub.dev for available packages');
}

// ── ADDING A DEP STEP BY STEP ──
/*
1. Find the package on pub.dev
   → Search "http" at https://pub.dev

2. Check it:
   → Dart 3 compatible? ✅
   → pub points > 100? ✅
   → Maintained recently? ✅

3. Add to pubspec.yaml:
   dependencies:
     http: ^1.1.0

   Or run:
   dart pub add http

4. Run:
   dart pub get

5. Import in your code:
   import 'package:http/http.dart' as http;

6. Use it:
   final response = await http.get(Uri.parse('...'));
*/

// ── PATH DEPENDENCY (local package) ──
/*
# Reference a local package (for development):
dependencies:
  my_local_package:
    path: ../my_local_package

# Reference a git package:
dependencies:
  some_package:
    git:
      url: https://github.com/user/some_package.git
      ref: main   # branch, tag, or commit hash
*/

// ── OVERRIDE FOR TESTING ────────
/*
# Force specific version (breaks pub resolution for others):
dependency_overrides:
  some_package: 1.2.3

# Useful when:
# - Two packages require conflicting versions
# - Testing against unreleased version
# Use sparingly — can break things
*/

📝 KEY POINTS:
✅ pubspec.yaml is the single source of truth for your project's identity and deps
✅ ^1.2.3 means >=1.2.3 <2.0.0 — compatible patch and minor updates only
✅ Commit pubspec.lock to version control — ensures reproducible builds
✅ dart pub get downloads packages; dart pub upgrade upgrades to latest compatible
✅ dev_dependencies are only used during development, not in production builds
✅ pub.dev pub points, popularity, and maintenance tell you package quality
✅ Run dart pub outdated regularly to see what has new versions
❌ Don't use "any" as a version constraint — it causes unexpected breakage
❌ Don't manually edit pubspec.lock — let pub manage it
❌ Don't add packages you don't need — they increase build size and complexity
''',
  quiz: [
    Quiz(question: 'What does the version constraint "^1.2.3" mean?', options: [
      QuizOption(text: 'Exactly version 1.2.3', correct: false),
      QuizOption(text: '>=1.2.3 and <2.0.0 — compatible updates within major version', correct: true),
      QuizOption(text: 'Any version above 1.2.3', correct: false),
      QuizOption(text: 'Between version 1.2.3 and 1.2.9 only', correct: false),
    ]),
    Quiz(question: 'Should you commit pubspec.lock to version control?', options: [
      QuizOption(text: 'No — it is auto-generated and should be in .gitignore', correct: false),
      QuizOption(text: 'Yes — it records exact resolved versions ensuring reproducible builds', correct: true),
      QuizOption(text: 'Only for production apps, not libraries', correct: false),
      QuizOption(text: 'Only if you have more than 5 dependencies', correct: false),
    ]),
    Quiz(question: 'What is the difference between dependencies and dev_dependencies?', options: [
      QuizOption(text: 'There is no practical difference', correct: false),
      QuizOption(text: 'dependencies are shipped in the final app; dev_dependencies are only used during development and testing', correct: true),
      QuizOption(text: 'dev_dependencies are installed first', correct: false),
      QuizOption(text: 'dependencies are for Flutter; dev_dependencies are for Dart', correct: false),
    ]),
  ],
);
