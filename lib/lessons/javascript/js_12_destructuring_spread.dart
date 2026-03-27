import '../../models/lesson.dart';
import '../../models/quiz.dart';

final jsLesson12 = Lesson(
  language: 'JavaScript',
  title: 'Destructuring, Spread, and Rest',
  content: """
🎯 METAPHOR:
Destructuring is like unpacking a suitcase and labeling
each item as you take it out: "this is my laptop, this is
my charger, these are the rest of my clothes." The spread
operator is a magic photocopier that instantly copies and
spreads the contents of one container into another.
Rest is the "catch-all" drawer at the end — it collects
everything that wasn't specifically claimed. Together,
these three features eliminate boilerplate code that
used to take three lines to write and now takes half a line.

📖 EXPLANATION:

─────────────────────────────────────
ARRAY DESTRUCTURING:
─────────────────────────────────────
  const [a, b, c] = [1, 2, 3];
  const [first, ...rest] = [1, 2, 3, 4, 5];
  const [,, third] = [10, 20, 30];    // skip with commas
  const [x = 0, y = 0] = [5];         // default values
  const [head, ...tail] = "hello";     // from string

  // Swap variables:
  let p = 1, q = 2;
  [p, q] = [q, p];

─────────────────────────────────────
OBJECT DESTRUCTURING:
─────────────────────────────────────
  const { name, age } = person;

  // Rename while destructuring:
  const { name: fullName, age: years } = person;

  // Default values:
  const { name = "Guest", role = "user" } = user;

  // Nested destructuring:
  const { address: { city, zip } } = person;

  // Combined rename + default:
  const { name: n = "Unknown" } = obj;

─────────────────────────────────────
IN FUNCTION PARAMETERS:
─────────────────────────────────────
  // Array params:
  function sum([a, b, c]) { return a + b + c; }
  sum([1, 2, 3]);

  // Object params:
  function greet({ name, age = 0 }) {
    return \`\${
name} is\${
age}\`;
  }
  greet({ name: "Alice", age: 28 });

  // With rest:
  function first([head, ...tail]) { return head; }

─────────────────────────────────────
SPREAD OPERATOR (...):
─────────────────────────────────────
  ARRAYS:
  [...arr]              → copy
  [...arr1, ...arr2]    → combine
  fn(...arr)            → spread as function arguments
  [...new Set(arr)]     → deduplicate

  OBJECTS:
  {...obj}              → shallow copy
  {...obj1, ...obj2}    → merge (right wins)
  {...obj, key: newVal} → update a field

  STRINGS:
  [...str]              → array of characters

─────────────────────────────────────
REST PARAMETERS (...rest):
─────────────────────────────────────
  In FUNCTION parameters — collects remaining args:
  function log(level, ...messages) {
    console.log(\`[\${
level}]\`, ...messages);
  }

  In DESTRUCTURING — collects remaining items:
  const [head, ...tail] = [1, 2, 3, 4];
  const { a, b, ...others } = { a:1, b:2, c:3, d:4 };
  // head=1, tail=[2,3,4]
  // a=1, b=2, others={c:3, d:4}

─────────────────────────────────────
NESTED DESTRUCTURING:
─────────────────────────────────────
  const { name, address: { city, coords: { lat, lng } } } = user;

  // Be careful — if address is undefined:
  const { address: { city } = {} } = user; // safe default

─────────────────────────────────────
DESTRUCTURING IN LOOPS:
─────────────────────────────────────
  for (const [key, value] of Object.entries(obj)) { }
  for (const { name, age } of people) { }

─────────────────────────────────────
COMPUTED PROPERTY IN DESTRUCTURING:
─────────────────────────────────────
  const key = "name";
  const { [key]: value } = { name: "Alice" };
  // value = "Alice"

💻 CODE:
// ─── ARRAY DESTRUCTURING ──────────────────────────────
console.log("=== Array Destructuring ===");
const [a, b, c] = [1, 2, 3];
console.log(a, b, c);  // 1 2 3

// Skip elements
const [,, third] = [10, 20, 30, 40];
console.log(third);  // 30

// Rest
const [head, ...tail] = [1, 2, 3, 4, 5];
console.log(head, tail);  // 1 [2,3,4,5]

// Default values
const [x = 0, y = 0, z = 0] = [5, 10];
console.log(x, y, z);  // 5 10 0

// Swap variables
let p = "hello", q = "world";
[p, q] = [q, p];
console.log(p, q);  // world hello

// From function return
const getCoords = () => [40.7128, -74.0060];
const [lat, lng] = getCoords();
console.log(\`Lat:\${
lat}, Lng:\${
lng}\`);

// ─── OBJECT DESTRUCTURING ─────────────────────────────
console.log("\n=== Object Destructuring ===");
const person = {
  name: "Alice",
  age: 28,
  address: { city: "London", zip: "EC1A 1BB" },
  scores: [95, 87, 92]
};

const { name, age } = person;
console.log(name, age);  // Alice 28

// Rename
const { name: fullName, age: years } = person;
console.log(fullName, years);  // Alice 28

// Default values
const { email = "none@example.com", role = "user" } = person;
console.log(email, role);  // none@example.com user

// Nested
const { address: { city, zip } } = person;
console.log(city, zip);  // London EC1A 1BB

// Rest in object
const { name: n, ...rest } = person;
console.log(n);    // Alice
console.log(Object.keys(rest));  // ['age','address','scores']

// ─── IN FUNCTION PARAMS ───────────────────────────────
console.log("\n=== Destructuring in Parameters ===");
function createProfile({ name, age = 0, role = "user", ...extra }) {
  return { name, age, role, ...extra };
}
console.log(createProfile({ name: "Bob", age: 34, premium: true }));

function sumArray([first2, second, ...others]) {
  const rest2Sum = others.reduce((a, b) => a + b, 0);
  return first2 + second + rest2Sum;
}
console.log(sumArray([1, 2, 3, 4, 5]));  // 15

// ─── SPREAD OPERATOR ──────────────────────────────────
console.log("\n=== Spread Operator ===");

// Array spread
const arr1 = [1, 2, 3];
const arr2 = [4, 5, 6];
const combined = [...arr1, ...arr2];
console.log(combined);  // [1,2,3,4,5,6]

const copy = [...arr1];
copy.push(99);
console.log(arr1);   // [1,2,3] — unchanged
console.log(copy);   // [1,2,3,99]

// Spread into function
const nums = [1, 5, 3, 9, 2];
console.log(Math.max(...nums));  // 9
console.log(Math.min(...nums));  // 1

// Object spread
const obj1 = { a: 1, b: 2 };
const obj2 = { b: 99, c: 3 };
const merged = { ...obj1, ...obj2 };
console.log(merged);  // {a:1, b:99, c:3} — obj2 wins for 'b'

// Update pattern (immutable update)
const user = { name: "Alice", age: 28, city: "London" };
const birthday = { ...user, age: user.age + 1 };
console.log(user.age);     // 28 — original unchanged
console.log(birthday.age); // 29

// ─── REST IN DESTRUCTURING ────────────────────────────
console.log("\n=== Rest in Destructuring ===");

// Array rest
const [first3, second3, ...remaining] = [1, 2, 3, 4, 5, 6];
console.log(first3, second3, remaining);  // 1 2 [3,4,5,6]

// Object rest (pick and collect)
const { name: personName, age: personAge, ...details } = {
  name: "Carol", age: 32, city: "Berlin", hobby: "coding"
};
console.log(personName, personAge);  // Carol 32
console.log(details);                // {city:'Berlin', hobby:'coding'}

// ─── DESTRUCTURING IN LOOPS ───────────────────────────
console.log("\n=== Destructuring in Loops ===");
const team = [
  { name: "Alice", score: 95 },
  { name: "Bob",   score: 82 },
  { name: "Carol", score: 91 },
];

for (const { name: memberName, score } of team) {
  console.log(\`\${
memberName}:\${
score}\`);
}

// entries() with destructuring
const fruits = ["apple", "banana", "cherry"];
for (const [idx, fruit] of fruits.entries()) {
  console.log(\`\${
idx + 1}.\${
fruit}\`);
}

// ─── ADVANCED PATTERNS ────────────────────────────────
console.log("\n=== Advanced Patterns ===");

// Function that returns multiple values
function minMax(arr) {
  return [Math.min(...arr), Math.max(...arr)];
}
const [min, max] = minMax([3, 1, 4, 1, 5, 9, 2, 6]);
console.log(\`Min:\${
min}, Max:\${
max}\`);  // Min: 1, Max: 9

// Nested with defaults
const response = {
  status: 200,
  data: { users: [{ id: 1, name: "Alice" }] }
};
const { status, data: { users: [firstUser] = [] } = {} } = response;
console.log(status, firstUser);  // 200 {id:1, name:'Alice'}

// Computed property in destructuring
const field = "name";
const { [field]: dynamicValue } = { name: "Dynamic!" };
console.log(dynamicValue);  // "Dynamic!"

📝 KEY POINTS:
✅ Array destructuring extracts values by POSITION; object destructuring by KEY
✅ Use comma skipping to skip elements: const [,, third] = arr
✅ Default values in destructuring: const { x = 0 } = obj — used only if undefined
✅ Rename while destructuring: const { name: alias } = obj
✅ Rest in destructuring collects remaining elements: const [head, ...tail] = arr
✅ Spread creates SHALLOW copies — nested objects are still shared references
✅ Object spread: right side wins for duplicate keys: { ...a, ...b } — b overrides
✅ Destructuring in function params is the idiomatic way to pass named options
❌ Rest must always be LAST: const [a, ...rest, b] is a SyntaxError
❌ Spread is SHALLOW — {...obj} does not deep-clone nested objects
❌ Destructuring undefined throws TypeError — provide defaults or check first
""",
  quiz: [
    Quiz(
      question: 'What does const { name: alias = "Guest" } = obj do?',
      options: [
        QuizOption(text: 'Extracts the "name" property from obj, renames it to "alias", and defaults to "Guest" if name is undefined', correct: true),
        QuizOption(text: 'Creates a property called "name: alias" with the default value "Guest"', correct: false),
        QuizOption(text: 'Aliases the entire obj to both "name" and the value "Guest"', correct: false),
        QuizOption(text: 'Checks if obj.name equals "alias" and returns "Guest" if false', correct: false),
      ],
    ),
    Quiz(
      question: 'What is the difference between rest parameters and the spread operator?',
      options: [
        QuizOption(text: 'Rest collects multiple values INTO an array; spread expands an array/iterable INTO individual values', correct: true),
        QuizOption(text: 'They are the same — ... always spreads values out', correct: false),
        QuizOption(text: 'Spread is for arrays; rest is for objects', correct: false),
        QuizOption(text: 'Rest works in function parameters only; spread works everywhere', correct: false),
      ],
    ),
    Quiz(
      question: 'When merging two objects with spread ({ ...a, ...b }), what happens to duplicate keys?',
      options: [
        QuizOption(text: 'The value from b overwrites the value from a — the rightmost source wins', correct: true),
        QuizOption(text: 'An error is thrown because duplicate keys are not allowed', correct: false),
        QuizOption(text: 'Both values are kept in an array under the duplicate key', correct: false),
        QuizOption(text: 'The value from a is preserved — first source wins', correct: false),
      ],
    ),
  ],
);
