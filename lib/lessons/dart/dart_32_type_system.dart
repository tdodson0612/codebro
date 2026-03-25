import '../../models/lesson.dart';
import '../../models/quiz.dart';

final dartLesson32 = Lesson(
  language: 'Dart',
  title: 'The Dart Type System',
  content: '''
🎯 METAPHOR:
Dart's type system is like an airport security screening.
Sound null safety is the X-ray machine — it detects
problems before you board (compile time), not after
the flight crashes (runtime). The type hierarchy is the
chain of authority: every traveler (value) has an identity
(type), their passport (class) says what they can do.
Some IDs are forgeries (dynamic — unchecked), some are
verified international passports (Object), some are
specialty permits (extension types). The system's "sound"
guarantee means: if the X-ray machine says you're clear,
you ARE clear — no surprises at 30,000 feet.

📖 EXPLANATION:
Dart has a sound static type system. Sound means: if the
type checker says a variable is a non-nullable String, it
CANNOT be null or a non-String at runtime. Types inform the
compiler about valid operations and enable optimizations.
This lesson covers the full type hierarchy, variance,
covariance, and type system subtleties.

─────────────────────────────────────
📐 THE TYPE HIERARCHY
─────────────────────────────────────
                Object?              ← top type (nullable)
               /       \\
           Object        Null
          /  |  \\ \\
       int String bool  ...    ← non-nullable types
        |
      Never                    ← bottom type (no values)

Object?  → accepts anything (including null)
Object   → accepts anything non-null
T?       → T or null
Never    → no values (functions that never return, throw only)

─────────────────────────────────────
🔑 SUBTYPE RELATIONSHIPS
─────────────────────────────────────
String    <: Object      (String is a subtype of Object)
String    <: String?     (non-null is subtype of nullable!)
int       <: num         (int is a subtype of num)
List<int> <: List<num>?  (via covariance)
Never     <: anything    (Never is subtype of everything)

─────────────────────────────────────
🔄 VARIANCE
─────────────────────────────────────
Dart's generic types are COVARIANT in the type parameter:
  List<String> <: List<Object>   ← allowed!

This is convenient but can cause issues:
  List<Object> objs = <String>['hello'];  // ✅ compiles
  objs.add(42);   // ✅ compiles! But 42 is not a String...
  // → Throws at runtime: type error

Dart detects this at runtime with a CastError.
This is the price of covariance for convenience.

─────────────────────────────────────
🎯 DYNAMIC AND OBJECT?
─────────────────────────────────────
dynamic:   ALL operations allowed at compile time
           type checked at RUNTIME — can throw
           NOT part of the null-safe type system

Object?:   accepts any value (including null)
           ONLY Object? methods available: ==, toString, hashCode, runtimeType
           Must cast/check before using as specific type

─────────────────────────────────────
⚡ NEVER TYPE
─────────────────────────────────────
Never is the bottom type — no values have this type.
Used for:
  • Functions that always throw: Never throw(String msg) => throw msg;
  • Unreachable code
  • Exhaustiveness (switch returns Never in impossible case)

─────────────────────────────────────
📋 TYPE CHECKING AND CASTING
─────────────────────────────────────
is T        → runtime type check (bool)
is! T       → runtime NOT type check
as T        → runtime cast (throws TypeError if wrong)
obj is T ? (obj as T).method() : fallback
            → pattern: check then cast safely

Safer: use patterns instead of explicit casts!

💻 CODE:
void main() {
  // ── TYPE HIERARCHY ─────────────
  // Object? is the root — accepts everything
  Object? anything = null;
  anything = 42;
  anything = 'string';
  anything = [1, 2, 3];
  anything = true;
  print(anything);   // true

  // Object is non-nullable root
  Object obj = 42;
  obj = 'hello';
  // obj = null;  // ❌ Object is non-nullable!

  // Type testing
  print(42 is int);         // true
  print(42 is num);         // true — int is subtype of num
  print(42 is Object);      // true
  print(42 is Object?);     // true
  print(null is Object?);   // true
  print(null is Object);    // false — null is not Object

  // ── SUBTYPE RELATIONSHIPS ──────
  num n = 42;     // int is subtype of num ✅
  n = 3.14;       // double is subtype of num ✅

  String? nullable = null;    // String? includes null
  String nonNull = 'hello';
  nullable = nonNull;         // String <: String? ✅
  // nonNull = nullable;      // ❌ String? is not <: String

  // ── COVARIANCE ─────────────────
  List<int> ints = [1, 2, 3];
  List<num> nums = ints;   // ✅ List<int> <: List<num>

  // The DANGER of covariance:
  try {
    nums.add(3.14);  // compiles (adding num to List<num>)
    // but at runtime: ints now contains 3.14?
    // Dart protects this with a runtime check!
  } catch (e) {
    print('Covariance runtime check: \$e');
  }

  // Safe: readonly covariance (Iterable is conceptually covariant)
  Iterable<int> intIter = [1, 2, 3];
  Iterable<num> numIter = intIter;  // ✅ safe (read-only)
  print(numIter.reduce((a, b) => a + b));  // 6

  // ── DYNAMIC vs OBJECT? ─────────
  dynamic d = 42;
  print(d + 1);        // ✅ 43 (allowed at compile time)
  d = 'hello';
  print(d.length);     // ✅ 5 (method call, checked at runtime)

  // But dynamic can crash:
  try {
    d = 42;
    print(d.length);   // runtime error! int has no .length
  } catch (e) {
    print('Dynamic error: \$e');
  }

  Object? objQ = 'hello';
  // objQ.length;  // ❌ compile error — Object? has no .length
  if (objQ is String) {
    print(objQ.length);  // ✅ promoted to String
  }

  // ── IS / AS OPERATORS ─────────
  Object val = 'Dart is awesome!';

  // is — safe type check
  print(val is String);    // true
  print(val is int);       // false

  // as — unsafe cast (throws if wrong)
  String s = val as String;
  print(s.toUpperCase());   // DART IS AWESOME!

  // as on wrong type:
  try {
    int bad = val as int;  // TypeError!
  } catch (e) {
    print('Cast error: \$e');
  }

  // BETTER: use pattern matching
  if (val case String str) {
    print(str.length);    // type-safe, no cast
  }

  // ── NEVER TYPE ─────────────────
  // Functions returning Never always throw or loop forever:
  // (defined below)

  try {
    alwaysThrows('something bad happened');
  } catch (e) {
    print('Caught Never: \$e');
  }

  // Never in switch exhaustiveness
  String? maybeStr = null;
  String result = maybeStr != null ? maybeStr : alwaysThrows('null!');
  // ^ this works because Never <: String

  // ── TYPE PROMOTION ─────────────
  Object? value = getRandomValue();

  // Cascade of is checks
  if (value is int) {
    print('Int: ${
value * 2}');
  } else if (value is String) {
    print('String: ${
value.toUpperCase()}');
  } else if (value is List) {
    print('List of ${
value.length} items');
  } else {
    print('Unknown type: ${
value?.runtimeType}');
  }

  // ── GENERICS AND BOUNDS ────────
  // T extends Object — T cannot be nullable!
  printNonNull('hello');
  printNonNull(42);
  // printNonNull(null);  // ❌ null not allowed

  // T extends Object? — T CAN be nullable
  printMaybe(null);
  printMaybe('world');

  // ── FUN WITH TYPES ─────────────
  // The type of a function IS a type
  int Function(int) doubler = (n) => n * 2;
  print(doubler.runtimeType);   // (int) => int

  // List of functions
  List<int Function(int)> transforms = [
    (n) => n + 1,
    (n) => n * 2,
    (n) => n * n,
  ];
  int val2 = 3;
  for (final t in transforms) {
    val2 = t(val2);   // 4, 8, 64
  }
  print(val2);   // 64
}

// Never return type — this function NEVER returns normally
Never alwaysThrows(String message) {
  throw Exception(message);
}

Object? getRandomValue() {
  final values = [42, 'hello', [1, 2, 3], null, true];
  return values[DateTime.now().millisecond % values.length];
}

// Non-nullable generic bound
void printNonNull<T extends Object>(T value) {
  print('Non-null value: \$value (type: ${
value.runtimeType})');
}

// Nullable generic bound
void printMaybe<T extends Object?>(T value) {
  print('Maybe value: \$value');
}

📝 KEY POINTS:
✅ Object? is the true top type — accepts anything including null
✅ Object is the non-nullable top — accepts everything except null
✅ Never is the bottom type — used for functions that always throw
✅ Dart's generics are covariant: List<String> <: List<Object>
✅ Covariance is convenient but can cause runtime CastErrors on mutation
✅ dynamic opts out of all compile-time type checking
✅ Object? requires explicit checks before calling non-Object methods
✅ is checks + type narrowing are the safe alternative to as casts
✅ T extends Object prevents nullable type arguments
❌ Covariance means List<String> assigned to List<Object> can be written to with non-Strings
❌ dynamic.anything() compiles but can throw — avoid unless necessary
❌ as cast throws TypeError if wrong — prefer is checks or pattern matching
''',
  quiz: [
    Quiz(question: 'What is the "top type" in Dart\'s null-safe type system?', options: [
      QuizOption(text: 'Object — the root of all classes', correct: false),
      QuizOption(text: 'Object? — accepts any value including null', correct: true),
      QuizOption(text: 'dynamic — accepts anything', correct: false),
      QuizOption(text: 'Null — since null is the absence of value', correct: false),
    ]),
    Quiz(question: 'What is the Never type used for?', options: [
      QuizOption(text: 'Variables that are never initialized', correct: false),
      QuizOption(text: 'Functions that always throw or never return, and unreachable code', correct: true),
      QuizOption(text: 'Generic type parameters with no constraints', correct: false),
      QuizOption(text: 'Optional parameters that are never passed', correct: false),
    ]),
    Quiz(question: 'Why is List<String> assignable to List<Object> in Dart (covariance)?', options: [
      QuizOption(text: 'Because String extends Object, the collection is also considered a subtype', correct: true),
      QuizOption(text: 'Because all Dart lists have the same underlying type', correct: false),
      QuizOption(text: 'Because Dart automatically upcasts the elements', correct: false),
      QuizOption(text: 'It is not assignable — this is a compile error', correct: false),
    ]),
  ],
);
