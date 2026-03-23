import '../../models/lesson.dart';
import '../../models/quiz.dart';

final dartLesson07 = Lesson(
  language: 'Dart',
  title: 'Operators',
  content: '''
🎯 METAPHOR:
Operators are the verbs of Dart's sentence structure.
Just as language has verbs (add, compare, negate), Dart has
operators that act on values. Some are intuitive (+ - * /),
some are Dart-specific (?? ?. ~/ >>>), and some can be
overloaded — you teach YOUR objects what + or == means for them.
The cascade operator .. is particularly elegant: it lets
you call multiple methods on the same object without
repeating its name, like signing a form once and then
filling all the fields.

📖 EXPLANATION:
Dart has a rich set of operators, many inherited from C-family
languages plus unique additions for null safety and cascades.
All operators are actually method calls — a + b calls a.operator+(b).

─────────────────────────────────────
🔢 ARITHMETIC
─────────────────────────────────────
+    addition        5 + 3 → 8
-    subtraction     5 - 3 → 2
*    multiplication  5 * 3 → 15
/    division        5 / 2 → 2.5  (always double!)
~/   int division    5 ~/ 2 → 2   (truncates to int)
%    modulo          5 % 2 → 1    (remainder)
-x   negation        -(5) → -5
++x  pre-increment   ++a (increment, then return)
x++  post-increment  a++ (return, then increment)
--x  pre-decrement
x--  post-decrement

─────────────────────────────────────
⚖️  COMPARISON
─────────────────────────────────────
==   equal          (checks value, not reference for most types)
!=   not equal
<    less than
>    greater than
<=   less or equal
>=   greater or equal

─────────────────────────────────────
🔠 TYPE OPERATORS
─────────────────────────────────────
is   type test      obj is String → true/false
is!  not type test  obj is! String → true if NOT String
as   type cast      (obj as String).length

─────────────────────────────────────
🔗 LOGICAL
─────────────────────────────────────
&&   AND (short-circuit)
||   OR  (short-circuit)
!    NOT

─────────────────────────────────────
🔢 BITWISE
─────────────────────────────────────
&    bitwise AND
|    bitwise OR
^    bitwise XOR
~    bitwise NOT (complement)
<<   left shift
>>   right shift
>>>  unsigned right shift (Dart 2.14+)

─────────────────────────────────────
📋 ASSIGNMENT
─────────────────────────────────────
=    assign
+=   add and assign
-=   subtract and assign
*=   multiply and assign
/=   divide and assign
~/=  int-divide and assign
%=   modulo and assign
??=  assign if null
&=  |=  ^=  <<=  >>=  >>>=   bitwise compound assignment

─────────────────────────────────────
🌊 CASCADE OPERATOR ..
─────────────────────────────────────
.. calls multiple methods on the same object, returning
the original object. Perfect for builder patterns.

StringBuffer sb = StringBuffer();
sb.write('Hello');
sb.write(', ');
sb.write('World');

// Same with cascade:
StringBuffer sb2 = StringBuffer()
  ..write('Hello')
  ..write(', ')
  ..write('World');

?.  is the null-safe cascade:
  obj?..method()  → only cascades if obj is not null

─────────────────────────────────────
🔀 TERNARY & SPREAD
─────────────────────────────────────
condition ? a : b      → ternary
...list                → spread operator (in collections)
...?nullableList       → null-aware spread

─────────────────────────────────────
🎯 OPERATOR PRECEDENCE (high → low)
─────────────────────────────────────
unary postfix  (++ -- . ?. !)
unary prefix   (- ! ~ ++ --)
multiplicative (* / ~/ %)
additive       (+ -)
shift          (<< >> >>>)
bitwise AND    (&)
bitwise XOR    (^)
bitwise OR     (|)
comparison     (< > <= >= as is is!)
equality       (== !=)
logical AND    (&&)
logical OR     (||)
if-null        (??)
ternary        (? :)
cascade        (..)
assignment     (= += -= etc.)

💻 CODE:
void main() {
  // ── ARITHMETIC ────────────────
  print(10 + 3);    // 13
  print(10 - 3);    // 7
  print(10 * 3);    // 30
  print(10 / 3);    // 3.3333... (double always)
  print(10 ~/ 3);   // 3 (integer division)
  print(10 % 3);    // 1 (remainder)
  print(-(-5));      // 5 (negation)

  int a = 5;
  print(++a);   // 6  (increment first, then use)
  print(a++);   // 6  (use first, then increment)
  print(a);     // 7  (now it's 7)
  print(--a);   // 6  (decrement first, then use)

  // ── COMPARISON ────────────────
  print(5 == 5);   // true
  print(5 != 4);   // true
  print(5 > 3);    // true
  print(5 < 3);    // false
  print(5 >= 5);   // true
  print(5 <= 4);   // false

  // String comparison
  print('abc' == 'abc');   // true
  print('abc' == 'ABC');   // false

  // ── TYPE OPERATORS ────────────
  Object val = 'hello';

  if (val is String) {
    print('It is a String: \${val.length} chars'); // promoted!
  }
  if (val is! int) {
    print('Not an int');
  }

  // as cast
  String str = val as String;
  print(str.toUpperCase());   // HELLO

  // Safe cast pattern
  dynamic d = 42;
  String? safe = d is String ? d : null;
  print(safe);  // null (42 is not a String)

  // ── LOGICAL ───────────────────
  bool x = true, y = false;
  print(x && y);    // false
  print(x || y);    // true
  print(!x);        // false

  // Short-circuit: right side not evaluated if unnecessary
  bool? result = false && _expensive(); // _expensive() NOT called!
  result = true || _expensive();        // _expensive() NOT called!

  // ── BITWISE ───────────────────
  print(5 & 3);   // 1   (0101 & 0011 = 0001)
  print(5 | 3);   // 7   (0101 | 0011 = 0111)
  print(5 ^ 3);   // 6   (0101 ^ 0011 = 0110)
  print(~5);      // -6  (bitwise NOT, two's complement)
  print(1 << 3);  // 8   (left shift: 1 × 2³)
  print(8 >> 2);  // 2   (right shift: 8 ÷ 2²)
  print(-8 >>> 1);// large positive (unsigned right shift)

  // Flag pattern with bitwise
  const int READ    = 1 << 0;   // 1
  const int WRITE   = 1 << 1;   // 2
  const int EXECUTE = 1 << 2;   // 4

  int perms = READ | WRITE;
  print((perms & READ) != 0);     // true — has READ
  print((perms & EXECUTE) != 0);  // false — no EXECUTE
  perms |= EXECUTE;               // grant execute
  print((perms & EXECUTE) != 0);  // true

  // ── ASSIGNMENT ────────────────
  int n = 10;
  n += 5;   print(n);   // 15
  n -= 3;   print(n);   // 12
  n *= 2;   print(n);   // 24
  n ~/= 5;  print(n);   // 4
  n %= 3;   print(n);   // 1

  // ── NULL-AWARE ────────────────
  String? name = null;
  name ??= 'Default';    // assign if null
  print(name);           // Default

  String? city;
  String result2 = city ?? 'Unknown';  // use Default
  print(result2);   // Unknown

  // ── TERNARY ───────────────────
  int score = 85;
  String grade = score >= 90 ? 'A' : score >= 80 ? 'B' : 'C';
  print(grade);  // B

  // ── CASCADE .. ─────────────────
  // Without cascade:
  StringBuffer sb1 = StringBuffer();
  sb1.write('Hello');
  sb1.write(', ');
  sb1.write('World');
  sb1.write('!');

  // With cascade (same result, less repetition):
  StringBuffer sb2 = StringBuffer()
    ..write('Hello')
    ..write(', ')
    ..write('World')
    ..write('!');

  print(sb1.toString());   // Hello, World!
  print(sb2.toString());   // Hello, World!

  // Null-safe cascade
  StringBuffer? maybeSb;
  maybeSb?.write('ignored');   // null-safe, does nothing
  print(maybeSb);              // null

  // ── SPREAD ────────────────────
  List<int> a2 = [1, 2, 3];
  List<int> b2 = [4, 5, 6];
  List<int> merged = [...a2, ...b2];
  print(merged);  // [1, 2, 3, 4, 5, 6]

  List<int>? maybe;
  List<int> safe2 = [...a2, ...?maybe];  // null-safe spread
  print(safe2);  // [1, 2, 3]

  // ── OPERATOR PRECEDENCE ───────
  print(2 + 3 * 4);      // 14 (not 20) — * before +
  print((2 + 3) * 4);    // 20
  print(true || false && false); // true — && before ||
  print(null ?? 'a' ?? 'b');    // 'a' — left to right
}

bool _expensive() {
  print('expensive called!');
  return true;
}

// Operator overloading
class Vector {
  final double x, y;
  const Vector(this.x, this.y);

  Vector operator +(Vector other) => Vector(x + other.x, y + other.y);
  Vector operator -(Vector other) => Vector(x - other.x, y - other.y);
  Vector operator *(double scalar) => Vector(x * scalar, y * scalar);
  bool operator ==(Object other) =>
      other is Vector && x == other.x && y == other.y;

  @override
  String toString() => 'Vector(\$x, \$y)';
}

📝 KEY POINTS:
✅ / always returns double in Dart: 5 / 2 → 2.5
✅ ~/ is integer division: 5 ~/ 2 → 2
✅ .. cascade chains method calls on the same object
✅ is and is! check types; as casts (throws if wrong type)
✅ ??= assigns only if the variable is null
✅ Short-circuit: && stops at first false, || stops at first true
✅ Spread ... merges collections; ...? is null-safe spread
✅ Operators can be overloaded by defining operator methods in classes
❌ Don't confuse == (value equality) with identical() (reference equality)
❌ ~/ truncates toward zero, not floor: -7 ~/ 2 → -3 (not -4)
❌ as throws if the cast is wrong — use is check first if uncertain
''',
  quiz: [
    Quiz(question: 'What does the .. (cascade) operator do in Dart?', options: [
      QuizOption(text: 'Creates a copy of the object', correct: false),
      QuizOption(text: 'Chains multiple method calls on the same object, returning the original object', correct: true),
      QuizOption(text: 'Merges two lists together', correct: false),
      QuizOption(text: 'Applies null safety to method chains', correct: false),
    ]),
    Quiz(question: 'What is the result of 7 / 2 in Dart?', options: [
      QuizOption(text: '3 — integer division', correct: false),
      QuizOption(text: '3.5 — Dart / always returns double', correct: true),
      QuizOption(text: '4 — rounded up', correct: false),
      QuizOption(text: 'Depends on the type of the operands', correct: false),
    ]),
    Quiz(question: 'What does [...list1, ...?nullableList] do?', options: [
      QuizOption(text: 'Throws an error if nullableList is null', correct: false),
      QuizOption(text: 'Spreads list1 and safely spreads nullableList if non-null, ignoring it if null', correct: true),
      QuizOption(text: 'Creates a list of lists', correct: false),
      QuizOption(text: 'Concatenates the lists as strings', correct: false),
    ]),
  ],
);
