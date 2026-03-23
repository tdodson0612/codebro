import '../../models/lesson.dart';
import '../../models/quiz.dart';

final jsLesson13 = Lesson(
  language: 'JavaScript',
  title: 'The "this" Keyword and Binding',
  content: """
🎯 METAPHOR:
'this' in JavaScript is like the word "I" in a sentence —
its meaning depends ENTIRELY on who is speaking, not
where the sentence is written. If Alice says "I am tall,"
'I' means Alice. If Bob says the same sentence, 'I' means
Bob. In JavaScript, 'this' refers to the object that is
CALLING the method — determined at runtime, not at write
time. The problem: arrow functions don't have their own
"I" — they borrow it from the surrounding context.
Understanding this is one of the most important skills
in JavaScript, and the source of many classic bugs.

📖 EXPLANATION:

─────────────────────────────────────
WHAT "this" REFERS TO:
─────────────────────────────────────
  1. GLOBAL context:
     this → global object (window in browser, global in Node)
     In strict mode: this → undefined

  2. OBJECT METHOD:
     const obj = { fn() { return this; } };
     obj.fn(); → this is obj

  3. FUNCTION call (loose mode):
     function fn() { return this; }
     fn(); → this is global (or undefined in strict mode)

  4. ARROW FUNCTION:
     → No own 'this' — lexically inherits from outer scope
     → Cannot be rebound with call/apply/bind

  5. CONSTRUCTOR (new):
     function Person(name) { this.name = name; }
     new Person("Alice"); → this is the new instance

  6. EXPLICIT BINDING (call/apply/bind):
     fn.call(obj, arg1, arg2)    → this is obj
     fn.apply(obj, [arg1, arg2]) → this is obj
     const bound = fn.bind(obj)  → new fn with this = obj

  7. DOM EVENTS:
     button.addEventListener("click", function() {
       this; → the button element
     });
     // Arrow function: this → outer scope (not the button!)

─────────────────────────────────────
CALL, APPLY, BIND:
─────────────────────────────────────
  function greet(greeting, punctuation) {
    return \`\${greeting}, \${this.name}\${punctuation}\`;
  }

  const alice = { name: "Alice" };
  greet.call(alice, "Hello", "!")    → "Hello, Alice!"
  greet.apply(alice, ["Hi", "?"])    → "Hi, Alice?"
  const boundGreet = greet.bind(alice, "Hey");
  boundGreet("...")                  → "Hey, Alice..."

─────────────────────────────────────
THE ARROW FUNCTION FIX:
─────────────────────────────────────
  // Classic 'this' problem:
  function Timer() {
    this.seconds = 0;
    setInterval(function() {
      this.seconds++; // ❌ 'this' is global/undefined!
    }, 1000);
  }

  // Fix 1: arrow function (captures outer 'this'):
  function Timer() {
    this.seconds = 0;
    setInterval(() => {
      this.seconds++; // ✅ 'this' is the Timer instance
    }, 1000);
  }

  // Fix 2: assign 'this' to a variable:
  function Timer() {
    this.seconds = 0;
    const self = this;
    setInterval(function() {
      self.seconds++; // ✅ works but verbose
    }, 1000);
  }

─────────────────────────────────────
CLASS METHODS AND 'this':
─────────────────────────────────────
  class Counter {
    count = 0;
    // Problem: detached method loses 'this':
    increment() { this.count++; }
  }
  const c = new Counter();
  const fn = c.increment;
  fn(); // ❌ TypeError: this is undefined

  // Fix: bind in constructor or use arrow class field:
  class Counter {
    count = 0;
    increment = () => { this.count++; }; // arrow class field
  }

💻 CODE:
"use strict";
// ─── this IN DIFFERENT CONTEXTS ───────────────────────
console.log("=== this Contexts ===");

const obj = {
  name: "MyObject",
  regular() { return this.name; },      // 'this' = obj
  arrow: () => typeof this,             // 'this' = outer (undefined in strict module)
  nested: {
    name: "Nested",
    fn() { return this.name; },         // 'this' = obj.nested
  }
};

console.log(obj.regular());       // "MyObject"
console.log(obj.nested.fn());     // "Nested"

// Detached method loses 'this':
const detached = obj.regular;
try {
  console.log(detached()); // TypeError in strict mode
} catch (e) {
  console.log("Detached error:", e.message);
}

// ─── CALL, APPLY, BIND ────────────────────────────────
console.log("\n=== call, apply, bind ===");
function introduce(greeting, punctuation) {
  return \`\${greeting}, I'm \${this.name}\${punctuation}\`;
}

const alice = { name: "Alice" };
const bob   = { name: "Bob" };

console.log(introduce.call(alice, "Hello", "!"));  // Hello, I'm Alice!
console.log(introduce.call(bob, "Hi", "?"));        // Hi, I'm Bob?
console.log(introduce.apply(alice, ["Hey", "..."])); // Hey, I'm Alice...

const aliceGreet = introduce.bind(alice, "Good day");
console.log(aliceGreet("!!"));   // Good day, I'm Alice!!
console.log(aliceGreet("."));    // Good day, I'm Alice.

// ─── ARROW FUNCTIONS AND this ─────────────────────────
console.log("\n=== Arrow Functions and this ===");
function Person(name) {
  this.name = name;
  this.friends = [];
  this.getNameRegular = function() { return this.name; };
  this.getNameArrow = () => this.name; // captures outer 'this'
}

const alice2 = new Person("Alice");
const fn1 = alice2.getNameRegular;
const fn2 = alice2.getNameArrow;

try {
  fn1(); // ❌ undefined or error
} catch(e) {
  console.log("Regular detached:", e.message || "undefined");
}
console.log("Arrow detached:", fn2()); // ✅ "Alice" (bound via closure)

// ─── PRACTICAL: Event handler pattern ─────────────────
console.log("\n=== Practical: Timer / Callback ===");
class Timer {
  constructor(name) {
    this.name = name;
    this.ticks = 0;
  }

  start() {
    // ✅ Arrow function captures 'this' from start():
    const tick = () => {
      this.ticks++;
    };
    for (let i = 0; i < 5; i++) tick();
  }

  toString() {
    return \`\${this.name}: \${this.ticks} ticks\`;
  }
}

const t = new Timer("MyTimer");
t.start();
console.log(t.toString());  // MyTimer: 5 ticks

// ─── BIND FOR PARTIAL APPLICATION ─────────────────────
console.log("\n=== bind for Partial Application ===");
function multiply(a, b) { return a * b; }
const double  = multiply.bind(null, 2);  // null = don't care about 'this'
const triple  = multiply.bind(null, 3);
console.log(double(5));   // 10
console.log(triple(5));   // 15

const nums = [1, 2, 3, 4, 5];
console.log(nums.map(double));  // [2,4,6,8,10]

📝 KEY POINTS:
✅ 'this' is determined by HOW a function is called, not where it's defined
✅ In a regular function called as a method: this = the object before the dot
✅ Detached methods (const fn = obj.method; fn()) lose their 'this'
✅ Arrow functions inherit 'this' from the enclosing lexical scope — never their own
✅ call(ctx, ...args) and apply(ctx, argsArray) explicitly set 'this' for one call
✅ bind(ctx, ...args) returns a NEW function with 'this' permanently bound
✅ Arrow class fields (increment = () => this.count++) solve the callback 'this' problem
✅ Use null as the context for bind when you only need partial application
❌ Arrow functions cannot have 'this' rebound with call/apply/bind — it's ignored
❌ Don't use arrow functions as object methods — they won't have the right 'this'
❌ 'this' in a regular function called without a receiver is global or undefined in strict mode
""",
  quiz: [
    Quiz(
      question: 'What happens when you extract a method and call it as a standalone function?',
      options: [
        QuizOption(text: 'The method loses its "this" binding — in strict mode this is undefined, causing a TypeError', correct: true),
        QuizOption(text: 'The method retains "this" pointing to the original object it came from', correct: false),
        QuizOption(text: 'The method automatically binds "this" to the global object', correct: false),
        QuizOption(text: 'The method creates a new copy of the object to use as "this"', correct: false),
      ],
    ),
    Quiz(
      question: 'What is the difference between call() and apply()?',
      options: [
        QuizOption(text: 'call() takes individual arguments; apply() takes an array of arguments — both explicitly set "this"', correct: true),
        QuizOption(text: 'call() creates a new bound function; apply() calls immediately', correct: false),
        QuizOption(text: 'apply() is deprecated; call() is the modern replacement', correct: false),
        QuizOption(text: 'They are identical — the names are interchangeable', correct: false),
      ],
    ),
    Quiz(
      question: 'Why is an arrow function the preferred solution for callbacks that need "this"?',
      options: [
        QuizOption(text: 'Arrow functions lexically capture "this" from the enclosing scope — they always refer to the outer "this" even when called later as callbacks', correct: true),
        QuizOption(text: 'Arrow functions automatically bind "this" to the nearest class instance', correct: false),
        QuizOption(text: 'Arrow functions have a built-in reference to the DOM element that triggered them', correct: false),
        QuizOption(text: 'Arrow functions run in strict mode, which makes "this" predictable', correct: false),
      ],
    ),
  ],
);
