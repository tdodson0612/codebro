import '../../models/lesson.dart';
import '../../models/quiz.dart';

final jsLesson05 = Lesson(
  language: 'JavaScript',
  title: 'Strings Deep Dive',
  content: """
🎯 METAPHOR:
A JavaScript string is like a pearl necklace — a sequence
of characters strung together in order, where each pearl
has a numbered position starting at 0. You can look at any
pearl (index access), count the pearls (length), find a
specific pattern (search methods), create a new necklace
with some pearls changed (replace/slice), and much more.
But like a real pearl necklace, you can't change a pearl
in place — strings are immutable. Every transformation
creates a brand new necklace.

📖 EXPLANATION:
Strings are one of the most-used types in JavaScript.
They are immutable sequences of UTF-16 characters.

─────────────────────────────────────
STRING CREATION:
─────────────────────────────────────
  "double quotes"           — traditional
  'single quotes'           — traditional (same behavior)
  \`template literals\`      — modern, multi-line, interpolation

  Template literals:
  const name = "World";
  const msg = \`Hello, \${name}!\`;          // interpolation
  const multi = \`Line 1
  Line 2
  Line 3\`;                                 // multi-line
  const math = \`2 + 2 = \${2 + 2}\`;        // expressions

─────────────────────────────────────
ACCESSING CHARACTERS:
─────────────────────────────────────
  "hello"[0]           → "h"
  "hello".at(0)        → "h"
  "hello".at(-1)       → "o"  ← at() supports negative index
  "hello".charAt(1)    → "e"
  "hello".charCodeAt(0)→ 104  (UTF-16 code unit)
  "hello".length       → 5   (property, not method)

─────────────────────────────────────
SEARCHING:
─────────────────────────────────────
  str.indexOf("lo")         → 3 (first index, or -1)
  str.lastIndexOf("l")      → 3 (last index, or -1)
  str.includes("ell")       → true/false
  str.startsWith("hel")     → true/false
  str.endsWith("lo")        → true/false
  str.search(/pattern/)     → index or -1 (regex)
  str.match(/pattern/g)     → array of matches or null
  str.matchAll(/pattern/g)  → iterator of matches

─────────────────────────────────────
EXTRACTING:
─────────────────────────────────────
  str.slice(start, end)       → from start to end (exclusive)
  str.slice(-3)               → last 3 characters
  str.substring(start, end)   → similar to slice (no negatives)
  str.at(index)               → supports negative index (ES2022)

─────────────────────────────────────
TRANSFORMING:
─────────────────────────────────────
  str.toUpperCase()           → "HELLO"
  str.toLowerCase()           → "hello"
  str.trim()                  → remove leading/trailing whitespace
  str.trimStart()             → remove leading whitespace
  str.trimEnd()               → remove trailing whitespace
  str.padStart(n, "0")        → pad to length n on left
  str.padEnd(n, ".")          → pad to length n on right
  str.repeat(3)               → "abcabcabc"
  str.replace("a", "b")       → replace first occurrence
  str.replaceAll("a", "b")    → replace all occurrences
  str.replace(/regex/, fn)    → replace with function
  str.normalize()             → Unicode normalization

─────────────────────────────────────
SPLITTING AND JOINING:
─────────────────────────────────────
  str.split(",")              → array of parts
  str.split("")               → array of chars
  str.split(/\s+/)            → split on whitespace
  arr.join(", ")              → join array into string

─────────────────────────────────────
CHECKING:
─────────────────────────────────────
  str.includes("pattern")
  str.startsWith("prefix")
  str.endsWith("suffix")
  /regex/.test(str)           → true/false regex test

─────────────────────────────────────
TEMPLATE LITERAL ADVANCED:
─────────────────────────────────────
  // Tagged templates (advanced):
  const highlight = (strings, ...values) => {
    return strings.reduce((result, str, i) =>
      result + str + (values[i] !== undefined
        ? \`<b>\${values[i]}</b>\` : ""), "");
  };
  const result = highlight\`Hello \${name}, you are \${age}!\`;

  // String.raw — no escape processing:
  String.raw\`C:\\Users\\terry\` → "C:\\\\Users\\\\terry"

─────────────────────────────────────
USEFUL PATTERNS:
─────────────────────────────────────
  // Capitalize first letter:
  str[0].toUpperCase() + str.slice(1)

  // Check if numeric:
  !isNaN(str) && str.trim() !== ""

  // Reverse a string:
  [...str].reverse().join("")

  // Count occurrences:
  str.split("target").length - 1

  // Truncate with ellipsis:
  str.length > 50 ? str.slice(0, 47) + "..." : str

💻 CODE:
// ─── CREATION ─────────────────────────────────────────
console.log("=== String Creation ===");
const single = 'Hello';
const double = "World";
const template = \`\${single}, \${double}!\`;  // interpolation

// Multi-line template literals
const poem = \`
Roses are red,
Violets are blue,
JavaScript is awesome,
And so are you!
\`.trim();
console.log(poem);

// Expressions in templates
const a = 5, b = 10;
console.log(\`\${a} + \${b} = \${a + b}\`);    // 5 + 10 = 15
console.log(\`Is adult: \${a > 18 ? 'yes' : 'no'}\`);

// ─── ACCESSING ────────────────────────────────────────
console.log("\n=== Accessing Characters ===");
const str = "JavaScript";
console.log(str[0]);          // J
console.log(str.at(0));       // J
console.log(str.at(-1));      // t  (last char!)
console.log(str.at(-3));      // i  pt
console.log(str.length);      // 10
console.log(str.charAt(4));   // S

// ─── SEARCHING ────────────────────────────────────────
console.log("\n=== Searching ===");
const sentence = "The quick brown fox jumps over the lazy dog";
console.log(sentence.indexOf("fox"));       // 16
console.log(sentence.indexOf("cat"));       // -1
console.log(sentence.lastIndexOf("the"));   // 31
console.log(sentence.includes("quick"));    // true
console.log(sentence.startsWith("The"));    // true
console.log(sentence.endsWith("dog"));      // true
console.log(sentence.startsWith("quick", 4)); // true (from index 4)

// ─── EXTRACTING ───────────────────────────────────────
console.log("\n=== Extracting (slice) ===");
const text = "Hello, World!";
console.log(text.slice(7));        // "World!"
console.log(text.slice(7, 12));    // "World"
console.log(text.slice(-6));       // "orld!" ← last 6
console.log(text.slice(0, 5));     // "Hello"

// ─── TRANSFORMING ─────────────────────────────────────
console.log("\n=== Transforming ===");
const messy = "  Hello, World!  ";
console.log(messy.trim());                   // "Hello, World!"
console.log(messy.trimStart());              // "Hello, World!  "
console.log("hello".toUpperCase());          // "HELLO"
console.log("HELLO".toLowerCase());          // "hello"
console.log("5".padStart(4, "0"));           // "0005"
console.log("done".padEnd(8, "."));          // "done...."
console.log("ha".repeat(5));                 // "hahahahaha"
console.log("aababab".replace("ab", "X"));   // "aXabab" (first only)
console.log("aababab".replaceAll("ab", "X")); // "aXXX"

// ─── SPLIT AND JOIN ───────────────────────────────────
console.log("\n=== Split and Join ===");
const csv = "alice,bob,charlie,diana";
const names = csv.split(",");
console.log(names);                 // ['alice', 'bob', 'charlie', 'diana']
console.log(names.join(" | "));     // "alice | bob | charlie | diana"

const chars = "hello".split("");
console.log(chars);                 // ['h', 'e', 'l', 'l', 'o']

// ─── TEMPLATE LITERAL POWER ───────────────────────────
console.log("\n=== Template Literal Power ===");
const user = { name: "Terry", score: 95, level: "Expert" };
const card = \`
  ┌─────────────────────────┐
  │  Player: \${user.name.padEnd(16)}│
  │  Score:  \${String(user.score).padEnd(16)}│
  │  Level:  \${user.level.padEnd(16)}│
  └─────────────────────────┘
\`.trim();
console.log(card);

// ─── COMMON PATTERNS ──────────────────────────────────
console.log("\n=== Common Patterns ===");

// Capitalize first letter
const capitalize = s => s.charAt(0).toUpperCase() + s.slice(1);
console.log(capitalize("hello world"));  // "Hello world"

// Reverse a string (handles Unicode correctly)
const reverse = s => [...s].reverse().join("");
console.log(reverse("JavaScript"));     // "tpircSavaJ"

// Truncate with ellipsis
const truncate = (s, n) => s.length > n ? s.slice(0, n - 3) + "..." : s;
console.log(truncate("This is a very long string", 15)); // "This is a ve..."

// Count occurrences
const countOccurrences = (str2, target) =>
  str2.split(target).length - 1;
console.log(countOccurrences("banana", "an")); // 2

// Slug from title
const slugify = s => s.toLowerCase()
  .trim()
  .replace(/[^\w\s-]/g, "")
  .replace(/[\s_-]+/g, "-");
console.log(slugify("Hello World! This is a Test")); // "hello-world-this-is-a-test"

// ─── STRING.RAW ───────────────────────────────────────
console.log("\n=== String.raw ===");
console.log(String.raw\`C:\\Users\\terry\\Documents\`);
// C:\\Users\\terry\\Documents (no escape processing)

📝 KEY POINTS:
✅ Template literals (\`...\`) support interpolation, multi-line, and expressions
✅ str.at(-1) is the modern way to get the last character (supports negative indices)
✅ slice(start, end) is the go-to extraction method — supports negative indices
✅ includes(), startsWith(), endsWith() return boolean — simpler than indexOf() checks
✅ trim(), trimStart(), trimEnd() handle whitespace removal
✅ replace() only replaces the first match; replaceAll() replaces all
✅ split() + join() is the classic way to transform strings via arrays
✅ [...str].reverse().join("") correctly handles Unicode multi-byte characters
❌ Strings are IMMUTABLE — all methods return new strings, never modify in place
❌ Don't use substring() — slice() is more consistent and supports negative indices
❌ str[str.length-1] works but str.at(-1) is cleaner for last character
""",
  quiz: [
    Quiz(
      question: 'What does "hello".at(-1) return?',
      options: [
        QuizOption(text: '"o" — at() supports negative indices, where -1 is the last character', correct: true),
        QuizOption(text: 'undefined — negative indices are not supported', correct: false),
        QuizOption(text: '"h" — negative index wraps around to the beginning', correct: false),
        QuizOption(text: 'TypeError — at() requires a non-negative integer', correct: false),
      ],
    ),
    Quiz(
      question: 'What is the difference between replace() and replaceAll()?',
      options: [
        QuizOption(text: 'replace() only replaces the first occurrence; replaceAll() replaces every occurrence', correct: true),
        QuizOption(text: 'replace() is for strings; replaceAll() is for regular expressions only', correct: false),
        QuizOption(text: 'They are identical — replaceAll() is just an alias', correct: false),
        QuizOption(text: 'replace() modifies the string in place; replaceAll() returns a new string', correct: false),
      ],
    ),
    Quiz(
      question: 'Why should you use [...str].reverse().join("") instead of str.split("").reverse().join("") to reverse a string?',
      options: [
        QuizOption(text: 'Spread operator [...str] correctly handles multi-byte Unicode characters (emoji, etc.); split("") splits by code unit which can break them', correct: true),
        QuizOption(text: 'The spread version is faster for long strings', correct: false),
        QuizOption(text: 'split("") does not produce an array; spread is required', correct: false),
        QuizOption(text: 'They are equivalent — there is no practical difference', correct: false),
      ],
    ),
  ],
);
