import '../../models/lesson.dart';
import '../../models/quiz.dart';

final dartLesson20 = Lesson(
  language: 'Dart',
  title: 'Exceptions & Error Handling',
  content: '''
🎯 METAPHOR:
Exception handling is like a hospital emergency system.
Normal operations (try) go through the regular process.
When something goes wrong (an exception is thrown),
the alarm sounds and the emergency team (catch) takes
over, handling the specific type of emergency (on TypeError,
on FormatException). The finally block is the cleanup
crew — they sanitize the room whether the patient lived
or died. Dart separates true program errors (Error) from
recoverable problems (Exception): Errors are like
structural building failures — you shouldn't catch them
and limp on. Exceptions are like broken equipment —
handle it, fix it, continue.

📖 EXPLANATION:
Dart uses try/on/catch/finally for exception handling.
The on keyword matches exception types specifically.
catch gives access to the exception object and stack trace.
throw can throw any non-null object.
Dart has two hierarchies: Exception (recoverable) and
Error (programming errors — generally shouldn't catch).

─────────────────────────────────────
📐 SYNTAX
─────────────────────────────────────
try {
  riskyOperation();
} on SpecificException catch (e) {
  // handle specific type
} on AnotherException catch (e, stackTrace) {
  // handle with stack trace
} catch (e) {
  // catch anything
} finally {
  // always runs
}

─────────────────────────────────────
🔑 ON vs CATCH
─────────────────────────────────────
on ExceptionType:        match type, no variable
on ExceptionType catch (e): match type, get object
catch (e):              match anything, get object
catch (e, s):           match anything, get object + trace

─────────────────────────────────────
⚡ THROWING
─────────────────────────────────────
throw FormatException('Invalid format');
throw ArgumentError.value(x, 'x', 'must be positive');
throw StateError('Object is in invalid state');
throw Exception('Something went wrong');

// Can throw any non-null object (but use Exception/Error subclasses!)
throw 'Error string';  // valid but bad practice

─────────────────────────────────────
🏗️  CUSTOM EXCEPTIONS
─────────────────────────────────────
class ValidationException implements Exception {
  final String message;
  final String? field;
  ValidationException(this.message, {this.field});

  @override
  String toString() => field != null
      ? 'ValidationException: \$field — \$message'
      : 'ValidationException: \$message';
}

─────────────────────────────────────
📊 EXCEPTION HIERARCHY
─────────────────────────────────────
Object
└── Throwable (conceptual)
    ├── Exception (recoverable problems)
    │   ├── FormatException
    │   ├── IOException
    │   ├── TimeoutException
    │   └── ... (your custom ones)
    └── Error (programming bugs — don't catch!)
        ├── AssertionError
        ├── ArgumentError
        ├── RangeError
        ├── StateError
        ├── TypeError
        ├── NullError (null dereference)
        └── StackOverflowError

─────────────────────────────────────
🔄 RETHROW
─────────────────────────────────────
try { ... }
catch (e) {
  log(e);
  rethrow;  // re-throws the same exception
}

─────────────────────────────────────
📌 ASSERT
─────────────────────────────────────
assert(condition);            // throws AssertionError if false
assert(condition, 'message'); // with message
// Only active in debug mode — ignored in production!

💻 CODE:
void main() {
  // ── BASIC TRY/CATCH ───────────
  try {
    int result = 10 ~/ 0;
    print(result);
  } catch (e) {
    print('Caught: \$e');   // Caught: IntegerDivisionByZeroException
  }

  // ── ON — SPECIFIC TYPE ────────
  try {
    int.parse('not a number');
  } on FormatException {
    print('Bad format!');   // matches FormatException
  }

  // ── ON + CATCH ────────────────
  try {
    int.parse('abc');
  } on FormatException catch (e) {
    print('Format error: \$e');  // has the exception object
  }

  // ── MULTIPLE HANDLERS ─────────
  void riskyOp(String input) {
    try {
      var n = int.parse(input);
      print(100 ~/ n);
    } on FormatException catch (e) {
      print('Not a number: \$e');
    } on IntegerDivisionByZeroException {
      print('Cannot divide by zero!');
    } catch (e, stackTrace) {
      print('Unknown error: \$e');
      print('Stack: \$stackTrace');
    } finally {
      print('Operation complete (always prints)');
    }
  }

  riskyOp('5');     // 20 + "Operation complete"
  riskyOp('abc');   // "Not a number" + "Operation complete"
  riskyOp('0');     // "Cannot divide by zero" + "Operation complete"

  // ── THROWING ──────────────────
  try {
    validateAge(-5);
  } on ArgumentError catch (e) {
    print('Validation: \$e');
  }

  try {
    String? name = null;
    processName(name!);  // null assertion — throws
  } catch (e) {
    print('Caught null assertion: \$e');
  }

  // ── CUSTOM EXCEPTIONS ─────────
  try {
    createUser(name: '', email: 'not-an-email', age: 200);
  } on ValidationException catch (e) {
    print('Validation failed: \$e');
    if (e.field != null) print('Field: \${e.field}');
  }

  // ── RETHROW ───────────────────
  try {
    processData(null);
  } catch (e) {
    print('Outer caught: \$e');
  }

  // ── FINALLY ───────────────────
  String? resource;
  try {
    resource = 'opened resource';
    print(resource);
    // throw Exception('Something went wrong');  // uncomment to test
    resource = null;
  } catch (e) {
    print('Error: \$e');
  } finally {
    if (resource != null) {
      print('Closing: \$resource');
    }
    print('Finally block always runs!');
  }

  // ── ASSERT (debug only) ───────
  int x = 5;
  assert(x > 0, 'x must be positive');  // passes
  assert(x < 10, 'x must be less than 10');  // passes

  // In debug mode: assert(x > 100) throws AssertionError
  // In production: assert is completely ignored

  // ── RESULT PATTERN (no exceptions) ──
  // Alternative to exceptions: return a Result type
  var result = safeDivide(10, 2);
  if (result case (:final value) when value != null) {
    print('Result: \$value');   // 5
  }

  var badResult = safeDivide(10, 0);
  if (badResult case (:final errorMessage)) {
    print('Error: \$errorMessage');
  }

  // ── ASYNC EXCEPTIONS ──────────
  // (Covered fully in the async lesson)
  // Future throws are caught with .catchError() or try/catch in async functions:
  //
  // try {
  //   await someAsyncOperation();
  // } catch (e) {
  //   print('Async error: \$e');
  // }
}

// ── CUSTOM EXCEPTION ───────────
class ValidationException implements Exception {
  final String message;
  final String? field;

  const ValidationException(this.message, {this.field});

  @override
  String toString() => field != null
      ? 'ValidationException[\$field]: \$message'
      : 'ValidationException: \$message';
}

class NetworkException implements Exception {
  final int statusCode;
  final String message;

  const NetworkException(this.statusCode, this.message);

  bool get isClientError => statusCode >= 400 && statusCode < 500;
  bool get isServerError => statusCode >= 500;

  @override
  String toString() => 'NetworkException(\$statusCode): \$message';
}

// ── THROWING ──────────────────
void validateAge(int age) {
  if (age < 0 || age > 150) {
    throw ArgumentError.value(age, 'age', 'must be between 0 and 150');
  }
}

void processName(String name) {
  if (name.isEmpty) throw ArgumentError('name cannot be empty');
  print('Processing: \$name');
}

// ── CUSTOM EXCEPTION IN USE ────
void createUser({
  required String name,
  required String email,
  required int age,
}) {
  if (name.isEmpty) {
    throw ValidationException('Name cannot be empty', field: 'name');
  }
  if (!email.contains('@')) {
    throw ValidationException('Invalid email format', field: 'email');
  }
  if (age < 0 || age > 150) {
    throw ValidationException('Age out of range: \$age', field: 'age');
  }
  print('User created: \$name');
}

// ── RETHROW ───────────────────
void processData(String? data) {
  try {
    if (data == null) throw ArgumentError('data cannot be null');
    print('Processing: \$data');
  } catch (e) {
    print('  Inner caught, logging...');
    rethrow;   // re-throw to caller
  }
}

// ── RESULT TYPE (no exceptions) ─
({int? value, String? errorMessage}) safeDivide(int a, int b) {
  if (b == 0) return (value: null, errorMessage: 'Cannot divide by zero');
  return (value: a ~/ b, errorMessage: null);
}

📝 KEY POINTS:
✅ on ExceptionType matches a specific type cleanly
✅ catch (e, s) gives both the exception and the stack trace
✅ finally always runs — even after return or throw
✅ rethrow preserves the original exception with its stack trace
✅ Custom exceptions should implement Exception (not extend it)
✅ Error subclasses are for programming bugs — don't catch them normally
✅ assert only runs in debug mode — safe to use freely for invariants
✅ Consider the Result pattern for expected failures instead of exceptions
❌ Don't catch Error subclasses unless you truly know what you're doing
❌ Don't swallow exceptions silently: catch (e) { } — always log or rethrow
❌ throw 'string' is valid but bad practice — use proper Exception subclasses
''',
  quiz: [
    Quiz(question: 'What is the difference between on and catch in Dart exception handling?', options: [
      QuizOption(text: 'on handles synchronous exceptions; catch handles async ones', correct: false),
      QuizOption(text: 'on filters by exception type; catch (e) gives access to the exception object', correct: true),
      QuizOption(text: 'catch is for Errors; on is for Exceptions', correct: false),
      QuizOption(text: 'They are identical — just different syntax', correct: false),
    ]),
    Quiz(question: 'When does the finally block run?', options: [
      QuizOption(text: 'Only when no exception was thrown', correct: false),
      QuizOption(text: 'Always — whether the try block succeeded, threw, or returned', correct: true),
      QuizOption(text: 'Only when an exception was caught', correct: false),
      QuizOption(text: 'Only in debug mode', correct: false),
    ]),
    Quiz(question: 'What does rethrow do differently than throw e?', options: [
      QuizOption(text: 'rethrow creates a new exception; throw e uses the old one', correct: false),
      QuizOption(text: 'rethrow preserves the original stack trace; throw e would create a new stack trace', correct: true),
      QuizOption(text: 'They are identical', correct: false),
      QuizOption(text: 'rethrow only works with Error types', correct: false),
    ]),
  ],
);
