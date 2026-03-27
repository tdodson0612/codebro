import '../../models/lesson.dart';
import '../../models/quiz.dart';

final jsLesson07 = Lesson(
  language: 'JavaScript',
  title: 'Control Flow: if, switch, and Ternary',
  content: """
🎯 METAPHOR:
Control flow is the traffic system of your program.
if/else statements are traffic lights — green means
go one way, red means go another. switch is a roundabout
with multiple exits — you enter with a value and take
the exit that matches. The ternary operator is a Y-junction
on a bike path — a simple split for when the road briefly
diverges and immediately comes back together.
Without control flow, every program would be a straight
highway with no turns, no exits, and no ability to
adapt to changing conditions.

📖 EXPLANATION:

─────────────────────────────────────
IF / ELSE IF / ELSE:
─────────────────────────────────────
  if (condition) {
    // runs if condition is truthy
  } else if (otherCondition) {
    // runs if first is false, this is truthy
  } else {
    // runs if all conditions are false
  }

  Condition can be ANY expression that JavaScript
  evaluates as truthy or falsy.

─────────────────────────────────────
SWITCH:
─────────────────────────────────────
  switch (expression) {
    case value1:
      // runs when expression === value1 (strict!)
      break;           // ← ALWAYS include break
    case value2:
    case value3:       // fallthrough to group cases
      // runs when value2 OR value3
      break;
    default:
      // runs when no case matches
  }

  Uses === for comparison (strict — no coercion).
  Without break, execution FALLS THROUGH to next case.
  Fallthrough is occasionally intentional (grouped cases).

─────────────────────────────────────
TERNARY OPERATOR:
─────────────────────────────────────
  condition ? valueIfTrue : valueIfFalse

  Best for simple inline decisions.
  Avoid nesting — use if/else for complex logic.

─────────────────────────────────────
TRUTHY/FALSY REMINDER:
─────────────────────────────────────
  Falsy: false, 0, -0, 0n, "", null, undefined, NaN
  Everything else is truthy — including "0", [], {}

─────────────────────────────────────
GUARD CLAUSES (early returns):
─────────────────────────────────────
  // ❌ Deeply nested:
  function process(user) {
    if (user) {
      if (user.isActive) {
        if (user.age >= 18) {
          return "proceed";
        }
      }
    }
    return "rejected";
  }

  // ✅ Guard clauses (invert + return early):
  function process(user) {
    if (!user) return "rejected";
    if (!user.isActive) return "rejected";
    if (user.age < 18) return "rejected";
    return "proceed";
  }

─────────────────────────────────────
SHORT-CIRCUIT AS CONTROL FLOW:
─────────────────────────────────────
  // Execute only if condition is true:
  isLoggedIn && renderDashboard();

  // Default value pattern:
  const name = inputName || "Anonymous";

  // Null guard:
  const city = user?.address?.city ?? "Unknown";

─────────────────────────────────────
SWITCH vs IF/ELSE — WHEN TO USE EACH:
─────────────────────────────────────
  switch:   comparing one value to many known constants
  if/else:  ranges, compound conditions, type checks

─────────────────────────────────────
NULLISH COALESCING + OPTIONAL CHAINING
AS CONTROL FLOW:
─────────────────────────────────────
  // Classic:
  let result;
  if (value !== null && value !== undefined) {
    result = value;
  } else {
    result = "default";
  }

  // Modern:
  const result = value ?? "default";

💻 CODE:
// ─── IF / ELSE ────────────────────────────────────────
console.log("=== if / else ===");
const score = 75;

if (score >= 90) {
  console.log("Grade: A");
} else if (score >= 80) {
  console.log("Grade: B");
} else if (score >= 70) {
  console.log("Grade: C");
} else if (score >= 60) {
  console.log("Grade: D");
} else {
  console.log("Grade: F");
}
// Grade: C

// Truthy/falsy in conditions
const name = "";
if (name) {
  console.log("Name is:", name);
} else {
  console.log("No name provided"); // ← empty string is falsy
}

const items = [];
if (items.length) {
  console.log("Has items");
} else {
  console.log("Empty"); // ← length 0 is falsy
}

// ─── SWITCH ───────────────────────────────────────────
console.log("\n=== switch ===");
const day = "Wednesday";
switch (day) {
  case "Monday":
  case "Tuesday":
    console.log("Early week — long way to go!");
    break;
  case "Wednesday":
    console.log("Hump day — halfway there!");
    break;
  case "Thursday":
  case "Friday":
    console.log("Almost the weekend!");
    break;
  case "Saturday":
  case "Sunday":
    console.log("Weekend! 🎉");
    break;
  default:
    console.log("Not a valid day");
}

// switch with return (in a function):
const getLabel = (code) => {
  switch (code) {
    case 200: return "OK";
    case 201: return "Created";
    case 400: return "Bad Request";
    case 401: return "Unauthorized";
    case 404: return "Not Found";
    case 500: return "Server Error";
    default:  return \`Unknown (\${code})\`;
  }
};
console.log(getLabel(200));  // "OK"
console.log(getLabel(404));  // "Not Found"
console.log(getLabel(418));  // "Unknown (418)"

// ─── TERNARY ──────────────────────────────────────────
console.log("\n=== Ternary ===");
const age = 20;
const status = age >= 18 ? "adult" : "minor";
console.log(status); // "adult"

// Ternary in template literal
const hour = new Date().getHours();
const greeting = \`Good \${
hour < 12 ? "morning" : hour < 18 ? "afternoon" : "evening"}!\`;
console.log(greeting);

// Conditional rendering pattern (React-style):
const isLoggedIn = true;
const message = isLoggedIn ? "Welcome back!" : "Please log in.";
console.log(message);

// ─── GUARD CLAUSES ────────────────────────────────────
console.log("\n=== Guard Clauses ===");
function processOrder(order) {
  if (!order)             return { error: "No order provided" };
  if (!order.userId)      return { error: "Missing user" };
  if (!order.items?.length) return { error: "Empty cart" };
  if (order.total <= 0)   return { error: "Invalid total" };

  // Happy path — no deep nesting!
  return { success: true, orderId: Math.random().toString(36).slice(2) };
}

console.log(processOrder(null));
console.log(processOrder({ userId: 1, items: [], total: 0 }));
console.log(processOrder({ userId: 1, items: ["a"], total: 99.99 }));

// ─── SHORT-CIRCUIT AS CONTROL FLOW ───────────────────
console.log("\n=== Short-circuit control flow ===");
const user = { name: "Alice", isAdmin: true };
const nullUser = null;

// Execute only if truthy:
user.isAdmin && console.log("Admin panel visible");
nullUser?.isAdmin && console.log("This won't run");

// Default values:
const displayName = nullUser?.name ?? "Guest";
console.log("Display:", displayName); // "Guest"

// ─── ADVANCED PATTERNS ────────────────────────────────
console.log("\n=== Pattern: Object lookup instead of switch ===");
// Instead of a long switch with static values,
// use an object lookup:
const statusMessages = {
  200: "OK",
  201: "Created",
  400: "Bad Request",
  401: "Unauthorized",
  404: "Not Found",
  500: "Server Error",
};

const getStatus = (code) =>
  statusMessages[code] ?? \`Unknown (\${code})\`;

console.log(getStatus(200)); // "OK"
console.log(getStatus(404)); // "Not Found"
console.log(getStatus(418)); // "Unknown (418)"

// Array of conditions (for complex multi-condition dispatch):
const temperature = 28;
const conditions = [
  [temp => temp < 0,   "Freezing 🥶"],
  [temp => temp < 10,  "Cold 🧥"],
  [temp => temp < 20,  "Cool 🌤"],
  [temp => temp < 30,  "Warm ☀️"],
  [() => true,         "Hot 🔥"],
];

const weatherDesc = conditions.find(([test]) =>
  test(temperature))?.[1] ?? "Unknown";
console.log(\`\${temperature}°C: \${weatherDesc}\`);  // 28°C: Warm ☀️

📝 KEY POINTS:
✅ if/else evaluates truthiness — not just strict boolean true/false
✅ switch uses === (strict) — no type coercion between cases
✅ Always include break in switch cases unless intentional fallthrough
✅ Guard clauses (early returns) reduce nesting and improve readability
✅ Ternary is great for simple inline decisions; avoid nesting more than 2 levels
✅ Short-circuit (&&, ||, ??) can replace simple if statements elegantly
✅ Object lookup tables can replace long switch statements for static mappings
✅ Optional chaining ?. + nullish coalescing ?? handle null-safe conditions concisely
❌ Don't forget break in switch — fallthrough bugs are hard to spot
❌ Don't use deeply nested ternaries — extract to a function or if/else
❌ Avoid relying on type coercion in if conditions — be explicit when needed
""",
  quiz: [
    Quiz(
      question: 'What happens in a switch statement if you forget to include a break?',
      options: [
        QuizOption(text: 'Execution falls through to the next case and runs it regardless of its value', correct: true),
        QuizOption(text: 'A SyntaxError is thrown because break is required', correct: false),
        QuizOption(text: 'The switch exits automatically after the first matching case', correct: false),
        QuizOption(text: 'The default case runs next regardless of whether it matches', correct: false),
      ],
    ),
    Quiz(
      question: 'What is a "guard clause" in a function?',
      options: [
        QuizOption(text: 'An early return at the top of a function that handles edge cases, reducing the need for deep nesting', correct: true),
        QuizOption(text: 'A try/catch block that protects against runtime errors', correct: false),
        QuizOption(text: 'A default parameter value that guards against undefined inputs', correct: false),
        QuizOption(text: 'An assertion that throws if the condition is false', correct: false),
      ],
    ),
    Quiz(
      question: 'What does isLoggedIn && renderDashboard() do?',
      options: [
        QuizOption(text: 'Calls renderDashboard() only if isLoggedIn is truthy — short-circuit evaluation prevents the call when false', correct: true),
        QuizOption(text: 'Returns true if both isLoggedIn is true and renderDashboard() succeeds', correct: false),
        QuizOption(text: 'Creates a logical AND condition that must be explicitly evaluated with if()', correct: false),
        QuizOption(text: 'Assigns the result of renderDashboard() to isLoggedIn', correct: false),
      ],
    ),
  ],
);
