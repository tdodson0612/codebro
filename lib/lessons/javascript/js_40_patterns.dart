import '../../models/lesson.dart';
import '../../models/quiz.dart';

final jsLesson40 = Lesson(
  language: 'JavaScript',
  title: 'JavaScript Design Patterns',
  content: """
🎯 METAPHOR:
Design patterns are recipes that experienced chefs have
already figured out for common cooking challenges. You
don't need to discover from scratch how to make a roux
or braise meat — there's a well-tested technique for it.
Similarly, design patterns are solutions to recurring
software design problems. The Singleton says "you only
need one instance of this — like the world's only copy
of a master recipe book." The Observer says "notify
everyone who signed up for this newsletter when new
content arrives." The Factory says "I'll handle the
complicated decision of which type of sauce to make —
you just tell me what dish you're cooking."

📖 EXPLANATION:
JavaScript patterns leverage its unique features:
first-class functions, closures, prototypes, and modules.

─────────────────────────────────────
MODULE PATTERN (IIFE):
─────────────────────────────────────
  const Counter = (() => {
      let count = 0;          // private state

      return {
          increment: () => ++count,
          decrement: () => --count,
          reset:     () => { count = 0; },
          value:     () => count,
      };
  })();

  // ES modules replaced this — use them instead.

─────────────────────────────────────
SINGLETON:
─────────────────────────────────────
  // Lazy singleton:
  class Config {
      static #instance = null;
      #data = {};

      static getInstance() {
          if (!Config.#instance) Config.#instance = new Config();
          return Config.#instance;
      }

      get(key)      { return this.#data[key]; }
      set(key, val) { this.#data[key] = val; }
  }

  // Module-based singleton (better):
  export const config = new Config();

─────────────────────────────────────
OBSERVER / PUBSUB:
─────────────────────────────────────
  class EventBus {
      #subscribers = new Map();

      subscribe(event, fn) {
          if (!this.#subscribers.has(event)) this.#subscribers.set(event, []);
          this.#subscribers.get(event).push(fn);
          return () => this.unsubscribe(event, fn);  // return unsubscriber
      }

      publish(event, data) {
          (this.#subscribers.get(event) || []).forEach(fn => fn(data));
      }
  }

─────────────────────────────────────
FACTORY:
─────────────────────────────────────
  class NotificationFactory {
      static create(type, data) {
          switch (type) {
              case 'email':  return new EmailNotification(data);
              case 'sms':    return new SmsNotification(data);
              case 'push':   return new PushNotification(data);
              default: throw new Error(\`Unknown type: ${
type}\`);
          }
      }
  }
  const n = NotificationFactory.create('email', { to: 'a@b.com' });

─────────────────────────────────────
STRATEGY:
─────────────────────────────────────
  class Sorter {
      #strategy;
      constructor(strategy) { this.#strategy = strategy; }
      setStrategy(s)        { this.#strategy = s; }
      sort(data)            { return this.#strategy(data); }
  }

  const sorter = new Sorter(arr => [...arr].sort((a,b) => a-b));
  sorter.sort([3,1,2]);   // [1,2,3]

  sorter.setStrategy(arr => [...arr].sort((a,b) => b-a));
  sorter.sort([3,1,2]);   // [3,2,1]

─────────────────────────────────────
DECORATOR (JavaScript-native):
─────────────────────────────────────
  // Function decorator:
  function memoize(fn) {
      const cache = new Map();
      return (...args) => {
          const key = JSON.stringify(args);
          if (cache.has(key)) return cache.get(key);
          const result = fn(...args);
          cache.set(key, result);
          return result;
      };
  }

  // Class decorator (TC39 Stage 3):
  function readonly(target, key, descriptor) {
      descriptor.writable = false;
      return descriptor;
  }

─────────────────────────────────────
PROXY PATTERN:
─────────────────────────────────────
  function createProxy(target) {
      return new Proxy(target, {
          get(t, prop) { log(\`Getting ${
prop}\`); return t[prop]; },
          set(t, prop, val) { log(\`Setting ${
prop}\`); t[prop] = val; return true; }
      });
  }

─────────────────────────────────────
COMMAND:
─────────────────────────────────────
  class CommandManager {
      #history = [];
      #undone  = [];

      execute(command) {
          command.execute();
          this.#history.push(command);
          this.#undone = [];
      }

      undo() {
          const cmd = this.#history.pop();
          if (!cmd) return;
          cmd.undo();
          this.#undone.push(cmd);
      }

      redo() {
          const cmd = this.#undone.pop();
          if (!cmd) return;
          cmd.execute();
          this.#history.push(cmd);
      }
  }

─────────────────────────────────────
BUILDER:
─────────────────────────────────────
  class QueryBuilder {
      #table; #conditions = []; #limit; #offset; #order;

      from(table)         { this.#table = table; return this; }
      where(cond)         { this.#conditions.push(cond); return this; }
      limit(n)            { this.#limit = n; return this; }
      offset(n)           { this.#offset = n; return this; }
      orderBy(field, dir) { this.#order = \`${
field} ${
dir}\`; return this; }

      build() {
          let sql = \`SELECT * FROM ${
this.#table}\`;
          if (this.#conditions.length) sql += \` WHERE ${
this.#conditions.join(' AND ')}\`;
          if (this.#order) sql += \` ORDER BY ${
this.#order}\`;
          if (this.#limit)  sql += \` LIMIT ${
this.#limit}\`;
          if (this.#offset) sql += \` OFFSET ${
this.#offset}\`;
          return sql;
      }
  }

  const query = new QueryBuilder()
      .from('users')
      .where("age > 18")
      .where("active = true")
      .orderBy('name', 'ASC')
      .limit(10)
      .build();

💻 CODE:
// ─── OBSERVER / EVENT BUS ─────────────────────────────
console.log("=== Observer / Event Bus ===");

class EventBus {
    #subscribers = new Map();

    subscribe(event, fn) {
        if (!this.#subscribers.has(event)) this.#subscribers.set(event, new Set());
        this.#subscribers.get(event).add(fn);
        return () => this.#subscribers.get(event)?.delete(fn);
    }

    publish(event, data) {
        console.log(\`  [EventBus] emit: ${
event}\`);
        (this.#subscribers.get(event) || new Set()).forEach(fn => fn(data));
    }

    once(event, fn) {
        const unsub = this.subscribe(event, (data) => {
            fn(data);
            unsub();
        });
    }
}

const bus = new EventBus();

const unsubCart = bus.subscribe('cart:updated', ({ items, total }) => {
    console.log(\`  CartView: ${
items} items, total: \$${
total.toFixed(2)}\`);
});

bus.subscribe('cart:updated', ({ items }) => {
    console.log(\`  HeaderBadge: showing count ${
items}\`);
});

bus.once('cart:cleared', () => {
    console.log("  CartView: cart was cleared (fires once)");
});

bus.publish('cart:updated', { items: 3, total: 87.99 });
bus.publish('cart:updated', { items: 4, total: 112.49 });
bus.publish('cart:cleared', {});
bus.publish('cart:cleared', {});  // doesn't fire again

unsubCart();  // CartView stops listening
bus.publish('cart:updated', { items: 2, total: 45.00 });

// ─── FACTORY ──────────────────────────────────────────
console.log("\n=== Factory Pattern ===");

class TextValidator {
    validate(value) { return typeof value === 'string' && value.trim().length > 0; }
    message() { return "Must be a non-empty string"; }
}
class NumberValidator {
    constructor(min, max) { this.min = min; this.max = max; }
    validate(value) { return typeof value === 'number' && value >= this.min && value <= this.max; }
    message() { return \`Must be a number between ${
this.min} and ${
this.max}\`; }
}
class EmailValidator {
    validate(value) { return /^[^\\s@]+@[^\\s@]+\\.[^\\s@]+\$/.test(value); }
    message() { return "Must be a valid email address"; }
}
class RegexValidator {
    constructor(pattern, msg) { this.pattern = pattern; this.msg = msg; }
    validate(value) { return this.pattern.test(value); }
    message() { return this.msg; }
}

function validatorFactory(type, options = {}) {
    switch (type) {
        case 'text':   return new TextValidator();
        case 'number': return new NumberValidator(options.min ?? -Infinity, options.max ?? Infinity);
        case 'email':  return new EmailValidator();
        case 'regex':  return new RegexValidator(options.pattern, options.message);
        default: throw new Error(\`Unknown validator type: ${
type}\`);
    }
}

const validators = {
    name:  validatorFactory('text'),
    age:   validatorFactory('number', { min: 0, max: 150 }),
    email: validatorFactory('email'),
    slug:  validatorFactory('regex', { pattern: /^[a-z0-9-]+\$/, message: "Use lowercase, digits, hyphens" }),
};

const testData = [
    { name: "Alice", age: 28, email: "alice@example.com", slug: "alice-chen" },
    { name: "",      age: 200, email: "not-an-email",     slug: "Alice Chen!" },
];

testData.forEach((data, i) => {
    console.log(\`  Test case ${
i + 1}:\`);
    Object.entries(validators).forEach(([field, v]) => {
        const valid = v.validate(data[field]);
        console.log(\`    ${
field.padEnd(8)}: ${
valid ? '✅' : '❌'} ${
valid ? data[field] : v.message()}\`);
    });
});

// ─── STRATEGY ─────────────────────────────────────────
console.log("\n=== Strategy Pattern ===");

class PricingEngine {
    #strategy;
    constructor(strategy) { this.#strategy = strategy; }
    setStrategy(s)        { this.#strategy = s; }

    calculate(price, quantity, customer) {
        return this.#strategy(price, quantity, customer);
    }
}

const strategies = {
    standard:    (p, q)    => p * q,
    bulk:        (p, q)    => p * q * (q >= 10 ? 0.85 : q >= 5 ? 0.92 : 1),
    membership:  (p, q, c) => p * q * (c.member ? 0.90 : 1),
    flash:       (p, q)    => p * q * 0.50,   // 50% off flash sale
};

const engine = new PricingEngine(strategies.standard);
const product = { name: "Widget", price: 19.99 };
const customer = { name: "Alice", member: true };

Object.entries(strategies).forEach(([name, strategy]) => {
    engine.setStrategy(strategy);
    const qty = 10;
    const total = engine.calculate(product.price, qty, customer);
    console.log(\`  ${
name.padEnd(12)} x${
qty}: \$${
total.toFixed(2)}\`);
});

// ─── COMMAND + UNDO/REDO ──────────────────────────────
console.log("\n=== Command Pattern (with Undo/Redo) ===");

class TextEditor {
    #text    = '';
    #history = [];
    #undone  = [];

    execute(command) {
        const prevText = this.#text;
        this.#text = command.execute(this.#text);
        this.#history.push({ command, prev: prevText });
        this.#undone = [];
    }

    undo() {
        if (!this.#history.length) return console.log("  Nothing to undo");
        const { command, prev } = this.#history.pop();
        this.#undone.push({ command, text: this.#text });
        this.#text = prev;
        console.log(\`  Undo: "${
this.#text}"\`);
    }

    redo() {
        if (!this.#undone.length) return console.log("  Nothing to redo");
        const { command, text } = this.#undone.pop();
        this.#history.push({ command, prev: this.#text });
        this.#text = text;
        console.log(\`  Redo: "${
this.#text}"\`);
    }

    get content() { return this.#text; }
}

const commands = {
    insert: (text) => ({ execute: (s) => s + text }),
    uppercase: () => ({ execute: (s) => s.toUpperCase() }),
    trim:      () => ({ execute: (s) => s.trim() }),
    replace:   (from, to) => ({ execute: (s) => s.replaceAll(from, to) }),
};

const editor = new TextEditor();
editor.execute(commands.insert("Hello, World!"));
console.log(\`  After insert: "${
editor.content}"\`);

editor.execute(commands.uppercase());
console.log(\`  After uppercase: "${
editor.content}"\`);

editor.execute(commands.replace("WORLD", "JavaScript"));
console.log(\`  After replace: "${
editor.content}"\`);

editor.undo();
editor.undo();
editor.redo();

// ─── BUILDER ──────────────────────────────────────────
console.log("\n=== Builder Pattern ===");

class QueryBuilder {
    #table; #select = ['*']; #conditions = [];
    #limit; #offset; #order = []; #joins = [];

    from(table)                { this.#table = table; return this; }
    select(...fields)          { this.#select = fields; return this; }
    where(cond)                { this.#conditions.push(cond); return this; }
    join(table, on)            { this.#joins.push(\`JOIN ${
table} ON ${
on}\`); return this; }
    limit(n)                   { this.#limit = n; return this; }
    offset(n)                  { this.#offset = n; return this; }
    orderBy(field, dir = 'ASC') { this.#order.push(\`${
field} ${
dir}\`); return this; }

    build() {
        let sql = \`SELECT ${
this.#select.join(', ')} FROM ${
this.#table}\`;
        if (this.#joins.length)      sql += ' ' + this.#joins.join(' ');
        if (this.#conditions.length) sql += \` WHERE ${
this.#conditions.join(' AND ')}\`;
        if (this.#order.length)      sql += \` ORDER BY ${
this.#order.join(', ')}\`;
        if (this.#limit !== undefined) sql += \` LIMIT ${
this.#limit}\`;
        if (this.#offset !== undefined) sql += \` OFFSET ${
this.#offset}\`;
        return sql;
    }
}

const query = new QueryBuilder()
    .from('users u')
    .select('u.id', 'u.name', 'u.email', 'COUNT(p.id) as post_count')
    .join('posts p', 'p.user_id = u.id')
    .where('u.active = true')
    .where('u.age >= 18')
    .orderBy('post_count', 'DESC')
    .orderBy('u.name')
    .limit(20)
    .offset(0)
    .build();

console.log("  Built query:");
console.log("  " + query);

📝 KEY POINTS:
✅ Observer/PubSub decouples event producers from consumers — great for UI state management
✅ Factory centralizes object creation — clients don't know which concrete class they get
✅ Strategy makes algorithms interchangeable at runtime — no if/else chains
✅ Command encapsulates actions as objects — enables undo/redo and queuing
✅ Builder constructs complex objects step by step — readable fluent API
✅ JavaScript closures naturally implement private state for module and singleton patterns
✅ Proxy enables cross-cutting concerns (logging, caching, validation) transparently
✅ Return the unsubscribe function from subscribe() — cleaner than a separate unsubscribe call
❌ Don't overuse patterns — many problems are simpler than they appear
❌ Singleton is often an anti-pattern — prefer dependency injection for testability
❌ Too many abstract layers (patterns on patterns) creates complexity without benefit
❌ JavaScript ES modules already provide the module pattern — IIFE is mostly obsolete
""",
  quiz: [
    Quiz(question: 'What does the Observer pattern solve?', options: [
      QuizOption(text: 'It decouples event producers from consumers — subscribers are notified without the publisher knowing who they are', correct: true),
      QuizOption(text: 'It ensures only one instance of an object exists in the application', correct: false),
      QuizOption(text: 'It allows swapping algorithms at runtime without changing the calling code', correct: false),
      QuizOption(text: 'It wraps an object to add behaviors without modifying the original class', correct: false),
    ]),
    Quiz(question: 'What is the key benefit of the Command pattern?', options: [
      QuizOption(text: 'Commands encapsulate actions as objects, enabling undo/redo, queuing, and logging of operations', correct: true),
      QuizOption(text: 'Commands run asynchronously on separate threads for better performance', correct: false),
      QuizOption(text: 'Commands validate input before passing it to the target function', correct: false),
      QuizOption(text: 'Commands allow multiple functions to be called as a single operation', correct: false),
    ]),
    Quiz(question: 'When should you use the Builder pattern?', options: [
      QuizOption(text: 'When constructing complex objects step by step with many optional configurations — making the construction readable', correct: true),
      QuizOption(text: 'When you need to build a class hierarchy with multiple inheritance levels', correct: false),
      QuizOption(text: 'When constructing objects must happen asynchronously with Promises', correct: false),
      QuizOption(text: 'When two objects need to be built simultaneously and combined', correct: false),
    ]),
  ],
);
