import '../../models/lesson.dart';
import '../../models/quiz.dart';

final dartLesson19 = Lesson(
  language: 'Dart',
  title: 'Extension Methods',
  content: '''
🎯 METAPHOR:
Extension methods are like retrofitting a car with new
features. You don't build a new car — you add a better
stereo, a backup camera, and LED headlights to the
existing one. The car manufacturer (String, int, List)
didn't include these features, but you can add them
without touching the original design. The result feels
native — you write myString.toSnakeCase() just like
any built-in String method, but you wrote it yourself.

📖 EXPLANATION:
Extensions add methods, getters, setters, and operators
to existing types — without modifying the original class,
without subclassing, and without wrapping.
Dart's own List, Iterable, and String APIs use this technique.

─────────────────────────────────────
📐 SYNTAX
─────────────────────────────────────
extension ExtensionName on ExistingType {
  ReturnType methodName(args) { ... }
  Type get getterName => ...;
  set setterName(Type value) { ... }
  ReturnType operator +(OtherType other) { ... }
}

// Anonymous extension (no name — can't be imported by name)
extension on String {
  bool get isPalindrome => this == split('').reversed.join();
}

─────────────────────────────────────
🎯 GENERIC EXTENSIONS
─────────────────────────────────────
extension ListExtensions<T> on List<T> {
  T? get secondOrNull => length >= 2 ? this[1] : null;
}

extension ComparableExtension<T extends Comparable<T>> on List<T> {
  T get median { ... }
}

─────────────────────────────────────
🔑 CONFLICTS & DISAMBIGUATION
─────────────────────────────────────
If two extensions define the same method, it's ambiguous.
Resolve by calling explicitly:
  ExtensionName(value).method()

─────────────────────────────────────
📦 EXTENSIONS ON NULLABLE TYPES
─────────────────────────────────────
extension NullableExtension on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;
}

Can be called on null without ? operator!

─────────────────────────────────────
🔧 EXTENSION TYPES (Dart 3.3)
─────────────────────────────────────
Extension types (different from extension methods) create
a NEW compile-time type wrapping an existing type.
Covered in detail in lesson 45.

💻 CODE:
void main() {
  // ── STRING EXTENSIONS ─────────
  print('hello world'.capitalize());     // Hello world
  print('hello_world'.toCamelCase());    // helloWorld
  print('helloWorld'.toSnakeCase());     // hello_world
  print('racecar'.isPalindrome);         // true
  print('hello'.isPalindrome);           // false
  print('hello@world.com'.isEmail);      // true
  print('  hello  '.truncate(5));        // hello
  print('hello world'.truncate(8));      // hello...

  // Built-in String extension from dart:core
  print('   hello   '.trim());           // hello (built-in)

  // ── INTEGER EXTENSIONS ────────
  print(5.factorial());      // 120
  print(8.isPowerOfTwo);     // true
  print(7.isPowerOfTwo);     // false
  print(255.toBinaryString()); // 11111111
  print(3.times(() => print('hi')));  // prints 'hi' 3 times
  for (final i in 5.range) {
    print(i);   // 0 1 2 3 4
  }

  // ── DURATION EXTENSIONS ───────
  // These make common Duration creation very readable:
  final delay = 5.seconds;
  final timeout = 30.minutes;
  final deadline = 2.hours + 30.minutes;

  print(delay);    // 0:00:05.000000
  print(timeout);  // 0:30:00.000000
  print(deadline); // 2:30:00.000000

  // ── LIST EXTENSIONS ───────────
  var nums = [3, 1, 4, 1, 5, 9, 2, 6, 5, 3, 5];
  print(nums.secondOrNull);    // 1
  print(nums.sum);             // 44
  print(nums.average);         // 4.0
  print(nums.distinct);        // [3, 1, 4, 5, 9, 2, 6]
  print(nums.chunked(3));      // [[3,1,4],[1,5,9],[2,6,5],[3,5]]
  print(nums.count(5));        // 3 (count occurrences)

  // ── MAP EXTENSIONS ────────────
  var scores = {'Alice': 92, 'Bob': 78, 'Carol': 95};
  print(scores.mapValues((v) => v + 5));  // all +5
  print(scores.filterValues((v) => v >= 90));  // {Alice:92, Carol:95}

  // ── NULLABLE EXTENSION ────────
  String? name = null;
  print(name.isNullOrEmpty);    // true
  name = '';
  print(name.isNullOrEmpty);    // true
  name = 'Alice';
  print(name.isNullOrEmpty);    // false

  // ── GENERIC EXTENSION ─────────
  var words = ['banana', 'apple', 'cherry'];
  print(words.sortedBy((s) => s.length));  // [apple, banana, cherry]
  print(words.groupBy((s) => s[0]));  // {b:[banana], a:[apple], c:[cherry]}

  // ── DISAMBIGUATION ─────────────
  // If two extensions conflict, be explicit:
  // ExtensionA('hello').doSomething()
  // vs
  // ExtensionB('hello').doSomething()
}

// ── STRING EXTENSIONS ──────────
extension StringExtensions on String {
  String capitalize() =>
      isEmpty ? this : '\${this[0].toUpperCase()}\${substring(1)}';

  String toCamelCase() {
    final parts = split('_');
    return parts.first + parts.skip(1).map((s) => s.capitalize()).join();
  }

  String toSnakeCase() {
    return replaceAllMapped(
      RegExp(r'[A-Z]'),
      (m) => '_\${m[0]!.toLowerCase()}',
    ).replaceFirst(RegExp(r'^_'), '');
  }

  bool get isPalindrome {
    final cleaned = toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
    return cleaned == cleaned.split('').reversed.join();
  }

  bool get isEmail =>
      RegExp(r'^[\w-\.]+@[\w-]+\.[a-zA-Z]{2,}$').hasMatch(this);

  String truncate(int maxLength, {String ellipsis = '...'}) {
    if (length <= maxLength) return this;
    return '\${substring(0, maxLength - ellipsis.length)}\$ellipsis';
  }
}

// ── NULLABLE STRING EXTENSION ──
extension NullableStringExtension on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;
  bool get isNullOrBlank => this == null || this!.trim().isEmpty;
  String get orEmpty => this ?? '';
}

// ── INTEGER EXTENSIONS ─────────
extension IntExtensions on int {
  int factorial() {
    if (this <= 1) return 1;
    return this * (this - 1).factorial();
  }

  bool get isPowerOfTwo => this > 0 && (this & (this - 1)) == 0;

  String toBinaryString() => toRadixString(2);

  void times(void Function() action) {
    for (int i = 0; i < this; i++) action();
  }

  Iterable<int> get range sync* {
    for (int i = 0; i < this; i++) yield i;
  }
}

// ── DURATION EXTENSIONS ────────
extension IntDurationExtensions on int {
  Duration get microseconds => Duration(microseconds: this);
  Duration get milliseconds => Duration(milliseconds: this);
  Duration get seconds => Duration(seconds: this);
  Duration get minutes => Duration(minutes: this);
  Duration get hours => Duration(hours: this);
  Duration get days => Duration(days: this);
}

// ── LIST EXTENSIONS ────────────
extension ListExtensions<T> on List<T> {
  T? get secondOrNull => length >= 2 ? this[1] : null;
  T? get thirdOrNull => length >= 3 ? this[2] : null;

  List<List<T>> chunked(int size) {
    final result = <List<T>>[];
    for (int i = 0; i < length; i += size) {
      result.add(sublist(i, (i + size).clamp(0, length)));
    }
    return result;
  }

  int count(T element) => where((e) => e == element).length;
}

extension NumListExtensions on List<num> {
  num get sum => fold(0, (a, b) => a + b);
  double get average => isEmpty ? 0 : sum / length;
  List<num> get distinct => toSet().toList();
}

// ── GENERIC SORT EXTENSION ─────
extension SortableListExtension<T> on List<T> {
  List<T> sortedBy<K extends Comparable<K>>(K Function(T) key) {
    final copy = List<T>.from(this);
    copy.sort((a, b) => key(a).compareTo(key(b)));
    return copy;
  }

  Map<K, List<T>> groupBy<K>(K Function(T) key) {
    final result = <K, List<T>>{};
    for (final item in this) {
      result.putIfAbsent(key(item), () => []).add(item);
    }
    return result;
  }
}

// ── MAP EXTENSIONS ─────────────
extension MapExtensions<K, V> on Map<K, V> {
  Map<K, R> mapValues<R>(R Function(V) transform) =>
      map((k, v) => MapEntry(k, transform(v)));

  Map<K, V> filterValues(bool Function(V) predicate) =>
      {for (final e in entries.where((e) => predicate(e.value))) e.key: e.value};
}

📝 KEY POINTS:
✅ Extensions add methods to existing types without modifying them
✅ Extension methods look and feel exactly like built-in methods
✅ Named extensions can be imported/hidden like regular APIs
✅ Anonymous extensions (no name) work only in the same file
✅ Generic extensions work with any type parameter
✅ Extensions on nullable types (String?) can be called on null values
✅ The extension sees this — the object the extension is called on
✅ Conflicts between extensions require explicit disambiguation
❌ Extensions cannot add instance variables (only methods, getters, setters, operators)
❌ Extension methods have lower priority than class methods — a class method always wins
❌ Extensions don't work with dynamic — the type must be known at compile time
''',
  quiz: [
    Quiz(question: 'What can extension methods NOT add to a type?', options: [
      QuizOption(text: 'Getters', correct: false),
      QuizOption(text: 'Instance variables (fields)', correct: true),
      QuizOption(text: 'Operators', correct: false),
      QuizOption(text: 'Methods', correct: false),
    ]),
    Quiz(question: 'If a class already has a method and an extension defines the same method, which wins?', options: [
      QuizOption(text: 'The extension method — it always overrides', correct: false),
      QuizOption(text: 'The class method — class methods always have higher priority', correct: true),
      QuizOption(text: 'A compile error is produced', correct: false),
      QuizOption(text: 'The last one defined wins', correct: false),
    ]),
    Quiz(question: 'What is the advantage of "extension on String?" over "extension on String"?', options: [
      QuizOption(text: 'It works faster on string operations', correct: false),
      QuizOption(text: 'The method can be called directly on null values without the ?. operator', correct: true),
      QuizOption(text: 'It automatically null-checks the string', correct: false),
      QuizOption(text: 'There is no difference', correct: false),
    ]),
  ],
);
