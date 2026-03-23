import '../../models/lesson.dart';
import '../../models/quiz.dart';

final jsLesson02 = Lesson(
  language: 'JavaScript',
  title: 'Variables: var, let, and const',
  content: """
🎯 METAPHOR:
Think of variables as labeled boxes on a shelf.
const is a box sealed with a padlock — once you put
something in and lock it, the LABEL stays on that box
forever. let is a box with a sticky note label — you can
swap out the contents whenever you like, but it only
sits on YOUR shelf (the block it was created in).
var is a mysterious box from the 1990s — it ignores
shelves entirely, floats up to the nearest room ceiling,
and is available to everyone in the room before you
even put anything in it (hoisting). Modern JavaScript
uses const and let almost exclusively. var is legacy.

📖 EXPLANATION:

─────────────────────────────────────
THREE WAYS TO DECLARE VARIABLES:
─────────────────────────────────────
  const  → block-scoped, cannot be reassigned  ← use this first
  let    → block-scoped, can be reassigned     ← use when needed
  var    → function-scoped, hoisted            ← avoid in modern JS

─────────────────────────────────────
const — the default choice:
─────────────────────────────────────
  const name = "Alice";
  // name = "Bob";  ❌ TypeError: Assignment to constant variable

  const is NOT deeply immutable:
  const arr = [1, 2, 3];
  arr.push(4);       // ✅ mutating the array content is fine
  // arr = [1, 2, 3, 4]; ❌ reassigning the variable is not

  const obj = { x: 1 };
  obj.x = 2;         // ✅ mutating the object is fine
  // obj = { x: 2 }; ❌ reassigning is not

  Rule: const means the BINDING is constant, not the value.

─────────────────────────────────────
let — when you need to reassign:
─────────────────────────────────────
  let count = 0;
  count = 1;     // ✅
  count++;       // ✅

  let is BLOCK-SCOPED:
  {
    let x = 10;
    console.log(x); // 10 ✅
  }
  // console.log(x); ❌ ReferenceError: x is not defined

─────────────────────────────────────
var — legacy (avoid):
─────────────────────────────────────
  var is FUNCTION-SCOPED, not block-scoped:
  {
    var y = 20;
  }
  console.log(y); // 20 ← leaks out of the block!

  var is HOISTED to the top of its function:
  console.log(z); // undefined (not an error!)
  var z = 5;
  // Behaves as if: var z; (declaration hoisted)
  //               z = 5;  (assignment stays)

  var allows RE-DECLARATION (dangerous):
  var name = "Alice";
  var name = "Bob";  // ✅ no error — silently overwrites!

─────────────────────────────────────
HOISTING:
─────────────────────────────────────
  JavaScript moves DECLARATIONS (not initializations)
  to the top of their scope before execution.

  var: hoisted with value undefined
  let/const: hoisted BUT in the "Temporal Dead Zone" (TDZ)
  → accessing let/const before declaration = ReferenceError

  console.log(a); // undefined (var hoisting)
  var a = 5;

  console.log(b); // ❌ ReferenceError (TDZ)
  let b = 5;

─────────────────────────────────────
SCOPE:
─────────────────────────────────────
  GLOBAL scope   → declared outside any function/block
  FUNCTION scope → inside a function (var, let, const)
  BLOCK scope    → inside {} (let and const only)
  MODULE scope   → inside an ES module file

  Scope chain: inner scope can access outer scope,
  but outer cannot access inner.

─────────────────────────────────────
NAMING CONVENTIONS:
─────────────────────────────────────
  camelCase          → variables and functions: myVariable
  PascalCase         → classes and constructors: MyClass
  SCREAMING_SNAKE_CASE → constants: MAX_SIZE, API_KEY
  _prefix            → "private" by convention: _internal
 \$prefix            → jQuery era, or special framework vars

  Valid names:
  ✅ myVar, _private,\$special, camelCase99
  ❌ 1stVar (starts with digit), my-var (hyphen), let (keyword)

─────────────────────────────────────
WHEN TO USE WHAT:
─────────────────────────────────────
  const → DEFAULT. Use unless you need to reassign.
  let   → When the value WILL change (loop counters,
           accumulators, conditional assignments).
  var   → NEVER in new code. Only when maintaining
           legacy code.

💻 CODE:
// ─── CONST ────────────────────────────────────────────
const PI = 3.14159;
const MAX_USERS = 100;
const APP_NAME = "CodeBro";

console.log("=== const ===");
console.log(PI, MAX_USERS, APP_NAME);

// const with objects and arrays — binding is const, content isn't
const user = { name: "Alice", age: 28 };
user.age = 29;           // ✅ mutation is fine
user.city = "London";    // ✅ adding property is fine
console.log(user);       // { name: 'Alice', age: 29, city: 'London' }
// user = {};  ❌ TypeError

const scores = [95, 87, 92];
scores.push(88);         // ✅
scores[0] = 100;         // ✅
console.log(scores);     // [100, 87, 92, 88]
// scores = [];  ❌ TypeError

// ─── LET ──────────────────────────────────────────────
console.log("\n=== let ===");
let counter = 0;
counter++;
counter += 5;
console.log("Counter:", counter); // 6

// Block scope
{
  let blockVar = "I'm inside a block";
  console.log(blockVar); // ✅
}
// console.log(blockVar); // ❌ ReferenceError

// Loop variable (classic use of let)
for (let i = 0; i < 5; i++) {
  // i is scoped to THIS iteration
}
// console.log(i); // ❌ ReferenceError

// ─── VAR (legacy) ─────────────────────────────────────
console.log("\n=== var (legacy) ===");
{
  var legacyVar = "I leak out of blocks";
}
console.log(legacyVar); // "I leak out of blocks" ← bad!

// Hoisting
console.log("hoisted:", hoisted); // undefined (not an error)
var hoisted = "value";
console.log("hoisted:", hoisted); // "value"

// ─── TEMPORAL DEAD ZONE ───────────────────────────────
console.log("\n=== Temporal Dead Zone ===");
try {
  console.log(tdz); // ❌ ReferenceError
  let tdz = "value";
} catch (e) {
  console.log("TDZ error:", e.message);
}

// ─── SCOPE CHAIN ──────────────────────────────────────
console.log("\n=== Scope Chain ===");
const globalVar = "global";

function outerFn() {
  const outerVar = "outer";

  function innerFn() {
    const innerVar = "inner";
    // Can access all parent scopes:
    console.log(globalVar); // "global"
    console.log(outerVar);  // "outer"
    console.log(innerVar);  // "inner"
  }
  innerFn();
  // console.log(innerVar); // ❌ not accessible here
}
outerFn();

// ─── NAMING CONVENTIONS ───────────────────────────────
console.log("\n=== Naming Conventions ===");
const firstName = "Terry";           // camelCase
const MAX_RETRIES = 3;               // SCREAMING_SNAKE
const ApiEndpoint = "https://...";   // PascalCase (for classes)
let _privateCounter = 0;             // _prefix convention
let isLoggedIn = false;              // boolean: is/has/can prefix

console.log(firstName, MAX_RETRIES);

// ─── DESTRUCTURING (preview) ──────────────────────────
const [a, b, c] = [1, 2, 3];
const { name: personName, age } = { name: "Bob", age: 30 };
console.log(a, b, c);           // 1 2 3
console.log(personName, age);   // Bob 30

// ─── TYPEOF ───────────────────────────────────────────
console.log("\n=== typeof ===");
console.log(typeof "hello");     // string
console.log(typeof 42);          // number
console.log(typeof true);        // boolean
console.log(typeof undefined);   // undefined
console.log(typeof null);        // object ← famous JS bug
console.log(typeof {});          // object
console.log(typeof []);          // object (arrays are objects)
console.log(typeof function(){}); // function

📝 KEY POINTS:
✅ Use const by default — switch to let only when you need to reassign
✅ const prevents reassignment of the variable binding, not mutation of its content
✅ let and const are block-scoped — they only exist within the {} that contains them
✅ var is function-scoped and hoisted — leads to confusing bugs, avoid in new code
✅ Hoisting: var is hoisted with undefined; let/const are hoisted but in the TDZ
✅ Temporal Dead Zone: accessing let/const before declaration throws ReferenceError
✅ Inner functions can access outer scope variables (scope chain)
✅ typeof null === "object" is a historic JavaScript bug — null is NOT an object
❌ Never use var in modern JavaScript — always const or let
❌ Don't confuse const (immutable binding) with deeply frozen objects
❌ Don't redeclare variables with let — only var allows that (another reason to avoid var)
""",
  quiz: [
    Quiz(
      question: 'What is the key difference between const and let in JavaScript?',
      options: [
        QuizOption(text: 'const prevents the variable from being reassigned; let allows reassignment — both are block-scoped', correct: true),
        QuizOption(text: 'const creates an immutable deep copy of the value; let creates a mutable reference', correct: false),
        QuizOption(text: 'const is function-scoped; let is block-scoped', correct: false),
        QuizOption(text: 'They are identical — const is just a convention for values that should not change', correct: false),
      ],
    ),
    Quiz(
      question: 'What happens when you access a let variable before its declaration?',
      options: [
        QuizOption(text: 'A ReferenceError is thrown — let/const are in the Temporal Dead Zone until the declaration is reached', correct: true),
        QuizOption(text: 'undefined is returned — the same behavior as var', correct: false),
        QuizOption(text: 'null is returned — let variables are initialized to null before declaration', correct: false),
        QuizOption(text: 'A SyntaxError is thrown at parse time, preventing the script from running', correct: false),
      ],
    ),
    Quiz(
      question: 'What does typeof null return, and why is this notable?',
      options: [
        QuizOption(text: '"object" — a historic JavaScript bug from 1995 that was kept for backwards compatibility', correct: true),
        QuizOption(text: '"null" — null has its own type in JavaScript', correct: false),
        QuizOption(text: '"undefined" — null and undefined share the same type', correct: false),
        QuizOption(text: '"boolean" — null is treated as false in JavaScript\'s type system', correct: false),
      ],
    ),
  ],
);
