import '../../models/lesson.dart';
import '../../models/quiz.dart';

final jsLesson35 = Lesson(
  language: 'JavaScript',
  title: 'Web Storage: localStorage, sessionStorage, and Cookies',
  content: """
🎯 METAPHOR:
Browser storage is like different kinds of notes you
leave for yourself at a computer. localStorage is a
sticky note on the monitor — it stays there permanently
until someone physically removes it. No matter how many
times you close the browser or restart the computer,
the note is still there next time you sit down.
sessionStorage is a whiteboard next to the desk — useful
while you're working, but wiped clean when you leave
(close the tab). Cookies are notes you also hand to the
server every time you walk into the building — they're
sent with every HTTP request so the server knows who you
are, but they have expiry dates and can be marked
"do not read in the lobby" (HttpOnly for security).

📖 EXPLANATION:
Browsers provide three main client-side storage mechanisms,
each with different scope, persistence, and access rules.

─────────────────────────────────────
localStorage — persistent key-value store:
─────────────────────────────────────
  localStorage.setItem('key', 'value')
  localStorage.getItem('key')         → string or null
  localStorage.removeItem('key')
  localStorage.clear()
  localStorage.length                 → number of items
  localStorage.key(0)                 → key at index 0

  // Values MUST be strings:
  localStorage.setItem('user', JSON.stringify({ id: 1 }));
  const user = JSON.parse(localStorage.getItem('user'));

  Characteristics:
  → Persists across sessions (survives tab/browser close)
  → Scoped to origin (protocol + domain + port)
  → ~5MB limit (browser-dependent)
  → Synchronous — blocks the main thread
  → No expiry — stored until manually cleared
  → Not sent to server

─────────────────────────────────────
sessionStorage — session-scoped storage:
─────────────────────────────────────
  Same API as localStorage:
  sessionStorage.setItem('key', 'value')
  sessionStorage.getItem('key')
  sessionStorage.removeItem('key')
  sessionStorage.clear()

  Key differences from localStorage:
  → Cleared when the tab/window is closed
  → Each tab has its own separate sessionStorage
  → Not shared between tabs (even same origin)

  Use cases:
  ✅ Multi-step form state (don't lose on refresh)
  ✅ Temporary shopping cart before login
  ✅ Tab-specific UI state (scroll position, etc.)

─────────────────────────────────────
Cookies — server-sent, HTTP-aware:
─────────────────────────────────────
  // Read all cookies (JS-accessible only):
  document.cookie   → "key1=val1; key2=val2"

  // Set a cookie:
  document.cookie = "theme=dark; max-age=31536000; path=/";
  document.cookie = "session=abc123; secure; samesite=strict";

  Cookie attributes:
  expires / max-age  → when cookie expires
  path               → URL path scope (default: current)
  domain             → domain scope
  secure             → HTTPS only
  samesite           → Lax | Strict | None (CSRF protection)
  HttpOnly           → NOT accessible by JS (server-set only)

  // Reading a specific cookie (need to parse):
  function getCookie(name) {
      return document.cookie.split('; ')
          .find(c => c.startsWith(name + '='))
          ?.split('=')[1];
  }

─────────────────────────────────────
IndexedDB — large structured storage:
─────────────────────────────────────
  → Async (non-blocking, unlike localStorage)
  → Stores any JS object (files, blobs, etc.)
  → Typically 50MB+ limit
  → Indexed queries — not just key-value
  → Complex API — use a library (Dexie.js, idb)

  // With idb library:
  const db = await openDB('MyDB', 1, {
      upgrade(db) {
          db.createObjectStore('users', { keyPath: 'id' });
      }
  });
  await db.put('users', { id: 1, name: 'Alice' });
  const user = await db.get('users', 1);

─────────────────────────────────────
Cache API — for offline/PWA:
─────────────────────────────────────
  const cache = await caches.open('v1');
  await cache.add('/api/data');
  const response = await cache.match('/api/data');

  Used with Service Workers for offline apps.

─────────────────────────────────────
STORAGE COMPARISON:
─────────────────────────────────────
  Feature          localStorage  sessionStorage  Cookies
  ─────────────────────────────────────────────────────
  Persistence      Forever       Tab session     Configurable
  Scope            Origin        Tab             Domain/Path
  Capacity         ~5MB          ~5MB            ~4KB
  Sent to server   No            No              Every request
  JS access        Yes           Yes             Yes (unless HttpOnly)
  API              Sync          Sync            Manual parse/set
  Use case         User prefs    Temp state      Auth sessions

─────────────────────────────────────
BEST PRACTICES:
─────────────────────────────────────
  ✅ localStorage for: theme, language, user preferences
  ✅ sessionStorage for: form wizard state, tabs
  ✅ Cookies for: session tokens, auth (HttpOnly, Secure!)
  ✅ IndexedDB for: large data, offline apps
  ✅ Always JSON.stringify/parse for objects
  ✅ Handle null (item not found) gracefully
  ❌ Never store passwords or sensitive data in localStorage
  ❌ localStorage is synchronous — avoid in tight loops

💻 CODE:
// ─── LOCALSTORAGE SIMULATION ──────────────────────────
class MockStorage {
    #store = new Map();

    setItem(key, value) {
        this.#store.set(String(key), String(value));
    }
    getItem(key) {
        return this.#store.has(String(key)) ? this.#store.get(String(key)) : null;
    }
    removeItem(key) {
        this.#store.delete(String(key));
    }
    clear() {
        this.#store.clear();
    }
    get length() {
        return this.#store.size;
    }
    key(index) {
        return [...this.#store.keys()][index] ?? null;
    }
    get keys() {
        return [...this.#store.keys()];
    }
}

const localStorage = new MockStorage();
const sessionStorage = new MockStorage();

// ─── BASIC localStorage USAGE ─────────────────────────
console.log("=== localStorage Basics ===");

// Primitives (stored as strings):
localStorage.setItem('theme',    'dark');
localStorage.setItem('fontSize', '16');
localStorage.setItem('language', 'en');

console.log("  theme:    ", localStorage.getItem('theme'));
console.log("  fontSize: ", localStorage.getItem('fontSize'));  // string "16"
console.log("  missing:  ", localStorage.getItem('nonexistent'));  // null
console.log("  length:   ", localStorage.length);

// Objects (must JSON stringify/parse):
const user = { id: 1, name: 'Alice', email: 'alice@example.com', role: 'admin' };
localStorage.setItem('user', JSON.stringify(user));

const storedUser = JSON.parse(localStorage.getItem('user'));
console.log("  Stored user:", storedUser);
console.log("  Is same object:", storedUser === user);  // false — it's a copy

// Updating stored object:
const updatedUser = { ...storedUser, lastLogin: new Date().toISOString() };
localStorage.setItem('user', JSON.stringify(updatedUser));
console.log("  Updated user keys:", Object.keys(JSON.parse(localStorage.getItem('user'))));

// ─── TYPED STORAGE WRAPPER ────────────────────────────
console.log("\n=== Typed Storage Wrapper ===");

class TypedStorage {
    constructor(storage, prefix = '') {
        this.storage = storage;
        this.prefix  = prefix;
    }

    #key(k) { return this.prefix + k; }

    set(key, value) {
        this.storage.setItem(this.#key(key), JSON.stringify(value));
        return this;
    }

    get(key, defaultValue = null) {
        const raw = this.storage.getItem(this.#key(key));
        if (raw === null) return defaultValue;
        try { return JSON.parse(raw); }
        catch { return raw; }
    }

    remove(key) {
        this.storage.removeItem(this.#key(key));
        return this;
    }

    update(key, fn, defaultValue = null) {
        const current = this.get(key, defaultValue);
        this.set(key, fn(current));
        return this;
    }

    has(key) {
        return this.storage.getItem(this.#key(key)) !== null;
    }
}

const store = new TypedStorage(localStorage, 'app:');

store.set('preferences', {
    theme: 'dark',
    fontSize: 14,
    notifications: true,
    language: 'en',
});

store.set('visitCount', 0);
store.update('visitCount', n => n + 1);
store.update('visitCount', n => n + 1);

console.log("  preferences:", store.get('preferences'));
console.log("  visitCount:", store.get('visitCount'));  // 2
console.log("  missing (with default):", store.get('missing', { value: 42 }));
console.log("  has preferences:", store.has('preferences'));

// ─── REACTIVE STORAGE ─────────────────────────────────
console.log("\n=== Reactive Storage Pattern ===");

class ReactiveStorage extends TypedStorage {
    #watchers = new Map();

    set(key, value) {
        const old = this.get(key);
        super.set(key, value);
        (this.#watchers.get(key) || []).forEach(cb => cb(value, old, key));
        return this;
    }

    watch(key, callback) {
        if (!this.#watchers.has(key)) this.#watchers.set(key, []);
        this.#watchers.get(key).push(callback);
        return () => {
            this.#watchers.set(key,
                this.#watchers.get(key).filter(cb => cb !== callback));
        };
    }
}

const reactiveStore = new ReactiveStorage(localStorage, 'react:');

const unwatchTheme = reactiveStore.watch('theme', (newVal, oldVal) => {
    console.log(\`  theme changed: "\${
oldVal}" → "\${
newVal}"\`);
});
reactiveStore.watch('count', (newVal, oldVal) => {
    console.log(\`  count:\${
oldVal ?? 0} →\${
newVal}\`);
});

reactiveStore.set('theme', 'light');
reactiveStore.set('theme', 'dark');
reactiveStore.set('count', 1);
reactiveStore.set('count', 2);

unwatchTheme();  // stop watching theme
reactiveStore.set('theme', 'light');  // won't log anymore
console.log("  (theme watcher removed — no output above)");

// ─── COOKIE SIMULATION ────────────────────────────────
console.log("\n=== Cookie Management ===");

class CookieManager {
    #cookies = new Map();

    set(name, value, options = {}) {
        const cookie = {
            value: String(value),
            maxAge:   options.maxAge || null,
            expires:  options.expires || null,
            path:     options.path || '/',
            secure:   options.secure || false,
            httpOnly: options.httpOnly || false,
            sameSite: options.sameSite || 'Lax',
            created:  Date.now(),
        };
        this.#cookies.set(name, cookie);
        console.log(\`  Set cookie:\${
name}=\${
value.slice(0,20)} (sameSite=\${
cookie.sameSite})\`);
    }

    get(name) {
        const cookie = this.#cookies.get(name);
        if (!cookie) return null;
        if (cookie.maxAge && Date.now() > cookie.created + cookie.maxAge * 1000) {
            this.#cookies.delete(name);
            return null;
        }
        return cookie.value;
    }

    delete(name) {
        this.#cookies.delete(name);
    }

    getAll() {
        const result = {};
        this.#cookies.forEach((c, name) => result[name] = c.value);
        return result;
    }
}

const cookies = new CookieManager();

cookies.set('session',  'abc123xyz',    { httpOnly: true, secure: true, sameSite: 'Strict' });
cookies.set('theme',    'dark',         { maxAge: 31536000, sameSite: 'Lax' });
cookies.set('language', 'en',           { maxAge: 86400 });
cookies.set('tracking', 'disable',      { sameSite: 'None', secure: true });

console.log("  session cookie:", cookies.get('session'));
console.log("  theme cookie:  ", cookies.get('theme'));
console.log("  all cookies:   ", cookies.getAll());
cookies.delete('tracking');
console.log("  after delete:  ", Object.keys(cookies.getAll()));

// ─── STORAGE STRATEGY GUIDE ───────────────────────────
console.log("\n=== When to Use Each Storage Type ===");

const guide = [
    ["localStorage",    "User preferences, theme, language, settings (survives sessions)"],
    ["sessionStorage",  "Multi-step form data, tab-specific state, temp auth tokens"],
    ["Cookies",         "Session IDs, auth tokens (use HttpOnly!), cross-tab preferences"],
    ["IndexedDB",       "Large datasets, offline data, files, blobs, complex queries"],
    ["Cache API",       "Cached API responses, offline assets (with Service Workers)"],
];
guide.forEach(([storage, use]) => {
    console.log(\` \${
storage.padEnd(18)}:\${
use}\`);
});

📝 KEY POINTS:
✅ localStorage persists across browser sessions; sessionStorage is cleared when tab closes
✅ Always JSON.stringify() objects before storing; JSON.parse() when retrieving
✅ Always handle null from getItem() — it means the key doesn't exist
✅ sessionStorage is tab-specific — each tab has its own isolated storage
✅ Cookies are sent with EVERY HTTP request — keep them small
✅ Set cookies with HttpOnly to prevent JS access (security for auth tokens)
✅ Set cookies with Secure flag for HTTPS-only transmission
✅ Use SameSite=Strict or Lax on auth cookies to prevent CSRF attacks
✅ IndexedDB is async and can store much more than localStorage (~50MB+)
❌ Never store passwords, private keys, or sensitive data in localStorage — it's XSS-vulnerable
❌ localStorage is synchronous — heavy reads/writes block the main thread
❌ localStorage and sessionStorage only store strings — objects need JSON serialization
❌ Cookie access via document.cookie is cumbersome — use a helper function
""",
  quiz: [
    Quiz(question: 'What is the key difference between localStorage and sessionStorage?', options: [
      QuizOption(text: 'localStorage persists across browser sessions; sessionStorage is cleared when the tab is closed', correct: true),
      QuizOption(text: 'localStorage is shared between tabs; sessionStorage is per-session and shared too', correct: false),
      QuizOption(text: 'sessionStorage has unlimited capacity; localStorage is limited to 5MB', correct: false),
      QuizOption(text: 'localStorage is async; sessionStorage is synchronous', correct: false),
    ]),
    Quiz(question: 'Why should auth session tokens be stored in HttpOnly cookies rather than localStorage?', options: [
      QuizOption(text: 'HttpOnly cookies are not accessible via JavaScript — XSS attacks cannot steal them; localStorage is readable by any JS on the page', correct: true),
      QuizOption(text: 'Cookies have higher storage capacity than localStorage for long tokens', correct: false),
      QuizOption(text: 'HttpOnly cookies are automatically encrypted by the browser', correct: false),
      QuizOption(text: 'localStorage cannot store strings long enough for JWT tokens', correct: false),
    ]),
    Quiz(question: 'What must you do before storing an object in localStorage?', options: [
      QuizOption(text: 'JSON.stringify() the object — localStorage only stores strings', correct: true),
      QuizOption(text: 'Base64 encode the object to make it URL-safe', correct: false),
      QuizOption(text: 'Nothing — localStorage automatically serializes JavaScript objects', correct: false),
      QuizOption(text: 'Convert it to a FormData object which localStorage understands', correct: false),
    ]),
  ],
);
