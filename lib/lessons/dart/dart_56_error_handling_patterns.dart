import '../../models/lesson.dart';
import '../../models/quiz.dart';

final dartLesson56 = Lesson(
  language: 'Dart',
  title: 'Error Handling Patterns',
  content: '''
🎯 METAPHOR:
Error handling is like building safety systems into a ship.
A ship can sink (crash) if it hits an iceberg (exception)
with no safety plan. Good error handling is the life jacket
system — for EXPECTED problems, you have a plan (try/catch,
Result type). The smoke detector (on Object: catch) signals
unexpected problems and keeps the crew informed. "Rethrow"
is pulling the alarm but letting the bridge deal with it.
The Result<T, E> pattern is even better: it moves the "this
might fail" signal from runtime (crash) to compile time
(you must handle both success and failure paths).

📖 EXPLANATION:
Dart error handling goes beyond basic try/catch. This lesson
covers exception hierarchies, on/catch/finally, rethrowing,
the Result pattern for typed errors, zone-based error handling,
and practical patterns for async error management.

─────────────────────────────────────
⚠️  EXCEPTION HIERARCHY
─────────────────────────────────────
Object
├── Error        (programming bugs — don't recover)
│   ├── AssertionError
│   ├── TypeError
│   ├── RangeError
│   ├── StackOverflowError
│   └── OutOfMemoryError
└── Exception    (runtime failures — recoverable)
    ├── IOException
    ├── FormatException
    ├── TimeoutException
    └── (your custom exceptions)

─────────────────────────────────────
📋 TRY / ON / CATCH / FINALLY
─────────────────────────────────────
try {
  riskyOperation();
} on SpecificException catch (e) {
  // handles only SpecificException
} on AnotherException {
  // handles AnotherException (no binding)
} catch (e, stackTrace) {
  // handles anything else
  print(stackTrace);
} finally {
  // ALWAYS runs (cleanup)
  cleanup();
}

─────────────────────────────────────
🔄 RETHROW
─────────────────────────────────────
try {
  operation();
} catch (e) {
  log(e);       // log it
  rethrow;      // keep original stack trace
  // NOT: throw e;  (would reset stack trace!)
}

─────────────────────────────────────
📦 RESULT PATTERN
─────────────────────────────────────
Instead of throwing exceptions, return a Result<T, E>:

sealed class Result<T, E> { }
class Ok<T, E> extends Result<T, E> { final T value; }
class Err<T, E> extends Result<T, E> { final E error; }

// Caller MUST handle both cases:
switch (result) {
  case Ok(:final value): print(value);
  case Err(:final error): print(error);
}

─────────────────────────────────────
🔁 RETRY PATTERN
─────────────────────────────────────
Future<T> retry<T>(Future<T> Function() fn, {
  int attempts = 3,
  Duration delay = const Duration(seconds: 1),
}) async {
  for (int i = 0; i < attempts; i++) {
    try {
      return await fn();
    } catch (e) {
      if (i == attempts - 1) rethrow;
      await Future.delayed(delay * (1 << i)); // exponential backoff
    }
  }
  throw StateError('unreachable');
}

─────────────────────────────────────
🌐 ZONE ERROR HANDLING
─────────────────────────────────────
runZonedGuarded(body, onError) captures ALL uncaught
errors in the zone — including async ones.

runZonedGuarded(() {
  runApp(MyApp());
}, (error, stack) {
  FirebaseCrashlytics.instance.recordError(error, stack);
});

💻 CODE:
import 'dart:async';

void main() async {
  print('=== Error Handling Patterns ===\n');

  await basicExceptionHandling();
  await customExceptions();
  await resultPatternDemo();
  await retryPatternDemo();
  await asyncErrorHandling();
  zoneErrorHandling();
}

// ── BASIC EXCEPTION HANDLING ──────

Future<void> basicExceptionHandling() async {
  print('--- Basic try/on/catch/finally ---');

  // Catch specific exception types
  try {
    final result = int.parse('not a number');
    print(result);
  } on FormatException catch (e) {
    print('FormatException: \${
e.message}');
  } on RangeError catch (e) {
    print('RangeError: \${
e.message}');
  } catch (e, stackTrace) {
    print('Unknown error: \$e');
    // print(stackTrace);  // available!
  } finally {
    print('Finally runs no matter what');
  }

  // Catching Error subclasses
  try {
    List<int> list = [1, 2, 3];
    print(list[10]);   // RangeError
  } on RangeError catch (e) {
    print('RangeError caught: \${
e.message}');
  }

  // Rethrow preserves stack trace
  try {
    try {
      throw FormatException('bad format');
    } catch (e) {
      print('  Inner caught: \$e');
      rethrow;   // ← preserves original stack trace
    }
  } catch (e) {
    print('  Outer caught: \$e');
  }

  // Async exceptions
  try {
    await Future.delayed(const Duration(milliseconds: 10));
    throw StateError('async error!');
  } on StateError catch (e) {
    print('Async error caught: \$e');
  }
}

// ── CUSTOM EXCEPTIONS ─────────────

Future<void> customExceptions() async {
  print('\n--- Custom Exceptions ---');

  // Try different failure scenarios
  for (final id in ['1', '999', 'bad', '-1']) {
    try {
      final user = await fetchUser(id);
      print('  Found: \${
user['name']}');
    } on NotFoundException catch (e) {
      print('  Not found: \${
e.message}');
    } on ValidationException catch (e) {
      print('  Validation: \${
e.message} (field: \${
e.field})');
    } on ApiException catch (e) {
      print('  API error \${
e.statusCode}: \${
e.message}');
    }
  }
}

class AppException implements Exception {
  final String message;
  const AppException(this.message);
  @override
  String toString() => '\${
runtimeType}: \$message';
}

class NotFoundException extends AppException {
  final String resourceId;
  const NotFoundException(this.resourceId)
      : super('Resource not found: \$resourceId');
}

class ValidationException extends AppException {
  final String field;
  const ValidationException(String message, {required this.field})
      : super(message);
}

class ApiException extends AppException {
  final int statusCode;
  const ApiException(super.message, {required this.statusCode});
}

Future<Map<String, dynamic>> fetchUser(String id) async {
  await Future.delayed(const Duration(milliseconds: 20));

  if (id == 'bad') throw ValidationException('Invalid ID format', field: 'id');
  if (id == '-1') throw ValidationException('ID must be positive', field: 'id');
  if (id == '999') throw NotFoundException(id);
  if (id == '500') throw const ApiException('Internal server error', statusCode: 500);

  return {'id': id, 'name': 'User \$id'};
}

// ── RESULT PATTERN ────────────────

Future<void> resultPatternDemo() async {
  print('\n--- Result Pattern ---');

  for (final input in ['42', 'abc', '-1', '1000']) {
    final result = parsePositiveInt(input);

    switch (result) {
      case Ok(:final value):
        print('  "\$input" → Ok(\$value)');
      case Err(:final error):
        print('  "\$input" → Err(\$error)');
    }
  }

  // Chain results
  final result = parsePositiveInt('42')
      .map((n) => n * 2)          // transform Ok value
      .flatMap((n) => n < 100     // chain another Result
          ? Ok(n)
          : Err('Too large: \$n'));

  print('\nChained: \$result');
}

sealed class Result<T, E> {
  const Result();

  bool get isOk => this is Ok<T, E>;
  bool get isErr => this is Err<T, E>;

  T? get valueOrNull => isOk ? (this as Ok<T, E>).value : null;
  E? get errorOrNull => isErr ? (this as Err<T, E>).error : null;

  Result<R, E> map<R>(R Function(T) f) => switch (this) {
    Ok(:final value) => Ok(f(value)),
    Err(:final error) => Err(error),
  };

  Result<R, E> flatMap<R>(Result<R, E> Function(T) f) => switch (this) {
    Ok(:final value) => f(value),
    Err(:final error) => Err(error),
  };

  T getOrElse(T defaultValue) => valueOrNull ?? defaultValue;

  @override
  String toString() => switch (this) {
    Ok(:final value) => 'Ok(\$value)',
    Err(:final error) => 'Err(\$error)',
  };
}

class Ok<T, E> extends Result<T, E> {
  final T value;
  const Ok(this.value);
}

class Err<T, E> extends Result<T, E> {
  final E error;
  const Err(this.error);
}

Result<int, String> parsePositiveInt(String input) {
  final n = int.tryParse(input);
  if (n == null) return Err('Not a number: "\$input"');
  if (n <= 0) return Err('Must be positive: \$n');
  return Ok(n);
}

// ── RETRY PATTERN ─────────────────

Future<void> retryPatternDemo() async {
  print('\n--- Retry with Backoff ---');

  int attempt = 0;

  try {
    final result = await retry(
      () async {
        attempt++;
        print('  Attempt \$attempt...');
        if (attempt < 3) throw Exception('Transient failure');
        return 'Success on attempt \$attempt!';
      },
      maxAttempts: 5,
      baseDelay: const Duration(milliseconds: 50),
    );
    print('  \$result');
  } catch (e) {
    print('  All attempts failed: \$e');
  }
}

Future<T> retry<T>(
  Future<T> Function() fn, {
  int maxAttempts = 3,
  Duration baseDelay = const Duration(seconds: 1),
  bool Function(Object)? retryIf,
}) async {
  for (int attempt = 1; attempt <= maxAttempts; attempt++) {
    try {
      return await fn();
    } catch (e) {
      final shouldRetry = retryIf?.call(e) ?? true;
      if (!shouldRetry || attempt == maxAttempts) rethrow;

      // Exponential backoff with jitter
      final delay = baseDelay * (1 << (attempt - 1));
      await Future.delayed(delay);
    }
  }
  throw StateError('unreachable');
}

// ── ASYNC ERROR HANDLING ──────────

Future<void> asyncErrorHandling() async {
  print('\n--- Async Error Patterns ---');

  // catchError on Future
  final result = await Future.delayed(
    const Duration(milliseconds: 10),
    () => throw FormatException('bad data'),
  ).catchError(
    (e) => 'default value',
    test: (e) => e is FormatException,  // only catch FormatException
  );
  print('catchError result: \$result');

  // Multiple async operations, collect errors
  final futures = [
    Future.value(1),
    Future.error(Exception('err2')),
    Future.value(3),
    Future.error(Exception('err4')),
  ];

  final results = await Future.wait(
    futures.map((f) => f.then((v) => (value: v, error: null))
        .catchError((e) => (value: null, error: e.toString()))),
  );

  for (final r in results) {
    if (r.error != null) {
      print('  Error: \${
r.error}');
    } else {
      print('  Value: \${
r.value}');
    }
  }
}

// ── ZONE ERROR HANDLING ───────────

void zoneErrorHandling() {
  print('\n--- Zone Error Handling ---');

  runZonedGuarded(
    () {
      // Any uncaught error in this zone is captured
      Future.delayed(const Duration(milliseconds: 10), () {
        throw StateError('Uncaught async error in zone!');
      });
      print('  Zone running — uncaught error will be intercepted');
    },
    (error, stack) {
      // This is where you'd log to Crashlytics/Sentry
      print('  Zone caught: \$error');
    },
  );
}

📝 KEY POINTS:
✅ Use "on SpecificType catch (e)" to catch specific exception types
✅ "rethrow" preserves the original stack trace; "throw e" creates a new one
✅ finally always runs — use it for cleanup regardless of success/failure
✅ Extend Exception for expected failures; Error for programming bugs
✅ The Result<T, E> pattern makes failure explicit in the type system
✅ Retry with exponential backoff for transient failures (network, rate limits)
✅ runZonedGuarded catches all uncaught errors — essential for error reporting
✅ catchError on a Future handles async errors without try/catch
❌ Never catch bare "catch (e)" and ignore it — always log or rethrow
❌ Don't use "throw e" when rethrowing — use "rethrow" to preserve the stack trace
❌ Don't catch Error subclasses in production code — they're programming bugs
''',
  quiz: [
    Quiz(question: 'What is the difference between "rethrow" and "throw e" when rethrowing an exception?', options: [
      QuizOption(text: 'rethrow is for Errors; throw e is for Exceptions', correct: false),
      QuizOption(text: 'rethrow preserves the original stack trace; throw e creates a new stack trace from the rethrow point', correct: true),
      QuizOption(text: 'They are identical — both rethrow the same exception', correct: false),
      QuizOption(text: 'rethrow only works in finally blocks', correct: false),
    ]),
    Quiz(question: 'What is the Result<T, E> pattern used for?', options: [
      QuizOption(text: 'Catching and logging exceptions automatically', correct: false),
      QuizOption(text: 'Making error handling explicit in the type system — callers must handle both Ok and Err cases', correct: true),
      QuizOption(text: 'Retrying failed operations', correct: false),
      QuizOption(text: 'Converting Futures to synchronous code', correct: false),
    ]),
    Quiz(question: 'What does runZonedGuarded do?', options: [
      QuizOption(text: 'Runs code in a separate isolate', correct: false),
      QuizOption(text: 'Catches ALL uncaught errors — including async ones — within the zone', correct: true),
      QuizOption(text: 'Wraps code in a try/catch automatically', correct: false),
      QuizOption(text: 'Guards against null pointer exceptions only', correct: false),
    ]),
  ],
);
