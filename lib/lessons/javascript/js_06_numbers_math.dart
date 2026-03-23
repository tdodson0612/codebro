import '../../models/lesson.dart';
import '../../models/quiz.dart';

final jsLesson06 = Lesson(
  language: 'JavaScript',
  title: 'Numbers, Math, and BigInt',
  content: """
🎯 METAPHOR:
JavaScript's number system is like a ruler that's incredibly
precise in the middle but fuzzy at both ends. For everyday
numbers between -(2^53) and 2^53, it's perfectly accurate.
But try to represent 0.1 as a binary fraction and the ruler
gets wobbly — just like trying to write 1/3 as a finite
decimal (0.333...). The Math object is a scientific
calculator strapped to the side of this ruler — square
roots, trigonometry, random numbers, rounding — all the
functions you'd expect without needing a library.
BigInt is a new, infinitely long ruler for when normal
numbers just aren't big enough.

📖 EXPLANATION:
JavaScript has ONE number type: IEEE 754 64-bit double-precision
floating point. This covers both integers and decimals.

─────────────────────────────────────
NUMBER LITERALS:
─────────────────────────────────────
  42          integer
  3.14        float
  1_000_000   numeric separator (ES2021) — same as 1000000
  0xFF        hexadecimal (255)
  0b1010      binary (10)
  0o17        octal (15)
  1e6         scientific: 1,000,000
  1.5e-3      scientific: 0.0015

─────────────────────────────────────
NUMBER STATIC PROPERTIES:
─────────────────────────────────────
  Number.MAX_SAFE_INTEGER    → 9007199254740991  (2^53 - 1)
  Number.MIN_SAFE_INTEGER    → -9007199254740991
  Number.MAX_VALUE           → ~1.79e+308
  Number.MIN_VALUE           → ~5e-324 (smallest positive)
  Number.EPSILON             → ~2.22e-16 (smallest rounding diff)
  Number.POSITIVE_INFINITY   → Infinity
  Number.NEGATIVE_INFINITY   → -Infinity
  Number.NaN                 → NaN

─────────────────────────────────────
NUMBER METHODS:
─────────────────────────────────────
  Number.isInteger(n)       → true if n is an integer
  Number.isFinite(n)        → true if finite (not Inf/NaN)
  Number.isNaN(n)           → true only if exactly NaN
  Number.isSafeInteger(n)   → within ±2^53

  num.toFixed(2)            → "3.14" (string, rounded)
  num.toPrecision(4)        → "3.142" (4 significant digits)
  num.toString(16)          → hex string
  num.toString(2)           → binary string
  num.toString(8)           → octal string

─────────────────────────────────────
Math OBJECT — ESSENTIAL METHODS:
─────────────────────────────────────
  Math.abs(x)              → absolute value
  Math.round(x)            → nearest integer
  Math.floor(x)            → round down
  Math.ceil(x)             → round up
  Math.trunc(x)            → remove decimal (toward 0)
  Math.sign(x)             → -1, 0, or 1

  Math.max(...arr)          → largest value
  Math.min(...arr)          → smallest value
  Math.clamp(x, lo, hi)    → NOT in JS — use Math.min/max

  Math.pow(base, exp)       → base^exp (use ** instead)
  Math.sqrt(x)              → square root
  Math.cbrt(x)              → cube root
  Math.hypot(a, b)          → sqrt(a² + b²)

  Math.log(x)              → natural log (ln)
  Math.log2(x)             → log base 2
  Math.log10(x)            → log base 10
  Math.exp(x)              → e^x

  Math.sin(x), .cos(x), .tan(x)   → trig (radians)
  Math.asin(x), .acos(x), .atan(x) → inverse trig
  Math.atan2(y, x)         → angle from x-axis

  Math.random()            → [0.0, 1.0) random float
  Math.PI                  → 3.14159...
  Math.E                   → 2.71828...
  Math.SQRT2               → √2

─────────────────────────────────────
BIGINT — ES2020:
─────────────────────────────────────
  For integers beyond Number.MAX_SAFE_INTEGER.

  const big = 9007199254740991n;   // append n
  const sum = big + 1n;            // 9007199254740992n

  BigInt cannot be mixed with regular numbers:
  1n + 1   → TypeError
  1n + 1n  → 2n ✅

  BigInt.asIntN(64, value)   → signed 64-bit BigInt
  BigInt.asUintN(64, value)  → unsigned 64-bit BigInt

─────────────────────────────────────
FLOAT PRECISION PATTERNS:
─────────────────────────────────────
  // Safe float comparison:
  Math.abs(0.1 + 0.2 - 0.3) < Number.EPSILON  // true

  // Round to N decimal places:
  Math.round(num * 100) / 100  // 2 decimal places

  // For financial: use toFixed then parse:
  parseFloat((0.1 + 0.2).toFixed(2)) // 0.3

  // Or use an integer representation (cents):
  const priceInCents = 199;  //\$1.99 stored as 199

💻 CODE:
// ─── NUMBER LITERALS ──────────────────────────────────
console.log("=== Number Literals ===");
console.log(1_000_000);    // 1000000 (readability separator)
console.log(0xFF);         // 255 (hex)
console.log(0b1010);       // 10  (binary)
console.log(0o17);         // 15  (octal)
console.log(1.5e3);        // 1500
console.log(1.5e-3);       // 0.0015

// ─── NUMBER STATICS ───────────────────────────────────
console.log("\n=== Number Properties ===");
console.log(Number.MAX_SAFE_INTEGER); // 9007199254740991
console.log(Number.EPSILON);           // 2.220446049250313e-16
console.log(Number.isInteger(3.0));    // true
console.log(Number.isInteger(3.5));    // false
console.log(Number.isNaN(NaN));        // true
console.log(Number.isNaN("NaN"));      // false (unlike global isNaN!)
console.log(Number.isFinite(Infinity));// false
console.log(Number.isSafeInteger(Number.MAX_SAFE_INTEGER)); // true

// ─── NUMBER METHODS ───────────────────────────────────
console.log("\n=== Number Instance Methods ===");
const pi = 3.14159265;
console.log(pi.toFixed(2));       // "3.14"
console.log(pi.toFixed(4));       // "3.1416" (rounds)
console.log(pi.toPrecision(5));   // "3.1416"
console.log((255).toString(16));  // "ff" (hex)
console.log((10).toString(2));    // "1010" (binary)
console.log((255).toString(8));   // "377" (octal)

// ─── MATH OBJECT ──────────────────────────────────────
console.log("\n=== Math Object ===");
console.log(Math.PI);             // 3.141592653589793
console.log(Math.E);              // 2.718281828459045
console.log(Math.abs(-42));       // 42
console.log(Math.round(4.6));     // 5
console.log(Math.round(4.4));     // 4
console.log(Math.floor(4.9));     // 4
console.log(Math.ceil(4.1));      // 5
console.log(Math.trunc(4.9));     // 4 (truncate toward 0)
console.log(Math.trunc(-4.9));    // -4 (not -5)
console.log(Math.sign(-5));       // -1
console.log(Math.sign(0));        //  0
console.log(Math.sign(5));        //  1

console.log(Math.max(1, 5, 3, 9, 2));  // 9
console.log(Math.min(1, 5, 3, 9, 2));  // 1
const nums = [3, 1, 4, 1, 5, 9];
console.log(Math.max(...nums));         // 9 (spread!)
console.log(Math.min(...nums));         // 1

console.log(Math.sqrt(144));    // 12
console.log(Math.cbrt(27));     // 3
console.log(Math.hypot(3, 4));  // 5 (Pythagoras)
console.log(2 ** 10);           // 1024 (prefer ** over Math.pow)

// Logarithms
console.log(Math.log(Math.E)); // 1
console.log(Math.log2(8));     // 3
console.log(Math.log10(1000)); // 3

// Trig (in radians)
console.log(Math.sin(Math.PI / 2));  // 1
console.log(Math.cos(0));            // 1
console.log(Math.atan2(1, 1));       // 0.785... (45°)

// ─── RANDOM NUMBERS ───────────────────────────────────
console.log("\n=== Random Numbers ===");
// [0, 1)
console.log(Math.random());

// Integer in [min, max] inclusive:
const randomInt = (min, max) =>
  Math.floor(Math.random() * (max - min + 1)) + min;
console.log(randomInt(1, 6));    // dice roll
console.log(randomInt(1, 100));  // 1–100

// Random item from array:
const items = ["apple", "banana", "cherry"];
console.log(items[randomInt(0, items.length - 1)]);

// ─── FLOAT PRECISION ──────────────────────────────────
console.log("\n=== Float Precision ===");
console.log(0.1 + 0.2);                        // 0.30000000000000004
console.log(0.1 + 0.2 === 0.3);               // false
console.log(Math.abs(0.1 + 0.2 - 0.3) < Number.EPSILON); // true ✅

// Round to 2 decimal places:
const round2 = n => Math.round(n * 100) / 100;
console.log(round2(3.14159));  // 3.14
console.log(round2(2.005));    // 2  ← still imprecise!
console.log(parseFloat((2.005).toFixed(2))); // 2  

// ─── BIGINT ───────────────────────────────────────────
console.log("\n=== BigInt ===");
const maxSafe = BigInt(Number.MAX_SAFE_INTEGER);
console.log(maxSafe);          // 9007199254740991n
console.log(maxSafe + 1n);     // 9007199254740992n ✅
console.log(maxSafe + 2n);     // 9007199254740993n ✅

// Factorial of 100:
const factorial = n => n <= 1n ? 1n : n * factorial(n - 1n);
console.log(factorial(20n));   // 2432902008176640000n

// Cannot mix BigInt and Number:
try {
  const mixed = 1n + 1;
} catch (e) {
  console.log("Error:", e.message); // Cannot mix BigInt and other types
}

// Convert:
console.log(Number(42n));   // 42
console.log(BigInt(42));    // 42n

📝 KEY POINTS:
✅ JavaScript has ONE number type: 64-bit float — integers and decimals share the same type
✅ Use 1_000_000 numeric separators for readability (ES2021)
✅ Number.isNaN() is reliable; global isNaN() coerces its argument first — avoid global
✅ Math.floor(), Math.ceil(), Math.round(), Math.trunc() — four rounding strategies
✅ Math.random() returns [0, 1) — use Math.floor(Math.random() * (max-min+1)) + min for range
✅ For float equality, use Math.abs(a - b) < Number.EPSILON
✅ BigInt handles integers beyond 2^53 — suffix with n, cannot mix with Number
✅ toFixed() returns a STRING — use parseFloat() if you need a number back
❌ 0.1 + 0.2 !== 0.3 in JavaScript — floating point is not exact
❌ Never use global isNaN() — use Number.isNaN() instead
❌ Cannot use BigInt with regular numbers without explicit conversion
""",
  quiz: [
    Quiz(
      question: 'What is the correct way to generate a random integer between 1 and 10 inclusive?',
      options: [
        QuizOption(text: 'Math.floor(Math.random() * 10) + 1', correct: true),
        QuizOption(text: 'Math.random() * 10', correct: false),
        QuizOption(text: 'Math.round(Math.random() * 10)', correct: false),
        QuizOption(text: 'Math.ceil(Math.random() * 9)', correct: false),
      ],
    ),
    Quiz(
      question: 'Why does Number.isNaN("NaN") return false while the global isNaN("NaN") returns true?',
      options: [
        QuizOption(text: 'Number.isNaN() only returns true for the actual NaN value; global isNaN() first coerces its argument to a number', correct: true),
        QuizOption(text: 'Number.isNaN() checks the type first; strings are never NaN by definition', correct: false),
        QuizOption(text: 'They have a bug — both should return true for the string "NaN"', correct: false),
        QuizOption(text: 'isNaN() is stricter than Number.isNaN() for string inputs', correct: false),
      ],
    ),
    Quiz(
      question: 'What does (3.14159).toFixed(2) return?',
      options: [
        QuizOption(text: '"3.14" as a string — toFixed always returns a string, not a number', correct: true),
        QuizOption(text: '3.14 as a number with 2 decimal places', correct: false),
        QuizOption(text: '3 as an integer (toFixed rounds to the nearest integer)', correct: false),
        QuizOption(text: '"3.142" — it rounds to 3 significant digits', correct: false),
      ],
    ),
  ],
);
