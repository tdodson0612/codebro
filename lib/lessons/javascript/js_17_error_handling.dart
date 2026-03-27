import '../../models/lesson.dart';
import '../../models/quiz.dart';

final jsLesson17 = Lesson(
  language: 'JavaScript',
  title: 'Error Handling',
  content: """
🎯 METAPHOR:
Error handling is like the safety net under a trapeze
artist. The artist (your code) SHOULD nail every catch —
and usually does. But unexpected things happen: a grip
slips, the timing is off. Without a net, a single miss
is catastrophic. try/catch is the net — it lets your
code attempt something dangerous, catches the fall if
something goes wrong, and lets the show continue.
finally is the stage crew that always cleans up after
the act, whether it succeeded or failed. Custom errors
are colour-coded nets: different colours signal different
types of falls so the crew knows exactly how to respond.

📖 EXPLANATION:
JavaScript has a rich error handling system built around
try/catch/finally blocks and the Error object hierarchy.

─────────────────────────────────────
THE try/catch/finally BLOCK:
─────────────────────────────────────
  try {
      // Code that might throw
      riskyOperation();
  } catch (error) {
      // Handle the error
      console.error(error.message);
  } finally {
      // ALWAYS runs — cleanup goes here
      cleanup();
  }

─────────────────────────────────────
THE Error OBJECT:
─────────────────────────────────────
  error.name      → "TypeError", "RangeError" etc.
  error.message   → human-readable description
  error.stack     → stack trace string

  Built-in error types:
  Error           → base class
  TypeError       → wrong type ("null.property")
  RangeError      → value out of valid range
  ReferenceError  → variable not defined
  SyntaxError     → invalid syntax (parse time)
  URIError        → malformed URI
  EvalError       → eval() issues (rare)
  AggregateError  → multiple errors (Promise.any)

─────────────────────────────────────
THROWING ERRORS:
─────────────────────────────────────
  throw new Error("Something went wrong");
  throw new TypeError("Expected a string");
  throw new RangeError("Value must be 0-100");

  // You can throw ANY value (but Error is best practice):
  throw "just a string";   // works but avoid — no stack trace
  throw 42;                // works but avoid
  throw { code: 404 };    // works but avoid

─────────────────────────────────────
CUSTOM ERROR CLASSES:
─────────────────────────────────────
  class ValidationError extends Error {
      constructor(message, field) {
          super(message);
          this.name = "ValidationError";
          this.field = field;
      }
  }

  class NetworkError extends Error {
      constructor(message, statusCode) {
          super(message);
          this.name = "NetworkError";
          this.statusCode = statusCode;
      }
  }

  // Usage:
  throw new ValidationError("Name is required", "name");

  // Catching by type:
  try { ... }
  catch (e) {
      if (e instanceof ValidationError) {
          console.log(\`Field\${
e.field}:\${
e.message}\`);
      } else if (e instanceof NetworkError) {
          console.log(\`HTTP\${
e.statusCode}:\${
e.message}\`);
      } else {
          throw e;  // re-throw unknown errors
      }
  }

─────────────────────────────────────
ERROR HANDLING IN ASYNC CODE:
─────────────────────────────────────
  // Promises:
  fetch(url)
      .then(res => res.json())
      .catch(err => console.error("Fetch failed:", err));

  // async/await:
  async function loadData() {
      try {
          const res = await fetch(url);
          const data = await res.json();
          return data;
      } catch (err) {
          console.error("Failed:", err.message);
          return null;
      }
  }

─────────────────────────────────────
GLOBAL ERROR HANDLERS:
─────────────────────────────────────
  // Browser:
  window.onerror = (msg, src, line, col, err) => {
      console.error("Global error:", msg);
  };
  window.addEventListener('unhandledrejection', e => {
      console.error("Unhandled promise rejection:", e.reason);
  });

  // Node.js:
  process.on('uncaughtException', err => {
      console.error("Uncaught:", err);
      process.exit(1);
  });
  process.on('unhandledRejection', (reason, promise) => {
      console.error("Unhandled rejection:", reason);
  });

─────────────────────────────────────
ERROR HANDLING BEST PRACTICES:
─────────────────────────────────────
  ✅ Always use Error objects (not strings/numbers)
  ✅ Set error.name on custom errors
  ✅ Re-throw errors you can't handle
  ✅ Use finally for cleanup (close files, connections)
  ✅ Handle promise rejections — always
  ✅ Log the full error object, not just message
  ❌ Empty catch blocks: catch(e) {} — swallows bugs
  ❌ catch everything at the top level silently

💻 CODE:
// ─── BASIC try/catch/finally ──────────────────────────
console.log("=== Basic Error Handling ===");

function divide(a, b) {
    if (typeof a !== 'number' || typeof b !== 'number') {
        throw new TypeError(\`Expected numbers, got\${
typeof a} and\${
typeof b}\`);
    }
    if (b === 0) {
        throw new RangeError("Division by zero is not allowed");
    }
    return a / b;
}

const testCases = [
    [10, 2],
    [10, 0],
    ["hello", 5],
    [null, 5],
];

for (const [a, b] of testCases) {
    try {
        const result = divide(a, b);
        console.log(\`\${
a} /\${
b} =\${
result}\`);
    } catch (e) {
        console.log(\`❌\${
e.name}:\${
e.message}\`);
    }
}

// ─── CUSTOM ERROR CLASSES ─────────────────────────────
console.log("\\n=== Custom Error Classes ===");

class AppError extends Error {
    constructor(message, code) {
        super(message);
        this.name = "AppError";
        this.code = code;
    }
}

class ValidationError extends AppError {
    constructor(message, field) {
        super(message, "VALIDATION_ERROR");
        this.name = "ValidationError";
        this.field = field;
    }
}

class NotFoundError extends AppError {
    constructor(resource, id) {
        super(\`\${
resource} with id '\${
id}' not found\`, "NOT_FOUND");
        this.name = "NotFoundError";
        this.resource = resource;
        this.resourceId = id;
    }
}

class NetworkError extends AppError {
    constructor(message, statusCode) {
        super(message, "NETWORK_ERROR");
        this.name = "NetworkError";
        this.statusCode = statusCode;
    }
}

function processError(error) {
    if (error instanceof ValidationError) {
        console.log(\`  🔴 Validation: field='\${
error.field}' →\${
error.message}\`);
    } else if (error instanceof NotFoundError) {
        console.log(\`  🔍 Not Found:\${
error.resource}[\${
error.resourceId}]\`);
    } else if (error instanceof NetworkError) {
        console.log(\`  🌐 Network: HTTP\${
error.statusCode} →\${
error.message}\`);
    } else if (error instanceof AppError) {
        console.log(\`  ⚠️  App Error [\${
error.code}]:\${
error.message}\`);
    } else {
        console.log(\`  💥 Unknown:\${
error.message}\`);
        throw error;  // Re-throw unknown errors
    }
}

const errors = [
    new ValidationError("Name cannot be blank", "name"),
    new ValidationError("Email format invalid", "email"),
    new NotFoundError("User", "user_42"),
    new NetworkError("Request timed out", 408),
    new AppError("Something unexpected happened", "UNKNOWN"),
    new Error("Plain error"),
];

errors.forEach(err => {
    try {
        throw err;
    } catch (e) {
        processError(e);
    }
});

// Check inheritance chain:
console.log("\\n  instanceof checks:");
const ve = new ValidationError("test", "field");
console.log(\`  ve instanceof ValidationError:\${
ve instanceof ValidationError}\`);
console.log(\`  ve instanceof AppError:       \${
ve instanceof AppError}\`);
console.log(\`  ve instanceof Error:          \${
ve instanceof Error}\`);

// ─── FINALLY ALWAYS RUNS ──────────────────────────────
console.log("\\n=== finally block ===");

function withFinally(shouldThrow) {
    console.log(\`  Trying (shouldThrow=\${
shouldThrow})...\`);
    try {
        if (shouldThrow) throw new Error("Intentional error");
        console.log("  ✅ Success!");
        return "success";
    } catch (e) {
        console.log(\`  ❌ Caught:\${
e.message}\`);
        return "error";
    } finally {
        console.log("  🧹 Finally always runs!");
        // Note: return in finally OVERRIDES try/catch returns
    }
}

withFinally(false);
withFinally(true);

// ─── ERROR PROPERTIES ─────────────────────────────────
console.log("\\n=== Error Properties ===");
try {
    null.property;   // TypeError
} catch (e) {
    console.log(\`  name:   \${
e.name}\`);
    console.log(\`  message:\${
e.message}\`);
    console.log(\`  stack:  \${
e.stack.split('\\n')[0]}\`);
}

// ─── ASYNC ERROR HANDLING ─────────────────────────────
console.log("\\n=== Async Error Handling ===");

async function fetchUser(id) {
    if (id <= 0) throw new ValidationError("ID must be positive", "id");
    if (id > 100) throw new NotFoundError("User", id);

    // Simulate async work
    await new Promise(resolve => setTimeout(resolve, 10));
    return { id, name: \`User\${id}\`, email: \`user\${id}@example.com\` };
}

async function main() {
    const ids = [1, 0, 999];

    for (const id of ids) {
        try {
            const user = await fetchUser(id);
            console.log(\`  ✅ Found:\${
JSON.stringify(user)}\`);
        } catch (e) {
            processError(e);
        }
    }

    // Promise chain error handling
    console.log("\\n  Promise chain:");
    await Promise.resolve(42)
        .then(n => {
            if (n < 50) throw new RangeError("Number too small");
            return n * 2;
        })
        .catch(e => {
            console.log(\`  Caught in .catch():\${
e.message}\`);
            return -1;   // recover with a default
        })
        .then(result => console.log(\`  Final result:\${
result}\`));
}

main();

📝 KEY POINTS:
✅ try/catch/finally: try the code, catch errors, finally always cleans up
✅ Always throw Error objects, not primitives — they carry stack traces
✅ Always set this.name in custom error classes for proper error.name
✅ Use instanceof to check error type and handle each differently
✅ Re-throw errors you can't handle — let them bubble up
✅ finally always runs — even if try returns or catch throws
✅ For async code: use .catch() on promises or try/catch inside async functions
✅ Handle unhandledRejection globally to catch missed promise errors
❌ Never use empty catch blocks — they silently swallow bugs
❌ Don't throw non-Error values — you lose the stack trace
❌ Don't catch errors too broadly at the top level without logging them
❌ A return inside finally overrides the return value from try/catch — surprising!
""",
  quiz: [
    Quiz(question: 'What does the finally block guarantee in a try/catch/finally?', options: [
      QuizOption(text: 'It always runs — whether the try block succeeds, throws, or even returns', correct: true),
      QuizOption(text: 'It only runs when an error is caught in the catch block', correct: false),
      QuizOption(text: 'It runs before the try block to set up resources', correct: false),
      QuizOption(text: 'It only runs when no error occurs in the try block', correct: false),
    ]),
    Quiz(question: 'What is the best practice for creating custom error classes in JavaScript?', options: [
      QuizOption(text: 'Extend Error, call super(message), and set this.name to identify the error type', correct: true),
      QuizOption(text: 'Create a plain object with a message property and throw it', correct: false),
      QuizOption(text: 'Throw a descriptive string instead of an Error object', correct: false),
      QuizOption(text: 'Use a factory function that returns an object with code and message fields', correct: false),
    ]),
    Quiz(question: 'How do you handle errors in async/await functions?', options: [
      QuizOption(text: 'Wrap await calls in try/catch — errors from rejected promises are thrown and caught normally', correct: true),
      QuizOption(text: 'Use .catch() after the function call — try/catch doesn\'t work with async', correct: false),
      QuizOption(text: 'Async functions never throw — they return null on error', correct: false),
      QuizOption(text: 'Use process.on("uncaughtException") for all async errors', correct: false),
    ]),
  ],
);
