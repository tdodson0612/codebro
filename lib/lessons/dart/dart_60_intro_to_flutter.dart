import '../../models/lesson.dart';
import '../../models/quiz.dart';

final dartLesson60 = Lesson(
  language: 'Dart',
  title: 'Intro to Flutter: Where Dart Leads',
  content: '''
🎯 WHAT IS FLUTTER?
Flutter is the destination that Dart was built for.
Everything you learned — null safety, async/await, generics,
sealed classes, records, streams — comes alive in Flutter.
Flutter is Google's UI toolkit for building beautiful,
natively compiled applications for mobile, web, desktop,
and embedded systems from a single Dart codebase.

Not "compiled to native UI components" — Flutter draws
EVERY pixel itself using the Skia/Impeller rendering engine.
This is why Flutter apps look identical on iOS, Android,
and web — and why they can achieve buttery 60/120fps
animations without compromise.

─────────────────────────────────────
💡 FLUTTER IN ONE SENTENCE
─────────────────────────────────────
Flutter is a Dart-powered UI framework that renders
every pixel itself, giving you one codebase, one language,
and pixel-perfect UI across every platform.

─────────────────────────────────────
🎯 PLATFORMS
─────────────────────────────────────
📱 iOS & Android     → via Flutter mobile
🌐 Web               → via dart compile js / WASM
🖥️  Windows           → native Win32 app
🍎 macOS             → native macOS app
🐧 Linux             → native Linux app
📺 Embedded/TV       → Samsung TV, LG WebOS, etc.

One codebase → six platforms.

─────────────────────────────────────
🏗️  CORE CONCEPTS
─────────────────────────────────────
Widget:        Everything is a widget. Text is a widget.
               A button is a widget. The whole screen is a widget.

Widget Tree:   Widgets nest inside widgets. This tree IS your UI.

State:         What changes over time. Widget rebuilds when state changes.

BuildContext:  Your position in the widget tree — used to find
               ancestors, themes, navigation, etc.

Hot Reload:    Change code → see changes INSTANTLY without restart.
               Keeps app state. Revolutionary for productivity.

─────────────────────────────────────
📦 STATELESS vs STATEFUL WIDGETS
─────────────────────────────────────
StatelessWidget:
  → No mutable state
  → Builds once from properties
  → Rebuilt when parent rebuilds with different props
  → Simple, pure, fast

StatefulWidget:
  → Has mutable State object
  → Calls setState(() { ... }) to trigger rebuild
  → State persists across rebuilds
  → Use for UI that changes (counters, forms, animations)

─────────────────────────────────────
🔧 THE WIDGET CATALOGUE
─────────────────────────────────────
Layout:    Column, Row, Stack, Flex, Wrap, GridView, ListView
Display:   Text, Image, Icon, Container, Card, Chip
Input:     TextField, ElevatedButton, Checkbox, Slider, Switch
Navigation:Navigator, AppBar, Drawer, BottomNavigationBar
Styling:   Theme, TextStyle, BoxDecoration, Color
Async:     FutureBuilder, StreamBuilder
Animation: AnimatedWidget, AnimationController, Hero

─────────────────────────────────────
🔄 STATE MANAGEMENT OPTIONS
─────────────────────────────────────
setState           → built-in, simple, for local state
Provider           → simple DI wrapper for InheritedWidget
Riverpod           → modern, type-safe, composable
BLoC               → event-driven, great for complex apps
GetX               → all-in-one, opinionated
MobX               → reactive, code-gen based

─────────────────────────────────────
📁 FLUTTER PROJECT STRUCTURE
─────────────────────────────────────
my_flutter_app/
├── lib/
│   ├── main.dart          ← entry point
│   ├── app.dart           ← MyApp widget
│   ├── screens/           ← full-screen widgets
│   ├── widgets/           ← reusable component widgets
│   ├── models/            ← data classes
│   ├── services/          ← API, database
│   └── utils/             ← helpers
├── assets/                ← images, fonts, JSON
├── test/                  ← widget/unit/integration tests
├── android/               ← Android platform code
├── ios/                   ← iOS platform code
├── web/                   ← web platform code
└── pubspec.yaml

─────────────────────────────────────
🚀 GET STARTED IN 5 STEPS
─────────────────────────────────────
1. Install Flutter: flutter.dev/docs/get-started/install
2. flutter create my_app
3. cd my_app
4. flutter run
5. Open lib/main.dart and start editing!

─────────────────────────────────────
📖 WHERE TO LEARN
─────────────────────────────────────
Official:
  flutter.dev                    → documentation
  flutter.dev/docs/cookbook      → recipes for common tasks
  codelabs.developers.google.com → hands-on tutorials
  youtube.com/@flutterdev        → Flutter team's channel

Courses:
  "Flutter & Dart - The Complete Guide" (Udemy - Maximilian S.)
  "The Complete Flutter Development Bootcamp" (Angela Yu)
  Fireship.io Flutter course
  Flutter Mapp YouTube channel
  Reso Coder YouTube channel

Community:
  flutter.dev/community
  r/FlutterDev
  Flutter Discord
  FlutterCommunity GitHub org

Books:
  "Flutter in Action" (Manning)
  "Beginning Flutter" (Apress)
  "Flutter for Beginners" (Packt)

─────────────────────────────────────
🎓 YOUR DART KNOWLEDGE PREPARES YOU
─────────────────────────────────────
Everything you learned in this course directly applies:

null safety    → widget props, model fields
async/await    → API calls, FutureBuilder
streams        → StreamBuilder, real-time data
sealed classes → UI state (loading/success/error)
records        → return multiple values from functions
generics       → typed repositories, Result<T, E>
extension types → type-safe IDs and value objects
mixins         → reusable widget behaviors
isolates       → background processing
dart:convert   → JSON serialization
dart:io        → file storage
dart:typed_data → image manipulation

💻 CODE:
// ── YOUR FIRST FLUTTER APP ────────

String flutterQuickstart = '''
// lib/main.dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Flutter App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CounterScreen(),
    );
  }
}

