import '../../models/lesson.dart';
import '../../models/quiz.dart';

final jsLesson18 = Lesson(
  language: 'JavaScript',
  title: 'Higher-Order Functions',
  content: """
🎯 METAPHOR:
Higher-order functions are like management consultants.
A regular worker (normal function) does one specific job.
A consultant (higher-order function) takes OTHER workers
as inputs, coordinates them, delegates to them, and
returns a new combined worker. "Here's a team of three
specialists — coordinate them into one workflow." map
is the consultant who says "have every worker process
one item." filter is the consultant who says "only keep
workers who pass this test." reduce is the consultant
who says "fold all results into one final answer."
You're not doing the work — you're orchestrating it.

📖 EXPLANATION:
A higher-order function (HOF) either:
→ Takes one or more functions as arguments, OR
→ Returns a function as its result (or both)

This is possible because in JavaScript, functions are
first-class values — they can be passed around like
any other variable.

─────────────────────────────────────
THE BIG THREE ARRAY HOFs:
─────────────────────────────────────
  arr.map(fn)      → transform each element → new array
  arr.filter(fn)   → keep elements where fn returns true
  arr.reduce(fn, init) → fold to single value

  arr.forEach(fn)  → side effects only, returns undefined
  arr.find(fn)     → first element where fn is true
  arr.findIndex(fn)→ index of first match
  arr.findLast(fn) → last element where fn is true (ES2023)
  arr.some(fn)     → true if ANY element passes
  arr.every(fn)    → true if ALL elements pass
  arr.flatMap(fn)  → map then flatten one level
  arr.sort(fn)     → sort with custom comparator

─────────────────────────────────────
map — TRANSFORM:
─────────────────────────────────────
  const nums = [1, 2, 3, 4, 5];

  const doubled  = nums.map(n => n * 2);   // [2, 4, 6, 8, 10]
  const squared  = nums.map(n => n ** 2);  // [1, 4, 9, 16, 25]
  const asStr    = nums.map(String);       // ["1","2","3","4","5"]

  // Map over objects:
  const users = [{ name: "Alice", age: 28 }];
  const names = users.map(u => u.name);    // ["Alice"]

─────────────────────────────────────
filter — KEEP MATCHING:
─────────────────────────────────────
  const nums = [1, 2, 3, 4, 5, 6, 7, 8];

  const evens    = nums.filter(n => n % 2 === 0);  // [2,4,6,8]
  const big      = nums.filter(n => n > 5);         // [6,7,8]
  const nonNull  = [1, null, 2, undefined, 3].filter(Boolean);
  // → [1, 2, 3]  (Boolean filters out falsy values)

─────────────────────────────────────
reduce — FOLD TO ONE VALUE:
─────────────────────────────────────
  const nums = [1, 2, 3, 4, 5];

  // Sum:
  const sum = nums.reduce((acc, n) => acc + n, 0);  // 15

  // Product:
  const product = nums.reduce((acc, n) => acc * n, 1); // 120

  // Flatten:
  [[1,2],[3,4],[5,6]].reduce((acc, arr) => [...acc, ...arr], []);
  // → [1, 2, 3, 4, 5, 6]

  // Group by:
  const byLength = ["cat","dog","fish","ant"].reduce((acc, word) => {
      const len = word.length;
      acc[len] = acc[len] || [];
      acc[len].push(word);
      return acc;
  }, {});
  // → { 3: ["cat","dog","ant"], 4: ["fish"] }

─────────────────────────────────────
RETURNING FUNCTIONS — function factories:
─────────────────────────────────────
  function multiplier(factor) {
      return (n) => n * factor;    // returns a function!
  }
  const double = multiplier(2);
  const triple = multiplier(3);
  double(5)  // 10
  triple(5)  // 15

  // Partial application:
  function add(a) { return (b) => a + b; }
  const add10 = add(10);
  add10(5)   // 15
  add10(20)  // 30

─────────────────────────────────────
FUNCTION COMPOSITION:
─────────────────────────────────────
  const compose = (...fns) => x => fns.reduceRight((v, f) => f(v), x);
  const pipe    = (...fns) => x => fns.reduce((v, f) => f(v), x);

  const transform = pipe(
      s => s.trim(),
      s => s.toLowerCase(),
      s => s.replace(/\\s+/g, '_')
  );
  transform("  Hello World  ")  // "hello_world"

─────────────────────────────────────
CHAINING HOFs:
─────────────────────────────────────
  const result = users
      .filter(u => u.age >= 18)
      .map(u => u.name.toUpperCase())
      .sort()
      .join(", ");

  Each method returns a new array — chain as long as needed.

💻 CODE:
// ─── map ──────────────────────────────────────────────
console.log("=== map ===");

const products = [
    { name: "Laptop",  price: 999, category: "Electronics" },
    { name: "T-Shirt", price: 29,  category: "Clothing" },
    { name: "Phone",   price: 699, category: "Electronics" },
    { name: "Jeans",   price: 79,  category: "Clothing" },
    { name: "Tablet",  price: 499, category: "Electronics" },
];

const names    = products.map(p => p.name);
const prices   = products.map(p => p.price);
const withTax  = products.map(p => ({
    ...p,
    priceWithTax: +(p.price * 1.08).toFixed(2)
}));

console.log("  Names:", names);
console.log("  Prices:", prices);
console.log("  With tax:", withTax.map(p => \`${
p.name}: \$${
p.priceWithTax}\`));

// ─── filter ───────────────────────────────────────────
console.log("\\n=== filter ===");

const electronics    = products.filter(p => p.category === "Electronics");
const affordable     = products.filter(p => p.price < 100);
const uniqueNames    = ["apple", "banana", "", null, "cherry", undefined]
    .filter(Boolean);

console.log("  Electronics:", electronics.map(p => p.name));
console.log("  Affordable:", affordable.map(p => p.name));
console.log("  Non-falsy:", uniqueNames);

// ─── reduce ───────────────────────────────────────────
console.log("\\n=== reduce ===");

const totalValue = products.reduce((sum, p) => sum + p.price, 0);
const maxPrice   = products.reduce((max, p) => p.price > max ? p.price : max, 0);
const byCategory = products.reduce((acc, p) => {
    if (!acc[p.category]) acc[p.category] = [];
    acc[p.category].push(p.name);
    return acc;
}, {});

console.log("  Total value: \$" + totalValue);
console.log("  Max price: \$" + maxPrice);
console.log("  By category:", JSON.stringify(byCategory));

// Reduce to build frequency map:
const words = ["apple", "banana", "apple", "cherry", "banana", "apple"];
const freq  = words.reduce((acc, w) => ({ ...acc, [w]: (acc[w] || 0) + 1 }), {});
console.log("  Word freq:", freq);

// ─── CHAINING ─────────────────────────────────────────
console.log("\\n=== Chaining HOFs ===");

const report = products
    .filter(p => p.price >= 100)
    .map(p => ({ ...p, discount: +(p.price * 0.1).toFixed(2) }))
    .sort((a, b) => b.price - a.price)
    .map(p => \`${
p.name}: \$${
p.price} (save \$${
p.discount})\`);

report.forEach(line => console.log("  " + line));

// ─── some / every / find ──────────────────────────────
console.log("\\n=== some / every / find ===");

const hasExpensive   = products.some(p => p.price > 900);
const allPositive    = products.every(p => p.price > 0);
const firstCheap     = products.find(p => p.price < 50);
const cheapIdx       = products.findIndex(p => p.price < 50);

console.log("  Has item > \$900:", hasExpensive);
console.log("  All prices > 0:", allPositive);
console.log("  First cheap:", firstCheap?.name);
console.log("  First cheap idx:", cheapIdx);

// ─── FUNCTION FACTORIES ───────────────────────────────
console.log("\\n=== Function Factories ===");

const makeMultiplier  = factor => n => n * factor;
const makeAdder       = x => y => x + y;
const makeGreeter     = greeting => name => \`${
greeting}, ${
name}!\`;
const makeValidator   = (min, max) => n => n >= min && n <= max;

const double    = makeMultiplier(2);
const triple    = makeMultiplier(3);
const add100    = makeAdder(100);
const greetHi   = makeGreeter("Hi");
const isPercent = makeValidator(0, 100);

console.log("  double(7):", double(7));
console.log("  triple(7):", triple(7));
console.log("  add100(42):", add100(42));
console.log("  greetHi('Terry'):", greetHi("Terry"));
console.log("  isPercent(75):", isPercent(75));
console.log("  isPercent(150):", isPercent(150));

// Apply multiple transforms with map:
const nums = [1, 2, 3, 4, 5];
const transforms = [double, triple, add100];
transforms.forEach(fn => {
    console.log(\`  ${
fn.name || 'fn'}([1..5]): ${
nums.map(fn)}\`);
});

// ─── COMPOSE / PIPE ───────────────────────────────────
console.log("\\n=== Compose / Pipe ===");

const pipe    = (...fns) => x => fns.reduce((v, f) => f(v), x);
const compose = (...fns) => x => fns.reduceRight((v, f) => f(v), x);

const slugify = pipe(
    s => s.trim(),
    s => s.toLowerCase(),
    s => s.replace(/[^a-z0-9\\s-]/g, ''),
    s => s.replace(/\\s+/g, '-')
);

const titles = ["  Hello World!  ", "  JavaScript 101  ", "  ES6+ Features  "];
titles.forEach(t => console.log(\`  "${
t}" → "${
slugify(t)}"\`));

// ─── flatMap ──────────────────────────────────────────
console.log("\\n=== flatMap ===");

const sentences = ["hello world", "foo bar baz", "one two"];
const allWords = sentences.flatMap(s => s.split(" "));
console.log("  All words:", allWords);

const nested = [[1, 2], [3, 4], [5, 6]];
const doubled = nested.flatMap(arr => arr.map(n => n * 2));
console.log("  Doubled flat:", doubled);

📝 KEY POINTS:
✅ map: transforms each element and returns a NEW array of the same length
✅ filter: keeps elements passing the test and returns a NEW (shorter) array
✅ reduce: folds all elements into ONE value using an accumulator
✅ forEach: side effects only — returns undefined, not chainable
✅ some/every: short-circuit — stop as soon as the result is determined
✅ find/findIndex: return the first matching element or index
✅ flatMap: map then flatten one level — great for splitting strings into tokens
✅ Chain HOFs: filter().map().sort() each returns a new array, enabling fluent pipelines
✅ Function factories: functions that return other functions — partial application
❌ map/filter/reduce never mutate the original array — they always return new ones
❌ reduce without an initial value uses the first element — can cause bugs on empty arrays
❌ forEach returns undefined — don't try to chain it
❌ sort() without a comparator converts to strings — [10, 9, 2].sort() → [10, 2, 9]!
""",
  quiz: [
    Quiz(question: 'What does Array.map() return?', options: [
      QuizOption(text: 'A new array of the same length with each element transformed by the callback', correct: true),
      QuizOption(text: 'The original array mutated with each element replaced', correct: false),
      QuizOption(text: 'A single accumulated value from all elements', correct: false),
      QuizOption(text: 'A new array containing only elements where the callback returned true', correct: false),
    ]),
    Quiz(question: 'What is a "higher-order function"?', options: [
      QuizOption(text: 'A function that takes other functions as arguments and/or returns a function', correct: true),
      QuizOption(text: 'A function that runs at a higher priority in the event loop', correct: false),
      QuizOption(text: 'A function defined at the top level of a module (not nested)', correct: false),
      QuizOption(text: 'An async function that returns a Promise', correct: false),
    ]),
    Quiz(question: 'What is the correct reduce call to sum [1,2,3,4,5]?', options: [
      QuizOption(text: '[1,2,3,4,5].reduce((acc, n) => acc + n, 0) — using 0 as the initial accumulator', correct: true),
      QuizOption(text: '[1,2,3,4,5].reduce((n) => n + 1) — no initial value needed', correct: false),
      QuizOption(text: '[1,2,3,4,5].reduce(sum) — sum is a built-in operator', correct: false),
      QuizOption(text: '[1,2,3,4,5].reduce((acc, n) => acc + n) — no initial value always works', correct: false),
    ]),
  ],
);
