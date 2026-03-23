import '../../models/lesson.dart';
import '../../models/quiz.dart';

final jsLesson15 = Lesson(
  language: 'JavaScript',
  title: 'Prototypes and the Prototype Chain',
  content: """
🎯 METAPHOR:
Prototypes are like family heirlooms — traits and abilities
that get passed down through generations. When you ask
someone "can you cook?", JavaScript first checks if THEY
personally know how to cook. If not, it asks their parent.
If their parent doesn't know, it asks their grandparent.
This search continues up the family tree until someone
says yes, or the family tree ends (null). This chain of
inheritance is the prototype chain, and it's how ALL
JavaScript objects share methods. When you call
arr.push(), JavaScript doesn't find push directly on
your array — it finds it on Array.prototype, which is
the "parent" of all arrays.

📖 EXPLANATION:

─────────────────────────────────────
EVERY OBJECT HAS A PROTOTYPE:
─────────────────────────────────────
  Every object has an internal [[Prototype]] link.
  When you access a property:
  1. Look on the object itself
  2. Look on its prototype
  3. Look on the prototype's prototype
  4. Continue until null (end of chain)

─────────────────────────────────────
THE PROTOTYPE CHAIN:
─────────────────────────────────────
  myArray → Array.prototype → Object.prototype → null

  All arrays share Array.prototype's methods.
  All objects share Object.prototype's methods.

─────────────────────────────────────
ACCESSING THE PROTOTYPE:
─────────────────────────────────────
  Object.getPrototypeOf(obj)     → get prototype
  Object.setPrototypeOf(obj, p)  → set prototype (avoid)
  obj.__proto__                  → legacy, avoid

  // Check if in prototype chain:
  obj instanceof Constructor     → true/false

─────────────────────────────────────
CREATING OBJECTS WITH PROTOTYPES:
─────────────────────────────────────
  // Object.create():
  const animal = {
    type: "Animal",
    describe() { return \`I am a \${this.type}\`; }
  };
  const dog = Object.create(animal);
  dog.type = "Dog";
  dog.describe(); // "I am a Dog"

  // Constructor functions (pre-class syntax):
  function Animal(type) {
    this.type = type;
  }
  Animal.prototype.describe = function() {
    return \`I am a \${this.type}\`;
  };
  const cat = new Animal("Cat");

─────────────────────────────────────
PROTOTYPE INHERITANCE:
─────────────────────────────────────
  // Using Object.create for inheritance:
  function Dog(name) {
    Animal.call(this, "Dog");  // call parent constructor
    this.name = name;
  }
  Dog.prototype = Object.create(Animal.prototype);
  Dog.prototype.constructor = Dog;
  Dog.prototype.bark = function() { return "Woof!"; };

  → Modern code uses class syntax instead (next lesson).

─────────────────────────────────────
PROTOTYPE POLLUTION — NEVER DO THIS:
─────────────────────────────────────
  Array.prototype.myMethod = function() {};  // ❌ NEVER
  Object.prototype.key = "value";            // ❌ NEVER

  This adds to EVERY array/object in the program.
  Causes subtle bugs throughout the codebase.

─────────────────────────────────────
instanceof AND PROTOTYPE:
─────────────────────────────────────
  [] instanceof Array    → true
  [] instanceof Object   → true (Array extends Object)
  {} instanceof Array    → false
  typeof []              → "object" (not helpful)
  Array.isArray([])      → true (most reliable check)

─────────────────────────────────────
hasOwnProperty vs prototype:
─────────────────────────────────────
  const obj = { x: 1 };
  obj.x              → 1 (own property)
  obj.toString       → inherited from Object.prototype

  Object.hasOwn(obj, "x")        → true ✅ (ES2022)
  obj.hasOwnProperty("x")        → true (older)
  Object.hasOwn(obj, "toString") → false (inherited)

─────────────────────────────────────
PROTOTYPE-BASED vs CLASS-BASED:
─────────────────────────────────────
  JavaScript is prototype-based at heart.
  ES6 class syntax is syntactic sugar over prototypes.
  Under the hood:
  class Animal {} → function Animal() {}
                    with Animal.prototype.method = ...

💻 CODE:
// ─── PROTOTYPE CHAIN ──────────────────────────────────
console.log("=== Prototype Chain ===");
const arr = [1, 2, 3];
console.log(Object.getPrototypeOf(arr) === Array.prototype);  // true
console.log(Object.getPrototypeOf(Array.prototype) === Object.prototype); // true
console.log(Object.getPrototypeOf(Object.prototype)); // null ← chain ends

// All arrays share Array.prototype methods:
console.log(arr.hasOwnProperty("0")); // true (0 is own property)
console.log(arr.hasOwnProperty("push")); // false (from Array.prototype)
console.log("push" in arr); // true (found in chain)

// ─── Object.create ────────────────────────────────────
console.log("\n=== Object.create ===");
const vehicleProto = {
  type: "Vehicle",
  describe() {
    return \`I am a \${this.type} named \${this.name}\`;
  },
  start() {
    return \`\${this.name} started!\`;
  }
};

const car = Object.create(vehicleProto);
car.name = "Tesla";
car.type = "Car";

const bike = Object.create(vehicleProto);
bike.name = "Harley";
bike.type = "Motorcycle";

console.log(car.describe());   // I am a Car named Tesla
console.log(bike.describe());  // I am a Motorcycle named Harley
console.log(car.start());      // Tesla started!

// Check prototype chain:
console.log(Object.getPrototypeOf(car) === vehicleProto); // true

// ─── CONSTRUCTOR FUNCTIONS ────────────────────────────
console.log("\n=== Constructor Functions ===");
function Animal(name, sound) {
  this.name  = name;
  this.sound = sound;
}
// Methods on prototype — shared by all instances:
Animal.prototype.speak = function() {
  return \`\${this.name} says \${this.sound}!\`;
};
Animal.prototype.toString = function() {
  return \`Animal(\${this.name})\`;
};

const dog = new Animal("Rex", "Woof");
const cat = new Animal("Whiskers", "Meow");

console.log(dog.speak());  // Rex says Woof!
console.log(cat.speak());  // Whiskers says Meow!
// Both share the SAME speak function from the prototype:
console.log(dog.speak === cat.speak);  // true

// Inheritance (pre-class):
function Dog(name) {
  Animal.call(this, name, "Woof");  // call parent constructor
  this.breed = "Unknown";
}
Dog.prototype = Object.create(Animal.prototype);
Dog.prototype.constructor = Dog;
Dog.prototype.fetch = function() {
  return \`\${this.name} fetches the ball!\`;
};

const rex = new Dog("Rex");
console.log(rex.speak());   // Rex says Woof! (inherited)
console.log(rex.fetch());   // Rex fetches the ball!
console.log(rex instanceof Dog);    // true
console.log(rex instanceof Animal); // true

// ─── instanceof ───────────────────────────────────────
console.log("\n=== instanceof ===");
console.log([] instanceof Array);   // true
console.log([] instanceof Object);  // true (Array extends Object)
console.log({} instanceof Array);   // false
console.log("hi" instanceof String);// false (primitive, not wrapper)

// Array.isArray is more reliable:
console.log(Array.isArray([]));  // true
console.log(Array.isArray({}));  // false

// ─── OWN vs INHERITED ─────────────────────────────────
console.log("\n=== Own vs Inherited Properties ===");
const obj = { x: 1, y: 2 };
console.log(Object.hasOwn(obj, "x"));         // true
console.log(Object.hasOwn(obj, "toString"));  // false (inherited)
console.log("toString" in obj);               // true (found in chain)

// Filter out inherited when iterating:
for (const key in obj) {
  if (Object.hasOwn(obj, key)) {
    console.log("Own:", key, obj[key]);
  }
}

// ─── UNDERSTANDING CLASSES AS PROTOTYPE SUGAR ─────────
console.log("\n=== Classes ARE Prototypes ===");
class PersonClass {
  constructor(name) {
    this.name = name;
  }
  greet() {
    return \`Hello, I'm \${this.name}!\`;
  }
}

const alice = new PersonClass("Alice");
// Under the hood:
console.log(typeof PersonClass);               // "function"!
console.log(alice.greet === PersonClass.prototype.greet); // true
console.log(Object.getPrototypeOf(alice) === PersonClass.prototype); // true

// ─── PRACTICAL: Mixin pattern ─────────────────────────
console.log("\n=== Mixin Pattern ===");
const Serializable = {
  serialize()   { return JSON.stringify(this); },
  toJSON()      { return Object.assign({}, this); },
};

const Validatable = {
  validate() {
    return Object.keys(this).every(k => this[k] !== null && this[k] !== undefined);
  }
};

function createModel(props) {
  return Object.assign(Object.create({ ...Serializable, ...Validatable }), props);
}

const model = createModel({ id: 1, name: "Test", value: 42 });
console.log(model.serialize());  // JSON
console.log(model.validate());   // true

📝 KEY POINTS:
✅ Every JavaScript object has a prototype — a chain of inherited properties
✅ Property lookup walks up the prototype chain until found or null is reached
✅ Array.prototype, String.prototype, Object.prototype contain all built-in methods
✅ Object.create(proto) creates an object with a specific prototype
✅ class syntax in ES6 is syntactic sugar over prototype-based inheritance
✅ instanceof checks if a constructor's prototype is anywhere in the object's chain
✅ Object.hasOwn() checks for OWN properties only — use over in operator when needed
✅ All instances of a class share the SAME prototype methods — memory efficient
❌ NEVER modify built-in prototypes (Array.prototype, Object.prototype) — causes global bugs
❌ obj.__proto__ is deprecated — use Object.getPrototypeOf() instead
❌ instanceof can lie across different realms (iframes) — use Array.isArray for arrays
""",
  quiz: [
    Quiz(
      question: 'What is the prototype chain used for in JavaScript?',
      options: [
        QuizOption(text: 'Property lookup — when a property is not found on an object, JavaScript searches up the prototype chain until it finds it or reaches null', correct: true),
        QuizOption(text: 'Memory management — prototypes prevent objects from being garbage collected', correct: false),
        QuizOption(text: 'Security — prototypes restrict which code can access an object\'s properties', correct: false),
        QuizOption(text: 'Performance — the prototype chain caches property lookups for faster access', correct: false),
      ],
    ),
    Quiz(
      question: 'How does the ES6 class syntax relate to prototypes?',
      options: [
        QuizOption(text: 'class is syntactic sugar over prototypes — methods are added to Constructor.prototype, just like pre-class code', correct: true),
        QuizOption(text: 'class introduces a completely new object model separate from prototypes', correct: false),
        QuizOption(text: 'class syntax creates deep copies of all methods for each instance', correct: false),
        QuizOption(text: 'class is faster because it bypasses the prototype chain for method lookups', correct: false),
      ],
    ),
    Quiz(
      question: 'What does Object.hasOwn(obj, key) check?',
      options: [
        QuizOption(text: 'Whether the key is a direct (own) property of obj — not inherited from its prototype', correct: true),
        QuizOption(text: 'Whether the key exists anywhere in the prototype chain', correct: false),
        QuizOption(text: 'Whether the key\'s value is truthy', correct: false),
        QuizOption(text: 'Whether the key is configurable (can be deleted)', correct: false),
      ],
    ),
  ],
);
