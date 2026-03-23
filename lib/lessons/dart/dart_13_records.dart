import '../../models/lesson.dart';
import '../../models/quiz.dart';

final dartLesson13 = Lesson(
  language: 'Dart',
  title: 'Records (Dart 3)',
  content: '''
🎯 METAPHOR:
A Record is like a labeled receipt.
When you buy multiple items in a store, the receipt groups
them: "Item 1: Coffee, Item 2: Croissant — Total: \$8.50."
The receipt is a lightweight, anonymous bundle of facts.
Unlike a class (a formal registered business entity),
a Record is informal — you create it right there without
declaring a type first. Named fields are like labeled
items on the receipt: (coffee: 5.50, croissant: 3.00).
Records are immutable, structurally typed, and perfect
for returning multiple values from a function.

📖 EXPLANATION:
Records (added in Dart 3.0) are anonymous, immutable,
aggregate types. They bundle multiple values together
without creating a class. Records have structural equality
(two records with the same fields and values are equal).

─────────────────────────────────────
📐 SYNTAX
─────────────────────────────────────
// Positional record (anonymous)
(int, String) point = (42, 'origin');

// Named fields
({String name, int age}) person = (name: 'Alice', age: 30);

// Mix of positional and named
(int, {String label}) labeled = (42, label: 'answer');

─────────────────────────────────────
🔑 ACCESSING FIELDS
─────────────────────────────────────
Positional: record.\$1, record.\$2, record.\$3, ...
Named:      record.name, record.age

(int, String) point = (1, 'A');
print(point.\$1);   // 1
print(point.\$2);   // A

({String name, int age}) person = (name: 'Alice', age: 30);
print(person.name);  // Alice
print(person.age);   // 30

─────────────────────────────────────
🔀 DESTRUCTURING RECORDS
─────────────────────────────────────
var (x, y) = (10, 20);           // positional
var (name: n, age: a) = person;  // named
var (name: String n, :age) = p;  // with type / shorthand

─────────────────────────────────────
✅ STRUCTURAL EQUALITY
─────────────────────────────────────
Records with the same type and values are equal:
  (1, 'a') == (1, 'a')   → true
  (name: 'Alice') == (name: 'Alice')  → true

─────────────────────────────────────
🎯 PRIMARY USE CASE: MULTIPLE RETURNS
─────────────────────────────────────
(int, String) divmod(int a, int b) {
  return (a ~/ b, (a % b).toString());
}

var (quotient, remainder) = divmod(17, 5);
// quotient=3, remainder='2'

─────────────────────────────────────
📋 RECORDS vs CLASSES vs MAPS
─────────────────────────────────────
Record:  lightweight, anonymous, immutable, structural equality
Class:   named type, methods, inheritance, mutable
Map:     dynamic keys, runtime errors, no static typing

💻 CODE:
void main() {
  // ── CREATING RECORDS ──────────

  // Positional fields
  (int, String) coord = (42, 'North');
  (double, double) point = (3.14, 2.71);
  (String, int, bool) user = ('Alice', 30, true);

  print(coord);   // (42, North)
  print(point);   // (3.14, 2.71)

  // Named fields
  ({String name, int age}) person = (name: 'Alice', age: 30);
  ({double x, double y}) origin = (x: 0.0, y: 0.0);

  print(person);   // (name: Alice, age: 30)
  print(origin);   // (x: 0.0, y: 0.0)

  // Mixed: positional + named
  (int, {String label, bool active}) item = (
    99,
    label: 'Widget',
    active: true,
  );
  print(item);   // (99, label: Widget, active: true)

  // ── ACCESSING FIELDS ──────────

  // Positional: \$1, \$2, \$3, ...
  print(coord.\$1);   // 42
  print(coord.\$2);   // North
  print(user.\$1);    // Alice
  print(user.\$2);    // 30
  print(user.\$3);    // true

  // Named fields: .fieldName
  print(person.name);   // Alice
  print(person.age);    // 30
  print(item.label);    // Widget
  print(item.active);   // true
  print(item.\$1);       // 99 (positional)

  // ── DESTRUCTURING ─────────────

  // Positional destructuring
  var (x, y) = point;
  print('x=\$x, y=\$y');   // x=3.14, y=2.71

  var (name, age, isActive) = user;
  print('\$name, \$age, \$isActive');   // Alice, 30, true

  // Named destructuring
  var (name: personName, age: personAge) = person;
  print('\$personName is \$personAge');   // Alice is 30

  // Shorthand (when variable name matches field name)
  var (:name, :age) = person;   // same as above
  print('\$name: \$age');   // Alice: 30

  // In for loops
  List<({String name, int score})> results = [
    (name: 'Alice', score: 92),
    (name: 'Bob', score: 78),
    (name: 'Carol', score: 95),
  ];

  for (final (:name, :score) in results) {
    print('\$name: \$score');
  }

  // ── STRUCTURAL EQUALITY ───────
  var r1 = (1, 'hello');
  var r2 = (1, 'hello');
  var r3 = (1, 'world');

  print(r1 == r2);   // true  — same values!
  print(r1 == r3);   // false — different values

  var n1 = (name: 'Alice', age: 30);
  var n2 = (name: 'Alice', age: 30);
  print(n1 == n2);   // true

  // ── MULTIPLE RETURN VALUES ─────
  // Old way: return a list or create a class
  // New way: return a record!

  var (quot, rem) = divmod(17, 5);
  print('17 ÷ 5 = \$quot remainder \$rem');   // 17 ÷ 5 = 3 remainder 2

  var (:min, :max, :sum, :count) = analyzeList([3, 1, 4, 1, 5, 9, 2]);
  print('min=\$min, max=\$max, sum=\$sum, count=\$count');

  // ── RECORDS IN PATTERN MATCHING ──
  Object data = (42, 'hello');

  switch (data) {
    case (int n, String s) when n > 0:
      print('Positive int \$n and string \$s');   // ← matches
    case (int n, String s):
      print('Non-positive int \$n');
    case _:
      print('Something else');
  }

  // ── RECORD TYPES ──────────────
  // You can create type aliases for records:
  // (see typedefs lesson for full coverage)
  // typedef Point = (double x, double y);  // Dart 3.3+

  // ── RECORDS IN MAPS ───────────
  Map<String, (int score, String grade)> report = {
    'Alice': (92, 'A'),
    'Bob':   (78, 'C'),
    'Carol': (95, 'A'),
  };

  for (final entry in report.entries) {
    final (score, grade) = entry.value;
    print('\${entry.key}: \$score (\$grade)');
  }

  // ── IMMUTABILITY ──────────────
  var rec = (name: 'Alice', age: 30);
  // rec.name = 'Bob';  // ❌ Records are immutable!
  // Fields can't be changed — create a new record
}

// Multiple return values with records
(int, int) divmod(int a, int b) => (a ~/ b, a % b);

({int min, int max, int sum, int count}) analyzeList(List<int> nums) {
  return (
    min: nums.reduce((a, b) => a < b ? a : b),
    max: nums.reduce((a, b) => a > b ? a : b),
    sum: nums.reduce((a, b) => a + b),
    count: nums.length,
  );
}

// Records as function parameters
String formatCoord((double lat, double lng) coord) {
  return '\${coord.\$1}°N, \${coord.\$2}°E';
}

📝 KEY POINTS:
✅ Records are lightweight, anonymous, immutable bundles of values
✅ Positional fields accessed via .\$1 .\$2 .\$3 etc.
✅ Named fields accessed via .fieldName
✅ Records have STRUCTURAL equality — same fields & values means equal
✅ Perfect for returning multiple values from functions
✅ Destructuring: var (x, y) = point; or var (:name, :age) = person;
✅ Records work in for-in, switch cases, and pattern matching
✅ Collection literals can contain records as elements
❌ Records are immutable — you cannot change field values after creation
❌ Positional fields are .\$1 .\$2 (1-indexed), not [0] [1] (0-indexed)
❌ Records with different field names are different types even if values match
''',
  quiz: [
    Quiz(question: 'How do you access the second positional field of a record in Dart?', options: [
      QuizOption(text: 'record[1]', correct: false),
      QuizOption(text: 'record.\$2', correct: true),
      QuizOption(text: 'record.second', correct: false),
      QuizOption(text: 'record.get(1)', correct: false),
    ]),
    Quiz(question: 'What does structural equality mean for records?', options: [
      QuizOption(text: 'Two records with the same type name are equal', correct: false),
      QuizOption(text: 'Two records are equal if they have the same fields and values, regardless of which variable they are stored in', correct: true),
      QuizOption(text: 'Records compare by reference like class instances', correct: false),
      QuizOption(text: 'Equality is only defined for records with named fields', correct: false),
    ]),
    Quiz(question: 'What is the primary use case for records in Dart?', options: [
      QuizOption(text: 'Replacing classes for complex objects with methods', correct: false),
      QuizOption(text: 'Returning multiple typed values from a function without creating a class', correct: true),
      QuizOption(text: 'Creating mutable data containers', correct: false),
      QuizOption(text: 'Storing large collections of data', correct: false),
    ]),
  ],
);
