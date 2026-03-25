import '../../models/lesson.dart';
import '../../models/quiz.dart';

final dartLesson27 = Lesson(
  language: 'Dart',
  title: 'Null Safety Deep Dive: late, !, ? & ??',
  content: '''
🎯 METAPHOR:
Dart's null safety is like a strict hotel check-in system.
Every room key (variable) is either guaranteed to have a
guest (non-nullable) or might be empty (nullable T?).
The front desk (type system) enforces this at check-in
time (compile time). The ! operator is like a skeleton
key: "I GUARANTEE there's a guest in this room" — works
if you're right, hotel alarm (runtime crash) if you're wrong.
late is pre-booking a room: you reserve it now but the
guest arrives later. ?? is the hotel's backup plan:
"If Room 204 is empty, use Room 205."

📖 EXPLANATION:
This lesson goes deep on Dart's null safety system:
the type hierarchy around null, promotion mechanics,
late semantics, nullable generics, and the null assertion
operator. Understanding these deeply prevents bugs and
eliminates unnecessary null checks.

─────────────────────────────────────
📐 THE FULL NULL TYPE HIERARCHY
─────────────────────────────────────
Object               → non-nullable root (everything is here)
├── int
├── String
├── bool
├── MyClass
└── ...

Null                 → type of null itself
                       (only value is null)

T?  =  T | Null      → union type, nullable form of T
Object?              → nullable root of ALL types

─────────────────────────────────────
🔑 PROMOTION RULES
─────────────────────────────────────
Dart promotes T? to T inside certain checks:

✅ if (x != null)           → x is T inside if body
✅ if (x == null) return    → x is T after the guard
✅ assert(x != null)        → x is T after (debug only)
✅ x is String              → x is String inside if
✅ x as String              → x is String (throws if wrong)

Promotion is BLOCKED by:
  ❌ x being a non-final field (can change between checks)
  ❌ x being accessed via getter
  ❌ Assignment to x in a closure (could be null again)

─────────────────────────────────────
⚡ LATE DEEP DIVE
─────────────────────────────────────
Four common uses of late:

1. Circular references (A needs B, B needs A)
2. Lazy initialization (expensive computation deferred)
3. Framework setup (Flutter initState, DI containers)
4. Tests (setUp initializes, tests use)

late + final = initialized once, then cached:
  late final value = _computeOnce();  // computed on first access

NEVER:
  late String name;
  print(name);  // LateInitializationError — not set yet!

─────────────────────────────────────
🔄 SOUND NULL SAFETY
─────────────────────────────────────
"Sound" means the type checker's guarantees are airtight:
• If the type says non-null, it CANNOT be null
• No holes, no workarounds through the type system
• Enables compile-time optimizations

This is different from unsound systems (TypeScript, Java)
where you can bypass type safety with casts/any.

─────────────────────────────────────
📋 NULL SAFETY OPERATORS SUMMARY
─────────────────────────────────────
x?.method()          → call only if x is not null
x ?? fallback        → use fallback if x is null
x ??= value          → assign value if x is null
x!                   → assert non-null (throws if wrong)
x is T               → runtime type check (promotes)
x as T               → runtime cast (throws if wrong)
if (x case T v)      → pattern match with promotion

💻 CODE:
void main() {
  // ── TYPE HIERARCHY ────────────
  String s = 'hello';       // non-nullable
  String? ns = null;        // nullable
  Object o = 42;            // non-nullable Object
  Object? no = null;        // nullable Object (accepts anything)
  dynamic d = null;         // dynamic (no type checking)

  // Object? is the supertype of everything nullable
  no = 42;         // int
  no = 'string';   // String
  no = [1, 2, 3];  // List

  // dynamic skips all type checking
  d = 42;
  d.anything();    // No compile error — runtime crash!

  // ── PROMOTION ─────────────────
  String? name = _getName(true);

  // Classic if-null check (promotes in body)
  if (name != null) {
    print(name.length);    // name is String here
    print(name.toUpperCase()); // no ? needed
  }

  // Guard clause (promotes AFTER the guard)
  String? city = _getName(false);
  if (city == null) {
    print('No city provided');
    // DON'T return here for demonstration — normally would return
  }
  // city is still String? here (no return above)

  // Early return guard (CORRECT pattern):
  String? value = _getName(true);
  if (value == null) return;
  print(value.length);    // value is String here!

  // is-check promotes
  Object obj = 'hello';
  if (obj is String) {
    print(obj.length);    // obj is String here!
    print(obj.toUpperCase());
  }
  // Outside: obj is Object again

  // ── PROMOTION BLOCKERS ────────
  // Fields are NOT promoted (can change between read and use):
  var holder = _NullableHolder();
  if (holder.value != null) {
    // holder.value is STILL String? here!
    // Because between the check and use, something could change holder.value
    print(holder.value?.length);  // must use ?. or !

    // FIX: copy to local variable first!
    final local = holder.value;
    if (local != null) {
      print(local.length);  // ✅ local IS promoted
    }
  }

  // ── LATE VARIABLES ────────────
  // 1. Basic late
  late String description;
  // Can use description here in code — compiler trusts you
  description = _computeDescription();  // set before first use
  print(description);

  // 2. Lazy late final (computed once, then cached)
  late final String expensiveResult = _expensiveComputation();
  // _expensiveComputation() not called yet...
  print(expensiveResult);  // NOW computed and cached
  print(expensiveResult);  // Returns cached — NOT recomputed!

  // 3. LateInitializationError if accessed before set:
  late String unset;
  try {
    print(unset);  // ❌ LateInitializationError
  } catch (e) {
    print('Error: \$e');
  }

  // ── NULL ASSERTION OPERATOR ! ──
  String? maybeNull = 'definitely not null here';
  print(maybeNull!.length);   // 24 — works fine

  // When ! is wrong:
  String? definitelyNull;
  try {
    print(definitelyNull!.length);  // ❌ throws!
  } catch (e) {
    print('Null assertion error: \$e');
  }

  // BETTER PATTERN — avoid ! when possible:
  String safe = definitelyNull ?? 'fallback';
  print(safe);   // fallback

  // ── NULL-COALESCING PATTERNS ──
  String? firstName;
  String? lastName;
  String displayName = firstName ?? lastName ?? 'Anonymous';
  print(displayName);   // Anonymous

  // ??= assignment
  Map<String, int> counts = {};
  counts['apple'] ??= 0;   // sets to 0 since key missing
  counts['apple']!;
  counts['apple'] = (counts['apple'] ?? 0) + 1;  // increment
  print(counts);  // {apple: 1}

  // ── NULL-SAFE CHAINS ──────────
  List<String>? names;
  print(names?.first?.toUpperCase());  // null (chain short-circuits)
  names = ['alice', 'bob'];
  print(names.first.toUpperCase());    // ALICE (non-null, no ? needed)

  // ── IF-CASE NULL CHECK ─────────
  Object? raw = 'hello';
  if (raw case String s) {
    print(s.length);   // s is promoted to String
  }

  // ── NULLABLE GENERICS ─────────
  // List<String?> vs List<String>?
  List<String?> nullableItems = ['hello', null, 'world'];
  List<String>? nullableList = null;

  // nullableItems: non-null list, nullable elements
  for (final item in nullableItems) {
    print(item?.toUpperCase() ?? '(null)');
  }

  // nullableList: might be null, but elements non-null
  print(nullableList?.length ?? 0);   // 0

  // ── REQUIRED NAMED PARAMS ─────
  // required + non-nullable = can never be null
  printInfo(name: 'Alice', age: 30);   // compiler ensures both passed

  // Optional nullable = can be omitted (null by default)
  printOptional(title: 'Mr');  // bio is null
  printOptional();             // both null
}

String? _getName(bool provide) => provide ? 'Alice' : null;
String _computeDescription() => 'A computed description';
String _expensiveComputation() {
  print('  (computing — only once!)');
  return 'expensive result';
}

// Non-promotable field example
class _NullableHolder {
  String? value = 'hello';
}

// Required named params — enforced non-null
void printInfo({required String name, required int age}) {
  print('\$name: \$age');
}

// Optional nullable named params
void printOptional({String? title, String? bio}) {
  print('\${title ?? ''} \${bio ?? '(no bio)'}');
}

// ── MIGRATION PATTERN ──────────
// When receiving data from external source (JSON, DB):
class UserDto {
  final String? name;        // might be missing in JSON
  final int? age;
  final String email;        // always required

  UserDto({this.name, this.age, required this.email});

  // Validate and create non-nullable version
  User toUser() {
    if (name == null) throw ArgumentError('name is required');
    if (age == null) throw ArgumentError('age is required');
    return User(name: name!, age: age!, email: email);
  }
}

class User {
  final String name;
  final int age;
  final String email;
  User({required this.name, required this.age, required this.email});
}

📝 KEY POINTS:
✅ T? is a union of T | Null — adding ? makes any type nullable
✅ Type promotion: after null checks, Dart treats T? as T inside the safe scope
✅ Local variables promote; fields do NOT — copy to local first
✅ late defers initialization; late final caches the first computation
✅ ! is a runtime assertion — only use when you are CERTAIN
✅ Guard clauses (if (x == null) return) promote x for the rest of the function
✅ Object? is the supertype of everything — accepts any nullable or non-nullable value
✅ dynamic completely bypasses null safety — avoid unless absolutely necessary
❌ Fields don't promote — always copy nullable fields to locals before null-checking
❌ Never use ! without being 100% certain — prefer ?? or null checks
❌ late without initialization is dangerous — LateInitializationError at runtime
''',
  quiz: [
    Quiz(question: 'Why don\'t class fields get type-promoted after a null check?', options: [
      QuizOption(text: 'This is a Dart limitation that will be fixed', correct: false),
      QuizOption(text: 'Fields can be changed between the null check and the use, so the compiler cannot guarantee safety', correct: true),
      QuizOption(text: 'Only final fields don\'t get promoted', correct: false),
      QuizOption(text: 'Fields are always null-safe regardless', correct: false),
    ]),
    Quiz(question: 'What does "late final String value = compute();" do?', options: [
      QuizOption(text: 'Calls compute() immediately at declaration', correct: false),
      QuizOption(text: 'Calls compute() only on the first access, then caches the result forever', correct: true),
      QuizOption(text: 'Calls compute() every time value is accessed', correct: false),
      QuizOption(text: 'Creates a lazy nullable variable', correct: false),
    ]),
    Quiz(question: 'What is the difference between List<String?> and List<String>??', options: [
      QuizOption(text: 'They are identical — just different syntax', correct: false),
      QuizOption(text: 'List<String?> is a non-null list with nullable elements; List<String>? is a nullable list with non-null elements', correct: true),
      QuizOption(text: 'List<String?> can be null; List<String>? cannot', correct: false),
      QuizOption(text: 'List<String>? is deprecated', correct: false),
    ]),
  ],
);
