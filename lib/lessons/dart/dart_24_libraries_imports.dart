import '../../models/lesson.dart';
import '../../models/quiz.dart';

final dartLesson24 = Lesson(
  language: 'Dart',
  title: 'Libraries & Imports',
  content: '''
🎯 METAPHOR:
Dart libraries are like specialized departments in a city.
dart:core is City Hall — always there, never needs to be
summoned. dart:math is the Science Department — you ask
for it when you need math. dart:io is the Physical Works
Department — only available in the field (native apps),
not at the web office (browser apps). Packages from
pub.dev are services from other cities you can import
by signing a contract (adding to pubspec.yaml). Your own
files are your own departments — organized, accessible,
and hidden from outsiders by the privacy rules.

📖 EXPLANATION:
Dart code is organized into libraries. Every .dart file
IS a library by default. Libraries define what's public
(default) and what's private (underscore prefix).
Import with import, export with export, conditionally
import with import ... if (platform).

─────────────────────────────────────
📦 IMPORT TYPES
─────────────────────────────────────
import 'dart:core';        // standard library (implicit — always available)
import 'dart:math';        // standard library, must import
import 'dart:io';          // native I/O (files, sockets)
import 'dart:html';        // web only (DOM, browser APIs)
import 'dart:async';       // Future, Stream
import 'dart:convert';     // JSON, UTF-8 encoding

import 'package:http/http.dart';      // pub.dev package
import 'package:flutter/material.dart'; // Flutter SDK

import 'path/to/my_file.dart'; // relative path within project
import 'src/my_util.dart';    // relative import

─────────────────────────────────────
🔑 IMPORT MODIFIERS
─────────────────────────────────────
// Alias (avoid name conflicts or shorten long names)
import 'dart:math' as math;
print(math.pi);

// Show only specific names
import 'dart:math' show pi, sqrt;
print(pi);
print(sqrt(16));

// Hide specific names
import 'dart:math' hide Random;

// Deferred (lazy loading)
import 'heavy_library.dart' deferred as heavy;
await heavy.loadLibrary();
heavy.doSomething();

─────────────────────────────────────
📤 EXPORT
─────────────────────────────────────
// In a library file, re-export other files:
export 'src/user.dart';
export 'src/post.dart' show Post, PostStatus;
export 'src/utils.dart' hide internalHelper;

// The "barrel" pattern:
// lib/my_package.dart exports everything
// Users just: import 'package:my_package/my_package.dart';

─────────────────────────────────────
🔒 PRIVACY IN DART
─────────────────────────────────────
_ prefix = private to the LIBRARY (not just the class!)
Everything without _ is public.

class _InternalHelper { ... }  // private class
void _helper() { ... }         // private function
int _count = 0;                // private variable

Note: within the same library file, _ members are accessible.
In OTHER files, _ members are invisible.

─────────────────────────────────────
🌐 CONDITIONAL IMPORTS
─────────────────────────────────────
import 'dart:io' if (dart.library.html) 'dart:html';

// Common pattern for cross-platform libraries:
import 'io_impl.dart'
    if (dart.library.html) 'html_impl.dart';

─────────────────────────────────────
📁 LIBRARY DIRECTIVE
─────────────────────────────────────
// Optional — name your library for documentation:
library my_package.utils;

// Part/part of — split large library into files:
// main_library.dart:   part 'src/helper.dart';
// src/helper.dart:     part of 'main_library.dart';
// (avoid this pattern in modern Dart — prefer regular imports)

💻 CODE:
// ── STANDARD IMPORTS ──────────

import 'dart:math' as math;
import 'dart:math' show pi, sqrt, Random;
import 'dart:convert' show jsonEncode, jsonDecode, utf8;
import 'dart:async' show Future, Stream, Timer;
import 'dart:collection' show LinkedHashMap, Queue;

// dart:core is ALWAYS imported automatically — no need to import:
// String, int, double, bool, List, Map, Set, Object, Exception...

void main() {
  // ── DART:MATH ─────────────────
  print(math.pi);              // 3.141592653589793 (via alias)
  print(pi);                   // 3.141592653589793 (via show)
  print(sqrt(144));            // 12.0
  print(math.sqrt(144));       // 12.0 (same thing)
  print(math.pow(2, 10));      // 1024.0
  print(math.log(math.e));     // 1.0 (natural log of e)
  print(math.sin(math.pi / 6)); // 0.5 (sin 30°)
  print(math.cos(math.pi / 3)); // 0.5 (cos 60°)
  print(math.min(3, 7));        // 3
  print(math.max(3, 7));        // 7

  // Random
  final rng = Random();
  print(rng.nextInt(100));     // random int 0-99
  print(rng.nextDouble());     // random double 0.0-1.0
  print(rng.nextBool());       // random bool

  // Seeded random (reproducible)
  final seeded = Random(42);
  print(seeded.nextInt(100));  // always same for seed 42

  // ── DART:CONVERT ──────────────
  final data = {'name': 'Alice', 'age': 30, 'scores': [92, 88, 95]};

  // JSON encoding
  final json = jsonEncode(data);
  print(json);  // {"name":"Alice","age":30,"scores":[92,88,95]}

  // JSON decoding
  final decoded = jsonDecode(json) as Map<String, dynamic>;
  print(decoded['name']);  // Alice

  // Pretty JSON
  final pretty = jsonEncode(data);  // add indent with JsonEncoder
  print(pretty);

  // UTF-8 encoding
  final bytes = utf8.encode('Hello, 世界!');
  print(bytes.length);   // bytes, not chars!
  print(utf8.decode(bytes));  // Hello, 世界!

  // ── DART:COLLECTION ───────────
  final queue = Queue<int>();
  queue.addLast(1);
  queue.addLast(2);
  queue.addLast(3);
  print(queue.removeFirst());  // 1 (FIFO)

  final linked = LinkedHashMap<String, int>();
  linked['c'] = 3;
  linked['a'] = 1;
  linked['b'] = 2;
  print(linked.keys.toList());  // [c, a, b] — insertion order!

  // ── DART:ASYNC ────────────────
  // Timer — fire after delay
  Timer(Duration(milliseconds: 100), () {
    print('Timer fired!');
  });

  // Periodic timer
  int count = 0;
  final timer = Timer.periodic(Duration(milliseconds: 50), (t) {
    print('Tick \${++count}');
    if (count >= 3) t.cancel();
  });

  // ── PRIVACY DEMONSTRATION ─────
  // Within this file, _privateFunction is accessible:
  print(_privateFunction());  // Private but accessible in same library

  // From other files/libraries — not accessible at all
  // import 'this_file.dart';
  // _privateFunction(); // ❌ Compile error — undefined

  // ── CONDITIONAL IMPORT PATTERN ─
  // (See platform_helper.dart below for implementation)
  // Allows the same API with different implementations:
  // import 'platform_helper.dart'
  //     if (dart.library.io) 'platform_helper_io.dart'
  //     if (dart.library.html) 'platform_helper_web.dart';
}

// ── PRIVATE FUNCTION ───────────
String _privateFunction() => 'private to this library';

class _PrivateClass {
  String value = 'private class';
}

// ── BARREL FILE PATTERN ────────
// In a real project, lib/my_package.dart would look like:
/*
library my_package;

export 'src/models/user.dart';
export 'src/models/post.dart';
export 'src/services/api_service.dart' hide ApiConfig;
export 'src/utils/string_utils.dart' show capitalize, truncate;
*/

// Then users just write:
// import 'package:my_package/my_package.dart';
// and get access to everything you chose to export!

// ── DEFERRED LOADING ───────────
/*
// Useful for web apps to reduce initial bundle size:

import 'package:heavy_feature/heavy_feature.dart' deferred as heavy;

Future<void> loadFeature() async {
  await heavy.loadLibrary();  // downloads the library code
  heavy.initializeFeature();  // now safe to use
}
*/

// ── DART STANDARD LIBRARY MAP ──
/*
dart:core         → String, int, List, Map, etc. (always imported)
dart:async        → Future, Stream, Timer, Completer
dart:collection   → LinkedHashMap, Queue, SplayTreeMap, etc.
dart:convert      → jsonEncode/Decode, utf8, base64, etc.
dart:developer    → log(), debugger(), Timeline
dart:io           → File, Directory, HttpServer, Socket (native only)
dart:isolate      → Isolate, ReceivePort, SendPort
dart:math         → pi, e, Random, sqrt, sin, cos, log, etc.
dart:mirrors      → reflection (limited on Flutter)
dart:typed_data   → Uint8List, Int32List, ByteData, etc.
dart:ffi          → foreign function interface (native C calls)
dart:html         → DOM, window, document (web only)
dart:js_interop   → modern JS interop (web)
dart:js_util      → JS utility functions (web)
*/

📝 KEY POINTS:
✅ dart:core is always imported — no need to import String, int, List, etc.
✅ as alias prevents name conflicts and keeps import origins clear
✅ show only imports specific names — keeps namespace clean
✅ hide excludes specific names from an otherwise full import
✅ Private names (underscore prefix) are private to the whole LIBRARY file
✅ Barrel files (lib/my_package.dart with exports) simplify public APIs
✅ Deferred imports (deferred as name) enable lazy loading for web performance
✅ Conditional imports enable platform-specific implementations
❌ _ privacy is per-library (file), not per-class — a subtle distinction
❌ Don't import the same library with multiple different aliases — confusing
❌ Avoid circular imports — restructure to eliminate them
''',
  quiz: [
    Quiz(question: 'In Dart, what does "import \'dart:math\' show pi, sqrt" do?', options: [
      QuizOption(text: 'Imports all of dart:math except pi and sqrt', correct: false),
      QuizOption(text: 'Imports only pi and sqrt from dart:math into scope', correct: true),
      QuizOption(text: 'Creates aliases named pi and sqrt for dart:math', correct: false),
      QuizOption(text: 'Only imports the dart:math library metadata', correct: false),
    ]),
    Quiz(question: 'A name with a _ prefix in Dart is private to what scope?', options: [
      QuizOption(text: 'The class it is defined in', correct: false),
      QuizOption(text: 'The library (file) it is defined in', correct: true),
      QuizOption(text: 'The function it is defined in', correct: false),
      QuizOption(text: 'The entire package', correct: false),
    ]),
    Quiz(question: 'What is a "barrel file" pattern in Dart?', options: [
      QuizOption(text: 'A file containing only constants', correct: false),
      QuizOption(text: 'A file that re-exports other library files to create a clean public API', correct: true),
      QuizOption(text: 'A file that stores serialized data', correct: false),
      QuizOption(text: 'A test helper file', correct: false),
    ]),
  ],
);
