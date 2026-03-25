import '../../models/lesson.dart';
import '../../models/quiz.dart';

final jsLesson50 = Lesson(
  language: 'JavaScript',
  title: 'JavaScript → Frameworks: React, Vue, and Next.js',
  content: """
🎯 METAPHOR:
Learning vanilla JavaScript and then picking a framework
is like learning carpentry and then choosing your power
tools. A carpenter who only knows hammers and hand saws
can build anything — but once you learn the table saw
(React), miter saw (Vue), and router (Next.js), you
build the same things 10x faster. The underlying
skills — measuring, joining, sanding — are unchanged.
The tools amplify them. The carpenter who skips learning
the basics and jumps to power tools is dangerous.
YOU have the fundamentals. Now let's pick your power tools.

📖 EXPLANATION:
JavaScript frameworks build on everything you've learned:
closures, async/await, modules, the event loop, the DOM.
This lesson bridges you from vanilla JS to the three
most important frameworks.

─────────────────────────────────────
WHAT TRANSFERS DIRECTLY:
─────────────────────────────────────
  ✅ All JavaScript syntax (ES6-ES2024)
  ✅ async/await — fetch in React/Vue works the same
  ✅ Array methods — map/filter/reduce everywhere
  ✅ Destructuring — used extensively in all frameworks
  ✅ Modules (import/export) — essential
  ✅ Classes — used in Vue 3 Composition, NestJS
  ✅ Closures — component state depends on them
  ✅ Promises — data fetching everywhere
  ✅ Event handling — synthetic events, listeners
  ✅ The DOM — virtual DOM abstracts it, but understanding helps
  ✅ TypeScript — all major frameworks support it natively

─────────────────────────────────────
REACT — Component-Based UI:
─────────────────────────────────────
  Made by Facebook/Meta. Largest ecosystem. 2013-present.

  Key concepts:
  → Components: functions that return JSX (JS + HTML-like)
  → Props: data passed to components (like function args)
  → State: component's reactive data (useState hook)
  → Effects: side effects (data fetching, subscriptions)
  → Hooks: built-in useState, useEffect, useContext, etc.

  // React component — it's just JavaScript!
  function Counter({ initialCount = 0 }) {  // props
      const [count, setCount] = useState(initialCount);  // state

      useEffect(() => {
          document.title = \`Count: ${
count}\`;   // side effect
          return () => { document.title = 'App'; }; // cleanup
      }, [count]);  // run when count changes

      return (
          <div>
              <p>Count: {count}</p>
              <button onClick={() => setCount(c => c + 1)}>+</button>
          </div>
      );
  }

  YOUR PATH TO REACT:
  npx create-react-app my-app
  // or Vite:
  npm create vite@latest my-app -- --template react-ts

  Resources:
  → react.dev (official docs, excellent)
  → React - The Complete Guide (Udemy - Maximilian)
  → Epic React by Kent C. Dodds

─────────────────────────────────────
VUE 3 — Progressive Framework:
─────────────────────────────────────
  Made by Evan You. Easier learning curve than React.
  Vue 3 with Composition API is most similar to React.

  // Vue 3 Single File Component (SFC):
  <script setup lang="ts">
  import { ref, computed, onMounted } from 'vue';

  const count = ref(0);         // reactive reference
  const double = computed(() => count.value * 2);

  onMounted(() => {
      console.log('Component mounted');
  });
  </script>

  <template>
      <div>
          <p>Count: {{ count }} | Double: {{ double }}</p>
          <button @click="count++">+</button>
      </div>
  </template>

  YOUR PATH TO VUE:
  npm create vite@latest my-app -- --template vue-ts

  Resources:
  → vuejs.org (official docs)
  → Vue Mastery, Vue School

─────────────────────────────────────
NEXT.JS — React for Production:
─────────────────────────────────────
  Made by Vercel. React framework with server-side rendering,
  file-based routing, API routes, and more.

  // app/page.tsx (Next.js 13+ App Router):
  async function UsersPage() {
      // Server Component — runs on the server!
      const users = await fetch('https://api.example.com/users')
          .then(r => r.json());

      return (
          <main>
              <h1>Users</h1>
              <ul>
                  {users.map(u => <li key={u.id}>{u.name}</li>)}
              </ul>
          </main>
      );
  }

  Features:
  → Server & Client Components
  → File-based routing (/app/users/page.tsx)
  → API routes (/app/api/users/route.ts)
  → Image optimization, font optimization
  → Server Actions for form handling

  YOUR PATH TO NEXT.JS:
  npx create-next-app@latest my-app --typescript

  Resources:
  → nextjs.org (official docs)
  → Josh tried coding (YouTube)
  → Theo Browne - t3.gg

─────────────────────────────────────
OTHER FRAMEWORKS WORTH KNOWING:
─────────────────────────────────────
  Svelte/SvelteKit   → compile-time reactivity, no virtual DOM
  Astro              → content-focused, multi-framework support
  Solid.js           → React-like but with fine-grained reactivity
  Angular            → opinionated enterprise framework (TypeScript-first)
  Remix              → full-stack React with web standards focus
  Nuxt.js            → Vue's equivalent of Next.js

─────────────────────────────────────
THE FRAMEWORK DECISION:
─────────────────────────────────────
  Choose React if:
  → Maximum job market opportunities
  → Large ecosystem (thousands of libraries)
  → Building SPAs, mobile apps (React Native)
  → Teams with existing React knowledge

  Choose Vue if:
  → Gentler learning curve
  → Building on existing HTML codebase
  → Smaller teams, faster onboarding
  → Asian market (huge Vue adoption there)

  Choose Next.js if:
  → Need SEO (server-side rendering)
  → Full-stack in one framework
  → Building production React apps
  → Deploying to Vercel

─────────────────────────────────────
YOUR LEARNING PATH:
─────────────────────────────────────
  WEEK 1-2: React basics
  → Components, props, JSX
  → useState, useEffect hooks
  → Event handling, conditional rendering

  WEEK 3-4: React intermediate
  → Custom hooks
  → Context API
  → React Router
  → Fetching data with fetch/axios

  WEEK 5-6: React + Next.js
  → File-based routing
  → Server vs Client components
  → API routes
  → Deployment to Vercel

  WEEK 7-8: Production skills
  → State management (Zustand, Redux Toolkit)
  → Form handling (React Hook Form + Zod)
  → Testing (React Testing Library)
  → Performance (React.memo, useMemo, lazy)

💻 CODE:
// ─── FRAMEWORK CONCEPTS IN VANILLA JS ────────────────
// Showing how frameworks build on JavaScript concepts

console.log("=== How Frameworks Build on JavaScript ===\n");

// ─── MINI REACT-LIKE (to understand the concept) ──────
console.log("1. Component Model (React concept)");

// React component = function that returns a description:
function Button({ label, onClick, disabled = false }) {
    return { type: 'button', props: { label, onClick, disabled } };
}

function Counter2({ initialCount = 0 }) {
    // state = useState(initialCount) in React
    let count = initialCount;

    return {
        type: 'div',
        children: [
            { type: 'p', text: \`Count: ${
count}\` },
            Button({ label: '+', onClick: () => count++ }),
            Button({ label: '-', onClick: () => count-- }),
        ]
    };
}

const counterOutput = Counter2({ initialCount: 5 });
console.log("  Component tree:", JSON.stringify(counterOutput, null, 2).slice(0, 150) + "...");

// ─── REACTIVITY CONCEPT ───────────────────────────────
console.log("\n2. Reactivity (Vue 3 / Solid concept)");

function createRef(initialValue) {
    let _value = initialValue;
    const subscribers = new Set();

    return {
        get value()  { return _value; },
        set value(v) {
            _value = v;
            subscribers.forEach(sub => sub(_value));
        },
        subscribe: (fn) => { subscribers.add(fn); return () => subscribers.delete(fn); }
    };
}

function createComputed(fn, deps) {
    const result = createRef(fn());
    deps.forEach(dep => {
        dep.subscribe(() => {
            result.value = fn();
        });
    });
    return result;
}

const count  = createRef(0);
const double = createComputed(() => count.value * 2, [count]);
const label  = createComputed(() => \`Count: ${
count.value}, Double: ${
double.value}\`, [count, double]);

// Subscribe to changes (like useEffect in React):
label.subscribe(text => console.log(\`  UI updated: "${
text}"\`));

count.value = 1;  // triggers UI updates
count.value = 5;  // triggers again

// ─── HOOKS CONCEPT ────────────────────────────────────
console.log("\n3. Hooks Pattern (useState concept)");

// React's useState in pure JS:
function createHookState() {
    const states  = [];
    let callIndex = 0;

    function useState(initial) {
        const index = callIndex++;
        if (states[index] === undefined) states[index] = initial;

        const setState = (newValue) => {
            states[index] = typeof newValue === 'function'
                ? newValue(states[index])
                : newValue;
            console.log(\`  [setState] states[${
index}] = ${
states[index]}\`);
        };

        return [states[index], setState];
    }

    return { useState, reset: () => { callIndex = 0; } };
}

const { useState, reset } = createHookState();

// Simulate a component render:
function renderComponent() {
    reset();  // reset hook index for this render
    const [name, setName] = useState('Alice');
    const [age,  setAge]  = useState(28);
    return { name, age, setName, setAge };
}

const state = renderComponent();
console.log(\`  Initial: name=${
state.name}, age=${
state.age}\`);
state.setName('Bob');
state.setAge(n => n + 1);
const state2 = renderComponent();
console.log(\`  After update: name=${
state2.name}, age=${
state2.age}\`);

// ─── FRAMEWORK COMPARISON ─────────────────────────────
console.log("\n=== Framework Comparison ===");

const comparison = [
    ["Feature",       "React",         "Vue 3",         "Next.js"],
    ["─────────",     "────────",      "────────",      "────────"],
    ["Type",          "UI library",    "Framework",     "Full-stack"],
    ["Learning",      "Moderate",      "Easiest",       "Moderate"],
    ["Jobs",          "Most",          "Many",          "Many"],
    ["Rendering",     "CSR default",   "CSR default",   "SSR/SSG/CSR"],
    ["Routing",       "React Router",  "Vue Router",    "File-based"],
    ["State",         "useState/Zustand","Pinia/Vuex",  "useState/Zustand"],
    ["TypeScript",    "Excellent",     "Excellent",     "Excellent"],
    ["Ecosystem",     "Massive",       "Large",         "React's"],
    ["Best for",      "SPAs, RN",      "Simple apps",   "Production"],
];

comparison.forEach(row => {
    console.log(\`  ${
row[0].padEnd(16)}${
row[1].padEnd(16)}${
row[2].padEnd(16)}${
row[3]}\`);
});

// ─── YOUR NEXT STEPS ──────────────────────────────────
console.log("\n=== Your JavaScript → Framework Journey ===\n");
console.log("  You now know the FULL JavaScript language.");
console.log("  Your next step: pick ONE framework and build something real.\n");

const nextSteps = [
    ["1.", "Choose React (best career prospects) or Vue (easier start)"],
    ["2.", "Follow the official docs — they're excellent"],
    ["3.", "Build something you actually care about (not another Todo app)"],
    ["4.", "Add TypeScript — you already learned the concepts here"],
    ["5.", "Learn Next.js when ready for full-stack / production"],
    ["",   ""],
    ["",   "Recommended first projects:"],
    ["→",  "Weather app (fetch API, state, rendering)"],
    ["→",  "Shopping cart (state management, routing)"],
    ["→",  "Blog with CMS (Next.js, Markdown, data fetching)"],
    ["→",  "Clone of a site you love (Twitter, Reddit, etc.)"],
    ["",   ""],
    ["",   "Resources:"],
    ["→",  "react.dev — official React docs (best)"],
    ["→",  "vuejs.org — official Vue docs"],
    ["→",  "nextjs.org — official Next.js docs"],
    ["→",  "Josh tried coding (YouTube) — Next.js tutorials"],
    ["→",  "Theo Browne / t3.gg (YouTube) — modern React stack"],
    ["→",  "Maximilian Schwarzmüller (Udemy) — complete courses"],
];

nextSteps.forEach(([prefix, text]) => {
    if (text) console.log(\`  ${
prefix.padEnd(4)}${
text}\`);
    else console.log();
});

📝 KEY POINTS:
✅ Frameworks build ON JavaScript — your fundamentals apply directly
✅ React = most jobs, largest ecosystem, components + hooks pattern
✅ Vue = easiest learning curve, excellent docs, progressive adoption
✅ Next.js = production React with server-side rendering and full-stack features
✅ All major frameworks now use TypeScript — your TS knowledge transfers
✅ async/await and fetch work identically inside React, Vue, and Next.js
✅ Closures, modules, destructuring, and array methods are used everywhere
✅ Build something real — tutorials only take you so far
✅ Start with one framework and go deep — breadth comes naturally after mastery
❌ Don't try to learn all frameworks at once — pick one and build with it
❌ Don't skip vanilla JS to jump to frameworks — you'll struggle with the fundamentals
❌ Don't learn frameworks from 2019 tutorials — they change quickly, use official docs
❌ Framework knowledge doesn't expire — understanding components/state is universal
""",
  quiz: [
    Quiz(question: 'What JavaScript concept is React\'s useState hook directly based on?', options: [
      QuizOption(text: 'Closures — useState captures component state in a closure that persists between renders', correct: true),
      QuizOption(text: 'Prototypes — useState stores state in the component\'s prototype chain', correct: false),
      QuizOption(text: 'Generators — useState uses generators to pause and resume component rendering', correct: false),
      QuizOption(text: 'Symbols — useState uses Symbols as keys to prevent state naming collisions', correct: false),
    ]),
    Quiz(question: 'What is the primary advantage of Next.js over plain React?', options: [
      QuizOption(text: 'Next.js adds server-side rendering, file-based routing, and API routes — enabling full-stack development and better SEO', correct: true),
      QuizOption(text: 'Next.js is faster because it doesn\'t use a virtual DOM like React', correct: false),
      QuizOption(text: 'Next.js replaces React\'s component model with a simpler template syntax', correct: false),
      QuizOption(text: 'Next.js allows you to use JavaScript and Python in the same project', correct: false),
    ]),
    Quiz(question: 'Which JavaScript features are most important to understand before learning React?', options: [
      QuizOption(text: 'ES6+ modules, destructuring, array methods, async/await, and closures — used constantly in React components', correct: true),
      QuizOption(text: 'Regular expressions and typed arrays — React uses them internally for performance', correct: false),
      QuizOption(text: 'WebSockets and Service Workers — React applications are primarily real-time', correct: false),
      QuizOption(text: 'The Proxy and Reflect APIs — React\'s virtual DOM is implemented with Proxies', correct: false),
    ]),
  ],
);
