import '../../models/lesson.dart';
import '../../models/quiz.dart';

final dartLesson39 = Lesson(
  language: 'Dart',
  title: 'dart:convert — JSON, UTF-8 & Codecs',
  content: '''
🎯 METAPHOR:
dart:convert is like a universal translation service.
JSON is English, UTF-8 is the alphabet, Base64 is Morse code.
When your Dart Map needs to travel over the internet
(become a JSON string), dart:convert is the translator.
When bytes arrive from a server and need to become a
readable string, dart:convert handles the alphabet
conversion (UTF-8 decode). The codec system is elegant:
every conversion has a forward and reverse direction,
and you can chain codecs like language-to-language-to-language
translation in a single pipeline.

📖 EXPLANATION:
dart:convert provides JSON encoding/decoding, UTF-8 and
ASCII encoding, Base64 encoding, HTML escaping, and a
codec framework for building custom encoding pipelines.

─────────────────────────────────────
📦 KEY CONTENTS
─────────────────────────────────────
jsonEncode(object)    → String (JSON)
jsonDecode(string)    → dynamic (Dart object)
json.encode()         → same as jsonEncode
json.decode()         → same as jsonDecode
JsonEncoder()         → configurable encoder
JsonDecoder()         → configurable decoder
JsonEncoder.withIndent('  ') → pretty-print encoder

utf8.encode(string)   → List<int> (bytes)
utf8.decode(bytes)    → String
Utf8Encoder           → Stream transformer
Utf8Decoder           → Stream transformer

ascii.encode()        → ASCII bytes
latin1.encode()       → Latin-1 bytes

base64.encode(bytes)  → Base64 String
base64.decode(string) → List<int>
base64Url.encode()    → URL-safe Base64
base64Url.decode()

HtmlEscape            → escape HTML entities
LineSplitter          → split stream by lines

─────────────────────────────────────
🔑 JSON TYPE MAPPING
─────────────────────────────────────
JSON null       → Dart null
JSON true/false → Dart bool
JSON number     → Dart int (if no decimal) or double
JSON string     → Dart String
JSON array      → Dart List<dynamic>
JSON object     → Dart Map<String, dynamic>

─────────────────────────────────────
⚡ CUSTOM JSON SERIALIZATION
─────────────────────────────────────
jsonEncode handles: null, bool, int, double, String, List, Map.
For custom classes, provide a toJson() method OR
pass a toEncodable function.

─────────────────────────────────────
🔄 CODEC PIPELINE (STREAMS)
─────────────────────────────────────
Stream<List<int>> → utf8.decoder → Stream<String>
Stream<String>    → utf8.encoder → Stream<List<int>>

// Fuse codecs together:
final encoder = utf8.encoder.fuse(base64.encoder);

💻 CODE:
import 'dart:convert';

void main() {
  // ── JSON ENCODE ────────────────
  // Simple types
  print(jsonEncode(null));          // null
  print(jsonEncode(true));          // true
  print(jsonEncode(42));            // 42
  print(jsonEncode(3.14));          // 3.14
  print(jsonEncode('hello'));        // "hello"
  print(jsonEncode([1, 2, 3]));     // [1,2,3]
  print(jsonEncode({'a': 1}));      // {"a":1}

  // Complex nested structures
  final data = {
    'name': 'Alice',
    'age': 30,
    'scores': [92, 88, 95],
    'address': {
      'city': 'New York',
      'country': 'US',
    },
    'active': true,
    'email': null,   // null is encoded as JSON null
  };

  final json = jsonEncode(data);
  print(json);

  // Pretty-print JSON
  final pretty = const JsonEncoder.withIndent('  ').convert(data);
  print(pretty);
  /*
  {
    "name": "Alice",
    "age": 30,
    ...
  }
  */

  // ── JSON DECODE ────────────────
  final jsonStr = '{"name":"Bob","age":25,"scores":[78,82,80]}';
  final decoded = jsonDecode(jsonStr) as Map<String, dynamic>;

  print(decoded['name']);           // Bob
  print(decoded['age']);            // 25 (int)
  print(decoded['scores']);         // [78, 82, 80]
  print(decoded['scores'][0]);      // 78

  // Type casting from dynamic
  final name = decoded['name'] as String;
  final age  = decoded['age'] as int;
  final scores = (decoded['scores'] as List).cast<int>();
  print('Name: \$name, Age: \$age, First score: \${scores.first}');

  // JSON array
  final jsonArray = '[1, 2, 3, {"key": "value"}]';
  final list = jsonDecode(jsonArray) as List;
  print(list[3]);   // {key: value}

  // ── CUSTOM TOENCODING ──────────
  // Classes need either toJson() OR you provide toEncodable:
  final user = User(name: 'Carol', age: 35, createdAt: DateTime.now());
  final userJson = jsonEncode(user, toEncodable: (obj) {
    if (obj is DateTime) return obj.toIso8601String();
    if (obj is User) return obj.toMap();
    throw UnsupportedError('Cannot encode \${obj.runtimeType}');
  });
  print(userJson);

  // ── UTF-8 ENCODING ─────────────
  // String → bytes
  final text = 'Hello, 世界! 🌍';
  final bytes = utf8.encode(text);
  print('Bytes: \${bytes.length}');  // more than String.length!
  print('Chars: \${text.length}');   // character count

  // Bytes → String
  final decoded2 = utf8.decode(bytes);
  print('Decoded: \$decoded2');
  print('Same: \${text == decoded2}');  // true

  // Handle invalid bytes
  final invalid = [0xFF, 0xFE, 0x41];  // invalid UTF-8 + 'A'
  final safe = utf8.decode(invalid, allowMalformed: true);
  print('Malformed: \$safe');   // replacement chars + A

  // ── ASCII / LATIN-1 ────────────
  final asciiText = 'Hello ASCII';
  final asciiBytes = ascii.encode(asciiText);
  print('ASCII: \$asciiBytes');

  // Latin-1 (ISO-8859-1) — for legacy systems
  final latin1Text = 'Héllo';
  final latin1Bytes = latin1.encode(latin1Text);
  print('Latin-1: \$latin1Bytes');

  // ── BASE64 ─────────────────────
  // Bytes → Base64 string
  final imageBytes = [0x89, 0x50, 0x4E, 0x47];  // PNG header
  final b64 = base64.encode(imageBytes);
  print('Base64: \$b64');   // iVBORw== or similar

  // Base64 → bytes
  final back = base64.decode(b64);
  print('Restored: \$back');

  // URL-safe Base64 (no + or /)
  final urlSafe = base64Url.encode(imageBytes);
  print('URL-safe: \$urlSafe');

  // Encode a string via Base64
  final textBytes = utf8.encode('Hello, Dart!');
  final encoded = base64.encode(textBytes);
  print('Encoded string: \$encoded');
  print('Decoded: \${utf8.decode(base64.decode(encoded))}');

  // ── HTML ESCAPE ────────────────
  const escape = HtmlEscape();
  print(escape.convert('<script>alert("XSS")</script>'));
  // &lt;script&gt;alert(&quot;XSS&quot;)&lt;/script&gt;

  print(escape.convert('Hello & "World"'));
  // Hello &amp; &quot;World&quot;

  // ── LINE SPLITTER ──────────────
  const data2 = 'line1\nline2\r\nline3\rline4';
  final lines = const LineSplitter().convert(data2);
  print(lines);   // [line1, line2, line3, line4]

  // ── CODEC COMPOSITION ──────────
  // Fuse codecs: str → utf8 bytes → base64 string
  final utf8ToBase64 = utf8.encoder.fuse(base64.encoder);
  final base64ToUtf8 = base64.decoder.fuse(utf8.decoder);

  final msg = 'Secret message: 🔐';
  final encoded2 = utf8ToBase64.convert(msg);
  final decoded3 = base64ToUtf8.convert(encoded2);
  print('Original: \$msg');
  print('Encoded:  \$encoded2');
  print('Decoded:  \$decoded3');
  print('Match: \${msg == decoded3}');

  // ── STREAMING JSON ─────────────
  // For very large JSON, use streaming:
  // (shown conceptually)
  final jsonChunks = ['{"name"', ':"Alice","', 'age":30}'];
  final controller = StreamController<String>();
  final stream = controller.stream.transform(json.decoder);
  stream.listen((decoded4) => print('Streamed: \$decoded4'));
  for (final chunk in jsonChunks) controller.add(chunk);
  controller.close();
}

import 'dart:async';

class User {
  final String name;
  final int age;
  final DateTime createdAt;

  User({required this.name, required this.age, required this.createdAt});

  Map<String, dynamic> toMap() => {
    'name': name,
    'age': age,
    'createdAt': createdAt.toIso8601String(),
  };

  factory User.fromMap(Map<String, dynamic> map) => User(
    name: map['name'] as String,
    age: map['age'] as int,
    createdAt: DateTime.parse(map['createdAt'] as String),
  );
}

📝 KEY POINTS:
✅ jsonEncode handles: null, bool, int, double, String, List, Map<String,dynamic>
✅ jsonDecode returns dynamic — always cast to expected type
✅ JsonEncoder.withIndent('  ') produces pretty-printed JSON
✅ utf8.encode(string) returns bytes (List<int>); more bytes than characters for non-ASCII
✅ base64.encode() for safe binary-to-text; base64Url for URL-safe variant
✅ HtmlEscape prevents XSS in web apps
✅ Fuse codecs together for pipeline transformations: utf8.encoder.fuse(base64.encoder)
✅ Custom classes need toJson() or a toEncodable function passed to jsonEncode
❌ Don't cast decoded JSON blindly — use as with type checking
❌ Don't pass DateTime directly to jsonEncode — it's not JSON-serializable
❌ ascii.encode() throws for non-ASCII characters — use utf8 for general text
''',
  quiz: [
    Quiz(question: 'What Dart type does jsonDecode return when parsing a JSON object?', options: [
      QuizOption(text: 'Map<String, String>', correct: false),
      QuizOption(text: 'dynamic (usually Map<String, dynamic> that you cast)', correct: true),
      QuizOption(text: 'Object', correct: false),
      QuizOption(text: 'Map<dynamic, dynamic>', correct: false),
    ]),
    Quiz(question: 'Why does utf8.encode("Hello 🌍").length differ from "Hello 🌍".length?', options: [
      QuizOption(text: 'utf8.encode adds a null terminator', correct: false),
      QuizOption(text: 'Non-ASCII characters take multiple bytes in UTF-8 but count as one character in a Dart String', correct: true),
      QuizOption(text: 'The string is padded to a multiple of 4', correct: false),
      QuizOption(text: 'utf8 includes a BOM header', correct: false),
    ]),
    Quiz(question: 'What does codec1.fuse(codec2) create?', options: [
      QuizOption(text: 'Two separate codecs applied one after the other', correct: false),
      QuizOption(text: 'A single combined codec that applies codec1 then codec2 as one pipeline', correct: true),
      QuizOption(text: 'A bidirectional codec that can encode and decode', correct: false),
      QuizOption(text: 'A streaming version of the codec', correct: false),
    ]),
  ],
);
