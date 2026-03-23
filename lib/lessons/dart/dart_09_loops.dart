import '../../models/lesson.dart';
import '../../models/quiz.dart';

final dartLesson09 = Lesson(
  language: 'Dart',
  title: 'Loops: for, while & Iteration',
  content: '''
🎯 METAPHOR:
Loops are like assembly line workers.
A for loop is a worker who knows exactly how many parts
to process: "I'll handle items 1 through 100, done."
A while loop is a worker who keeps going until the alarm
sounds: "Keep going while the hopper is not empty."
A do-while loop is the same worker but guaranteed to
process at least one part before checking: "Process one,
then check the hopper." for-in is the most elegant: a
worker who picks up each item from a conveyor belt without
caring about the index number.

📖 EXPLANATION:
Dart has four loop constructs: for (classic C-style),
for-in (iteration over iterables), while (condition first),
and do-while (body first). Plus break, continue, and
labeled loops for complex control flow.

─────────────────────────────────────
📐 FOR LOOP
─────────────────────────────────────
for (init; condition; increment) {
  body
}

for (int i = 0; i < 5; i++) {
  print(i);  // 0, 1, 2, 3, 4
}

─────────────────────────────────────
🔄 FOR-IN LOOP (preferred for iterables)
─────────────────────────────────────
for (var item in collection) {
  // item is each element
}

for (final name in names) {
  print(name);
}

// With index — use indexed extension or enumerate
for (final (i, name) in names.indexed) {
  print('\$i: \$name');
}

─────────────────────────────────────
⏳ WHILE LOOP
─────────────────────────────────────
while (condition) {
  // runs while condition is true
  // condition checked BEFORE each iteration
}

─────────────────────────────────────
🔁 DO-WHILE LOOP
─────────────────────────────────────
do {
  // runs at least ONCE
  // condition checked AFTER each iteration
} while (condition);

─────────────────────────────────────
⏩ BREAK & CONTINUE
─────────────────────────────────────
break;          → exit the loop immediately
continue;       → skip to next iteration

Labeled loops for breaking out of nested loops:
  outerLoop: for (...) {
    for (...) {
      if (done) break outerLoop;
    }
  }

─────────────────────────────────────
📦 ITERABLE METHODS (functional style)
─────────────────────────────────────
Often better than explicit loops:
  .forEach()      → apply function to each element
  .map()          → transform each element
  .where()        → filter elements
  .any()          → true if any element matches
  .every()        → true if all elements match
  .reduce()       → fold to single value
  .fold()         → fold with initial value
  .take(n)        → first n elements
  .skip(n)        → skip first n elements
  .toList()       → convert lazy Iterable to List

💻 CODE:
void main() {
  // ── CLASSIC FOR LOOP ──────────
  print('Counting up:');
  for (int i = 0; i < 5; i++) {
    print(i);    // 0 1 2 3 4
  }

  print('Counting down:');
  for (int i = 5; i > 0; i--) {
    print(i);    // 5 4 3 2 1
  }

  // Step by 2
  for (int i = 0; i <= 10; i += 2) {
    print(i);    // 0 2 4 6 8 10
  }

  // ── FOR-IN LOOP ───────────────
  List<String> fruits = ['apple', 'banana', 'cherry'];

  for (final fruit in fruits) {
    print(fruit.toUpperCase());   // APPLE BANANA CHERRY
  }

  // Map iteration
  Map<String, int> scores = {'Alice': 92, 'Bob': 78};
  for (final entry in scores.entries) {
    print('\${entry.key}: \${entry.value}');
  }
  // Or destructure:
  for (final MapEntry(key: name, value: score) in scores.entries) {
    print('\$name scored \$score');
  }

  // ── INDEXED ITERATION (Dart 3.7+) ──
  List<String> colors = ['red', 'green', 'blue'];
  for (final (index, color) in colors.indexed) {
    print('\$index: \$color');
  }
  // 0: red
  // 1: green
  // 2: blue

  // For older Dart, use asMap() or generate index manually
  for (int i = 0; i < colors.length; i++) {
    print('\$i: \${colors[i]}');
  }

  // ── WHILE LOOP ────────────────
  int count = 0;
  while (count < 5) {
    print('count: \$count');
    count++;
  }

  // Reading until a condition
  String input = 'data to process';
  int pos = 0;
  while (pos < input.length) {
    print(input[pos]);
    pos++;
  }

  // ── DO-WHILE LOOP ─────────────
  int n = 0;
  do {
    print('n = \$n');
    n++;
  } while (n < 3);
  // Prints n=0, n=1, n=2

  // do-while guarantees at least one execution:
  int x = 100;
  do {
    print('Executes once even though 100 > 3');
  } while (x < 3);

  // ── BREAK ─────────────────────
  for (int i = 0; i < 10; i++) {
    if (i == 5) break;
    print(i);    // 0 1 2 3 4 (stops at 5)
  }

  // ── CONTINUE ──────────────────
  for (int i = 0; i < 8; i++) {
    if (i % 2 == 0) continue;    // skip evens
    print(i);    // 1 3 5 7
  }

  // ── LABELED LOOPS ─────────────
  outer:
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      if (i == 1 && j == 1) {
        print('Breaking out of BOTH loops');
        break outer;    // exits outer loop
      }
      print('(\$i, \$j)');
    }
  }
  // Prints (0,0)(0,1)(0,2)(1,0) then breaks

  // ── FUNCTIONAL ALTERNATIVES ───
  List<int> numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  // forEach
  numbers.forEach(print);    // prints each number

  // map — transform
  List<int> doubled = numbers.map((n) => n * 2).toList();
  print(doubled);  // [2, 4, 6, 8, 10, 12, 14, 16, 18, 20]

  // where — filter
  List<int> evens = numbers.where((n) => n.isEven).toList();
  print(evens);    // [2, 4, 6, 8, 10]

  // chain: filter then transform
  List<int> doubledEvens = numbers
      .where((n) => n.isEven)
      .map((n) => n * 2)
      .toList();
  print(doubledEvens);  // [4, 8, 12, 16, 20]

  // any / every
  print(numbers.any((n) => n > 8));     // true
  print(numbers.every((n) => n > 0));   // true
  print(numbers.every((n) => n > 5));   // false

  // reduce / fold
  int sum = numbers.reduce((a, b) => a + b);
  print(sum);    // 55

  int product = numbers.fold(1, (acc, n) => acc * n);
  print(product);    // 3628800

  // take / skip
  print(numbers.take(3).toList());    // [1, 2, 3]
  print(numbers.skip(7).toList());    // [8, 9, 10]

  // ── GENERATOR FUNCTIONS ───────
  // sync* generates a lazy Iterable
  Iterable<int> range(int start, int end) sync* {
    for (int i = start; i < end; i++) {
      yield i;
    }
  }

  for (final n in range(5, 10)) {
    print(n);   // 5 6 7 8 9
  }
}

// Generator function example
Iterable<int> fibonacci() sync* {
  int a = 0, b = 1;
  while (true) {
    yield a;
    int temp = a;
    a = b;
    b = temp + b;
  }
}

void printFibonacci(int count) {
  int i = 0;
  for (final n in fibonacci()) {
    if (i++ >= count) break;
    print(n);
  }
}

📝 KEY POINTS:
✅ for-in is the cleanest way to iterate over lists, sets, and maps
✅ Use .indexed to get (index, value) pairs in Dart 3.7+
✅ while checks condition before; do-while checks condition after
✅ break exits the loop; continue skips to the next iteration
✅ Labels let you break/continue outer loops from nested ones
✅ Functional methods (.map, .where, .reduce) often replace loops cleanly
✅ sync* generator functions create lazy iterables with yield
✅ for (final item in collection) — prefer final over var in loops
❌ Don't modify a collection while iterating it with for-in — use a copy
❌ Infinite while loops must have a reliable break condition
❌ forEach doesn't support break or continue — use for-in instead
''',
  quiz: [
    Quiz(question: 'What is the difference between while and do-while?', options: [
      QuizOption(text: 'while is for numbers; do-while is for strings', correct: false),
      QuizOption(text: 'while checks the condition before the body; do-while checks after — body runs at least once', correct: true),
      QuizOption(text: 'do-while is faster than while', correct: false),
      QuizOption(text: 'They are identical — just different syntax', correct: false),
    ]),
    Quiz(question: 'How do you break out of a nested loop in Dart?', options: [
      QuizOption(text: 'break break; — two break statements', correct: false),
      QuizOption(text: 'Label the outer loop and use break labelName; from the inner loop', correct: true),
      QuizOption(text: 'You cannot break out of nested loops in Dart', correct: false),
      QuizOption(text: 'throw an exception and catch it outside', correct: false),
    ]),
    Quiz(question: 'What does numbers.where((n) => n.isEven).map((n) => n * 2).toList() do?', options: [
      QuizOption(text: 'Doubles all numbers then filters evens', correct: false),
      QuizOption(text: 'Filters to even numbers, then doubles each, then collects to a List', correct: true),
      QuizOption(text: 'Maps all numbers to booleans', correct: false),
      QuizOption(text: 'It is a compile error — where and map cannot be chained', correct: false),
    ]),
  ],
);
