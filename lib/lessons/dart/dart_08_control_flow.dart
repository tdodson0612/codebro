import '../../models/lesson.dart';
import '../../models/quiz.dart';

final dartLesson08 = Lesson(
  language: 'Dart',
  title: 'Control Flow: if, switch & Guards',
  content: '''
🎯 METAPHOR:
Control flow is like a railroad switching yard.
Each if/else is a track switch — the train (your program)
takes one path or another based on conditions.
switch is like a roundabout with many exits — you arrive
with a value and leave on the matching road.
Dart 3's pattern matching switch is like a smart customs
officer — it doesn't just check your passport number (value),
it inspects your luggage (structure) and checks your visa
type (type), all in one glance.

📖 EXPLANATION:
Dart has if/else for conditional branching, switch for
multi-way branching. Dart 3 dramatically enhanced switch
with pattern matching, guard clauses, expressions, and
exhaustiveness checking.

─────────────────────────────────────
📐 IF / ELSE IF / ELSE
─────────────────────────────────────
if (condition) {
  // true branch
} else if (otherCondition) {
  // second condition true
} else {
  // none of the above
}

Condition MUST be a bool expression (not truthy/falsy).

─────────────────────────────────────
🔀 SWITCH STATEMENT (classic)
─────────────────────────────────────
switch (value) {
  case 1:
    print('one');
    break;           // required to prevent fall-through
  case 2:
  case 3:            // fall-through to share code
    print('two or three');
    break;
  default:
    print('other');
}

─────────────────────────────────────
✨ SWITCH EXPRESSION (Dart 3)
─────────────────────────────────────
A switch that RETURNS a value:

String result = switch (score) {
  >= 90 => 'A',
  >= 80 => 'B',
  >= 70 => 'C',
  _ => 'F',          // wildcard — matches everything
};

─────────────────────────────────────
🎭 PATTERN MATCHING IN SWITCH (Dart 3)
─────────────────────────────────────
switch can match:
  Literals:    case 42:   case 'hello':
  Variables:   case var x:  (captures the value)
  Types:       case String s:  (type check + bind)
  Records:     case (int x, int y):
  Lists:       case [int a, int b, ...]:
  Guards:      case String s when s.length > 5:

─────────────────────────────────────
🛡️  GUARD CLAUSES (when)
─────────────────────────────────────
case String s when s.isNotEmpty:
  // matches String AND the string is not empty

Guards add additional conditions to a pattern.

─────────────────────────────────────
✅ EXHAUSTIVENESS CHECKING
─────────────────────────────────────
When switching on a sealed class or enum, Dart checks
that ALL cases are handled (at compile time!).
No default needed if all cases covered.

💻 CODE:
void main() {
  // ── IF / ELSE ─────────────────
  int score = 85;

  if (score >= 90) {
    print('Grade: A');
  } else if (score >= 80) {
    print('Grade: B');    // ← prints this
  } else if (score >= 70) {
    print('Grade: C');
  } else {
    print('Grade: F');
  }

  // Single-line if (no braces — be careful!)
  if (score > 50) print('Passing');

  // if as an expression? Not directly, use ternary:
  String label = score >= 60 ? 'Pass' : 'Fail';
  print(label);  // Pass

  // Null check pattern
  String? name;
  if (name == null) {
    print('No name provided');
  }
  // After null check, name is promoted to String
  // (nothing here since we entered the if-null branch)

  // ── CLASSIC SWITCH ────────────
  String day = 'Monday';

  switch (day) {
    case 'Monday':
    case 'Tuesday':
    case 'Wednesday':
    case 'Thursday':
    case 'Friday':
      print('Weekday');
      break;
    case 'Saturday':
    case 'Sunday':
      print('Weekend!');
      break;
    default:
      print('Unknown day');
  }

  // ── SWITCH EXPRESSION (Dart 3) ─
  String grade = switch (score) {
    >= 90 => 'A',
    >= 80 => 'B',
    >= 70 => 'C',
    >= 60 => 'D',
    _     => 'F',    // _ is wildcard
  };
  print('Grade: \$grade');   // Grade: B

  // Switch expression with enum
  Season season = Season.summer;
  String activity = switch (season) {
    Season.spring => 'Go hiking',
    Season.summer => 'Go swimming',
    Season.autumn => 'Pick apples',
    Season.winter => 'Build a snowman',
    // No default needed — enum is exhaustive!
  };
  print(activity);   // Go swimming

  // ── PATTERN MATCHING ──────────
  Object value = 'Hello, Dart!';

  switch (value) {
    case int n when n > 0:
      print('Positive int: \$n');
    case int n:
      print('Non-positive int: \$n');
    case String s when s.length > 10:
      print('Long string: \$s');    // ← matches!
    case String s:
      print('Short string: \$s');
    case _:
      print('Something else');
  }

  // ── RECORD PATTERN ────────────
  (int, String) point = (42, 'origin');

  switch (point) {
    case (0, String label):
      print('At origin: \$label');
    case (int x, String label) when x > 0:
      print('Positive: x=\$x, label=\$label');   // ← matches
    case (int x, String label):
      print('Negative: x=\$x, label=\$label');
  }

  // ── LIST PATTERN ──────────────
  List<int> numbers = [1, 2, 3, 4, 5];

  switch (numbers) {
    case []:
      print('Empty');
    case [int only]:
      print('One element: \$only');
    case [int first, int second, ...]:
      print('Starts with \$first, \$second...');  // ← matches
  }

  // ── SWITCH ON SEALED CLASS ────
  // (Sealed classes covered in depth later)
  // When switching on sealed class, Dart ensures exhaustiveness

  // ── IF-CASE STATEMENT (Dart 3) ─
  // pattern matching in if statements!
  Object shape = Circle(radius: 5.0);

  if (shape case Circle(radius: var r) when r > 3) {
    print('Large circle with radius \$r');   // ← matches
  } else if (shape case Rectangle(width: var w, height: var h)) {
    print('Rectangle \${w}x\$h');
  }

  // ── NESTED IF ─────────────────
  int temp = 25;
  bool isRaining = false;

  String advice;
  if (temp > 30) {
    advice = isRaining ? 'Hot and rainy — stay in' : 'Very hot — use sunscreen';
  } else if (temp > 20) {
    advice = isRaining ? 'Warm rain — take an umbrella' : 'Perfect weather!'; // ← this
  } else {
    advice = 'Chilly — wear a jacket';
  }
  print(advice);   // Perfect weather!
}

enum Season { spring, summer, autumn, winter }

class Circle {
  final double radius;
  Circle({required this.radius});
}

class Rectangle {
  final double width, height;
  Rectangle({required this.width, required this.height});
}

📝 KEY POINTS:
✅ Dart conditions must be bool — no truthy/falsy values
✅ Classic switch requires break to prevent fall-through
✅ Switch expression (Dart 3) returns a value and uses => instead of :
✅ _ is the wildcard pattern — matches anything
✅ when adds a guard condition to a pattern: case int n when n > 0
✅ Enum/sealed class switches get exhaustiveness checking at compile time
✅ if-case (Dart 3) lets you use patterns in if statements
✅ Patterns in switch can match type, structure, AND bind variables simultaneously
❌ Don't forget break in classic switch statements (or use return/throw)
❌ Switch expressions don't have fall-through — each arm is a single expression
❌ Guards (when) require the pattern to match first, then the guard is checked
''',
  quiz: [
    Quiz(question: 'What is a Dart switch expression (Dart 3)?', options: [
      QuizOption(text: 'A switch that only works with strings', correct: false),
      QuizOption(text: 'A switch that returns a value using => arms, like a ternary with multiple cases', correct: true),
      QuizOption(text: 'A way to switch between functions', correct: false),
      QuizOption(text: 'The classic switch with the break keyword', correct: false),
    ]),
    Quiz(question: 'What does the when keyword add to a switch case?', options: [
      QuizOption(text: 'It replaces the break statement', correct: false),
      QuizOption(text: 'A guard condition — the case only matches if the pattern AND the when condition are both true', correct: true),
      QuizOption(text: 'It makes the case optional', correct: false),
      QuizOption(text: 'It defers execution of the case body', correct: false),
    ]),
    Quiz(question: 'When switching on an enum, do you need a default case?', options: [
      QuizOption(text: 'Always — default is required in every switch', correct: false),
      QuizOption(text: 'No — if all enum values are covered, Dart\'s exhaustiveness check ensures no default is needed', correct: true),
      QuizOption(text: 'Only if the enum has more than 5 values', correct: false),
      QuizOption(text: 'Only in switch expressions, not switch statements', correct: false),
    ]),
  ],
);
