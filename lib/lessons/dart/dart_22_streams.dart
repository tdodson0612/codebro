import '../../models/lesson.dart';
import '../../models/quiz.dart';

final dartLesson22 = Lesson(
  language: 'Dart',
  title: 'Streams',
  content: '''
🎯 METAPHOR:
A Stream is like a river of data flowing past you.
A Future is a one-time delivery (a package arrives once).
A Stream is a continuous flow — data keeps arriving:
sensor readings, keyboard events, websocket messages,
file bytes. You stand by the river (listen) and process
each piece of data as it floats by. You can also
put up filters (where), transform the water (map),
or combine rivers (zip, merge). The async* function
is the source — a spring that yields water droplets
one at a time.

📖 EXPLANATION:
Stream<T> emits zero or more values over time, then
optionally completes or errors. Single-subscription streams
can only be listened to once. Broadcast streams allow
multiple listeners. async* functions create streams with
yield. await for loops consume them.

─────────────────────────────────────
📐 CREATING STREAMS
─────────────────────────────────────
Stream.fromIterable([1,2,3])    → from a list
Stream.fromFuture(myFuture)     → wraps a Future
Stream.periodic(interval, (i)=>i) → tick every interval
Stream.value(v)                 → single value, then done
Stream.error(e)                 → single error, then done
StreamController<T>             → manual stream creation

async* function with yield      → generator stream

─────────────────────────────────────
🔑 CONSUMING STREAMS
─────────────────────────────────────
// await for (clearest way, in async context)
await for (final value in stream) {
  print(value);
}

// .listen() (low-level, callback-based)
stream.listen(
  (data) => print(data),
  onError: (e) => print('Error: \$e'),
  onDone: () => print('Done'),
  cancelOnError: false,
);

// Collecting
await stream.toList()    → List<T>
await stream.first       → first value
await stream.last        → last value
await stream.single      → exactly one value
await stream.length      → count all emitted values

─────────────────────────────────────
🔀 STREAM TRANSFORMATION
─────────────────────────────────────
stream.map((e) => ...)           → transform each value
stream.where((e) => ...)         → filter values
stream.take(n)                   → first n values
stream.skip(n)                   → skip first n
stream.distinct()                → deduplicate
stream.debounce(dur)             → (rxdart) debounce
stream.expand((e) => [...])      → flatMap
stream.asyncMap((e) async => ...) → async transform
stream.handleError((e) => ...)   → handle errors inline
stream.timeout(dur)              → add timeout per event

─────────────────────────────────────
📻 SINGLE-SUBSCRIPTION vs BROADCAST
─────────────────────────────────────
Single-subscription: only ONE listener allowed
  (default for most streams, e.g., file reads)

Broadcast: MULTIPLE listeners allowed
  stream.asBroadcastStream()
  StreamController.broadcast()

─────────────────────────────────────
🏗️  STREAMCONTROLLER
─────────────────────────────────────
final ctrl = StreamController<int>();
ctrl.add(1);           → emit value
ctrl.addError(e);      → emit error
ctrl.close();          → close stream
ctrl.stream            → the Stream
ctrl.sink              → the StreamSink (add/close)

💻 CODE:
import 'dart:async';

void main() async {
  // ── FROM ITERABLE ─────────────
  final nums = Stream.fromIterable([1, 2, 3, 4, 5]);
  await for (final n in nums) {
    print(n);   // 1 2 3 4 5
  }

  // ── PERIODIC ──────────────────
  final ticks = Stream.periodic(Duration(milliseconds: 100), (i) => i);
  await ticks.take(5).forEach(print);  // 0 1 2 3 4 (then done)

  // ── ASYNC* GENERATOR ──────────
  await for (final n in countdown(5)) {
    print(n);   // 5 4 3 2 1 0
  }

  // ── STREAM TRANSFORMATIONS ────
  final data = Stream.fromIterable([1, 2, 3, 4, 5, 6, 7, 8]);

  // map
  final doubled = data.map((n) => n * 2);
  print(await doubled.toList());   // [2, 4, 6, 8, 10, 12, 14, 16]

  // where
  final odds = Stream.fromIterable([1,2,3,4,5,6]).where((n) => n.isOdd);
  print(await odds.toList());   // [1, 3, 5]

  // chain transformations
  final result = Stream.fromIterable(List.generate(10, (i) => i))
      .where((n) => n.isEven)
      .map((n) => n * n)
      .take(3);
  print(await result.toList());   // [0, 4, 16]

  // ── COLLECTING STREAM ─────────
  final letters = Stream.fromIterable(['a', 'b', 'c', 'd']);
  final list = await letters.toList();
  print(list);   // [a, b, c, d]

  final first = await Stream.fromIterable([10, 20, 30]).first;
  print(first);  // 10

  final count = await Stream.fromIterable(List.generate(100, (i) => i)).length;
  print(count);  // 100

  // ── STREAMCONTROLLER ──────────
  final ctrl = StreamController<String>();

  // Listen before adding
  ctrl.stream.listen(
    (data) => print('Got: \$data'),
    onError: (e) => print('Error: \$e'),
    onDone: () => print('Stream closed!'),
  );

  // Add data
  ctrl.add('Hello');
  ctrl.add('World');
  ctrl.addError(Exception('oops'));
  ctrl.add('Recovered');
  ctrl.close();

  // Wait for stream to finish
  await Future.delayed(Duration(milliseconds: 10));

  // ── BROADCAST STREAM ──────────
  final bcast = StreamController<int>.broadcast();

  // Multiple listeners!
  bcast.stream.listen((n) => print('Listener A: \$n'));
  bcast.stream.listen((n) => print('Listener B: \${n * 2}'));

  bcast.add(1);   // Listener A: 1, Listener B: 2
  bcast.add(2);   // Listener A: 2, Listener B: 4
  bcast.close();

  await Future.delayed(Duration(milliseconds: 10));

  // ── ERROR HANDLING ─────────────
  await for (final val in safeStream()) {
    print('Safe: \$val');
  }

  // ── ASYNC MAP ─────────────────
  final ids = Stream.fromIterable([1, 2, 3]);
  final users = ids.asyncMap((id) => fetchUser(id));
  await for (final user in users) {
    print(user);
  }

  // ── STREAM + FUTURE INTEROP ───
  // Convert Stream to Future
  final sumResult = await Stream.fromIterable([1, 2, 3, 4, 5])
      .fold<int>(0, (acc, n) => acc + n);
  print('Sum: \$sumResult');   // 15

  // ── REAL-WORLD PATTERN ────────
  final eventBus = EventBus();
  eventBus.on<UserEvent>().listen((event) {
    print('User event: \${event.message}');
  });

  eventBus.fire(UserEvent('User logged in'));
  eventBus.fire(UserEvent('User updated profile'));

  await Future.delayed(Duration(milliseconds: 10));
  eventBus.dispose();
}

// ── ASYNC* STREAM GENERATOR ────
Stream<int> countdown(int from) async* {
  for (int i = from; i >= 0; i--) {
    await Future.delayed(Duration(milliseconds: 10));
    yield i;
  }
}

// Stream with error handling
Stream<int> safeStream() async* {
  yield 1;
  yield 2;
  try {
    // something risky
    throw Exception('error in stream');
  } catch (e) {
    // handle and continue
    yield -1;  // signal error
  }
  yield 3;
}

// Async map helper
Future<String> fetchUser(int id) async {
  await Future.delayed(Duration(milliseconds: 20));
  return 'User \$id';
}

// ── EVENT BUS PATTERN ──────────
class UserEvent {
  final String message;
  UserEvent(this.message);
}

class EventBus {
  final _controllers = <Type, StreamController>{};

  Stream<T> on<T>() {
    final ctrl = _controllers.putIfAbsent(
      T, () => StreamController<T>.broadcast(),
    ) as StreamController<T>;
    return ctrl.stream;
  }

  void fire<T>(T event) {
    _controllers[T]?.add(event);
  }

  void dispose() {
    for (final ctrl in _controllers.values) {
      ctrl.close();
    }
  }
}

// ── STREAM TRANSFORMER ─────────
StreamTransformer<int, String> numberToString =
    StreamTransformer.fromHandlers(
  handleData: (data, sink) => sink.add('Number: \$data'),
  handleError: (error, trace, sink) => sink.addError('Error!'),
  handleDone: (sink) => sink.close(),
);

📝 KEY POINTS:
✅ Future is a single value; Stream is zero or more values over time
✅ await for (final v in stream) is the cleanest way to consume a stream
✅ async* with yield creates a stream generator function
✅ StreamController lets you manually emit values and errors
✅ Broadcast streams allow multiple simultaneous listeners
✅ .map(), .where(), .take(), .skip(), .distinct() transform streams lazily
✅ .asyncMap() handles async transformations inside a stream pipeline
✅ Always call ctrl.close() when done — or listeners never see onDone
❌ Single-subscription streams throw if you listen more than once — use broadcast
❌ Don't forget to cancel() subscriptions — they hold resources
❌ Unhandled stream errors crash the app — always have onError or try/catch
''',
  quiz: [
    Quiz(question: 'What is the key difference between Future<T> and Stream<T>?', options: [
      QuizOption(text: 'Future is synchronous; Stream is asynchronous', correct: false),
      QuizOption(text: 'Future delivers one value; Stream delivers zero or more values over time', correct: true),
      QuizOption(text: 'Stream is faster than Future for single values', correct: false),
      QuizOption(text: 'Future can be cancelled; Stream cannot', correct: false),
    ]),
    Quiz(question: 'What does async* with yield create in Dart?', options: [
      QuizOption(text: 'A Future that resolves with the yielded values', correct: false),
      QuizOption(text: 'A Stream that emits values as yield statements are reached', correct: true),
      QuizOption(text: 'A lazy Iterable', correct: false),
      QuizOption(text: 'A broadcast stream', correct: false),
    ]),
    Quiz(question: 'What is a broadcast stream?', options: [
      QuizOption(text: 'A stream that broadcasts over the network', correct: false),
      QuizOption(text: 'A stream that allows multiple simultaneous listeners', correct: true),
      QuizOption(text: 'A stream that repeats values indefinitely', correct: false),
      QuizOption(text: 'A stream connected to a StreamController', correct: false),
    ]),
  ],
);