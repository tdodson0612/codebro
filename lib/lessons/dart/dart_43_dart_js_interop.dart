import '../../models/lesson.dart';
import '../../models/quiz.dart';

final dartLesson43 = Lesson(
  language: 'Dart',
  title: 'dart:js_interop — Web & JavaScript Interop',
  content: '''
🎯 METAPHOR:
dart:js_interop is the diplomatic protocol for Dart's
embassy in JavaScript country. When your Dart code
runs in a web browser, it lives in JavaScript's world.
To work with the browser DOM, call a JavaScript library,
or use browser APIs, you need the official protocol:
extension types that wrap JS objects. The new interop
(Dart 3.3+) is like having a perfect translator who
speaks both languages fluently — no runtime overhead,
type-safe, and zero confusion between Dart and JS objects.

📖 EXPLANATION:
Dart code compiled to web (JavaScript) needs to interact
with browser APIs and existing JS libraries. dart:js_interop
(modern) uses extension types for zero-overhead, type-safe
JS interop. The older dart:js library is deprecated.

─────────────────────────────────────
📦 KEY TYPES
─────────────────────────────────────
JSObject          → any JavaScript object
JSString          → JavaScript string
JSNumber          → JavaScript number
JSBoolean         → JavaScript boolean
JSNull            → JavaScript null
JSUndefined       → JavaScript undefined
JSArray<T>        → JavaScript Array
JSPromise<T>      → JavaScript Promise
JSFunction        → JavaScript function
JSAny             → any JS value (nullable variant: JSAny?)

─────────────────────────────────────
🔑 CONVERTING BETWEEN DART AND JS
─────────────────────────────────────
// Dart → JS
'hello'.toJS            → JSString
42.toJS                 → JSNumber
true.toJS               → JSBoolean
[1,2,3].toJS            → JSArray<JSNumber>

// JS → Dart
jsStr.toDart            → String
jsNum.toDartInt         → int
jsNum.toDartDouble      → double
jsBool.toDart           → bool
jsArray.toDart          → List<JSAny?>
jsPromise.toDart        → Future<T>

─────────────────────────────────────
📐 EXTERNAL DECLARATIONS
─────────────────────────────────────
@JS() marks Dart as JS interop.
@staticInterop + @anonymous for static JS objects.
external marks functions/getters implemented in JS.

@JS('window.location')
external JSObject get location;

@JS()
extension type Console(JSObject _) {
  external void log(JSAny? message);
  external void error(JSAny? message);
}

─────────────────────────────────────
🌐 FLUTTER WEB vs PURE DART WEB
─────────────────────────────────────
Flutter web: use JS interop for platform calls
             Flutter provides web_plugins for common APIs

Pure Dart web (dart compile js): full access to DOM/browser
             Use dart:js_interop for modern approach
             Use dart:html for older (but wider) API

─────────────────────────────────────
🔒 SAFETY
─────────────────────────────────────
Old dart:js was dynamic and unchecked.
New dart:js_interop uses extension types — type-safe!
Cross-origin restrictions still apply (browser security).

💻 CODE:
// dart:js_interop is only available when compiling to web
// These examples show the patterns and APIs

void main() {
  print('=== dart:js_interop Overview ===');
  print('Note: These APIs only work in web (browser) context');
  print('when Dart is compiled to JavaScript.');
  print('');

  // ── BASIC INTEROP PATTERNS ─────
  final basicPattern = """
  // Import modern interop
  import "dart:js_interop";

  // ── ACCESSING JS GLOBALS ───────
  // Access window.location
  @JS("window.location")
  external Location get location;

  // Access console
  @JS("console")
  external Console get console;

  // Use them
  void main() {
    console.log("Hello from Dart!".toJS);
    print(location.href.toDart);    // current URL as Dart String
  }
  """;
  print('Basic Pattern:\n\$basicPattern');

  // ── DEFINING INTEROP TYPES ─────
  final interopTypes = """
  import "dart:js_interop";

  // Define JS class bindings
  @JS("HTMLElement")
  extension type HTMLElement(JSObject _) implements JSObject {
    external String get id;
    external set id(String value);
    external String get innerHTML;
    external void addEventListener(
      String type,
      EventListenerCallback callback,
    );
  }

  @JS("HTMLButtonElement")
  extension type HTMLButtonElement(HTMLElement _) implements HTMLElement {
    external String get textContent;
    external set textContent(String value);
  }

  @JS("Event")
  extension type Event(JSObject _) implements JSObject {
    external String get type;
    external void preventDefault();
  }

  typedef EventListenerCallback = JSFunction;
  """;
  print('Interop Types:\n\$interopTypes');

  // ── DOCUMENT & DOM ─────────────
  final domExample = """
  import "dart:js_interop";
  import "dart:js_interop_unsafe";  // for operator []

  // Access document
  @JS("document")
  external Document get document;

  @JS("Document")
  extension type Document(JSObject _) implements JSObject {
    external HTMLElement? getElementById(String id);
    external HTMLElement createElement(String tag);
    external HTMLElement get body;
  }

  void manipulateDOM() {
    final btn = document.getElementById("myButton");
    if (btn != null) {
      btn.innerHTML = "<strong>Clicked!</strong>";
    }

    // Create element
    final div = document.createElement("div");
    div.id = "new-div";
    document.body.append(div);
  }
  """;
  print('DOM Example:\n\$domExample');

  // ── PROMISES / FUTURES ─────────
  final promisesExample = """
  import "dart:js_interop";

  @JS("fetch")
  external JSPromise<JSObject> fetch(JSString url);

  @JS("Response")
  extension type Response(JSObject _) implements JSObject {
    external JSPromise<JSString> text();
    external JSPromise<JSObject> json();
    external int get status;
  }

  Future<void> fetchData() async {
    // Convert JSPromise to Future
    final response = await fetch("https://api.example.com/data".toJS).toDart;
    final text = await (response as Response).text().toDart;
    print(text.toDart);  // Dart String
  }
  """;
  print('Promises:\n\$promisesExample');

  // ── TYPE CONVERSIONS ───────────
  final conversions = """
  import "dart:js_interop";

  void conversionExamples() {
    // Dart → JS
    JSString jsStr = "Hello".toJS;
    JSNumber jsNum = 42.toJS;
    JSBoolean jsBool = true.toJS;
    JSArray<JSNumber> jsArr = [1, 2, 3].map((n) => n.toJS).toList().toJS;

    // JS → Dart
    String dartStr = jsStr.toDart;
    int dartInt = jsNum.toDartInt;
    double dartDouble = jsNum.toDartDouble;
    bool dartBool = jsBool.toDart;

    // Null-safe access
    JSAny? maybeNull;
    String? safeStr = maybeNull?.typeofEquals("string") == true
        ? (maybeNull as JSString).toDart
        : null;
  }
  """;
  print('Conversions:\n\$conversions');

  // ── CALLING JS FUNCTIONS ────────
  final callingJS = """
  import "dart:js_interop";

  // Declare a JS function
  @JS("Math.random")
  external JSNumber mathRandom();

  @JS("JSON.stringify")
  external JSString jsonStringify(JSAny object, [JSAny? replacer, JSAny? space]);

  @JS("setTimeout")
  external void setTimeout(JSFunction callback, JSNumber delay);

  void useJSFunctions() {
    double rand = mathRandom().toDartDouble;
    print("Random: \$rand");

    final obj = {"name": "Alice", "age": 30}.jsify()!;
    final json = jsonStringify(obj, null, "  ".toJS);
    print(json.toDart);

    // Callback
    void afterDelay() { print("Timer fired!"); }
    setTimeout(afterDelay.toJS, 1000.toJS);  // 1 second
  }
  """;
  print('Calling JS:\n\$callingJS');

  // ── INTEROP WITH JS LIBRARY ────
  final libraryInterop = """
  // Example: wrapping a JS charting library
  import "dart:js_interop";

  @JS("Chart")
  extension type Chart(JSObject _) implements JSObject {
    external factory Chart(HTMLCanvasElement canvas, JSObject config);
    external void update();
    external void destroy();
  }

  @JS("HTMLCanvasElement")
  extension type HTMLCanvasElement(HTMLElement _) implements HTMLElement {}

  // Usage
  void createChart(HTMLCanvasElement canvas) {
    final config = {
      "type": "bar",
      "data": {
        "labels": ["Jan", "Feb", "Mar"],
        "datasets": [{
          "data": [10, 20, 15],
        }]
      }
    }.jsify()!;

    final chart = Chart(canvas, config as JSObject);
    // Later: chart.update(), chart.destroy()
  }
  """;
  print('Library Interop:\n\$libraryInterop');

  print("""
Key Resources:
  • dart.dev/interop/js-interop  — official guide
  • dart.dev/web                 — Dart web development
  • pub.dev/packages/web         — typed DOM bindings package

Common packages:
  • package:web                  — typed bindings for web APIs
  • package:js                   — older interop (deprecated)
""");
}

📝 KEY POINTS:
✅ dart:js_interop (Dart 3.3+) uses extension types for zero-overhead type-safe JS interop
✅ Dart → JS: use .toJS on Dart primitives
✅ JS → Dart: use .toDart, .toDartInt, .toDartDouble on JS types
✅ JSPromise<T>.toDart converts to Future<T> — use await
✅ Extension types model JavaScript classes without overhead
✅ @JS("name") binds to a global JavaScript identifier
✅ package:web provides pre-built typed bindings for all browser APIs
✅ external keyword marks things implemented by the JS environment
❌ dart:js_interop only works when compiled to web (JavaScript)
❌ Old dart:js library is deprecated — use dart:js_interop instead
❌ Cross-origin security restrictions apply regardless of interop method
''',
  quiz: [
    Quiz(question: 'How do you convert a Dart String to a JavaScript String for use in dart:js_interop?', options: [
      QuizOption(text: 'JSString(myDartString)', correct: false),
      QuizOption(text: 'myDartString.toJS', correct: true),
      QuizOption(text: 'jsify(myDartString)', correct: false),
      QuizOption(text: 'No conversion needed — they are the same type', correct: false),
    ]),
    Quiz(question: 'How do you convert a JSPromise<T> to a Dart Future<T>?', options: [
      QuizOption(text: 'Future.fromPromise(jsPromise)', correct: false),
      QuizOption(text: 'jsPromise.toDart', correct: true),
      QuizOption(text: 'await jsPromise directly', correct: false),
      QuizOption(text: 'jsPromise.toFuture()', correct: false),
    ]),
    Quiz(question: 'What makes dart:js_interop better than the old dart:js library?', options: [
      QuizOption(text: 'dart:js_interop is faster at runtime', correct: false),
      QuizOption(text: 'dart:js_interop uses extension types for compile-time type safety with zero overhead', correct: true),
      QuizOption(text: 'dart:js_interop works without a browser', correct: false),
      QuizOption(text: 'dart:js_interop supports older browsers', correct: false),
    ]),
  ],
);