import '../../models/lesson.dart';
import '../../models/quiz.dart';

final jsLesson11 = Lesson(
  language: 'JavaScript',
  title: 'Objects: Creation, Access, and Methods',
  content: """
🎯 METAPHOR:
A JavaScript object is like a physical filing cabinet
with labeled drawers. Each drawer has a name (key) and
holds something (value). You can add new drawers, remove
old ones, rename them, and look inside any one by name.
The cabinet is open by default — anything with a reference
to the cabinet can read and modify any drawer. Modern
JavaScript gives you tools to lock certain drawers
(Object.freeze, getters/setters) and get a manifest of
all drawers (Object.keys, Object.entries).

📖 EXPLANATION:

─────────────────────────────────────
OBJECT LITERALS:
─────────────────────────────────────
  const obj = {
    key: "value",
    number: 42,
    nested: { x: 1 },
    method() { return "hello"; },
    "multi word key": true,
    [computedKey]: "dynamic",
  };

─────────────────────────────────────
PROPERTY ACCESS:
─────────────────────────────────────
  obj.name          → dot notation
  obj["name"]       → bracket notation (dynamic keys)
  obj?.name         → optional chaining
  obj["multi word"] → must use bracket for special keys

─────────────────────────────────────
ADDING, MODIFYING, DELETING:
─────────────────────────────────────
  obj.newProp = "new";          // add
  obj.existing = "updated";     // modify
  delete obj.unwanted;          // remove

─────────────────────────────────────
SHORTHAND PROPERTIES (ES6):
─────────────────────────────────────
  const name = "Alice";
  const age  = 28;
  const user = { name, age };   // same as { name: name, age: age }

─────────────────────────────────────
COMPUTED PROPERTY NAMES:
─────────────────────────────────────
  const key = "dynamic";
  const obj = { [key]: "value" };     // { dynamic: "value" }
  const prefix = "get";
  const obj2 = { [\`\${
prefix}Name\`]: fn }; // { getName: fn }

─────────────────────────────────────
METHODS AND this:
─────────────────────────────────────
  const counter = {
    count: 0,
    increment() { this.count++; },     // method shorthand
    getCount() { return this.count; },
  };
  counter.increment();
  counter.getCount(); // 1

─────────────────────────────────────
OBJECT STATIC METHODS:
─────────────────────────────────────
  Object.keys(obj)         → array of own enumerable keys
  Object.values(obj)       → array of own values
  Object.entries(obj)      → array of [key, value] pairs
  Object.assign(target, src) → shallow copy/merge
  Object.freeze(obj)       → make immutable (shallow)
  Object.isFrozen(obj)     → check if frozen
  Object.create(proto)     → create with prototype
  Object.fromEntries(pairs) → create from [key,val] pairs
  Object.hasOwn(obj, key)  → check own property (ES2022)
  Object.getOwnPropertyNames(obj) → all own keys inc. non-enum
  Object.getPrototypeOf(obj) → get prototype

─────────────────────────────────────
SPREAD AND MERGE:
─────────────────────────────────────
  const copy    = { ...obj };              // shallow copy
  const merged  = { ...obj1, ...obj2 };   // merge (obj2 wins)
  const updated = { ...user, age: 29 };   // update one field

─────────────────────────────────────
GETTERS AND SETTERS:
─────────────────────────────────────
  const user = {
    _name: "",
    get name() { return this._name.trim(); },
    set name(val) {
      if (typeof val !== "string") throw new Error("Must be string");
      this._name = val;
    },
  };

─────────────────────────────────────
PROPERTY DESCRIPTORS:
─────────────────────────────────────
  Object.defineProperty(obj, "key", {
    value: 42,
    writable: false,    // cannot reassign
    enumerable: false,  // won't appear in loops
    configurable: false,// cannot delete or redefine
  });

💻 CODE:
// ─── OBJECT CREATION ──────────────────────────────────
console.log("=== Object Literals ===");
const name = "Alice";
const age = 28;
const user = {
  name,          // shorthand
  age,           // shorthand
  city: "London",
  isActive: true,
  scores: [95, 87, 92],
  address: {
    street: "123 Main St",
    zip: "EC1A 1BB"
  },
  greet() {
    return \`Hi, I'm\${
this.name}!\`;
  }
};

console.log(user.name);            // Alice
console.log(user["age"]);          // 28
console.log(user.address.zip);     // EC1A 1BB
console.log(user.greet());         // Hi, I'm Alice!

// Dynamic key access
const field = "city";
console.log(user[field]);          // London

// ─── ADDING / MODIFYING / DELETING ────────────────────
console.log("\n=== Modifying Objects ===");
const config = { host: "localhost", port: 3000 };
config.debug = true;              // add
config.port = 8080;               // modify
delete config.debug;              // remove
console.log(config);              // { host: 'localhost', port: 8080 }

// ─── OBJECT STATIC METHODS ────────────────────────────
console.log("\n=== Object Static Methods ===");
const person = { name: "Bob", age: 34, city: "Paris" };

console.log(Object.keys(person));    // ['name','age','city']
console.log(Object.values(person));  // ['Bob',34,'Paris']
console.log(Object.entries(person)); // [['name','Bob'],['age',34],...]

// from entries:
const swapped = Object.fromEntries(
  Object.entries(person).map(([k, v]) => [v, k])
);
console.log(swapped);  // {Bob:'name', 34:'age', Paris:'city'}

// assign (shallow merge):
const defaults = { theme: "light", lang: "en", debug: false };
const userPrefs = { theme: "dark", lang: "fr" };
const settings = Object.assign({}, defaults, userPrefs);
console.log(settings);  // dark, fr, debug:false

// spread merge (preferred):
const settingsSpread = { ...defaults, ...userPrefs };
console.log(settingsSpread);  // same result

// freeze:
const frozen = Object.freeze({ x: 1, y: 2 });
frozen.x = 99;   // silently ignored (strict mode throws)
console.log(frozen.x);  // still 1

// hasOwn (ES2022):
console.log(Object.hasOwn(person, "name"));   // true
console.log(Object.hasOwn(person, "email"));  // false

// ─── SPREAD AND UPDATE ────────────────────────────────
console.log("\n=== Spread and Update ===");
const original = { a: 1, b: 2, c: 3 };
const copy = { ...original };
const updated = { ...original, b: 99, d: 4 };
console.log(copy);     // {a:1,b:2,c:3}
console.log(updated);  // {a:1,b:99,c:3,d:4}
console.log(original); // unchanged

// ─── GETTERS AND SETTERS ──────────────────────────────
console.log("\n=== Getters and Setters ===");
const rectangle = {
  _width: 0,
  _height: 0,
  get width()  { return this._width; },
  get height() { return this._height; },
  get area()   { return this._width * this._height; },
  get perimeter() { return 2 * (this._width + this._height); },
  set width(v)  { if (v >= 0) this._width = v; },
  set height(v) { if (v >= 0) this._height = v; },
};

rectangle.width = 5;
rectangle.height = 3;
console.log(\`\${rectangle.width}×\${rectangle.height}\`); // 5×3
console.log("Area:", rectangle.area);       // 15
console.log("Perimeter:", rectangle.perimeter); // 16
rectangle.width = -1;  // rejected by setter
console.log("Width still:", rectangle.width); // 5

// ─── COMPUTED KEYS ────────────────────────────────────
console.log("\n=== Computed Property Names ===");
const prefix = "user";
const index = 1;
const dynamic = {
  [\`\${
prefix}_\${
index}\`]: "Alice",
  [\`\${
prefix}_\${
index + 1}\`]: "Bob",
};
console.log(dynamic); // { user_1: 'Alice', user_2: 'Bob' }

// ─── PROPERTY DESCRIPTORS ─────────────────────────────
console.log("\n=== Property Descriptors ===");
const obj = {};
Object.defineProperty(obj, "PI", {
  value: 3.14159,
  writable: false,
  enumerable: true,
  configurable: false,
});
obj.PI = 999;  // silently ignored
console.log(obj.PI);                         // 3.14159
console.log(Object.keys(obj));               // ['PI']
console.log(Object.getOwnPropertyDescriptor(obj, "PI"));

// ─── PRACTICAL PATTERNS ───────────────────────────────
console.log("\n=== Practical Patterns ===");
// Merge deep (simple version):
const mergeDeep = (target, source) => {
  const result = { ...target };
  for (const key of Object.keys(source)) {
    if (source[key] && typeof source[key] === "object"
        && !Array.isArray(source[key])) {
      result[key] = mergeDeep(target[key] || {}, source[key]);
    } else {
      result[key] = source[key];
    }
  }
  return result;
};

const base = { a: 1, b: { c: 2, d: 3 } };
const override = { b: { c: 99, e: 5 }, f: 6 };
console.log(mergeDeep(base, override));
// {a:1, b:{c:99, d:3, e:5}, f:6}

// Pick specific keys:
const pick = (obj2, keys) =>
  Object.fromEntries(keys.map(k => [k, obj2[k]]));
const full = { name: "Alice", age: 28, password: "secret" };
console.log(pick(full, ["name", "age"]));  // {name:'Alice', age:28}

// Omit keys:
const omit = (obj2, keys) =>
  Object.fromEntries(
    Object.entries(obj2).filter(([k]) => !keys.includes(k))
  );
console.log(omit(full, ["password"]));  // {name:'Alice', age:28}

📝 KEY POINTS:
✅ Shorthand properties: const obj = { name, age } instead of { name: name, age: age }
✅ Computed keys: { [expression]: value } — evaluated at runtime
✅ Object.keys/values/entries return arrays of the own enumerable properties
✅ Spread syntax {...obj} creates a SHALLOW copy — nested objects are still shared
✅ Object.freeze() makes an object immutable (shallow — nested objects still mutable)
✅ Object.hasOwn(obj, key) is the modern way to check own properties (ES2022)
✅ Getters/setters provide computed properties and validation with property syntax
✅ Object.fromEntries(entries) is the inverse of Object.entries(obj)
❌ Spread and Object.assign are SHALLOW — nested objects are not deeply copied
❌ delete operator removes a property but does NOT affect object copies
❌ for...in iterates inherited properties too — use Object.keys() or Object.hasOwn()
""",
  quiz: [
    Quiz(
      question: 'What does Object.freeze() do, and what is its limitation?',
      options: [
        QuizOption(text: 'It prevents adding, removing, or modifying properties of the object — but it is shallow: nested objects can still be mutated', correct: true),
        QuizOption(text: 'It creates a deep immutable copy of the object and all nested objects', correct: false),
        QuizOption(text: 'It prevents the object from being garbage collected', correct: false),
        QuizOption(text: 'It converts the object to a read-only Map for efficient lookups', correct: false),
      ],
    ),
    Quiz(
      question: 'How do you create a copy of an object with one property changed?',
      options: [
        QuizOption(text: 'const updated = { ...original, key: newValue } — spread copies existing props, then the new key overwrites', correct: true),
        QuizOption(text: 'Object.assign(original, { key: newValue }) — but this mutates the original', correct: false),
        QuizOption(text: 'original.key = newValue — this only works on frozen objects', correct: false),
        QuizOption(text: 'Object.clone(original, { key: newValue }) — the standard clone method', correct: false),
      ],
    ),
    Quiz(
      question: 'What does Object.entries(obj) return?',
      options: [
        QuizOption(text: 'An array of [key, value] pairs for each own enumerable property', correct: true),
        QuizOption(text: 'An array of all keys including inherited properties', correct: false),
        QuizOption(text: 'An iterator that yields property descriptors', correct: false),
        QuizOption(text: 'A Map of the object\'s key-value pairs', correct: false),
      ],
    ),
  ],
);
