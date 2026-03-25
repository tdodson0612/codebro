import '../../models/lesson.dart';
import '../../models/quiz.dart';

final dartLesson21 = Lesson(
  language: 'Dart',
  title: 'Async / Await & Futures',
  content: '''
🎯 METAPHOR:
A Future is like an order ticket at a busy restaurant.
You place your order (start the async operation), get a
ticket (the Future), and go sit down. The kitchen works
in the background. When your order is ready, the buzzer
goes off (Future completes) and you pick it up (await
resolves to the value). While the kitchen is working,
you can read the menu, chat with friends, or order drinks
— you're not blocked staring at the kitchen window.
That's async programming: do other things while waiting,
but come back for the result when it's ready.

📖 EXPLANATION:
Dart is single-threaded but non-blocking through its
event loop. async/await makes asynchronous code look
synchronous. Future<T> represents a value that will
be available later. The event loop processes microtasks
(Future continuations) and events (I/O, timers).

─────────────────────────────────────
📐 ASYNC/AWAIT SYNTAX
─────────────────────────────────────
Future<String> fetchData() async {
  final result = await httpGet(url);  // waits here
  return result.body;                  // returns String
}

// Calling it:
void main() async {
  String data = await fetchData();
  print(data);
}

─────────────────────────────────────
🔑 FUTURE<T>
─────────────────────────────────────
States:
  Uncompleted → waiting for value
  Completed with value → success, holds T
  Completed with error → failure, holds exception

Creating Futures:
  Future.value(42)         → already completed
  Future.error(e)          → already errored
  Future.delayed(d, () => v) → completes after delay
  Future<T>(() => ...)     → runs in microtask queue
  async function           → returns a Future

─────────────────────────────────────
🔗 FUTURE METHODS
─────────────────────────────────────
.then((v) => ...)     → on success
.catchError((e) => .) → on error
.whenComplete(() => .) → always (like finally)
.timeout(duration)    → add a timeout
.then(...).then(...)  → chaining

─────────────────────────────────────
⚡ CONCURRENT FUTURES
─────────────────────────────────────
Future.wait([f1, f2, f3])  → wait for ALL, list of results
Future.any([f1, f2, f3])   → first to complete wins
Future.wait(futures, eagerError: true) → fail fast

(await (f1, f2).wait)      → Dart 3 parallel await

─────────────────────────────────────
🔄 ASYNC* / YIELD — STREAMS FROM ASYNC
─────────────────────────────────────
Stream-generating functions use async* + yield.
Covered fully in the Streams lesson.

─────────────────────────────────────
📋 THE EVENT LOOP
─────────────────────────────────────
1. Microtask queue (Future.then callbacks) — highest priority
2. Event queue (I/O, timers, user events)
3. If both empty — idle

This means Future.then runs before any new events.

💻 CODE:
import 'dart:async';

// Simulated async operations
Future<String> fetchUser(int id) async {
  await Future.delayed(Duration(milliseconds: 100)); // simulate network
  return 'User \$id: Alice';
}

Future<List<String>> fetchPosts(String userId) async {
  await Future.delayed(Duration(milliseconds: 150));
  return ['Post 1 by \$userId', 'Post 2 by \$userId'];
}

Future<int> fetchScore(String userId) async {
  await Future.delayed(Duration(milliseconds: 50));
  return 92;
}

void main() async {
  // ── BASIC ASYNC/AWAIT ─────────
  print('Fetching...');
  String user = await fetchUser(1);
  print(user);    // User 1: Alice

  // ── ASYNC IN SEQUENCE ─────────
  // Each line waits for the previous
  final u = await fetchUser(1);
  final posts = await fetchPosts(u);   // runs AFTER fetchUser completes
  print(posts);   // [Post 1 by User 1: Alice, Post 2 by User 1: Alice]

  // ── ASYNC IN PARALLEL (faster!) ─
  final stopwatch = Stopwatch()..start();

  // Bad: sequential (100 + 150 + 50 = 300ms)
  final u1 = await fetchUser(1);
  final p1 = await fetchPosts(u1);
  final s1 = await fetchScore(u1);
  print('Sequential: \${stopwatch.elapsedMilliseconds}ms');

  stopwatch.reset();

  // Good: parallel (max(100, 150, 50) = 150ms)
  final (u2, p2, s2) = await (
    fetchUser(2),
    fetchPosts('user2'),
    fetchScore('user2'),
  ).wait;   // Dart 3 parallel await
  print('Parallel: \${stopwatch.elapsedMilliseconds}ms');
  print('\$u2 scored \$s2 with \${p2.length} posts');

  // Future.wait — classic way
  final results = await Future.wait([
    fetchUser(3),
    fetchUser(4),
    fetchUser(5),
  ]);
  print(results);  // [User 3: Alice, User 4: Alice, User 5: Alice]

  // ── ERROR HANDLING ────────────
  try {
    await failingOperation();
  } catch (e) {
    print('Caught: \$e');
  }

  // ── FUTURE CHAINING (.then) ───
  Future.value(42)
      .then((v) => v * 2)
      .then((v) => 'Result: \$v')
      .then(print)     // Result: 84
      .catchError((e) => print('Error: \$e'));

  // ── TIMEOUT ───────────────────
  try {
    final result = await fetchUser(1)
        .timeout(Duration(milliseconds: 50)); // too short!
    print(result);
  } on TimeoutException catch (e) {
    print('Timed out: \$e');
  }

  // ── COMPLETER — MANUAL FUTURE ─
  final completer = Completer<String>();

  // Complete it after a delay (simulating external event)
  Future.delayed(Duration(milliseconds: 100), () {
    completer.complete('Manual result!');
    // or: completer.completeError(Exception('failed'));
  });

  final manualResult = await completer.future;
  print(manualResult);   // Manual result!

  // ── FUTURE.DELAYED ─────────────
  print('Waiting 200ms...');
  await Future.delayed(Duration(milliseconds: 200));
  print('Done waiting!');

  // ── UNAWAITED FUTURES ─────────
  // Fire and forget (don't wait for result)
  unawaited(fetchUser(99));   // runs but we ignore result
  // Import 'dart:async' for unawaited()

  print('Done!');
}

Future<void> failingOperation() async {
  await Future.delayed(Duration(milliseconds: 10));
  throw Exception('Something went wrong!');
}

// ── ASYNC FUNCTION PATTERNS ────

// Async getter
Future<String> get currentUser async {
  await Future.delayed(Duration(milliseconds: 10));
  return 'Alice';
}

// Wrapping a sync operation in a Future
Future<T> runAsync<T>(T Function() computation) {
  return Future(() => computation());
}

// Converting callback to Future
Future<String> callbackToFuture() {
  final completer = Completer<String>();
  // Simulate callback-based API:
  Future.delayed(Duration(milliseconds: 100), () {
    completer.complete('callback result');
  });
  return completer.future;
}

// ── RETRY PATTERN ──────────────
Future<T> retry<T>(
  Future<T> Function() operation, {
  int maxAttempts = 3,
  Duration delay = const Duration(seconds: 1),
}) async {
  for (int attempt = 1; attempt <= maxAttempts; attempt++) {
    try {
      return await operation();
    } catch (e) {
      if (attempt == maxAttempts) rethrow;
      print('Attempt \$attempt failed, retrying in \${delay.inSeconds}s...');
      await Future.delayed(delay);
    }
  }
  throw StateError('Should not reach here');
}

// ── ASYNC CLASS INITIALIZATION ─
class DataService {
  late final String _data;

  // Can't use async in constructor body — use factory + _init
  DataService._();

  static Future<DataService> create() async {
    final service = DataService._();
    await service._init();
    return service;
  }

  Future<void> _init() async {
    await Future.delayed(Duration(milliseconds: 50));
    _data = 'initialized data';
  }

  String get data => _data;
}

📝 KEY POINTS:
✅ async functions return Future<T> even if the function returns T
✅ await pauses execution until the Future completes — only inside async
✅ For parallel work: use Future.wait() or (f1, f2).wait (Dart 3)
✅ Try/catch works naturally in async functions to handle Future errors
✅ Completer creates a Future you complete manually
✅ Future.delayed is useful for debouncing and timeout simulation
✅ unawaited() explicitly marks a Future you intentionally don't await
✅ Always await Futures — unawaited exceptions can crash the app silently
❌ Don't make constructors async — use a static factory method instead
❌ Don't use .then() when async/await is available — it's harder to read
❌ Never ignore Dart's "unawaited_futures" lint warning — it prevents bugs
''',
  quiz: [
    Quiz(question: 'What does async do to a function\'s return type?', options: [
      QuizOption(text: 'It makes the function run on a separate thread', correct: false),
      QuizOption(text: 'It wraps the return type in a Future: String becomes Future<String>', correct: true),
      QuizOption(text: 'It makes the function return null', correct: false),
      QuizOption(text: 'Nothing — it is just a hint to the compiler', correct: false),
    ]),
    Quiz(question: 'What is the fastest way to run three independent Futures in parallel?', options: [
      QuizOption(text: 'await f1; await f2; await f3 — sequential is fine', correct: false),
      QuizOption(text: 'Future.wait([f1, f2, f3]) or (f1, f2, f3).wait — runs all at once', correct: true),
      QuizOption(text: 'Create three Isolates', correct: false),
      QuizOption(text: 'Use async* and yield each future', correct: false),
    ]),
    Quiz(question: 'What does a Completer<T> allow you to do?', options: [
      QuizOption(text: 'Complete a Future multiple times', correct: false),
      QuizOption(text: 'Manually control when a Future completes and with what value', correct: true),
      QuizOption(text: 'Cancel a running Future', correct: false),
      QuizOption(text: 'Convert a Stream to a Future', correct: false),
    ]),
  ],
);
