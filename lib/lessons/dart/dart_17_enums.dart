import '../../models/lesson.dart';
import '../../models/quiz.dart';

final dartLesson17 = Lesson(
  language: 'Dart',
  title: 'Enums: Simple & Enhanced',
  content: '''
🎯 METAPHOR:
A simple enum is like a traffic light — exactly three
states: Red, Yellow, Green. No in-between. No "kind of
red." The type system enforces this: you can't set the
light to "purple" or 42. It's one of exactly those three.
An enhanced enum (Dart 2.17+) is like a traffic light
that ALSO knows things about itself: Red knows it means
"stop" and lasts 30 seconds. Yellow knows it means "slow"
and lasts 5 seconds. Each case carries its own data
and behavior — it's like a tiny object masquerading as
an enum case.

📖 EXPLANATION:
Dart's simple enums are named constants in a sealed set.
Enhanced enums (Dart 2.17+) can have fields, constructors,
methods, getters, and even implement interfaces. They are
regular Dart classes that happen to have a fixed set of
named instances.

─────────────────────────────────────
📐 SIMPLE ENUM
─────────────────────────────────────
enum Color { red, green, blue }

// Access:
Color c = Color.red;
print(c);           // Color.red
print(c.name);      // red
print(c.index);     // 0
Color.values        // [Color.red, Color.green, Color.blue]

// In switch (exhaustive!):
switch (c) {
  case Color.red:   print('Stop!');
  case Color.green: print('Go!');
  case Color.blue:  print('...');
}

─────────────────────────────────────
⭐ ENHANCED ENUM (Dart 2.17+)
─────────────────────────────────────
enum Planet {
  mercury(mass: 3.303e+23, radius: 2.4397e6),
  venus(mass: 4.869e+24, radius: 6.0518e6);

  const Planet({required this.mass, required this.radius});

  final double mass;
  final double radius;

  static const double G = 6.67430e-11;

  double get surfaceGravity => G * mass / (radius * radius);
}

─────────────────────────────────────
📋 BUILT-IN ENUM PROPERTIES
─────────────────────────────────────
All enums automatically get:
  .name     → String name of the case
  .index    → int position (0-based)
  .values   → static list of all values
  .toString() → 'EnumName.caseName'

EnumType.values.byName('red')   → find by name
EnumType.values[0]              → find by index

─────────────────────────────────────
🎭 ENUM IN SWITCH
─────────────────────────────────────
Dart checks exhaustiveness on enum switches!
If you cover all cases, no default needed.
If you don't cover all cases, compile warning.

─────────────────────────────────────
🔒 SEALED ENUMS
─────────────────────────────────────
All enums are sealed — no new cases can be added at runtime.
This enables exhaustiveness checking in switch.

💻 CODE:
void main() {
  // ── SIMPLE ENUM ───────────────
  Color favorite = Color.blue;
  print(favorite);          // Color.blue
  print(favorite.name);     // blue
  print(favorite.index);    // 2

  // All values
  print(Color.values);      // [Color.red, Color.green, Color.blue]

  // Iterate
  for (final color in Color.values) {
    print('\${color.index}: \${color.name}');
  }

  // Find by name (null if not found)
  Color? fromName = Color.values.byName('green');
  print(fromName);  // Color.green

  // In switch — exhaustive!
  String signal = switch (favorite) {
    Color.red   => 'Stop',
    Color.green => 'Go',
    Color.blue  => 'Interesting...',
  };
  print(signal);  // Interesting...

  // ── DIRECTION ENUM ─────────────
  Direction d = Direction.north;
  print(d.opposite);    // Direction.south
  print(d.dx);          // 0
  print(d.dy);          // 1

  // Move using enum
  int x = 0, y = 0;
  for (var dir in [Direction.north, Direction.east, Direction.north]) {
    x += dir.dx;
    y += dir.dy;
  }
  print('Position: (\$x, \$y)');  // (1, 2)

  // ── STATUS ENUM ───────────────
  Status order = Status.pending;
  print(order.label);           // Pending
  print(order.canTransitionTo(Status.processing));  // true
  print(order.canTransitionTo(Status.delivered));   // false

  // State machine
  Status current = Status.pending;
  List<Status> transitions = [
    Status.processing,
    Status.shipped,
    Status.delivered,
  ];

  for (var next in transitions) {
    if (current.canTransitionTo(next)) {
      print('✅ \${current.label} → \${next.label}');
      current = next;
    } else {
      print('❌ Cannot go from \${current.label} to \${next.label}');
    }
  }

  // ── PLANET ENUM ───────────────
  print('\nPlanets:');
  for (var planet in Planet.values) {
    print('\${planet.name}: gravity=\${planet.surfaceGravity.toStringAsFixed(2)} m/s²');
  }

  double earthWeight = 70.0;  // kg
  print('\n\$earthWeight kg person weighs:');
  for (var planet in Planet.values) {
    double weight = planet.weightOf(earthWeight);
    print('  \${planet.name}: \${weight.toStringAsFixed(1)} kg');
  }

  // ── HTTP METHOD ENUM ──────────
  HttpMethod method = HttpMethod.post;
  print(method.hasBody);     // true
  print(method.isIdempotent); // false
  
  // Pattern match on enum
  String description = switch (method) {
    HttpMethod.get    => 'Retrieve data',
    HttpMethod.post   => 'Create resource',
    HttpMethod.put    => 'Replace resource',
    HttpMethod.patch  => 'Partial update',
    HttpMethod.delete => 'Remove resource',
  };
  print(description);   // Create resource

  // ── SERIALIZATION ─────────────
  String json = '"red"';  // from API
  String colorName = json.replaceAll('"', '');
  Color parsed = Color.values.byName(colorName);
  print(parsed);  // Color.red

  // Enum to JSON
  String toJson = '"\${favorite.name}"';
  print(toJson);  // "blue"
}

// ── SIMPLE ENUM ────────────────
enum Color { red, green, blue }

// ── DIRECTION ENUM (with getters) ──
enum Direction {
  north, south, east, west;

  Direction get opposite => switch (this) {
    Direction.north => Direction.south,
    Direction.south => Direction.north,
    Direction.east  => Direction.west,
    Direction.west  => Direction.east,
  };

  int get dx => switch (this) {
    Direction.east  =>  1,
    Direction.west  => -1,
    _               =>  0,
  };

  int get dy => switch (this) {
    Direction.north =>  1,
    Direction.south => -1,
    _               =>  0,
  };
}

// ── ENHANCED ENUM WITH FIELDS ──
enum Status {
  pending('Pending', []),
  processing('Processing', []),
  shipped('Shipped', []),
  delivered('Delivered', []),
  cancelled('Cancelled', []);

  const Status(this.label, this._allowedTransitions);

  final String label;
  final List<Status> _allowedTransitions;

  bool canTransitionTo(Status next) => switch (this) {
    Status.pending    => next == Status.processing || next == Status.cancelled,
    Status.processing => next == Status.shipped || next == Status.cancelled,
    Status.shipped    => next == Status.delivered,
    _                 => false,
  };
}

// ── PLANET ENHANCED ENUM ───────
enum Planet {
  mercury(mass: 3.303e+23, radius: 2.4397e6),
  venus  (mass: 4.869e+24, radius: 6.0518e6),
  earth  (mass: 5.976e+24, radius: 6.37814e6),
  mars   (mass: 6.421e+23, radius: 3.3972e6);

  const Planet({required this.mass, required this.radius});

  final double mass;
  final double radius;

  static const double G = 6.67430e-11;

  double get surfaceGravity => G * mass / (radius * radius);

  double weightOf(double earthWeightKg) {
    return earthWeightKg * surfaceGravity / Planet.earth.surfaceGravity;
  }
}

// ── HTTP METHOD ENUM ───────────
enum HttpMethod {
  get, post, put, patch, delete;

  bool get hasBody => this == post || this == put || this == patch;

  bool get isIdempotent =>
      this == get || this == put || this == delete;

  String get value => name.toUpperCase();
}

📝 KEY POINTS:
✅ Simple enums: enum Color { red, green, blue } — type-safe named constants
✅ .name returns the case name as String; .index returns its position
✅ .values returns a list of all enum values
✅ .byName('name') finds an enum value by its string name (throws if not found)
✅ Enhanced enums can have fields, constructors, methods, and getters
✅ Enhanced enum constructors MUST be const
✅ Switch on enums is exhaustive — compiler checks all cases are covered
✅ Enums can implement interfaces in Dart 2.17+
❌ Cannot create new enum instances at runtime — they're a fixed set
❌ Enhanced enum constructors cannot be non-const
❌ byName() throws if the name doesn't exist — use values.where() for safety
''',
  quiz: [
    Quiz(question: 'What does Color.values.byName("red") return?', options: [
      QuizOption(text: 'The index 0', correct: false),
      QuizOption(text: 'The Color.red enum value', correct: true),
      QuizOption(text: 'The string "red"', correct: false),
      QuizOption(text: 'null if not found', correct: false),
    ]),
    Quiz(question: 'What is required for constructors in enhanced enums?', options: [
      QuizOption(text: 'They must be private', correct: false),
      QuizOption(text: 'They must be const', correct: true),
      QuizOption(text: 'They must use initializing formals', correct: false),
      QuizOption(text: 'They must be factory constructors', correct: false),
    ]),
    Quiz(question: 'What happens if you switch on an enum but miss a case?', options: [
      QuizOption(text: 'The program crashes at runtime', correct: false),
      QuizOption(text: 'Dart\'s exhaustiveness check produces a compile warning or error', correct: true),
      QuizOption(text: 'The default case is used automatically', correct: false),
      QuizOption(text: 'Nothing — Dart ignores missing cases', correct: false),
    ]),
  ],
);