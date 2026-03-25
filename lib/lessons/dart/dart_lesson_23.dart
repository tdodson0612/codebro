import '../../models/lesson.dart';
import '../../models/quiz.dart';

final dartLesson23 = Lesson(
  language: 'Dart',
  title: 'Isolates & Concurrency',
  content: '''
🎯 METAPHOR:
Isolates are like separate countries with their own laws,
currency, and language. They don't share anything directly —
no shared memory, no shared variables. To trade (communicate),
they use diplomatic couriers (message passing). This seems
restrictive, but it's a FEATURE: no shared state means no
race conditions, no mutexes, no deadlocks. Each isolate is
completely independent. The main isolate is your home country;
spawning isolates is like establishing embassies in other
countries to do specialized work in parallel.

📖 EXPLANATION:
Dart is single-threaded per isolate, but you can create
multiple isolates that run truly in parallel (on separate
CPU cores). Isolates communicate by passing messages —
they share NO memory. The Isolate.run() API (Dart 2.19+)
is the easy way; the low-level Isolate.spawn() + ports
gives full control.

─────────────────────────────────────
📐 ISOLATE.RUN (EASIEST - Dart 2.19+)
─────────────────────────────────────
// Run heavy computation in a new isolate:
final result = await Isolate.run(() {
  return heavyComputation();   // runs in separate isolate
});

- Takes a top-level or static function (NOT closure capturing state)
- Returns result via automatic message passing
- Isolate is created, runs, returns, then disposed

─────────────────────────────────────
📬 RECEIVEPORT & SENDPORT
─────────────────────────────────────
Low-level: Ports are the communication channels.

ReceivePort:   creates a mailbox; has a stream of messages
SendPort:      a reference to someone else's mailbox
               can be sent across isolates!

// Setup:
final receivePort = ReceivePort();
await Isolate.spawn(entryPoint, receivePort.sendPort);
receivePort.listen((message) => print(message));

─────────────────────────────────────
📋 WHAT CAN BE SENT?
─────────────────────────────────────
✅ Primitives: int, double, String, bool, null
✅ Collections: List, Map, Set (of sendable types)
✅ SendPort objects
✅ TransferableTypedData (zero-copy)
✅ Closures (Dart 3 - experimental)
❌ Regular objects with methods (not sendable)
❌ Open files or sockets

─────────────────────────────────────
🔄 COMPUTE (FLUTTER)
─────────────────────────────────────
In Flutter apps, use compute():
  final result = await compute(heavyFunction, input);
  // compute() wraps Isolate.run for Flutter

─────────────────────────────────────
⚡ WHEN TO USE ISOLATES
─────────────────────────────────────
Use isolates for:
  ✅ Parsing large JSON files
  ✅ Image processing
  ✅ Encryption/cryptography
  ✅ Complex sorting/searching on large data
  ✅ Any computation > 16ms (one UI frame)

Don't need isolates for:
  ❌ I/O operations (async/await handles these)
  ❌ Quick operations
  ❌ Simple UI updates

💻 CODE:
import 'dart:isolate';
import 'dart:async';

void main() async {
  // ── ISOLATE.RUN — SIMPLEST ────
  print('Starting heavy computation...');
  final sw = Stopwatch()..start();

  // This runs in a separate isolate — won't block UI/main thread
  final result = await Isolate.run(() {
    return _fibonacci(40);   // heavy computation
  });

  print('Fib(40) = \$result in \${sw.elapsedMilliseconds}ms');

  // ── PARALLEL WORK ─────────────
  // Run multiple isolates in parallel:
  sw.reset();

  final (r1, r2, r3) = await (
    Isolate.run(() => _fibonacci(35)),
    Isolate.run(() => _fibonacci(36)),
    Isolate.run(() => _fibonacci(37)),
  ).wait;

  print('Parallel results: [\$r1, \$r2, \$r3] in \${sw.elapsedMilliseconds}ms');

  // ── ISOLATE WITH SENDPORT ──────
  // For long-running isolates that send multiple messages:
  final receivePort = ReceivePort();

  await Isolate.spawn(
    _workerIsolate,
    receivePort.sendPort,
  );

  // Collect 5 results from worker
  int received = 0;
  await for (final message in receivePort) {
    if (message is String) {
      print('Main received: \$message');
    } else if (message is Map) {
      print('Status: \${message['status']}');
    }
    received++;
    if (received >= 6) {
      receivePort.close();
      break;
    }
  }

  // ── TWO-WAY COMMUNICATION ──────
  print('\n--- Two-way communication ---');
  final (result2, _) = await _setupTwoWay();
  print('Two-way result: \$result2');

  // ── TRANSFERABLE DATA ──────────
  // Zero-copy transfer for large typed data
  // (import dart:typed_data for this)
  // final data = Uint8List(1000000);
  // final transferable = TransferableTypedData.fromList([data]);
  // await Isolate.run(() { ... use transferable ... });

  print('All isolate examples complete!');
}

// ── HEAVY COMPUTATION ──────────
int _fibonacci(int n) {
  if (n <= 1) return n;
  return _fibonacci(n - 1) + _fibonacci(n - 2);
}

// ── WORKER ISOLATE ─────────────
// Must be a top-level or static function!
void _workerIsolate(SendPort sendPort) async {
  // Send multiple messages back to main isolate
  sendPort.send({'status': 'started'});

  for (int i = 1; i <= 5; i++) {
    await Future.delayed(Duration(milliseconds: 50));
    sendPort.send('Task \$i completed');
  }
}

// ── TWO-WAY COMMUNICATION ──────
Future<(String, void)> _setupTwoWay() async {
  final receivePort = ReceivePort();
  await Isolate.spawn(_bidirectionalWorker, receivePort.sendPort);

  final completer = Completer<String>();

  // First message from worker is its SendPort
  late SendPort workerSendPort;
  late StreamSubscription sub;

  sub = receivePort.listen((message) {
    if (message is SendPort) {
      // Worker sent us its port — now we can send TO it
      workerSendPort = message;
      workerSendPort.send('Hello from main!');
    } else if (message is String) {
      completer.complete(message);
      sub.cancel();
      receivePort.close();
    }
  });

  final result = await completer.future;
  return (result, null);
}

void _bidirectionalWorker(SendPort mainSendPort) {
  final receivePort = ReceivePort();

  // Send our SendPort to main so main can send to us
  mainSendPort.send(receivePort.sendPort);

  receivePort.listen((message) {
    print('Worker received: \$message');
    mainSendPort.send('Worker processed: \$message');
    receivePort.close();
  });
}

// ── ISOLATE POOL PATTERN ────────
class IsolatePool {
  final int size;
  final _ports = <SendPort>[];
  int _current = 0;

  IsolatePool(this.size);

  Future<void> initialize() async {
    for (int i = 0; i < size; i++) {
      final port = ReceivePort();
      await Isolate.spawn(_poolWorker, port.sendPort);
      final sendPort = await port.first as SendPort;
      _ports.add(sendPort);
    }
  }

  SendPort get nextPort {
    final port = _ports[_current];
    _current = (_current + 1) % size;
    return port;
  }

  static void _poolWorker(SendPort mainPort) {
    final receivePort = ReceivePort();
    mainPort.send(receivePort.sendPort);
    receivePort.listen((task) {
      // process task and send back result
    });
  }
}

// ── LARGE JSON PARSING EXAMPLE ─
Map<String, dynamic> _parseJsonIsolate(String jsonString) {
  // In a real app: import 'dart:convert' and use jsonDecode
  // return jsonDecode(jsonString);
  return {'parsed': true, 'length': jsonString.length};
}

Future<Map<String, dynamic>> parseJsonInIsolate(String json) {
  return Isolate.run(() => _parseJsonIsolate(json));
}

📝 KEY POINTS:
✅ Isolates are true parallelism — run on separate CPU cores
✅ Isolates share NO memory — all communication is via message passing
✅ Isolate.run() is the easiest API for one-shot heavy computations
✅ Use Future.wait or parallel await to run multiple isolates simultaneously
✅ Entry functions for Isolate.spawn must be top-level or static
✅ ReceivePort is a mailbox (stream); SendPort is a reference to mail it
✅ In Flutter, use compute() — it wraps Isolate.run for the UI thread
✅ Use isolates for CPU-bound work >16ms; use async/await for I/O
❌ Cannot send arbitrary Dart objects between isolates — only primitives/collections
❌ Closures capturing state from the calling isolate cannot be sent
❌ Don't create isolates for light work — spawning has overhead
''',
  quiz: [
    Quiz(question: 'Do Dart isolates share memory with each other?', options: [
      QuizOption(text: 'Yes — they share the same heap like threads', correct: false),
      QuizOption(text: 'No — each isolate has its own memory; communication is only via message passing', correct: true),
      QuizOption(text: 'Only const and final values are shared', correct: false),
      QuizOption(text: 'Yes, but you need Mutex to access shared data safely', correct: false),
    ]),
    Quiz(question: 'What is Isolate.run() best used for?', options: [
      QuizOption(text: 'Long-running isolates that continuously emit data', correct: false),
      QuizOption(text: 'One-shot heavy CPU computations that return a single result', correct: true),
      QuizOption(text: 'I/O operations like file reading and HTTP requests', correct: false),
      QuizOption(text: 'Running Flutter widgets on a separate thread', correct: false),
    ]),
    Quiz(question: 'Why must Isolate.spawn() entry functions be top-level or static?', options: [
      QuizOption(text: 'This is a Dart language limitation with no practical reason', correct: false),
      QuizOption(text: 'Because closures that capture state from the calling isolate cannot be serialized and sent to the new isolate', correct: true),
      QuizOption(text: 'Static functions run faster in isolates', correct: false),
      QuizOption(text: 'Dynamic methods are not supported in isolates', correct: false),
    ]),
  ],
);
