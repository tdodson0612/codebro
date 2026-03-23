import '../../models/lesson.dart';
import '../../models/quiz.dart';

final dartLesson18 = Lesson(
  language: 'Dart',
  title: 'Generics',
  content: '''
🎯 METAPHOR:
Generics are like labeled containers at a shipping warehouse.
An untyped container (dynamic list) can hold anything —
books, hammers, fruit — but nobody knows what's inside
without opening it. A labeled container (generic List<Book>)
declares exactly what it holds. The warehouse system
(type checker) ensures only books go in, and when you
take something out, you KNOW it's a book — no inspection
needed. This is type-safe reuse: the same container design
works for books OR hammers, but each container only holds
one type.

📖 EXPLANATION:
Generics allow writing type-safe code that works with
multiple types. List<T>, Map<K, V>, and Future<T> are all
generic. You can create your own generic classes, mixins,
extensions, and functions. Dart's generics are REIFIED
(available at runtime) — unlike Java's type erasure.

─────────────────────────────────────
📐 GENERIC SYNTAX
─────────────────────────────────────
// Generic class
class Box<T> {
  T value;
  Box(this.value);
}

// Generic function
T identity<T>(T value) => value;

// Multiple type parameters
class Pair<A, B> {
  A first;
  B second;
  Pair(this.first, this.second);
}

// Bounded type parameter
class SortedList<T extends Comparable<T>> { ... }

─────────────────────────────────────
🔑 USING GENERICS
─────────────────────────────────────
var intBox = Box<int>(42);
var strBox = Box<String>('hello');
var numList = <num>[1, 2, 3.0];

// Inference — type often inferred:
var box = Box(42);   // inferred as Box<int>

─────────────────────────────────────
🔒 BOUNDED TYPE PARAMETERS
─────────────────────────────────────
T extends SomeType constrains T:
  class Cache<T extends Serializable> { ... }
  // T must be Serializable or a subtype

─────────────────────────────────────
📋 GENERIC METHODS
─────────────────────────────────────
void printAll<T>(List<T> items) {
  for (var item in items) print(item);
}

// Dart can infer T from the argument:
printAll([1, 2, 3]);   // T inferred as int

─────────────────────────────────────
🔄 REIFIED GENERICS
─────────────────────────────────────
Unlike Java, Dart keeps type info at runtime:
  var list = <String>[];
  print(list is List<String>);  // true! (Java: would be just List)
  print(list.runtimeType);      // List<String>

─────────────────────────────────────
🌊 COVARIANCE & CONTRAVARIANCE
─────────────────────────────────────
List<String> is NOT a subtype of List<Object>
(even though String is a subtype of Object).
This prevents type safety violations.

Exception: function return types are covariant.

💻 CODE:
void main() {
  // ── BUILT-IN GENERIC TYPES ────
  List<int> ints = [1, 2, 3];
  List<String> strs = ['a', 'b', 'c'];
  Map<String, int> scores = {'Alice': 90, 'Bob': 85};
  Set<double> temps = {98.6, 37.0, 100.4};

  // Type safety
  ints.add(42);       // ✅
  // ints.add('hello'); // ❌ compile error!

  // ── GENERIC CLASS ─────────────
  var intBox = Box<int>(42);
  var strBox = Box<String>('Hello');
  var listBox = Box<List<int>>([1, 2, 3]);

  print(intBox.value);      // 42
  print(strBox.value);      // Hello
  print(intBox.runtimeType); // Box<int>

  // Type inference
  var inferredBox = Box(99);    // Box<int> inferred
  print(inferredBox.value * 2); // 198

  // ── GENERIC PAIR ──────────────
  var pair = Pair<String, int>('age', 30);
  var coords = Pair(3.14, 2.71);  // Pair<double, double> inferred

  print(pair.first);   // age
  print(pair.second);  // 30

  var swapped = pair.swap();
  print(swapped.first);   // 30
  print(swapped.second);  // age

  // ── GENERIC FUNCTIONS ─────────
  print(identity(42));         // 42 (T inferred as int)
  print(identity('hello'));    // hello (T inferred as String)

  List<int> nums = [3, 1, 4, 1, 5, 9];
  print(firstOrNull(nums));    // 3
  print(firstOrNull(<int>[]));  // null

  printAll(['apple', 'banana', 'cherry']);
  printAll([1, 2, 3]);

  // ── BOUNDED GENERICS ──────────
  var sorted = SortedList<String>();
  sorted.add('banana');
  sorted.add('apple');
  sorted.add('cherry');
  print(sorted.toList());   // [apple, banana, cherry]

  // Cannot use non-Comparable types:
  // SortedList<Map>()  // ❌ Map doesn't extend Comparable

  // ── GENERIC STACK ─────────────
  var stack = Stack<int>();
  stack.push(1);
  stack.push(2);
  stack.push(3);
  print(stack.pop());    // 3
  print(stack.peek());   // 2
  print(stack.size);     // 2
  print(stack.isEmpty);  // false

  // Type-safe — can only push/pop int
  var strStack = Stack<String>();
  strStack.push('hello');
  strStack.push('world');
  print(strStack.pop());  // world

  // ── GENERIC RESULT TYPE ───────
  var ok = Result<int>.ok(42);
  var err = Result<int>.error('something went wrong');

  print(ok.isSuccess);    // true
  print(ok.value);        // 42
  print(err.isSuccess);   // false
  print(err.errorMessage); // something went wrong

  // Pattern match on generic result
  switch (ok) {
    case Result(:final value) when value != null:
      print('Got: \$value');
    case Result(:final errorMessage):
      print('Error: \$errorMessage');
  }

  // ── REIFIED GENERICS ──────────
  var intList = <int>[1, 2, 3];
  var strList = <String>['a', 'b'];
  var objList = <Object>[1, 'a', true];

  print(intList is List<int>);    // true
  print(intList is List<String>); // false
  print(intList is List<Object>); // false! (covariance issue)
  print(intList is List);         // true (raw type check)

  print(intList.runtimeType);     // List<int>

  // Type-safe casting
  Object obj = [1, 2, 3];
  if (obj is List<int>) {
    print(obj.reduce((a, b) => a + b));  // 6 — type-safe!
  }

  // ── GENERIC EXTENSION ─────────
  var data = [3, 1, 4, 1, 5, 9, 2, 6];
  print(data.second);  // 1 (using generic extension)

  var words = ['hello', 'world'];
  print(words.second);  // world
}

// ── GENERIC CLASS ──────────────
class Box<T> {
  final T value;
  Box(this.value);

  Box<R> transform<R>(R Function(T) mapper) {
    return Box(mapper(value));
  }

  @override
  String toString() => 'Box<\${T}>(\$value)';
}

// ── GENERIC PAIR ──────────────
class Pair<A, B> {
  final A first;
  final B second;

  const Pair(this.first, this.second);

  Pair<B, A> swap() => Pair(second, first);

  @override
  String toString() => 'Pair(\$first, \$second)';
}

// ── GENERIC FUNCTIONS ──────────
T identity<T>(T value) => value;

T? firstOrNull<T>(List<T> list) => list.isEmpty ? null : list.first;

void printAll<T>(Iterable<T> items) {
  for (var item in items) {
    print(item);
  }
}

// ── BOUNDED GENERIC ────────────
class SortedList<T extends Comparable<T>> {
  final List<T> _data = [];

  void add(T item) {
    _data.add(item);
    _data.sort();
  }

  List<T> toList() => List.unmodifiable(_data);
}

// ── GENERIC STACK ──────────────
class Stack<T> {
  final List<T> _items = [];

  void push(T item) => _items.add(item);

  T pop() {
    if (isEmpty) throw StateError('Stack is empty');
    return _items.removeLast();
  }

  T peek() {
    if (isEmpty) throw StateError('Stack is empty');
    return _items.last;
  }

  bool get isEmpty => _items.isEmpty;
  int get size => _items.length;
}

// ── GENERIC RESULT TYPE ────────
class Result<T> {
  final T? value;
  final String? errorMessage;

  const Result._({this.value, this.errorMessage});

  factory Result.ok(T value) => Result._(value: value);
  factory Result.error(String msg) => Result._(errorMessage: msg);

  bool get isSuccess => errorMessage == null;

  R when<R>({
    required R Function(T value) ok,
    required R Function(String error) error,
  }) {
    if (isSuccess) return ok(value as T);
    return error(errorMessage!);
  }
}

// ── GENERIC EXTENSION ──────────
extension ListExtension<T> on List<T> {
  T? get second => length >= 2 ? this[1] : null;
  T? get third  => length >= 3 ? this[2] : null;
}

📝 KEY POINTS:
✅ Generics enable type-safe reuse across different types
✅ Dart generics are REIFIED — type info is available at runtime
✅ Type inference often infers T: Box(42) is Box<int>
✅ T extends SomeType bounds the type parameter
✅ Generic methods can infer T from arguments
✅ List<String> is NOT a subtype of List<Object> — no variance issues
✅ You can make generic classes, functions, extensions, and mixins
✅ Multiple type params: class Pair<A, B> { }
❌ Don't use dynamic when you can use generics — you lose type safety
❌ Bounded type parameters must use extends even for interfaces
❌ Cannot use T() to call constructors on generic types in Dart
''',
  quiz: [
    Quiz(question: 'What does "T extends Comparable<T>" as a type bound mean?', options: [
      QuizOption(text: 'T must be a subclass of T (recursive)', correct: false),
      QuizOption(text: 'T must implement Comparable<T> — allowing comparison operations', correct: true),
      QuizOption(text: 'T must extend the Comparable class through inheritance', correct: false),
      QuizOption(text: 'T can only be numeric types', correct: false),
    ]),
    Quiz(question: 'Are Dart generics reified?', options: [
      QuizOption(text: 'No — type info is erased at runtime like Java', correct: false),
      QuizOption(text: 'Yes — type info is preserved at runtime: List<String> is List<String> at runtime', correct: true),
      QuizOption(text: 'Only for built-in types like List and Map', correct: false),
      QuizOption(text: 'Only when using the dart:mirrors library', correct: false),
    ]),
    Quiz(question: 'Is List<String> a subtype of List<Object> in Dart?', options: [
      QuizOption(text: 'Yes — since String is a subtype of Object', correct: false),
      QuizOption(text: 'No — generic types are invariant in Dart', correct: true),
      QuizOption(text: 'Yes, but only in read-only contexts', correct: false),
      QuizOption(text: 'It depends on the Dart version', correct: false),
    ]),
  ],
);
