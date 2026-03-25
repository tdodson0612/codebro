import '../../models/lesson.dart';
import '../../models/quiz.dart';

final jsLesson43 = Lesson(
  language: 'JavaScript',
  title: 'Service Workers and Progressive Web Apps',
  content: """
🎯 METAPHOR:
A Service Worker is like a smart proxy server that lives
inside your browser specifically for your website. Every
network request your page makes first goes through this
proxy. The proxy can intercept it and say "I have a
cached copy of this — here you go" (offline mode), or
"let me fetch the latest version and update my cache
while I'm at it" (background sync), or "I'll let this
through to the network" (pass-through). Because it's a
separate thread with its own lifecycle, it keeps working
even when the tab is closed — that's how push
notifications and background sync work. A Progressive
Web App (PWA) is a web app enhanced with Service Workers
to feel like a native app: installable, offline-capable,
and capable of receiving push notifications.

📖 EXPLANATION:
Service Workers are special Web Workers that act as
network proxies with persistent storage (Cache API).

─────────────────────────────────────
SERVICE WORKER LIFECYCLE:
─────────────────────────────────────
  Registration → Install → Activate → Fetch

  1. REGISTER (from your page):
  if ('serviceWorker' in navigator) {
      navigator.serviceWorker.register('/sw.js')
          .then(reg => console.log('SW registered:', reg.scope))
          .catch(err => console.error('SW failed:', err));
  }

  2. INSTALL (in sw.js) — cache initial assets:
  self.addEventListener('install', (event) => {
      event.waitUntil(
          caches.open('v1').then(cache =>
              cache.addAll(['/index.html', '/app.js', '/styles.css'])
          )
      );
  });

  3. ACTIVATE — clean old caches:
  self.addEventListener('activate', (event) => {
      event.waitUntil(
          caches.keys().then(keys =>
              Promise.all(keys.filter(k => k !== 'v1').map(k => caches.delete(k)))
          )
      );
  });

  4. FETCH — intercept network requests:
  self.addEventListener('fetch', (event) => {
      event.respondWith(
          caches.match(event.request)
              .then(cached => cached || fetch(event.request))
      );
  });

─────────────────────────────────────
CACHING STRATEGIES:
─────────────────────────────────────
  CACHE FIRST (offline-first):
  → Check cache, use if found, else fetch and cache
  → Best for: static assets, images, fonts

  NETWORK FIRST (fresh-first):
  → Try network, use cache as fallback
  → Best for: API data, HTML pages

  STALE-WHILE-REVALIDATE:
  → Return cache immediately, update cache in background
  → Best for: non-critical data that should stay fresh

  CACHE ONLY:
  → Only serve from cache, never network
  → Best for: assets you know won't change

  NETWORK ONLY:
  → Always fetch from network, no caching
  → Best for: analytics, payments

─────────────────────────────────────
CACHE API:
─────────────────────────────────────
  const cache = await caches.open('v1');
  await cache.add('/api/data');          // fetch and cache
  await cache.addAll(['/a', '/b']);      // fetch multiple
  await cache.put(request, response);   // store manually
  const res = await cache.match(url);   // retrieve (null if missing)
  await cache.delete(url);              // remove one
  await caches.delete('v1');            // delete entire cache
  const names = await caches.keys();   // list all cache names

─────────────────────────────────────
WEB APP MANIFEST (manifest.json):
─────────────────────────────────────
  {
    "name": "My Awesome App",
    "short_name": "MyApp",
    "start_url": "/",
    "display": "standalone",     // fullscreen, minimal-ui, browser
    "theme_color": "#3498db",
    "background_color": "#ffffff",
    "icons": [
      { "src": "/icon-192.png", "sizes": "192x192", "type": "image/png" },
      { "src": "/icon-512.png", "sizes": "512x512", "type": "image/png" }
    ],
    "description": "A fast, reliable web application"
  }

  <link rel="manifest" href="/manifest.json">

─────────────────────────────────────
PUSH NOTIFICATIONS:
─────────────────────────────────────
  // Request permission:
  const permission = await Notification.requestPermission();

  // Subscribe to push:
  const sub = await registration.pushManager.subscribe({
      userVisibleOnly: true,
      applicationServerKey: vapidPublicKey
  });
  // Send sub to your server

  // In service worker (receive push):
  self.addEventListener('push', (event) => {
      const data = event.data.json();
      event.waitUntil(
          self.registration.showNotification(data.title, {
              body: data.body,
              icon: '/icon-192.png',
          })
      );
  });

─────────────────────────────────────
BACKGROUND SYNC:
─────────────────────────────────────
  // Register sync when offline:
  await registration.sync.register('send-message');

  // In service worker:
  self.addEventListener('sync', (event) => {
      if (event.tag === 'send-message') {
          event.waitUntil(sendQueuedMessages());
      }
  });

─────────────────────────────────────
PWA CHECKLIST:
─────────────────────────────────────
  ✅ HTTPS (required for service workers)
  ✅ Web App Manifest
  ✅ Service Worker registered
  ✅ Offline fallback page
  ✅ Icons (192px, 512px minimum)
  ✅ Responsive design
  ✅ Fast load (< 3s on 3G)
  ✅ Lighthouse PWA score > 90

─────────────────────────────────────
TOOLS:
─────────────────────────────────────
  Workbox     → Google's SW library (caching strategies)
  Vite PWA    → Vite plugin for zero-config PWA
  Lighthouse  → Audit tool built into Chrome DevTools

💻 CODE:
// ─── SERVICE WORKER SIMULATION ────────────────────────
// Real SWs run in a separate context. This simulates the
// exact patterns you'd write in sw.js

const CACHE_VERSION = 'v2';
const STATIC_ASSETS = [
    '/',
    '/index.html',
    '/app.js',
    '/styles.css',
    '/icons/icon-192.png',
];

// ─── SIMULATED CACHE ──────────────────────────────────
class SimulatedCache {
    #entries = new Map();

    async match(request) {
        const key = typeof request === 'string' ? request : request.url;
        return this.#entries.get(key) || null;
    }

    async put(request, response) {
        const key = typeof request === 'string' ? request : request.url;
        this.#entries.set(key, response);
    }

    async add(url) {
        this.#entries.set(url, { url, body: \`Cached content of ${
url}\`, status: 200 });
    }

    async addAll(urls) {
        await Promise.all(urls.map(url => this.add(url)));
    }

    async delete(request) {
        const key = typeof request === 'string' ? request : request.url;
        return this.#entries.delete(key);
    }

    get size() { return this.#entries.size; }
    keys() { return [...this.#entries.keys()]; }
}

class SimulatedCaches {
    #caches = new Map();

    async open(name) {
        if (!this.#caches.has(name)) this.#caches.set(name, new SimulatedCache());
        return this.#caches.get(name);
    }

    async keys() { return [...this.#caches.keys()]; }

    async delete(name) { return this.#caches.delete(name); }

    async match(request) {
        for (const cache of this.#caches.values()) {
            const match = await cache.match(request);
            if (match) return match;
        }
        return null;
    }
}

const caches = new SimulatedCaches();

// ─── INSTALL PHASE ────────────────────────────────────
console.log("=== Service Worker Lifecycle ===");

async function handleInstall() {
    console.log("  [SW] Installing...");
    const cache = await caches.open(CACHE_VERSION);
    await cache.addAll(STATIC_ASSETS);
    console.log(\`  [SW] Cached ${
STATIC_ASSETS.length} static assets\`);
}

// ─── ACTIVATE PHASE ───────────────────────────────────
async function handleActivate() {
    console.log("  [SW] Activating...");
    const cacheNames = await caches.keys();
    const deleted = await Promise.all(
        cacheNames
            .filter(name => name !== CACHE_VERSION)
            .map(name => {
                console.log(\`  [SW] Removing old cache: ${
name}\`);
                return caches.delete(name);
            })
    );
    console.log(\`  [SW] Activation complete. Caches: ${
(await caches.keys()).join(', ')}\`);
}

// ─── CACHING STRATEGIES ───────────────────────────────
async function cacheFirst(request) {
    const cached = await caches.match(request);
    if (cached) {
        console.log(\`    [Cache First] HIT: ${
request.url}\`);
        return cached;
    }
    console.log(\`    [Cache First] MISS — fetching: ${
request.url}\`);
    const response = { url: request.url, body: \`Fresh: ${
request.url}\`, status: 200 };
    const cache = await caches.open(CACHE_VERSION);
    await cache.put(request, response);
    return response;
}

async function networkFirst(request) {
    try {
        console.log(\`    [Network First] Trying network: ${
request.url}\`);
        const response = { url: request.url, body: \`Network: ${
request.url}\`, status: 200 };
        const cache = await caches.open(CACHE_VERSION);
        await cache.put(request, response);
        return response;
    } catch (e) {
        const cached = await caches.match(request);
        if (cached) {
            console.log(\`    [Network First] Network failed, using cache: ${
request.url}\`);
            return cached;
        }
        throw new Error(\`No cache and no network for ${
request.url}\`);
    }
}

async function staleWhileRevalidate(request) {
    const cached  = await caches.match(request);
    const refresh = (async () => {
        const response = { url: request.url, body: \`Updated: ${
request.url}\`, status: 200 };
        const cache = await caches.open(CACHE_VERSION);
        await cache.put(request, response);
        console.log(\`    [SWR] Background updated: ${
request.url}\`);
        return response;
    })();

    if (cached) {
        console.log(\`    [SWR] Serving stale: ${
request.url} (revalidating in background)\`);
        return cached;
    }
    return refresh;
}

// ─── FETCH HANDLER ────────────────────────────────────
async function handleFetch(request) {
    const url = request.url;

    if (url.includes('/api/')) {
        return networkFirst(request);         // API: always try network
    } else if (url.includes('/images/')) {
        return cacheFirst(request);           // Images: cache first
    } else if (url.includes('/data/')) {
        return staleWhileRevalidate(request); // Data: fast + fresh
    } else {
        return cacheFirst(request);           // Default: cache first
    }
}

// ─── RUN THE SIMULATION ───────────────────────────────
(async () => {
    // 1. Install
    await handleInstall();

    // 2. Activate (removes old cache versions)
    const oldCache = await caches.open('v1');
    await oldCache.add('/old-asset.js');
    await handleActivate();

    // 3. Serve requests with different strategies
    console.log("\n=== Fetch Strategy Demo ===");

    const requests = [
        { url: '/index.html' },
        { url: '/api/users' },
        { url: '/images/hero.jpg' },
        { url: '/data/config.json' },
        { url: '/index.html' },   // second request — should be cached
        { url: '/api/users' },    // network first always goes to network
    ];

    for (const req of requests) {
        const response = await handleFetch(req);
        console.log(\`  → ${
req.url}: ${
response.body.slice(0, 40)}\`);
    }

    // 4. Cache inspection
    console.log("\n=== Cache Inspection ===");
    const cache = await caches.open(CACHE_VERSION);
    console.log(\`  Total cached items: ${
cache.size}\`);
    console.log("  Cached URLs:");
    cache.keys().slice(0, 8).forEach(k => console.log(\`    ${
k}\`));

    // 5. PWA Manifest simulation
    console.log("\n=== Web App Manifest ===");
    const manifest = {
        name:             "CodeBro",
        short_name:       "CodeBro",
        description:      "Learn programming on the go",
        start_url:        "/",
        display:          "standalone",
        theme_color:      "#1a73e8",
        background_color: "#ffffff",
        icons: [
            { src: "/icons/icon-192.png", sizes: "192x192", type: "image/png" },
            { src: "/icons/icon-512.png", sizes: "512x512", type: "image/png", purpose: "maskable" },
        ],
        categories:  ["education", "productivity"],
        shortcuts: [
            { name: "JavaScript", url: "/learn/javascript", icon: { src: "/icons/js.png" } },
            { name: "Python",     url: "/learn/python",     icon: { src: "/icons/py.png" } },
        ],
    };
    console.log("  Manifest:", JSON.stringify(manifest, null, 2).split('\n').slice(0, 10).join('\n'));
    console.log("  ...(more fields)");

    // 6. Background sync simulation
    console.log("\n=== Background Sync Pattern ===");
    const syncQueue = [];

    function queueForSync(action) {
        syncQueue.push({ action, timestamp: Date.now(), retries: 0 });
        console.log(\`  Queued: ${
action}\`);
    }

    async function processSyncQueue() {
        console.log(\`  Processing ${
syncQueue.length} queued actions:\`);
        while (syncQueue.length > 0) {
            const item = syncQueue.shift();
            console.log(\`    ✅ Synced: ${
item.action}\`);
        }
    }

    queueForSync("Create post: 'JavaScript modules explained'");
    queueForSync("Update user preference: theme=dark");
    queueForSync("Mark lesson complete: js-27");
    await processSyncQueue();
})();

📝 KEY POINTS:
✅ Service Workers are HTTPS-only — they require a secure context
✅ SW lifecycle: Register → Install (cache assets) → Activate (cleanup) → Fetch (intercept)
✅ event.waitUntil() keeps the SW alive until the Promise resolves
✅ Cache First is best for static assets; Network First for API data
✅ Stale-While-Revalidate serves cached content immediately while updating in background
✅ Web App Manifest enables "Add to Home Screen" and standalone display
✅ Workbox is the recommended library for production-ready SW caching strategies
✅ Lighthouse in Chrome DevTools audits PWA compliance and performance
❌ Service Workers only work on HTTPS (and localhost for development)
❌ The SW runs in a separate thread — no DOM access
❌ Not calling event.waitUntil() may cause async operations to be cut short
❌ Always version your caches — old caches must be deleted in activate phase
""",
  quiz: [
    Quiz(question: 'What is the purpose of the Service Worker\'s install event?', options: [
      QuizOption(text: 'To pre-cache critical static assets so the app works offline from the first visit', correct: true),
      QuizOption(text: 'To register the service worker with the browser\'s security module', correct: false),
      QuizOption(text: 'To set up push notification subscriptions', correct: false),
      QuizOption(text: 'To check whether the user has a valid authentication token', correct: false),
    ]),
    Quiz(question: 'What caching strategy serves a cached response immediately while updating the cache in the background?', options: [
      QuizOption(text: 'Stale-While-Revalidate — fast response from cache, fresh update happening concurrently', correct: true),
      QuizOption(text: 'Network First — always goes to network before returning anything', correct: false),
      QuizOption(text: 'Cache First — returns cache and never updates it', correct: false),
      QuizOption(text: 'Cache Only — serves from cache and ignores the network entirely', correct: false),
    ]),
    Quiz(question: 'What is required for Service Workers to work?', options: [
      QuizOption(text: 'HTTPS (or localhost for development) — Service Workers are restricted to secure contexts', correct: true),
      QuizOption(text: 'A valid Web App Manifest file in the root directory', correct: false),
      QuizOption(text: 'The user must have granted notification permissions first', correct: false),
      QuizOption(text: 'Node.js must be running on the server to support Service Worker registration', correct: false),
    ]),
  ],
);
