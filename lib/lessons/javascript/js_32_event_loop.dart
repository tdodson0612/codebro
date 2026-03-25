import '../../models/lesson.dart';
import '../../models/quiz.dart';

final jsLesson32 = Lesson(
  language: 'JavaScript',
  title: 'Event Loop, Call Stack, and Async Execution',
  content: """
🎯 METAPHOR:
The JavaScript event loop is like a single-person restaurant.
There's ONE chef (single-threaded JS engine). The kitchen
has a CALL STACK — the chef's current work: right now they're
chopping vegetables, standing on a stove ignition, waiting
for someone to get back to them. The restaurant has a
WAITING AREA (task queue) where orders line up. The chef
finishes their ENTIRE current dish (clears the call stack)
before picking up the next order from the waiting area.
Microtasks (Promise callbacks) are like urgent interruptions
from the sous chef — "the sauce is ready NOW" — which
happen between every dish, before any new order from the
waiting area. This is why Promise.then() runs before
setTimeout(..., 0) even though both are "scheduled."

📖 EXPLANATION:
Understanding the event loop is essential for writing
correct async JavaScript and debugging timing issues.

─────────────────────────────────────
THE COMPONENTS:
─────────────────────────────────────
  CALL STACK:
  → LIFO stack of currently executing functions
  → When a function is called, pushed to stack
  → When it returns, popped from stack
  → "Stack overflow" = too many nested calls

  HEAP:
  → Unstructured memory region
  → Objects and closures are stored here

  CALLBACK QUEUE (Task Queue / Macrotask Queue):
  → setTimeout, setInterval callbacks
  → DOM events (click, keydown, etc.)
  → I/O callbacks (Node.js fs.readFile etc.)
  → UI rendering (browser)

  MICROTASK QUEUE:
  → Promise .then()/.catch()/.finally() callbacks
  → queueMicrotask()
  → MutationObserver callbacks
  → Processed COMPLETELY before next macrotask

  EVENT LOOP:
  → Checks: is call stack empty?
  → YES: drain ALL microtasks, then pick ONE macrotask
  → Repeat forever

─────────────────────────────────────
EXECUTION ORDER:
─────────────────────────────────────
  1. Synchronous code (call stack)
  2. Microtasks (ALL of them, in order)
  3. ONE macrotask (setTimeout/setInterval/etc.)
  4. Microtasks (ALL of them again)
  5. Next macrotask...
  (In browsers: rendering happens between macrotasks)

  console.log('1');                          // sync
  setTimeout(() => console.log('2'), 0);    // macrotask
  Promise.resolve().then(() => console.log('3')); // microtask
  console.log('4');                          // sync

  Output: 1, 4, 3, 2

─────────────────────────────────────
MACROTASKS:
─────────────────────────────────────
  setTimeout(fn, delay)      → after delay (minimum)
  setInterval(fn, interval)  → repeating
  setImmediate(fn)           → Node.js only (after I/O)
  requestAnimationFrame(fn)  → before next browser paint
  I/O callbacks              → file reads, network, etc.
  MessageChannel             → structured communication
  HTML parsing tasks

─────────────────────────────────────
MICROTASKS:
─────────────────────────────────────
  Promise.resolve().then(fn)
  Promise.reject().catch(fn)
  queueMicrotask(fn)
  await expression (after await resumes)
  MutationObserver callbacks
  IntersectionObserver callbacks (spec unclear)

─────────────────────────────────────
BLOCKING THE EVENT LOOP:
─────────────────────────────────────
  // ❌ This blocks EVERYTHING for 5 seconds:
  const start = Date.now();
  while (Date.now() - start < 5000) {}
  // No callbacks, no renders, no user interaction!

  // ✅ Break up long work:
  function processChunk(items, chunkSize = 100) {
      return new Promise(resolve => {
          let i = 0;
          function doChunk() {
              const end = Math.min(i + chunkSize, items.length);
              while (i < end) process(items[i++]);
              if (i < items.length) setTimeout(doChunk, 0);
              else resolve();
          }
          setTimeout(doChunk, 0);
      });
  }

─────────────────────────────────────
queueMicrotask() — schedule a microtask:
─────────────────────────────────────
  queueMicrotask(() => {
      console.log("This runs as a microtask");
  });
  // Same queue as Promise.then() — runs before setTimeout

─────────────────────────────────────
ASYNC/AWAIT AND THE EVENT LOOP:
─────────────────────────────────────
  async function example() {
      console.log('A');         // sync — in current microtask
      await Promise.resolve(); // pause, schedule continuation
      console.log('B');        // resumes as microtask
  }

  console.log('1');
  example();
  console.log('2');

  Output: 1, A, 2, B
  // await schedules resumption as a microtask after '2'

💻 CODE:
// ─── EXECUTION ORDER DEMONSTRATION ───────────────────
console.log("=== Execution Order ===");

// Predict the output BEFORE running:
console.log("1 - sync start");

setTimeout(() => console.log("2 - setTimeout 0ms"), 0);
setTimeout(() => console.log("3 - setTimeout 100ms"), 100);

Promise.resolve()
    .then(() => console.log("4 - Promise.then #1"))
    .then(() => console.log("5 - Promise.then #2"));

queueMicrotask(() => console.log("6 - queueMicrotask"));

Promise.resolve().then(() => {
    console.log("7 - Promise.then #3");
    queueMicrotask(() => console.log("8 - microtask from microtask"));
});

console.log("9 - sync end");

// Expected output: 1, 9, 4, 6, 7, 5, 8, 2, 3

// ─── MICROTASK DRAINING ───────────────────────────────
console.log("\n=== Microtask Queue Draining ===");

let microtaskCount = 0;

function spawnMicrotasks(n) {
    if (n <= 0) {
        console.log(\`  ✅ Spawned ${
microtaskCount} microtasks — all before next macrotask\`);
        return;
    }
    microtaskCount++;
    Promise.resolve().then(() => spawnMicrotasks(n - 1));
}

setTimeout(() => {
    console.log("  setTimeout (macrotask) ran");
}, 0);

spawnMicrotasks(5);   // 5 chained microtasks
console.log("  Synchronous code done — microtask queue will drain next");

// ─── BLOCKING vs NON-BLOCKING ─────────────────────────
console.log("\n=== Blocking vs Non-Blocking ===");

function simulateWork(ms) {
    const end = Date.now() + ms;
    while (Date.now() < end) {}  // BLOCKS the thread
}

function nonBlockingWork(items) {
    return new Promise(resolve => {
        const results = [];
        let i = 0;
        function chunk() {
            const start = Date.now();
            while (i < items.length && Date.now() - start < 5) {
                results.push(items[i++] * 2);  // process item
            }
            if (i < items.length) {
                setTimeout(chunk, 0);  // yield to event loop
            } else {
                resolve(results);
            }
        }
        setTimeout(chunk, 0);
    });
}

console.log("  Starting non-blocking work...");
const start = Date.now();
nonBlockingWork(Array.from({ length: 1000 }, (_, i) => i)).then(results => {
    console.log(\`  ✅ Processed ${
results.length} items in ${
Date.now() - start}ms\`);
    console.log(\`  First 5 results: ${
results.slice(0, 5)}\`);
});
console.log("  (other code can run while work processes in chunks)");

// ─── PROMISE EXECUTION ORDER ──────────────────────────
setTimeout(() => {
    console.log("\n=== Promise Chain Execution Order ===");

    async function step(name) {
        console.log(\`  → entering ${
name}\`);
        await new Promise(resolve => setTimeout(resolve, 10));
        console.log(\`  ← returning ${
name}\`);
        return name;
    }

    console.log("  Before async calls");
    const p1 = step("A");
    const p2 = step("B");
    console.log("  After async calls (sync part done)");

    Promise.all([p1, p2]).then(results => {
        console.log("  Both completed:", results);
    });
}, 200);

// ─── EVENT LOOP VISUALIZATION ─────────────────────────
setTimeout(() => {
    console.log("\n=== Event Loop Mental Model ===");
    console.log(\`
  ┌─────────────────────────────────────┐
  │            CALL STACK               │
  │  [main()] → [fn()] → [inner()]     │
  └──────────────────┬──────────────────┘
                     │ empty? check queues
  ┌──────────────────▼──────────────────┐
  │         MICROTASK QUEUE             │  ← drained COMPLETELY first
  │  Promise.then  queueMicrotask       │
  └──────────────────┬──────────────────┘
                     │ all microtasks done
  ┌──────────────────▼──────────────────┐
  │          MACROTASK QUEUE            │  ← pick ONE
  │  setTimeout  setInterval  I/O       │
  └──────────────────┬──────────────────┘
                     │ repeat
                     └──→ (check microtasks again)
    \`);

    console.log("  KEY RULES:");
    console.log("  1. Call stack must be EMPTY before any queue is checked");
    console.log("  2. Microtasks (Promise.then) ALL run before next macrotask");
    console.log("  3. setTimeout(..., 0) is NOT instant — it's next macrotask");
    console.log("  4. await x = run sync, then schedule .then(resume) as microtask");
    console.log("  5. Never block the event loop with synchronous loops!");
}, 400);

📝 KEY POINTS:
✅ JavaScript is single-threaded — the call stack processes one function at a time
✅ The event loop: wait for call stack to empty → drain microtasks → pick one macrotask → repeat
✅ Microtasks (Promise.then, queueMicrotask) ALL run before the next macrotask
✅ setTimeout(..., 0) is a macrotask — runs AFTER all pending microtasks
✅ await schedules the function's continuation as a microtask after the awaited Promise settles
✅ Never block the event loop with synchronous loops — use setTimeout chunking for heavy work
✅ queueMicrotask() adds to the same queue as Promise.then()
✅ In browsers, rendering happens between macrotasks — long tasks block UI updates
✅ Node.js has additional queues: process.nextTick (runs before other microtasks), setImmediate
❌ Don't assume setTimeout(fn, 0) runs immediately — it runs AFTER all microtasks
❌ Don't chain infinite microtasks — they'll starve macrotasks and the browser render
❌ Blocking loops (while, for) prevent event processing — async code can't run during them
❌ Don't confuse the event loop with true parallelism — JavaScript is still single-threaded
""",
  quiz: [
    Quiz(question: 'What is the order of execution for: synchronous code, Promise.then(), and setTimeout(..., 0)?', options: [
      QuizOption(text: 'Synchronous code first, then Promise.then() (microtask), then setTimeout callback (macrotask)', correct: true),
      QuizOption(text: 'All three run simultaneously in separate threads', correct: false),
      QuizOption(text: 'setTimeout first (schedules immediately), then sync code, then Promise.then()', correct: false),
      QuizOption(text: 'Promise.then() first (highest priority), then sync code, then setTimeout', correct: false),
    ]),
    Quiz(question: 'Why does Promise.then() run before setTimeout(..., 0) even though setTimeout is "0 milliseconds"?', options: [
      QuizOption(text: 'Promise callbacks are microtasks — ALL microtasks drain before the event loop picks the next macrotask (setTimeout)', correct: true),
      QuizOption(text: 'Promise callbacks have higher thread priority than setTimeout callbacks', correct: false),
      QuizOption(text: 'setTimeout always has at least a 4ms delay imposed by browsers', correct: false),
      QuizOption(text: 'Promise.then() executes synchronously — it doesn\'t actually schedule asynchronously', correct: false),
    ]),
    Quiz(question: 'What happens when you run a blocking loop (while(true){}) in JavaScript?', options: [
      QuizOption(text: 'It permanently blocks the call stack — no callbacks, events, or renders can run until the loop ends', correct: true),
      QuizOption(text: 'JavaScript automatically moves the loop to a background thread', correct: false),
      QuizOption(text: 'The event loop pauses the loop periodically to process pending tasks', correct: false),
      QuizOption(text: 'The browser kills the tab after 5 seconds of a blocking loop', correct: false),
    ]),
  ],
);
