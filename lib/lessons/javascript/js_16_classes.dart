import '../../models/lesson.dart';
import '../../models/quiz.dart';

final jsLesson16 = Lesson(
  language: 'JavaScript',
  title: 'Classes: ES6+ Object-Oriented JavaScript',
  content: """
🎯 METAPHOR:
A class is like a blueprint for a house. The blueprint
defines the structure — how many rooms, where the wiring
goes, what the walls are made of. Each house you build
from that blueprint is an INSTANCE — a real, physical
house based on the blueprint. All houses from the same
blueprint share the same design, but each has its own
specific address, furniture, and inhabitants. JavaScript
classes work exactly like this: the class defines the
shape, constructors build the instance, methods are the
shared behaviors, and private fields are the interior
details that only the house itself can access.

📖 EXPLANATION:

─────────────────────────────────────
CLASS BASICS:
─────────────────────────────────────
  class Animal {
    // Class field (ES2022):
    type = "Animal";

    constructor(name) {
      this.name = name;  // instance property
    }

    // Method (on prototype — shared):
    speak() {
      return \`\${
this.name} makes a sound\`;
    }

    // Getter:
    get info() { return \`\${
this.type}:\${
this.name}\`; }

    // Static method:
    static create(name) { return new Animal(name); }
  }

  const a = new Animal("Rex");
  a.speak();     // "Rex makes a sound"
  a.info;        // "Animal: Rex"
  Animal.create("Max"); // static call

─────────────────────────────────────
INHERITANCE (extends / super):
─────────────────────────────────────
  class Dog extends Animal {
    constructor(name, breed) {
      super(name);           // MUST call super first!
      this.breed = breed;
    }

    speak() {
      return super.speak() + " — Woof!";  // call parent method
    }

    fetch() { return \`\${
this.name} fetches!\`; }
  }

  const dog = new Dog("Rex", "Labrador");
  dog.speak();    // "Rex makes a sound — Woof!"
  dog.fetch();    // "Rex fetches!"
  dog instanceof Dog;    // true
  dog instanceof Animal; // true

─────────────────────────────────────
PRIVATE FIELDS AND METHODS (#):
─────────────────────────────────────
  class BankAccount {
    #balance = 0;          // private field
    #owner;                // private field

    constructor(owner, initialBalance) {
      this.#owner = owner;
      this.#balance = initialBalance;
    }

    #validate(amount) {   // private method
      if (amount <= 0) throw new Error("Invalid amount");
    }

    deposit(amount) {
      this.#validate(amount);
      this.#balance += amount;
    }

    get balance() { return this.#balance; }
  }

  const acc = new BankAccount("Alice", 100);
  acc.balance;    // 100 ✅ (via getter)
  acc.#balance;   // ❌ SyntaxError — cannot access private field

─────────────────────────────────────
STATIC MEMBERS:
─────────────────────────────────────
  class MathUtils {
    static PI = 3.14159;

    static add(a, b) { return a + b; }
    static clamp(val, min, max) {
      return Math.min(Math.max(val, min), max);
    }
  }

  MathUtils.PI        // 3.14159
  MathUtils.add(2, 3) // 5
  // new MathUtils().add() → TypeError (can call on instance but usually shouldn't)

─────────────────────────────────────
CLASS FIELDS (public and private):
─────────────────────────────────────
  class Counter {
    count = 0;              // public field with default
    #step = 1;              // private field with default

    increment() { this.count += this.#step; }
    setStep(n) { this.#step = n; }
  }

─────────────────────────────────────
MIXINS — adding multiple behaviors:
─────────────────────────────────────
  const Serializable = (Base) => class extends Base {
    serialize() { return JSON.stringify(this); }
  };

  const Timestamped = (Base) => class extends Base {
    createdAt = new Date().toISOString();
  };

  class User extends Serializable(Timestamped(class {})) {
    constructor(name) {
      super();
      this.name = name;
    }
  }

─────────────────────────────────────
instanceof vs DUCK TYPING:
─────────────────────────────────────
  // instanceof — checks prototype chain:
  dog instanceof Animal   // true

  // Duck typing — checks behavior:
  typeof obj.speak === "function"  // more flexible

  // Symbol.hasInstance — customize instanceof:
  class EvenNumber {
    static [Symbol.hasInstance](n) {
      return Number.isInteger(n) && n % 2 === 0;
    }
  }
  4 instanceof EvenNumber   // true!
  3 instanceof EvenNumber   // false

💻 CODE:
// ─── BASIC CLASS ──────────────────────────────────────
console.log("=== Basic Class ===");
class Shape {
  #color = "black";
  #created = new Date().toISOString();
  static count = 0;

  constructor(color = "black") {
    this.#color = color;
    Shape.count++;
  }

  get color()   { return this.#color; }
  set color(v)  {
    const valid = ["red","green","blue","black","white","yellow"];
    if (!valid.includes(v)) throw new Error(\`Invalid color:\${
v}\`);
    this.#color = v;
  }
  get created() { return this.#created; }
  get area()    { return 0; }  // override in subclasses

  describe() {
    return \`\${
this.constructor.name}: color=\${
this.#color}, area=\${
this.area.toFixed(2)}\`;
  }

  toString() { return this.describe(); }

  static getCount() { return Shape.count; }
}

// ─── INHERITANCE ──────────────────────────────────────
class Circle extends Shape {
  #radius;

  constructor(radius, color) {
    super(color);  // must call super first
    this.#radius = radius;
  }

  get radius()  { return this.#radius; }
  get area()    { return Math.PI * this.#radius ** 2; }
  get perimeter() { return 2 * Math.PI * this.#radius; }

  describe() {
    return super.describe() + \`, radius=\${
this.#radius}\`;
  }

  scale(factor) {
    return new Circle(this.#radius * factor, this.color);
  }
}

class Rectangle extends Shape {
  #width; #height;

  constructor(width, height, color) {
    super(color);
    this.#width = width;
    this.#height = height;
  }

  get area()    { return this.#width * this.#height; }
  get isSquare(){ return this.#width === this.#height; }

  describe() {
    return super.describe() +
      \`,\${
this.#width}×\${
this.#height}\${
this.isSquare ? " (square)" : ""}\`;
  }
}

const circle = new Circle(5, "red");
const rect   = new Rectangle(4, 6, "blue");
const square = new Rectangle(5, 5, "green");

console.log(circle.describe());
console.log(rect.describe());
console.log(square.describe());

console.log("Shape count:", Shape.getCount());  // 3

console.log(circle instanceof Circle);  // true
console.log(circle instanceof Shape);   // true
console.log(rect instanceof Circle);    // false

// Scale
const bigCircle = circle.scale(2);
console.log(\`Scaled: radius=\${
bigCircle.radius.toFixed(1)}\`);

// ─── PRIVATE FIELDS ───────────────────────────────────
console.log("\n=== Private Fields (Bank Account) ===");
class BankAccount {
  #balance;
  #owner;
  #transactions = [];

  constructor(owner, initialBalance = 0) {
    this.#owner   = owner;
    this.#balance = initialBalance;
  }

  #log(type, amount) {
    this.#transactions.push({
      type, amount,
      balance: this.#balance,
      date: new Date().toISOString()
    });
  }

  deposit(amount) {
    if (amount <= 0) throw new Error("Deposit must be positive");
    this.#balance += amount;
    this.#log("deposit", amount);
    return this;  // chainable
  }

  withdraw(amount) {
    if (amount <= 0) throw new Error("Withdrawal must be positive");
    if (amount > this.#balance) throw new Error("Insufficient funds");
    this.#balance -= amount;
    this.#log("withdrawal", -amount);
    return this;  // chainable
  }

  get balance() { return this.#balance; }
  get owner()   { return this.#owner; }
  get history() { return [...this.#transactions]; }

  toString() {
    return \`\${
this.#owner}'s account: \$\${
this.#balance.toFixed(2)}\`;
  }
}

const account = new BankAccount("Alice", 1000);
account.deposit(500).withdraw(200).deposit(100);  // chaining

console.log(account.toString());
console.log("Balance:", account.balance);
console.log("Transactions:", account.history.length);

try {
  account.withdraw(10000);
} catch (e) {
  console.log("Error:", e.message);
}

// ─── STATIC MEMBERS ───────────────────────────────────
console.log("\n=== Static Members ===");
class Temperature {
  static ABSOLUTE_ZERO_C = -273.15;

  #celsius;
  constructor(celsius) { this.#celsius = celsius; }

  get celsius()    { return this.#celsius; }
  get fahrenheit() { return this.#celsius * 9/5 + 32; }
  get kelvin()     { return this.#celsius - Temperature.ABSOLUTE_ZERO_C; }

  static fromFahrenheit(f) { return new Temperature((f - 32) * 5/9); }
  static fromKelvin(k) { return new Temperature(k + Temperature.ABSOLUTE_ZERO_C); }

  toString() { return \`\${
this.#celsius}°C\`; }
}

const boiling = new Temperature(100);
const body    = Temperature.fromFahrenheit(98.6);

console.log(\`Boiling:\${
boiling} =\${
boiling.fahrenheit}°F =\${
boiling.kelvin.toFixed(2)}K\`);
console.log(\`Body:\${
body.celsius.toFixed(1)}°C\`);
console.log(\`Absolute zero:\${
Temperature.ABSOLUTE_ZERO_C}°C\`);

// ─── MIXIN PATTERN ────────────────────────────────────
console.log("\n=== Mixin Pattern ===");
const Serializable = (Base) => class extends Base {
  serialize()   { return JSON.stringify(this, null, 2); }
  static deserialize(json) {
    return Object.assign(new this(), JSON.parse(json));
  }
};

const Observable = (Base) => class extends Base {
  #listeners = {};
  on(event, fn)  { (this.#listeners[event] ??= []).push(fn); }
  emit(event, data) {
    (this.#listeners[event] || []).forEach(fn => fn(data));
  }
};

class User extends Serializable(Observable(class {})) {
  constructor(name, email) {
    super();
    this.name  = name;
    this.email = email;
  }
}

const user = new User("Terry", "terry@example.com");
user.on("update", data => console.log("Updated:", data));
user.emit("update", { field: "email", value: "new@email.com" });
console.log(user.serialize());

📝 KEY POINTS:
✅ class syntax is syntactic sugar over prototypes — methods go on Constructor.prototype
✅ super() MUST be called before using 'this' in a subclass constructor
✅ Private fields (#) are truly private — not accessible outside the class (not even subclasses)
✅ Getters/setters provide computed properties and validation with clean property syntax
✅ Static members belong to the class itself, not instances
✅ Method chaining: return this from methods to enable obj.a().b().c()
✅ Mixins are the JavaScript answer to multiple inheritance
✅ instanceof checks prototype chain — works with extends
❌ Forgetting super() in a subclass constructor throws ReferenceError before 'this' is available
❌ Private fields (#) are different from convention-private (_prefix) — # is enforced by the engine
❌ Static methods are NOT inherited by instances — they're called on the class
""",
  quiz: [
    Quiz(
      question: 'What is the difference between a private field (#name) and a convention-private field (_name)?',
      options: [
        QuizOption(text: '#name is truly private — enforced by the JavaScript engine; _name is just a naming convention with no enforcement', correct: true),
        QuizOption(text: 'They are equivalent — both prevent external access to the field', correct: false),
        QuizOption(text: '#name is faster because the engine optimizes private fields', correct: false),
        QuizOption(text: '#name is only for primitive values; _name works for objects', correct: false),
      ],
    ),
    Quiz(
      question: 'Why must super() be called before using "this" in a subclass constructor?',
      options: [
        QuizOption(text: 'The parent constructor initializes "this" — until super() runs, "this" is not yet available in the subclass', correct: true),
        QuizOption(text: 'super() registers the subclass with the prototype chain', correct: false),
        QuizOption(text: 'It is just convention — forgetting super() only causes a lint warning', correct: false),
        QuizOption(text: 'super() copies the parent class methods onto the subclass instance', correct: false),
      ],
    ),
    Quiz(
      question: 'What does a static method belong to?',
      options: [
        QuizOption(text: 'The class itself — called as ClassName.method(), not on instances', correct: true),
        QuizOption(text: 'All instances — it is shared on the prototype', correct: false),
        QuizOption(text: 'The instance that called it most recently', correct: false),
        QuizOption(text: 'The parent class when called through inheritance', correct: false),
      ],
    ),
  ],
);
