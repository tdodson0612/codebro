import '../../models/lesson.dart';
import '../../models/quiz.dart';

final jsLesson47 = Lesson(
  language: 'JavaScript',
  title: 'JavaScript Interview Preparation',
  content: """
🎯 METAPHOR:
A JavaScript interview is like a driving test for a
Formula 1 race. The examiner isn't just checking that
you know left from right — they want to see you handle
high-speed corners (closures), manage the gearbox
(the event loop), and explain WHY you brake before
the apex (explain code choices). Most candidates know
the basics; the ones who stand out know the QUIRKS —
why typeof null === "object", why [] + [] === "",
why 0.1 + 0.2 !== 0.3. These aren't trick questions —
they reveal whether you truly understand the language
or just memorized syntax.

📖 EXPLANATION:
The most commonly asked JavaScript interview questions
with thorough, accurate answers.

─────────────────────────────────────
CLOSURES:
─────────────────────────────────────
  Q: What is a closure?
  A: A function that retains access to its outer scope
     even after the outer function has returned.

  function makeCounter(start = 0) {
      let count = start;
      return {
          increment: () => ++count,
          decrement: () => --count,
          value:     () => count,
      };
  }
  const c = makeCounter(10);
  c.increment(); c.increment();
  c.value();   // 12 — 'count' lives in the closure

─────────────────────────────────────
HOISTING:
─────────────────────────────────────
  Q: What is hoisting?
  A: JavaScript moves declarations to the top of their
     scope before execution.

  console.log(x);        // undefined (not ReferenceError)
  var x = 5;             // var is hoisted, not initialized

  console.log(y);        // ReferenceError: temporal dead zone
  let y = 5;             // let/const hoisted but not initialized

  foo();                 // works! function declarations hoisted
  function foo() {}

  bar();                 // TypeError: bar is not a function
  var bar = () => {};    // arrow fn — var hoisted as undefined

─────────────────────────────────────
EVENT LOOP:
─────────────────────────────────────
  Q: What is the event loop?
  A: The mechanism that allows JavaScript (single-threaded)
     to perform non-blocking operations.
     It checks if the call stack is empty, then processes
     microtasks (Promise callbacks), then macrotasks
     (setTimeout, I/O).

  console.log(1);
  setTimeout(() => console.log(2), 0);
  Promise.resolve().then(() => console.log(3));
  console.log(4);
  // Output: 1, 4, 3, 2

─────────────────────────────────────
PROTOTYPE AND INHERITANCE:
─────────────────────────────────────
  Q: What is prototypal inheritance?
  A: Objects inherit from other objects via the prototype
     chain. When accessing a property, JS looks up the
     chain until found or reaching null.

  const animal = { sound() { return 'generic'; } };
  const dog = Object.create(animal);
  dog.sound = () => 'woof';
  const puppy = Object.create(dog);
  puppy.sound();   // 'woof' — found in dog
  delete dog.sound;
  puppy.sound();   // 'generic' — found in animal

─────────────────────────────────────
THIS BINDING:
─────────────────────────────────────
  Q: What does 'this' refer to?
  A: Depends on HOW the function is called:
  → Regular function: this = global (or undefined in strict)
  → Method: this = the object before the dot
  → Arrow function: this = enclosing scope (lexical)
  → call/apply/bind: this = explicitly set

  const obj = {
      name: 'Alice',
      regular: function() { return this.name; },  // 'Alice'
      arrow:   () => this.name,                   // undefined
  };

─────────────────────────────────────
COMMON TRICKY QUESTIONS:
─────────────────────────────────────
  typeof null              // "object" (historical bug)
  typeof undefined         // "undefined"
  typeof function(){}      // "function"
  typeof []                // "object" (use Array.isArray)
  null == undefined        // true (loose equality)
  null === undefined       // false (strict equality)
  0.1 + 0.2 === 0.3       // false (floating point)
  NaN === NaN              // false (use Number.isNaN)
  [] + []                  // "" (arrays coerced to strings)
  [] + {}                  // "[object Object]"
  {} + []                  // 0 (at statement level, {} = block)
  1 + "2"                  // "12" (coercion: number → string)
  +"3"                     // 3 (unary + converts to number)
  !!"hello"                // true (double negation = truthy)

─────────────────────────────────────
PROMISE vs async/await:
─────────────────────────────────────
  Q: When would you use Promises over async/await?
  A: Use Promise.all/race/any for concurrent operations.
     Use async/await for sequential async code that needs
     to read like synchronous code.

  // Concurrent — use Promise.all:
  const [a, b] = await Promise.all([fetchA(), fetchB()]);

  // Sequential — use async/await:
  const user = await fetchUser(id);
  const posts = await fetchPosts(user.id);

─────────────────────────────────────
VAR vs LET vs CONST:
─────────────────────────────────────
  var:   function-scoped, hoisted, can be redeclared
  let:   block-scoped, temporal dead zone, can reassign
  const: block-scoped, temporal dead zone, cannot reassign

  // var in loops — classic bug:
  for (var i = 0; i < 3; i++) {
      setTimeout(() => console.log(i), 0);
  }
  // Prints: 3, 3, 3 (not 0, 1, 2!)

  // let fixes it:
  for (let i = 0; i < 3; i++) {
      setTimeout(() => console.log(i), 0);
  }
  // Prints: 0, 1, 2 ✅

─────────────────────────────────────
COMMON CODING CHALLENGES:
─────────────────────────────────────
  Flatten array:
  [1,[2,[3,[4]]]].flat(Infinity)

  Unique values:
  [...new Set([1,2,2,3,3])]

  Deep clone:
  structuredClone(obj)

  Debounce/throttle (implemented from scratch)
  Curry a function
  Implement Array.map from scratch
  Find duplicate in array O(n)
  Two-sum problem
  Palindrome check
  Valid parentheses
  Fibonacci (recursive + memoized)

💻 CODE:
// ─── CLOSURE DEMO ─────────────────────────────────────
console.log("=== Closures ===");

function makeCounter(start = 0, step = 1) {
    let count = start;
    return {
        increment: ()  => (count += step),
        decrement: ()  => (count -= step),
        reset:     ()  => (count = start),
        value:     ()  => count,
    };
}
const c1 = makeCounter(0, 1);
const c2 = makeCounter(10, 5);
c1.increment(); c1.increment(); c1.increment();
c2.increment(); c2.increment();
console.log("  c1.value():", c1.value());  // 3
console.log("  c2.value():", c2.value());  // 20

// Classic var/let loop bug:
console.log("  var loop (bug):");
const varFns = [];
for (var i = 0; i < 3; i++) varFns.push(() => i);
console.log("  ", varFns.map(f => f())); // [3,3,3] — closure captures last i

console.log("  let loop (correct):");
const letFns = [];
for (let j = 0; j < 3; j++) letFns.push(() => j);
console.log("  ", letFns.map(f => f())); // [0,1,2] — each j is a new binding

// ─── HOISTING ─────────────────────────────────────────
console.log("\n=== Hoisting ===");

// Function declarations are fully hoisted:
console.log("  hoisted():", hoisted());
function hoisted() { return "I was hoisted!"; }

// var is hoisted as undefined:
console.log("  typeof varX before:", typeof varX);  // "undefined"
var varX = 42;
console.log("  typeof varX after:", typeof varX);   // "number"

// let/const are in temporal dead zone:
try {
    // console.log(letY);  // Would throw ReferenceError
    console.log("  let in TDZ: would throw ReferenceError");
} catch (e) {}
let letY = 10;

// ─── TYPE COERCION ────────────────────────────────────
console.log("\n=== Type Coercion Gotchas ===");

console.log("  0.1 + 0.2 === 0.3:", 0.1 + 0.2 === 0.3);         // false!
console.log("  0.1 + 0.2:", 0.1 + 0.2);                           // 0.30000000000000004
console.log("  typeof null:", typeof null);                         // "object"
console.log("  null == undefined:", null == undefined);             // true
console.log("  null === undefined:", null === undefined);           // false
console.log("  NaN === NaN:", NaN === NaN);                        // false!
console.log("  Number.isNaN(NaN):", Number.isNaN(NaN));            // true ✅
console.log("  1 + '2':", 1 + "2");                               // "12"
console.log("  '3' - 1:", "3" - 1);                               // 2 (- converts to number)
console.log("  +'42':", +"42");                                    // 42
console.log("  !!'hello':", !!"hello");                            // true
console.log("  !!'':", !!"");                                      // false
console.log("  [] + []:", [] + []);                               // ""
console.log("  [] + {}:", [] + {});                               // "[object Object]"

// ─── CODING CHALLENGES ────────────────────────────────
console.log("\n=== Common Coding Challenges ===");

// 1. Flatten nested array:
const nested = [1, [2, [3, [4, [5]]]]];
console.log("  Flat:", nested.flat(Infinity));
// Custom flatten:
const flatDeep = (arr) => arr.reduce(
    (acc, val) => Array.isArray(val) ? [...acc, ...flatDeep(val)] : [...acc, val], []);
console.log("  Custom flat:", flatDeep(nested));

// 2. Unique values preserving order:
const dupes = [3, 1, 4, 1, 5, 9, 2, 6, 5, 3, 5];
console.log("  Unique:", [...new Set(dupes)]);

// 3. Two-sum O(n):
function twoSum(nums, target) {
    const seen = new Map();
    for (let i = 0; i < nums.length; i++) {
        const complement = target - nums[i];
        if (seen.has(complement)) return [seen.get(complement), i];
        seen.set(nums[i], i);
    }
    return null;
}
console.log("  twoSum([2,7,11,15], 9):", twoSum([2,7,11,15], 9));  // [0,1]
console.log("  twoSum([3,2,4], 6):", twoSum([3,2,4], 6));           // [1,2]

// 4. Valid parentheses:
function isValid(s) {
    const stack = [];
    const pairs = { ')': '(', ']': '[', '}': '{' };
    for (const c of s) {
        if ('([{'.includes(c)) stack.push(c);
        else if (stack.pop() !== pairs[c]) return false;
    }
    return stack.length === 0;
}
console.log("  isValid('([]{})'):", isValid('([]{})')); // true
console.log("  isValid('([)]'):", isValid('([)]'));       // false

// 5. Implement Array.map from scratch:
Array.prototype.myMap = function(fn) {
    const result = [];
    for (let i = 0; i < this.length; i++) {
        result.push(fn(this[i], i, this));
    }
    return result;
};
console.log("  myMap:", [1,2,3].myMap(x => x * x));  // [1,4,9]

// 6. Curry:
function curry(fn) {
    return function curried(...args) {
        if (args.length >= fn.length) return fn(...args);
        return (...more) => curried(...args, ...more);
    };
}
const add3 = curry((a, b, c) => a + b + c);
console.log("  curry(1)(2)(3):", add3(1)(2)(3));  // 6
console.log("  curry(1,2)(3):", add3(1,2)(3));    // 6
console.log("  curry(1)(2,3):", add3(1)(2,3));    // 6

// 7. Deep equal:
function deepEqual(a, b) {
    if (a === b) return true;
    if (typeof a !== typeof b) return false;
    if (typeof a !== 'object' || a === null) return false;
    const keysA = Object.keys(a), keysB = Object.keys(b);
    if (keysA.length !== keysB.length) return false;
    return keysA.every(k => deepEqual(a[k], b[k]));
}
console.log("  deepEqual:", deepEqual({ a: 1, b: [2, 3] }, { a: 1, b: [2, 3] })); // true
console.log("  deepEqual:", deepEqual({ a: 1 }, { a: 2 }));                         // false

// 8. Memoize:
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
const slowSquare = (n) => { /* simulated slow */ return n * n; };
const fastSquare = memoize(slowSquare);
console.log("  memoize:", [5,5,6,5,6].map(n => fastSquare(n)));  // [25,25,36,25,36]

// 9. Flatten object:
function flattenObject(obj, prefix = '') {
    return Object.entries(obj).reduce((acc, [key, val]) => {
        const newKey = prefix ? \`\${prefix}.\${key}\` : key;
        if (val && typeof val === 'object' && !Array.isArray(val)) {
            return { ...acc, ...flattenObject(val, newKey) };
        }
        return { ...acc, [newKey]: val };
    }, {});
}
const deep = { a: { b: { c: 1 }, d: 2 }, e: 3 };
console.log("  flattenObject:", flattenObject(deep));

📝 KEY POINTS:
✅ Closures retain access to their outer scope — used for data privacy and state
✅ var is function-scoped and hoisted; let/const are block-scoped with TDZ
✅ var in loops creates one binding shared by all iterations — causes classic bugs
✅ typeof null === "object" is a historical bug — use null === value to check for null
✅ NaN !== NaN — always use Number.isNaN() or Object.is(x, NaN)
✅ Event loop: sync → microtasks (all) → one macrotask → repeat
✅ Arrow functions don't have their own 'this' — they use the enclosing scope's
✅ Two-sum with a Map is O(n); nested loops are O(n²) — know the difference
✅ curry() and memoize() are classic functional programming interview questions
❌ Don't confuse == (coercion) with === (strict) — always prefer ===
❌ Don't forget that floating-point arithmetic is imprecise — use epsilon or BigDecimal
❌ Don't mutate arrays/objects passed as arguments in algorithm questions
❌ Don't use var — it causes confusing scoping behavior
""",
  quiz: [
    Quiz(question: 'What output does this code produce? for(var i=0;i<3;i++){setTimeout(()=>console.log(i),0)}', options: [
      QuizOption(text: '3, 3, 3 — var creates one shared binding, all callbacks see the final value i=3', correct: true),
      QuizOption(text: '0, 1, 2 — each setTimeout captures a different value of i', correct: false),
      QuizOption(text: '0, 0, 0 — setTimeout resets the counter on each call', correct: false),
      QuizOption(text: 'undefined, undefined, undefined — var is not accessible inside setTimeout', correct: false),
    ]),
    Quiz(question: 'Why does typeof null return "object"?', options: [
      QuizOption(text: 'It\'s a historical bug from JavaScript\'s first version — null should return "null" but it\'s kept for backward compatibility', correct: true),
      QuizOption(text: 'null is an object in JavaScript — it inherits from the Object prototype', correct: false),
      QuizOption(text: 'typeof checks the prototype chain and finds Object.prototype', correct: false),
      QuizOption(text: 'null is represented as an empty object internally, so "object" is technically correct', correct: false),
    ]),
    Quiz(question: 'What is the output order of: console.log(1); setTimeout(()=>log(2),0); Promise.resolve().then(()=>log(3)); console.log(4)?', options: [
      QuizOption(text: '1, 4, 3, 2 — sync first, then microtask (Promise), then macrotask (setTimeout)', correct: true),
      QuizOption(text: '1, 2, 3, 4 — code executes top to bottom in order', correct: false),
      QuizOption(text: '1, 3, 2, 4 — Promise resolves before sync code finishes', correct: false),
      QuizOption(text: '1, 4, 2, 3 — setTimeout fires before Promise because it was registered first', correct: false),
    ]),
  ],
);
