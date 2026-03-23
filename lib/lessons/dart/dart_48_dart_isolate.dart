import '../../models/lesson.dart';
import '../../models/quiz.dart';

final dartLesson48 = Lesson(
  language: 'Dart',
  title: 'dart:isolate Deep Dive',
  content: '''
🎯 METAPHOR:
Isolates are like separate processes running in parallel
universes that can only communicate by passing notes under
the door. Unlike threads in Java or C++, isolates don't
share ANY memory — no shared variables, no mutex locks,
no race conditions. Each isolate has its own heap, its
own event loop, and its own garbage collector. When you
want to share data, you pass a MESSAGE. The receiving
isolate gets a COPY of the data (for most types), not
a reference to the original. This makes parallelism
safe by design — the architecture prevents the entire
class of concurrency bugs that plague shared-memory systems.

📖 EXPLANATION:
dart:isolate is the foundation of Dart concurrency.
An Isolate is an independent unit of execution with its
own memory. Communication happens via SendPort/ReceivePort
message passing. Isolate.spawn() creates a new isolate.
For simpler use, use the compute() function (Flutter) or
Isolate.run() (Dart 2.19+).

─────────────────────────────────────
📐 CORE API
─────────────────────────────────────
import 'dart:isolate';

// Simple: run a function in a new isolate (Dart 2.19+)
T result = await Isolate.run(() => heavyWork());

// Full control:
ReceivePort receivePort = ReceivePort();
Isolate isolate = await Isolate.spawn(
  entryPoint,           // top-level or static function
  receivePort.sendPort, // pass the send port as message
);

// In the spawned isolate:
void entryPoint(SendPort sendPort) {
  sendPort.send(result);    // send result back
}

─────────────────────────────────────
📦 KEY CLASSES
─────────────────────────────────────
Isolate          → represents a running isolate
ReceivePort      → receive messages (has a stream)
SendPort         → send messages to a ReceivePort
RawReceivePort   → lower-level, callback-based
IsolateNameServer → register/lookup isolates by name

─────────────────────────────────────
📨 WHAT CAN BE SENT?
─────────────────────────────────────
Primitives:  null, bool, int, double, String
Collections: List, Map, Set (of sendable types)
Typed data:  Uint8List, ByteData, etc. (transferred!)
SendPort:    to set up back-channel communication
Objects:     Custom classes (COPIED, not shared)
             — must have no illegal references

Transfer ownership (zero-copy):
  TransferableTypedData — transfer large data without copy

─────────────────────────────────────
🔄 ISOLATE.RUN() — SIMPLEST APPROACH
─────────────────────────────────────
Dart 2.19+ — runs a function in a fresh isolate,
returns the result, and kills the isolate:

final result = await Isolate.run(() {
  return expensiveCalculation();
});

─────────────────────────────────────
⚡ EVENT LOOP WITHIN ISOLATES
─────────────────────────────────────
Each isolate has its own event loop.
async/await within an isolate runs on THAT isolate's loop.
Multiple async operations within an isolate are cooperative
(not parallel) — for true parallelism, use multiple isolates.

─────────────────────────────────────
🔑 ISOLATE vs async/await
─────────────────────────────────────
async/await: cooperative concurrency on ONE isolate
  → single thread, shared memory, no real parallelism
  → great for I/O-bound work (network, disk)

Isolate: true parallelism on SEPARATE isolates
  → separate threads/cores, no shared memory
  → great for CPU-bound work (parsing, computation)

💻 CODE:
import 'dart:isolate';
import 'dart:async';

// ── SIMPLE: Isolate.run() ────────
Future<void> simpleExample() async {
  print('Main isolate: starting heavy computation');

  // Runs in a separate isolate — doesn't block main
  final result = await Isolate.run(() {
    // This runs in a new isolate
    return _expensiveComputation(10000000);
  });

  print('Main isolate: got result = \$result');
}

int _expensiveComputation(int n) {
  int sum = 0;
  for (int i = 0; i < n; i++) {
    sum += i;
  }
  return sum;
}

// ── FULL CONTROL: spawn() ────────
Future<void> spawnExample() async {
  final receivePort = ReceivePort();

  // Spawn a new isolate, passing our receive port's send port
  await Isolate.spawn(
    _workerIsolate,
    receivePort.sendPort,
    debugName: 'WorkerIsolate',
  );

  // Wait for the result
  final result = await receivePort.first;
  print('Received from worker: \$result');
  receivePort.close();
}

// Entry point for the worker isolate
// MUST be top-level or static
void _workerIsolate(SendPort sendPort) {
  final result = _expensiveComputation(1000000);
  sendPort.send(result);
}

// ── BIDIRECTIONAL COMMUNICATION ──
Future<void> bidirectionalExample() async {
  final mainReceive = ReceivePort();

  await Isolate.spawn(_bidirectionalWorker, mainReceive.sendPort);

  // Receive the worker's send port first
  final workerSendPort = await mainReceive.first as SendPort;

  // Now set up our receive for worker responses
  final responsePort = ReceivePort();

  // Send tasks to worker
  workerSendPort.send((responsePort.sendPort, 'task1'));
  workerSendPort.send((responsePort.sendPort, 'task2'));
  workerSendPort.send((responsePort.sendPort, 'stop'));

  // Collect responses
  await for (final response in responsePort) {
    print('Response: \$response');
    if (response == 'done') {
      responsePort.close();
      mainReceive.close();
      break;
    }
  }
}

void _bidirectionalWorker(SendPort mainSendPort) {
  final workerReceive = ReceivePort();

  // Send our port to main so it can send us tasks
  mainSendPort.send(workerReceive.sendPort);

  workerReceive.listen((message) {
    final (SendPort replyPort, String task) = message as (SendPort, String);

    if (task == 'stop') {
      replyPort.send('done');
      workerReceive.close();
      return;
    }

    // Process task
    replyPort.send('Processed: \$task');
  });
}

// ── ISOLATE POOL PATTERN ─────────
class IsolatePool {
  final int size;
  final List<_PoolWorker> _workers = [];
  int _nextWorker = 0;

  IsolatePool(this.size);

  Future<void> initialize() async {
    for (int i = 0; i < size; i++) {
      final worker = _PoolWorker(i);
      await worker.initialize();
      _workers.add(worker);
    }
    print('Pool of \$size isolates ready');
  }

  Future<T> submit<T>(T Function() task) {
    // Round-robin distribution
    final worker = _workers[_nextWorker % _workers.length];
    _nextWorker++;
    return worker.execute(task);
  }

  Future<void> shutdown() async {
    for (final worker in _workers) {
      await worker.shutdown();
    }
  }
}

class _PoolWorker {
  final int id;
  late Isolate _isolate;
  late SendPort _sendPort;
  late ReceivePort _receivePort;

  _PoolWorker(this.id);

  Future<void> initialize() async {
    _receivePort = ReceivePort();
    _isolate = await Isolate.spawn(
      _workerLoop,
      _receivePort.sendPort,
      debugName: 'PoolWorker-\$id',
    );
    _sendPort = await _receivePort.first as SendPort;
  }

  Future<T> execute<T>(T Function() task) {
    final completer = Completer<T>();
    final replyPort = ReceivePort();
    _sendPort.send((replyPort.sendPort, task));
    replyPort.first.then((result) {
      completer.complete(result as T);
      replyPort.close();
    });
    return completer.future;
  }

  Future<void> shutdown() async {
    _sendPort.send(null);  // null = shutdown signal
    _isolate.kill(priority: Isolate.immediate);
  }

  static void _workerLoop(SendPort mainPort) {
    final receivePort = ReceivePort();
    mainPort.send(receivePort.sendPort);

    receivePort.listen((message) {
      if (message == null) {
        receivePort.close();
        return;
      }
      final (SendPort replyPort, Function task) = message as (SendPort, Function);
      final result = task();
      replyPort.send(result);
    });
  }
}

// ── TRANSFERABLE TYPED DATA ──────
Future<void> transferExample() async {
  // Create large data
  final data = Uint8List(1024 * 1024);  // 1MB
  for (int i = 0; i < data.length; i++) {
    data[i] = i % 256;
  }

  // Transfer (zero-copy!) — original data becomes unusable
  final transferable = TransferableTypedData.fromList([data]);

  final result = await Isolate.run(() {
    // Materialize in the new isolate
    final received = transferable.materialize().asUint8List();
    return received.fold<int>(0, (sum, b) => sum + b);
  });

  print('Sum of transferred data: \$result');
}

// ── ISOLATE.EXIT() ───────────────
// Modern alternative to SendPort.send() for final result:
void _exitWorker(SendPort sendPort) {
  final result = _expensiveComputation(100000);
  Isolate.exit(sendPort, result);  // exits AND sends in one call
}

Future<void> exitExample() async {
  final receivePort = ReceivePort();
  await Isolate.spawn(_exitWorker, receivePort.sendPort);
  final result = await receivePort.first;
  print('Exit result: \$result');
}

// ── ISOLATE GROUPS (Dart 2.15+) ──
// Isolates in the same group CAN share some data more efficiently
// (implementation detail — API is the same)

void main() async {
  print('=== Simple Isolate.run() ===');
  await simpleExample();

  print('\\n=== Spawn Example ===');
  await spawnExample();

  print('\\n=== Exit Example ===');
  await exitExample();

  print('\\nAll isolate examples complete!');
}

📝 KEY POINTS:
✅ Isolates have completely separate memory — no shared state, no race conditions
✅ Isolate.run() is the simplest way: runs a function, returns result, kills isolate
✅ Use isolates for CPU-bound work; use async/await for I/O-bound work
✅ Communication is via message passing: SendPort sends, ReceivePort receives
✅ Most data is copied when sent between isolates
✅ TransferableTypedData transfers large binary data with zero-copy (transfers ownership)
✅ Entry points for spawned isolates must be top-level or static functions
✅ Isolate.exit(sendPort, result) sends the final result and terminates cleanly
❌ Don't send closures or objects with references to non-sendable things
❌ Don't use isolates for I/O-bound work — async/await is sufficient and lighter
❌ Each isolate has its own event loop — async inside an isolate is still single-threaded within that isolate
''',
  quiz: [
    Quiz(question: 'How do Dart isolates differ from threads in Java or C++?', options: [
      QuizOption(text: 'Isolates are slower but more portable', correct: false),
      QuizOption(text: 'Isolates have completely separate memory — no shared state, communicating only by message passing', correct: true),
      QuizOption(text: 'Isolates run on a single CPU core', correct: false),
      QuizOption(text: 'Isolates are only available in Flutter, not pure Dart', correct: false),
    ]),
    Quiz(question: 'What is Isolate.run() best used for?', options: [
      QuizOption(text: 'Handling HTTP requests asynchronously', correct: false),
      QuizOption(text: 'Offloading a single CPU-intensive computation to a new isolate and getting the result back', correct: true),
      QuizOption(text: 'Long-running background services', correct: false),
      QuizOption(text: 'Sharing state between parts of an application', correct: false),
    ]),
    Quiz(question: 'What does TransferableTypedData do when passed between isolates?', options: [
      QuizOption(text: 'Creates a copy of the data in the receiving isolate', correct: false),
      QuizOption(text: 'Transfers ownership of the data with zero-copy — the original becomes unusable', correct: true),
      QuizOption(text: 'Creates a shared memory reference', correct: false),
      QuizOption(text: 'Compresses the data before sending', correct: false),
    ]),
  ],
);
