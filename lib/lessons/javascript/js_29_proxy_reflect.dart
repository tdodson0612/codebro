import '../../models/lesson.dart';
import '../../models/quiz.dart';

final jsLesson29 = Lesson(
  language: 'JavaScript',
  title: 'Proxy and Reflect',
  content: """
🎯 METAPHOR:
A Proxy is like a highly trained personal assistant who
intercepts everything before it reaches their boss.
When someone tries to get a file from the boss (property
access), the assistant steps in first. They might say
"yes, here's the file" (pass through), "no, that file
is restricted" (block access), "here's a modified version"
(transform), or "let me log that request first and then
proceed" (observe). The boss (target object) never has
to change — the assistant handles everything transparently.
Reflect is the assistant's reference manual that provides
the default behavior: "the standard way to get a property
from an object" — ensuring the assistant can always do
things correctly after their custom logic runs.

📖 EXPLANATION:
Proxy intercepts and customizes fundamental operations on
objects. Reflect provides the default implementations of
those same operations. They work as a pair.

─────────────────────────────────────
CREATING A PROXY:
─────────────────────────────────────
  const proxy = new Proxy(target, handler);

  target  → the object being proxied
  handler → object with "trap" methods

  const handler = {
      get(target, prop, receiver) {
          return Reflect.get(target, prop, receiver);
      },
      set(target, prop, value, receiver) {
          return Reflect.set(target, prop, value, receiver);
      }
  };

─────────────────────────────────────
THE 13 PROXY TRAPS:
─────────────────────────────────────
  get(target, prop, receiver)          → property read
  set(target, prop, value, receiver)   → property write
  has(target, prop)                    → in operator
  deleteProperty(target, prop)         → delete
  apply(target, thisArg, args)         → function call
  construct(target, args, newTarget)   → new operator
  getPrototypeOf(target)               → Object.getPrototypeOf
  setPrototypeOf(target, proto)        → Object.setPrototypeOf
  isExtensible(target)                 → Object.isExtensible
  preventExtensions(target)            → Object.preventExtensions
  getOwnPropertyDescriptor(target, p)  → Object.getOwnPropertyDescriptor
  defineProperty(target, p, desc)      → Object.defineProperty
  ownKeys(target)                      → Object.keys etc.

─────────────────────────────────────
Reflect — the mirror of Proxy traps:
─────────────────────────────────────
  Reflect.get(target, prop, receiver)
  Reflect.set(target, prop, value, receiver)
  Reflect.has(target, prop)
  Reflect.deleteProperty(target, prop)
  Reflect.apply(fn, thisArg, args)
  Reflect.construct(Target, args, newTarget)
  Reflect.getPrototypeOf(target)
  Reflect.setPrototypeOf(target, proto)
  Reflect.ownKeys(target)
  Reflect.defineProperty(target, prop, desc)
  Reflect.getOwnPropertyDescriptor(target, prop)
  Reflect.isExtensible(target)
  Reflect.preventExtensions(target)

  // Reflect.apply is cleaner than Function.prototype.apply:
  Reflect.apply(Math.max, null, [1, 2, 3])  // 3

─────────────────────────────────────
COMMON PROXY PATTERNS:
─────────────────────────────────────
  VALIDATION:     Throw on invalid property writes
  LOGGING:        Log all reads and writes
  DEFAULT VALUES: Return defaults for missing props
  READ-ONLY:      Prevent all writes
  PRIVATE PROPS:  Block access to _ prefixed props
  REACTIVE:       Notify observers on change (Vue 3!)
  LAZY LOADING:   Load data only when accessed
  MEMOIZATION:    Cache function results automatically

─────────────────────────────────────
PROXY LIMITATIONS:
─────────────────────────────────────
  ❌ Cannot proxy some built-in types (Map, Set internals)
  ❌ Cannot intercept calls to == or typeof
  ❌ Proxied objects lose identity checks (proxy !== target)
  ❌ Cannot be revoked by default (use Proxy.revocable())
  ✅ Proxy.revocable() creates a proxy that can be disabled

💻 CODE:
// ─── VALIDATION PROXY ─────────────────────────────────
console.log("=== Validation Proxy ===");

function createValidated(schema) {
    const data = {};
    return new Proxy(data, {
        set(target, prop, value) {
            const rule = schema[prop];
            if (!rule) throw new TypeError(\`Unknown property: ${
String(prop)}\`);
            if (rule.required && (value === null || value === undefined)) {
                throw new TypeError(\`${
String(prop)} is required\`);
            }
            if (rule.type && typeof value !== rule.type) {
                throw new TypeError(\`${
String(prop)} must be ${
rule.type}, got ${
typeof value}\`);
            }
            if (rule.min !== undefined && value < rule.min) {
                throw new RangeError(\`${
String(prop)} must be >= ${
rule.min}\`);
            }
            if (rule.max !== undefined && value > rule.max) {
                throw new RangeError(\`${
String(prop)} must be <= ${
rule.max}\`);
            }
            if (rule.pattern && !rule.pattern.test(value)) {
                throw new Error(\`${
String(prop)} doesn't match required pattern\`);
            }
            return Reflect.set(target, prop, value);
        },
        get(target, prop) {
            return Reflect.get(target, prop);
        }
    });
}

const userSchema = {
    name:  { type: 'string', required: true },
    age:   { type: 'number', min: 0, max: 150 },
    email: { type: 'string', pattern: /^[^\\s@]+@[^\\s@]+\\.[^\\s@]+\$/ },
};

const validatedUser = createValidated(userSchema);

const tests = [
    () => { validatedUser.name = "Alice"; console.log("  ✅ name = Alice"); },
    () => { validatedUser.age  = 28; console.log("  ✅ age = 28"); },
    () => { validatedUser.email = "alice@example.com"; console.log("  ✅ email set"); },
    () => { validatedUser.age  = -5; },  // will throw
    () => { validatedUser.age  = 200; }, // will throw
    () => { validatedUser.name = 42; },  // will throw
    () => { validatedUser.unknown = "x"; }, // will throw
];

for (const test of tests) {
    try { test(); }
    catch (e) { console.log(\`  ❌ ${
e.constructor.name}: ${
e.message}\`); }
}

// ─── LOGGING PROXY ────────────────────────────────────
console.log("\n=== Logging Proxy ===");

function createLogger(target, name = "object") {
    return new Proxy(target, {
        get(target, prop, receiver) {
            const value = Reflect.get(target, prop, receiver);
            if (typeof value !== 'function') {
                console.log(\`  [LOG] GET ${
name}.${
String(prop)} → ${
JSON.stringify(value)}\`);
            }
            return value;
        },
        set(target, prop, value, receiver) {
            console.log(\`  [LOG] SET ${
name}.${
String(prop)} = ${
JSON.stringify(value)}\`);
            return Reflect.set(target, prop, value, receiver);
        },
        deleteProperty(target, prop) {
            console.log(\`  [LOG] DEL ${
name}.${
String(prop)}\`);
            return Reflect.deleteProperty(target, prop);
        }
    });
}

const config = createLogger({ host: "localhost", port: 8080 }, "config");
config.host;              // GET
config.port = 9090;       // SET
config.debug = true;      // SET
delete config.debug;      // DEL

// ─── DEFAULT VALUES PROXY ─────────────────────────────
console.log("\n=== Default Values Proxy ===");

function withDefaults(target, defaults) {
    return new Proxy(target, {
        get(target, prop) {
            const value = Reflect.get(target, prop);
            return value !== undefined ? value : defaults[prop];
        }
    });
}

const settings = withDefaults(
    { theme: "dark" },
    { theme: "light", fontSize: 14, language: "en", debug: false }
);
console.log("  theme (set):    ", settings.theme);       // "dark"
console.log("  fontSize (def): ", settings.fontSize);    // 14
console.log("  language (def): ", settings.language);    // "en"
console.log("  debug (def):    ", settings.debug);       // false

// ─── REACTIVE PROXY ───────────────────────────────────
console.log("\n=== Reactive Proxy (simplified Vue 3 style) ===");

function reactive(target) {
    const handlers = new Map();

    const proxy = new Proxy(target, {
        get(target, prop, receiver) {
            const value = Reflect.get(target, prop, receiver);
            if (value && typeof value === 'object') return reactive(value);
            return value;
        },
        set(target, prop, value, receiver) {
            const oldValue = Reflect.get(target, prop);
            const result   = Reflect.set(target, prop, value, receiver);
            if (oldValue !== value) {
                const cbs = handlers.get(prop) || [];
                cbs.forEach(cb => cb(value, oldValue, prop));
            }
            return result;
        }
    });

    proxy.\$watch = (prop, callback) => {
        if (!handlers.has(prop)) handlers.set(prop, []);
        handlers.get(prop).push(callback);
    };

    return proxy;
}

const state = reactive({ count: 0, name: "Alice" });

state.\$watch('count', (newVal, oldVal) =>
    console.log(\`  count changed: ${
oldVal} → ${
newVal}\`));
state.\$watch('name', (newVal, oldVal) =>
    console.log(\`  name changed: "${
oldVal}" → "${
newVal}"\`));

state.count = 1;
state.count = 2;
state.name  = "Bob";

// ─── FUNCTION PROXY — memoization ─────────────────────
console.log("\n=== Function Proxy (Memoization) ===");

function memoize(fn) {
    const cache = new Map();
    return new Proxy(fn, {
        apply(target, thisArg, args) {
            const key = JSON.stringify(args);
            if (cache.has(key)) {
                console.log(\`  [CACHE HIT]  ${
fn.name}(${
args})\`);
                return cache.get(key);
            }
            console.log(\`  [COMPUTE]    ${
fn.name}(${
args})\`);
            const result = Reflect.apply(target, thisArg, args);
            cache.set(key, result);
            return result;
        }
    });
}

function fibonacci(n) {
    if (n <= 1) return n;
    return fibonacci(n - 1) + fibonacci(n - 2);
}
const memoFib = memoize(fibonacci);

[10, 15, 10, 20, 15].forEach(n => {
    const result = memoFib(n);
    console.log(\`  fib(${
n}) = ${
result}\`);
});

// ─── REVOCABLE PROXY ──────────────────────────────────
console.log("\n=== Revocable Proxy ===");

const { proxy: tempProxy, revoke } = Proxy.revocable(
    { secret: "top-secret-data" },
    {
        get(target, prop) {
            console.log(\`  Accessing: ${
String(prop)}\`);
            return Reflect.get(target, prop);
        }
    }
);

console.log("  Before revoke:", tempProxy.secret);
revoke();   // destroy the proxy
try {
    console.log(tempProxy.secret);
} catch (e) {
    console.log(\`  After revoke: ${
e.constructor.name} — proxy is dead!\`);
}

📝 KEY POINTS:
✅ Proxy wraps a target and intercepts operations via handler "traps"
✅ Reflect provides the default behavior — always use Reflect inside traps for correctness
✅ get/set are the most commonly used traps — property reads and writes
✅ Proxy.revocable() creates a proxy that can be disabled — useful for temporary access
✅ apply trap intercepts function calls — great for memoization and logging
✅ Proxy enables reactive programming (Vue 3's reactivity system uses Proxies)
✅ construct trap intercepts the new operator — can modify or validate constructors
✅ has trap intercepts the in operator — customize membership checks
✅ ownKeys trap intercepts Object.keys(), for...in, Reflect.ownKeys()
❌ Proxy adds overhead — don't use it in hot paths where performance matters
❌ Some built-in objects (Map internals, Date internals) cannot be proxied transparently
❌ A proxy and its target are different objects — proxy !== target
❌ If you forget to call Reflect inside a trap, you lose the default behavior
""",
  quiz: [
    Quiz(question: 'What is the relationship between Proxy traps and Reflect methods?', options: [
      QuizOption(text: 'Each Proxy trap has a corresponding Reflect method that performs the default behavior — use Reflect inside traps to forward correctly', correct: true),
      QuizOption(text: 'Reflect is a library that creates Proxies automatically from schemas', correct: false),
      QuizOption(text: 'Reflect methods are the older API that Proxy replaced entirely', correct: false),
      QuizOption(text: 'Reflect provides reflection for class metadata; Proxy handles object operations', correct: false),
    ]),
    Quiz(question: 'Which Proxy trap intercepts function calls (when the proxied object is a function)?', options: [
      QuizOption(text: 'The apply trap — called when the proxied function is invoked', correct: true),
      QuizOption(text: 'The call trap — named after Function.prototype.call', correct: false),
      QuizOption(text: 'The invoke trap — specifically for function invocation', correct: false),
      QuizOption(text: 'The get trap — reading the function and calling it triggers get', correct: false),
    ]),
    Quiz(question: 'What does Proxy.revocable() provide that a regular Proxy does not?', options: [
      QuizOption(text: 'A revoke() function that permanently disables the proxy — any future access throws TypeError', correct: true),
      QuizOption(text: 'A way to temporarily pause the proxy and resume it later', correct: false),
      QuizOption(text: 'Automatic cleanup when the proxy goes out of scope', correct: false),
      QuizOption(text: 'Access to the internal target object through the proxy', correct: false),
    ]),
  ],
);
