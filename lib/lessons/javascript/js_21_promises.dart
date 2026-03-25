import '../../models/lesson.dart';
import '../../models/quiz.dart';

final jsLesson21 = Lesson(
  language: 'JavaScript',
  title: 'Promises',
  content: """
🎯 METAPHOR:
A Promise is like a restaurant pager when your table
isn't ready. You order at the counter (start an async
operation), they give you a pager (the Promise object),
and you're free to wander the mall (keep doing other
work). The pager either buzzes (the promise RESOLVES —
success with a value) or flashes an error message
(REJECTS — failure with a reason). You set up what to
do when it buzzes BEFORE it buzzes — that's .then().
You set up what to do if it fails — that's .catch().
The key insight: you can set up these handlers NOW even
though the result doesn't exist yet.

📖 EXPLANATION:
Promises are JavaScript's way of representing an eventual
(asynchronous) result. They have three states:
pending → fulfilled or rejected (settled).

─────────────────────────────────────
CREATING A PROMISE:
─────────────────────────────────────
  const promise = new Promise((resolve, reject) => {
      // Async work here...
      if (success) {
          resolve(value);    // fulfill with a value
      } else {
          reject(reason);    // reject with a reason
      }
  });

  // Shorthand creators:
  Promise.resolve(42)          // already fulfilled with 42
  Promise.reject(new Error())  // already rejected

─────────────────────────────────────
CONSUMING PROMISES:
─────────────────────────────────────
  promise
      .then(value  => console.log("Success:", value))
      .catch(error => console.error("Error:", error))
      .finally(()  => console.log("Always runs"));

  // .then() can take two args:
  promise.then(
      value  => console.log("Fulfilled:", value),
      reason => console.log("Rejected:", reason)
  );

─────────────────────────────────────
CHAINING:
─────────────────────────────────────
  // Each .then() returns a NEW promise:
  fetch('/api/user')
      .then(res  => res.json())         // transform
      .then(user => user.name)          // extract
      .then(name => name.toUpperCase()) // transform again
      .then(name => console.log(name))
      .catch(err => console.error(err));

  // Return a promise to chain async ops:
  getUserId()
      .then(id  => fetchUser(id))      // returns a promise
      .then(user => fetchPosts(user))  // waits for above
      .then(posts => console.log(posts));

─────────────────────────────────────
PROMISE COMBINATORS:
─────────────────────────────────────
  Promise.all([p1, p2, p3])
    → Waits for ALL to fulfill. Rejects if ANY rejects.
    → Returns array of results in INPUT order.

  Promise.allSettled([p1, p2, p3])
    → Waits for ALL to settle (fulfill OR reject).
    → Returns [{status, value/reason}] — never rejects.

  Promise.race([p1, p2, p3])
    → Resolves/rejects with the FIRST to settle.

  Promise.any([p1, p2, p3])
    → Resolves with the FIRST to FULFILL.
    → Rejects (AggregateError) only if ALL reject.

  Promise.withResolvers()  (ES2024)
    → Returns { promise, resolve, reject }
    → Create a promise and expose its resolvers

─────────────────────────────────────
COMMON PATTERNS:
─────────────────────────────────────
  // Timeout pattern:
  function withTimeout(promise, ms) {
      const timeout = new Promise((_, reject) =>
          setTimeout(() => reject(new Error("Timeout")), ms));
      return Promise.race([promise, timeout]);
  }

  // Retry pattern:
  async function retry(fn, times) {
      for (let i = 0; i < times; i++) {
          try { return await fn(); }
          catch (e) { if (i === times - 1) throw e; }
      }
  }

  // Sequential promises (not parallel):
  const results = await [1, 2, 3].reduce(
      async (acc, n) => [...(await acc), await fetchData(n)],
      Promise.resolve([])
  );

─────────────────────────────────────
COMMON MISTAKES:
─────────────────────────────────────
  ❌ Forgetting to return in .then():
  .then(user => { user.save(); })   // returns undefined!
  ✅ .then(user => user.save())      // returns the promise

  ❌ Nested promises (promise hell):
  fetch(url).then(r => r.json().then(data => ...))

  ✅ Flat chain:
  fetch(url).then(r => r.json()).then(data => ...)

  ❌ Missing .catch() on Promise.all():
  Promise.all([p1, p2, p3]) // unhandled rejection!
  ✅ Promise.all([p1, p2, p3]).catch(err => ...)

💻 CODE:
// ─── CREATING PROMISES ────────────────────────────────
console.log("=== Creating Promises ===");

function delay(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

function fetchData(id) {
    return new Promise((resolve, reject) => {
        setTimeout(() => {
            if (id > 0) {
                resolve({ id, name: \`User${
id}\`, score: id * 10 });
            } else {
                reject(new Error(\`Invalid ID: ${
id}\`));
            }
        }, 50);
    });
}

// Test basic resolution:
fetchData(1)
    .then(user => {
        console.log("  Resolved:", user);
        return user.score;
    })
    .then(score => console.log("  Score:", score))
    .catch(err  => console.log("  Error:", err.message))
    .finally(()  => console.log("  Done (finally)"));

// Test rejection:
fetchData(-1)
    .then(user => console.log("  Should not reach here"))
    .catch(err => console.log("  Caught rejection:", err.message));

// ─── CHAINING ─────────────────────────────────────────
console.log("\\n=== Promise Chaining ===");

function step(name, value) {
    return new Promise(resolve => {
        setTimeout(() => {
            console.log(\`  Step ${
name}: ${
value}\`);
            resolve(value + 1);
        }, 20);
    });
}

step("A", 1)
    .then(v => step("B", v))
    .then(v => step("C", v))
    .then(v => step("D", v))
    .then(v => console.log("  Final value:", v));

// ─── PROMISE COMBINATORS ──────────────────────────────
async function combinators() {
    console.log("\\n=== Promise Combinators ===");

    const fast   = () => new Promise(resolve => setTimeout(() => resolve("fast"),   50));
    const medium = () => new Promise(resolve => setTimeout(() => resolve("medium"), 100));
    const slow   = () => new Promise(resolve => setTimeout(() => resolve("slow"),   150));
    const fail   = () => new Promise((_, reject) => setTimeout(() => reject(new Error("💥 failed")), 75));

    // Promise.all — wait for ALL:
    const allResults = await Promise.all([fast(), medium(), slow()]);
    console.log("  Promise.all:", allResults);

    // Promise.all fails if any rejects:
    try {
        await Promise.all([fast(), fail(), slow()]);
    } catch (e) {
        console.log("  Promise.all (with failure):", e.message);
    }

    // Promise.allSettled — all settle regardless:
    const settled = await Promise.allSettled([fast(), fail(), slow()]);
    settled.forEach((result, i) => {
        if (result.status === 'fulfilled') {
            console.log(\`  allSettled[${
i}]: ✅ ${
result.value}\`);
        } else {
            console.log(\`  allSettled[${
i}]: ❌ ${
result.reason.message}\`);
        }
    });

    // Promise.race — first to settle wins:
    const winner = await Promise.race([fast(), medium(), slow()]);
    console.log("  Promise.race winner:", winner);

    // Promise.any — first to FULFILL wins:
    const anyResult = await Promise.any([fail(), medium(), slow()]);
    console.log("  Promise.any (ignores failure):", anyResult);

    // Promise.any rejects only if ALL reject:
    try {
        await Promise.any([
            Promise.reject(new Error("e1")),
            Promise.reject(new Error("e2")),
        ]);
    } catch (e) {
        console.log("  Promise.any (all failed):", e instanceof AggregateError, e.errors.length, "errors");
    }
}
combinators();

// ─── COMMON PATTERNS ──────────────────────────────────
async function patterns() {
    console.log("\\n=== Common Patterns ===");

    // Timeout wrapper:
    function withTimeout(promise, ms) {
        const timeout = new Promise((_, reject) =>
            setTimeout(() => reject(new Error(\`Timed out after ${
ms}ms\`)), ms));
        return Promise.race([promise, timeout]);
    }

    try {
        const result = await withTimeout(
            new Promise(resolve => setTimeout(() => resolve("done"), 50)),
            200
        );
        console.log("  withTimeout (pass):", result);
    } catch (e) {
        console.log("  withTimeout (fail):", e.message);
    }

    try {
        await withTimeout(
            new Promise(resolve => setTimeout(() => resolve("done"), 500)),
            100
        );
    } catch (e) {
        console.log("  withTimeout (timeout):", e.message);
    }

    // Parallel with limit (run max N concurrently):
    async function parallelLimit(tasks, limit) {
        const results = [];
        const executing = [];
        for (const task of tasks) {
            const p = task().then(result => { results.push(result); });
            executing.push(p);
            if (executing.length >= limit) {
                await Promise.race(executing);
                executing.splice(executing.findIndex(e => e === p), 1);
            }
        }
        await Promise.all(executing);
        return results;
    }

    const tasks = [1,2,3,4,5].map(i => () => fetchData(i));
    const parallel = await parallelLimit(tasks, 2);
    console.log("  Parallel(limit=2) count:", parallel.length);

    // Promise.withResolvers (ES2024):
    if (Promise.withResolvers) {
        const { promise, resolve, reject } = Promise.withResolvers();
        setTimeout(() => resolve("withResolvers result"), 30);
        console.log("  Promise.withResolvers:", await promise);
    }

    // Sequential promises:
    const ids = [1, 2, 3];
    const sequential = [];
    for (const id of ids) {
        sequential.push(await fetchData(id));
    }
    console.log("  Sequential:", sequential.map(u => u.name));
}
patterns();

📝 KEY POINTS:
✅ Promises have three states: pending → fulfilled (resolved) or rejected (settled)
✅ .then() handles fulfillment; .catch() handles rejection; .finally() always runs
✅ Each .then() returns a NEW promise — enabling flat chaining
✅ Returning a promise inside .then() causes the chain to wait for it
✅ Promise.all(): waits for all, fails fast if any reject
✅ Promise.allSettled(): waits for all, never rejects — gives each result's status
✅ Promise.race(): resolves/rejects with the first settled promise
✅ Promise.any(): resolves with first fulfilled — rejects only if ALL reject
✅ Promise.withResolvers() (ES2024): extract resolve/reject to call externally
❌ Forgetting to return in .then() passes undefined to the next handler
❌ Nesting .then() inside .then() creates "promise hell" — keep chains flat
❌ Always add .catch() — unhandled rejections crash Node.js and warn in browsers
❌ Promise.all() with a failure immediately rejects — use allSettled() if you need all results
""",
  quiz: [
    Quiz(question: 'What is the difference between Promise.all() and Promise.allSettled()?', options: [
      QuizOption(text: 'Promise.all() rejects immediately if any promise rejects; allSettled() always waits for all and reports each outcome', correct: true),
      QuizOption(text: 'Promise.all() runs promises in sequence; allSettled() runs them in parallel', correct: false),
      QuizOption(text: 'They are identical — allSettled() is just the newer name for all()', correct: false),
      QuizOption(text: 'Promise.allSettled() only works with arrays of exactly the same type of promises', correct: false),
    ]),
    Quiz(question: 'What happens when you return a Promise inside a .then() callback?', options: [
      QuizOption(text: 'The next .then() in the chain waits for that returned Promise to settle before running', correct: true),
      QuizOption(text: 'The Promise is ignored and undefined is passed to the next .then()', correct: false),
      QuizOption(text: 'It throws a TypeError — you cannot return Promises from .then()', correct: false),
      QuizOption(text: 'The chain immediately resolves with the Promise object itself', correct: false),
    ]),
    Quiz(question: 'What does Promise.any() do when ALL promises reject?', options: [
      QuizOption(text: 'It throws an AggregateError containing all the rejection reasons', correct: true),
      QuizOption(text: 'It resolves with undefined — no value is available', correct: false),
      QuizOption(text: 'It resolves with the last rejection reason as the value', correct: false),
      QuizOption(text: 'It behaves the same as Promise.all() and rejects with the first error', correct: false),
    ]),
  ],
);
