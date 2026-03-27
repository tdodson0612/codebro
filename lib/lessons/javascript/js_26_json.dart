import '../../models/lesson.dart';
import '../../models/quiz.dart';

final jsLesson26 = Lesson(
  language: 'JavaScript',
  title: 'JSON: Parse, Stringify, and Beyond',
  content: """
🎯 METAPHOR:
JSON is like a universal shipping container standard
for data. When you want to send a JavaScript object
across the internet to a server in Python, a database
in Java, or an app in Swift — they all speak different
languages. But they ALL understand JSON. JSON.stringify()
is the shrink-wrap machine: it wraps your JavaScript
object into a flat text container safe for shipping.
JSON.parse() is the unboxing machine on the other end:
it reconstructs the contents from the container.
The reviver function is the customs inspector who can
transform specific items as they're unboxed — converting
date strings back into real Date objects, for example.

📖 EXPLANATION:
JSON (JavaScript Object Notation) is a lightweight
data-interchange format. It's a text format that's both
human-readable and easy for machines to parse.

─────────────────────────────────────
JSON SYNTAX RULES:
─────────────────────────────────────
  ✅ Keys MUST be double-quoted strings
  ✅ String values use double quotes
  ✅ Numbers, booleans, null, arrays, objects
  ❌ No undefined, functions, Symbols, BigInt
  ❌ No comments (// or /* */)
  ❌ No trailing commas

  Valid JSON:
  {
    "name": "Alice",
    "age": 28,
    "active": true,
    "scores": [95, 87, 92],
    "address": { "city": "London" },
    "notes": null
  }

─────────────────────────────────────
JSON.stringify() — JavaScript → JSON string:
─────────────────────────────────────
  JSON.stringify(value)
  JSON.stringify(value, replacer)
  JSON.stringify(value, replacer, space)

  // space for pretty printing:
  JSON.stringify(obj, null, 2)    // 2 spaces indent
  JSON.stringify(obj, null, '\\t') // tab indent

  // What gets OMITTED:
  → undefined values → omitted from objects, null in arrays
  → Function values  → omitted
  → Symbol keys      → omitted
  → Symbol values    → omitted
  → BigInt          → throws TypeError!

─────────────────────────────────────
JSON.stringify() REPLACER:
─────────────────────────────────────
  // Array of keys to include (whitelist):
  JSON.stringify(obj, ['name', 'age'])

  // Function to transform:
  JSON.stringify(obj, (key, value) => {
      if (typeof value === 'number') return value * 2;
      return value;   // keep everything else
  });

─────────────────────────────────────
JSON.parse() — JSON string → JavaScript:
─────────────────────────────────────
  JSON.parse(text)
  JSON.parse(text, reviver)

  // Reviver transforms values as they're parsed:
  JSON.parse(jsonString, (key, value) => {
      if (key === 'date') return new Date(value);
      return value;
  });

─────────────────────────────────────
toJSON() — custom serialization:
─────────────────────────────────────
  class User {
      constructor(name, password) {
          this.name = name;
          this.password = password;   // sensitive!
      }

      toJSON() {
          return { name: this.name };  // exclude password
      }
  }

  JSON.stringify(new User("Alice", "secret"))
  // '{"name":"Alice"}' — password excluded!

─────────────────────────────────────
DEEP CLONE WITH JSON (simple cases):
─────────────────────────────────────
  // Works for JSON-serializable data:
  const clone = JSON.parse(JSON.stringify(original));

  // ❌ Doesn't work for:
  // → Dates (become strings)
  // → undefined values
  // → Functions
  // → Circular references (throws)

  // ✅ Better: structuredClone() (modern):
  const clone = structuredClone(original);
  // Handles Dates, ArrayBuffers, circular refs, etc.

─────────────────────────────────────
JSON5 / JSONC (not standard JS but common):
─────────────────────────────────────
  JSON5 allows:
  → Single-quoted strings
  → Trailing commas
  → Comments
  → Unquoted keys
  Used in: package.json5, tsconfig.json (comments)

─────────────────────────────────────
COMMON JSON PITFALLS:
─────────────────────────────────────
  JSON.parse('{"a": undefined}')  // SyntaxError
  JSON.parse("{'a': 1}")          // SyntaxError — single quotes!
  JSON.stringify({ fn: () => {} }) // '{}' — function silently dropped
  JSON.stringify(undefined)        // returns undefined (not a string)
  JSON.stringify(NaN)              // 'null'
  JSON.stringify(Infinity)         // 'null'
  JSON.stringify({ a: 1n })        // TypeError: BigInt not serializable

💻 CODE:
// ─── BASIC STRINGIFY / PARSE ──────────────────────────
console.log("=== JSON.stringify / JSON.parse ===");

const user = {
    id: 1,
    name: "Alice Chen",
    email: "alice@example.com",
    age: 28,
    active: true,
    scores: [95, 87, 92],
    address: { city: "London", country: "UK" },
    tags: ["admin", "user"],
    notes: null,
    // These will be OMITTED:
    password: undefined,
    login: () => "logged in",
};

const json = JSON.stringify(user);
console.log("  Compact:", json);

const pretty = JSON.stringify(user, null, 2);
console.log("  Pretty-printed:");
console.log(pretty.split('\n').slice(0, 8).map(l => "  " + l).join('\n'));
console.log("  ...");

const parsed = JSON.parse(json);
console.log("  Parsed name:", parsed.name);
console.log("  Parsed scores:", parsed.scores);
console.log("  Parsed login:", parsed.login);  // undefined — functions omitted

// ─── WHAT GETS OMITTED / TRANSFORMED ─────────────────
console.log("\n=== Serialization Edge Cases ===");

const edgeCases = {
    undef: undefined,       // omitted from object
    fn: () => {},           // omitted from object
    sym: Symbol("test"),    // omitted from object
    nan: NaN,               // → null
    inf: Infinity,          // → null
    negInf: -Infinity,      // → null
    date: new Date("2024-01-15"),  // → ISO string
    regex: /hello/gi,       // → {}
    zero: 0,                // → 0
    empty: "",              // → ""
    nullVal: null,          // → null
    nested: { fn: () => {}, num: 42 },  // fn omitted, num kept
};

const serialized = JSON.stringify(edgeCases, null, 2);
console.log("  Serialized:");
serialized.split('\n').forEach(l => console.log("  " + l));

// Arrays with undefined/functions:
const arr = [1, undefined, 3, null, () => {}, 6];
console.log("  Array with undefined/fn:", JSON.stringify(arr));
// undefined and function become null in arrays

// ─── REPLACER FUNCTION ────────────────────────────────
console.log("\n=== Replacer Function ===");

const data = {
    name: "Bob",
    password: "secret123",
    token: "abc.def.ghi",
    age: 25,
    salary: 75000,
    role: "admin",
};

// Redact sensitive fields:
const redacted = JSON.stringify(data, (key, value) => {
    if (["password", "token"].includes(key)) return "***REDACTED***";
    return value;
}, 2);
console.log("  Redacted:");
redacted.split('\n').forEach(l => console.log("  " + l));

// Whitelist (array replacer):
const filtered = JSON.stringify(data, ["name", "age", "role"], 2);
console.log("  Whitelist (name, age, role):");
filtered.split('\n').forEach(l => console.log("  " + l));

// Numeric transform:
const prices = { regular: 100, sale: 75, tax: 8 };
const doubled = JSON.stringify(prices, (key, value) =>
    typeof value === 'number' ? value * 2 : value
);
console.log("  Doubled prices:", doubled);

// ─── REVIVER FUNCTION ─────────────────────────────────
console.log("\n=== Reviver Function ===");

const apiResponse = `{
    "id": 1,
    "name": "Alice",
    "createdAt": "2024-01-15T10:30:00.000Z",
    "updatedAt": "2024-03-20T14:15:00.000Z",
    "lastLogin": "2024-03-22T09:00:00.000Z"
}`;

const withDates = JSON.parse(apiResponse, (key, value) => {
    // Convert ISO date strings back to Date objects:
    if (typeof value === 'string' && /^\\d{4}-\\d{2}-\\d{2}T/.test(value)) {
        return new Date(value);
    }
    return value;
});

console.log("  createdAt is Date:", withDates.createdAt instanceof Date);
console.log("  createdAt:", withDates.createdAt.toLocaleDateString());
console.log("  name is string:", typeof withDates.name === 'string');

// ─── toJSON() CUSTOM SERIALIZATION ────────────────────
console.log("\n=== toJSON() Custom Serialization ===");

class ApiUser {
    #password;

    constructor({ id, name, email, password, role }) {
        this.id       = id;
        this.name     = name;
        this.email    = email;
        this.#password = password;
        this.role     = role;
        this.createdAt = new Date();
    }

    toJSON() {
        return {
            id:        this.id,
            name:      this.name,
            email:     this.email,
            role:      this.role,
            createdAt: this.createdAt.toISOString(),
            // password intentionally excluded!
        };
    }
}

const apiUser = new ApiUser({
    id: 1, name: "Alice", email: "alice@example.com",
    password: "hunter2", role: "admin"
});

const serializedUser = JSON.stringify(apiUser, null, 2);
console.log("  Serialized (no password):");
serializedUser.split('\n').forEach(l => console.log("  " + l));

// ─── DEEP CLONE COMPARISON ────────────────────────────
console.log("\n=== Deep Clone Methods ===");

const original = {
    name: "Alice",
    scores: [1, 2, 3],
    nested: { a: 1 },
    date: new Date("2024-01-15"),
};

// JSON clone (basic):
const jsonClone = JSON.parse(JSON.stringify(original));
jsonClone.scores.push(4);
jsonClone.nested.b = 2;

console.log("  Original scores:", original.scores);  // unchanged ✅
console.log("  Clone scores:", jsonClone.scores);      // [1,2,3,4]
console.log("  Original date type:", original.date instanceof Date);      // true
console.log("  JSON clone date type:", jsonClone.date instanceof Date);   // false — became string!

// structuredClone (better):
const deepClone = structuredClone(original);
console.log("  structuredClone date type:", deepClone.date instanceof Date); // true ✅

// ─── JSON VALIDATION ──────────────────────────────────
console.log("\n=== JSON Validation ===");

function isValidJSON(str) {
    try {
        JSON.parse(str);
        return true;
    } catch {
        return false;
    }
}

const tests = [
    '{"name":"Alice"}',
    "{'name':'Alice'}",  // single quotes — invalid
    '{"a": 1,}',         // trailing comma — invalid
    '{"a": undefined}',  // undefined — invalid
    '[1, 2, 3]',
    '"just a string"',
    'true',
    '42',
    'null',
];

tests.forEach(t => {
    const short = t.length > 25 ? t.slice(0, 22) + "..." : t;
    console.log(\` \${
isValidJSON(t) ? '✅' : '❌'}\${
short}\`);
});

📝 KEY POINTS:
✅ JSON.stringify() converts JS to JSON text; JSON.parse() converts JSON text to JS
✅ JSON keys MUST be double-quoted strings — single quotes are invalid JSON
✅ undefined, functions, and Symbols are SILENTLY OMITTED from JSON output
✅ NaN and Infinity become null in JSON output
✅ Dates become ISO 8601 strings — use a reviver to restore them as Date objects
✅ The replacer function lets you transform or exclude values during serialization
✅ The reviver function lets you transform values during parsing
✅ Implement toJSON() on a class to control its JSON representation
✅ Use structuredClone() for deep cloning — it handles Dates, circular refs, and more
❌ JSON.stringify(bigint) throws a TypeError — BigInt is not JSON-serializable
❌ JSON.parse("{'a':1}") throws SyntaxError — single quotes are invalid JSON
❌ JSON.stringify(undefined) returns undefined (not a string) — use null instead
❌ JSON deep-clone won't preserve Date objects — they become strings
""",
  quiz: [
    Quiz(question: 'What happens to undefined values when you JSON.stringify() an object?', options: [
      QuizOption(text: 'They are silently omitted from the JSON output — the key disappears entirely', correct: true),
      QuizOption(text: 'They are converted to null in the JSON output', correct: false),
      QuizOption(text: 'JSON.stringify() throws a TypeError for undefined values', correct: false),
      QuizOption(text: 'They are converted to the string "undefined"', correct: false),
    ]),
    Quiz(question: 'What is the purpose of the reviver function in JSON.parse()?', options: [
      QuizOption(text: 'It transforms parsed values as they are reconstructed — useful for converting date strings back to Date objects', correct: true),
      QuizOption(text: 'It validates the JSON string before parsing to catch syntax errors', correct: false),
      QuizOption(text: 'It reverts the parse operation if any value fails validation', correct: false),
      QuizOption(text: 'It provides default values for missing keys during parsing', correct: false),
    ]),
    Quiz(question: 'Why is structuredClone() better than JSON.parse(JSON.stringify()) for deep cloning?', options: [
      QuizOption(text: 'structuredClone() correctly handles Dates, ArrayBuffers, circular references, and more types that JSON round-trips incorrectly', correct: true),
      QuizOption(text: 'structuredClone() is faster because it uses binary format internally', correct: false),
      QuizOption(text: 'structuredClone() works with undefined and function values that JSON cannot handle', correct: false),
      QuizOption(text: 'JSON.parse(JSON.stringify()) only creates shallow copies', correct: false),
    ]),
  ],
);
