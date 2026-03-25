import '../../models/lesson.dart';
import '../../models/quiz.dart';

final jsLesson01 = Lesson(
  language: 'JavaScript',
  title: 'What is JavaScript?',
  content: """
🎯 METAPHOR:
If a webpage were a building, HTML is the structure —
the walls, floors, and rooms. CSS is the interior design —
the paint, furniture, and lighting. JavaScript is the
electricity that makes everything work: it opens doors
when you press a button, turns lights on when you enter
a room, and sends an alert when the smoke detector fires.
Without JavaScript, a webpage is a beautiful, static
photograph. With it, the photograph becomes a living,
interactive space that responds to everything you do.

📖 EXPLANATION:
JavaScript is the world's most widely used programming
language. It runs in every web browser, on servers
(Node.js), in mobile apps, desktop apps, and even IoT
devices. It is the only language that runs natively
in the browser — making it essential for web development.

─────────────────────────────────────
A BRIEF HISTORY:
─────────────────────────────────────
  1995 → Created by Brendan Eich at Netscape in 10 days.
         Originally named Mocha, then LiveScript.
  1996 → Renamed JavaScript (marketing — not related to Java!)
  1997 → ECMAScript standard created (JavaScript's spec)
  2009 → Node.js — JavaScript on the server (Ryan Dahl)
  2015 → ES6/ES2015 — massive modernization: let, const,
         arrow functions, classes, promises, modules
  2016+ → Annual releases (ES2016, ES2017... ES2024)
  Today → Used everywhere: web, server, mobile, desktop,
           AI tooling, cloud functions, databases

─────────────────────────────────────
JAVASCRIPT vs JAVA — NOT THE SAME:
─────────────────────────────────────
  The name was purely a marketing decision in 1995.
  They are as different as car and carpet.

  JavaScript:              Java:
  Dynamic typing           Static typing
  Interpreted/JIT          Compiled to bytecode
  Runs in browser          Runs on JVM
  Prototype-based OOP      Class-based OOP
  Single-threaded          Multi-threaded
  Weak coercion            Strong typing

─────────────────────────────────────
ECMASCRIPT vs JAVASCRIPT:
─────────────────────────────────────
  ECMAScript (ES) is the official SPECIFICATION.
  JavaScript is the most famous IMPLEMENTATION of it.

  Version names you'll see:
  ES5     (2009) → the old baseline
  ES6     (2015) → modern JS begins here
  ES2016–ES2024  → yearly additions

  "ES6+", "modern JavaScript", "vanilla JS" all mean
  the same thing: current, standards-based JavaScript.

─────────────────────────────────────
WHERE JAVASCRIPT RUNS:
─────────────────────────────────────
  BROWSER (Frontend):
  → Chrome, Firefox, Safari, Edge each have a JS engine
  → Chrome/Edge: V8 engine (Google)
  → Firefox: SpiderMonkey (Mozilla)
  → Safari: JavaScriptCore (Apple)
  → Direct access to DOM, Web APIs, localStorage, etc.

  SERVER (Backend):
  → Node.js (built on V8) — most popular
  → Deno — modern, secure Node.js alternative
  → Bun — fast new runtime

  MOBILE:
  → React Native (runs on a JS thread)
  → Expo, NativeScript

  DESKTOP:
  → Electron (VS Code, Slack, Discord are built with it)
  → Tauri (newer, lighter alternative)

─────────────────────────────────────
HOW JAVASCRIPT EXECUTES:
─────────────────────────────────────
  1. JS source code is written (.js file)
  2. Engine parses it into an AST (Abstract Syntax Tree)
  3. Interpreter starts executing immediately
  4. JIT (Just-In-Time) compiler detects "hot" code
  5. Hot code compiled to optimized machine code
  6. Result runs fast — nearly as fast as native code

  JavaScript is NOT pre-compiled. It is compiled at
  runtime by the engine. This is why "JavaScript is
  interpreted" is partially correct but oversimplified.

─────────────────────────────────────
YOUR FIRST JAVASCRIPT:
─────────────────────────────────────
  // In a browser console (F12 → Console tab):
  console.log("Hello, World!");

  // In an HTML file:
  <script>
    alert("Hello!");
    console.log("I run in the browser.");
  </script>

  // In Node.js (terminal):
  node hello.js

  // hello.js:
  console.log("Hello from Node.js!");

─────────────────────────────────────
THE JS ECOSYSTEM:
─────────────────────────────────────
  npm     → package manager (2M+ packages)
  React   → UI library (Facebook/Meta)
  Vue     → progressive UI framework
  Angular → enterprise framework (Google)
  Next.js → React framework with SSR
  Express → minimal Node.js web server
  TypeScript → typed superset of JavaScript

💻 CODE:
// ─── BASIC OUTPUT ─────────────────────────────────────
console.log("Hello, World!");          // most common
console.error("Something went wrong"); // red in console
console.warn("Be careful here");       // yellow in console
console.info("FYI: server started");   // informational

// ─── COMMENTS ─────────────────────────────────────────
// This is a single-line comment

/*
  This is a
  multi-line comment
*/

/**
 * JSDoc comment — used for documentation
 * @param {string} name - The person's name
 * @returns {string} A greeting message
 */
function greet(name) {
  return "Hello, " + name + "!";
}

// ─── JAVASCRIPT VERSIONS DEMO ─────────────────────────
// Old style (ES5):
var greeting = "Hello";
function oldStyle(name) {
  return greeting + ", " + name + "!";
}

// Modern style (ES6+):
const modernGreeting = "Hello";
const modernStyle = (name) => \`${
modernGreeting}, ${
name}!\`;

console.log(oldStyle("Terry"));      // Hello, Terry!
console.log(modernStyle("Terry"));   // Hello, Terry!

// ─── WHERE JS RUNS ────────────────────────────────────
// Detect environment:
const isBrowser = typeof window !== "undefined";
const isNode    = typeof process !== "undefined";

console.log("Running in browser:", isBrowser);
console.log("Running in Node.js:", isNode);

// ─── CONSOLE METHODS ──────────────────────────────────
console.log("Plain output");
console.log("Multiple", "values", "at", "once");   // space-separated
console.log("%cStyled text", "color: blue; font-size: 20px"); // browser only

// Table output (great for arrays of objects):
const people = [
  { name: "Alice", age: 28 },
  { name: "Bob",   age: 34 },
];
console.table(people);

// Group output:
console.group("My Group");
console.log("Line 1");
console.log("Line 2");
console.groupEnd();

// Time operations:
console.time("myTimer");
let sum = 0;
for (let i = 0; i < 1_000_000; i++) sum += i;
console.timeEnd("myTimer");  // myTimer: Xms

// Assert (throws if false):
console.assert(1 + 1 === 2, "Math is broken");

// Count calls:
console.count("myLabel");  // myLabel: 1
console.count("myLabel");  // myLabel: 2

console.log("Sum:", sum);
console.log("JavaScript is everywhere! 🌍");

📝 KEY POINTS:
✅ JavaScript is the only language that runs natively in every web browser
✅ ECMAScript is the spec; JavaScript is the implementation — yearly releases since ES2015
✅ ES6 (2015) was the biggest modernization: let/const, arrows, classes, promises, modules
✅ Node.js brought JS to the server — same language, full-stack development
✅ V8 (Chrome/Node), SpiderMonkey (Firefox), JavaScriptCore (Safari) are the major engines
✅ JS is JIT-compiled at runtime — not purely interpreted, not pre-compiled
✅ console.log, console.error, console.table, console.time are your main debugging tools
❌ JavaScript is NOT Java — completely unrelated despite the name
❌ Don't use var in modern code — use const and let instead
❌ JavaScript is NOT slow — modern engines are highly optimized and extremely fast
""",
  quiz: [
    Quiz(
      question: 'What does ECMAScript refer to in relation to JavaScript?',
      options: [
        QuizOption(text: 'ECMAScript is the official specification that JavaScript implements — it defines the language standard', correct: true),
        QuizOption(text: 'ECMAScript is an older version of JavaScript that is now deprecated', correct: false),
        QuizOption(text: 'ECMAScript is the runtime engine that executes JavaScript in the browser', correct: false),
        QuizOption(text: 'ECMAScript is a competing language that later merged with JavaScript', correct: false),
      ],
    ),
    Quiz(
      question: 'What is the name of the JavaScript engine used in Google Chrome and Node.js?',
      options: [
        QuizOption(text: 'V8 — built by Google, used in Chrome, Edge, and Node.js', correct: true),
        QuizOption(text: 'SpiderMonkey — Mozilla\'s engine used in Firefox', correct: false),
        QuizOption(text: 'JavaScriptCore — Apple\'s engine used in Safari', correct: false),
        QuizOption(text: 'Chakra — Microsoft\'s original Edge engine', correct: false),
      ],
    ),
    Quiz(
      question: 'Which ES version introduced let, const, arrow functions, classes, and Promises?',
      options: [
        QuizOption(text: 'ES6 / ES2015 — the biggest modernization of JavaScript to date', correct: true),
        QuizOption(text: 'ES5 / ES2009 — the previous major baseline version', correct: false),
        QuizOption(text: 'ES2017 — the version that introduced async/await', correct: false),
        QuizOption(text: 'ES2020 — the version that introduced optional chaining', correct: false),
      ],
    ),
  ],
);
