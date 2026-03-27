import '../../models/lesson.dart';
import '../../models/quiz.dart';

final jsLesson20 = Lesson(
  language: 'JavaScript',
  title: 'Iterators and Generators',
  content: """
🎯 METAPHOR:
An iterator is like a conveyor belt with a "next item"
button. You press the button, get the next box, press
again, get the next one. You don't know or care how
many boxes there are — you just keep pressing until
the belt says "done." A generator is the worker who
BUILDS the conveyor belt lazily — they don't pre-make
all the boxes ahead of time. They wait until you press
the button, make ONE box, hand it to you, then pause
until you press again. This means a generator can
produce an infinite sequence (infinite boxes) without
ever using infinite memory — it only makes the next box
when you ask for it.

📖 EXPLANATION:
Iterators are the protocol powering for...of, spread,
and destructuring. Generators are functions that can
pause and resume execution using yield.

─────────────────────────────────────
THE ITERATOR PROTOCOL:
─────────────────────────────────────
  An iterator is any object with a next() method that
  returns: { value: any, done: boolean }

  const counter = {
      count: 0,
      next() {
          this.count++;
          if (this.count <= 3) return { value: this.count, done: false };
          return { value: undefined, done: true };
      }
  };

  counter.next()  // { value: 1, done: false }
  counter.next()  // { value: 2, done: false }
  counter.next()  // { value: 3, done: false }
  counter.next()  // { value: undefined, done: true }

─────────────────────────────────────
THE ITERABLE PROTOCOL:
─────────────────────────────────────
  An iterable is any object with [Symbol.iterator]()
  that returns an iterator.

  Built-in iterables: Array, String, Map, Set,
                       NodeList, arguments, TypedArray

  // All of these use [Symbol.iterator] internally:
  for (const x of iterable) { }
  [...iterable]
  const [a, b] = iterable
  Array.from(iterable)
  new Map(iterable)

─────────────────────────────────────
GENERATOR FUNCTIONS:
─────────────────────────────────────
  function* gen() {        // * marks it as a generator
      yield 1;             // pause and produce 1
      yield 2;             // pause and produce 2
      yield 3;             // pause and produce 3
  }                        // implicit return { done: true }

  const g = gen();         // creates a generator object
  g.next()   // { value: 1, done: false }
  g.next()   // { value: 2, done: false }
  g.next()   // { value: 3, done: false }
  g.next()   // { value: undefined, done: true }

  // Generators ARE iterables:
  [...gen()]       // [1, 2, 3]
  for (const x of gen()) { }

─────────────────────────────────────
yield* — DELEGATE TO ANOTHER ITERABLE:
─────────────────────────────────────
  function* combined() {
      yield* [1, 2, 3];
      yield* "hello";
      yield 99;
  }
  [...combined()]  // [1, 2, 3, "h", "e", "l", "l", "o", 99]

─────────────────────────────────────
INFINITE SEQUENCES:
─────────────────────────────────────
  function* naturals(start = 0) {
      let n = start;
      while (true) yield n++;
  }

  function take(n, iterable) {
      const result = [];
      for (const x of iterable) {
          result.push(x);
          if (result.length >= n) break;
      }
      return result;
  }

  take(5, naturals())     // [0, 1, 2, 3, 4]
  take(5, naturals(10))   // [10, 11, 12, 13, 14]

─────────────────────────────────────
TWO-WAY COMMUNICATION WITH next(value):
─────────────────────────────────────
  function* accumulator() {
      let total = 0;
      while (true) {
          const value = yield total;  // yield current total, receive new value
          total += value;
      }
  }

  const acc = accumulator();
  acc.next()      // { value: 0, done: false } — start
  acc.next(10)    // { value: 10, done: false } — sent 10, got total
  acc.next(20)    // { value: 30, done: false } — sent 20, got total
  acc.next(5)     // { value: 35, done: false }

─────────────────────────────────────
ASYNC GENERATORS:
─────────────────────────────────────
  async function* paginate(url) {
      let page = 1;
      while (true) {
          const data = await fetch(\`\${
url}?page=\${
page}\`).then(r => r.json());
          if (data.length === 0) return;
          yield* data;
          page++;
      }
  }

  for await (const item of paginate('/api/items')) {
      console.log(item);
  }

─────────────────────────────────────
LAZY EVALUATION:
─────────────────────────────────────
  Generator pipelines process elements one at a time:

  function* map(fn, iterable) {
      for (const x of iterable) yield fn(x);
  }

  function* filter(fn, iterable) {
      for (const x of iterable) if (fn(x)) yield x;
  }

  function* take(n, iterable) {
      let count = 0;
      for (const x of iterable) {
          if (count++ >= n) return;
          yield x;
      }
  }

  // Process 10 items from an infinite stream, lazily:
  take(10, filter(n => n % 2 === 0, map(n => n*n, naturals())))

💻 CODE:
// ─── CUSTOM ITERATOR ──────────────────────────────────
console.log("=== Custom Iterator ===");

function createRange(start, end, step = 1) {
    return {
        [Symbol.iterator]() {
            let current = start;
            return {
                next() {
                    if (current <= end) {
                        const value = current;
                        current += step;
                        return { value, done: false };
                    }
                    return { value: undefined, done: true };
                }
            };
        }
    };
}

const range = createRange(0, 20, 5);
console.log("  Range 0-20 step 5:", [...range]);
for (const n of createRange(1, 5)) process.stdout.write(n + " ");
console.log();

// ─── BASIC GENERATORS ─────────────────────────────────
console.log("\\n=== Basic Generators ===");

function* countdown(n) {
    while (n > 0) yield n--;
    yield "🚀 Blast off!";
}

console.log("  Countdown:", [...countdown(5)]);

function* fibonacci() {
    let [a, b] = [0, 1];
    while (true) {
        yield a;
        [a, b] = [b, a + b];
    }
}

const fib = fibonacci();
const first10 = Array.from({ length: 10 }, () => fib.next().value);
console.log("  Fibonacci:", first10);

// ─── yield* DELEGATION ────────────────────────────────
console.log("\\n=== yield* Delegation ===");

function* alphabet() {
    yield* "ABCDE";
}

function* combined() {
    yield "start";
    yield* [1, 2, 3];
    yield* alphabet();
    yield "end";
}

console.log("  Combined:", [...combined()]);

// ─── INFINITE SEQUENCES ───────────────────────────────
console.log("\\n=== Infinite Sequences ===");

function* naturals(start = 1) {
    let n = start;
    while (true) yield n++;
}

function* primes() {
    function isPrime(n) {
        if (n < 2) return false;
        for (let i = 2; i <= Math.sqrt(n); i++) {
            if (n % i === 0) return false;
        }
        return true;
    }
    yield* filter(isPrime, naturals(2));
}

function* map(fn, iter) {
    for (const x of iter) yield fn(x);
}

function* filter(fn, iter) {
    for (const x of iter) if (fn(x)) yield x;
}

function* take(n, iter) {
    let count = 0;
    for (const x of iter) {
        if (count++ >= n) return;
        yield x;
    }
}

console.log("  First 10 primes:", [...take(10, primes())]);
console.log("  First 8 squares:", [...take(8, map(n => n*n, naturals()))]);

// Lazy pipeline — only processes what's needed:
const result = [
    ...take(5,
        filter(n => n % 2 === 0,
            map(n => n * n, naturals(1))
        )
    )
];
console.log("  First 5 even squares:", result);

// ─── TWO-WAY COMMUNICATION ────────────────────────────
console.log("\\n=== Two-way Communication ===");

function* calculator() {
    let result = 0;
    while (true) {
        const input = yield result;
        if (input === null) return result;
        result += input;
    }
}

const calc = calculator();
calc.next();       // start (result = 0)
console.log("  After +10:", calc.next(10).value);   // 10
console.log("  After +25:", calc.next(25).value);   // 35
console.log("  After -5:",  calc.next(-5).value);   // 30
console.log("  Final:",     calc.next(null).value); // 30 (done)

// ─── GENERATOR RETURN AND THROW ───────────────────────
console.log("\\n=== Generator return() and throw() ===");

function* interruptable() {
    try {
        yield 1;
        yield 2;
        yield 3;
    } catch (e) {
        console.log("  Caught in generator:", e.message);
        yield -1;
    } finally {
        console.log("  Generator cleanup");
    }
}

const g1 = interruptable();
console.log("  g1.next():", g1.next().value);       // 1
console.log("  g1.throw():", g1.throw(new Error("Interrupted")).value);  // -1
console.log("  g1.next():", g1.next().done);         // true

const g2 = interruptable();
console.log("  g2.next():", g2.next().value);        // 1
console.log("  g2.return(99):", g2.return(99).value);// 99 (early return)
console.log("  g2.done:", g2.next().done);            // true

// ─── ASYNC GENERATOR ──────────────────────────────────
console.log("\\n=== Async Generator ===");

async function* asyncRange(start, end, delayMs = 10) {
    for (let i = start; i <= end; i++) {
        await new Promise(resolve => setTimeout(resolve, delayMs));
        yield i;
    }
}

async function runAsync() {
    const values = [];
    for await (const n of asyncRange(1, 5)) {
        values.push(n);
    }
    console.log("  Async range:", values);
}

runAsync();

📝 KEY POINTS:
✅ The iterator protocol: an object with next() returning { value, done }
✅ The iterable protocol: an object with [Symbol.iterator]() returning an iterator
✅ function* creates a generator function — calling it returns a generator object
✅ yield pauses execution and produces a value; next() resumes
✅ Generators are lazy — they compute values on demand, enabling infinite sequences
✅ yield* delegates to another iterable — like spreading it inline
✅ next(value) passes a value back INTO the generator (two-way communication)
✅ generator.return(value) terminates the generator early
✅ generator.throw(error) injects an error at the current yield point
✅ async function* creates async generators — use with for await...of
❌ Calling the generator function doesn't run any code — it returns an iterator object
❌ Generator objects are single-use — once exhausted, they're done forever
❌ Don't forget to handle return/throw in generators with try/finally for cleanup
❌ Generators are NOT functions that return arrays — they're lazy sequences
""",
  quiz: [
    Quiz(question: 'What does calling a generator function return?', options: [
      QuizOption(text: 'A generator object (iterator) — no code inside runs until you call next()', correct: true),
      QuizOption(text: 'The first yielded value immediately', correct: false),
      QuizOption(text: 'An array of all yielded values', correct: false),
      QuizOption(text: 'A Promise that resolves with the return value', correct: false),
    ]),
    Quiz(question: 'What makes generators useful for infinite sequences?', options: [
      QuizOption(text: 'They compute values lazily on demand — each value is produced only when next() is called', correct: true),
      QuizOption(text: 'They allocate a special infinite-size array that grows as needed', correct: false),
      QuizOption(text: 'They run in a separate thread so they don\'t block the main thread', correct: false),
      QuizOption(text: 'They use circular references to represent unlimited sequences', correct: false),
    ]),
    Quiz(question: 'What does yield* do inside a generator?', options: [
      QuizOption(text: 'It delegates to another iterable — yielding each of its values in sequence', correct: true),
      QuizOption(text: 'It yields a value and terminates the generator', correct: false),
      QuizOption(text: 'It creates a sub-generator that runs in parallel', correct: false),
      QuizOption(text: 'It yields the return value of another generator function call', correct: false),
    ]),
  ],
);
