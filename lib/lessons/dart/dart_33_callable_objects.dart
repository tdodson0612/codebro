import '../../models/lesson.dart';
import '../../models/quiz.dart';

final dartLesson33 = Lesson(
  language: 'Dart',
  title: 'Callable Objects & Advanced Functions',
  content: '''
🎯 METAPHOR:
A callable object is like a person with a specialty job.
A regular object is like a carpenter — you call specific
methods: carpenter.buildTable(), carpenter.repairDoor().
A callable object is like a magician — you just snap your
fingers (call the object itself) and the magic happens.
The magician IS their trick. In Dart, implement call()
on a class and you can invoke instances like functions:
myMagician(input) instead of myMagician.doMagic(input).
This is perfect for strategy objects, event handlers,
and function-like configurations.

📖 EXPLANATION:
Any Dart class can be made callable by implementing the
call() method. The object can then be invoked like a
function. This lesson also covers advanced function topics:
tear-offs, closures, higher-order patterns, and memoization.

─────────────────────────────────────
📐 CALLABLE OBJECTS
─────────────────────────────────────
class Multiplier {
  final int factor;
  Multiplier(this.factor);

  int call(int x) => x * factor;   // makes it callable!
}

var triple = Multiplier(3);
print(triple(5));    // 15 — called like a function!
print(triple(10));   // 30

// Useful because callable objects have STATE:
// triple remembers its factor between calls.

─────────────────────────────────────
🔑 FUNCTION TYPE COMPATIBILITY
─────────────────────────────────────
A callable object IS a Function if it has a call() method.
Can be assigned to a Function variable!

int Function(int) fn = Multiplier(3);  // ✅ compatible!

─────────────────────────────────────
📋 ADVANCED CLOSURES
─────────────────────────────────────
Closures capture variables from their enclosing scope.
Each closure has its OWN copy of captured variables.
Closures in Dart close over the VARIABLE (reference),
not the value — so mutations are visible.

─────────────────────────────────────
🔄 FUNCTION COMPOSITION
─────────────────────────────────────
Composing functions is combining them:
  f(g(x))  →  compose(f, g)(x)

Dart doesn't have built-in composition,
but it's trivial to implement.

─────────────────────────────────────
⚡ MEMOIZATION
─────────────────────────────────────
Caching the result of pure function calls:
  memoize(expensiveFunction)(input)
  → computes once per unique input, caches after

─────────────────────────────────────
🎯 CURRYING
─────────────────────────────────────
Converting f(a, b) into f(a)(b):
  curry((a, b) => a + b)(3)(4)  → 7

Enables partial application:
  var add3 = curriedAdd(3);
  add3(4)   // 7
  add3(10)  // 13

💻 CODE:
void main() {
  // ── CALLABLE OBJECTS ──────────
  final triple = Multiplier(3);
  final double_ = Multiplier(2);

  print(triple(5));    // 15
  print(double_(7));   // 14

  // Callable with state
  final counter = Counter();
  print(counter());   // 1
  print(counter());   // 2
  print(counter());   // 3
  print(counter.count); // 3

  // Validator as callable
  final emailValidator = EmailValidator();
  print(emailValidator('alice@example.com'));  // true
  print(emailValidator('not-an-email'));        // false

  // Assign to Function variable
  bool Function(String) validator = emailValidator;  // ✅
  print(validator('test@test.com'));  // true

  // ── ADVANCED CLOSURES ──────────
  // Each call to makeCounter creates independent state
  var c1 = makeCounter();
  var c2 = makeCounter();
  print(c1());  // 1
  print(c1());  // 2
  print(c2());  // 1 — independent!
  print(c1());  // 3

  // Closure captures REFERENCE to variable:
  var x = 10;
  var addX = (int n) => n + x;   // captures x reference
  print(addX(5));   // 15
  x = 20;           // mutate x
  print(addX(5));   // 25 — closure sees the new value!

  // ── HIGHER-ORDER FUNCTIONS ─────
  final nums = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  // compose — apply functions in sequence
  final processEven = compose(
    (List<int> l) => l.map((n) => n * n).toList(),
    (List<int> l) => l.where((n) => n.isEven).toList(),
  );
  print(processEven(nums));   // [4, 16, 36, 64, 100]

  // pipe — left to right (more readable)
  final processOdd = pipe([
    (List<int> l) => l.where((n) => n.isOdd).toList(),
    (List<int> l) => l.map((n) => n * 2).toList(),
    (List<int> l) => l.reversed.toList(),
  ]);
  print(processOdd(nums));   // [18, 14, 10, 6, 2]

  // ── MEMOIZATION ────────────────
  var callCount = 0;
  int slowFib(int n) {
    callCount++;
    if (n <= 1) return n;
    return slowFib(n - 1) + slowFib(n - 2);
  }

  // Without memoization — exponential calls
  callCount = 0;
  print(slowFib(20));   // correct result
  print('Calls: \$callCount');  // hundreds of thousands

  // With memoization
  callCount = 0;
  final memoFib = memoize<int, int>((n) {
    callCount++;
    if (n <= 1) return n;
    // Note: recursive memoization needs a self-reference trick
    return n;  // simplified for demo
  });
  print('Memoized calls: \$callCount');

  // Proper memoization with Map cache:
  final cache = <int, int>{};
  int fastFib(int n) {
    if (cache.containsKey(n)) return cache[n]!;
    final result = n <= 1 ? n : fastFib(n-1) + fastFib(n-2);
    return cache[n] = result;
  }
  callCount = 0;
  int fibCount = 0;
  int fastFibCounted(int n) {
    if (cache.containsKey(n)) return cache[n]!;
    fibCount++;
    final r = n <= 1 ? n : fastFibCounted(n-1) + fastFibCounted(n-2);
    return cache[n] = r;
  }
  cache.clear();
  print(fastFibCounted(30));      // 832040
  print('Efficient calls: \$fibCount');  // Only 31!

  // ── CURRYING ───────────────────
  final curriedAdd = curry2((int a, int b) => a + b);
  final add10 = curriedAdd(10);
  print(add10(5));    // 15
  print(add10(20));   // 30

  // ── PARTIAL APPLICATION ────────
  final greetFormal = partial(greet, 'Good day');
  final greetCasual = partial(greet, 'Hey');

  print(greetFormal('Alice'));   // Good day, Alice!
  print(greetCasual('Bob'));     // Hey, Bob!

  // ── RETRY FUNCTION ─────────────
  final safeDivide = withRetry(
    (int a, int b) {
      if (b == 0) throw ArgumentError('Cannot divide by zero');
      return a ~/ b;
    },
    maxRetries: 2,
  );

  // ── FUNCTION COMBINATORS ───────
  // negate a predicate
  var isEven = (int n) => n % 2 == 0;
  var isOdd = negate(isEven);
  print([1,2,3,4,5].where(isOdd).toList());  // [1, 3, 5]

  // once — only runs the first time
  var initOnce = once(() => print('Initialized!'));
  initOnce();   // Initialized!
  initOnce();   // (nothing)
  initOnce();   // (nothing)
}

// ── CALLABLE CLASSES ───────────
class Multiplier {
  final int factor;
  Multiplier(this.factor);
  int call(int x) => x * factor;
}

class Counter {
  int count = 0;
  int call() => ++count;
}

class EmailValidator {
  static final _regex = RegExp(r'^[\w-\.]+@[\w-]+\.[a-zA-Z]{2,}\$');
  bool call(String email) => _regex.hasMatch(email);
}

// ── HIGHER-ORDER UTILITIES ─────
Function makeCounter() {
  int count = 0;
  return () => ++count;
}

// compose: apply g first, then f
T Function(A) compose<A, B, T>(
  T Function(B) f,
  B Function(A) g,
) => (A x) => f(g(x));

// pipe: apply functions left to right
T Function(T) pipe<T>(List<T Function(T)> fns) {
  return (T x) => fns.fold(x, (acc, fn) => fn(acc));
}

// memoize (simple single-arg version)
R Function(A) memoize<A, R>(R Function(A) fn) {
  final cache = <A, R>{};
  return (A arg) => cache.putIfAbsent(arg, () => fn(arg));
}

// curry2 — convert (a, b) => r to (a) => (b) => r
R Function(B) Function(A) curry2<A, B, R>(R Function(A, B) fn) {
  return (A a) => (B b) => fn(a, b);
}

// partial application
String Function(String) partial(String Function(String, String) fn, String first) {
  return (String second) => fn(first, second);
}

String greet(String greeting, String name) => '\$greeting, \$name!';

// negate a predicate
bool Function(T) negate<T>(bool Function(T) predicate) {
  return (T value) => !predicate(value);
}

// once — run only on first call
void Function() once(void Function() fn) {
  bool called = false;
  return () {
    if (!called) {
      called = true;
      fn();
    }
  };
}

// withRetry factory
dynamic Function(dynamic, dynamic) withRetry(
  dynamic Function(dynamic, dynamic) fn, {
  int maxRetries = 3,
}) {
  return (a, b) {
    for (int i = 0; i < maxRetries; i++) {
      try {
        return fn(a, b);
      } catch (e) {
        if (i == maxRetries - 1) rethrow;
      }
    }
  };
}

📝 KEY POINTS:
✅ Implement call() on a class to make it callable like a function
✅ Callable objects are functions with persistent state — powerful for strategies
✅ Closures capture variable REFERENCES — mutations after closure creation are visible
✅ compose(f, g) creates f(g(x)); pipe([f, g]) creates g(f(x)) left-to-right
✅ Memoization caches results — only pure functions should be memoized
✅ curry2 converts (a, b) => r to (a) => (b) => r
✅ Partial application bakes in some arguments, creating specialized functions
✅ Function combinators (negate, once, retry) build robust function pipelines
❌ Callable objects are NOT identical to Dart functions — they don't have .call implicitly on assignment to var
❌ Memoizing impure functions (with side effects) gives wrong cached results
❌ Curried functions in Dart aren't built-in — manual implementation needed
''',
  quiz: [
    Quiz(question: 'How do you make a Dart class callable like a function?', options: [
      QuizOption(text: 'Implement the Callable interface', correct: false),
      QuizOption(text: 'Define a call() method on the class', correct: true),
      QuizOption(text: 'Extend Function class', correct: false),
      QuizOption(text: 'Use the @callable annotation', correct: false),
    ]),
    Quiz(question: 'What does a closure capture when it references an outer variable?', options: [
      QuizOption(text: 'A copy of the value at the time the closure was created', correct: false),
      QuizOption(text: 'A reference to the variable — mutations after closure creation are visible', correct: true),
      QuizOption(text: 'The type of the variable only', correct: false),
      QuizOption(text: 'Nothing — closures are pure', correct: false),
    ]),
    Quiz(question: 'What is the difference between compose(f, g) and pipe([f, g])?', options: [
      QuizOption(text: 'compose applies f first; pipe applies g first', correct: false),
      QuizOption(text: 'compose applies g first then f (right-to-left); pipe applies f first then g (left-to-right)', correct: true),
      QuizOption(text: 'They are identical', correct: false),
      QuizOption(text: 'compose works with closures; pipe works with named functions', correct: false),
    ]),
  ],
);
