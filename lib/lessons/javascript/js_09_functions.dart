import '../../models/lesson.dart';
import '../../models/quiz.dart';

final jsLesson09 = Lesson(
  language: 'JavaScript',
  title: 'Functions: Declarations, Expressions, and Arrow Functions',
  content: """
🎯 METAPHOR:
Functions are the verbs of programming — the reusable
actions. A function declaration is like a published recipe
in a cookbook that can be referenced before the page you're
reading (hoisting). A function expression is like writing
a recipe on a sticky note and taping it to your fridge —
it only exists from that moment forward. An arrow function
is a shorthand recipe card — compact, elegant, and
deliberately borrowing the kitchen context of whoever
created it (no own 'this'). Default parameters are the
recipe's suggested ingredient quantities, and rest parameters
are the "and whatever else you have" instruction.

📖 EXPLANATION:

─────────────────────────────────────
FUNCTION DECLARATION:
─────────────────────────────────────
  function greet(name) {
    return "Hello, " + name + "!";
  }

  → HOISTED: can be called before it's defined
  → Has its own 'this'
  → Named — shows up in stack traces

─────────────────────────────────────
FUNCTION EXPRESSION:
─────────────────────────────────────
  const greet = function(name) {
    return "Hello, " + name + "!";
  };

  const greet = function myGreet(name) {  // named expression
    return "Hello, " + name + "!";
  };

  → NOT hoisted (only the variable is hoisted, as undefined)
  → Has its own 'this'
  → Can be anonymous or named

─────────────────────────────────────
ARROW FUNCTIONS (ES6):
─────────────────────────────────────
  // Full syntax:
  const greet = (name) => {
    return "Hello, " + name + "!";
  };

  // Concise body (implicit return):
  const greet = (name) => "Hello, " + name + "!";

  // One parameter — parens optional:
  const double = n => n * 2;

  // No parameters:
  const getRandom = () => Math.random();

  // Return an object literal — wrap in parens!:
  const makeObj = (x, y) => ({ x, y });

  KEY DIFFERENCES from regular functions:
  ❌ No 'this' binding (inherits from enclosing scope)
  ❌ Cannot be used as constructors
  ❌ No 'arguments' object
  ❌ Not hoisted

─────────────────────────────────────
PARAMETERS AND ARGUMENTS:
─────────────────────────────────────
  // Default parameters (ES6):
  function greet(name = "World") {
    return \`Hello,\${
name}!\`;
  }
  greet()          → "Hello, World!"
  greet("Alice")   → "Hello, Alice!"

  // Rest parameters (...rest):
  function sum(...numbers) {
    return numbers.reduce((a, b) => a + b, 0);
  }
  sum(1, 2, 3, 4, 5) → 15

  // Must be last parameter
  function log(level, ...messages) { }

  // Destructured parameters:
  function display({ name, age = 0 }) {
    return \`\${
name} is\${
age}\`;
  }
  display({ name: "Alice", age: 28 })

─────────────────────────────────────
RETURN VALUES:
─────────────────────────────────────
  Functions return undefined if:
  → No return statement
  → return; (empty return)

  Can return any value including functions and objects.
  Immediately exits the function.

─────────────────────────────────────
FIRST-CLASS FUNCTIONS:
─────────────────────────────────────
  Functions are VALUES in JavaScript.
  They can be:
  → Stored in variables
  → Passed as arguments
  → Returned from other functions
  → Stored in arrays and objects

  This enables: callbacks, higher-order functions,
  functional programming patterns.

─────────────────────────────────────
IIFE (Immediately Invoked Function Expression):
─────────────────────────────────────
  (function() {
    // runs immediately
    const private = "only here";
  })();

  (() => {
    // arrow IIFE
  })();

  Use cases: module-like encapsulation, avoiding global
  pollution, initialization logic.

─────────────────────────────────────
FUNCTION PROPERTIES:
─────────────────────────────────────
  fn.name       → function's name
  fn.length     → number of declared parameters
  fn.toString() → source code as string
  fn.call(ctx, ...args)    → call with explicit 'this'
  fn.apply(ctx, argsArray) → call with this and array
  fn.bind(ctx, ...args)    → create new function with bound 'this'

💻 CODE:
// ─── DECLARATIONS ─────────────────────────────────────
console.log("=== Function Declarations ===");

// Hoisted — can be called before definition
console.log(add(3, 4));  // 7 ← works!

function add(a, b) {
  return a + b;
}

function factorial(n) {
  if (n <= 1) return 1;
  return n * factorial(n - 1);
}
console.log(factorial(5));  // 120
console.log(factorial(10)); // 3628800

// ─── EXPRESSIONS ──────────────────────────────────────
console.log("\n=== Function Expressions ===");

const multiply = function(a, b) {
  return a * b;
};
console.log(multiply(3, 4));  // 12

// Named function expression (better stack traces):
const fib = function fibonacci(n) {
  if (n <= 1) return n;
  return fibonacci(n - 1) + fibonacci(n - 2);
};
console.log(fib(10));  // 55

// ─── ARROW FUNCTIONS ──────────────────────────────────
console.log("\n=== Arrow Functions ===");

const square = n => n * n;
const greet = (name, time = "day") => \`Good\${
time},\${
name}!\`;
const identity = x => x;
const getRandom = () => Math.random();
const makePoint = (x, y) => ({ x, y });  // object: wrap in ()

console.log(square(5));                    // 25
console.log(greet("Alice"));               // "Good day, Alice!"
console.log(greet("Bob", "morning"));     // "Good morning, Bob!"
console.log(makePoint(3, 4));              // {x: 3, y: 4}

// Arrow in array methods:
const nums = [1, 2, 3, 4, 5];
console.log(nums.map(n => n ** 2));         // [1, 4, 9, 16, 25]
console.log(nums.filter(n => n % 2 === 0)); // [2, 4]
console.log(nums.reduce((acc, n) => acc + n, 0)); // 15

// ─── DEFAULT PARAMETERS ───────────────────────────────
console.log("\n=== Default Parameters ===");
function createUser(name, role = "user", active = true) {
  return { name, role, active };
}
console.log(createUser("Alice"));                  // {name:"Alice", role:"user", active:true}
console.log(createUser("Bob", "admin"));           // {name:"Bob", role:"admin", active:true}
console.log(createUser("Carol", "user", false));   // {name:"Carol", role:"user", active:false}

// Default from expression (evaluated each call):
function getTimestamp(date = new Date()) {
  return date.toISOString();
}
console.log(getTimestamp()); // current timestamp

// ─── REST PARAMETERS ──────────────────────────────────
console.log("\n=== Rest Parameters ===");
const sum = (...numbers) => numbers.reduce((a, b) => a + b, 0);
console.log(sum(1, 2, 3));         // 6
console.log(sum(1, 2, 3, 4, 5));   // 15

function logMessage(level, ...parts) {
  console.log(\`[\${
level.toUpperCase()}]\`, ...parts);
}
logMessage("info", "Server started on port", 3000);
logMessage("error", "Failed:", "connection refused");

// ─── DESTRUCTURED PARAMETERS ──────────────────────────
console.log("\n=== Destructured Parameters ===");
function displayUser({ name, age = 0, city = "Unknown" }) {
  console.log(\`\${
name},\${
age}, from\${
city}\`);
}
displayUser({ name: "Alice", age: 28, city: "London" });
displayUser({ name: "Bob" });  // age=0, city="Unknown"

// Array destructuring in params:
const first = ([a, b]) => a;
console.log(first([1, 2, 3]));  // 1

// ─── FIRST-CLASS FUNCTIONS ────────────────────────────
console.log("\n=== First-Class Functions ===");

// Function as argument:
const applyTwice = (fn, x) => fn(fn(x));
console.log(applyTwice(n => n * 2, 3));  // 12

// Function as return value:
const multiplier = factor => num => num * factor;
const double = multiplier(2);
const triple = multiplier(3);
console.log(double(5));  // 10
console.log(triple(5));  // 15

// Functions in objects:
const calculator = {
  add: (a, b) => a + b,
  sub: (a, b) => a - b,
  mul: (a, b) => a * b,
};
console.log(calculator.add(3, 4));  // 7

// ─── IIFE ─────────────────────────────────────────────
console.log("\n=== IIFE ===");
const result = (function() {
  const secret = 42;
  return { getValue: () => secret };
})();
console.log(result.getValue());  // 42

// ─── FUNCTION PROPERTIES ──────────────────────────────
console.log("\n=== Function Properties ===");
function myFunction(a, b, c) {}
console.log(myFunction.name);    // "myFunction"
console.log(myFunction.length);  // 3 (params, excludes default+rest)

const arrowFn = (x, y = 0) => x + y;
console.log(arrowFn.name);       // "arrowFn"
console.log(arrowFn.length);     // 1 (y has default, not counted)

📝 KEY POINTS:
✅ Function declarations are hoisted — can be called before they're defined
✅ Arrow functions inherit 'this' from enclosing scope — no own 'this'
✅ Concise arrow body: n => n * 2 implicitly returns n * 2
✅ To return an object literal from arrow: n => ({ value: n }) — wrap in parens
✅ Default parameters: function greet(name = "World") — evaluated at call time
✅ Rest parameters: (...args) collects all remaining arguments into an array
✅ Functions are first-class values — pass them, return them, store them
✅ fn.length returns the number of parameters (excluding defaults and rest)
❌ Arrow functions cannot be used as constructors (no new arrow())
❌ Arrow functions have no 'arguments' object — use rest parameters instead
❌ Function expressions are NOT hoisted — calling before declaration throws ReferenceError
""",
  quiz: [
    Quiz(
      question: 'What is the key difference between function declarations and function expressions regarding hoisting?',
      options: [
        QuizOption(text: 'Declarations are fully hoisted and can be called before their definition; expressions are not — calling before declaration throws ReferenceError', correct: true),
        QuizOption(text: 'Both are hoisted — the difference is only stylistic', correct: false),
        QuizOption(text: 'Expressions are hoisted; declarations are not', correct: false),
        QuizOption(text: 'Neither is hoisted in strict mode', correct: false),
      ],
    ),
    Quiz(
      question: 'Why do arrow functions NOT have their own "this"?',
      options: [
        QuizOption(text: 'Arrow functions inherit "this" from the enclosing lexical scope — designed for callbacks where "this" from the outer context is needed', correct: true),
        QuizOption(text: '"this" in arrow functions always refers to the global object', correct: false),
        QuizOption(text: 'Arrow functions are pure functions that cannot have any state', correct: false),
        QuizOption(text: '"this" is automatically bound to undefined in arrow functions', correct: false),
      ],
    ),
    Quiz(
      question: 'What does const makePoint = (x, y) => ({ x, y }) do?',
      options: [
        QuizOption(text: 'Returns an object { x, y } — the parentheses are needed because {} would be interpreted as a block body without them', correct: true),
        QuizOption(text: 'Wraps x and y in an array using destructuring syntax', correct: false),
        QuizOption(text: 'Creates a function that modifies the global x and y variables', correct: false),
        QuizOption(text: 'Throws a SyntaxError — arrow functions cannot return object literals', correct: false),
      ],
    ),
  ],
);
