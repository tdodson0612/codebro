import '../../models/lesson.dart';
import '../../models/quiz.dart';

final dartLesson45 = Lesson(
  language: 'Dart',
  title: 'Zones',
  content: '''
🎯 METAPHOR:
A Zone is like an acoustic bubble around your code.
In normal air (default zone), sounds travel naturally.
Inside a special bubble (custom zone), you can make sounds
echo differently, silence certain noises, or replace the
normal sound with a recording. Dart's Zone intercepts
async operations and errors AS they happen — not before,
not after, but in the moment. The bubble wraps everything:
Futures, Timers, microtasks, print() calls, and uncaught
errors. runZonedGuarded is the crash-proof bubble —
nothing escapes undetected.

📖 EXPLANATION:
Zones are execution contexts that can intercept operations
within their scope: print, async callbacks, error handling,
and timer creation. Used by testing frameworks, error
monitoring services (like Sentry), and Flutter's own
framework internally.

─────────────────────────────────────
📦 ZONE OPERATIONS INTERCEPTABLE
─────────────────────────────────────
print          → intercept console output
createTimer    → intercept Timer.new / Timer.periodic
scheduleMicrotask → intercept microtask scheduling
handleUncaughtError → catch all uncaught errors
fork           → create child zones
run/runUnary/runBinary → run code in zone

─────────────────────────────────────
🔑 KEY APIs
─────────────────────────────────────
Zone.current             → current zone

runZoned(body, zoneValues: {...}, zoneSpecification: ...)
  → run code in a new zone with custom behavior

runZonedGuarded(body, (error, stack) => ...)
  → run code catching all uncaught async errors

Zone.current.fork(specification: ...)
  → create a child zone

Zone.current[key]        → read zone-local values
Zone.current.runGuarded(fn) → run in zone, catch errors

ZoneSpecification(
  print: ...,
  scheduleMicrotask: ...,
  createTimer: ...,
  handleUncaughtError: ...,
  fork: ...,
  run: ..., runUnary: ..., runBinary: ...,
)

─────────────────────────────────────
🎯 PRIMARY USE CASES
─────────────────────────────────────
1. Error monitoring (runZonedGuarded for catch-all)
2. Testing (override timers, print)
3. Request scoping (zone-local storage per HTTP request)
4. Performance tracing (intercept async operations)
5. Flutter framework internals

─────────────────────────────────────
🔄 ZONE INHERITANCE
─────────────────────────────────────
Zones form a tree. Every zone has a parent.
Child zones inherit parent zone's behavior unless overridden.
Zone.root is the root (no parent).
Zone.current is always the innermost zone.

─────────────────────────────────────
⚡ ZONE LOCAL VALUES
─────────────────────────────────────
Zones can store key-value pairs, accessible
via Zone.current[key]. Children see parent values
but can override them without affecting parent.

💻 CODE:
import 'dart:async';

void main() async {
  // ── BASIC ZONE ─────────────────
  print('=== Zones ===\n');

  // Override print in a zone
  runZoned(
    () {
      print('This is intercepted');           // → [LOG] This is intercepted
      print('So is this');                    // → [LOG] So is this
    },
    zoneSpecification: ZoneSpecification(
      print: (zone, delegate, zoneThis, line) {
        // Intercept every print call
        delegate.print(zone, zoneThis, '[LOG] \$line');
      },
    ),
  );

  print('Back to normal printing');

  // ── RUNZONEDGUARDED ────────────
  print('\n=== Error Catching ===');

  // Catch ALL async errors — even ones that would normally crash
  runZonedGuarded(
    () async {
      // This error happens in a Future — normally uncaught
      Future.delayed(Duration(milliseconds: 10), () {
        throw Exception('Async error in future!');
      });

      // This timer error too
      Timer(Duration(milliseconds: 20), () {
        throw StateError('Timer callback error!');
      });

      print('Zone started, waiting for errors...');
      await Future.delayed(Duration(milliseconds: 50));
    },
    (error, stack) {
      // This catches EVERYTHING
      print('  Caught: \${error.runtimeType}: \$error');
    },
  );

  await Future.delayed(Duration(milliseconds: 100));

  // ── ZONE-LOCAL STORAGE ─────────
  print('\n=== Zone-Local Storage ===');

  // Create a zone-local key
  final requestIdKey = Object();  // unique key

  // Simulate HTTP request handling with request-scoped data
  Future<void> handleRequest(String requestId) async {
    runZoned(
      () async {
        print('  Request \$requestId: starting');
        await Future.delayed(Duration(milliseconds: 10));
        // Any code in this zone can access the request ID
        final id = Zone.current[requestIdKey] as String;
        print('  Request \$id: finished processing');
      },
      zoneValues: {requestIdKey: requestId},
    );
  }

  // Multiple concurrent requests, each with own zone storage
  await Future.wait([
    handleRequest('REQ-001'),
    handleRequest('REQ-002'),
    handleRequest('REQ-003'),
  ]);

  // ── TIMER INTERCEPTION ─────────
  print('\n=== Timer Interception ===');

  var timerCount = 0;
  final timers = <Object>[];  // track created timers

  runZoned(
    () {
      // These timers are intercepted
      Timer(Duration(milliseconds: 10), () => print('  Timer 1 fired'));
      Timer(Duration(milliseconds: 20), () => print('  Timer 2 fired'));
      print('  Created \$timerCount timers');
    },
    zoneSpecification: ZoneSpecification(
      createTimer: (zone, delegate, zoneThis, duration, callback) {
        timerCount++;
        print('  [ZONE] Creating timer #\$timerCount for \${duration.inMilliseconds}ms');
        return delegate.createTimer(zone, zoneThis, duration, callback);
      },
    ),
  );

  await Future.delayed(Duration(milliseconds: 50));

  // ── ZONE FORK ─────────────────
  print('\n=== Zone Fork ===');

  // Fork creates a child zone that inherits parent behavior
  // but can add its own customizations

  final parentZone = Zone.current;

  // Fork from parent zone
  parentZone.fork(
    specification: ZoneSpecification(
      print: (zone, delegate, zoneThis, line) {
        delegate.print(zone, zoneThis, '  [CHILD ZONE] \$line');
      },
    ),
  ).run(() {
    print('Inside forked zone');       // → [CHILD ZONE] Inside forked zone
    print('Forked zone is active');    // → [CHILD ZONE] Forked zone is active
  });

  print('Back in parent zone');  // normal print

  // ── PERFORMANCE TRACING ────────
  print('\n=== Performance Tracing ===');

  final operationTimes = <String, Duration>{};

  // Zone that traces async operations
  await runZoned(
    () async {
      final sw = Stopwatch()..start();
      await _simulateWork('database query', 50);
      operationTimes['db'] = sw.elapsed;
      sw.reset(); sw.start();
      await _simulateWork('api call', 30);
      operationTimes['api'] = sw.elapsed;
    },
    zoneSpecification: ZoneSpecification(
      scheduleMicrotask: (zone, delegate, zoneThis, fn) {
        // Intercept microtask scheduling
        delegate.scheduleMicrotask(zone, zoneThis, fn);
      },
    ),
  );

  print('Operation times:');
  for (final entry in operationTimes.entries) {
    print('  \${entry.key}: \${entry.value.inMilliseconds}ms');
  }

  // ── ERROR MONITORING PATTERN ───
  print('\n=== Error Monitoring Pattern ===');

  // Simulate Sentry/Crashlytics style error monitoring
  void setupErrorMonitoring(void Function() app) {
    runZonedGuarded(
      app,
      (error, stack) {
        // In real code: send to error monitoring service
        print('[ERROR MONITOR] Caught: \$error');
        print('[ERROR MONITOR] Stack: \${stack.toString().split('\n').first}');
        // Sentry.captureException(error, stackTrace: stack);
      },
    );
  }

  setupErrorMonitoring(() async {
    await Future.delayed(Duration(milliseconds: 10));
    throw Exception('Production error!');
  });

  await Future.delayed(Duration(milliseconds: 50));
  print('\nZones demo complete!');
}

Future<void> _simulateWork(String name, int ms) async {
  print('  Starting \$name...');
  await Future.delayed(Duration(milliseconds: ms));
  print('  Completed \$name');
}

📝 KEY POINTS:
✅ Zones intercept: print, Timers, microtasks, and uncaught errors
✅ runZonedGuarded() catches ALL async errors — perfect for error monitoring
✅ Zone.current[key] provides zone-local storage — like thread-local storage
✅ runZoned() with zoneValues creates scoped data for async operations
✅ Zone.fork() creates a child zone inheriting parent behavior
✅ Zones form a tree — Zone.root is the ancestor of all zones
✅ Flutter test framework uses zones to fake Timer.periodic for testing
✅ Error monitoring SDKs wrap the app in runZonedGuarded
❌ Zones are advanced — use runZonedGuarded for error monitoring, skip the rest until needed
❌ Zone-local storage is per-zone, not per-isolate — don't confuse them
❌ Overriding scheduleMicrotask incorrectly can break async behavior
''',
  quiz: [
    Quiz(question: 'What is the primary practical use of runZonedGuarded()?', options: [
      QuizOption(text: 'Making async code faster', correct: false),
      QuizOption(text: 'Catching ALL uncaught async errors that would otherwise crash the app silently', correct: true),
      QuizOption(text: 'Creating isolated execution contexts', correct: false),
      QuizOption(text: 'Running code on a separate thread', correct: false),
    ]),
    Quiz(question: 'What does Zone.current[key] provide?', options: [
      QuizOption(text: 'The current error in the zone', correct: false),
      QuizOption(text: 'Zone-local storage — values scoped to the current zone and its children', correct: true),
      QuizOption(text: 'The index of the current zone', correct: false),
      QuizOption(text: 'A lock for synchronized access', correct: false),
    ]),
    Quiz(question: 'What ZoneSpecification option do you override to intercept print() calls?', options: [
      QuizOption(text: 'The log handler', correct: false),
      QuizOption(text: 'The print handler in ZoneSpecification', correct: true),
      QuizOption(text: 'The stdout specification', correct: false),
      QuizOption(text: 'The output delegate', correct: false),
    ]),
  ],
);
