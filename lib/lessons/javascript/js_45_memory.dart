import '../../models/lesson.dart';
import '../../models/quiz.dart';

final jsLesson45 = Lesson(
  language: 'JavaScript',
  title: 'Resource Management and Memory',
  content: """
🎯 METAPHOR:
Memory management in JavaScript is like renting hotel
rooms. The garbage collector is the hotel manager
who checks every night whether any rooms are still
"in use" — referenced by a guest who might return.
If no one can reach a room anymore (no references), it
gets cleaned and made available again. Memory leaks
happen when the manager thinks a room is still occupied
but the "guest" will never return — a forgotten event
listener holding onto a DOM node that's been removed,
like a keycard still registered to a checked-out guest.
The "using" declaration (ES2025) is like a hotel stay
with a guaranteed check-out: when the stay ends, the
room is automatically freed, no matter what.

📖 EXPLANATION:
JavaScript uses automatic garbage collection, but memory
leaks are still possible. The new "using" declaration
(Explicit Resource Management, Stage 4) adds deterministic
cleanup.

─────────────────────────────────────
HOW GARBAGE COLLECTION WORKS:
─────────────────────────────────────
  JavaScript uses mark-and-sweep:
  1. Mark: starting from roots (globals, call stack),
     traverse all reachable objects and mark them
  2. Sweep: collect all unmarked (unreachable) objects

  An object is collected when:
  → No variables reference it
  → No closures capture it
  → No event listeners hold it
  → No data structures contain it

─────────────────────────────────────
COMMON MEMORY LEAKS:
─────────────────────────────────────
  1. FORGOTTEN EVENT LISTENERS:
  // ❌ Handler holds closure over 'data':
  const data = new Array(1000000).fill('x');
  window.addEventListener('resize', () => {
      console.log(data.length);   // data can't be GC'd!
  });
  // window lives forever → handler lives forever → data lives forever

  // ✅ Remove when done:
  const handler = () => console.log(data.length);
  window.addEventListener('resize', handler);
  // Later: window.removeEventListener('resize', handler);

  2. TIMERS NOT CLEARED:
  // ❌ interval holds reference:
  const timer = setInterval(() => {
      heavyData.process();
  }, 1000);
  // Must call clearInterval(timer) when done!

  3. CLOSURES OVER LARGE DATA:
  // ❌ Closure holds large array unnecessarily:
  function setup() {
      const megabytes = new Array(1000000).fill(0);
      return function() {
          return megabytes.length;  // megabytes held forever
      };
  }

  // ✅ Only capture what you need:
  function setup() {
      const len = new Array(1000000).fill(0).length;
      return function() { return len; };  // only len, not array
  }

  4. DETACHED DOM NODES:
  // ❌ Removed from DOM but still referenced:
  const nodes = [];
  const div = document.createElement('div');
  nodes.push(div);
  document.body.appendChild(div);
  document.body.removeChild(div);
  // div is gone from DOM but 'nodes' array holds it!

  // ✅ Clear reference:
  nodes.pop();  // or nodes.length = 0;

  5. GROWING CACHES WITHOUT EVICTION:
  // ❌ Cache grows forever:
  const cache = {};
  function getUser(id) {
      if (!cache[id]) cache[id] = fetchUser(id);
      return cache[id];
  }
  // cache[id] holds all users ever fetched, forever!

  // ✅ Use WeakMap or implement LRU eviction:
  const cache = new WeakMap();  // values GC'd when keys are

─────────────────────────────────────
WeakRef — weak reference to an object:
─────────────────────────────────────
  const ref = new WeakRef(targetObject);

  // Dereference (may be null if GC'd):
  const obj = ref.deref();
  if (obj) {
      obj.doSomething();
  } else {
      console.log("Object was garbage collected");
  }

─────────────────────────────────────
FinalizationRegistry — cleanup callbacks:
─────────────────────────────────────
  const registry = new FinalizationRegistry((key) => {
      console.log(\`\${key} was garbage collected\`);
      cache.delete(key);
  });

  function trackObject(obj, key) {
      registry.register(obj, key);
  }

─────────────────────────────────────
EXPLICIT RESOURCE MANAGEMENT — "using":
─────────────────────────────────────
  ES2025 (Stage 4) adds 'using' for deterministic cleanup.
  Objects with [Symbol.dispose]() are cleaned up automatically.

  // Sync disposal:
  {
      using resource = acquireResource();
      resource.doWork();
  }   // resource[Symbol.dispose]() called automatically here!

  // Async disposal:
  {
      await using conn = await getConnection();
      await conn.query(...);
  }   // conn[Symbol.asyncDispose]() called here

  // Implement disposal:
  class DatabaseConnection {
      [Symbol.dispose]() {
          this.close();
          console.log("Connection closed automatically");
      }
  }

  // DisposableStack — manage multiple resources:
  using stack = new DisposableStack();
  const conn1 = stack.use(await getConnection());
  const conn2 = stack.use(await getConnection());
  // Both closed when stack goes out of scope

─────────────────────────────────────
MEASURING MEMORY:
─────────────────────────────────────
  // Browser:
  performance.memory.usedJSHeapSize   // in bytes
  performance.memory.totalJSHeapSize

  // Node.js:
  process.memoryUsage()
  // { rss, heapTotal, heapUsed, external, arrayBuffers }

  // Chrome DevTools:
  // Memory tab → Heap Snapshot → compare snapshots
  // Look for: detached DOM trees, growing collections

─────────────────────────────────────
PERFORMANCE.MEASURE AND MARKS:
─────────────────────────────────────
  performance.mark('start-parse');
  parseData(largeDataset);
  performance.mark('end-parse');
  performance.measure('parse-time', 'start-parse', 'end-parse');

  const measures = performance.getEntriesByName('parse-time');
  console.log(measures[0].duration);  // milliseconds

💻 CODE:
// ─── MEMORY LEAK DEMONSTRATIONS ───────────────────────
console.log("=== Memory Leak Patterns ===");

// 1. Growing cache without eviction:
class LeakyCache {
    #data = {};
    set(key, value) { this.#data[key] = value; }
    get(key)        { return this.#data[key]; }
    get size()      { return Object.keys(this.#data).length; }
}

class LRUCache {
    #capacity;
    #cache = new Map();

    constructor(capacity) { this.#capacity = capacity; }

    get(key) {
        if (!this.#cache.has(key)) return undefined;
        const value = this.#cache.get(key);
        this.#cache.delete(key);
        this.#cache.set(key, value);   // move to end (most recent)
        return value;
    }

    set(key, value) {
        if (this.#cache.has(key)) this.#cache.delete(key);
        if (this.#cache.size >= this.#capacity) {
            this.#cache.delete(this.#cache.keys().next().value);  // evict oldest
        }
        this.#cache.set(key, value);
    }

    get size() { return this.#cache.size; }
}

const leaky = new LeakyCache();
const lru   = new LRUCache(3);  // max 3 entries

for (let i = 0; i < 10; i++) {
    leaky.set(\`user:\${i}\`, { id: i, data: 'x'.repeat(100) });
    lru.set(\`user:\${i}\`,   { id: i, data: 'x'.repeat(100) });
}
console.log("  Leaky cache size:", leaky.size);  // 10 — all retained
console.log("  LRU cache size:  ", lru.size);    // 3 — bounded

// Access an LRU entry (moves it to most recent):
lru.get('user:9');
lru.set('user:10', { id: 10 });
console.log("  LRU after access+insert:", lru.size);  // still 3

// 2. WeakRef for optional caching:
console.log("\n=== WeakRef Cache ===");

class WeakCache {
    #refs = new Map();

    set(key, value) {
        this.#refs.set(key, new WeakRef(value));
    }

    get(key) {
        const ref = this.#refs.get(key);
        if (!ref) return null;
        const value = ref.deref();
        if (!value) {
            this.#refs.delete(key);  // clean up stale ref
            return null;
        }
        return value;
    }

    get size() { return this.#refs.size; }
}

const weakCache = new WeakCache();
let obj1 = { id: 1, data: 'important' };
let obj2 = { id: 2, data: 'also important' };

weakCache.set('key1', obj1);
weakCache.set('key2', obj2);

console.log("  Before GC hint:", weakCache.get('key1')?.id);  // 1
console.log("  Cache size:", weakCache.size);  // 2

// Simulate obj1 going out of scope (GC timing is non-deterministic):
// obj1 = null;
// After a GC cycle, weakCache.get('key1') would return null

// 3. FinalizationRegistry:
console.log("\n=== FinalizationRegistry ===");

const cleanupLog = [];
const registry = new FinalizationRegistry((info) => {
    cleanupLog.push(\`Cleaned up: \${info}\`);
});

function createTracked(id) {
    const obj = { id, data: \`resource-\${id}\` };
    registry.register(obj, \`resource-\${id}\`);
    return obj;
}

let tracked1 = createTracked(1);
let tracked2 = createTracked(2);
console.log("  Created tracked objects:", tracked1.id, tracked2.id);
console.log("  (FinalizationRegistry callbacks run when objects are GC'd)");
console.log("  (GC timing is non-deterministic — may not fire immediately)");

// 4. Explicit Resource Management (Symbol.dispose):
console.log("\n=== Symbol.dispose (Explicit Resource Management) ===");

class ManagedConnection {
    #id;
    #open = false;

    constructor(id) {
        this.#id = id;
        this.#open = true;
        console.log(\`  [Conn \${id}] Opened\`);
    }

    query(sql) {
        if (!this.#open) throw new Error("Connection closed");
        console.log(\`  [Conn \${this.#id}] Query: \${sql}\`);
        return [{ id: 1 }, { id: 2 }];
    }

    [Symbol.dispose]() {
        if (this.#open) {
            this.#open = false;
            console.log(\`  [Conn \${this.#id}] Closed (via Symbol.dispose)\`);
        }
    }
}

// Polyfill for 'using' (actual syntax when engines support it):
function withResource(resource, fn) {
    try {
        return fn(resource);
    } finally {
        resource[Symbol.dispose]?.();
    }
}

withResource(new ManagedConnection(1), (conn) => {
    const results = conn.query("SELECT * FROM users");
    console.log(\`  Got \${results.length} results\`);
});
console.log("  Connection automatically closed after block");

// Multiple resources with DisposableStack pattern:
console.log("\n=== Resource Stack Pattern ===");

class ResourceStack {
    #resources = [];

    use(resource) {
        this.#resources.push(resource);
        return resource;
    }

    [Symbol.dispose]() {
        const errors = [];
        while (this.#resources.length > 0) {
            const resource = this.#resources.pop();
            try { resource[Symbol.dispose]?.(); }
            catch (e) { errors.push(e); }
        }
        if (errors.length > 0) throw new AggregateError(errors, "Errors during cleanup");
    }
}

withResource(new ResourceStack(), (stack) => {
    const conn1 = stack.use(new ManagedConnection(2));
    const conn2 = stack.use(new ManagedConnection(3));
    conn1.query("BEGIN TRANSACTION");
    conn2.query("SELECT * FROM products");
    conn1.query("COMMIT");
    // Both connections closed when stack is disposed
});

// 5. Performance measurement:
console.log("\n=== Performance Measurement ===");

function benchmarkOperation(name, fn, iterations = 10000) {
    const start = performance.now();
    for (let i = 0; i < iterations; i++) fn(i);
    const elapsed = performance.now() - start;
    console.log(\`  \${name.padEnd(30)}: \${elapsed.toFixed(2)}ms (\${(elapsed/iterations*1000).toFixed(2)}μs/op)\`);
}

benchmarkOperation('Object property access', (i) => ({ x: i }).x);
benchmarkOperation('Array push + pop',        (i) => { const a = []; a.push(i); a.pop(); });
benchmarkOperation('Map set + get',           (i) => { const m = new Map(); m.set('k', i); m.get('k'); });
benchmarkOperation('String concat',           (i) => 'hello' + i);
benchmarkOperation('Template literal',        (i) => \`hello \${i}\`);

📝 KEY POINTS:
✅ Garbage collection is automatic but memory leaks are still possible in JavaScript
✅ Common leaks: forgotten event listeners, uncleaned timers, closures over large data
✅ WeakMap/WeakSet allow GC to collect objects even when the map holds them
✅ WeakRef holds a reference without preventing GC — check deref() for null before use
✅ FinalizationRegistry runs callbacks after an object is garbage collected
✅ Symbol.dispose implements deterministic cleanup (like try-finally but automatic)
✅ LRU cache bounds memory growth — essential for caches that could grow unbounded
✅ Use Chrome DevTools Memory tab → Heap Snapshots to find and compare memory usage
✅ performance.mark/measure provides precise timing for performance analysis
❌ Never rely on GC timing — it's non-deterministic, don't use for cleanup logic
❌ Event listeners added to long-lived objects (window, document) must be explicitly removed
❌ Closures capture the ENTIRE scope — only capture what you need
❌ Don't cache everything indefinitely — implement eviction policies
""",
  quiz: [
    Quiz(question: 'What is a memory leak in JavaScript?', options: [
      QuizOption(text: 'An object that remains reachable (referenced) but is no longer needed — the GC cannot collect it', correct: true),
      QuizOption(text: 'When JavaScript allocates more memory than the system has available', correct: false),
      QuizOption(text: 'A bug where memory is freed before the program is done using it', correct: false),
      QuizOption(text: 'When two objects reference each other, preventing either from being collected', correct: false),
    ]),
    Quiz(question: 'What makes WeakMap different from regular Map for preventing memory leaks?', options: [
      QuizOption(text: 'WeakMap keys are weakly held — when the key object has no other references, the entry is automatically garbage collected', correct: true),
      QuizOption(text: 'WeakMap automatically removes the oldest entry when it reaches a size limit', correct: false),
      QuizOption(text: 'WeakMap entries expire after a configurable time-to-live', correct: false),
      QuizOption(text: 'WeakMap uses compressed storage, using less memory than regular Map', correct: false),
    ]),
    Quiz(question: 'What does Symbol.dispose enable in ES2025?', options: [
      QuizOption(text: 'Automatic cleanup of resources when they go out of scope using the "using" declaration', correct: true),
      QuizOption(text: 'Manual garbage collection triggers for specific objects', correct: false),
      QuizOption(text: 'A way to mark objects as permanently immutable', correct: false),
      QuizOption(text: 'Automatic reference counting similar to C++ smart pointers', correct: false),
    ]),
  ],
);
