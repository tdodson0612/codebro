import '../../models/lesson.dart';
import '../../models/quiz.dart';

final jsLesson08 = Lesson(
  language: 'JavaScript',
  title: 'Loops and Iteration',
  content: """
🎯 METAPHOR:
Loops are like factory conveyor belts. A for loop is the
classic belt with a fixed number of items — you know
exactly how many to process before you start.
while is the belt with a sensor — it keeps running as
long as more items appear, and stops when the sensor
says "empty." for...of is a modern smart conveyor that
automatically handles each item one at a time — you just
say "give me each item" and it does the rest. for...in
is the warehouse auditor who checks every LABEL on every
shelf, not the items themselves. break is the emergency
stop button; continue is the "skip this one" button.

📖 EXPLANATION:

─────────────────────────────────────
for LOOP — classic counter-based:
─────────────────────────────────────
  for (initialization; condition; update) {
    // body
  }

  for (let i = 0; i < 5; i++) {
    console.log(i); // 0, 1, 2, 3, 4
  }

  Components are optional:
  for (;;) { }  // infinite loop (must break internally)

─────────────────────────────────────
while LOOP — condition-based:
─────────────────────────────────────
  while (condition) {
    // runs while condition is truthy
  }

  // Check happens BEFORE the first iteration.
  // If condition is false initially → body never runs.

─────────────────────────────────────
do...while LOOP — runs at least once:
─────────────────────────────────────
  do {
    // runs at least once
  } while (condition);

  // Check happens AFTER the body.
  // Use when first iteration must always happen.

─────────────────────────────────────
for...of — iterate OVER values (ES6):
─────────────────────────────────────
  for (const item of iterable) { }

  Works with: arrays, strings, Maps, Sets, generators,
              any object with [Symbol.iterator]

  for (const num of [1, 2, 3]) { }
  for (const char of "hello") { }
  for (const [key, val] of map) { }
  for (const item of set) { }

  ✅ Clean, safe, works with all iterables.
  ✅ Can use const for each iteration variable.

─────────────────────────────────────
for...in — iterate over KEYS (use carefully):
─────────────────────────────────────
  for (const key in obj) {
    // key is each enumerable property name
  }

  ⚠️ Iterates prototype chain too — use hasOwnProperty()
     or Object.keys() for safety.
  ⚠️ Order not guaranteed for non-integer keys in old engines.
  ❌ Don't use for arrays — use for...of or forEach instead.

─────────────────────────────────────
BREAK AND CONTINUE:
─────────────────────────────────────
  break     → exit the loop immediately
  continue  → skip to next iteration
  break label / continue label → for nested loops

─────────────────────────────────────
ARRAY ITERATION METHODS (prefer these):
─────────────────────────────────────
  arr.forEach(fn)     → iterate, no return value
  arr.map(fn)         → transform into new array
  arr.filter(fn)      → keep matching items
  arr.reduce(fn, init)→ accumulate to single value
  arr.find(fn)        → first matching item
  arr.findIndex(fn)   → index of first match
  arr.some(fn)        → true if any match
  arr.every(fn)       → true if all match
  arr.flatMap(fn)     → map then flatten
  (These are covered deeply in the Arrays lesson)

─────────────────────────────────────
LOOPS WITH ASYNC/AWAIT:
─────────────────────────────────────
  // ✅ for...of works with await:
  for (const item of items) {
    await processItem(item); // sequential
  }

  // ✅ Parallel with Promise.all:
  await Promise.all(items.map(item => processItem(item)));

  // ❌ forEach does NOT work with await (doesn't wait):
  items.forEach(async (item) => {
    await processItem(item); // won't be awaited!
  });

─────────────────────────────────────
INFINITE LOOPS + SAFEGUARDS:
─────────────────────────────────────
  // Controlled infinite loop:
  while (true) {
    const data = await fetchNext();
    if (!data) break;
    process(data);
  }

  // Iteration limit guard:
  let iterations = 0;
  while (condition && iterations++ < 10_000) {
    // prevents runaway loops
  }

💻 CODE:
// ─── for LOOP ─────────────────────────────────────────
console.log("=== for loop ===");
for (let i = 1; i <= 5; i++) {
  process.stdout.write(i + " ");  // 1 2 3 4 5
}
console.log();

// Countdown
for (let i = 10; i > 0; i--) {
  if (i <= 3) process.stdout.write(i + "... ");
}
console.log("Go! 🚀");

// Nested for
console.log("Multiplication table (3×3):");
for (let i = 1; i <= 3; i++) {
  let row = "";
  for (let j = 1; j <= 3; j++) {
    row += \`\${i * j}\`.padStart(3);
  }
  console.log(row);
}

// ─── while LOOP ───────────────────────────────────────
console.log("\n=== while loop ===");
let n = 1;
while (n <= 1024) {
  process.stdout.write(n + " ");
  n *= 2;
}
console.log(); // Powers of 2

// Read until sentinel
const inputs = [5, 3, 8, 1, -1, 9];  // -1 is sentinel
let idx = 0, total = 0;
while (inputs[idx] !== -1) {
  total += inputs[idx++];
}
console.log("Sum until -1:", total); // 17

// ─── do...while ───────────────────────────────────────
console.log("\n=== do...while ===");
let attempts = 0;
let success = false;
do {
  attempts++;
  success = Math.random() > 0.5;
  console.log(\`Attempt \${attempts}: \${success ? "✅ Success!" : "❌ Failed"}\`);
 } while (!success && attempts < 5);

// ─── for...of ─────────────────────────────────────────
console.log("\n=== for...of ===");

// Arrays
const fruits = ["apple", "banana", "cherry"];
for (const fruit of fruits) {
  console.log("🍎", fruit);
}

// With index (entries):
for (const [i, fruit] of fruits.entries()) {
  console.log(\`\${i + 1}. \${fruit}\`);
}

// Strings
console.log("Characters in 'hello':");
for (const char of "hello") {
  process.stdout.write(char + " ");
}
console.log();

// Map
const map = new Map([["one", 1], ["two", 2], ["three", 3]]);
for (const [key, value] of map) {
  console.log(\`\${key} = \${value}\`);
}

// Set
const unique = new Set([1, 2, 3, 2, 1]);
for (const num of unique) {
  process.stdout.write(num + " ");  // 1 2 3
}
console.log();

// ─── for...in ─────────────────────────────────────────
console.log("\n=== for...in (objects) ===");
const person = { name: "Alice", age: 28, city: "London" };
for (const key in person) {
  console.log(\`\${key}: \${person[key]}\`);
}

// Safer: use Object.entries() instead
console.log("Using Object.entries():");
for (const [key, value] of Object.entries(person)) {
  console.log(\`\${key}: \${value}\`);
}

// ─── BREAK AND CONTINUE ───────────────────────────────
console.log("\n=== break and continue ===");
const numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

// continue — skip even numbers
console.log("Odd numbers:");
for (const num of numbers) {
  if (num % 2 === 0) continue;
  process.stdout.write(num + " ");
}
console.log();

// break — stop at first multiple of 7
console.log("Until first multiple of 7:");
for (const num of numbers) {
  if (num % 7 === 0) {
    console.log("Found multiple of 7:", num);
    break;
  }
  process.stdout.write(num + " ");
}
console.log();

// Labeled break for nested loops
console.log("Labeled break:");
outer: for (let i = 0; i < 4; i++) {
  for (let j = 0; j < 4; j++) {
    if (i + j === 5) {
      console.log(\`Breaking at i=\${i}, j=\${j}\`);
      break outer;  // exits both loops
    }
    process.stdout.write(\`(\${i},\${j}) \`);
  }
}
console.log();

// ─── PRACTICAL: find, sum, transform ─────────────────
console.log("\n=== Practical Loops ===");
const students = [
  { name: "Alice", grade: 95 },
  { name: "Bob",   grade: 72 },
j}) \`);
  }
}
console.log();

// ─── PRACTICAL: find, sum, transform ─────────────────
console.log("\n=== Practical Loops ===");
const students = [
  { name: "Alice", grade: 95 },
  { name: "Bob",   grade: 72 },
  { name: "Carol", grade: 88 },
  { name: "Dave",  grade: 61 },
];

// Sum (prefer reduce, but for is fine too)
let sum = 0;
for (const s of students) sum += s.grade;
console.log("Average:", (sum / students.length).toFixed(1));

// Find top student
let top = students[0];
for (const s of students) {
  if (s.grade > top.grade) top = s;
}
console.log("Top student:", top.name, top.grade);

// Filter passing students
const passing = [];
for (const s of students) {
  if (s.grade >= 70) passing.push(s.name);
}
console.log("Passing:", passing.join(", "));

📝 KEY POINTS:
✅ for...of is the modern loop for arrays and iterables — clean and safe
✅ for...in loops over KEYS (property names) — use Object.entries() for objects
✅ do...while always runs at least once — use when the first execution is unconditional
✅ for...of with await works correctly for sequential async iteration
✅ Use forEach/map/filter/reduce for most array operations — cleaner and more declarative
✅ Labeled break (break outer) exits nested loops — rarely needed but useful
✅ for (const [i, item] of arr.entries()) gives both index and value
✅ continue skips current iteration; break exits the entire loop
❌ Never use for...in on arrays — use for...of or index-based for
❌ forEach does NOT work with await — use for...of for async loops
❌ Forgetting to update the loop variable in while leads to infinite loops
""",
  quiz: [
    Quiz(
      question: 'Why should you use for...of instead of for...in when iterating over an array?',
      options: [
        QuizOption(text: 'for...in iterates over property names (including inherited ones); for...of iterates over the actual values', correct: true),
        QuizOption(text: 'for...of is faster than for...in for arrays', correct: false),
        QuizOption(text: 'for...in requires the array to be sorted first', correct: false),
        QuizOption(text: 'They are identical for arrays — the choice is purely stylistic', correct: false),
      ],
    ),
    Quiz(
      question: 'What is the key difference between while and do...while?',
      options: [
        QuizOption(text: 'do...while always runs the body at least once; while may never run if the condition is false from the start', correct: true),
        QuizOption(text: 'do...while is faster because it skips the initial condition check', correct: false),
        QuizOption(text: 'while can use break; do...while cannot', correct: false),
        QuizOption(text: 'They are identical — do...while is just older syntax', correct: false),
      ],
    ),
    Quiz(
      question: 'Why doesn\'t async/await work correctly inside forEach()?',
      options: [
        QuizOption(text: 'forEach ignores the promise returned by async callbacks — it does not wait for them to resolve', correct: true),
        QuizOption(text: 'forEach does not accept async functions as arguments', correct: false),
        QuizOption(text: 'forEach is synchronous and blocks the event loop when used with async', correct: false),
        QuizOption(text: 'await inside forEach causes a SyntaxError', correct: false),
      ],
    ),
  ],
);
