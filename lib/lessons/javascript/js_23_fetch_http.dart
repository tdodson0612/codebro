import '../../models/lesson.dart';
import '../../models/quiz.dart';

final jsLesson23 = Lesson(
  language: 'JavaScript',
  title: 'Fetch API and HTTP',
  content: """
🎯 METAPHOR:
The Fetch API is like ordering online. You make a request
(fill in the order form — URL, method, headers, body),
hit submit, and get back a promise of a delivery (the
Response). The delivery comes in two stages: first the
doorbell rings (the Response object) telling you the
package arrived and whether it's the right one (status
code). THEN you open the package (.json() or .text())
to get the actual contents. This two-step process is
important: a 404 response STILL resolves the promise —
the delivery truck showed up, just with a "not found"
slip. You need to check the slip (response.ok) before
celebrating.

📖 EXPLANATION:
The Fetch API (built into browsers and Node.js 18+)
is the modern way to make HTTP requests in JavaScript.

─────────────────────────────────────
BASIC GET REQUEST:
─────────────────────────────────────
  const response = await fetch('https://api.example.com/users');

  // ALWAYS check response.ok before using the data:
  if (!response.ok) {
      throw new Error(\`HTTP \${response.status}: \${response.statusText}\`);
  }

  const data = await response.json();   // parse JSON body
  const text = await response.text();   // raw text
  const blob = await response.blob();   // binary data

─────────────────────────────────────
REQUEST OPTIONS:
─────────────────────────────────────
  await fetch(url, {
      method:  'POST',    // GET, POST, PUT, PATCH, DELETE
      headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer token123'
      },
      body:    JSON.stringify({ name: 'Alice', age: 28 }),
      mode:    'cors',    // cors, no-cors, same-origin
      cache:   'no-cache',
      credentials: 'include',  // send cookies
  });

─────────────────────────────────────
THE RESPONSE OBJECT:
─────────────────────────────────────
  response.ok          → true if status 200-299
  response.status      → HTTP status code (200, 404, 500...)
  response.statusText  → "OK", "Not Found", "Server Error"
  response.headers     → Headers object
  response.url         → final URL (after redirects)
  response.redirected  → true if redirected

  // Body methods (each returns a Promise, can only call once!):
  response.json()      → parsed JavaScript object
  response.text()      → string
  response.blob()      → Blob (binary data)
  response.arrayBuffer() → ArrayBuffer
  response.formData()  → FormData

  response.bodyUsed    → true if body already read

─────────────────────────────────────
COMMON HTTP PATTERNS:
─────────────────────────────────────
  // GET:
  const users = await fetch('/api/users').then(r => r.json());

  // POST JSON:
  const created = await fetch('/api/users', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ name: 'Alice' })
  }).then(r => r.json());

  // PUT (full replace):
  await fetch('/api/users/1', {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ name: 'Alice', age: 29 })
  });

  // PATCH (partial update):
  await fetch('/api/users/1', {
      method: 'PATCH',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ age: 29 })
  });

  // DELETE:
  await fetch('/api/users/1', { method: 'DELETE' });

─────────────────────────────────────
ABORT CONTROLLER — cancel requests:
─────────────────────────────────────
  const controller = new AbortController();
  const { signal } = controller;

  // Cancel after 5 seconds:
  const timeoutId = setTimeout(() => controller.abort(), 5000);

  try {
      const res = await fetch(url, { signal });
      clearTimeout(timeoutId);
      return await res.json();
  } catch (e) {
      if (e.name === 'AbortError') {
          console.log("Request was aborted");
      } else throw e;
  }

─────────────────────────────────────
BUILDING A FETCH WRAPPER:
─────────────────────────────────────
  class API {
      constructor(baseUrl, token) {
          this.base = baseUrl;
          this.token = token;
      }

      async request(path, options = {}) {
          const res = await fetch(this.base + path, {
              ...options,
              headers: {
                  'Content-Type': 'application/json',
                  'Authorization': \`Bearer \${this.token}\`,
                  ...options.headers
              }
          });
          if (!res.ok) throw new Error(\`HTTP \${res.status}\`);
          return res.status === 204 ? null : res.json();
      }

      get(path)           { return this.request(path); }
      post(path, data)    { return this.request(path, { method:'POST', body: JSON.stringify(data) }); }
      put(path, data)     { return this.request(path, { method:'PUT',  body: JSON.stringify(data) }); }
      patch(path, data)   { return this.request(path, { method:'PATCH',body: JSON.stringify(data) }); }
      delete(path)        { return this.request(path, { method:'DELETE' }); }
  }

─────────────────────────────────────
FETCH ERROR HANDLING (key insight!):
─────────────────────────────────────
  fetch() only REJECTS on network failure (no internet,
  DNS error). It RESOLVES even for 4xx and 5xx status codes!

  // This does NOT throw on 404:
  const res = await fetch('/not-found');
  console.log(res.ok);      // false
  console.log(res.status);  // 404

  // Always check response.ok:
  if (!res.ok) throw new Error(\`HTTP Error: \${res.status}\`);

💻 CODE:
// Simulating fetch for environments without network access
// In real apps, replace simulatedFetch with actual fetch()

const simulatedDatabase = {
    1: { id: 1, name: "Alice Chen",   email: "alice@example.com", role: "admin" },
    2: { id: 2, name: "Bob Smith",    email: "bob@example.com",   role: "user" },
    3: { id: 3, name: "Carol Davis",  email: "carol@example.com", role: "user" },
};

function simulatedFetch(url, options = {}) {
    return new Promise((resolve, reject) => {
        setTimeout(() => {
            const method = options.method || 'GET';
            const path   = new URL(url, 'http://localhost').pathname;
            const match  = path.match(/\/api\/users\/?(\d+)?/);

            if (!match) {
                resolve(new Response(JSON.stringify({ error: "Not found" }), { status: 404 }));
                return;
            }

            const id = match[1] ? parseInt(match[1]) : null;

            if (method === 'GET') {
                if (id) {
                    const user = simulatedDatabase[id];
                    if (user) resolve(new Response(JSON.stringify(user), { status: 200 }));
                    else resolve(new Response(JSON.stringify({ error: "User not found" }), { status: 404 }));
                } else {
                    resolve(new Response(JSON.stringify(Object.values(simulatedDatabase)), { status: 200 }));
                }
            } else if (method === 'POST') {
                const body = JSON.parse(options.body);
                const newId = Math.max(...Object.keys(simulatedDatabase).map(Number)) + 1;
                const newUser = { id: newId, ...body };
                simulatedDatabase[newId] = newUser;
                resolve(new Response(JSON.stringify(newUser), { status: 201 }));
            } else if (method === 'DELETE' && id) {
                delete simulatedDatabase[id];
                resolve(new Response(null, { status: 204 }));
            } else {
                resolve(new Response(JSON.stringify({ error: "Method not allowed" }), { status: 405 }));
            }
        }, 30);
    });
}

// ─── API WRAPPER ──────────────────────────────────────
class API {
    constructor(baseUrl, fetchFn = simulatedFetch) {
        this.base = baseUrl;
        this.fetchFn = fetchFn;
    }

    async request(path, options = {}) {
        const url = this.base + path;
        console.log(\`  → \${options.method || 'GET'} \${path}\`);

        const res = await this.fetchFn(url, {
            headers: { 'Content-Type': 'application/json' },
            ...options
        });

        console.log(\`  ← HTTP \${res.status}\`);

        if (!res.ok) {
            const error = await res.json().catch(() => ({ error: res.statusText }));
            throw new Error(\`HTTP \${res.status}: \${error.error || res.statusText}\`);
        }

        if (res.status === 204) return null;
        return res.json();
    }

    get(path)         { return this.request(path); }
    post(path, data)  { return this.request(path, { method:'POST',  body: JSON.stringify(data) }); }
    put(path, data)   { return this.request(path, { method:'PUT',   body: JSON.stringify(data) }); }
    patch(path, data) { return this.request(path, { method:'PATCH', body: JSON.stringify(data) }); }
    delete(path)      { return this.request(path, { method:'DELETE' }); }
}

async function main() {
    const api = new API('http://localhost');

    // ─── GET ALL ──────────────────────────────────────
    console.log("=== GET /api/users ===");
    const users = await api.get('/api/users');
    console.log("  Users:", users.map(u => u.name));

    // ─── GET ONE ──────────────────────────────────────
    console.log("\\n=== GET /api/users/1 ===");
    const user1 = await api.get('/api/users/1');
    console.log("  User:", user1);

    // ─── GET NOT FOUND ────────────────────────────────
    console.log("\\n=== GET /api/users/99 (not found) ===");
    try {
        await api.get('/api/users/99');
    } catch (e) {
        console.log("  Caught:", e.message);
    }

    // ─── POST ─────────────────────────────────────────
    console.log("\\n=== POST /api/users ===");
    const newUser = await api.post('/api/users', {
        name: "Dave Wilson",
        email: "dave@example.com",
        role: "user"
    });
    console.log("  Created:", newUser);

    // ─── GET ALL (updated) ────────────────────────────
    console.log("\\n=== GET /api/users (after create) ===");
    const updated = await api.get('/api/users');
    console.log("  Users:", updated.map(u => \`\${u.id}:\${u.name}\`));

    // ─── DELETE ───────────────────────────────────────
    console.log("\\n=== DELETE /api/users/2 ===");
    await api.delete('/api/users/2');
    console.log("  Deleted successfully");

    // ─── PARALLEL REQUESTS ────────────────────────────
    console.log("\\n=== Parallel Requests ===");
    const start = Date.now();
    const [u1, u3] = await Promise.all([
        api.get('/api/users/1'),
        api.get('/api/users/3'),
    ]);
    console.log(\`  Parallel: \${u1.name} + \${u3.name} in \${Date.now()-start}ms\`);

    // ─── ABORT CONTROLLER ─────────────────────────────
    console.log("\\n=== AbortController ===");
    const controller = new AbortController();
    let abortResult;
    try {
        const abortTimeout = setTimeout(() => controller.abort(), 10);
        // Try to fetch with very short timeout
        const longFetch = new Promise((_, reject) => {
            setTimeout(() => {
                if (controller.signal.aborted) reject(new DOMException("Aborted", "AbortError"));
            }, 5);
        });
        await longFetch;
    } catch (e) {
        if (e.name === 'AbortError') {
            console.log("  ✅ Request successfully aborted");
        }
    }
}

main().catch(console.error);

📝 KEY POINTS:
✅ fetch() resolves even for 4xx/5xx — ALWAYS check response.ok before using data
✅ The response body can only be read ONCE — call .json() or .text() once, save the result
✅ Set Content-Type: application/json and JSON.stringify() the body for POST/PUT
✅ Use AbortController to cancel fetch requests (timeout, user navigation)
✅ Build a fetch wrapper class for DRY code — centralize auth headers, error handling
✅ Use Promise.all() for parallel fetches to reduce total latency
✅ response.headers is a Headers object — use .get() to read individual headers
✅ Status 204 No Content means success with no body — don't try to parse it
❌ fetch() does NOT throw on HTTP errors (404, 500) — only on network failure
❌ Don't read response.body twice — it will throw "body already used"
❌ Missing Content-Type header for JSON POST causes servers to reject the body
❌ CORS errors happen on cross-origin requests — server must set proper CORS headers
""",
  quiz: [
    Quiz(question: 'When does fetch() reject its Promise?', options: [
      QuizOption(text: 'Only on network failure (no connection, DNS error) — NOT on HTTP errors like 404 or 500', correct: true),
      QuizOption(text: 'Whenever the HTTP status code is 400 or above', correct: false),
      QuizOption(text: 'Only when the response body cannot be parsed as JSON', correct: false),
      QuizOption(text: 'When the request takes longer than 30 seconds', correct: false),
    ]),
    Quiz(question: 'What does response.ok indicate?', options: [
      QuizOption(text: 'The HTTP status code is in the 200-299 range — the request succeeded', correct: true),
      QuizOption(text: 'The response body was successfully parsed as JSON', correct: false),
      QuizOption(text: 'The request was sent without any network errors', correct: false),
      QuizOption(text: 'All required response headers are present', correct: false),
    ]),
    Quiz(question: 'What is AbortController used for in fetch requests?', options: [
      QuizOption(text: 'To cancel an in-flight fetch request — useful for timeouts or when the user navigates away', correct: true),
      QuizOption(text: 'To abort parsing the JSON response body if it\'s malformed', correct: false),
      QuizOption(text: 'To prevent the fetch from following redirects', correct: false),
      QuizOption(text: 'To abort retrying a failed request after a certain number of attempts', correct: false),
    ]),
  ],
);
