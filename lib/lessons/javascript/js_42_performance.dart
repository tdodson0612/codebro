import '../../models/lesson.dart';
import '../../models/quiz.dart';

final jsLesson42 = Lesson(
  language: 'JavaScript',
  title: 'Performance and Best Practices',
  content: """
🎯 METAPHOR:
JavaScript performance is like cooking for a crowd.
The actual cooking (computation) takes time, but the
ORGANIZATION matters just as much. A great chef doesn't
chop one onion, then run to get another onion, then
chop it, then run for a third — they prep all the onions
at once (batch DOM operations). They don't leave all
the burners running when nothing's cooking (clean up
event listeners). They use the right tool for the job
— a food processor for chopping 50 onions, hand-chopping
for one (right algorithm for the scale). And they never
block the kitchen door while they're working (don't
block the main thread).

📖 EXPLANATION:
JavaScript performance encompasses: algorithmic choices,
DOM efficiency, memory management, and async patterns.

─────────────────────────────────────
AVOID BLOCKING THE MAIN THREAD:
─────────────────────────────────────
  ❌ Blocking:
  const start = Date.now();
  while (Date.now() - start < 2000) {}   // blocks 2 seconds!

  ✅ Non-blocking alternatives:
  → Web Workers for CPU-heavy computation
  → Chunking: process in setTimeout batches
  → Async/await for I/O operations
  → requestIdleCallback for low-priority work

─────────────────────────────────────
DOM PERFORMANCE:
─────────────────────────────────────
  // ❌ Forces multiple reflows:
  for (let i = 0; i < 1000; i++) {
      el.style.left = el.offsetLeft + 1 + 'px'; // read then write!
  }

  // ✅ Read once, batch writes:
  const positions = items.map(el => el.offsetLeft);  // read all
  items.forEach((el, i) => el.style.left = positions[i] + 'px'); // write all

  // ✅ Use DocumentFragment for multiple inserts:
  const frag = document.createDocumentFragment();
  items.forEach(item => frag.appendChild(createItem(item)));
  container.appendChild(frag);  // ONE reflow

  // ✅ Class changes instead of style changes:
  el.classList.add('active');    // vs el.style.color = 'red'

  // ✅ requestAnimationFrame for animations:
  function animate() {
      updatePositions();
      requestAnimationFrame(animate);
  }
  requestAnimationFrame(animate);

─────────────────────────────────────
MEMORY MANAGEMENT:
─────────────────────────────────────
  // ✅ Clean up event listeners:
  const handler = () => {};
  el.addEventListener('click', handler);
  // Later:
  el.removeEventListener('click', handler);

  // ✅ WeakMap/WeakSet for object-keyed metadata:
  const cache = new WeakMap();  // auto-cleaned when object GC'd

  // ✅ Avoid closures over large data unnecessarily:
  function processData(data) {
      const result = transform(data);
      return result;   // data is not held by a closure
  }

  // ❌ Memory leak — event listener never removed:
  class MyComponent {
      constructor() {
          window.addEventListener('resize', this.onResize.bind(this));
          // onResize holds 'this' — preventing GC of component!
      }
      // No cleanup!
  }

─────────────────────────────────────
ALGORITHMIC CHOICES:
─────────────────────────────────────
  // ❌ O(n²) lookup:
  const result = array1.filter(item =>
      array2.includes(item.id)   // O(n) per element = O(n²)
  );

  // ✅ O(n) with Set:
  const ids = new Set(array2.map(i => i.id));
  const result = array1.filter(item => ids.has(item.id));

  // ❌ Sort every time:
  function getTopN(arr, n) {
      return arr.sort((a, b) => b - a).slice(0, n);  // O(n log n)
  }

  // ✅ Partial sort / heap:
  function getTopN(arr, n) {
      // Min-heap of size n — O(n log n) but only keeps n items
      // For large arrays, use a priority queue
      return [...arr].sort((a, b) => b - a).slice(0, n);
  }

─────────────────────────────────────
BUNDLE SIZE AND LOADING:
─────────────────────────────────────
  // ✅ Code splitting — load on demand:
  const { heavy } = await import('./heavy.js');

  // ✅ Tree-shaking — import only what you need:
  import { debounce } from 'lodash-es';  // not: import _ from 'lodash'

  // ✅ Lazy load images:
  <img loading="lazy" src="image.jpg">

  // ✅ Preload critical resources:
  <link rel="preload" href="main.js" as="script">

─────────────────────────────────────
MEMOIZATION AND CACHING:
─────────────────────────────────────
  // Memoize expensive pure functions:
  const memo = fn => {
      const cache = new Map();
      return (...args) => {
          const key = JSON.stringify(args);
          if (cache.has(key)) return cache.get(key);
          const result = fn(...args);
          cache.set(key, result);
          return result;
      };
  };

  // debounce — delay until idle:
  const debounce = (fn, ms) => {
      let timer;
      return (...args) => {
          clearTimeout(timer);
          timer = setTimeout(() => fn(...args), ms);
      };
  };

  // throttle — limit call rate:
  const throttle = (fn, ms) => {
      let last = 0;
      return (...args) => {
          const now = Date.now();
          if (now - last >= ms) { last = now; return fn(...args); }
      };
  };

─────────────────────────────────────
JAVASCRIPT BEST PRACTICES:
─────────────────────────────────────
  ✅ const by default; let when reassignment needed; never var
  ✅ Use strict equality === instead of ==
  ✅ Optional chaining obj?.prop instead of obj && obj.prop
  ✅ Nullish coalescing ?? instead of || for defaults
  ✅ Destructuring for cleaner parameter handling
  ✅ Use Array methods (map/filter/reduce) over loops
  ✅ Handle Promise rejections — always
  ✅ Use TypeScript for large projects
  ✅ Lint with ESLint; format with Prettier
  ✅ Write tests before shipping
  ❌ Don't mutate function arguments
  ❌ Don't catch all errors silently
  ❌ Don't use eval() — security risk
  ❌ Don't leave console.log in production

💻 CODE:
// ─── DEBOUNCE AND THROTTLE ────────────────────────────
console.log("=== Debounce and Throttle ===");

function debounce(fn, ms) {
    let timer;
    return function(...args) {
        clearTimeout(timer);
        timer = setTimeout(() => fn.apply(this, args), ms);
    };
}

function throttle(fn, ms) {
    let last = 0;
    return function(...args) {
        const now = Date.now();
        if (now - last >= ms) {
            last = now;
            return fn.apply(this, args);
        }
    };
}

let searchCalls   = 0;
let scrollCalls   = 0;

const debouncedSearch = debounce((query) => {
    searchCalls++;
    console.log(\`  🔍 Search: "\${
query}" (call #\${
searchCalls})\`);
}, 200);

const throttledScroll = throttle((pos) => {
    scrollCalls++;
    console.log(\`  📜 Scroll position:\${
pos} (call #\${
scrollCalls})\`);
}, 100);

// Simulate rapid typing (5 keystrokes):
['h', 'he', 'hel', 'hell', 'hello'].forEach((q, i) => {
    setTimeout(() => debouncedSearch(q), i * 50);
});
// Only the last keystroke fires (after 200ms idle)

// Simulate rapid scrolling (10 events):
for (let i = 0; i < 10; i++) {
    setTimeout(() => throttledScroll(i * 100), i * 30);
}
// Only fires every 100ms

setTimeout(() => {
    console.log(\`  Debounced:\${
searchCalls} actual search calls (from 5 keystrokes)\`);
    console.log(\`  Throttled:\${
scrollCalls} scroll handler calls (from 10 events)\`);
}, 500);

// ─── MEMOIZATION ──────────────────────────────────────
console.log("\n=== Memoization Performance ===");

function memoize(fn) {
    const cache = new Map();
    return function(...args) {
        const key = JSON.stringify(args);
        if (cache.has(key)) return cache.get(key);
        const result = fn.apply(this, args);
        cache.set(key, result);
        return result;
    };
}

// Fibonacci without memoization (exponential):
function naiveFib(n) {
    if (n <= 1) return n;
    return naiveFib(n - 1) + naiveFib(n - 2);
}

// With memoization:
const fastFib = memoize(function(n) {
    if (n <= 1) return n;
    return fastFib(n - 1) + fastFib(n - 2);
});

let t1 = Date.now();
const r1 = naiveFib(35);
const naiveMs = Date.now() - t1;

let t2 = Date.now();
const r2 = fastFib(50);
const memoMs = Date.now() - t2;

console.log(\`  naiveFib(35):\${
r1} in\${
naiveMs}ms\`);
console.log(\`  memoFib(50): \${
r2} in\${
memoMs}ms\`);

// ─── ALGORITHMIC IMPROVEMENT ──────────────────────────
console.log("\n=== O(n²) vs O(n) ===");

const N = 10000;
const arr1 = Array.from({ length: N }, (_, i) => i);
const arr2 = Array.from({ length: N }, (_, i) => i * 2).slice(0, N / 2);

// O(n²) — includes check is O(n) inside a filter (O(n)):
let t3 = Date.now();
const slow = arr1.filter(x => arr2.includes(x));
const slowMs = Date.now() - t3;

// O(n) — Set has O(1) lookup:
let t4 = Date.now();
const set = new Set(arr2);
const fast = arr1.filter(x => set.has(x));
const fastMs = Date.now() - t4;

console.log(\`  Intersection of\${
N} elements:\`);
console.log(\`  O(n²) Array.includes:\${
slowMs}ms →\${
slow.length} results\`);
console.log(\`  O(n) Set.has:        \${
fastMs}ms →\${
fast.length} results\`);
console.log(\`  Speedup:\${
Math.round(slowMs / Math.max(fastMs, 1))}x\`);

// ─── BEST PRACTICES EXAMPLES ──────────────────────────
console.log("\n=== Best Practices ===");

// 1. const by default
const USER_LIMIT = 100;  // use const

// 2. Optional chaining
const user = { profile: { address: null } };
console.log("  Optional chaining:", user?.profile?.address?.city ?? "No city");

// 3. Nullish coalescing vs OR
const zero   = 0;
const empty  = '';
console.log("  ?? keeps 0:", zero ?? "default");      // 0 (correct)
console.log("  || loses 0:", zero || "default");       // "default" (wrong!)
console.log("  ?? keeps '':", empty ?? "default");     // "" (correct)

// 4. Destructuring
function processUser({ name, email, role = 'user', active = true } = {}) {
    console.log(\`  Processed:\${
name},\${
email},\${
role}, active=\${
active}\`);
}
processUser({ name: 'Alice', email: 'alice@example.com', role: 'admin' });
processUser({ name: 'Bob', email: 'bob@example.com' });

// 5. Avoid mutating arguments
function addItem(list, item) {
    return [...list, item];  // ✅ returns new array
    // NOT: list.push(item); return list;  ❌ mutates
}
const original = [1, 2, 3];
const extended = addItem(original, 4);
console.log("  Original unchanged:", original);  // [1,2,3]
console.log("  New array:", extended);            // [1,2,3,4]

// 6. Always handle promise rejections
async function safeLoad(url) {
    try {
        const res = await fetch(url).catch(() => null);
        if (!res) return null;
        return await res.json();
    } catch {
        return null;  // never let unhandled rejections crash the app
    }
}

// 7. Avoid magic numbers
const SECONDS_PER_DAY     = 86400;
const MAX_RETRY_ATTEMPTS  = 3;
const CACHE_TTL_MS        = 5 * 60 * 1000;  // 5 minutes

console.log("  Cache TTL:", CACHE_TTL_MS, "ms =", CACHE_TTL_MS / 60000, "min");

// ─── PERFORMANCE MEASUREMENT ──────────────────────────
console.log("\n=== Performance Measurement ===");

function benchmark(name, fn, iterations = 1000) {
    // Warm up:
    for (let i = 0; i < 100; i++) fn();

    // Measure:
    const start = performance.now();
    for (let i = 0; i < iterations; i++) fn();
    const elapsed = performance.now() - start;

    console.log(\` \${
name.padEnd(30)}:\${
(elapsed / iterations * 1000).toFixed(2)}μs/op\`);
}

const arr = Array.from({ length: 1000 }, (_, i) => i);

benchmark('for loop sum',          () => { let s=0; for(const n of arr) s+=n; });
benchmark('reduce sum',            () => arr.reduce((a,n) => a+n, 0));
benchmark('Array.from + map',      () => Array.from(arr, n => n*2));
benchmark('arr.map()',             () => arr.map(n => n*2));
benchmark('spread into new array', () => [...arr, ...arr]);

📝 KEY POINTS:
✅ debounce: delay execution until N ms after last call (search inputs, resize)
✅ throttle: limit execution to once per N ms (scroll, mouse move)
✅ memoize pure functions that are called repeatedly with the same args
✅ Use Set for O(1) lookups instead of Array.includes() O(n) for large datasets
✅ Batch DOM reads then writes — avoid interleaving (triggers layout thrashing)
✅ Use const by default — communicate immutability intent
✅ Use ?? (nullish coalescing) not || when 0/'' are valid values
✅ Never mutate function arguments — return new data structures
✅ Always handle Promise rejections — unhandled rejections crash Node.js
❌ Don't block the main thread — use Web Workers for CPU-heavy tasks
❌ Don't leave console.log() calls in production code
❌ Don't use eval() — it's a security vulnerability and disables optimizations
❌ Don't leak event listeners — always removeEventListener when component unmounts
""",
  quiz: [
    Quiz(question: 'What is the difference between debounce and throttle?', options: [
      QuizOption(text: 'Debounce waits until N ms after the last call; throttle limits to one call per N ms regardless of how often triggered', correct: true),
      QuizOption(text: 'Debounce limits call rate; throttle delays until the function is idle', correct: false),
      QuizOption(text: 'They are identical — throttle is just a more accurate word for debounce', correct: false),
      QuizOption(text: 'Debounce runs immediately; throttle waits before executing', correct: false),
    ]),
    Quiz(question: 'Why is ?? (nullish coalescing) safer than || for default values?', options: [
      QuizOption(text: '?? only falls back on null/undefined; || falls back on ANY falsy value including 0, "", and false', correct: true),
      QuizOption(text: '?? evaluates both sides; || short-circuits on the first truthy value', correct: false),
      QuizOption(text: '?? works with objects only; || works with primitives only', correct: false),
      QuizOption(text: 'They behave identically — ?? is just newer syntax for ||', correct: false),
    ]),
    Quiz(question: 'What causes "layout thrashing" in DOM manipulation?', options: [
      QuizOption(text: 'Interleaving DOM reads and writes — each read after a write forces the browser to recalculate layout', correct: true),
      QuizOption(text: 'Using too many CSS classes on a single element', correct: false),
      QuizOption(text: 'Calling addEventListener too many times on the same element', correct: false),
      QuizOption(text: 'Using innerHTML instead of textContent for large amounts of text', correct: false),
    ]),
  ],
);
