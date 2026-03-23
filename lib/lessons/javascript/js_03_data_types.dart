import '../../models/lesson.dart';
import '../../models/quiz.dart';

final jsLesson03 = Lesson(
  language: 'JavaScript',
  title: 'Data Types and Type Coercion',
  content: """
🎯 METAPHOR:
JavaScript's type system is like a very accommodating
chef who will try to work with WHATEVER you bring.
Hand them a number and ask for it as a string? They'll
convert it without complaint. Hand them null and ask for
a number? They'll give you 0. Hand them an empty string
and ask for a boolean? They'll give you false. This
eagerness to cooperate is called TYPE COERCION, and it's
both JavaScript's greatest magic trick and its most
notorious source of bugs. Understanding the rules of
coercion is the difference between a developer who
curses JavaScript and one who works with it fluently.

📖 EXPLANATION:
JavaScript has 8 data types: 7 primitives and 1 object type.

─────────────────────────────────────
THE 8 DATA TYPES:
─────────────────────────────────────
  PRIMITIVES (immutable, compared by value):
  1. string      → "hello", 'world', \`template\`
  2. number      → 42, 3.14, NaN, Infinity
  3. bigint      → 9007199254740991n (huge integers)
  4. boolean     → true, false
  5. undefined   → variable declared but not assigned
  6. null        → intentional absence of value
  7. symbol      → unique identifier (Symbol("key"))

  OBJECT (mutable, compared by reference):
  8. object      → {}, [], functions, Date, Map, etc.

─────────────────────────────────────
STRINGS:
─────────────────────────────────────
  "double quotes"
  'single quotes'
  \`template literal with \${expression}\`

  Immutable: you cannot change characters in place.
  .length      → number of characters
  "hi"[0]      → "h" (indexed access)

─────────────────────────────────────
NUMBERS:
─────────────────────────────────────
  JavaScript has ONLY ONE numeric type: 64-bit float.
  All numbers are IEEE 754 doubles:
  42, 3.14, -100, 0.1 + 0.2 = 0.30000000000000004 ← precision!

  Special values:
  NaN         → "Not a Number" (result of invalid math)
  Infinity    → positive infinity
  -Infinity   → negative infinity
  -0          → negative zero (yes, JS has this)

  typeof NaN === "number" ← confusing but true
  NaN !== NaN ← NaN is the only value not equal to itself
  Number.isNaN(NaN) → true (reliable check)

─────────────────────────────────────
UNDEFINED vs NULL:
─────────────────────────────────────
  undefined → "this was never assigned"
  → Default value for uninitialized variables
  → Function returns undefined if no return statement
  → Accessing a non-existent property

  null → "intentionally empty"
  → Developer explicitly set to "no value"
  → Represents intentional absence

  undefined == null  → true  (loose equality)
  undefined === null → false (strict equality)

─────────────────────────────────────
TYPE COERCION — explicit:
─────────────────────────────────────
  String(42)           → "42"
  String(true)         → "true"
  String(null)         → "null"
  String(undefined)    → "undefined"

  Number("42")         → 42
  Number("")           → 0
  Number("abc")        → NaN
  Number(true)         → 1
  Number(false)        → 0
  Number(null)         → 0
  Number(undefined)    → NaN

  Boolean(0)           → false
  Boolean("")          → false
  Boolean(null)        → false
  Boolean(undefined)   → false
  Boolean(NaN)         → false
  Boolean("0")         → true  ← "0" is truthy!
  Boolean([])          → true  ← empty array is truthy!
  Boolean({})          → true  ← empty object is truthy!

─────────────────────────────────────
FALSY VALUES (6 total):
─────────────────────────────────────
  false, 0, -0, 0n, "", null, undefined, NaN

  Everything else is TRUTHY, including:
  "0", "false", [], {}, function(){}

─────────────────────────────────────
TYPE COERCION — implicit (the tricky part):
─────────────────────────────────────
  "5" + 3      → "53"  (+ with string = concatenation)
  "5" - 3      → 2     (- always converts to number)
  "5" * "3"    → 15    (* converts both to number)
  true + true  → 2     (booleans become 0/1)
  null + 1     → 1     (null becomes 0)
  [] + []      → ""    (arrays become empty strings)
  [] + {}      → "[object Object]"
  {} + []      → 0     (in some contexts — confusing!)

─────────────────────────────────────
== vs === (ALWAYS USE ===):
─────────────────────────────────────
  == (loose equality) performs type coercion:
  0 == false   → true
  "" == false  → true
  null == undefined → true
  1 == "1"     → true

  === (strict equality) NO coercion:
  0 === false  → false
  1 === "1"    → false
  null === undefined → false

  RULE: Always use ===. Use == only for null/undefined check.

💻 CODE:
// ─── ALL 8 TYPES ──────────────────────────────────────
console.log("=== All 8 Data Types ===");

const str   = "Hello, World!";
const num   = 42;
const big   = 9007199254740991n;
const bool  = true;
const undef = undefined;
const nul   = null;
const sym   = Symbol("mySymbol");
const obj   = { name: "Alice", scores: [95, 87] };

console.log(typeof str,  "→", str);
console.log(typeof num,  "→", num);
console.log(typeof big,  "→", big);
console.log(typeof bool, "→", bool);
console.log(typeof undef,"→", undef);
console.log(typeof nul,  "→", nul);   // "object" — JS bug!
console.log(typeof sym,  "→", sym);
console.log(typeof obj,  "→", obj);

// ─── NUMBER QUIRKS ────────────────────────────────────
console.log("\n=== Number Quirks ===");
console.log(0.1 + 0.2);           // 0.30000000000000004
console.log(0.1 + 0.2 === 0.3);   // false!
console.log(Math.abs(0.1 + 0.2 - 0.3) < Number.EPSILON); // true ✅

console.log(NaN === NaN);          // false ← unique!
console.log(Number.isNaN(NaN));    // true ✅
console.log(typeof NaN);           // "number" ← confusing but true

console.log(1 / 0);               // Infinity
console.log(-1 / 0);              // -Infinity
console.log(0 / 0);               // NaN
console.log(isFinite(Infinity));   // false
console.log(isFinite(42));         // true

console.log(Number.MAX_SAFE_INTEGER);  // 9007199254740991
console.log(Number.MIN_SAFE_INTEGER); // -9007199254740991

// BigInt for large numbers:
const bigNum = 9007199254740991n + 1n;
console.log(bigNum); // 9007199254740992n

// ─── FALSY VALUES ─────────────────────────────────────
console.log("\n=== Falsy vs Truthy ===");
const falsy = [false, 0, -0, 0n, "", null, undefined, NaN];
const truthy = ["0", "false", [], {}, -1, Infinity];

console.log("Falsy values:");
falsy.forEach(v => console.log(" ", JSON.stringify(v) ?? String(v),
  "→", Boolean(v)));

console.log("Truthy values (including empty array/object!):");
truthy.forEach(v => console.log(" ", JSON.stringify(v),
  "→", Boolean(v)));

// ─── TYPE COERCION ────────────────────────────────────
console.log("\n=== Implicit Type Coercion ===");
console.log("5" + 3);      // "53" (string concat)
console.log("5" - 3);      // 2    (numeric)
console.log("5" * "3");    // 15   (numeric)
console.log(true + true);  // 2
console.log(null + 1);     // 1    (null → 0)
console.log("" + 0);       // "0"  (string concat)

// ─── EXPLICIT CONVERSION ──────────────────────────────
console.log("\n=== Explicit Conversion ===");
console.log(Number("42"));       // 42
console.log(Number(""));         // 0
console.log(Number("abc"));      // NaN
console.log(Number(true));       // 1
console.log(Number(null));       // 0
console.log(Number(undefined));  // NaN

console.log(String(42));         // "42"
console.log(String(null));       // "null"
console.log(String(undefined));  // "undefined"

console.log(Boolean(0));         // false
console.log(Boolean(""));        // false
console.log(Boolean("0"));       // true ← watch out!
console.log(Boolean([]));        // true ← watch out!

// parseInt and parseFloat:
console.log(parseInt("42px"));      // 42 (stops at non-digit)
console.log(parseInt("0xFF", 16));  // 255 (hex)
console.log(parseFloat("3.14abc")); // 3.14

// ─── == vs === ────────────────────────────────────────
console.log("\n=== Equality: == vs === ===");
console.log(1 == "1");           // true  ← coercion
console.log(1 === "1");          // false ← no coercion ✅
console.log(null == undefined);  // true  ← intentional == use
console.log(null === undefined); // false
console.log(0 == false);         // true
console.log(0 === false);        // false

// ─── TYPE CHECKING PATTERNS ───────────────────────────
console.log("\n=== Reliable Type Checking ===");
const checkType = (val) => {
  if (val === null) return "null";
  if (Array.isArray(val)) return "array";
  return typeof val;
};

console.log(checkType("hi"));     // string
console.log(checkType(42));       // number
console.log(checkType(null));     // null (not "object"!)
console.log(checkType([]));       // array (not "object"!)
console.log(checkType({}));       // object
console.log(checkType(() => {})); // function

📝 KEY POINTS:
✅ JavaScript has 7 primitive types + object type (8 total)
✅ Primitives are compared by VALUE; objects are compared by REFERENCE
✅ NaN is the only value that is not equal to itself — use Number.isNaN() to check
✅ typeof null === "object" is a historic bug — null is NOT an object
✅ Six falsy values: false, 0, -0, 0n, "", null, undefined, NaN — everything else is truthy
✅ ALWAYS use === for equality comparison — == does type coercion which causes surprises
✅ "0" and [] are TRUTHY even though they look empty
✅ + with a string means concatenation; -, *, / always convert to numbers
❌ Never use == except for the null/undefined check (null == undefined)
❌ Don't rely on implicit coercion — be explicit with Number(), String(), Boolean()
❌ 0.1 + 0.2 !== 0.3 in JavaScript — use Number.EPSILON for float comparison
""",
  quiz: [
    Quiz(
      question: 'Which of these values is TRUTHY in JavaScript?',
      options: [
        QuizOption(text: '"0" (a string containing zero) — all non-empty strings are truthy', correct: true),
        QuizOption(text: '0 (the number zero) — falsy', correct: false),
        QuizOption(text: 'null — falsy', correct: false),
        QuizOption(text: 'undefined — falsy', correct: false),
      ],
    ),
    Quiz(
      question: 'What does "5" + 3 evaluate to in JavaScript?',
      options: [
        QuizOption(text: '"53" — the + operator concatenates when either operand is a string', correct: true),
        QuizOption(text: '8 — JavaScript converts the string to a number first', correct: false),
        QuizOption(text: 'NaN — mixing types with + produces NaN', correct: false),
        QuizOption(text: 'TypeError — you cannot add a string and a number', correct: false),
      ],
    ),
    Quiz(
      question: 'Why should you always use === instead of == in JavaScript?',
      options: [
        QuizOption(text: '== performs type coercion before comparing (1 == "1" is true); === compares without conversion and is predictable', correct: true),
        QuizOption(text: '=== is faster than == at runtime', correct: false),
        QuizOption(text: '== only works for primitive types; === works for all types', correct: false),
        QuizOption(text: 'They behave identically — === is just convention for clarity', correct: false),
      ],
    ),
  ],
);
