import '../../models/lesson.dart';
import '../../models/quiz.dart';

final jsLesson19 = Lesson(
  language: 'JavaScript',
  title: 'Symbols and Well-Known Symbols',
  content: """
🎯 METAPHOR:
A Symbol is like a unique employee badge that guarantees
no duplicates, ever. Normal strings are like name badges —
two people can both be named "Alice" and wear identical
badges, causing confusion. A Symbol is a cryptographic
badge number issued by HR (the runtime) that is provably
unique across the entire company, forever. Even if you
order a badge that says "Alice" twice, you get two
DIFFERENT badges. They look the same but are not the
same. This makes Symbols perfect as object property keys
when you absolutely need to avoid collisions — even with
code from third-party libraries you don't control.

📖 EXPLANATION:
Symbols are a primitive type introduced in ES6.
Every Symbol() call returns a unique, immutable value.

─────────────────────────────────────
CREATING SYMBOLS:
─────────────────────────────────────
  const sym1 = Symbol();
  const sym2 = Symbol("description");
  const sym3 = Symbol("description");

  sym1 === sym2  // false — always unique
  sym2 === sym3  // false — even with same description!

  // Description is just for debugging:
  sym2.toString()   // "Symbol(description)"
  sym2.description  // "description"

  typeof Symbol()   // "symbol"

─────────────────────────────────────
SYMBOLS AS PROPERTY KEYS:
─────────────────────────────────────
  const id = Symbol("id");

  const user = {
      name: "Alice",
      [id]: 12345        // computed property with Symbol key
  };

  user[id]         // 12345   ✅
  user["id"]       // undefined  (different key!)

  // Symbols are invisible to:
  Object.keys(user)         // ["name"]  — no symbol!
  Object.values(user)       // ["Alice"]
  JSON.stringify(user)      // {"name":"Alice"}  — no symbol!
  for...in loop             // skips symbols

  // But visible to:
  Object.getOwnPropertySymbols(user)   // [Symbol(id)]
  Reflect.ownKeys(user)                // ["name", Symbol(id)]

─────────────────────────────────────
GLOBAL SYMBOL REGISTRY:
─────────────────────────────────────
  // Share symbols across modules/realms:
  const s1 = Symbol.for("app.userId");
  const s2 = Symbol.for("app.userId");
  s1 === s2  // true! (same registry key)

  Symbol.keyFor(s1)   // "app.userId"
  Symbol.keyFor(Symbol())  // undefined (not in registry)

─────────────────────────────────────
WELL-KNOWN SYMBOLS — hooks into JS:
─────────────────────────────────────
  Well-known symbols let you customize how your objects
  interact with JavaScript's built-in behaviors:

  Symbol.iterator      → make object iterable (for...of)
  Symbol.asyncIterator → async iteration
  Symbol.toPrimitive   → customize type conversion
  Symbol.toStringTag   → customize Object.prototype.toString
  Symbol.hasInstance   → customize instanceof
  Symbol.species       → customize derived constructors
  Symbol.isConcatSpreadable → customize Array.prototype.concat
  Symbol.match         → customize String.prototype.match
  Symbol.replace       → customize String.prototype.replace
  Symbol.search        → customize String.prototype.search
  Symbol.split         → customize String.prototype.split

─────────────────────────────────────
Symbol.iterator — MAKE THINGS ITERABLE:
─────────────────────────────────────
  class Range {
      constructor(start, end) {
          this.start = start;
          this.end   = end;
      }

      [Symbol.iterator]() {
          let current = this.start;
          const end = this.end;
          return {
              next() {
                  if (current <= end) {
                      return { value: current++, done: false };
                  }
                  return { value: undefined, done: true };
              }
          };
      }
  }

  for (const n of new Range(1, 5)) {
      console.log(n);   // 1, 2, 3, 4, 5
  }
  [...new Range(1, 3)]   // [1, 2, 3]

─────────────────────────────────────
Symbol.toPrimitive — TYPE CONVERSION:
─────────────────────────────────────
  class Temperature {
      constructor(celsius) { this.celsius = celsius; }

      [Symbol.toPrimitive](hint) {
          if (hint === 'number')  return this.celsius;
          if (hint === 'string')  return \`${
this.celsius}°C\`;
          return this.celsius;  // 'default'
      }
  }

  const temp = new Temperature(22);
  +temp           // 22 (number hint)
  \`Temp: ${
temp}\` // "Temp: 22°C" (string hint)
  temp + 10       // 32 (default hint)

💻 CODE:
// ─── SYMBOL BASICS ────────────────────────────────────
console.log("=== Symbol Basics ===");

const s1 = Symbol("user-id");
const s2 = Symbol("user-id");

console.log("  s1 === s2:", s1 === s2);               // false!
console.log("  typeof s1:", typeof s1);                // "symbol"
console.log("  s1.toString():", s1.toString());        // "Symbol(user-id)"
console.log("  s1.description:", s1.description);      // "user-id"

// ─── SYMBOLS AS PROPERTY KEYS ─────────────────────────
console.log("\\n=== Symbols as Property Keys ===");

const ID     = Symbol("id");
const SECRET = Symbol("secret");

const user = {
    name: "Alice",
    role: "admin",
    [ID]: 42,
    [SECRET]: "hunter2"
};

// Normal property access:
console.log("  user.name:", user.name);
console.log("  user[ID]:", user[ID]);
console.log("  user['id']:", user['id']);         // undefined — different key

// Symbol keys hidden from enumeration:
console.log("  Object.keys:", Object.keys(user));    // ["name", "role"]
console.log("  for..in keys: ", (() => {
    const keys = [];
    for (const k in user) keys.push(k);
    return keys;
})());
console.log("  JSON.stringify:", JSON.stringify(user)); // no symbols

// But accessible with:
console.log("  getOwnPropertySymbols:", Object.getOwnPropertySymbols(user));
console.log("  Reflect.ownKeys:", Reflect.ownKeys(user));

// ─── GLOBAL SYMBOL REGISTRY ───────────────────────────
console.log("\\n=== Global Symbol Registry ===");

const g1 = Symbol.for("app.theme");
const g2 = Symbol.for("app.theme");

console.log("  g1 === g2:", g1 === g2);              // true!
console.log("  keyFor(g1):", Symbol.keyFor(g1));     // "app.theme"
console.log("  keyFor(s1):", Symbol.keyFor(s1));     // undefined

// ─── Symbol.iterator — CUSTOM ITERATION ───────────────
console.log("\\n=== Symbol.iterator ===");

class Range {
    constructor(start, end, step = 1) {
        this.start = start;
        this.end   = end;
        this.step  = step;
    }

    [Symbol.iterator]() {
        let current = this.start;
        const { end, step } = this;
        return {
            next() {
                if (current <= end) {
                    const value = current;
                    current += step;
                    return { value, done: false };
                }
                return { value: undefined, done: true };
            },
            [Symbol.iterator]() { return this; }  // iterators should be iterable
        };
    }
}

const range = new Range(1, 10, 2);   // odd numbers 1-10

// for...of works:
const odds = [];
for (const n of range) odds.push(n);
console.log("  Odd numbers 1-10:", odds);

// Spread works:
console.log("  Spread:", [...new Range(0, 5)]);

// Destructuring works:
const [a, b, c] = new Range(10, 30, 10);
console.log("  Destructure:", a, b, c);   // 10 20 30

// ─── Symbol.toPrimitive ───────────────────────────────
console.log("\\n=== Symbol.toPrimitive ===");

class Money {
    constructor(amount, currency = "USD") {
        this.amount   = amount;
        this.currency = currency;
    }

    [Symbol.toPrimitive](hint) {
        if (hint === 'number')  return this.amount;
        if (hint === 'string')  return \`${
this.currency} ${
this.amount.toFixed(2)}\`;
        return this.amount;  // default (e.g., comparison)
    }

    add(other) {
        return new Money(this.amount + +other, this.currency);
    }
}

const price = new Money(29.99);
const tax   = new Money(2.40);

console.log("  +price:", +price);                          // 29.99
console.log("  \`${
price}\`:", \`${
price}\`);                  // "USD 29.99"
console.log("  price > 20:", price > 20);                  // true
console.log("  price + tax:", (price.amount + +tax));      // 32.39

// ─── Symbol.toStringTag ───────────────────────────────
console.log("\\n=== Symbol.toStringTag ===");

class Database {
    get [Symbol.toStringTag]() { return "Database"; }
}

class Queue {
    get [Symbol.toStringTag]() { return "Queue"; }
}

const db = new Database();
const q  = new Queue();

console.log("  Object.prototype.toString.call(db):",
    Object.prototype.toString.call(db));   // [object Database]
console.log("  Object.prototype.toString.call(q):",
    Object.prototype.toString.call(q));    // [object Queue]

// ─── PRACTICAL USE: PRIVATE-LIKE PROPERTIES ───────────
console.log("\\n=== Symbols for Non-Enumerable Properties ===");

const _validate = Symbol("validate");
const _data     = Symbol("data");

class DataStore {
    constructor(data) {
        this[_data] = [...data];
    }

    [_validate](item) {
        return item !== null && item !== undefined;
    }

    add(item) {
        if (!this[_validate](item)) throw new Error("Invalid item");
        this[_data].push(item);
        return this;
    }

    get all() { return [...this[_data]]; }
    get size() { return this[_data].length; }
}

const store = new DataStore([1, 2, 3]);
store.add(4).add(5);
console.log("  store.all:", store.all);
console.log("  store.size:", store.size);
console.log("  Enumerable keys:", Object.keys(store));   // [] — symbols hidden

📝 KEY POINTS:
✅ Symbol() always creates a unique value — even with the same description
✅ symbol.description gives the debug label; .toString() gives "Symbol(label)"
✅ Symbols as object keys are hidden from Object.keys(), for...in, and JSON.stringify()
✅ Use Object.getOwnPropertySymbols() or Reflect.ownKeys() to see symbol keys
✅ Symbol.for() creates global registry symbols — same key = same symbol across modules
✅ Symbol.iterator makes your class usable with for...of, spread, and destructuring
✅ Symbol.toPrimitive customizes how objects convert to numbers and strings
✅ Symbol.toStringTag customizes the output of Object.prototype.toString.call()
✅ Symbols are perfect for "semi-private" properties that won't clash with library code
❌ Symbols are NOT private — Object.getOwnPropertySymbols() can still find them
❌ Symbol() !== Symbol.for() — Symbol() is always unique, Symbol.for() looks up a registry
❌ Symbols can't be used as JSON keys — they're always omitted from JSON.stringify()
❌ Don't use Symbol as a constructor: new Symbol() throws a TypeError
""",
  quiz: [
    Quiz(question: 'What is guaranteed about Symbol() values?', options: [
      QuizOption(text: 'Every call to Symbol() returns a unique value — even two Symbol("same") calls are not equal', correct: true),
      QuizOption(text: 'Symbol values are globally unique strings prefixed with "Symbol:"', correct: false),
      QuizOption(text: 'Two Symbol() calls with the same description return the same value', correct: false),
      QuizOption(text: 'Symbol values are immutable numbers assigned sequentially by the runtime', correct: false),
    ]),
    Quiz(question: 'What happens to Symbol keys when you call JSON.stringify() on an object?', options: [
      QuizOption(text: 'Symbol keys are omitted entirely — they never appear in the JSON output', correct: true),
      QuizOption(text: 'Symbol keys are converted to strings using toString() and included', correct: false),
      QuizOption(text: 'JSON.stringify() throws a TypeError if the object has Symbol keys', correct: false),
      QuizOption(text: 'Symbol keys are included as null values in the JSON output', correct: false),
    ]),
    Quiz(question: 'What does implementing [Symbol.iterator]() on a class enable?', options: [
      QuizOption(text: 'The class instances can be used with for...of loops, spread syntax, and array destructuring', correct: true),
      QuizOption(text: 'The class can only be instantiated once (Singleton pattern)', correct: false),
      QuizOption(text: 'The class becomes an async iterable that works with for await...of', correct: false),
      QuizOption(text: 'The class instances automatically sort themselves when iterated', correct: false),
    ]),
  ],
);
