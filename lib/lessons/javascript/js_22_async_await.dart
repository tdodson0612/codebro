import '../../models/lesson.dart';
import '../../models/quiz.dart';

final jsLesson22 = Lesson(
  language: 'JavaScript',
  title: 'async / await',
  content: """
🎯 METAPHOR:
async/await is like writing a recipe that has waiting
steps but reads as if time doesn't exist. Instead of
"start cooking rice, and WHEN it's done, start cooking
the sauce, and WHEN THAT'S done, plate it" — all of
which requires nested callbacks or promise chains —
you write it as: "cook rice. cook sauce. plate it."
The await keyword is a temporal pause marker. The code
below await literally doesn't run until the awaited
thing completes. But crucially, while waiting, the
kitchen (JavaScript engine) works on other orders.
It looks synchronous, behaves asynchronously, and
doesn't block anyone else's work.

📖 EXPLANATION:
async/await (ES2017) is syntactic sugar over Promises.
It makes asynchronous code look and behave like
synchronous code, dramatically improving readability.

─────────────────────────────────────
THE BASICS:
─────────────────────────────────────
  // An async function ALWAYS returns a Promise:
  async function greet() {
      return "Hello";  // same as: return Promise.resolve("Hello")
  }
  greet() instanceof Promise  // true
  await greet()               // "Hello"

  // await pauses until the Promise settles:
  async function fetchUser(id) {
      const response = await fetch(\`/api/users/\\\${id}\`);
      const user     = await response.json();
      return user;   // this becomes the resolved value
  }

─────────────────────────────────────
ERROR HANDLING:
─────────────────────────────────────
  async function loadData() {
      try {
          const data = await fetchSomething();
          return data;
      } catch (error) {
          console.error("Failed:", error.message);
          return null;
      }
  }

  // Or catch at the call site:
  const data = await loadData().catch(err => null);

  // Using .catch() on await:
  const result = await Promise.reject("oops").catch(e => "fallback");

─────────────────────────────────────
PARALLEL vs SEQUENTIAL:
─────────────────────────────────────
  // ❌ SEQUENTIAL — each waits for the previous:
  const user  = await fetchUser(1);    // 100ms
  const posts = await fetchPosts(1);   // 100ms
  // Total: 200ms

  // ✅ PARALLEL — both start at the same time:
  const [user, posts] = await Promise.all([
      fetchUser(1),
      fetchPosts(1)
  ]);
  // Total: 100ms (overlap!)

  // ✅ Start both, then await:
  const userPromise  = fetchUser(1);
  const postsPromise = fetchPosts(1);
  const user  = await userPromise;
  const posts = await postsPromise;

─────────────────────────────────────
async IN DIFFERENT CONTEXTS:
─────────────────────────────────────
  // Async function declaration:
  async function load() { ... }

  // Async arrow function:
  const load = async () => { ... };

  // Async method in class:
  class API {
      async getUser(id) { ... }
  }

  // Async IIFE (top-level await alternative):
  (async () => {
      const data = await fetchData();
      console.log(data);
  })();

  // Top-level await (ES modules only):
  const config = await fetch('/config').then(r => r.json());

─────────────────────────────────────
for await...of — ASYNC ITERATION:
─────────────────────────────────────
  async function processItems(items) {
      for await (const item of asyncSource()) {
          await process(item);
      }
  }

  // Useful for: async generators, ReadableStream,
  // paginated APIs, database cursors

─────────────────────────────────────
COMMON PATTERNS:
─────────────────────────────────────
  // Retry with exponential backoff:
  async function withRetry(fn, retries = 3) {
      for (let i = 0; i < retries; i++) {
          try { return await fn(); }
          catch (e) {
              if (i === retries - 1) throw e;
              await delay(2 ** i * 100);  // 100ms, 200ms, 400ms
          }
      }
  }

  // Memoization for async functions:
  function memoAsync(fn) {
      const cache = new Map();
      return async (...args) => {
          const key = JSON.stringify(args);
          if (cache.has(key)) return cache.get(key);
          const result = await fn(...args);
          cache.set(key, result);
          return result;
      };
  }

  // Debounce async:
  function debounceAsync(fn, ms) {
      let timer;
      return (...args) => new Promise(resolve => {
          clearTimeout(timer);
          timer = setTimeout(async () => resolve(await fn(...args)), ms);
      });
  }

─────────────────────────────────────
DIFFERENCES FROM PROMISES:
─────────────────────────────────────
  // Promise chain:
  function loadUser(id) {
      return fetch(\`/users/\\\${id}\`)
          .then(r => r.json())
          .then(user => {
              if (!user.active) throw new Error("Inactive");
              return user;
          })
          .catch(err => console.error(err));
  }

  // async/await equivalent (more readable):
  async function loadUser(id) {
      try {
          const r    = await fetch(\`/users/\\\${id}\`);
          const user = await r.json();
          if (!user.active) throw new Error("Inactive");
          return user;
      } catch (err) {
          console.error(err);
      }
  }

💻 CODE:
// Helper functions for demos
function delay(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

function fetchUser(id) {
    return new Promise((resolve, reject) => {
        setTimeout(() => {
            if (id > 0) resolve({ id, name: \`user\${
id}\`, posts: id * 3 });
            else reject(new Error(\`Invalid user id:\${
id}\`));
        }, 50);
    });
}

function fetchPosts(userId) {
    return new Promise(resolve => {
        setTimeout(() => resolve(
            Array.from({ length: 3 }, (_, i) => ({
                id: userId * 10 + i,
                title: \`Post\${
userId}-\${
i}\`
            }))
        ), 50);
    });
}

// ─── BASIC async/await ────────────────────────────────
async function basics() {
    console.log("=== Basic async/await ===");

    // async function returns a Promise:
    const result = await (async () => "Hello, async!")();
    console.log("  Async return:", result);

    // Awaiting a delay:
    console.log("  Waiting...");
    await delay(30);
    console.log("  Done waiting");

    // Error handling:
    try {
        const user = await fetchUser(-1);
    } catch (e) {
        console.log("  Caught:", e.message);
    }
}

// ─── SEQUENTIAL vs PARALLEL ───────────────────────────
async function parallelDemo() {
    console.log("\\n=== Sequential vs Parallel ===");

    // Sequential (slower):
    let start = Date.now();
    const u1 = await fetchUser(1);
    const p1 = await fetchPosts(1);
    console.log(\`  Sequential:\${
Date.now()-start}ms →\${
u1.name},\${
p1.length} posts\`);

    // Parallel (faster):
    start = Date.now();
    const [u2, p2] = await Promise.all([fetchUser(2), fetchPosts(2)]);
    console.log(\`  Parallel:  \${
Date.now()-start}ms →\${
u2.name},\${
p2.length} posts\`);

    // Parallel with individual awaits:
    start = Date.now();
    const u3Promise = fetchUser(3);
    const p3Promise = fetchPosts(3);
    const [u3, p3] = [await u3Promise, await p3Promise];
    console.log(\`  Pre-started:\${
Date.now()-start}ms →\${
u3.name},\${
p3.length} posts\`);
}

// ─── RETRY PATTERN ────────────────────────────────────
async function retryDemo() {
    console.log("\\n=== Retry Pattern ===");

    async function withRetry(fn, maxRetries = 3, delayMs = 50) {
        let lastError;
        for (let attempt = 1; attempt <= maxRetries; attempt++) {
            try {
                const result = await fn();
                console.log(\`  ✅ Succeeded on attempt\${
attempt}\`);
                return result;
            } catch (e) {
                lastError = e;
                console.log(\`  ❌ Attempt\${
attempt} failed:\${
e.message}\`);
                if (attempt < maxRetries) await delay(delayMs);
            }
        }
        throw lastError;
    }

    let callCount = 0;
    const flaky = () => {
        callCount++;
        return callCount < 3
            ? Promise.reject(new Error("Not ready yet"))
            : Promise.resolve("Success!");
    };

    try {
        const result = await withRetry(flaky);
        console.log("  Result:", result);
    } catch (e) {
        console.log("  All retries failed:", e.message);
    }
}

// ─── ASYNC MEMOIZATION ────────────────────────────────
async function memoDemo() {
    console.log("\\n=== Async Memoization ===");

    function memoAsync(fn) {
        const cache = new Map();
        return async (...args) => {
            const key = JSON.stringify(args);
            if (cache.has(key)) {
                console.log(\`  Cache HIT for\${
key}\`);
                return cache.get(key);
            }
            console.log(\`  Fetching\${
key}...\`);
            const result = await fn(...args);
            cache.set(key, result);
            return result;
        };
    }

    const cachedFetch = memoAsync(fetchUser);
    await cachedFetch(1);  // miss
    await cachedFetch(2);  // miss
    await cachedFetch(1);  // hit!
    await cachedFetch(2);  // hit!
}

// ─── for await...of ───────────────────────────────────
async function asyncIterationDemo() {
    console.log("\\n=== for await...of ===");

    async function* fetchPages() {
        for (let page = 1; page <= 3; page++) {
            await delay(20);
            yield { page, items: [page*10, page*10+1, page*10+2] };
        }
    }

    const allItems = [];
    for await (const { page, items } of fetchPages()) {
        console.log(\`  Page\${
page}:\${
items}\`);
        allItems.push(...items);
    }
    console.log("  All items:", allItems);
}

// ─── IIFE TOP-LEVEL ───────────────────────────────────
(async () => {
    await basics();
    await parallelDemo();
    await retryDemo();
    await memoDemo();
    await asyncIterationDemo();

    console.log("\\n=== Summary ===");
    console.log("  async function always returns a Promise");
    console.log("  await pauses execution until Promise settles");
    console.log("  Use try/catch for error handling");
    console.log("  Use Promise.all() for parallel execution");
    console.log("  Don't await sequentially when parallel is possible");
})();

📝 KEY POINTS:
✅ async functions ALWAYS return a Promise — even if you return a plain value
✅ await can only be used inside async functions (or top-level in ES modules)
✅ await pauses the current async function but does NOT block the event loop
✅ try/catch works naturally with await — rejected promises throw like sync errors
✅ For parallel operations use Promise.all() with await, not sequential awaits
✅ Pre-start promises before awaiting to achieve parallelism
✅ for await...of works with async iterables — great for streaming/pagination
✅ Top-level await works in ES modules (.mjs files, or type="module")
❌ Don't await inside a regular forEach() — use for...of or Promise.all() instead
❌ Awaiting sequentially when operations are independent wastes time
❌ An async function that throws before the first await still returns a rejected Promise
❌ Don't confuse async IIFE patterns with top-level await — they serve different purposes
""",
  quiz: [
    Quiz(question: 'What does an async function always return?', options: [
      QuizOption(text: 'A Promise — even if the function body just returns a plain value like a string', correct: true),
      QuizOption(text: 'The direct return value — async only matters when await is inside', correct: false),
      QuizOption(text: 'undefined — async functions have no return value', correct: false),
      QuizOption(text: 'A generator object that yields values asynchronously', correct: false),
    ]),
    Quiz(question: 'What is the most efficient way to fetch two independent resources with async/await?', options: [
      QuizOption(text: 'const [a, b] = await Promise.all([fetchA(), fetchB()]) — both run in parallel', correct: true),
      QuizOption(text: 'const a = await fetchA(); const b = await fetchB() — sequential is safer', correct: false),
      QuizOption(text: 'await fetchA(); await fetchB() — JavaScript automatically parallelizes awaits', correct: false),
      QuizOption(text: 'Use setTimeout to stagger the requests so they don\'t conflict', correct: false),
    ]),
    Quiz(question: 'Why can\'t you use await inside a regular .forEach() callback?', options: [
      QuizOption(text: 'forEach callbacks are not async — the awaits run but forEach doesn\'t wait for them, so the loop completes immediately', correct: true),
      QuizOption(text: 'await is not valid syntax inside any callback function', correct: false),
      QuizOption(text: 'forEach returns undefined so there\'s no way to chain .then() on it', correct: false),
      QuizOption(text: 'JavaScript only allows one await per function regardless of the function type', correct: false),
    ]),
  ],
);
