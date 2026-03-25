import '../../models/lesson.dart';
import '../../models/quiz.dart';

final jsLesson04 = Lesson(
  language: 'JavaScript',
  title: 'Operators',
  content: """
🎯 METAPHOR:
Operators are the verbs of JavaScript — the ACTION words
that transform and combine values. Arithmetic operators
add and multiply like a calculator. Comparison operators
ask questions: "is A bigger than B?" Logical operators
connect questions: "is it raining AND cold?" The modern
operators — optional chaining (?.), nullish coalescing
(??), and logical assignment (&&=, ||=, ??=) — are like
precision tools that handle the "what if this is null?"
scenario that used to require four lines of defensive code
and now takes one symbol.

📖 EXPLANATION:

─────────────────────────────────────
ARITHMETIC OPERATORS:
─────────────────────────────────────
  +    addition / string concatenation
  -    subtraction
  *    multiplication
  /    division (always returns float: 7/2 = 3.5)
  %    remainder (modulo): 7 % 3 = 1
  **   exponentiation: 2 ** 10 = 1024
  ++   increment (prefix or postfix)
  --   decrement (prefix or postfix)

  ++x  → increment THEN return (returns new value)
  x++  → return THEN increment (returns old value)

─────────────────────────────────────
ASSIGNMENT OPERATORS:
─────────────────────────────────────
  =    assign
  +=   add and assign:     x += 5  same as  x = x + 5
  -=   subtract and assign
  *=   multiply and assign
  /=   divide and assign
  %=   remainder and assign
  **=  exponent and assign
  &&=  logical AND assign: x &&= y → if x is truthy, x = y
  ||=  logical OR assign:  x ||= y → if x is falsy, x = y
  ??=  nullish assign:     x ??= y → if x is null/undefined, x = y

─────────────────────────────────────
COMPARISON OPERATORS:
─────────────────────────────────────
  ===  strict equal (ALWAYS use this)
  !==  strict not equal
  ==   loose equal (coerces types — AVOID)
  !=   loose not equal (coerces types — AVOID)
  >    greater than
  <    less than
  >=   greater than or equal
  <=   less than or equal

─────────────────────────────────────
LOGICAL OPERATORS:
─────────────────────────────────────
  &&   AND — returns first falsy, or last value
  ||   OR  — returns first truthy, or last value
  !    NOT — negates boolean

  Short-circuit evaluation:
  false && anything  → false (second not evaluated)
  true  || anything  → true  (second not evaluated)

  Pattern: defaults and guards
  const name = input || "Anonymous";  // || for default
  user && user.email && sendEmail();   // && for guard

─────────────────────────────────────
NULLISH COALESCING (??) — ES2020:
─────────────────────────────────────
  Returns right side ONLY if left is null OR undefined.
  Unlike ||, it doesn't treat 0, "", false as falsy.

  const port = config.port ?? 3000;   // 0 is preserved!
  const name = user.name ?? "Guest";

  || treats 0, "" as falsy (wrong for port numbers)
  ?? treats only null/undefined as "missing" (correct)

─────────────────────────────────────
OPTIONAL CHAINING (?.) — ES2020:
─────────────────────────────────────
  Safely access nested properties without null checks.

  // Old way:
  const city = user && user.address && user.address.city;

  // New way:
  const city = user?.address?.city;
  const first = arr?.[0];         // safe array access
  const result = fn?.();           // safe function call

  Returns undefined if any step is null/undefined.
  Does NOT throw TypeError on null/undefined access.

─────────────────────────────────────
TERNARY OPERATOR:
─────────────────────────────────────
  condition ? valueIfTrue : valueIfFalse

  const label = age >= 18 ? "adult" : "minor";
  const display = items.length > 0 ? items : ["No items"];

─────────────────────────────────────
BITWISE OPERATORS:
─────────────────────────────────────
  &    AND     5 & 3  = 1  (0101 & 0011 = 0001)
  |    OR      5 | 3  = 7  (0101 | 0011 = 0111)
  ^    XOR     5 ^ 3  = 6  (0101 ^ 0011 = 0110)
  ~    NOT     ~5     = -6
  <<   left shift   5 << 1 = 10
  >>   right shift  5 >> 1 = 2
  >>>  unsigned right shift

  Common use: flags, bitmasks, low-level operations.
  Rare in day-to-day JavaScript.

─────────────────────────────────────
OTHER OPERATORS:
─────────────────────────────────────
  typeof x        → type as string
  instanceof X    → is x an instance of X?
  in "key" in obj → does object have property?
  delete obj.key  → remove a property
  void expr       → evaluates and returns undefined
  , (comma)       → evaluate both, return last
  ... (spread)    → spread iterable
  ? (optional chaining) + ?? (nullish coalescing)

💻 CODE:
// ─── ARITHMETIC ───────────────────────────────────────
console.log("=== Arithmetic ===");
console.log(10 + 3);   // 13
console.log(10 - 3);   // 7
console.log(10 * 3);   // 30
console.log(10 / 3);   // 3.3333...
console.log(10 % 3);   // 1
console.log(2 ** 10);  // 1024

let x = 5;
console.log(x++);  // 5 (returns first, then increments)
console.log(x);    // 6
console.log(++x);  // 7 (increments first, then returns)
console.log(x);    // 7

// ─── COMPARISON ───────────────────────────────────────
console.log("\n=== Comparison ===");
console.log(5 === 5);       // true
console.log(5 === "5");     // false ← strict!
console.log(5 !== "5");     // true
console.log(5 > 3);         // true
console.log(5 >= 5);        // true
console.log("b" > "a");     // true (lexicographic)

// ─── LOGICAL OPERATORS ────────────────────────────────
console.log("\n=== Logical Operators ===");
console.log(true && false);  // false
console.log(true || false);  // true
console.log(!true);          // false

// && returns first falsy or last value:
console.log(1 && 2 && 3);    // 3 (all truthy → last)
console.log(1 && null && 3); // null (first falsy)
console.log(0 && "hello");   // 0 (first falsy)

// || returns first truthy or last value:
console.log(null || "default"); // "default"
console.log("Alice" || "Bob");  // "Alice"
console.log(0 || "" || "last"); // "last"

// ─── NULLISH COALESCING (??) ──────────────────────────
console.log("\n=== Nullish Coalescing (??) ===");
const port = 0;
console.log(port || 3000);   // 3000 ← WRONG! 0 is a valid port
console.log(port ?? 3000);   // 0    ← CORRECT! only null/undefined triggers

const username = "";
console.log(username || "Guest");   // "Guest" ← might be wrong
console.log(username ?? "Guest");   // ""      ← preserves empty string

let value = null;
console.log(value ?? "fallback");   // "fallback"
value = undefined;
console.log(value ?? "fallback");   // "fallback"
value = 0;
console.log(value ?? "fallback");   // 0

// ─── OPTIONAL CHAINING (?.) ───────────────────────────
console.log("\n=== Optional Chaining (?.) ===");
const user = {
  name: "Alice",
  address: {
    city: "London",
    zip: "EC1A 1BB"
  },
  getGreeting() { return \`Hello, ${
this.name}!\`; }
};

const nullUser = null;

// Without optional chaining (error-prone):
// const city = nullUser.address.city; ❌ TypeError

// With optional chaining:
console.log(user?.address?.city);      // "London"
console.log(nullUser?.address?.city);  // undefined (safe!)
console.log(user?.phone?.number);      // undefined
console.log(user?.getGreeting?.());    // "Hello, Alice!"

// Array element access:
const arr = [1, 2, 3];
console.log(arr?.[0]);      // 1
console.log(null?.[0]);     // undefined

// ─── LOGICAL ASSIGNMENT OPERATORS ────────────────────
console.log("\n=== Logical Assignment (ES2021) ===");
let a = null;
a ??= "default";
console.log(a); // "default"

let b = 0;
b ||= 42;
console.log(b); // 42 (0 is falsy → assigned)

let c = 5;
c &&= c * 2;
console.log(c); // 10 (5 is truthy → multiplied)

// ─── TERNARY ──────────────────────────────────────────
console.log("\n=== Ternary ===");
const age = 20;
const label = age >= 18 ? "adult" : "minor";
console.log(label);  // "adult"

// Nested ternary (use sparingly):
const score = 85;
const grade = score >= 90 ? "A" :
              score >= 80 ? "B" :
              score >= 70 ? "C" : "F";
console.log(grade); // "B"

// ─── TYPEOF AND INSTANCEOF ───────────────────────────
console.log("\n=== typeof and instanceof ===");
console.log(typeof "hi");      // string
console.log(typeof 42);        // number
console.log([] instanceof Array);   // true
console.log({} instanceof Object);  // true

// ─── IN OPERATOR ──────────────────────────────────────
console.log("\n=== in operator ===");
const car = { make: "Toyota", model: "Camry" };
console.log("make" in car);    // true
console.log("year" in car);    // false
console.log(0 in [1, 2, 3]);   // true (index exists)

📝 KEY POINTS:
✅ Use === and !== always — never == or != (they coerce types)
✅ ?? (nullish coalescing) is better than || for default values when 0 and "" are valid
✅ ?. (optional chaining) safely accesses nested properties without null checks
✅ x++ returns the old value THEN increments; ++x increments THEN returns
✅ && returns first falsy value or last value; || returns first truthy value or last value
✅ ??= assigns only if null/undefined; ||= assigns if falsy; &&= assigns if truthy
✅ ** is exponentiation (2 ** 3 = 8); % is remainder (7 % 3 = 1)
✅ typeof works for primitives; instanceof works for objects
❌ Don't use == — it coerces types in surprising ways
❌ Don't use || for default values when 0, "", or false are valid values — use ?? instead
❌ Avoid deeply nested ternaries — extract to if/else or a function for readability
""",
  quiz: [
    Quiz(
      question: 'What is the difference between ?? and || when used for default values?',
      options: [
        QuizOption(text: '?? only triggers when the left side is null or undefined; || triggers for any falsy value (including 0, "", false)', correct: true),
        QuizOption(text: '?? works for all types; || only works for booleans', correct: false),
        QuizOption(text: 'They are identical — ?? is just a newer syntax for ||', correct: false),
        QuizOption(text: '|| returns the right side always; ?? returns the left side when possible', correct: false),
      ],
    ),
    Quiz(
      question: 'What does user?.address?.city return if user is null?',
      options: [
        QuizOption(text: 'undefined — optional chaining short-circuits and returns undefined rather than throwing TypeError', correct: true),
        QuizOption(text: 'null — it propagates the null value through the chain', correct: false),
        QuizOption(text: 'TypeError — you must check for null before accessing properties', correct: false),
        QuizOption(text: 'false — null access evaluates to false', correct: false),
      ],
    ),
    Quiz(
      question: 'What does the expression 5 && "hello" evaluate to?',
      options: [
        QuizOption(text: '"hello" — && returns the last value when all values are truthy', correct: true),
        QuizOption(text: 'true — && always returns a boolean', correct: false),
        QuizOption(text: '5 — && returns the first value', correct: false),
        QuizOption(text: 'NaN — mixing number and string with && produces NaN', correct: false),
      ],
    ),
  ],
);
