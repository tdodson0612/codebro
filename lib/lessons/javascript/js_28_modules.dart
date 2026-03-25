import '../../models/lesson.dart';
import '../../models/quiz.dart';

final jsLesson28 = Lesson(
  language: 'JavaScript',
  title: 'JavaScript Modules (import / export)',
  content: """
🎯 METAPHOR:
Modules are like specialized workshops in a large factory.
Before modules, all workers shared one giant open-plan
room (global scope) — everyone's tools, materials, and
work-in-progress were mixed together. Anyone could
accidentally pick up someone else's screwdriver or
overwrite someone's measurements. Modules give each
team their own workshop with a locked door. Teams can
EXPORT specific tools they're willing to share (export),
and other teams can explicitly REQUEST those tools
(import). No accidental cross-contamination. The
factory becomes organized, each team's work is isolated,
and you can clearly see EXACTLY what flows between teams.

📖 EXPLANATION:
ES Modules (ESM) are the official JavaScript module system,
introduced in ES6. They replaced CommonJS (require/module.exports)
which is still used in Node.js.

─────────────────────────────────────
NAMED EXPORTS:
─────────────────────────────────────
  // math.js
  export const PI = 3.14159;
  export function add(a, b) { return a + b; }
  export function multiply(a, b) { return a * b; }
  export class Vector { ... }

  // Or export at bottom:
  const PI = 3.14159;
  function add(a, b) { return a + b; }
  export { PI, add };

  // Export with rename:
  export { add as sum, multiply as mul };

─────────────────────────────────────
DEFAULT EXPORTS:
─────────────────────────────────────
  // Only ONE default export per module:
  export default function main() { ... }
  export default class App { ... }
  export default { name: "Alice", age: 28 };
  export default 42;

─────────────────────────────────────
NAMED IMPORTS:
─────────────────────────────────────
  import { PI, add, multiply } from './math.js';
  import { add as sum }        from './math.js';
  import * as math             from './math.js';  // namespace import

  math.PI       // 3.14159
  math.add(2,3) // 5

─────────────────────────────────────
DEFAULT IMPORTS:
─────────────────────────────────────
  import App          from './App.js';    // any name you choose
  import MyApp        from './App.js';    // same, different name
  import App, { util } from './App.js';  // default + named

─────────────────────────────────────
RE-EXPORTS:
─────────────────────────────────────
  // index.js (barrel file — aggregate exports)
  export { add, multiply }   from './math.js';
  export { default as App }  from './App.js';
  export * from './utils.js'; // re-export everything

─────────────────────────────────────
DYNAMIC IMPORTS:
─────────────────────────────────────
  // import() returns a Promise — lazy load!
  const { default: App } = await import('./App.js');

  // Conditional load:
  const locale = 'fr';
  const strings = await import(\`./strings/${
locale}.js\`);

  // Code splitting (webpack/Vite):
  button.addEventListener('click', async () => {
      const { Modal } = await import('./Modal.js');
      new Modal().show();
  });

─────────────────────────────────────
MODULE FEATURES:
─────────────────────────────────────
  ✅ Always in strict mode
  ✅ Top-level this is undefined
  ✅ Imports are live bindings (not copies)
  ✅ Imports are hoisted
  ✅ Circular imports are handled
  ✅ One execution per file (cached after first import)

  // In HTML:
  <script type="module" src="main.js"></script>

  // In Node.js (package.json):
  { "type": "module" }       // all .js files are ESM
  // or use .mjs extension

─────────────────────────────────────
CommonJS vs ESM:
─────────────────────────────────────
  CommonJS (Node.js legacy):
  const path = require('path');
  module.exports = { add, multiply };
  module.exports.default = App;

  ESM (modern standard):
  import path from 'path';
  export { add, multiply };
  export default App;

  Key differences:
  → CJS: synchronous; ESM: async (importable in browser)
  → CJS: dynamic (require() anywhere); ESM: static analysis
  → CJS: exports are copies; ESM: live bindings
  → CJS: .js files; ESM: .mjs or { "type": "module" }

─────────────────────────────────────
TOP-LEVEL AWAIT (ESM only):
─────────────────────────────────────
  // In a .mjs file or <script type="module">:
  const config = await fetch('/config.json').then(r => r.json());
  export const apiUrl = config.apiUrl;

  // Other modules importing this must wait for the async init!

💻 CODE:
// Simulating module behavior in a single file for lesson demo

// ─── NAMED EXPORT SIMULATION ──────────────────────────
console.log("=== Named Exports ===");

// Simulating: math.js
const math = (() => {
    const PI = Math.PI;
    const E  = Math.E;

    function add(a, b)      { return a + b; }
    function subtract(a, b) { return a - b; }
    function multiply(a, b) { return a * b; }
    function divide(a, b)   {
        if (b === 0) throw new RangeError("Division by zero");
        return a / b;
    }

    class Vector {
        constructor(x, y) { this.x = x; this.y = y; }
        add(other) { return new Vector(this.x + other.x, this.y + other.y); }
        magnitude() { return Math.sqrt(this.x**2 + this.y**2); }
        toString()  { return \`Vector(${
this.x}, ${
this.y})\`; }
    }

    return { PI, E, add, subtract, multiply, divide, Vector };
})();

// Simulating: import { PI, add, multiply, Vector } from './math.js';
const { PI, add, multiply, Vector } = math;

console.log("  PI:", PI);
console.log("  add(3, 4):", add(3, 4));
console.log("  multiply(3, 4):", multiply(3, 4));

const v1 = new Vector(3, 4);
const v2 = new Vector(1, 2);
console.log("  v1:", v1.toString());
console.log("  v1.magnitude():", v1.magnitude());
console.log("  v1.add(v2):", v1.add(v2).toString());

// Namespace import: import * as math from './math.js';
console.log("  namespace:", math.add(10, 20), math.E.toFixed(5));

// ─── DEFAULT EXPORT SIMULATION ────────────────────────
console.log("\n=== Default Export ===");

// Simulating: export default class EventEmitter
class EventEmitter {
    #listeners = new Map();

    on(event, fn) {
        if (!this.#listeners.has(event)) this.#listeners.set(event, []);
        this.#listeners.get(event).push(fn);
        return this;
    }

    off(event, fn) {
        const fns = this.#listeners.get(event) || [];
        this.#listeners.set(event, fns.filter(f => f !== fn));
        return this;
    }

    emit(event, ...args) {
        (this.#listeners.get(event) || []).forEach(fn => fn(...args));
        return this;
    }

    once(event, fn) {
        const wrapper = (...args) => { fn(...args); this.off(event, wrapper); };
        return this.on(event, wrapper);
    }
}

// Simulating: import EventEmitter from './EventEmitter.js';
const emitter = new EventEmitter();

emitter.on('data', d => console.log("  Data received:", d));
emitter.on('error', e => console.log("  Error:", e.message));
emitter.once('ready', () => console.log("  Ready! (fires once)"));

emitter.emit('ready');
emitter.emit('ready');   // won't fire again
emitter.emit('data', { id: 1, value: "hello" });
emitter.emit('data', { id: 2, value: "world" });
emitter.emit('error', new Error("Something went wrong"));

// ─── BARREL FILE PATTERN ──────────────────────────────
console.log("\n=== Barrel File Pattern ===");

// utils/string.js
const stringUtils = {
    capitalize: s => s.charAt(0).toUpperCase() + s.slice(1).toLowerCase(),
    camelCase:  s => s.split(/[-_\\s]+/).map((w, i) =>
        i === 0 ? w.toLowerCase() : w.charAt(0).toUpperCase() + w.slice(1).toLowerCase()
    ).join(''),
    truncate: (s, n) => s.length > n ? s.slice(0, n) + '...' : s,
    slugify:  s => s.toLowerCase().trim().replace(/[^\\w\\s-]/g, '').replace(/[\\s_]+/g, '-'),
};

// utils/number.js
const numberUtils = {
    clamp:    (n, min, max) => Math.max(min, Math.min(max, n)),
    lerp:     (a, b, t)     => a + (b - a) * t,
    round:    (n, decimals) => Number(n.toFixed(decimals)),
    formatCurrency: (n, currency = 'USD') =>
        new Intl.NumberFormat('en-US', { style: 'currency', currency }).format(n),
};

// utils/array.js
const arrayUtils = {
    unique:    arr => [...new Set(arr)],
    chunk:     (arr, n) => Array.from({ length: Math.ceil(arr.length / n) },
                           (_, i) => arr.slice(i * n, i * n + n)),
    flatten:   arr => arr.flat(Infinity),
    groupBy:   (arr, key) => arr.reduce((acc, item) => {
        const k = typeof key === 'function' ? key(item) : item[key];
        return { ...acc, [k]: [...(acc[k] || []), item] };
    }, {}),
};

// Simulating: import { capitalize, camelCase } from './utils/index.js';
// (barrel file re-exports everything)
const utils = { ...stringUtils, ...numberUtils, ...arrayUtils };

console.log("  capitalize('hello world'):", utils.capitalize("hello world"));
console.log("  camelCase('my-variable'):", utils.camelCase("my-variable"));
console.log("  truncate('Hello World!', 8):", utils.truncate("Hello World!", 8));
console.log("  slugify('Hello World!'):", utils.slugify("Hello World!"));
console.log("  clamp(150, 0, 100):", utils.clamp(150, 0, 100));
console.log("  formatCurrency(1234.56):", utils.formatCurrency(1234.56));
console.log("  unique([1,2,2,3,3]):", utils.unique([1, 2, 2, 3, 3]));
console.log("  chunk([1..8], 3):", utils.chunk([1,2,3,4,5,6,7,8], 3));

const people = [
    { name: "Alice", dept: "Engineering" },
    { name: "Bob",   dept: "Marketing" },
    { name: "Carol", dept: "Engineering" },
    { name: "Dave",  dept: "Marketing" },
];
const byDept = utils.groupBy(people, "dept");
console.log("  groupBy dept:", JSON.stringify(byDept, null, 0));

// ─── DYNAMIC IMPORT SIMULATION ────────────────────────
console.log("\n=== Dynamic Import Pattern ===");

const moduleRegistry = {
    './heavy-module.js': {
        process: data => data.map(n => n ** 2),
        default: class HeavyProcessor {
            run(n) { return n * 1000; }
        }
    }
};

async function loadOnDemand(modulePath) {
    console.log(\`  [Loading] ${
modulePath}...\`);
    await new Promise(r => setTimeout(r, 50));  // simulate network
    const mod = moduleRegistry[modulePath];
    console.log(\`  [Loaded]  ${
modulePath}\`);
    return mod;
}

(async () => {
    const mod = await loadOnDemand('./heavy-module.js');
    console.log("  Dynamic import result:", mod.process([1, 2, 3, 4, 5]));

    const { default: HeavyProcessor } = mod;
    const proc = new HeavyProcessor();
    console.log("  Processor run(42):", proc.run(42));
})();

📝 KEY POINTS:
✅ Named exports: export { name } — import { name } from './module.js'
✅ Default export: export default — import anything from './module.js'
✅ One default export per module; unlimited named exports
✅ import * as ns from './module.js' collects all named exports into a namespace
✅ Barrel files (index.js) re-export from multiple modules for clean import paths
✅ Dynamic import() returns a Promise — enables code splitting and lazy loading
✅ ES Modules are always in strict mode — no need for "use strict"
✅ Imports are live bindings — if the exporting module updates the binding, you see the update
✅ Top-level await works inside ES modules (.mjs or type="module")
❌ .js file extension is required in import paths for native ES modules (browsers, Deno)
❌ You can't use import inside a function (static imports must be at the top level)
❌ ESM and CommonJS cannot mix without care — use .mjs or package.json "type":"module"
❌ Circular imports are allowed but can cause undefined values — avoid circular dependencies
""",
  quiz: [
    Quiz(question: 'What is the difference between a named export and a default export?', options: [
      QuizOption(text: 'Named exports are imported by their exact name; default exports can be imported with any name', correct: true),
      QuizOption(text: 'Named exports can only be strings and numbers; default exports can be any type', correct: false),
      QuizOption(text: 'Named exports are public; default exports are private to the module', correct: false),
      QuizOption(text: 'Default exports are evaluated eagerly; named exports are lazy', correct: false),
    ]),
    Quiz(question: 'What does import() (dynamic import) return?', options: [
      QuizOption(text: 'A Promise that resolves with the module namespace object', correct: true),
      QuizOption(text: 'The default export of the module directly', correct: false),
      QuizOption(text: 'A synchronous module reference that blocks execution', correct: false),
      QuizOption(text: 'An EventEmitter that fires when the module loads', correct: false),
    ]),
    Quiz(question: 'What is a barrel file (index.js) pattern?', options: [
      QuizOption(text: 'An index.js that re-exports from multiple modules — allowing consumers to import from one path', correct: true),
      QuizOption(text: 'A file that contains a compressed barrel of all the project\'s dependencies', correct: false),
      QuizOption(text: 'The entry point file that initializes the application', correct: false),
      QuizOption(text: 'A file that exports only default exports from all modules in a directory', correct: false),
    ]),
  ],
);
