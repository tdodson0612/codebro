import '../../models/lesson.dart';
import '../../models/quiz.dart';

final jsLesson24 = Lesson(
  language: 'JavaScript',
  title: 'Map, Set, WeakMap, and WeakSet',
  content: """
🎯 METAPHOR:
Map is like a labeled key cabinet where keys can be ANY
shape — not just strings. A regular object is like a
cabinet where every key MUST be a string (or gets
converted to one). Map's cabinet accepts actual objects,
numbers, booleans, even other Maps as keys. Set is like
a bag where duplicates are impossible — try to put the
same item in twice, and the second one just doesn't
make it in. WeakMap is a cabinet with keys made of
glass — when the key object gets recycled (garbage
collected), the entry VANISHES automatically. Perfect
for metadata that should live exactly as long as its
associated object, no longer.

📖 EXPLANATION:

─────────────────────────────────────
Map — key-value pairs with any key type:
─────────────────────────────────────
  const map = new Map();
  map.set('key', 'value')    // string key
  map.set(42, 'number key')  // number key
  map.set({}, 'object key')  // object key!

  map.get(key)           → value or undefined
  map.has(key)           → boolean
  map.delete(key)        → boolean
  map.clear()            → removes all
  map.size               → number of entries

  // Iteration (in insertion order!):
  map.forEach((value, key) => ...)
  for (const [key, value] of map) { }
  [...map.entries()]   → [[k,v], [k,v], ...]
  [...map.keys()]      → [k, k, ...]
  [...map.values()]    → [v, v, ...]

  // Initialize from array:
  new Map([['a', 1], ['b', 2], ['c', 3]])

─────────────────────────────────────
Map vs Object — when to use which:
─────────────────────────────────────
  Use Map when:
  ✅ Keys aren't strings (objects, numbers, functions)
  ✅ Order of insertion matters and must be preserved
  ✅ Frequent add/delete operations (Map is faster)
  ✅ Need to know the size quickly (map.size is O(1))

  Use Object when:
  ✅ Working with JSON data
  ✅ Using dot/bracket notation feels right
  ✅ Keys are always strings/symbols
  ✅ Working with prototypes or class instances

─────────────────────────────────────
Set — unique values collection:
─────────────────────────────────────
  const set = new Set([1, 2, 3, 2, 1]);
  // set = {1, 2, 3}  — duplicates removed

  set.add(value)     → set (chainable)
  set.has(value)     → boolean — O(1) lookup!
  set.delete(value)  → boolean
  set.clear()        → removes all
  set.size           → number of unique values

  // Iteration (insertion order):
  for (const value of set) { }
  [...set]   → array of unique values

  // Deduplication:
  const unique = [...new Set([1, 2, 2, 3, 3, 3])]; // [1,2,3]

  // Set math:
  const union        = new Set([...a, ...b]);
  const intersection = new Set([...a].filter(x => b.has(x)));
  const difference   = new Set([...a].filter(x => !b.has(x)));

─────────────────────────────────────
WeakMap — garbage-collection-friendly Map:
─────────────────────────────────────
  const wm = new WeakMap();
  // Keys MUST be objects (not primitives)
  // Entries are automatically removed when key is GC'd

  wm.set(obj, metadata)
  wm.get(obj)
  wm.has(obj)
  wm.delete(obj)

  // NOT iterable — no .size, no .forEach, no .keys()
  // (by design — GC state is not observable)

  Use cases:
  ✅ Private class data (without polluting objects)
  ✅ DOM node metadata (auto-cleaned when node removed)
  ✅ Caches keyed by object (auto-cleared when key GC'd)

─────────────────────────────────────
WeakSet — garbage-collection-friendly Set:
─────────────────────────────────────
  const ws = new WeakSet();
  // Values MUST be objects
  // Automatically removes GC'd objects

  ws.add(obj)
  ws.has(obj)
  ws.delete(obj)

  Use cases:
  ✅ Mark objects as "visited" in a traversal
  ✅ Track which DOM elements have been initialized
  ✅ Private membership tracking

─────────────────────────────────────
WeakRef (ES2021) — weak reference:
─────────────────────────────────────
  const ref = new WeakRef(target);
  const obj = ref.deref();  // null if GC'd

  Use with FinalizationRegistry for cleanup callbacks:
  const registry = new FinalizationRegistry(key => {
      cache.delete(key);
      console.log(\`${
key} was garbage collected\`);
  });
  registry.register(obj, "myObject");

💻 CODE:
// ─── MAP ──────────────────────────────────────────────
console.log("=== Map ===");

const scores = new Map([
    ["Alice",   95],
    ["Bob",     82],
    ["Charlie", 91],
]);

// Any key type:
const keyMap = new Map();
const objKey = { id: 1 };
const fnKey  = () => {};
keyMap.set(42,     "number key");
keyMap.set(true,   "boolean key");
keyMap.set(objKey, "object key");
keyMap.set(fnKey,  "function key");

console.log("  number key:", keyMap.get(42));
console.log("  object key:", keyMap.get(objKey));
console.log("  Map size:  ", keyMap.size);

// Iteration in insertion order:
console.log("  Scores:");
for (const [name, score] of scores) {
    console.log(\`    ${
name}: ${
score}\`);
}

// Transforming a Map:
const grades = new Map(
    [...scores.entries()].map(([name, score]) => [
        name,
        score >= 90 ? 'A' : score >= 80 ? 'B' : 'C'
    ])
);
console.log("  Grades:", [...grades.entries()]);

// Convert Object ↔ Map:
const obj  = { x: 1, y: 2, z: 3 };
const map  = new Map(Object.entries(obj));
const back = Object.fromEntries(map.entries());
console.log("  Obj→Map→Obj:", back);

// Frequency counter with Map:
const words = ["apple", "banana", "apple", "cherry", "banana", "apple"];
const freq  = words.reduce((m, w) => m.set(w, (m.get(w) || 0) + 1), new Map());
const sorted = [...freq.entries()].sort((a, b) => b[1] - a[1]);
console.log("  Word freq:", sorted);

// ─── SET ──────────────────────────────────────────────
console.log("\\n=== Set ===");

// Deduplication:
const nums = [1, 2, 3, 2, 1, 4, 3, 5];
const unique = [...new Set(nums)];
console.log("  Dedup:", nums, "→", unique);

// Fast membership test O(1):
const validRoles = new Set(["admin", "user", "moderator"]);
["admin", "guest", "user"].forEach(role => {
    console.log(\`  '${
role}' is valid: ${
validRoles.has(role)}\`);
});

// Set math:
const teamA = new Set([1, 2, 3, 4, 5]);
const teamB = new Set([3, 4, 5, 6, 7]);

const union        = new Set([...teamA, ...teamB]);
const intersection = new Set([...teamA].filter(x => teamB.has(x)));
const diffAB       = new Set([...teamA].filter(x => !teamB.has(x)));  // A - B
const diffBA       = new Set([...teamB].filter(x => !teamA.has(x)));  // B - A
const symmetric    = new Set([...diffAB, ...diffBA]);                   // A △ B

console.log("  A:", [...teamA], "B:", [...teamB]);
console.log("  A ∪ B:", [...union]);
console.log("  A ∩ B:", [...intersection]);
console.log("  A − B:", [...diffAB]);
console.log("  A △ B:", [...symmetric]);

// Set of objects (by reference):
const set1 = new Set();
const a = { name: "Alice" };
const b = { name: "Alice" };  // different object
set1.add(a); set1.add(a); set1.add(b);
console.log("  Object set size:", set1.size);  // 2! a !== b

// ─── WEAKMAP — private class data ─────────────────────
console.log("\\n=== WeakMap (private data pattern) ===");

const _private = new WeakMap();

class BankAccount {
    constructor(owner, balance) {
        _private.set(this, { balance, transactions: [] });
        this.owner = owner;
    }

    deposit(amount) {
        if (amount <= 0) throw new RangeError("Positive amount required");
        const data = _private.get(this);
        data.balance += amount;
        data.transactions.push({ type: "deposit", amount, date: new Date().toISOString() });
        return this;
    }

    withdraw(amount) {
        const data = _private.get(this);
        if (amount > data.balance) throw new Error("Insufficient funds");
        data.balance -= amount;
        data.transactions.push({ type: "withdrawal", amount, date: new Date().toISOString() });
        return this;
    }

    get balance()      { return _private.get(this).balance; }
    get transactions() { return [..._private.get(this).transactions]; }

    toString() { return \`BankAccount(${
this.owner}: \$${
this.balance})\`; }
}

const acc = new BankAccount("Alice", 1000);
acc.deposit(500).withdraw(200);
console.log("  " + acc.toString());
console.log("  Transactions:", acc.transactions.length);
console.log("  Public keys:", Object.keys(acc));  // only "owner" — balance hidden!

// ─── WEAKSET — track visited ───────────────────────────
console.log("\\n=== WeakSet (object tracking) ===");

const visited = new WeakSet();

function processNode(node) {
    if (visited.has(node)) {
        console.log(\`  ⚠️  Already visited: ${
node.name}\`);
        return;
    }
    visited.add(node);
    console.log(\`  ✅ Processing: ${
node.name}\`);
}

const nodes = [
    { name: "A", next: null },
    { name: "B", next: null },
    { name: "A", next: null },  // different object, different reference
];

// Simulate visiting same object twice:
processNode(nodes[0]);
processNode(nodes[1]);
processNode(nodes[0]);  // same object again
processNode(nodes[2]);  // different object, not in WeakSet

// ─── MAP PERFORMANCE vs OBJECT ────────────────────────
console.log("\\n=== Map Performance Note ===");
console.log("  Map.size is O(1) — direct property");
console.log("  Object.keys(obj).length is O(n) — must count");

const largeMap = new Map();
for (let i = 0; i < 10000; i++) largeMap.set(\`key${
i}\`, i);
console.log("  Map with 10k entries, .size:", largeMap.size);

📝 KEY POINTS:
✅ Map can use ANY type as a key — objects, functions, numbers, booleans
✅ Map preserves insertion order and has O(1) get/set/has/delete
✅ map.size is a property — O(1); Object.keys(obj).length is O(n)
✅ Set stores UNIQUE values — perfect for deduplication and membership tests
✅ Set.has() is O(1) — much faster than Array.includes() for large collections
✅ WeakMap: keys must be objects; entries auto-removed when key is garbage collected
✅ WeakSet: values must be objects; auto-cleaned when object is GC'd
✅ Use WeakMap for private class data — hidden from enumeration, auto-cleaned
✅ Set math: union (spread both), intersection (filter), difference (filter + !has)
❌ WeakMap and WeakSet are NOT iterable — no forEach, no size, no keys()
❌ Map.set() returns the Map itself (chainable); Map.get() returns the value
❌ Set doesn't have deduplication by value for objects — { a: 1 } !== { a: 1 }
❌ Don't use regular objects as key-value stores when keys aren't strings
""",
  quiz: [
    Quiz(question: 'What is the key advantage of Map over a plain Object for key-value storage?', options: [
      QuizOption(text: 'Map accepts any type as a key — objects, functions, numbers; Object silently converts keys to strings', correct: true),
      QuizOption(text: 'Map is immutable while Object allows mutation', correct: false),
      QuizOption(text: 'Map entries are sorted alphabetically while Object entries are random', correct: false),
      QuizOption(text: 'Map supports inheritance through the prototype chain while Object does not', correct: false),
    ]),
    Quiz(question: 'Why is Set.has() faster than Array.includes() for large collections?', options: [
      QuizOption(text: 'Set uses a hash table — O(1) lookup; Array.includes() scans every element — O(n)', correct: true),
      QuizOption(text: 'Set uses binary search internally while Array is unsorted', correct: false),
      QuizOption(text: 'Set.has() is compiled to native code; Array.includes() is interpreted', correct: false),
      QuizOption(text: 'They have identical performance — Set.has() is just more readable', correct: false),
    ]),
    Quiz(question: 'What makes WeakMap useful for storing private class data?', options: [
      QuizOption(text: 'WeakMap entries are not enumerable and auto-removed when the key object is garbage collected — no memory leaks', correct: true),
      QuizOption(text: 'WeakMap encrypts stored values to prevent unauthorized access', correct: false),
      QuizOption(text: 'WeakMap prevents the stored values from being modified after insertion', correct: false),
      QuizOption(text: 'WeakMap keys are read-only so no code outside the class can overwrite the data', correct: false),
    ]),
  ],
);
