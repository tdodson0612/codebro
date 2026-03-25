import '../../models/lesson.dart';
import '../../models/quiz.dart';

final dartLesson28 = Lesson(
  language: 'Dart',
  title: 'Patterns (Dart 3)',
  content: '''
🎯 METAPHOR:
Patterns are like smart sorting machines at a postal center.
A regular variable assignment just says "put this in the bin."
A pattern says "if this package has a weight over 10kg AND
is marked fragile AND is addressed to Zone A — put it in
the special handling bin, and label it with its tracking number."
Patterns match on STRUCTURE, not just value — and they can
simultaneously check, destructure, and bind, all in one
elegant expression. Dart 3's patterns bring this to variables,
switch statements, for-in loops, and if statements.

📖 EXPLANATION:
Patterns are a Dart 3 feature that enables structural matching
and destructuring. They can be used in variable declarations,
switch expressions/statements, and if-case statements.
Patterns match values, check types, destructure records and
objects, and bind variables — all simultaneously.

─────────────────────────────────────
📐 PATTERN TYPES
─────────────────────────────────────
Literal:      case 42:     case 'hello':   case true:
Variable:     case var x:  → captures to x
Wildcard:     case _:      → matches anything, discards
Identifier:   case n:      → final binding
Typed:        case String s: → type check + bind
Null-check:   case x?      → matches if non-null, binds
Null-assert:  case x!      → must be non-null, binds
Logical-and:  case p1 && p2
Logical-or:   case p1 || p2
Cast:         case x as Type
Const:        case const MyConst:
Record:       case (int x, String y):
Object:       case MyClass(:field1, :field2):
List:         case [first, ...rest]:
Map:          case {'key': value}:

─────────────────────────────────────
🔑 WHERE PATTERNS ARE USED
─────────────────────────────────────
1. Variable declarations:
   var (a, b) = (1, 2);
   final [first, ...rest] = myList;

2. Switch expressions:
   switch (value) {
     case Pattern => result,
   }

3. Switch statements:
   switch (value) {
     case Pattern:
       body;
   }

4. If-case statements:
   if (value case Pattern when guard) { ... }

5. For-in loops:
   for (final (key, value) in map.entries) { ... }

─────────────────────────────────────
🎯 DESTRUCTURING PATTERNS
─────────────────────────────────────
Record:
  var (x, y) = (1, 2);           // positional
  var (name: n, age: a) = rec;   // named
  var (:name, :age) = rec;       // shorthand

List:
  var [first, second, ...rest] = list;
  var [a, b] = twoElementList;

Map:
  var {'key1': v1, 'key2': v2} = myMap;

Object:
  var MyClass(:field1, :field2) = obj;

💻 CODE:
void main() {
  // ── VARIABLE DECLARATION PATTERNS ─

  // Record destructuring
  var (x, y) = (10, 20);
  print('x=\$x, y=\$y');   // x=10, y=20

  // Named record
  var (:name, :age) = (name: 'Alice', age: 30);
  print('\$name is \$age');   // Alice is 30

  // List patterns
  var [first, second, ...rest] = [1, 2, 3, 4, 5];
  print('first=\$first, second=\$second, rest=\$rest');
  // first=1, second=2, rest=[3, 4, 5]

  var [head, ...tail] = ['a', 'b', 'c', 'd'];
  print('head=\$head, tail=\$tail');   // head=a, tail=[b, c, d]

  var [...init, last] = [10, 20, 30, 40];
  print('init=\$init, last=\$last');   // init=[10,20,30], last=40

  // Map patterns
  var {'name': n, 'score': s} = {'name': 'Bob', 'score': 95};
  print('\$n: \$s');   // Bob: 95

  // Swap variables with record pattern!
  var a = 1, b = 2;
  (a, b) = (b, a);   // elegant swap
  print('a=\$a, b=\$b');   // a=2, b=1

  // ── SWITCH WITH PATTERNS ───────

  // Type patterns
  Object value = 42;
  switch (value) {
    case int n when n > 0:
      print('Positive int: \$n');   // ← this
    case int n:
      print('Non-positive int: \$n');
    case String s:
      print('String: \$s');
    case _:
      print('Unknown');
  }

  // Record pattern in switch
  var point = (x: 0, y: 5);
  String description = switch (point) {
    (x: 0, y: 0) => 'Origin',
    (x: 0, y: _) => 'On Y-axis',    // ← matches
    (x: _, y: 0) => 'On X-axis',
    (x: var px, y: var py) when px == py => 'On diagonal',
    _ => 'Other point',
  };
  print(description);   // On Y-axis

  // List pattern in switch
  List<int> nums = [1, 2, 3];
  String listDesc = switch (nums) {
    [] => 'Empty',
    [int only] => 'One: \$only',
    [int f, int s] => 'Two: \$f, \$s',
    [int f, _, ...] => 'Many, starts with \$f',   // ← this
  };
  print(listDesc);   // Many, starts with 1

  // Object pattern
  var user = User(name: 'Alice', age: 30, role: Role.admin);
  String access = switch (user) {
    User(role: Role.admin) => 'Full access',   // ← this
    User(role: Role.editor, age: >= 18) => 'Editor access',
    User(role: Role.viewer) => 'Read only',
    _ => 'No access',
  };
  print(access);   // Full access

  // ── IF-CASE ────────────────────
  Object raw = [1, 2, 3];
  if (raw case List<int> nums when nums.length > 2) {
    print('Got \${nums.length} ints: \$nums');   // ← matches
  }

  Object data = (name: 'Bob', score: 78);
  if (data case (name: String n, score: int s) when s >= 70) {
    print('\$n passed with \$s');   // Bob passed with 78
  }

  // ── FOR-IN WITH PATTERNS ───────
  Map<String, int> scores = {'Alice': 92, 'Bob': 78, 'Carol': 95};
  for (final MapEntry(:key, :value) in scores.entries) {
    print('\$key: \$value');
  }

  // Record list
  List<(String, int)> pairs = [('Alice', 1), ('Bob', 2)];
  for (final (name, id) in pairs) {
    print('\$id: \$name');
  }

  // ── LOGICAL PATTERNS ──────────
  int n = 15;
  // logical-or pattern
  String category = switch (n) {
    1 || 2 || 3 => 'Small',
    >= 10 && <= 20 => 'Medium',   // logical-and with guard
    > 20 => 'Large',
    _ => 'Other',
  };
  print(category);   // Medium

  // ── NULL-CHECK PATTERN ─────────
  String? maybeStr = 'hello';
  if (maybeStr case var s?) {    // ? = null-check pattern
    print('Non-null: \${s.toUpperCase()}');   // HELLO
  }

  String? nullStr = null;
  if (nullStr case var s?) {
    print('This won\'t print');
  } else {
    print('Was null');   // ← this
  }

  // ── NESTED PATTERNS ────────────
  List<(String, List<int>)> data2 = [
    ('Alice', [90, 85, 92]),
    ('Bob', [78, 80]),
  ];

  for (final (studentName, [first2, ...grades]) in data2) {
    print('\$studentName first grade: \$first2, others: \$grades');
  }

  // ── CONST PATTERNS ─────────────
  const pi = 3.14;
  double val = 3.14;
  switch (val) {
    case pi:
      print('Exactly pi!');   // ← matches
    default:
      print('Not pi');
  }
}

class User {
  final String name;
  final int age;
  final Role role;
  const User({required this.name, required this.age, required this.role});
}

enum Role { admin, editor, viewer }

📝 KEY POINTS:
✅ Patterns can match type, structure, and value simultaneously
✅ Record patterns: var (x, y) = point; var (:name, :age) = person;
✅ List patterns: var [first, ...rest] = list; with spread
✅ Object patterns: case MyClass(:field) matches class instances
✅ Map patterns: var {'key': value} = map;
✅ Logical-or (||) and logical-and (&&) combine patterns
✅ Wildcard _ matches anything and discards the value
✅ var x? in patterns is a null-check (only matches non-null)
✅ Patterns work in switch, if-case, for-in, and variable declarations
❌ Pattern variables are final by default in switch cases
❌ Object patterns require the class to expose the fields (or use getters)
❌ List patterns require exact length unless ... spread is used
''',
  quiz: [
    Quiz(question: 'What does var (:name, :age) = person; do in Dart 3?', options: [
      QuizOption(text: 'Creates a record with name and age fields', correct: false),
      QuizOption(text: 'Destructures the record person, binding its name and age fields to local variables', correct: true),
      QuizOption(text: 'Copies person into two separate variables', correct: false),
      QuizOption(text: 'Checks if person has name and age fields', correct: false),
    ]),
    Quiz(question: 'In a list pattern var [first, ...rest] = list, what does ...rest capture?', options: [
      QuizOption(text: 'Only the last element', correct: false),
      QuizOption(text: 'All elements after first, as a List', correct: true),
      QuizOption(text: 'The length of the remaining elements', correct: false),
      QuizOption(text: 'A lazy Iterable of remaining elements', correct: false),
    ]),
    Quiz(question: 'What does "case String s when s.length > 5" match?', options: [
      QuizOption(text: 'Any String', correct: false),
      QuizOption(text: 'Any String with more than 5 characters, binding it to s', correct: true),
      QuizOption(text: 'Only Strings of exactly 5 characters', correct: false),
      QuizOption(text: 'Any value longer than 5 characters', correct: false),
    ]),
  ],
);