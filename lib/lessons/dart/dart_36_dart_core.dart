import '../../models/lesson.dart';
import '../../models/quiz.dart';

final dartLesson36 = Lesson(
  language: 'Dart',
  title: 'dart:core Deep Dive',
  content: '''
🎯 METAPHOR:
dart:core is like the air you breathe — always there,
always available, never needing to be asked for.
It's the bedrock of every Dart program: the types
you use constantly (String, int, List, Map), the
functions you rely on (print, identical, hashCode),
and the error types you catch. You don't import it
because it's already there, woven into the language
itself. Understanding dart:core deeply means understanding
what Dart fundamentally IS.

📖 EXPLANATION:
dart:core is automatically imported in every Dart file.
It provides the foundational types, exceptions, functions,
and annotations. This lesson covers the non-obvious parts
of dart:core that elevate your Dart proficiency.

─────────────────────────────────────
📦 KEY dart:core CONTENTS
─────────────────────────────────────
Types:
  Object, Null, bool, int, double, num
  String, StringBuffer
  List, Map, Set, Iterable, Iterator
  Future, Stream
  Symbol, Type, Function
  DateTime, Duration, Stopwatch
  RegExp, Match, Pattern
  Uri, UriData
  Exception, Error + subclasses
  Comparable, Enum

Functions/Properties:
  print(), identical(), hashCode
  int.parse(), double.parse()
  Object.hash(), Object.hashAll()

─────────────────────────────────────
🔤 STRINGBUFFER
─────────────────────────────────────
Efficient string building — avoids creating
a new String on every concatenation:

var sb = StringBuffer();
sb.write('Hello');
sb.write(', ');
sb.writeln('World!');    // write + newline
sb.writeAll([1,2,3], ', '); // write iterable with separator
String result = sb.toString();

─────────────────────────────────────
📅 DATETIME & DURATION
─────────────────────────────────────
DateTime.now()
DateTime.utc(2024, 3, 15, 10, 30)
DateTime.parse('2024-03-15T10:30:00')

d1.difference(d2)  → Duration
d1.add(Duration(days: 7))
d.compareTo(other)
d.isBefore(other) / isAfter(other)

Duration:
  Duration(days: 1, hours: 2, minutes: 30)
  duration.inDays / inHours / inMinutes / inSeconds

─────────────────────────────────────
🔗 COMPARABLE
─────────────────────────────────────
Implement Comparable<T> to enable sorting:
  int compareTo(T other):
    < 0 → this comes before other
    = 0 → equal
    > 0 → this comes after other

─────────────────────────────────────
🔍 REGEXP
─────────────────────────────────────
RegExp(r'pattern')
  .hasMatch(string)       → bool
  .firstMatch(string)     → Match?
  .allMatches(string)     → Iterable<Match>
  .matchAsPrefix(string)  → Match?

Match.group(0)   → whole match
Match.group(1)   → first capture group

─────────────────────────────────────
🌐 URI
─────────────────────────────────────
Uri.parse('https://example.com/path?q=hello')
  .scheme → 'https'
  .host   → 'example.com'
  .path   → '/path'
  .query  → 'q=hello'
  .queryParameters → {'q': 'hello'}

Uri.https('example.com', '/path', {'q': 'hello'})
Uri.encodeComponent('hello world') → 'hello%20world'

💻 CODE:
void main() {
  // ── OBJECT METHODS ────────────
  // Every Dart object has these:
  var list = [1, 2, 3];
  print(list.toString());           // [1, 2, 3]
  print(list.runtimeType);          // List<int>
  print(list.hashCode);             // some hash
  print(list == [1, 2, 3]);         // false (reference equality for List)

  // identical() — same object reference?
  var a = [1, 2, 3];
  var b = a;   // same reference
  var c = [1, 2, 3];  // new list
  print(identical(a, b));   // true
  print(identical(a, c));   // false

  // Object.hash — combine multiple values
  int hash = Object.hash('Alice', 30, 'Engineering');
  print(hash);  // consistent hash for combination

  // Object.hashAll — hash an iterable
  int listHash = Object.hashAll([1, 2, 3, 4, 5]);

  // ── STRINGBUFFER ──────────────
  var sb = StringBuffer();
  sb.write('Hello');
  sb.write(', ');
  sb.write('Dart!');
  sb.writeln();   // newline
  sb.writeln('Second line');
  sb.writeAll(['a', 'b', 'c'], ' | ');

  print(sb.toString());
  print('Length: \${sb.length}');
  sb.clear();
  print('After clear: "\${sb.toString()}"');  // ""

  // ── DATETIME ──────────────────
  final now = DateTime.now();
  final utcNow = DateTime.now().toUtc();
  final specific = DateTime(2024, 3, 15, 10, 30, 0);
  final fromStr = DateTime.parse('2024-06-21T12:00:00');
  final utc = DateTime.utc(2024, 1, 1);

  print('Now: \$now');
  print('UTC: \$utcNow');
  print('Specific: \$specific');
  print('Year: \${now.year}');
  print('Month: \${now.month}');
  print('Day: \${now.day}');
  print('Weekday: \${now.weekday}');  // 1=Mon, 7=Sun
  print('Is UTC: \${now.isUtc}');    // false

  // Comparisons
  print(specific.isBefore(now));   // true
  print(specific.isAfter(now));    // false
  print(utc.compareTo(specific));  // negative (utc is before)

  // Arithmetic
  final tomorrow = now.add(Duration(days: 1));
  final lastWeek = now.subtract(Duration(days: 7));
  final diff = now.difference(specific);
  print('Days since 2024-03-15: \${diff.inDays}');

  // Formatting (basic)
  String formatted = '\${now.year}-\${now.month.toString().padLeft(2,'0')}-\${now.day.toString().padLeft(2,'0')}';
  print('Formatted: \$formatted');
  // For proper formatting, use package:intl

  // ── DURATION ──────────────────
  final dur = Duration(days: 1, hours: 2, minutes: 30, seconds: 15);
  print(dur);                        // 26:30:15.000000
  print(dur.inDays);                 // 1
  print(dur.inHours);                // 26
  print(dur.inMinutes);              // 1590
  print(dur.inSeconds);              // 95415
  print(dur.inMilliseconds);         // 95415000

  // Comparison
  final d1 = Duration(hours: 2);
  final d2 = Duration(minutes: 90);
  print(d1 > d2);    // true
  print(d1 + d2);    // 3:30:00.000000

  // ── STOPWATCH ─────────────────
  final sw = Stopwatch()..start();
  // ... some work ...
  sw.stop();
  print('Elapsed: \${sw.elapsed}');
  print('Milliseconds: \${sw.elapsedMilliseconds}');
  sw.reset();
  sw.start();   // can restart after reset

  // ── COMPARABLE ────────────────
  var versions = [Version(1, 3, 0), Version(2, 0, 1), Version(1, 2, 0)];
  versions.sort();
  print(versions);   // [1.2.0, 1.3.0, 2.0.1]

  print(Version(1,0,0).compareTo(Version(2,0,0)));  // < 0

  // ── REGEXP ─────────────────────
  // Basic matching
  final emailRegex = RegExp(r'^[\w-\.]+@[\w-]+\.[a-zA-Z]{2,}$');
  print(emailRegex.hasMatch('alice@example.com'));   // true
  print(emailRegex.hasMatch('not-valid'));            // false

  // Groups
  final dateRegex = RegExp(r'(\d{4})-(\d{2})-(\d{2})');
  final match = dateRegex.firstMatch('Today is 2024-03-15');
  if (match != null) {
    print('Year: \${match.group(1)}');   // 2024
    print('Month: \${match.group(2)}');  // 03
    print('Day: \${match.group(3)}');    // 15
    print('Full: \${match.group(0)}');   // 2024-03-15
  }

  // Named groups
  final namedRegex = RegExp(r'(?<year>\d{4})-(?<month>\d{2})-(?<day>\d{2})');
  final nm = namedRegex.firstMatch('2024-06-21');
  if (nm != null) {
    print('Year: \${nm.namedGroup('year')}');  // 2024
  }

  // All matches
  final words = RegExp(r'\b\w+\b');
  for (final m in words.allMatches('Hello, World! Dart is awesome')) {
    print(m.group(0));
  }

  // Replace with regex
  final spaced = 'helloWorld'.replaceAllMapped(
    RegExp(r'[A-Z]'),
    (m) => ' \${m.group(0)}',
  );
  print(spaced);  // hello World

  // ── URI ───────────────────────
  final uri = Uri.parse('https://api.example.com:8080/v1/users?page=1&limit=10#results');
  print(uri.scheme);       // https
  print(uri.host);         // api.example.com
  print(uri.port);         // 8080
  print(uri.path);         // /v1/users
  print(uri.query);        // page=1&limit=10
  print(uri.fragment);     // results
  print(uri.queryParameters);  // {page: 1, limit: 10}

  // Build URI
  final built = Uri.https(
    'api.example.com',
    '/v1/search',
    {'q': 'dart programming', 'lang': 'en'},
  );
  print(built.toString());  // https://api.example.com/v1/search?q=dart+programming&lang=en

  // Encoding
  print(Uri.encodeComponent('hello world & more'));  // hello%20world%20%26%20more
  print(Uri.decodeComponent('hello%20world'));        // hello world
}

// Comparable implementation
class Version implements Comparable<Version> {
  final int major, minor, patch;

  const Version(this.major, this.minor, this.patch);

  @override
  int compareTo(Version other) {
    if (major != other.major) return major.compareTo(other.major);
    if (minor != other.minor) return minor.compareTo(other.minor);
    return patch.compareTo(other.patch);
  }

  @override
  String toString() => '\$major.\$minor.\$patch';
}

📝 KEY POINTS:
✅ dart:core is auto-imported — String, int, List, Map, print() always available
✅ StringBuffer is O(n) for building strings; string += is O(n²) — use StringBuffer in loops
✅ DateTime.now() gives local time; .toUtc() converts to UTC
✅ Duration arithmetic: add, subtract, compare durations
✅ Stopwatch for performance measurement without creating DateTime objects
✅ Implement Comparable<T> to enable natural sorting with sort()
✅ RegExp with named groups (?<name>...) for readable regex
✅ Uri.parse() and Uri.https() for safe URL construction and parsing
✅ Object.hash() combines multiple values into a consistent hash code
❌ Don't concatenate strings in loops — use StringBuffer
❌ DateTime is LOCAL by default — explicitly use .toUtc() for UTC operations
❌ RegExp is compiled on creation — store as a static field to avoid recompilation
''',
  quiz: [
    Quiz(question: 'Why should you use StringBuffer instead of string += in a loop?', options: [
      QuizOption(text: 'StringBuffer is only needed for very long strings', correct: false),
      QuizOption(text: 'String += creates a new string object each iteration (O(n²)); StringBuffer appends in place (O(n))', correct: true),
      QuizOption(text: 'StringBuffer supports Unicode; string += does not', correct: false),
      QuizOption(text: 'They have identical performance', correct: false),
    ]),
    Quiz(question: 'What does implementing Comparable<T> enable?', options: [
      QuizOption(text: 'The == operator', correct: false),
      QuizOption(text: 'Natural sorting — objects can be sorted with list.sort() without a comparator', correct: true),
      QuizOption(text: 'Conversion to string', correct: false),
      QuizOption(text: 'Hashing for use in maps and sets', correct: false),
    ]),
    Quiz(question: 'What does match.group(0) return in a RegExp match?', options: [
      QuizOption(text: 'The first capture group', correct: false),
      QuizOption(text: 'The entire matched string', correct: true),
      QuizOption(text: 'The position of the match in the string', correct: false),
      QuizOption(text: 'null if there are no capture groups', correct: false),
    ]),
  ],
);
