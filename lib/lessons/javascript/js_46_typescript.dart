import '../../models/lesson.dart';
import '../../models/quiz.dart';

final jsLesson46 = Lesson(
  language: 'JavaScript',
  title: 'JavaScript → TypeScript: Your Next Step',
  content: """
🎯 METAPHOR:
TypeScript is JavaScript with a safety harness. Imagine
building a skyscraper without blueprints — you can do it,
but you won't know if the 30th floor will fit the 29th
until you're actually on the 30th floor. TypeScript
adds the blueprints (type annotations) so the architect
(compiler) can check everything fits BEFORE construction.
The skyscraper (JavaScript output) looks identical to
one built without blueprints — TypeScript just adds
the design verification step. TypeScript IS JavaScript —
it just adds optional type annotations that get stripped
away at build time. Everything you've learned in this
JavaScript course applies 100%.

📖 EXPLANATION:
TypeScript is a typed superset of JavaScript developed
by Microsoft. It compiles to plain JavaScript.

─────────────────────────────────────
WHAT TYPESCRIPT ADDS:
─────────────────────────────────────
  ✅ Static type checking at compile time
  ✅ Better IDE autocomplete and error detection
  ✅ Interfaces and type aliases
  ✅ Enums
  ✅ Generics with full type safety
  ✅ Decorators (used heavily in Angular, NestJS)
  ✅ Access modifiers (private, protected, public)
  ✅ Abstract classes
  ✅ Namespaces

  ❌ TypeScript does NOT add:
  → New runtime features (stripped before running)
  → Performance improvements
  → New JavaScript syntax (just types)

─────────────────────────────────────
TYPE ANNOTATIONS:
─────────────────────────────────────
  // Primitive types:
  let name: string = "Alice";
  let age: number = 28;
  let active: boolean = true;
  let id: number | string = 42;   // union type
  let nothing: null = null;
  let undef: undefined = undefined;
  let anything: unknown = "could be anything";   // safer than 'any'
  let truly: never = undefined as never;         // never exists

  // Arrays:
  let scores: number[] = [95, 87, 92];
  let names: Array<string> = ["Alice", "Bob"];
  let pairs: [string, number][] = [["Alice", 95]];  // array of tuples

  // Objects:
  let user: { name: string; age: number; role?: string } = {
      name: "Alice", age: 28
  };

  // Functions:
  function add(a: number, b: number): number { return a + b; }
  const greet = (name: string): string => \`Hello,\${
name}!\`;
  const log = (msg: string): void => console.log(msg);  // void = no return

─────────────────────────────────────
INTERFACES:
─────────────────────────────────────
  interface User {
      id:        number;
      name:      string;
      email:     string;
      role?:     string;    // optional
      readonly joinedAt: Date;  // can't be changed
  }

  interface Admin extends User {
      permissions: string[];
  }

  // Function interface:
  interface Comparator<T> {
      (a: T, b: T): number;
  }

─────────────────────────────────────
TYPE ALIASES:
─────────────────────────────────────
  type UserId = number;
  type Status = 'active' | 'inactive' | 'banned';  // literal union
  type Nullable<T> = T | null;
  type Callback<T> = (data: T) => void;

  type ApiResponse<T> = {
      data: T;
      status: number;
      message: string;
  };

  // Difference: interface is extendable; type is more flexible
  type Coords = { x: number; y: number };
  type Coords3D = Coords & { z: number };   // intersection

─────────────────────────────────────
GENERICS:
─────────────────────────────────────
  function first<T>(arr: T[]): T | undefined {
      return arr[0];
  }

  first([1, 2, 3])       // type: number | undefined
  first(["a", "b"])      // type: string | undefined
  first([])              // type: T | undefined

  // Constrained generics:
  function longest<T extends { length: number }>(a: T, b: T): T {
      return a.length >= b.length ? a : b;
  }

  longest("hello", "hi")          // works — strings have .length
  longest([1,2], [1,2,3])         // works — arrays have .length
  longest(1, 2)                   // error! numbers lack .length

─────────────────────────────────────
UTILITY TYPES:
─────────────────────────────────────
  Partial<User>          → all fields optional
  Required<User>         → all fields required
  Readonly<User>         → all fields readonly
  Pick<User, 'id'|'name'>→ subset of fields
  Omit<User, 'password'> → exclude fields
  Record<string, number> → key-value type
  ReturnType<typeof fn>  → infer return type
  Parameters<typeof fn>  → infer parameter types
  NonNullable<T|null>    → remove null/undefined

─────────────────────────────────────
GETTING STARTED:
─────────────────────────────────────
  # Install TypeScript:
  npm install -D typescript tsx

  # Create config:
  npx tsc --init

  # tsconfig.json key settings:
  {
    "compilerOptions": {
      "target": "ES2022",
      "module": "ESNext",
      "strict": true,
      "noImplicitAny": true,
      "strictNullChecks": true,
      "outDir": "./dist",
      "rootDir": "./src"
    }
  }

  # Compile: npx tsc
  # Run directly: npx tsx src/index.ts
  # Watch mode: npx tsc --watch

─────────────────────────────────────
RESOURCES:
─────────────────────────────────────
  typescriptlang.org/docs   → official documentation
  typescriptlang.org/play   → online playground
  Total TypeScript (Matt Pocock) → best TS course
  type-challenges (GitHub)  → TypeScript puzzles

─────────────────────────────────────
YOUR TRANSITION PATH:
─────────────────────────────────────
  Week 1: Add .ts extension, fix compiler errors
  Week 2: Add interfaces and types to your data
  Week 3: Add generics where needed
  Week 4: Enable strict mode — fix remaining issues
  Month 2: Master utility types and advanced patterns

💻 CODE:
// ─── TYPESCRIPT CONCEPTS DEMONSTRATED IN JS ───────────
// TypeScript compiles to JavaScript — this shows the
// patterns you'd use in TypeScript expressed as JS

console.log("=== TypeScript Preview ===");
console.log("Everything below is valid TypeScript (with type annotations)");
console.log("The JS output after compilation looks the same\\n");

// ─── TYPES AND INTERFACES (as JSDoc) ──────────────────
// TypeScript: interface User { id: number; name: string; }
// JavaScript with JSDoc type hints:

/**
 * @typedef {{ id: number, name: string, email: string, role?: string }} User
 */

/**
 * @param {number} id
 * @returns {User}
 */
function createUser(id, name, email, role = 'user') {
    return { id, name, email, role };
}

const alice = createUser(1, 'Alice Chen', 'alice@example.com', 'admin');
const bob   = createUser(2, 'Bob Smith',  'bob@example.com');
console.log("=== User Objects ===");
console.log("  Alice:", alice);
console.log("  Bob:", bob);

// ─── GENERIC FUNCTION PATTERN ─────────────────────────
console.log("\\n=== Generic Patterns ===");

// TypeScript: function first<T>(arr: T[]): T | undefined
function first(arr) { return arr[0]; }
function last(arr)  { return arr[arr.length - 1]; }

function chunk(arr, size) {
    return Array.from({ length: Math.ceil(arr.length / size) },
        (_, i) => arr.slice(i * size, i * size + size));
}

function zip(a, b) {
    return a.map((item, i) => [item, b[i]]);
}

console.log("  first([1,2,3]):", first([1, 2, 3]));
console.log("  last(['a','b']):", last(['a', 'b']));
console.log("  chunk([1..8],3):", chunk([1,2,3,4,5,6,7,8], 3));
console.log("  zip([1,2,3],['a','b','c']):", zip([1,2,3], ['a','b','c']));

// ─── TYPED VALIDATION (like Zod) ──────────────────────
console.log("\\n=== Type-safe Validation (Zod-style) ===");

// TypeScript enables libraries like Zod:
// const schema = z.object({ name: z.string().min(2), age: z.number().min(0) })
// TypeScript: const result: { name: string, age: number } = schema.parse(data)

// We simulate this pattern:
const schema = {
    string: (opts = {}) => ({
        type: 'string',
        ...opts,
        parse: (v) => {
            if (typeof v !== 'string') throw new Error('Expected string');
            if (opts.min && v.length < opts.min) throw new Error(\`Min length\${
opts.min}\`);
            if (opts.max && v.length > opts.max) throw new Error(\`Max length\${
opts.max}\`);
            if (opts.email && !/^[^\\s@]+@[^\\s@]+\\.[^\\s@]+\$/.test(v)) throw new Error('Invalid email');
            return v;
        }
    }),
    number: (opts = {}) => ({
        type: 'number',
        ...opts,
        parse: (v) => {
            if (typeof v !== 'number') throw new Error('Expected number');
            if (opts.min !== undefined && v < opts.min) throw new Error(\`Min value\${
opts.min}\`);
            if (opts.max !== undefined && v > opts.max) throw new Error(\`Max value\${
opts.max}\`);
            return v;
        }
    }),
    object: (fields) => ({
        parse: (data) => {
            const result = {};
            const errors = {};
            for (const [key, fieldSchema] of Object.entries(fields)) {
                try { result[key] = fieldSchema.parse(data[key]); }
                catch (e) { errors[key] = e.message; }
            }
            if (Object.keys(errors).length > 0) throw { errors };
            return result;
        }
    }),
};

const userSchema = schema.object({
    name:  schema.string({ min: 2, max: 50 }),
    email: schema.string({ email: true }),
    age:   schema.number({ min: 0, max: 150 }),
});

const testCases = [
    { name: 'Alice', email: 'alice@example.com', age: 28 },
    { name: 'B',     email: 'not-an-email',       age: 200 },
];

testCases.forEach((data, i) => {
    try {
        const result = userSchema.parse(data);
        console.log(\`  Test\${
i+1}: ✅ Valid:`, JSON.stringify(result));
    } catch (e) {
        console.log(\`  Test\${
i+1}: ❌ Errors:`, JSON.stringify(e.errors || e.message));
    }
});

// ─── TS QUICK REFERENCE ───────────────────────────────
console.log("\\n=== TypeScript Quick Reference ===");

const tsExamples = [
    ["Type annotation",    "let name: string = 'Alice'"],
    ["Union type",         "let id: number | string"],
    ["Optional property",  "interface User { role?: string }"],
    ["Readonly",           "readonly id: number"],
    ["Array type",         "let scores: number[]"],
    ["Tuple",              "let pair: [string, number]"],
    ["Generic function",   "function first<T>(arr: T[]): T"],
    ["Interface",          "interface User { id: number; name: string }"],
    ["Type alias",         "type Status = 'active' | 'inactive'"],
    ["Intersection",       "type Admin = User & { perms: string[] }"],
    ["Partial",            "Partial<User>  // all fields optional"],
    ["Omit",               "Omit<User, 'password'>  // exclude field"],
    ["Infer return type",  "ReturnType<typeof myFn>"],
    ["Non-null assertion", "el!.innerHTML  // tells TS: not null"],
    ["Type assertion",     "value as string  // you know the type"],
];

tsExamples.forEach(([concept, code]) => {
    console.log(\` \${
concept.padEnd(22)}:\${
code}\`);
});

// ─── NEXT STEPS ───────────────────────────────────────
console.log("\\n=== Your TypeScript Learning Path ===");

const steps = [
    "1. Install: npm install -D typescript tsx",
    "2. Init: npx tsc --init (creates tsconfig.json)",
    "3. Rename .js files to .ts",
    "4. Fix type errors the compiler reports",
    "5. Enable strict: true in tsconfig.json",
    "6. Learn interfaces, types, generics",
    "7. Use utility types: Partial, Pick, Omit, Record",
    "8. Master: conditional types, mapped types, infer",
    "",
    "Best resources:",
    "→ typescriptlang.org/docs",
    "→ typescriptlang.org/play (interactive playground)",
    "→ Total TypeScript by Matt Pocock (course)",
    "→ type-challenges on GitHub (practice problems)",
];
steps.forEach(s => console.log(\` \${
s}\`));

📝 KEY POINTS:
✅ TypeScript is a strict superset of JavaScript — all valid JS is valid TS
✅ Types are erased at compile time — TypeScript adds zero runtime overhead
✅ Interfaces and type aliases describe object shapes; interfaces can extend
✅ Generics provide type-safe reusable code: function<T>(x: T): T
✅ Utility types (Partial, Omit, Pick, Required) transform existing types
✅ Enable strict: true in tsconfig.json — it catches the most bugs
✅ Libraries like Zod runtime-validate data and infer TypeScript types
✅ JSDoc type annotations let you get some TS benefits without migrating
✅ tsx runs TypeScript directly in Node.js without a build step
❌ TypeScript types are compile-time only — they don't validate at runtime
❌ Don't use any type — it defeats the purpose; use unknown instead
❌ Non-null assertions (!) can silence valid errors — use sparingly
❌ TypeScript doesn't make your code faster — it only improves developer experience
""",
  quiz: [
    Quiz(question: 'What happens to TypeScript type annotations when the code runs?', options: [
      QuizOption(text: 'They are completely stripped out — the compiled JavaScript has no types, just the original logic', correct: true),
      QuizOption(text: 'They are converted to runtime checks that validate values as the program runs', correct: false),
      QuizOption(text: 'They remain as metadata that TypeScript tools can read during execution', correct: false),
      QuizOption(text: 'They are compiled into a separate .d.ts file that runs alongside the .js file', correct: false),
    ]),
    Quiz(question: 'What is the difference between interface and type in TypeScript?', options: [
      QuizOption(text: 'Interfaces can be extended and merged; type aliases are more flexible (union/intersection types, primitives)', correct: true),
      QuizOption(text: 'interface is for objects only; type can be used for functions and primitives but not objects', correct: false),
      QuizOption(text: 'type is deprecated in TypeScript 5+; interface should always be used', correct: false),
      QuizOption(text: 'They are completely identical — just different syntax for the same thing', correct: false),
    ]),
    Quiz(question: 'What does Partial<User> do in TypeScript?', options: [
      QuizOption(text: 'Creates a new type where all properties of User become optional (can be undefined)', correct: true),
      QuizOption(text: 'Creates a read-only copy of User where no properties can be modified', correct: false),
      QuizOption(text: 'Returns only the partial (subset) fields that have been assigned values', correct: false),
      QuizOption(text: 'Creates a type with half of User\'s properties removed randomly', correct: false),
    ]),
  ],
);
