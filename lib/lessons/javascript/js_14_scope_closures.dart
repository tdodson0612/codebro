import '../../models/lesson.dart';
import '../../models/quiz.dart';

final jsLesson14 = Lesson(
  language: 'JavaScript',
  title: 'Scope and Closures',
  content: """
🎯 METAPHOR:
Scope is like a set of nested rooms in a house — each room
can see into rooms that contain it, but NOT into rooms
inside it. The bedroom can use things from the hallway
and the living room (outer scopes), but it cannot see into
the bathroom attached to the hallway (sibling scope), and
the hallway cannot peek into the bedroom (inner scope).

A closure is like a backpack that a function carries when
it leaves the room where it was born. The backpack contains
REFERENCES to all the variables that were in scope at the
time of creation — even after those rooms are long gone.
Open the backpack later, and the variables are still there,
still accessible, still mutable.

📖 EXPLANATION:

─────────────────────────────────────
TYPES OF SCOPE:
─────────────────────────────────────
  Global scope     → accessible everywhere
  Module scope     → inside an ES module (private)
  Function scope   → inside a function
  Block scope      → inside {} for let/const
  Lexical scope    → based on where code is WRITTEN

─────────────────────────────────────
SCOPE CHAIN:
─────────────────────────────────────
  When a variable is accessed, JavaScript looks:
  1. Current scope
  2. Outer (enclosing) scope
  3. Further outer scope
  4. Global scope
  → If not found anywhere: ReferenceError

─────────────────────────────────────
CLOSURES:
─────────────────────────────────────
  A closure is a function that REMEMBERS its lexical
  environment even after the enclosing function returns.

  function outer() {
    const x = 10;            // in outer's scope
    return function inner() {
      return x;              // inner closes over x
    };
  }
  const fn = outer();
  fn(); // → 10 (x is still accessible!)

  Key insight: closures hold REFERENCES, not copies.
  Changes to the variable are reflected.

─────────────────────────────────────
CLOSURE USE CASES:
─────────────────────────────────────
  1. Private state / data encapsulation
  2. Factory functions (create functions with configuration)
  3. Memoization (cache results)
  4. Partial application / currying
  5. Event handlers with captured state
  6. Module pattern (before ES modules)

─────────────────────────────────────
CLASSIC var LOOP BUG:
─────────────────────────────────────
  // ❌ Bug: all closures share the same 'i'
  for (var i = 0; i < 3; i++) {
    setTimeout(() => console.log(i), 0);
  }
  // Prints: 3 3 3 (not 0 1 2!)

  // ✅ Fix 1: use let (block-scoped, new binding per iteration)
  for (let i = 0; i < 3; i++) {
    setTimeout(() => console.log(i), 0);
  }
  // Prints: 0 1 2

  // ✅ Fix 2: IIFE to capture each value
  for (var i = 0; i < 3; i++) {
    ((capturedI) => setTimeout(() => console.log(capturedI), 0))(i);
  }

─────────────────────────────────────
CLOSURE VS GLOBAL STATE:
─────────────────────────────────────
  // ❌ Using global state:
  let count = 0;
  function increment() { count++; }  // modifies global

  // ✅ Using closure for private state:
  function createCounter() {
    let count = 0;             // private to the closure
    return {
      increment() { count++; },
      decrement() { count--; },
      getCount()  { return count; }
    };
  }
  const counter = createCounter();  // count is hidden

─────────────────────────────────────
STALE CLOSURES:
─────────────────────────────────────
  The captured variable is a REFERENCE, not a snapshot.
  If the outer variable changes, the closure sees the change.

  function badExample() {
    let x = 5;
    const getX = () => x;
    x = 99;           // changes x
    return getX;
  }
  badExample()(); // → 99 (not 5!)

  This is a feature, not a bug — but it can surprise you
  if you expect the value at creation time.

💻 CODE:
// ─── SCOPE CHAIN ──────────────────────────────────────
console.log("=== Scope Chain ===");
const globalVar = "I'm global";

function outer() {
  const outerVar = "I'm in outer";

  function middle() {
    const middleVar = "I'm in middle";

    function inner() {
      const innerVar = "I'm in inner";
      // Access all outer scopes:
      console.log(globalVar);   // ✅
      console.log(outerVar);    // ✅
      console.log(middleVar);   // ✅
      console.log(innerVar);    // ✅
    }
    inner();
    // console.log(innerVar); // ❌ ReferenceError
  }
  middle();
}
outer();

// ─── BASIC CLOSURE ────────────────────────────────────
console.log("\n=== Basic Closure ===");
function makeAdder(x) {
  return function(y) {
    return x + y;  // x is 'closed over'
  };
}
const add5  = makeAdder(5);
const add10 = makeAdder(10);
console.log(add5(3));   // 8  (x=5 is remembered)
console.log(add10(3));  // 13 (x=10 is remembered)
console.log(add5(100)); // 105

// ─── PRIVATE STATE ────────────────────────────────────
console.log("\n=== Private State via Closure ===");
function createCounter(initialValue = 0) {
  let count = initialValue;  // private!
  let history = [];

  return {
    increment(by = 1)  {
      count += by;
      history.push(\`+\${by} →\${count}\`);
      return count;
    },
    decrement(by = 1)  {
      count -= by;
      history.push(\`-\${
by} →\${
count}\`);
      return count;
    },
    reset()            {
      count = initialValue;
      history.push(\`reset →\${
count}\`);
    },
    getCount()         { return count; },
    getHistory()       { return [...history]; },
  };
}

const counter = createCounter(10);
counter.increment();
counter.increment(5);
counter.decrement(3);
counter.increment();
console.log("Count:", counter.getCount()); // 14
console.log("History:", counter.getHistory());

// ─── FACTORY FUNCTIONS ────────────────────────────────
console.log("\n=== Factory Functions ===");
function createUser(name, role) {
  const createdAt = new Date().toISOString();

  return {
    getName()       { return name; },
    getRole()       { return role; },
    getCreatedAt()  { return createdAt; },
    toString()      { return \`\${role}:\${name}@\${createdAt}\`; },
    hasPermission(perm) {
      const permissions = {
        admin: ["read", "write", "delete", "manage"],
        user:  ["read", "write"],
        guest: ["read"],
      };
      return (permissions[role] || []).includes(perm);
    }
  };
}

const admin = createUser("Alice", "admin");
const guest = createUser("Bob",   "guest");
console.log(admin.hasPermission("delete")); // true
console.log(guest.hasPermission("write"));  // false
console.log(admin.toString());

// ─── MEMOIZATION ──────────────────────────────────────
console.log("\n=== Memoization ===");
function memoize(fn) {
  const cache = new Map();
  return function(...args) {
    const key = JSON.stringify(args);
    if (cache.has(key)) {
      console.log("  Cache hit:", key);
      return cache.get(key);
    }
    const result = fn.apply(this, args);
    cache.set(key, result);
    return result;
  };
}

const expensiveSqrt = memoize((n) => {
  console.log("  Computing sqrt of", n);
  return Math.sqrt(n);
});

console.log(expensiveSqrt(144)); // computes
console.log(expensiveSqrt(144)); // cache hit
console.log(expensiveSqrt(256)); // computes
console.log(expensiveSqrt(144)); // cache hit

// ─── VAR LOOP BUG AND FIX ─────────────────────────────
console.log("\n=== var Loop Bug ===");
// The bug:
const bugFns = [];
for (var i = 0; i < 3; i++) {
  bugFns.push(() => i);  // all capture the SAME 'i'
}
console.log("Buggy:", bugFns.map(f => f())); // [3,3,3]

// Fix with let (new binding per iteration):
const fixedFns = [];
for (let j = 0; j < 3; j++) {
  fixedFns.push(() => j);  // each gets its own 'j'
}
console.log("Fixed:", fixedFns.map(f => f())); // [0,1,2]

// ─── CLOSURE IN CALLBACKS ─────────────────────────────
console.log("\n=== Closures in Callbacks ===");
function setupHandlers(items) {
  return items.map((item, index) => {
    return function handleClick() {
      // Closes over 'item' and 'index' from map
      return \`Clicked item\${
index}:\${
item}\`;
    };
  });
}

const handlers = setupHandlers(["Home", "About", "Contact"]);
console.log(handlers[0]()); // "Clicked item 0: Home"
console.log(handlers[2]()); // "Clicked item 2: Contact"

// ─── CURRYING ─────────────────────────────────────────
console.log("\n=== Currying via Closures ===");
const curry = fn => {
  const arity = fn.length;
  return function curried(...args) {
    if (args.length >= arity) return fn(...args);
    return (...moreArgs) => curried(...args, ...moreArgs);
  };
};

const curriedAdd = curry((a, b, c) => a + b + c);
console.log(curriedAdd(1)(2)(3));   // 6
console.log(curriedAdd(1, 2)(3));   // 6
console.log(curriedAdd(1)(2, 3));   // 6
console.log(curriedAdd(1, 2, 3));   // 6

📝 KEY POINTS:
✅ Closures are functions that remember the variables from their creation scope
✅ Inner functions access variables from all outer scopes (scope chain)
✅ Closures capture REFERENCES not values — changes to outer variables are seen
✅ Use closures to create private state that external code cannot directly modify
✅ Factory functions are the closure-based alternative to classes
✅ Memoization uses closures to cache function results
✅ let in for loops creates a new binding per iteration — fixes the classic var loop bug
✅ var in for loops creates ONE variable shared by all iterations — classic bug
❌ var in closures creates stale reference bugs — always use let/const
❌ Overusing closures in tight loops can cause memory issues (holding references)
❌ Closures don't make copies — the reference is live — mutation in outer scope is reflected
""",
  quiz: [
    Quiz(
      question: 'What is a closure in JavaScript?',
      options: [
        QuizOption(text: 'A function that remembers and has access to variables from its outer lexical scope, even after the outer function has returned', correct: true),
        QuizOption(text: 'A function that is immediately invoked when defined', correct: false),
        QuizOption(text: 'A function that encapsulates its arguments to prevent modification', correct: false),
        QuizOption(text: 'A function with no access to the global scope', correct: false),
      ],
    ),
    Quiz(
      question: 'Why does using var in a for loop closure print the wrong value?',
      options: [
        QuizOption(text: 'var is function-scoped — all iterations share ONE variable; when the callbacks run, the loop has finished and the variable holds the final value', correct: true),
        QuizOption(text: 'var is evaluated lazily, so its value is computed only when the callback runs', correct: false),
        QuizOption(text: 'var closures always capture the value 0 instead of the loop counter', correct: false),
        QuizOption(text: 'for loops do not support var — it causes undefined behavior', correct: false),
      ],
    ),
    Quiz(
      question: 'What does a closure capture — a copy of the value or a reference?',
      options: [
        QuizOption(text: 'A reference — if the outer variable changes after the closure is created, the closure sees the updated value', correct: true),
        QuizOption(text: 'A copy of the value at the moment the closure is created', correct: false),
        QuizOption(text: 'It depends on whether the variable is primitive or object', correct: false),
        QuizOption(text: 'A frozen (immutable) copy that cannot be changed', correct: false),
      ],
    ),
  ],
);
