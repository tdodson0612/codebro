import '../../models/lesson.dart';
import '../../models/quiz.dart';

final dartLesson58 = Lesson(
  language: 'Dart',
  title: 'Stream Transformers & Advanced Streams',
  content: '''
🎯 METAPHOR:
Stream transformers are like a production assembly line.
Raw materials (events) enter one end of the line. At each
station (transformer), something happens to the materials:
a quality filter removes defects (where), a machine reshapes
parts (map), a conveyor slows parts down when the output
queue is full (backpressure). At the end of the line, the
consumer receives only the finished, shaped, tested product.
You can bolt different stations onto the same line —
debounce (bundle rapid events), throttle (slow down high-
frequency events), or merge (combine two lines). This is
reactive programming: treating events as a river of data
you shape with composable operators.

📖 EXPLANATION:
Streams support powerful transformation pipelines.
StreamTransformer<S, T> converts a Stream<S> to Stream<T>.
Key patterns: debouncing, throttling, merging, buffering,
scan (running accumulation), and custom transformers.

─────────────────────────────────────
📦 BUILT-IN STREAM OPERATIONS
─────────────────────────────────────
stream.map((e) => ...)           → transform each event
stream.where((e) => ...)         → filter events
stream.take(n)                   → first n events
stream.skip(n)                   → skip first n events
stream.distinct()                → skip duplicate consecutive
stream.asyncMap((e) async => ..) → async transform
stream.expand((e) => [...])      → flatMap
stream.handleError((e) => ...)   → recover from errors
stream.timeout(dur)              → error after silence
stream.transform(transformer)    → apply custom transformer
stream.pipe(sink)                → connect to sink
stream.forEach(fn)               → consume all events

─────────────────────────────────────
🔀 STREAM TRANSFORMERS
─────────────────────────────────────
// Create a reusable transformer:
StreamTransformer<S, T>.fromHandlers(
  handleData: (data, sink) { sink.add(transformed); },
  handleError: (error, stack, sink) { sink.addError(error); },
  handleDone: (sink) { sink.close(); },
)

// Or implement StreamTransformer:
class MyTransformer<S, T> extends StreamTransformerBase<S, T> {
  @override
  Stream<T> bind(Stream<S> stream) { ... }
}

─────────────────────────────────────
⏱️  TIME-BASED OPERATORS
─────────────────────────────────────
Debounce: wait for a pause before emitting
  → typing in a search box: wait 300ms after last keystroke

Throttle: emit at most once per interval
  → scroll events: process max 60 times/second

Buffer: collect events into batches
  → API calls: batch every 100ms into single request

─────────────────────────────────────
🔗 COMBINING STREAMS
─────────────────────────────────────
StreamGroup.merge([s1, s2])   → merge multiple streams
StreamZip([s1, s2])           → zip values together
rxdart package: CombineLatestStream, ZipStream, MergeStream

─────────────────────────────────────
📦 RXDART
─────────────────────────────────────
pub add rxdart

BehaviorSubject   → StreamController that replays last value
PublishSubject    → broadcast StreamController
ReplaySubject     → replays n last values

Stream extensions: debounceTime, throttleTime, switchMap,
                   combineLatest, withLatestFrom

💻 CODE:
import 'dart:async';

void main() async {
  print('=== Advanced Streams ===\n');

  await builtinTransformations();
  await customTransformers();
  await timeBasedPatterns();
  await scanAndAccumulate();
  await errorHandlingInStreams();
}

// ── BUILT-IN TRANSFORMATIONS ──────

Future<void> builtinTransformations() async {
  print('--- Built-in Transformations ---');

  final stream = Stream.fromIterable([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);

  // map + where + take
  final result = await stream
      .where((n) => n % 2 == 0)       // keep evens: 2,4,6,8,10
      .map((n) => n * n)               // square: 4,16,36,64,100
      .take(3)                          // first 3: 4,16,36
      .toList();
  print('Pipeline: \$result');  // [4, 16, 36]

  // distinct — skip consecutive duplicates
  final withDupes = Stream.fromIterable([1, 1, 2, 2, 2, 3, 1, 1]);
  final unique = await withDupes.distinct().toList();
  print('Distinct: \$unique');  // [1, 2, 3, 1]

  // asyncMap — async transformation
  final ids = Stream.fromIterable([1, 2, 3]);
  final fetched = await ids
      .asyncMap((id) => _fetchUser(id))
      .toList();
  print('Fetched: \$fetched');  // [User-1, User-2, User-3]

  // expand — flatMap
  final nested = Stream.fromIterable([[1,2], [3,4], [5,6]]);
  final flat = await nested.expand((list) => list).toList();
  print('Flat: \$flat');  // [1, 2, 3, 4, 5, 6]

  // scan (running total using fold-like operation)
  // Note: scan is not built-in but easy to implement
  final nums = Stream.fromIterable([1, 2, 3, 4, 5]);
  final running = await scanStream(nums, 0, (acc, n) => acc + n).toList();
  print('Running totals: \$running');  // [1, 3, 6, 10, 15]
}

Future<String> _fetchUser(int id) async {
  await Future.delayed(const Duration(milliseconds: 10));
  return 'User-\$id';
}

// ── CUSTOM TRANSFORMERS ───────────

Future<void> customTransformers() async {
  print('\n--- Custom StreamTransformers ---');

  // Debounce transformer
  final ctrl = StreamController<String>();

  final debounced = ctrl.stream.transform(DebounceTransformer(
    const Duration(milliseconds: 200),
  ));

  debounced.listen((value) => print('  Debounced: \$value'));

  // Simulate rapid typing
  ctrl.add('h');
  ctrl.add('he');
  ctrl.add('hel');
  ctrl.add('hell');
  ctrl.add('hello');

  await Future.delayed(const Duration(milliseconds: 300));
  // Only 'hello' is emitted (last value after pause)

  ctrl.close();
  await Future.delayed(const Duration(milliseconds: 100));

  // Log transformer
  final numbers = Stream.fromIterable([1, 2, 3, 4, 5]);
  final logged = numbers.transform(LogTransformer('Numbers'));
  await logged.toList();
}

// Debounce: emit only after a pause of [delay]
class DebounceTransformer<T> extends StreamTransformerBase<T, T> {
  final Duration delay;
  DebounceTransformer(this.delay);

  @override
  Stream<T> bind(Stream<T> stream) {
    final controller = StreamController<T>();
    Timer? debounceTimer;

    stream.listen(
      (event) {
        debounceTimer?.cancel();
        debounceTimer = Timer(delay, () => controller.add(event));
      },
      onDone: () {
        debounceTimer?.cancel();
        controller.close();
      },
      onError: controller.addError,
    );

    return controller.stream;
  }
}

// Log transformer (for debugging streams)
class LogTransformer<T> extends StreamTransformerBase<T, T> {
  final String tag;
  int _count = 0;

  LogTransformer(this.tag);

  @override
  Stream<T> bind(Stream<T> stream) {
    return stream.map((event) {
      _count++;
      print('  [\$tag #\$_count]: \$event');
      return event;
    });
  }
}

// ── TIME-BASED PATTERNS ───────────

Future<void> timeBasedPatterns() async {
  print('\n--- Time-Based Patterns ---');

  // Throttle: emit at most once per interval
  final ctrl = StreamController<int>();
  int value = 0;

  // Simulate 20 events in 100ms
  final timer = Timer.periodic(const Duration(milliseconds: 5), (_) {
    ctrl.add(value++);
  });

  // Throttled: only emit every 25ms
  final throttled = ctrl.stream.transform(ThrottleTransformer(
    const Duration(milliseconds: 25),
  ));

  final collected = <int>[];
  final sub = throttled.listen(collected.add);

  await Future.delayed(const Duration(milliseconds: 120));
  timer.cancel();
  await ctrl.close();
  await sub.cancel();

  print('  ${
value} events → ${
collected.length} throttled: \$collected');

  // Buffer: collect events in time windows
  final source = Stream.periodic(
    const Duration(milliseconds: 20),
    (i) => i,
  ).take(10);

  final buffered = source.transform(BufferTransformer(
    const Duration(milliseconds: 50),
  ));

  await for (final batch in buffered) {
    print('  Batch: \$batch');
  }
}

// Throttle: emit first event, ignore rest for [interval]
class ThrottleTransformer<T> extends StreamTransformerBase<T, T> {
  final Duration interval;
  ThrottleTransformer(this.interval);

  @override
  Stream<T> bind(Stream<T> stream) {
    final controller = StreamController<T>();
    DateTime? lastEmit;

    stream.listen(
      (event) {
        final now = DateTime.now();
        if (lastEmit == null || now.difference(lastEmit!) >= interval) {
          lastEmit = now;
          controller.add(event);
        }
      },
      onDone: controller.close,
      onError: controller.addError,
    );

    return controller.stream;
  }
}

// Buffer: collect events in time windows
class BufferTransformer<T> extends StreamTransformerBase<T, List<T>> {
  final Duration window;
  BufferTransformer(this.window);

  @override
  Stream<List<T>> bind(Stream<T> stream) {
    final controller = StreamController<List<T>>();
    List<T> buffer = [];
    Timer? windowTimer;

    void flush() {
      if (buffer.isNotEmpty) {
        controller.add(List.of(buffer));
        buffer.clear();
      }
    }

    stream.listen(
      (event) {
        buffer.add(event);
        windowTimer ??= Timer(window, () {
          flush();
          windowTimer = null;
        });
      },
      onDone: () {
        windowTimer?.cancel();
        flush();
        controller.close();
      },
      onError: controller.addError,
    );

    return controller.stream;
  }
}

// ── SCAN & ACCUMULATE ─────────────

Future<void> scanAndAccumulate() async {
  print('\n--- Scan (Running Accumulation) ---');

  // Running sum
  final nums = Stream.fromIterable([1, 2, 3, 4, 5]);
  print('Running sum:');
  await for (final total in scanStream(nums, 0, (acc, n) => acc + n)) {
    print('  \$total');  // 1, 3, 6, 10, 15
  }

  // Running max
  final prices = Stream.fromIterable([3.5, 1.2, 4.0, 2.8, 5.1, 1.9]);
  final runningMax = await scanStream(
    prices, 0.0, (max, p) => p > max ? p : max,
  ).toList();
  print('Running max: \$runningMax');
}

Stream<R> scanStream<T, R>(
  Stream<T> source,
  R initialValue,
  R Function(R acc, T value) combine,
) async* {
  R accumulator = initialValue;
  await for (final value in source) {
    accumulator = combine(accumulator, value);
    yield accumulator;
  }
}

// ── ERROR HANDLING IN STREAMS ─────

Future<void> errorHandlingInStreams() async {
  print('\n--- Stream Error Handling ---');

  final errorStream = Stream.fromIterable([1, 2, 3, 4, 5])
      .map((n) {
        if (n == 3) throw Exception('Error at \$n!');
        return n;
      });

  // handleError — recover from errors
  final recovered = errorStream.handleError(
    (e) => print('  Caught error: \$e'),
  );

  await for (final n in recovered) {
    print('  Got: \$n');  // 1, 2, [error caught], 4, 5
  }

  // Transform errors to values
  final safeStream = Stream.fromIterable([1, 2, 3, 4, 5])
      .map((n) => n == 3 ? throw Exception('bad \$n') : n)
      .handleError((e) {}, test: (e) => e is Exception)
      .where((n) => n != null);

  print('Safe values: ${
await safeStream.toList()}');

  // onError in listen
  final ctrl = StreamController<int>();
  ctrl.stream.listen(
    (n) => print('  Value: \$n'),
    onError: (e) => print('  Error: \$e'),
    onDone: () => print('  Done'),
    cancelOnError: false,  // don't cancel on error
  );

  ctrl.add(1);
  ctrl.addError(Exception('oops'));
  ctrl.add(2);
  await ctrl.close();
  await Future.delayed(const Duration(milliseconds: 10));
}

📝 KEY POINTS:
✅ StreamTransformer converts a Stream<S> to Stream<T> — reusable and composable
✅ Debounce emits after a pause; throttle emits at most once per interval
✅ distinct() removes consecutive duplicate values (not all duplicates)
✅ asyncMap allows async operations inside stream transformations
✅ handleError recovers from stream errors without canceling the stream
✅ cancelOnError: false in listen lets the stream continue after errors
✅ scan (running accumulation) is not built-in but easy to implement with async*
✅ Buffer collects events into batches — good for batching API calls
❌ Don't forget to close StreamControllers — unclosed controllers cause memory leaks
❌ asyncMap processes events sequentially — use transform for concurrent processing
❌ distinct() only removes CONSECUTIVE duplicates — not all duplicates like a Set would
''',
  quiz: [
    Quiz(question: 'What does the debounce pattern do for a stream?', options: [
      QuizOption(text: 'Removes duplicate consecutive values', correct: false),
      QuizOption(text: 'Emits only after a period of silence — suppresses events that arrive too quickly', correct: true),
      QuizOption(text: 'Delays every event by a fixed amount', correct: false),
      QuizOption(text: 'Emits events in batches at regular intervals', correct: false),
    ]),
    Quiz(question: 'What does stream.distinct() do?', options: [
      QuizOption(text: 'Removes all duplicate values from the entire stream', correct: false),
      QuizOption(text: 'Skips consecutive duplicate values — emits only when the value changes', correct: true),
      QuizOption(text: 'Deduplicates using a Set internally', correct: false),
      QuizOption(text: 'Sorts the stream to group duplicates', correct: false),
    ]),
    Quiz(question: 'What is the StreamTransformerBase used for?', options: [
      QuizOption(text: 'A base class for stream error handlers', correct: false),
      QuizOption(text: 'Creating reusable stream transformations that convert Stream<S> to Stream<T>', correct: true),
      QuizOption(text: 'The base class for all Dart streams', correct: false),
      QuizOption(text: 'Converting synchronous functions to async streams', correct: false),
    ]),
  ],
);
