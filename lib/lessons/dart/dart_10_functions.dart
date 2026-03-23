import '../../models/lesson.dart';
import '../../models/quiz.dart';

final dartLesson10 = Lesson(
  language: 'Dart',
  title: 'Functions',
  content: '''
🎯 METAPHOR:
Functions are like specialized appliances in a kitchen.
Each appliance (function) has a clear job: the blender
blends, the oven bakes, the coffee maker brews. You set
the inputs (put ingredients in), it runs its process, and
gives you an output (a smoothie, a cake, coffee). Functions
in Dart take the same approach — clear inputs (parameters),
a defined process (body), and a clear output (return type).
Arrow functions are the espresso machines: minimal,
focused, single-purpose. Named parameters are the dials —
self-documenting controls that tell you exactly what each
setting does.

📖 EXPLANATION:
Functions are first-class objects in Dart — they can be
stored in variables, passed as arguments, and returned
from other functions. Dart has named functions, anonymous
functions (lambdas), arrow functions, and closures.

─────────────────────────────────────
📐 FUNCTION SYNTAX
─────────────────────────────────────
// Named function
ReturnType functionName(Type param) {
  return value;
}

// Arrow function (single expression)
ReturnType functionName(Type param) => expression;

// No return value
void doSomething() { ... }

// Optional return type (inferred)
greet(String name) => 'Hello, \$name!';

─────────────────────────────────────
📦 PARAMETER TYPES
─────────────────────────────────────
Required positional:   func(int a, String b)
Optional positional:   func(int a, [String? b])
Named (optional):      func({String? name})
Named (required):      func({required String name})
Default values:        func({int count = 1})

Named + positional mix:
  func(int req, {String? name, int count = 0})

─────────────────────────────────────
🔗 FIRST-CLASS FUNCTIONS
─────────────────────────────────────
Assign to variable:
  var greet = (String name) => 'Hi \$name!';

Pass as argument:
  list.forEach(print);
  list.sort((a, b) => a.compareTo(b));

Return from function:
  Function makeMultiplier(int n) => (int x) => x * n;

─────────────────────────────────────
🔒 CLOSURES
─────────────────────────────────────
A closure captures variables from its surrounding scope:
  Function counter() {
    int count = 0;
    return () => ++count;   // captures count
  }
  var c = counter();
  c();   // 1
  c();   // 2  (count persists!)

─────────────────────────────────────
📋 FUNCTION TYPEDEF
─────────────────────────────────────
typedef Transformer<T> = T Function(T value);
typedef Predicate<T> = bool Function(T value);
typedef Callback = void Function(String message);

─────────────────────────────────────
🎯 TEAR-OFFS
─────────────────────────────────────
A method reference WITHOUT calling it:
  print        → tear-off of the print function
  [1,2,3].forEach(print)  → passes print as function
  names.forEach(greet)    → passes greet method

─────────────────────────────────────
🌀 RECURSIVE FUNCTIONS
─────────────────────────────────────
Functions can call themselves. Always needs a base case.

💻 CODE:
void main() {
  // ── BASIC FUNCTIONS ───────────
  print(add(3, 4));          // 7
  print(greet('Alice'));     // Hello, Alice!
  print(square(5));          // 25 (arrow function)
  sayHello();                // Hello!

  // ── OPTIONAL POSITIONAL ───────
  print(repeat('hi'));       // hi (once)
  print(repeat('hi', 3));    // hi hi hi

  // ── NAMED PARAMETERS ──────────
  print(makeTag(content: 'Hello', tag: 'h1'));  // <h1>Hello</h1>
  print(makeTag(content: 'World'));              // <p>World</p>

  // Required named
  print(createUser(name: 'Alice', age: 30));

  // ── DEFAULT VALUES ─────────────
  print(connect());                      // localhost:3306
  print(connect(host: 'prod.db'));       // prod.db:3306
  print(connect(host: '10.0.0.1', port: 5432)); // 10.0.0.1:5432

  // ── FIRST-CLASS FUNCTIONS ──────
  // Store in a variable
  var double_ = (int n) => n * 2;
  print(double_(5));   // 10

  // Pass as argument
  List<int> nums = [3, 1, 4, 1, 5, 9, 2, 6];
  nums.sort((a, b) => a.compareTo(b));
  print(nums);  // [1, 1, 2, 3, 4, 5, 6, 9]

  // Tear-offs
  List<String> words = ['hello', 'world'];
  words.forEach(print);    // print is a tear-off
  List<String> upper = words.map(toUpper).toList();
  print(upper);  // [HELLO, WORLD]

  // ── ANONYMOUS FUNCTIONS ────────
  var multiply = (int a, int b) {
    return a * b;
  };
  print(multiply(4, 5));  // 20

  // Immediately invoked
  print(((int x) => x * x)(7));  // 49

  // ── CLOSURES ──────────────────
  var counter = makeCounter();
  print(counter());   // 1
  print(counter());   // 2
  print(counter());   // 3

  var counter2 = makeCounter();  // independent counter
  print(counter2());  // 1

  // Closure capturing loop variable
  List<Function> funcs = [];
  for (var i = 0; i < 3; i++) {
    final captured = i;   // capture current value
    funcs.add(() => captured);
  }
  print(funcs[0]());  // 0
  print(funcs[1]());  // 1
  print(funcs[2]());  // 2

  // ── HIGHER-ORDER FUNCTIONS ─────
  print(applyTwice(square, 3));   // 81 (3²=9, 9²=81)

  // Function returning a function
  var triple = makeMultiplier(3);
  var quadruple = makeMultiplier(4);
  print(triple(5));     // 15
  print(quadruple(5));  // 20

  // ── TYPEDEFS ──────────────────
  Transformer<String> shout = (s) => s.toUpperCase() + '!!!';
  print(applyTransform('hello', shout));   // HELLO!!!

  Predicate<int> isEven = (n) => n % 2 == 0;
  print([1,2,3,4,5].where(isEven).toList());  // [2, 4]

  // ── RECURSION ─────────────────
  print(factorial(5));   // 120
  print(fibonacci(10));  // 55

  // ── GENERATOR FUNCTIONS ───────
  // sync* (iterable)
  for (final n in range(1, 6)) {
    print(n);   // 1 2 3 4 5
  }

  // ── MAIN WITH ARGS ─────────────
  // void main(List<String> args) { ... }
  // dart run myapp.dart arg1 arg2
}

// Named functions
int add(int a, int b) => a + b;

String greet(String name) => 'Hello, \$name!';

int square(int n) => n * n;

void sayHello() {
  print('Hello!');
}

String toUpper(String s) => s.toUpperCase();  // for tear-off

// Optional positional parameters
String repeat(String s, [int times = 1]) {
  return List.filled(times, s).join(' ');
}

// Named parameters with defaults
String makeTag({required String content, String tag = 'p'}) {
  return '<\$tag>\$content</\$tag>';
}

// Required named parameters
String createUser({required String name, required int age}) {
  return 'User: \$name, age \$age';
}

// Named with defaults
String connect({
  String host = 'localhost',
  int port = 3306,
}) {
  return '\$host:\$port';
}

// Closure factory
Function makeCounter() {
  int count = 0;
  return () => ++count;
}

// Higher-order function
int applyTwice(int Function(int) f, int x) => f(f(x));

// Function returning function
int Function(int) makeMultiplier(int factor) {
  return (int x) => x * factor;
}

// Typedefs
typedef Transformer<T> = T Function(T value);
typedef Predicate<T> = bool Function(T value);

T applyTransform<T>(T value, Transformer<T> transform) {
  return transform(value);
}

// Recursive functions
int factorial(int n) => n <= 1 ? 1 : n * factorial(n - 1);

int fibonacci(int n) => n <= 1 ? n : fibonacci(n - 1) + fibonacci(n - 2);

// Generator function
Iterable<int> range(int start, int end) sync* {
  for (int i = start; i < end; i++) {
    yield i;
  }
}

📝 KEY POINTS:
✅ All Dart functions are first-class objects — store, pass, return them
✅ Arrow => is for single-expression functions (must be ONE expression)
✅ Named parameters with {} are optional unless marked required:
✅ Optional positional parameters use [] with optional defaults
✅ Closures capture variables from their surrounding scope
✅ Tear-offs: passing a function by name without calling it (print, greet)
✅ typedef names function signatures for reuse and readability
✅ sync* with yield creates lazy synchronous generator functions
❌ Named parameters come AFTER positional parameters
❌ You can't mix optional positional [] and named {} in one function
❌ Arrow functions can only contain a single expression, not a block
''',
  quiz: [
    Quiz(question: 'What is the difference between required and optional named parameters?', options: [
      QuizOption(text: 'required parameters come first; optional come last', correct: false),
      QuizOption(text: 'required must be passed by the caller; optional can be omitted (defaulting to null or a default value)', correct: true),
      QuizOption(text: 'Optional parameters cannot have default values', correct: false),
      QuizOption(text: 'required parameters are positional; optional are named', correct: false),
    ]),
    Quiz(question: 'What is a "tear-off" in Dart?', options: [
      QuizOption(text: 'Removing a method from a class', correct: false),
      QuizOption(text: 'A reference to a function or method without calling it — usable as a value', correct: true),
      QuizOption(text: 'Tearing apart a composite type', correct: false),
      QuizOption(text: 'A closure that captures variables', correct: false),
    ]),
    Quiz(question: 'What does a sync* function with yield produce?', options: [
      QuizOption(text: 'A Future that resolves to the yielded values', correct: false),
      QuizOption(text: 'A lazy synchronous Iterable — values computed on demand', correct: true),
      QuizOption(text: 'A Stream of values', correct: false),
      QuizOption(text: 'A List containing the yielded values', correct: false),
    ]),
  ],
);
