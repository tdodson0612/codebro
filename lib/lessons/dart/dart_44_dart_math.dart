import '../../models/lesson.dart';
import '../../models/quiz.dart';

final dartLesson44 = Lesson(
  language: 'Dart',
  title: 'dart:math Deep Dive',
  content: '''
🎯 METAPHOR:
dart:math is the scientific calculator built into Dart.
It has two modes: the deterministic mode (constants and
pure functions — pi always equals 3.14159..., sin(0)
is always 0) and the random mode (Random — rolls dice,
different result every time, or always the same if you
use the same seed). The Random.secure() mode is the
cryptographically secure dice that bad actors can't
predict — use it for security-sensitive randomness.

📖 EXPLANATION:
dart:math provides mathematical constants (pi, e), standard
math functions (sqrt, sin, cos, log, pow), and a
pseudo-random number generator with both regular and
cryptographically secure variants.

─────────────────────────────────────
📦 CONSTANTS
─────────────────────────────────────
math.pi     → 3.141592653589793
math.e      → 2.718281828459045
math.ln2    → 0.6931471805599453 (log(2))
math.ln10   → 2.302585092994046  (log(10))
math.log2e  → 1.4426950408889634 (log₂(e))
math.log10e → 0.4342944819032518 (log₁₀(e))
math.sqrt2  → 1.4142135623730951 (√2)
math.sqrt1_2 → 0.7071067811865476 (1/√2)

─────────────────────────────────────
📐 FUNCTIONS
─────────────────────────────────────
math.sqrt(x)           → square root
math.pow(base, exp)    → base^exp (returns num)
math.exp(x)            → e^x
math.log(x)            → natural log (ln)
math.sin(x)            → sine (radians)
math.cos(x)            → cosine (radians)
math.tan(x)            → tangent (radians)
math.asin(x)           → arcsin (radians)
math.acos(x)           → arccos (radians)
math.atan(x)           → arctan (radians)
math.atan2(y, x)       → atan(y/x) with correct quadrant
math.min(a, b)         → minimum of two values
math.max(a, b)         → maximum of two values

─────────────────────────────────────
🎲 RANDOM
─────────────────────────────────────
Random()              → pseudo-random (non-deterministic)
Random(seed)          → seeded (deterministic, reproducible)
Random.secure()       → cryptographically secure

rng.nextInt(max)      → int in [0, max)
rng.nextDouble()      → double in [0.0, 1.0)
rng.nextBool()        → true or false

─────────────────────────────────────
🔢 DEGREE vs RADIAN CONVERSION
─────────────────────────────────────
degrees = radians * (180 / pi)
radians = degrees * (pi / 180)

💻 CODE:
import 'dart:math' as math;

void main() {
  // ── CONSTANTS ─────────────────
  print('Constants:');
  print('  π = \${
math.pi}');
  print('  e = \${
math.e}');
  print('  √2 = \${
math.sqrt2}');
  print('  ln2 = \${
math.ln2}');

  // ── ARITHMETIC FUNCTIONS ───────
  print('\nArithmetic:');
  print('  sqrt(144) = \${
math.sqrt(144)}');        // 12.0
  print('  pow(2, 10) = \${
math.pow(2, 10)}');      // 1024
  print('  pow(8, 1/3) = \${
math.pow(8, 1/3)}');   // 2.0 (cube root)
  print('  exp(1) = \${
math.exp(1)}');               // e = 2.718...
  print('  exp(0) = \${
math.exp(0)}');               // 1.0
  print('  log(e) = \${
math.log(math.e)}');          // 1.0 (natural log)
  print('  log(1) = \${
math.log(1)}');               // 0.0
  print('  log2(8) = \${
math.log(8) / math.ln2}');  // 3.0
  print('  log10(1000) = \${
math.log(1000) / math.ln10}'); // 3.0

  // ── TRIGONOMETRY ───────────────
  print('\nTrigonometry (in radians):');
  print('  sin(0) = \${
math.sin(0)}');               // 0.0
  print('  sin(π/2) = \${
math.sin(math.pi/2)}');    // 1.0
  print('  cos(0) = \${
math.cos(0)}');               // 1.0
  print('  cos(π) = \${
math.cos(math.pi)}');         // -1.0
  print('  tan(π/4) = \${
math.tan(math.pi/4)}');    // 1.0

  // Degree → Radian conversion
  double toRadians(double degrees) => degrees * (math.pi / 180);
  double toDegrees(double radians) => radians * (180 / math.pi);

  print('\nTrig with degrees:');
  print('  sin(30°) = \${
math.sin(toRadians(30)).toStringAsFixed(4)}');  // 0.5
  print('  cos(60°) = \${
math.cos(toRadians(60)).toStringAsFixed(4)}');  // 0.5
  print('  tan(45°) = \${
math.tan(toRadians(45)).toStringAsFixed(4)}');  // 1.0

  // Inverse trig
  print('  asin(0.5) = \${
toDegrees(math.asin(0.5)).toStringAsFixed(1)}°');  // 30.0°
  print('  acos(0.5) = \${
toDegrees(math.acos(0.5)).toStringAsFixed(1)}°');  // 60.0°
  print('  atan(1.0) = \${
toDegrees(math.atan(1.0)).toStringAsFixed(1)}°');  // 45.0°

  // atan2 for angle between two points
  final angle = math.atan2(3, 4);  // angle of vector (4, 3)
  print('  angle of (4,3): \${
toDegrees(angle).toStringAsFixed(1)}°');

  // ── MIN / MAX ─────────────────
  print('\nMin/Max:');
  print('  min(3, 7) = \${
math.min(3, 7)}');    // 3
  print('  max(3, 7) = \${
math.max(3, 7)}');    // 7
  print('  min(-5.0, 2.0) = \${
math.min(-5.0, 2.0)}');  // -5.0

  // ── PRACTICAL GEOMETRY ─────────
  print('\nGeometry:');

  // Circle calculations
  double radius = 5.0;
  double circumference = 2 * math.pi * radius;
  double area = math.pi * radius * radius;
  print('  Circle r=5: circumference=\${
circumference.toStringAsFixed(2)}, area=\${
area.toStringAsFixed(2)}');

  // Distance between two points
  double distance(double x1, double y1, double x2, double y2) {
    final dx = x2 - x1;
    final dy = y2 - y1;
    return math.sqrt(dx * dx + dy * dy);
  }
  print('  Distance (0,0)→(3,4) = \${
distance(0,0,3,4)}');  // 5.0

  // Hypotenuse
  double hypotenuse(double a, double b) => math.sqrt(a*a + b*b);
  print('  hyp(3,4) = \${
hypotenuse(3, 4)}');  // 5.0

  // ── RANDOM ─────────────────────
  print('\nRandom:');

  // Non-deterministic
  final rng = math.Random();
  print('  nextInt(100) = \${
rng.nextInt(100)}');   // 0-99
  print('  nextDouble() = \${
rng.nextDouble().toStringAsFixed(4)}');  // 0.0-1.0
  print('  nextBool() = \${
rng.nextBool()}');

  // Seeded (reproducible)
  final seeded = math.Random(42);
  final sequence = List.generate(5, (_) => seeded.nextInt(100));
  print('  Seeded(42): \$sequence');   // always same

  final seeded2 = math.Random(42);
  final sequence2 = List.generate(5, (_) => seeded2.nextInt(100));
  print('  Seeded(42) again: \$sequence2');   // identical!
  print('  Same sequence: \${
sequence.toString() == sequence2.toString()}');  // true

  // Secure random (for crypto)
  final secure = math.Random.secure();
  print('  Secure nextInt: \${
secure.nextInt(1000000)}');

  // ── RANDOM UTILITIES ──────────
  // Random element from list
  List<T> shuffle<T>(List<T> list) {
    final copy = List<T>.from(list);
    for (int i = copy.length - 1; i > 0; i--) {
      final j = rng.nextInt(i + 1);
      final tmp = copy[i];
      copy[i] = copy[j];
      copy[j] = tmp;
    }
    return copy;
  }

  final cards = ['A', 'K', 'Q', 'J', '10'];
  print('  Shuffled: \${
shuffle(cards)}');

  // Random in range [min, max]
  double randomInRange(double min, double max) =>
      min + rng.nextDouble() * (max - min);

  print('  Random [-10, 10]: \${
randomInRange(-10, 10).toStringAsFixed(2)}');

  // Weighted random
  int weightedRandom(List<double> weights) {
    final total = weights.fold(0.0, (a, b) => a + b);
    double r = rng.nextDouble() * total;
    for (int i = 0; i < weights.length; i++) {
      r -= weights[i];
      if (r <= 0) return i;
    }
    return weights.length - 1;
  }

  // 70% chance of 0, 20% of 1, 10% of 2
  final results = List.generate(1000, (_) => weightedRandom([70, 20, 10]));
  final counts = [0, 0, 0];
  for (final r in results) counts[r]++;
  print('  Weighted (70/20/10): \${
counts.map((c) => (c/10).round()).toList()}%');

  // ── STATISTICS ─────────────────
  final nums = List.generate(100, (_) => rng.nextDouble() * 100);
  final sorted = List.from(nums)..sort();

  double mean(List<double> values) =>
      values.fold(0.0, (a, b) => a + b) / values.length;

  double stdDev(List<double> values) {
    final m = mean(values);
    final variance = values.fold(0.0, (a, b) => a + (b - m) * (b - m)) / values.length;
    return math.sqrt(variance);
  }

  print('\nStatistics (100 random values 0-100):');
  print('  Mean: \${
mean(nums).toStringAsFixed(2)}');
  print('  Std dev: \${
stdDev(nums).toStringAsFixed(2)}');
  print('  Min: \${
sorted.first.toStringAsFixed(2)}');
  print('  Max: \${
sorted.last.toStringAsFixed(2)}');
  print('  Median: \${
sorted[50].toStringAsFixed(2)}');
}

📝 KEY POINTS:
✅ import 'dart:math' as math — alias prevents naming conflicts with core members
✅ math.pow(base, exp) returns num — cast to double if needed
✅ Trig functions use RADIANS — convert with degrees * pi / 180
✅ math.atan2(y, x) gives the correct angle in all four quadrants
✅ Random(seed) is reproducible — great for tests and simulations
✅ Random.secure() uses OS entropy — use for passwords, tokens, cryptography
✅ math.min/max work on any Comparable — int, double, etc.
✅ math.log() is the natural logarithm — for log₂ divide by math.ln2
❌ math.pow() returns num not double — may need .toDouble() for assignment
❌ Don't use Regular Random() for security — use Random.secure()
❌ Trig inputs are in radians, not degrees — a common source of bugs
''',
  quiz: [
    Quiz(question: 'What does math.log(x) compute in dart:math?', options: [
      QuizOption(text: 'Log base 10 of x', correct: false),
      QuizOption(text: 'The natural logarithm (ln) of x', correct: true),
      QuizOption(text: 'Log base 2 of x', correct: false),
      QuizOption(text: 'Log base e² of x', correct: false),
    ]),
    Quiz(question: 'What is the difference between Random() and Random.secure()?', options: [
      QuizOption(text: 'Random.secure() is faster', correct: false),
      QuizOption(text: 'Random.secure() uses OS entropy and is cryptographically unpredictable — Random() is a pseudo-random sequence', correct: true),
      QuizOption(text: 'Random.secure() is seeded automatically', correct: false),
      QuizOption(text: 'They are identical', correct: false),
    ]),
    Quiz(question: 'What does Random(42) guarantee compared to Random()?', options: [
      QuizOption(text: 'It generates more random values', correct: false),
      QuizOption(text: 'It produces the same sequence every time — reproducible and deterministic', correct: true),
      QuizOption(text: 'It only generates values from 0 to 42', correct: false),
      QuizOption(text: 'It is thread-safe', correct: false),
    ]),
  ],
);
