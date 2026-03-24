import '../../models/lesson.dart';
import '../../models/quiz.dart';

final dartLesson59 = Lesson(
  language: 'Dart',
  title: 'Dart & the Web: dart:js_interop',
  content: '''
🎯 METAPHOR:
Dart's web interop is like a skilled translator at the United
Nations. Dart speaks its own precise, type-safe language.
The browser speaks JavaScript — a different dialect with
different rules. dart:js_interop is the translator: it
takes your Dart code and produces perfect JavaScript, or
lets you call JavaScript APIs from Dart. The new dart:js_interop
(Dart 3+) uses static JavaScript interop — more type-safe
and performant than the old dart:html approach. You write
Dart, the translator produces JS that the browser understands.

📖 EXPLANATION:
Dart compiles to JavaScript for the web. dart:js_interop
(modern) and dart:html (older) allow interacting with browser
APIs. Flutter Web uses this internally. For pure Dart web work
without Flutter, you use dart:js_interop directly, or use
the dart:html library for classic DOM manipulation.

─────────────────────────────────────
📦 DART WEB COMPILATION
─────────────────────────────────────
dart compile js main.dart -o main.js
dart compile js main.dart -O2 -o main.min.js

Two outputs:
  Development: large, includes source maps
  Production (-O2): tree-shaken, minified

─────────────────────────────────────
🌐 DART:JS_INTEROP (MODERN)
─────────────────────────────────────
import 'dart:js_interop';

// Declare JS types with @JS() annotation:
@JS()
extension type Window._(JSObject _) implements JSObject {
  external String get href;
  external void alert(String message);
}

// Access global JS objects:
@JS()
external Window get window;

// Call JS:
window.alert('Hello from Dart!');

─────────────────────────────────────
📋 DART:HTML (CLASSIC)
─────────────────────────────────────
import 'dart:html';

querySelector('#myDiv')?.text = 'Hello!';
window.location.href = 'https://example.com';
window.alert('Hello!');
document.createElement('div');
HttpRequest.getString('https://api.example.com/data');

─────────────────────────────────────
🔑 TYPE MAPPINGS
─────────────────────────────────────
Dart → JS:
  String → JSString
  int/double → JSNumber
  bool → JSBoolean
  null → JSNull
  List → JSArray
  Map → JSObject
  Function → JSFunction

.toJS   → Dart to JS type
.toDart → JS to Dart type

─────────────────────────────────────
🎯 WHEN TO USE
─────────────────────────────────────
dart:js_interop:  calling JS libraries, web APIs
dart:html:        DOM manipulation, events, HTTP
Flutter Web:      handles interop internally
package:web:      modern type-safe web APIs (future)

─────────────────────────────────────
📌 PACKAGE:WEB (EMERGING STANDARD)
─────────────────────────────────────
pub add web

Provides typed bindings for all Web APIs:
  Browser API → Dart types
  Generated from WebIDL specifications
  Replaces dart:html long-term

💻 CODE:
// ── DART COMPILE TO JS ────────────

// dart compile js main.dart -o main.js
// dart compile js main.dart -O2 -o app.min.js  (optimized)

// ── DART:JS_INTEROP ───────────────

/*
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

// Declare external JS types
@JS('console')
extension type Console._(JSObject _) implements JSObject {
  external void log(JSAny? value);
  external void warn(JSString message);
  external void error(JSString message);
  external void group(JSString label);
  external void groupEnd();
}

@JS()
external Console get console;

// Interop with global JS objects
@JS()
extension type Window._(JSObject _) implements JSObject {
  external JSString get href;
  external void alert(JSString message);
  external void setTimeout(JSFunction callback, JSNumber delay);

  @JS('localStorage')
  external Storage get localStorage;
}

@JS()
external Window get window;

@JS()
extension type Storage._(JSObject _) implements JSObject {
  external void setItem(JSString key, JSString value);
  external JSString? getItem(JSString key);
  external void removeItem(JSString key);
  external void clear();
}

// Using JS types
void jsInteropExample() {
  // Call console.log
  console.log('Hello from Dart!'.toJS);

  // Access window
  final href = window.href.toDart;
  print('Current URL: \$href');

  // localStorage
  window.localStorage.setItem('key'.toJS, 'value'.toJS);
  final val = window.localStorage.getItem('key'.toJS)?.toDart;
  print('Stored: \$val');

  // Type conversions
  JSString jsStr = 'Hello'.toJS;
  String dartStr = jsStr.toDart;

  JSNumber jsNum = 42.toJS;
  int dartInt = jsNum.toDartInt;

  JSBoolean jsBool = true.toJS;
  bool dartBool = jsBool.toDart;

  JSArray<JSString> jsArray = ['a', 'b', 'c'].map((s) => s.toJS).toList().toJS;
  List<JSString> dartList = jsArray.toDart;
}

// Calling a JS function
@JS()
external JSAny? eval(JSString code);

void callEval() {
  final result = eval('1 + 2 + 3'.toJS);
  print(result);  // 6 (as JSNumber)
}

// Passing Dart functions to JS
void dartFunctionToJS() {
  final callback = ((JSString event) {
    print('Event received: \${event.toDart}');
  }).toJS;

  // Pass to JS as a callback
  // someJSApi.addEventListener('click'.toJS, callback);
}
*/

// ── DART:HTML (CLASSIC APPROACH) ──

/*
import 'dart:html';

void domManipulation() {
  // Query elements
  final div = querySelector('#container') as DivElement?;
  div?.text = 'Hello, Dart!';
  div?.classes.add('active');
  div?.style.color = 'blue';

  // Create elements
  final button = ButtonElement()
    ..text = 'Click me!'
    ..onClick.listen(handleClick);
  document.body!.append(button);

  // Event handling
  final input = querySelector('#search') as InputElement?;
  input?.onInput.listen((event) {
    final value = input.value ?? '';
    print('Searching for: \$value');
  });

  // Animation frame
  window.requestAnimationFrame((_) {
    print('Frame!');
  });

  // Local storage
  window.localStorage['token'] = 'abc123';
  final token = window.localStorage['token'];

  // Fetch via HttpRequest
  HttpRequest.getString('https://api.github.com/zen').then((response) {
    print('GitHub zen: \$response');
  });
}

void handleClick(MouseEvent event) {
  print('Clicked at \${event.client.x}, \${event.client.y}');
}

// Form handling
void formExample() {
  final form = querySelector('#loginForm') as FormElement?;
  form?.onSubmit.listen((event) {
    event.preventDefault();  // prevent page reload

    final email = (querySelector('#email') as InputElement).value!;
    final password = (querySelector('#password') as InputElement).value!;

    print('Login: \$email / \$password');
  });
}
*/

// ── PACKAGE:WEB (MODERN) ──────────

/*
// pub add web
import 'package:web/web.dart';

void packageWebExample() {
  // Fully typed DOM API
  final div = document.createElement('div') as HTMLDivElement;
  div.textContent = 'Hello from package:web!';
  div.className = 'container';

  final button = document.createElement('button') as HTMLButtonElement;
  button.textContent = 'Click me!';
  button.addEventListener('click', (Event event) {
    print('Clicked!');
  }.toJS);

  document.body?.append(div);
  document.body?.append(button);

  // Typed access to window
  final location = window.location;
  print('Host: \${location.host}');
  print('Pathname: \${location.pathname}');
}
*/

// ── FLUTTER WEB INTEROP ────────────

/*
// In Flutter Web, use dart:js_interop for platform-specific code:
// lib/src/web_utils.dart  (only compiled on web)

@JS()
external void shareUrl(String url, String title);  // calls JS shareUrl()

// Conditional import (platform detection):
// import 'package:myapp/web_utils.dart' if (dart.library.io) 'stub.dart';
*/

// ── WEBASSEMBLY (DART → WASM) ──────

String wasmNote = """
Dart → WebAssembly (WasmGC) is in progress.
Flutter Web already uses WASM in some configurations.
dart compile wasm main.dart (experimental)

Benefits of WASM:
  → Faster startup than JS
  → Better performance for compute-heavy code
  → Smaller binary in some cases
  → Will gradually replace JS compilation
""";

void main() {
  print('Dart Web Compilation Options:');
  print('─────────────────────────────────────');
  print('dart compile js main.dart           → JavaScript output');
  print('dart compile js -O2 main.dart       → Optimized JS');
  print('dart compile wasm main.dart         → WebAssembly (experimental)');
  print('flutter build web                   → Flutter Web app');
  print('flutter build web --wasm            → Flutter Web + WASM');
  print('');
  print('Key Libraries:');
  print('  dart:js_interop  → modern JS interop (Dart 3+)');
  print('  dart:html        → classic DOM manipulation');
  print('  package:web      → modern typed Web APIs (replaces dart:html)');
  print('');
  print(wasmNote);
}

📝 KEY POINTS:
✅ dart compile js compiles Dart to JavaScript for web deployment
✅ dart:js_interop (Dart 3+) is the modern way to call JS from Dart
✅ Use .toJS to convert Dart values to JS types; .toDart to convert back
✅ @JS() annotation declares external JavaScript types and functions
✅ dart:html provides DOM manipulation in classic Dart web apps
✅ package:web is the emerging replacement for dart:html with better typing
✅ Flutter Web handles web interop internally — use dart:js_interop only for platform-specific code
✅ Dart → WebAssembly compilation is available and improving
❌ Don't use dart:html in new Dart code — use package:web or dart:js_interop
❌ JSAny from dart:js_interop is untyped — use specific JSObject subtypes when possible
❌ Don't import dart:html or dart:js in Flutter mobile apps — they're web-only
''',
  quiz: [
    Quiz(question: 'What does .toJS do in dart:js_interop?', options: [
      QuizOption(text: 'Calls a JavaScript function', correct: false),
      QuizOption(text: 'Converts a Dart value to the corresponding JavaScript type for interop', correct: true),
      QuizOption(text: 'Compiles the Dart file to JavaScript', correct: false),
      QuizOption(text: 'Creates a new JS object', correct: false),
    ]),
    Quiz(question: 'What command compiles Dart to optimized JavaScript?', options: [
      QuizOption(text: 'dart build --web', correct: false),
      QuizOption(text: 'dart compile js -O2 main.dart', correct: true),
      QuizOption(text: 'dart run --web main.dart', correct: false),
      QuizOption(text: 'dart transpile --js main.dart', correct: false),
    ]),
    Quiz(question: 'What is package:web replacing in the Dart ecosystem?', options: [
      QuizOption(text: 'dart:async', correct: false),
      QuizOption(text: 'dart:html — providing more complete and better-typed web API bindings', correct: true),
      QuizOption(text: 'dart:js_interop', correct: false),
      QuizOption(text: 'The entire Flutter Web framework', correct: false),
    ]),
  ],
);
