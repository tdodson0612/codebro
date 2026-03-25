import '../../models/lesson.dart';
import '../../models/quiz.dart';

final dartLesson06 = Lesson(
  language: 'Dart',
  title: 'Null Safety',
  content: '''
🎯 METAPHOR:
Null safety is like a building with two types of rooms.
Non-nullable rooms (T) have a guarantee: there is ALWAYS
a tenant. The door is never empty. You can walk in anytime.
Nullable rooms (T?) might be empty — the "?" is the
"vacancy" sign. Before you use a nullable room, you check
if anyone's home. Dart's type system enforces this at
compile time — you literally cannot walk into a potentially
empty room without checking first. No more "null pointer
exceptions" crashing your app silently at 3am.

📖 EXPLANATION:
Sound null safety (added in Dart 2.12) means the type
system GUARANTEES non-nullable types never contain null.
Null errors are caught at compile time, not runtime.
Every type T is non-nullable by default. Add ? to make
it nullable: T becomes T?.

─────────────────────────────────────
📐 THE CORE RULE
─────────────────────────────────────
String name = 'Alice';  // NEVER null — guaranteed
String? name = null;    // CAN be null — you must check

Without ? → the compiler guarantees no null
With    ? → you're responsible for null checks

─────────────────────────────────────
🔑 NULL-AWARE OPERATORS
─────────────────────────────────────
??   Null coalescing — provide a default
     x ?? 'default'   → x if not null, else 'default'

?.   Null-safe member access
     x?.length        → x.length if not null, else null

??=  Null-aware assignment
     x ??= 'value'    → assign only if x is null

!    Null assertion — "I know it's not null"
     x!.length        → forces non-null (throws if null!)

─────────────────────────────────────
🔍 NULL CHECKS & PROMOTION
─────────────────────────────────────
String? name = getName();

// Method 1: if-null check (promotes type!)
if (name != null) {
  print(name.length); // name is String here, not String?
}

// Method 2: null coalescing
print(name ?? 'Anonymous');

// Method 3: null assertion (risky!)
print(name!.length);  // crashes if name IS null

// Method 4: late (promise to initialize)
late String definite;
definite = 'I promise this gets set';
print(definite.length); // OK — no null check needed

─────────────────────────────────────
🔄 TYPE PROMOTION
─────────────────────────────────────
After a null check, Dart "promotes" the type:
  String? name = ...;
  if (name == null) return;
  // name is now promoted to String (not String?)
  print(name.length);  // ✅ no null check needed

─────────────────────────────────────
⚡ LATE VARIABLES
─────────────────────────────────────
late String name;     // non-nullable, initialized later
late final String id; // final late — set once, then frozen

Use late when:
  • Circular references
  • Expensive initialization (lazy)
  • Variables initialized in initState or setUp

─────────────────────────────────────
🌊 NULLABLE vs OPTIONAL
─────────────────────────────────────
In Dart, null has meaning: "no value."
Nullable parameters make intent explicit.
T?  means "this might be absent"
T   means "this is always present"

This is the opposite of Java/JavaScript where
any reference could be null silently.

💻 CODE:
void main() {
  // ── Basic nullable types ───────
  String nonNull = 'I am never null';
  String? nullable = null;
  String? alsoNullable = 'But I have a value';

  print(nonNull);      // I am never null
  print(nullable);     // null
  print(alsoNullable); // But I have a value

  // ── ?? null coalescing ─────────
  String? username;
  print(username ?? 'Anonymous');    // Anonymous
  username = 'Alice';
  print(username ?? 'Anonymous');    // Alice

  // Chain ?? for multiple fallbacks
  String? a, b;
  String c = 'found!';
  print(a ?? b ?? c);                // found!

  // ── ??= null-aware assignment ──
  String? config;
  config ??= 'default_value';
  print(config);      // default_value
  config ??= 'other'; // NOT assigned — already non-null
  print(config);      // default_value (unchanged!)

  // ── ?. null-safe access ────────
  String? city = null;
  print(city?.length);         // null (not a crash!)
  print(city?.toUpperCase());  // null

  city = 'London';
  print(city?.length);         // 6
  print(city?.toUpperCase());  // LONDON

  // Chaining ?.
  List<String>? names;
  print(names?.first?.length); // null (safe chain)
  names = ['Alice', 'Bob'];
  print(names.first.length);   // 5 (non-null, no ? needed)

  // ── if null check (promotes!) ──
  String? maybeNull = _getMaybe(true);

  if (maybeNull != null) {
    // Inside here, maybeNull is promoted to String
    print(maybeNull.toUpperCase()); // no ? needed!
    print(maybeNull.length);
  }

  // Early return pattern
  String? result = _getMaybe(false);
  if (result == null) return; // exit early
  // From here on, result is non-null String
  print(result.length);

  // ── ! null assertion ───────────
  String? definitelySet = 'Hello';
  print(definitelySet!.length);  // 5 — works fine

  // Use ! only when you are CERTAIN it's not null
  String? dangerous;
  try {
    print(dangerous!.length); // throws NullCheckException!
  } catch (e) {
    print('Caught: \$e');
  }

  // ── late variables ─────────────
  late String initialized;
  initialized = 'Set before use';
  print(initialized);   // Set before use

  // late + final (computed once, then cached)
  late final String expensive = _computeOnce();
  print(expensive);  // computed now
  print(expensive);  // returned from cache — not computed again

  // ── Null in collections ────────
  List<String?> nullableList = ['Alice', null, 'Bob', null];
  List<String> nonNullList = ['Alice', 'Bob'];

  // Filter nulls from nullable list
  List<String> filtered = nullableList
      .whereType<String>()
      .toList();
  print(filtered);  // [Alice, Bob]

  // Or use where + non-null cast
  List<String> filtered2 = nullableList
      .where((e) => e != null)
      .cast<String>()
      .toList();

  // ── Required named parameters ──
  greet(name: 'Alice');           // ✅
  greet();                        // ✅ name defaults to null
}

String? _getMaybe(bool returnValue) {
  return returnValue ? 'has value' : null;
}

String _computeOnce() {
  print('  (computing...)');
  return 'expensive result';
}

void greet({String? name}) {
  print('Hello, \${name ?? 'stranger'}!');
}

// ── Null safety with classes ────
class User {
  final String id;          // always present
  final String name;        // always present
  final String? email;      // optional
  final String? phone;      // optional

  User({
    required this.id,
    required this.name,
    this.email,             // optional — defaults to null
    this.phone,
  });

  String get displayEmail => email ?? 'No email on file';

  bool get hasContact => email != null || phone != null;
}

📝 KEY POINTS:
✅ By default, all Dart types are non-nullable — T can never be null
✅ Add ? to make nullable: String? can hold null or a String
✅ ?? provides a default when left side is null
✅ ?. safely calls methods/properties on nullable values
✅ ??= assigns only if the variable is currently null
✅ null checks promote the type: inside if (x != null) { ... } x is T not T?
✅ Use ! only when you are CERTAIN it's not null — it throws if wrong
✅ late is for non-nullable variables you'll initialize before first use
❌ ! is dangerous — prefer explicit null checks or ??
❌ Avoid late unless you truly can't initialize at declaration
❌ Never assign null to a non-nullable variable — compile error
''',
  quiz: [
    Quiz(question: 'What does the ?? operator do in Dart?', options: [
      QuizOption(text: 'Checks if two values are equal including type', correct: false),
      QuizOption(text: 'Returns the left value if not null, otherwise returns the right value', correct: true),
      QuizOption(text: 'Throws an exception if either value is null', correct: false),
      QuizOption(text: 'Converts null to an empty string', correct: false),
    ]),
    Quiz(question: 'What happens when you call ! on a null value?', options: [
      QuizOption(text: 'It returns null safely', correct: false),
      QuizOption(text: 'It throws a NullCheckException at runtime', correct: true),
      QuizOption(text: 'It returns false', correct: false),
      QuizOption(text: 'It is a compile error', correct: false),
    ]),
    Quiz(question: 'What is type promotion in Dart?', options: [
      QuizOption(text: 'Converting one type to another with a cast', correct: false),
      QuizOption(text: 'After a null check, the compiler narrows String? to String inside that block', correct: true),
      QuizOption(text: 'Upgrading to a parent class automatically', correct: false),
      QuizOption(text: 'Making a variable const at compile time', correct: false),
    ]),
  ],
);