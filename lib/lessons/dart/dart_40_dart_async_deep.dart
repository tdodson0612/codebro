import '../../models/lesson.dart';
import '../../models/quiz.dart';

final dartLesson40 = Lesson(
  language: 'Dart',
  title: 'dart:async Deep Dive',
  content: '''
🎯 METAPHOR:
dart:async is the orchestra conductor's toolkit.
Future is one musician playing one note.
Stream is the whole orchestra playing a symphony.
Completer is the podium with a buzzer — you control
when the performance ends. StreamController is the
stage manager who decides when musicians can play.
Zones are like different concert halls — each hall can
intercept the sound (errors, async operations) differently.
Together they orchestrate everything asynchronous in Dart.

📖 EXPLANATION:
dart:async provides the full async infrastructure:
Future, Stream, Completer, StreamController, StreamTransformer,
Zone, Timer, and scheduleMicrotask. Understanding these
deeply lets you build sophisticated async architectures.

─────────────────────────────────────
📦 KEY CLASSES
─────────────────────────────────────
Future<T>           → single async value
Stream<T>           → series of async values
Completer<T>        → manual Future control
StreamController<T> → manual Stream control
StreamTransformer<S,T> → transform streams
StreamSink<T>       → write side of a stream
EventSink<T>        → add/addError/close
Zone                → execution context with hooks
ZoneSpecification   → customize zone behavior
ZoneDelegate        → delegate zone operations
Timer               → scheduled callbacks
scheduleMicrotask() → queue a microtask

─────────────────────────────────────
🔑 COMPLETER
─────────────────────────────────────
Manually control when a Future completes:
  final c = Completer<String>();
  c.future   → the Future (give to consumers)
  c.complete(value)      → complete with value
  c.completeError(error) → complete with error
  c.isCompleted  → bool

Use for converting callback APIs to Futures.

─────────────────────────────────────
🌊 STREAM TRANSFORMER
─────────────────────────────────────
Transform streams as they flow:
  stream.transform(myTransformer)

Built-in:
  utf8.decoder          → bytes → String
  LineSplitter()        → String → lines

Custom:
  StreamTransformer.fromHandlers(
    handleData: (data, sink) => sink.add(process(data)),
    handleError: (err, stack, sink) => sink.addError(err),
    handleDone: (sink) => sink.close(),
  )

─────────────────────────────────────
⚡ ZONES
─────────────────────────────────────
Zones create scoped execution contexts.
They intercept:
  • Uncaught errors (runZonedGuarded)
  • Timer creation
  • microtask scheduling
  • print calls

Used by Flutter test framework, error reporters,
and instrumentation libraries.

─────────────────────────────────────
🔄 MICROTASK QUEUE
─────────────────────────────────────
scheduleMicrotask(() => ...)
  Runs before any events (I/O, timers).
  Used by Future.then() callbacks.
  Should be used sparingly — blocks event loop if overused.

Event queue (Timers, I/O) runs AFTER microtask queue drains.

💻 CODE:
import 'dart:async';

void main() async {
  // ── COMPLETER ──────────────────
  print('=== Completer ===');

  // Convert a callback API to Future
  Future<String> fetchWithTimeout() {
    final completer = Completer<String>();

    // Simulate callback-based API
    Timer(Duration(milliseconds: 100), () {
      if (!completer.isCompleted) {
        completer.complete('Fetched data!');
      }
    });

    // Add a timeout
    Timer(Duration(milliseconds: 50), () {
      if (!completer.isCompleted) {
        completer.completeError(TimeoutException('Too slow!'));
      }
    });

    return completer.future;
  }

  try {
    final result = await fetchWithTimeout();
    print('Result: \$result');
  } on TimeoutException catch (e) {
    print('Timed out: \$e');   // ← this happens (50ms < 100ms)
  }

  // ── STREAM CONTROLLER ──────────
  print('\n=== StreamController ===');

  final ctrl = StreamController<int>();

  // Single subscription stream
  ctrl.stream.listen(
    (data) => print('  Data: \$data'),
    onError: (e) => print('  Error: \$e'),
    onDone: () => print('  Done!'),
  );

  ctrl.add(1);
  ctrl.add(2);
  ctrl.addError(Exception('oops'));
  ctrl.add(3);
  ctrl.close();

  await Future.delayed(Duration(milliseconds: 10));

  // Broadcast stream controller
  final bcast = StreamController<String>.broadcast();

  bcast.stream.listen((s) => print('  A: \$s'));
  bcast.stream.listen((s) => print('  B: \${s.toUpperCase()}'));

  bcast.add('hello');
  bcast.add('world');
  bcast.close();

  await Future.delayed(Duration(milliseconds: 10));

  // ── STREAM TRANSFORMERS ────────
  print('\n=== Stream Transformers ===');

  // Custom transformer: double each number
  final doubler = StreamTransformer<int, int>.fromHandlers(
    handleData: (data, sink) => sink.add(data * 2),
    handleError: (err, stack, sink) {
      print('  Transformer caught error: \$err');
      // Don't propagate — transform error to 0
      sink.add(0);
    },
    handleDone: (sink) => sink.close(),
  );

  final doubled = Stream.fromIterable([1, 2, 3, 4, 5])
      .transform(doubler);

  await doubled.forEach((n) => print('  Doubled: \$n'));

  // Stateful transformer (sliding window average)
  final smoother = slidingAverage(3);
  final data = Stream.fromIterable([10.0, 20.0, 30.0, 40.0, 50.0]);
  await data.transform(smoother).forEach((avg) => print('  Avg: \$avg'));

  // ── ZONES ─────────────────────
  print('\n=== Zones ===');

  // Catch all uncaught errors in a zone
  runZonedGuarded(
    () async {
      print('  Zone started');
      // This error would normally be uncaught:
      Future.delayed(Duration(milliseconds: 10), () {
        throw Exception('Async error in zone!');
      });
      await Future.delayed(Duration(milliseconds: 50));
    },
    (error, stack) {
      print('  Zone caught: \$error');
    },
  );

  await Future.delayed(Duration(milliseconds: 60));

  // Custom zone with print override
  runZoned(
    () {
      print('This is intercepted!');   // goes to custom handler
      print('Me too!');
    },
    zoneSpecification: ZoneSpecification(
      print: (zone, delegate, zoneThis, line) {
        delegate.print(zone, zoneThis, '  [ZONE LOG] \$line');
      },
    ),
  );

  // ── MICROTASK QUEUE ────────────
  print('\n=== Microtask vs Event Queue ===');

  print('1. Start');

  scheduleMicrotask(() => print('3. Microtask 1'));
  scheduleMicrotask(() => print('4. Microtask 2'));

  Timer(Duration.zero, () => print('5. Timer (event queue)'));

  Future(() => print('6. Future (event queue)'));

  print('2. End of sync code');

  // Order: 1, 2, 3, 4, 5 or 6 (microtasks before events)

  await Future.delayed(Duration(milliseconds: 10));

  // ── STREAM UTILITIES ───────────
  print('\n=== Stream Utilities ===');

  // merge multiple streams
  final s1 = Stream.periodic(Duration(milliseconds: 100), (i) => 'A\$i').take(3);
  final s2 = Stream.periodic(Duration(milliseconds: 150), (i) => 'B\$i').take(2);

  // StreamGroup.merge (from package:async) — shown manually:
  final merged = StreamController<String>.broadcast();
  s1.listen(merged.add, onDone: () {});
  s2.listen(merged.add, onDone: () {
    Future.delayed(Duration(milliseconds: 100), merged.close);
  });

  await merged.stream.forEach((e) => print('  Merged: \$e'));

  // ── STREAMSUBSCRIPTION ─────────
  print('\n=== StreamSubscription ===');

  final subscription = Stream.periodic(Duration(milliseconds: 50), (i) => i)
      .listen((i) {
        print('  Tick \$i');
      });

  subscription.pause();
  await Future.delayed(Duration(milliseconds: 100));
  print('  (paused 100ms)');
  subscription.resume();
  await Future.delayed(Duration(milliseconds: 150));
  await subscription.cancel();
  print('  Subscription cancelled');

  print('\ndart:async deep dive complete!');
}

// Custom sliding window average transformer
StreamTransformer<double, double> slidingAverage(int windowSize) {
  final window = <double>[];
  return StreamTransformer.fromHandlers(
    handleData: (data, sink) {
      window.add(data);
      if (window.length > windowSize) window.removeAt(0);
      final avg = window.reduce((a, b) => a + b) / window.length;
      sink.add(avg);
    },
    handleDone: (sink) => sink.close(),
  );
}

📝 KEY POINTS:
✅ Completer converts callback-based APIs to Futures
✅ Completer.isCompleted prevents double-completion errors
✅ StreamController.broadcast() allows multiple listeners
✅ StreamTransformer transforms stream values while they flow
✅ runZonedGuarded catches ALL async errors in a zone — perfect for error reporting
✅ Microtasks run BEFORE events — scheduleMicrotask has higher priority than Timer
✅ StreamSubscription.pause/resume/cancel gives fine control over stream listening
✅ Zone.current gives access to the current zone context
❌ Single-subscription streams throw if listened to twice — use broadcast()
❌ Closing a StreamController without draining it may lose buffered events
❌ Don't overuse scheduleMicrotask — excessive microtasks starve the event queue
''',
  quiz: [
    Quiz(question: 'What is a Completer<T> used for?', options: [
      QuizOption(text: 'Completing a Stream', correct: false),
      QuizOption(text: 'Manually controlling when a Future completes and with what value', correct: true),
      QuizOption(text: 'Adding error handling to async functions', correct: false),
      QuizOption(text: 'Cancelling a running async operation', correct: false),
    ]),
    Quiz(question: 'What does runZonedGuarded() enable?', options: [
      QuizOption(text: 'Running code in a separate thread', correct: false),
      QuizOption(text: 'Catching all uncaught async errors in a guarded zone', correct: true),
      QuizOption(text: 'Creating a secure execution context', correct: false),
      QuizOption(text: 'Running code with a timeout', correct: false),
    ]),
    Quiz(question: 'What is the execution order: sync code, scheduleMicrotask, Timer(Duration.zero)?', options: [
      QuizOption(text: 'Timer runs first, then sync code, then microtask', correct: false),
      QuizOption(text: 'Sync code first, then microtask, then Timer', correct: true),
      QuizOption(text: 'All run in the order they are written', correct: false),
      QuizOption(text: 'Microtask first, then sync code, then Timer', correct: false),
    ]),
  ],
);
