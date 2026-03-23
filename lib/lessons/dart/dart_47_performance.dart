import '../../models/lesson.dart';
import '../../models/quiz.dart';

final dartLesson47 = Lesson(
  language: 'Dart',
  title: 'Performance & Optimization',
  content: '''
🎯 METAPHOR:
Performance optimization is like tuning a race car.
The car must first WORK correctly — you don't tune a
broken engine. Only then do you measure: where is the
car losing time? Is it the tires (memory allocation)?
The engine (CPU-bound code)? The fuel system (I/O)?
You don't guess — you measure with a profiler.
Then you fix the ONE bottleneck that matters most.
Dart gives you powerful tools: const constructors to
eliminate allocation, Uint8List for raw bytes, isolates
for CPU work, AOT compilation for startup speed.

📖 EXPLANATION:
Dart performance is excellent when you know the levers:
const objects (zero allocation), typed data (cache-friendly),
AOT compilation (fast startup), and isolates for parallelism.
The dart:developer library and DevTools give visibility.

─────────────────────────────────────
⚡ THE GOLDEN RULES
─────────────────────────────────────
1. Measure first — don't optimize blindly
2. const > final > var — fewer allocations
3. Avoid unnecessary object creation in hot loops
4. Use typed collections (Uint8List, Float32List)
5. Avoid dynamic dispatch in tight loops
6. Offload CPU work to isolates
7. Profile with Flutter DevTools / dart:developer

─────────────────────────────────────
🏗️  CONST OPTIMIZATION
─────────────────────────────────────
const objects are:
  • Created once at compile time
  • Shared across all references (canonicalized)
  • Zero cost to "create" — they already exist
  • Deeply immutable

const Widget = build pattern is the core Flutter perf trick

─────────────────────────────────────
📦 TYPED DATA (dart:typed_data)
─────────────────────────────────────
For number-heavy code, use typed lists:
  Uint8List    → bytes (0-255)
  Int32List    → 32-bit signed integers
  Float64List  → 64-bit doubles (like C double[])
  ByteData     → view with explicit endianness

Typed data is:
  • Backed by a continuous memory buffer
  • More cache-friendly than List<int>
  • No boxing/unboxing overhead
  • Directly transferable between isolates (no copy!)

─────────────────────────────────────
🔄 AVOID ALLOCATION IN LOOPS
─────────────────────────────────────
// Slow — creates new List every iteration
for (var i = 0; i < 1000; i++) {
  var buffer = <int>[];   // allocates every loop!
  buffer.add(i);
  process(buffer);
}

// Fast — reuse the buffer
final buffer = <int>[];
for (var i = 0; i < 1000; i++) {
  buffer.clear();
  buffer.add(i);
  process(buffer);
}

─────────────────────────────────────
🎯 STRING CONCATENATION
─────────────────────────────────────
// Slow — creates new String each time
var s = '';
for (var i = 0; i < 1000; i++) {
  s += 'item\$i,';   // O(n²) total!
}

// Fast — StringBuffer
final sb = StringBuffer();
for (var i = 0; i < 1000; i++) {
  sb.write('item\$i,');
}
var s = sb.toString();   // O(n) total

─────────────────────────────────────
🔬 PROFILING TOOLS
─────────────────────────────────────
Stopwatch class        → manual timing
dart:developer         → Timeline, log, inspect
dart analyze           → static analysis
dart compile --observe → VM service for profiling
Flutter DevTools       → CPU profiler, memory, timeline

💻 CODE:
import 'dart:typed_data';
import 'dart:math' as math;
import 'dart:developer' as dev;

void main() {
  // ── BENCHMARKING WITH STOPWATCH ──
  final sw = Stopwatch()..start();
  _doWork(100000);
  sw.stop();
  print('doWork took: \${sw.elapsedMicroseconds}μs');

  // ── CONST CANONICALIZATION ─────
  // These all point to the SAME object in memory:
  const p1 = _Point(1, 2);
  const p2 = _Point(1, 2);
  const p3 = _Point(1, 2);
  print(identical(p1, p2));  // true — same instance!
  print(identical(p1, p3));  // true

  // Compared to non-const:
  final f1 = _Point(1, 2);
  final f2 = _Point(1, 2);
  print(identical(f1, f2));  // false — two different objects

  // ── TYPED DATA PERFORMANCE ─────
  const int size = 1_000_000;

  // List<int> — boxed
  sw.reset(); sw.start();
  final list = List<int>.filled(size, 0);
  for (var i = 0; i < size; i++) list[i] = i;
  final listSum = list.fold(0, (a, b) => a + b);
  sw.stop();
  print('List<int>:    \${sw.elapsedMilliseconds}ms (sum=\$listSum)');

  // Uint32List — unboxed, cache-friendly
  sw.reset(); sw.start();
  final typed = Uint32List(size);
  for (var i = 0; i < size; i++) typed[i] = i;
  var typedSum = 0;
  for (var i = 0; i < size; i++) typedSum += typed[i];
  sw.stop();
  print('Uint32List:   \${sw.elapsedMilliseconds}ms (sum=\$typedSum)');

  // ── STRING BUILDING ────────────
  const iterations = 10000;

  // Bad: += concatenation
  sw.reset(); sw.start();
  var bad = '';
  for (var i = 0; i < iterations; i++) {
    bad += 'x';  // O(n) each concat → O(n²) total!
  }
  sw.stop();
  print('String +=:    \${sw.elapsedMicroseconds}μs');

  // Good: StringBuffer
  sw.reset(); sw.start();
  final sb = StringBuffer();
  for (var i = 0; i < iterations; i++) {
    sb.write('x');
  }
  final good = sb.toString();
  sw.stop();
  print('StringBuffer: \${sw.elapsedMicroseconds}μs');

  // ── AVOID CLOSURE ALLOCATION IN LOOPS ──
  // Bad: creates a new closure every iteration
  sw.reset(); sw.start();
  var sumBad = 0;
  [1, 2, 3, 4, 5].forEach((x) { sumBad += x; });  // closure
  sw.stop();
  final closureTime = sw.elapsedMicroseconds;

  // Good: use for loop (no closure allocation)
  sw.reset(); sw.start();
  var sumGood = 0;
  final data = [1, 2, 3, 4, 5];
  for (var i = 0; i < data.length; i++) { sumGood += data[i]; }
  sw.stop();
  final loopTime = sw.elapsedMicroseconds;
  print('forEach: \${closureTime}μs  vs  for loop: \${loopTime}μs');

  // ── LATE LAZY INITIALIZATION ───
  // With late, expensive init only runs if field is accessed
  final obj = ExpensiveObject();
  print('Object created (no computation yet)');
  // ...
  print('Accessing result: \${obj.result}');  // computed here
  print('Accessing again:  \${obj.result}');  // cached!

  // ── AVOID DYNAMIC ─────────────
  // dynamic disables static optimization
  // Bad:
  dynamic d = 42;
  d + 1;  // type check at runtime!

  // Good:
  int n = 42;
  n + 1;  // known at compile time!

  // ── COLLECTION BUILDER PATTERN ─
  // Use list spread vs repeated add:
  sw.reset(); sw.start();
  final built = [
    for (var i = 0; i < 10000; i++) i * 2,
  ];
  sw.stop();
  print('Collection for: \${sw.elapsedMicroseconds}μs, len=\${built.length}');

  // ── TIMELINE EVENTS (DevTools) ─
  dev.Timeline.startSync('myOperation');
  _doWork(1000);
  dev.Timeline.finishSync();

  // ── MEMORY: CACHE-FRIENDLY DATA ──
  // Struct-of-arrays vs Array-of-structs
  // For performance-critical code, prefer parallel arrays:
  final xs = Float64List(10000);
  final ys = Float64List(10000);
  // vs List<Point> points = [...] which creates many objects

  // Fill with data
  for (var i = 0; i < 10000; i++) {
    xs[i] = i.toDouble();
    ys[i] = (i * 2).toDouble();
  }

  // Sum distances — cache-friendly (sequential memory access)
  sw.reset(); sw.start();
  var totalDist = 0.0;
  for (var i = 0; i < 10000; i++) {
    totalDist += math.sqrt(xs[i] * xs[i] + ys[i] * ys[i]);
  }
  sw.stop();
  print('Parallel arrays: \${sw.elapsedMilliseconds}ms');
}

void _doWork(int n) {
  var sum = 0;
  for (var i = 0; i < n; i++) sum += i;
}

class _Point {
  final int x, y;
  const _Point(this.x, this.y);
}

class ExpensiveObject {
  // Computed only once, on first access
  late final int result = _compute();

  int _compute() {
    print('  (computing expensive result...)');
    return List.generate(1000, (i) => i).fold(0, (a, b) => a + b);
  }
}

// ── EFFICIENT PARSING ──────────
// Use RegExp.firstMatch instead of repeated .contains
final _emailRegex = RegExp(
  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\$',
);
// Compile once (top-level const/final), reuse many times
bool isEmail(String s) => _emailRegex.hasMatch(s);

📝 KEY POINTS:
✅ Measure before optimizing — use Stopwatch, DevTools, Timeline
✅ const objects are canonicalized — identical instances, zero allocation cost
✅ StringBuffer for building strings in loops — not +=
✅ Typed data (Uint8List, Float64List) for numeric heavy lifting
✅ late final for expensive lazy initialization — computed once, cached
✅ Avoid dynamic in hot paths — use concrete types for compiler optimization
✅ Prefer for loops over .forEach() when allocation matters
✅ Compile RegExp at top-level — not inside functions
❌ Don't optimize prematurely — write correct code first, profile second
❌ Don't use List<int> for massive numeric arrays — use typed_data
❌ Don't concatenate strings with += in loops — use StringBuffer
''',
  quiz: [
    Quiz(question: 'Why is StringBuffer faster than += for building strings in loops?', options: [
      QuizOption(text: 'StringBuffer uses parallel threads', correct: false),
      QuizOption(text: 'StringBuffer builds the string in one O(n) pass; += creates a new string each iteration making it O(n²)', correct: true),
      QuizOption(text: 'StringBuffer bypasses garbage collection', correct: false),
      QuizOption(text: 'There is no difference — they use the same implementation', correct: false),
    ]),
    Quiz(question: 'What is the memory advantage of Uint8List over List<int>?', options: [
      QuizOption(text: 'Uint8List can store larger numbers', correct: false),
      QuizOption(text: 'Uint8List uses a contiguous unboxed memory buffer — no object overhead per element', correct: true),
      QuizOption(text: 'Uint8List is automatically garbage collected', correct: false),
      QuizOption(text: 'Uint8List can be sorted faster', correct: false),
    ]),
    Quiz(question: 'What does "late final" provide for a class field?', options: [
      QuizOption(text: 'The field is initialized in a separate thread', correct: false),
      QuizOption(text: 'Lazy initialization — computed on first access, then cached forever', correct: true),
      QuizOption(text: 'The field is shared across all instances', correct: false),
      QuizOption(text: 'The field delays garbage collection', correct: false),
    ]),
  ],
);