class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int _count = 0;

  void _increment() {
    setState(() {
      _count++;   // triggers rebuild!
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Counter'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You have pushed the button:'),
            Text(
              '\$_count',
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _increment,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
''';

// ── APPLYING YOUR DART KNOWLEDGE ──

String dartToFlutter = '''
// Null safety in Flutter models:
class User {
  final String id;           // always present
  final String name;         // always present
  final String? email;       // optional
  final DateTime createdAt;  // always present

  const User({required this.id, required this.name,
    this.email, required this.createdAt});
}

// Async/await for API calls:
Future<List<User>> fetchUsers() async {
  final response = await dio.get('/users');
  return (response.data as List)
      .map((j) => User.fromJson(j))
      .toList();
}

// FutureBuilder uses the Future:
FutureBuilder<List<User>>(
  future: fetchUsers(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const CircularProgressIndicator();
    }
    if (snapshot.hasError) {
      return Text('Error: \${snapshot.error}');
    }
    final users = snapshot.data!;
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, i) => ListTile(title: Text(users[i].name)),
    );
  },
)

// Sealed class for UI state (with Riverpod):
sealed class UsersState { }
class UsersLoading extends UsersState { }
class UsersLoaded extends UsersState { final List<User> users; UsersLoaded(this.users); }
class UsersError extends UsersState { final String message; UsersError(this.message); }

Widget build(BuildContext context) {
  return switch (state) {
    UsersLoading() => const CircularProgressIndicator(),
    UsersLoaded(:final users) => UserListView(users: users),
    UsersError(:final message) => ErrorView(message: message),
  };
}
''';

void main() {
  print('🎉 Congratulations on completing the Dart course!');
  print('');
  print('You have mastered:');
  final topics = [
    'Variables, types, null safety',
    'Control flow, loops, functions',
    'Collections: List, Map, Set, Records',
    'OOP: classes, inheritance, mixins, interfaces',
    'Enums, generics, extensions, typedefs',
    'Error handling patterns',
    'Async/await, Futures, Streams, Isolates',
    'dart:core, dart:collection, dart:io, dart:convert',
    'dart:async, dart:typed_data, dart:ffi',
    'Dart 3: Records, Patterns, Sealed Classes, Class Modifiers',
    'Testing, performance, best practices',
    'Code generation, popular packages',
    'CLI tools, server-side Dart, web interop',
  ];

  for (final (i, topic) in topics.indexed) {
    print('  \${i+1}. \$topic');
  }

  print('');
  print('Next step: FLUTTER');
  print('Install: flutter.dev/docs/get-started/install');
  print('Run:     flutter create my_app && cd my_app && flutter run');
  print('Learn:   flutter.dev/docs/cookbook');
}

📝 KEY POINTS:
✅ Flutter renders every pixel itself — truly cross-platform, pixel-perfect UI
✅ Everything in Flutter is a widget — text, buttons, layouts, entire screens
✅ StatelessWidget for pure UI; StatefulWidget when the UI needs to change
✅ setState(() { ... }) triggers a widget rebuild in StatefulWidget
✅ Hot reload = change code, see changes instantly, state preserved
✅ All your Dart knowledge applies directly in Flutter
✅ FutureBuilder and StreamBuilder connect async Dart to the widget tree
✅ Start at flutter.dev — the docs are excellent and have a cookbook
✅ Riverpod is the recommended state management solution for new projects
❌ Don't try to learn Flutter without Dart — the language IS the framework
❌ Don't use setState for app-wide state — use Riverpod, BLoC, or Provider
❌ Don't skip the Flutter docs cookbook — it covers the 20 most common patterns
''',
  quiz: [
    Quiz(question: 'How does Flutter render UI differently from React Native or Cordova?', options: [
      QuizOption(text: 'It uses native platform components provided by iOS/Android', correct: false),
      QuizOption(text: 'Flutter renders every pixel itself using its own engine — not native components', correct: true),
      QuizOption(text: 'It uses a WebView to display HTML/CSS content', correct: false),
      QuizOption(text: 'It converts Dart widgets to platform-native code at compile time', correct: false),
    ]),
    Quiz(question: 'What does setState(() { ... }) do in a StatefulWidget?', options: [
      QuizOption(text: 'Saves the state to SharedPreferences', correct: false),
      QuizOption(text: 'Marks the widget as dirty and schedules a rebuild with the updated state', correct: true),
      QuizOption(text: 'Creates a new State object', correct: false),
      QuizOption(text: 'Sends state to a parent widget', correct: false),
    ]),
    Quiz(question: 'How does your Dart async knowledge apply in Flutter?', options: [
      QuizOption(text: 'It doesn\'t — Flutter uses a different async system', correct: false),
      QuizOption(text: 'FutureBuilder and StreamBuilder display Futures and Streams directly in the widget tree', correct: true),
      QuizOption(text: 'Dart async only works in CLI apps, not Flutter', correct: false),
      QuizOption(text: 'Flutter converts async to synchronous automatically', correct: false),
    ]),
  ],
);
