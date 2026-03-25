import '../../models/lesson.dart';
import '../../models/quiz.dart';

final dartLesson55 = Lesson(
  language: 'Dart',
  title: 'Async Patterns Deep Dive',
  content: '''
🎯 METAPHOR:
A Completer is like a restaurant order ticket.
The kitchen (async operation) gets the ticket when
the order is placed. The waiter (your code) hands the
customer a Future (the receipt number). When the kitchen
finishes, the chef calls "order up!" (completer.complete())
and the waiter delivers the food (Future resolves). If
something goes wrong, the chef calls "fire!" (completer
.completeError()). The key: the kitchen controls WHEN
the future resolves. This is the bridge between callback-
based old code and the modern Future world.

📖 EXPLANATION:
Beyond basic async/await, Dart has advanced async patterns:
Completer (manually create and resolve Futures), StreamController
(create and feed Streams), Future.wait/any/forEach for combining
Futures, and async generators (async*) for producing streams.

─────────────────────────────────────
📋 COMPLETER
─────────────────────────────────────
A Completer creates a Future you can complete manually.

final completer = Completer<String>();
final future = completer.future;   // the Future to await

// Complete it later:
completer.complete('result');       // resolves the Future
completer.completeError(error);     // rejects with error

// Check if already completed:
completer.isCompleted  → bool

─────────────────────────────────────
🌊 STREAMCONTROLLER
─────────────────────────────────────
A StreamController creates a Stream you feed manually.

final controller = StreamController<int>();
final stream = controller.stream;

controller.add(42);              // emit a value
controller.addError(exception);  // emit an error
controller.close();              // signal completion

// Broadcast stream (multiple listeners):
StreamController.broadcast()
  → multiple listeners can subscribe
  → single: only one listener at a time

─────────────────────────────────────
⚡ FUTURE COMBINATORS
─────────────────────────────────────
Future.wait(list)        → wait for ALL, return List<T>
Future.any(list)         → first to complete wins
Future.forEach(list, fn) → run fn for each, sequentially
Future.value(v)          → already-resolved Future
Future.error(e)          → already-rejected Future
Future.delayed(dur, fn)  → delayed Future
Future.sync(fn)          → synchronous completion

─────────────────────────────────────
🔄 ASYNC GENERATORS (async*)
─────────────────────────────────────
Stream<T> myStream() async* {
  yield value;           // emit one value
  yield* otherStream;    // emit all of another stream
  await Future.delayed(dur);  // async operations work!
}

─────────────────────────────────────
🔀 STREAM TRANSFORMATIONS
─────────────────────────────────────
stream.map((e) => ...)
stream.where((e) => ...)
stream.take(n)
stream.skip(n)
stream.distinct()
stream.asyncMap((e) async => ...)
stream.timeout(duration)
stream.handleError((e) => ...)
stream.transform(StreamTransformer)

─────────────────────────────────────
⏰ TIMER & PERIODIC
─────────────────────────────────────
Timer(duration, callback)           → fire once after delay
Timer.periodic(duration, callback)  → fire repeatedly

💻 CODE:
import 'dart:async';

void main() async {
  print('=== Async Patterns Demo ===\n');

  await completerExample();
  await streamControllerExample();
  await futureCombinators();
  await asyncGeneratorExample();
  timerExample();
}

// ── COMPLETER ─────────────────────

Future<void> completerExample() async {
  print('--- Completer ---');

  // Bridge callback to Future
  final result = await callbackToFuture();
  print('Result: \$result');

  // Timeout with completer
  try {
    final timedResult = await withTimeout(
      slowOperation(),
      const Duration(milliseconds: 500),
    );
    print('Timed result: \$timedResult');
  } on TimeoutException catch (e) {
    print('Timed out: \$e');
  }
}

// Convert callback-based API to Future
Future<String> callbackToFuture() {
  final completer = Completer<String>();

  // Simulate an old callback-based API
  _legacyApi('hello', (result) {
    completer.complete(result);
  }, (error) {
    completer.completeError(error);
  });

  return completer.future;
}

void _legacyApi(
  String input,
  void Function(String) onSuccess,
  void Function(Object) onError,
) {
  Future.delayed(const Duration(milliseconds: 100), () {
    onSuccess('Processed: \$input');
  });
}

// Timeout wrapper
Future<T> withTimeout<T>(Future<T> future, Duration timeout) {
  final completer = Completer<T>();

  future.then((value) {
    if (!completer.isCompleted) completer.complete(value);
  }).catchError((error) {
    if (!completer.isCompleted) completer.completeError(error);
  });

  Future.delayed(timeout, () {
    if (!completer.isCompleted) {
      completer.completeError(TimeoutException('Timed out', timeout));
    }
  });

  return completer.future;
}

Future<String> slowOperation() async {
  await Future.delayed(const Duration(seconds: 2));
  return 'Done';
}

// ── STREAMCONTROLLER ──────────────

Future<void> streamControllerExample() async {
  print('\n--- StreamController ---');

  // Single-subscription stream
  final controller = StreamController<int>();

  // Listen to the stream
  final subscription = controller.stream.listen(
    (value) => print('  Value: \$value'),
    onError: (e) => print('  Error: \$e'),
    onDone: () => print('  Stream closed!'),
  );

  // Feed values
  controller.add(1);
  controller.add(2);
  controller.add(3);
  controller.addError(Exception('oops'));
  controller.add(4);
  await controller.close();

  // ── Broadcast stream ──
  print('\nBroadcast stream:');
  final broadcast = StreamController<String>.broadcast();

  // Multiple listeners!
  broadcast.stream.listen((s) => print('  Listener 1: \$s'));
  broadcast.stream.listen((s) => print('  Listener 2: \$s'));

  broadcast.add('hello');
  broadcast.add('world');
  await broadcast.close();

  // ── Stream from scratch ──
  print('\nCustom temperature sensor:');
  final sensor = TemperatureSensor(initialTemp: 20.0);
  await for (final temp in sensor.readings.take(5)) {
    print('  Temp: ${
temp.toStringAsFixed(1)}°C');
  }
  sensor.dispose();
}

class TemperatureSensor {
  final StreamController<double> _controller = StreamController<double>();
  late final Timer _timer;
  double _current;

  TemperatureSensor({required double initialTemp})
      : _current = initialTemp {
    _timer = Timer.periodic(const Duration(milliseconds: 200), (_) {
      _current += (DateTime.now().millisecond % 3 - 1) * 0.5;
      _controller.add(_current);
    });
  }

  Stream<double> get readings => _controller.stream;

  void dispose() {
    _timer.cancel();
    _controller.close();
  }
}

// ── FUTURE COMBINATORS ────────────

Future<void> futureCombinators() async {
  print('\n--- Future Combinators ---');

  // Future.wait — all must succeed
  print('Future.wait:');
  final start = DateTime.now();
  final results = await Future.wait([
    _fetch('user-1', 100),
    _fetch('user-2', 200),
    _fetch('user-3', 150),
  ]);
  final elapsed = DateTime.now().difference(start).inMilliseconds;
  print('  Results: \$results in ${
elapsed}ms (all parallel!)');

  // Future.any — first wins
  print('Future.any:');
  final first = await Future.any([
    _fetch('slow', 500),
    _fetch('fast', 50),
    _fetch('medium', 200),
  ]);
  print('  First result: \$first');

  // Future.wait with errors
  try {
    await Future.wait([
      _fetch('ok', 100),
      _fetchError('fail', 50),
    ]);
  } catch (e) {
    print('  wait error caught: \$e');
  }

  // eagerError: collect all errors
  final results2 = await Future.wait(
    [_fetch('a', 100), _fetch('b', 200)],
    eagerError: false,
  );
  print('  results2: \$results2');

  // Future.forEach (sequential)
  print('Sequential forEach:');
  await Future.forEach(['a', 'b', 'c'], (item) async {
    await Future.delayed(const Duration(milliseconds: 50));
    print('  Processed: \$item');
  });
}

Future<String> _fetch(String id, int delayMs) async {
  await Future.delayed(Duration(milliseconds: delayMs));
  return 'data-\$id';
}

Future<String> _fetchError(String id, int delayMs) async {
  await Future.delayed(Duration(milliseconds: delayMs));
  throw Exception('Failed to fetch \$id');
}

// ── ASYNC GENERATORS ──────────────

Future<void> asyncGeneratorExample() async {
  print('\n--- async* Generators ---');

  // Simple async stream
  print('Range stream:');
  await for (final n in asyncRange(1, 6)) {
    print('  \$n');
  }

  // Paginated data (async generator pattern)
  print('\nPaginated API:');
  await for (final batch in paginatedFetch(totalItems: 15, pageSize: 5)) {
    print('  Batch: \$batch');
  }

  // Transform stream with async operations
  print('\nTransformed stream:');
  final ids = Stream.fromIterable([1, 2, 3, 4, 5]);
  final users = ids.asyncMap((id) => _fetch('user-\$id', 30));
  await for (final user in users.take(3)) {
    print('  \$user');
  }
}

Stream<int> asyncRange(int start, int end) async* {
  for (int i = start; i < end; i++) {
    await Future.delayed(const Duration(milliseconds: 20));
    yield i;
  }
}

Stream<List<int>> paginatedFetch({
  required int totalItems,
  required int pageSize,
}) async* {
  int offset = 0;
  while (offset < totalItems) {
    await Future.delayed(const Duration(milliseconds: 50));
    final batch = List.generate(
      pageSize.clamp(0, totalItems - offset),
      (i) => offset + i + 1,
    );
    yield batch;
    offset += pageSize;
  }
}

// ── TIMER ─────────────────────────

void timerExample() {
  print('\n--- Timers ---');

  // One-shot
  Timer(const Duration(milliseconds: 100), () {
    print('  Timer fired once!');
  });

  // Periodic
  int count = 0;
  final periodic = Timer.periodic(const Duration(milliseconds: 150), (timer) {
    count++;
    print('  Tick \$count');
    if (count >= 3) {
      timer.cancel();
      print('  Timer cancelled!');
    }
  });

  print('  Timers scheduled (will fire shortly)');
}

📝 KEY POINTS:
✅ Completer bridges callback-based APIs to the Future world
✅ Completer.isCompleted prevents double-completion errors
✅ StreamController.broadcast() allows multiple listeners; default allows only one
✅ Future.wait runs all Futures IN PARALLEL and waits for all to complete
✅ Future.any returns the FIRST Future to complete (others continue but are ignored)
✅ async* with yield creates a Stream — values are produced lazily
✅ .asyncMap() on a Stream applies an async transformation to each event
✅ StreamController must be closed when done — otherwise the stream never ends
❌ Don't complete a Completer twice — check isCompleted first
❌ A single-subscription stream can only have ONE listener — use broadcast for multiple
❌ Never forget to cancel Timer.periodic — it will run forever otherwise
''',
  quiz: [
    Quiz(question: 'What problem does Completer solve?', options: [
      QuizOption(text: 'It makes Futures faster to resolve', correct: false),
      QuizOption(text: 'It bridges callback-based APIs to Futures — you control when the Future completes', correct: true),
      QuizOption(text: 'It cancels Futures that take too long', correct: false),
      QuizOption(text: 'It combines multiple Futures into one', correct: false),
    ]),
    Quiz(question: 'What does Future.wait([f1, f2, f3]) do?', options: [
      QuizOption(text: 'Runs f1, then f2, then f3 sequentially', correct: false),
      QuizOption(text: 'Runs all three in parallel and returns when ALL have completed', correct: true),
      QuizOption(text: 'Returns the first Future to complete', correct: false),
      QuizOption(text: 'Creates a new Future that retries on failure', correct: false),
    ]),
    Quiz(question: 'What is the difference between a regular StreamController and a broadcast StreamController?', options: [
      QuizOption(text: 'Regular is for sync data; broadcast is for async', correct: false),
      QuizOption(text: 'Regular allows only one listener; broadcast allows multiple listeners simultaneously', correct: true),
      QuizOption(text: 'Broadcast controllers are faster', correct: false),
      QuizOption(text: 'Regular controllers buffer events; broadcast drops them', correct: false),
    ]),
  ],
);
