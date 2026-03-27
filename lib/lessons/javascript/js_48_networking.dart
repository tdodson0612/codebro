import '../../models/lesson.dart';
import '../../models/quiz.dart';

final jsLesson48 = Lesson(
  language: 'JavaScript',
  title: 'Advanced Networking: WebSockets, SSE, and more',
  content: """
🎯 METAPHOR:
HTTP (fetch) is like sending letters — you write a letter,
send it, wait for a reply, then the conversation ends.
Each request is independent. WebSockets are like a
phone call — once connected, both sides can talk at any
time without the overhead of a new connection for each
message. Server-Sent Events (SSE) are like a radio
broadcast — the server talks to YOU continuously, but
you can't talk back (one-way). WebRTC is like walkie-
talkies between browsers — direct peer-to-peer without
a server in the middle. Each pattern fits different needs:
HTTP for CRUD, WebSockets for real-time bidirectional,
SSE for live feeds, WebRTC for video/audio.

📖 EXPLANATION:
Modern web applications need more than request-response.
JavaScript provides several networking APIs for different
real-time communication patterns.

─────────────────────────────────────
WebSocket — full-duplex communication:
─────────────────────────────────────
  const ws = new WebSocket('wss://api.example.com/ws');

  // Events:
  ws.onopen    = () => ws.send('Hello server!');
  ws.onmessage = (event) => console.log(event.data);
  ws.onclose   = (event) => console.log(event.code, event.reason);
  ws.onerror   = (error) => console.error(error);

  // Send data:
  ws.send('plain text');
  ws.send(JSON.stringify({ type: 'ping', ts: Date.now() }));
  ws.send(arrayBuffer);   // binary data

  // Close:
  ws.close(1000, 'Normal closure');

  // State:
  ws.readyState   // CONNECTING=0, OPEN=1, CLOSING=2, CLOSED=3

  // Use cases: chat, live sports scores, collaborative editing,
  //            trading terminals, multiplayer games, live dashboards

─────────────────────────────────────
SERVER-SENT EVENTS (SSE) — one-way push:
─────────────────────────────────────
  const es = new EventSource('/api/events');

  es.onmessage = (event) => console.log(event.data);
  es.onerror   = (error) => console.error(error);
  es.onopen    = () => console.log('Connected');

  // Named events:
  es.addEventListener('user:joined', (event) => {
      const user = JSON.parse(event.data);
      console.log('Joined:', user.name);
  });

  es.close();  // stop listening

  // Server sends (Node.js):
  res.writeHead(200, {
      'Content-Type': 'text/event-stream',
      'Cache-Control': 'no-cache',
      'Connection': 'keep-alive',
  });
  res.write('data: hello\n\n');
  res.write('event: user:joined\ndata: {"name":"Alice"}\n\n');

  // Use cases: live feeds, notifications, progress bars,
  //            stock tickers (one-way)

─────────────────────────────────────
Beacon API — fire-and-forget:
─────────────────────────────────────
  // Reliable even as page unloads:
  navigator.sendBeacon('/analytics', JSON.stringify(eventData));

  // Use cases: analytics on page exit, error reporting
  // Unlike fetch, works reliably in unload/beforeunload

─────────────────────────────────────
URL and URLSearchParams:
─────────────────────────────────────
  const url = new URL('https://api.example.com/users?page=1');
  url.searchParams.set('limit', '20');
  url.searchParams.append('tag', 'javascript');
  url.searchParams.append('tag', 'nodejs');

  url.toString()
  // 'https://api.example.com/users?page=1&limit=20&tag=javascript&tag=nodejs'

  url.searchParams.get('page')      // '1'
  url.searchParams.getAll('tag')    // ['javascript', 'nodejs']
  url.searchParams.has('limit')     // true
  url.searchParams.delete('page')

─────────────────────────────────────
HTTP/2 and HTTP/3:
─────────────────────────────────────
  HTTP/2 benefits (automatic, no code changes):
  → Multiplexing: multiple requests on one connection
  → Server push: server sends resources before request
  → Header compression
  → Binary protocol (faster parsing)

  HTTP/3 (QUIC):
  → Built on UDP instead of TCP
  → Faster connection establishment
  → Better performance on poor networks

─────────────────────────────────────
REQUEST INTERCEPTORS PATTERN:
─────────────────────────────────────
  // Wrap fetch to add auth, logging, retry:
  const api = {
      async fetch(url, options = {}) {
          const token = getAuthToken();
          const response = await fetch(url, {
              ...options,
              headers: {
                  'Authorization': \`Bearer\${
token}\`,
                  'Content-Type': 'application/json',
                  ...options.headers,
              },
          });
          if (response.status === 401) {
              await refreshToken();
              return api.fetch(url, options);  // retry once
          }
          if (!response.ok) throw new Error(\`HTTP\${
response.status}\`);
          return response.json();
      }
  };

─────────────────────────────────────
RETRY AND CIRCUIT BREAKER:
─────────────────────────────────────
  async function fetchWithRetry(url, options, maxRetries = 3) {
      let lastError;
      for (let i = 0; i < maxRetries; i++) {
          try {
              const res = await fetch(url, options);
              if (res.ok) return res.json();
              throw new Error(\`HTTP\${
res.status}\`);
          } catch (e) {
              lastError = e;
              await delay(2 ** i * 100);  // exponential backoff
          }
      }
      throw lastError;
  }

💻 CODE:
// ─── WEBSOCKET CLIENT SIMULATION ──────────────────────
console.log("=== WebSocket Chat Room Simulation ===");

class MockWebSocket {
    #readyState = 0;
    #handlers   = {};
    #serverRef;
    url;

    constructor(url) {
        this.url = url;
        setTimeout(() => {
            this.#readyState = 1;  // OPEN
            this.#handlers.open?.({ type: 'open' });
        }, 10);
    }

    get readyState() { return this.#readyState; }

    send(data) {
        if (this.#readyState !== 1) throw new Error("WebSocket is not open");
        const parsed = typeof data === 'string' ? JSON.parse(data) : data;
        // Simulate server echo with processing:
        setTimeout(() => {
            const response = this.#serverRef?.(parsed);
            if (response) {
                this.#handlers.message?.({ data: JSON.stringify(response) });
            }
        }, 20);
    }

    set onopen(fn)    { this.#handlers.open    = fn; }
    set onmessage(fn) { this.#handlers.message = fn; }
    set onerror(fn)   { this.#handlers.error   = fn; }
    set onclose(fn)   { this.#handlers.close   = fn; }

    close(code = 1000, reason = '') {
        this.#readyState = 3;  // CLOSED
        this.#handlers.close?.({ code, reason });
    }

    // Test utility: set server handler
    _setServer(fn) { this.#serverRef = fn; }
}

// Simulate a chat server:
function chatServer(msg) {
    switch (msg.type) {
        case 'join':
            return { type: 'system', text: \`\${
msg.user} joined the room\`, users: ['Alice', 'Bob', msg.user] };
        case 'message':
            return { type: 'message', from: msg.user, text: msg.text, ts: Date.now() };
        case 'ping':
            return { type: 'pong', ts: msg.ts };
        default:
            return { type: 'error', message: \`Unknown type:\${
msg.type}\` };
    }
}

const ws = new MockWebSocket('wss://chat.example.com/room/1');
ws._setServer(chatServer);

ws.onopen = () => {
    console.log("  ✅ Connected to chat server");
    ws.send(JSON.stringify({ type: 'join', user: 'Terry' }));
};

ws.onmessage = ({ data }) => {
    const msg = JSON.parse(data);
    switch (msg.type) {
        case 'system':
            console.log(\`  [SYSTEM]\${
msg.text} (users:\${
msg.users.join(', ')})\`);
            // Send a message after joining:
            setTimeout(() => {
                ws.send(JSON.stringify({ type: 'message', user: 'Terry', text: 'Hello everyone!' }));
            }, 30);
            break;
        case 'message':
            console.log(\`  [\${
msg.from}]:\${
msg.text}\`);
            // Send a ping:
            setTimeout(() => {
                ws.send(JSON.stringify({ type: 'ping', ts: Date.now() }));
            }, 60);
            break;
        case 'pong':
            console.log(\`  [PING] Latency: ~\${
Date.now() - msg.ts}ms\`);
            ws.close(1000, 'Done');
            break;
    }
};

ws.onclose = ({ code, reason }) => {
    console.log(\`  Disconnected: code=\${
code} reason='\${
reason}'\`);
};

// ─── SERVER-SENT EVENTS SIMULATION ────────────────────
setTimeout(() => {
    console.log("\n=== Server-Sent Events (SSE) ===");

    class MockEventSource {
        #active = true;
        #handler;
        #listeners = new Map();
        url;

        constructor(url) {
            this.url = url;
            console.log(\`  [SSE] Connected to\${
url}\`);
            this.#startStream();
        }

        #startStream() {
            // Simulate server events:
            const events = [
                { event: 'message',      data: '{"metric": "cpu", "value": 45}', delay: 20 },
                { event: 'message',      data: '{"metric": "memory", "value": 72}', delay: 40 },
                { event: 'alert',        data: '{"severity": "warning", "msg": "High CPU"}', delay: 60 },
                { event: 'message',      data: '{"metric": "cpu", "value": 38}', delay: 80 },
                { event: 'connected',    data: '{"clientCount": 42}', delay: 100 },
            ];

            events.forEach(({ event, data, delay }) => {
                setTimeout(() => {
                    if (!this.#active) return;
                    const evt = { data, type: event, lastEventId: '' };
                    if (event === 'message') {
                        this.#handler?.({ data });
                    } else {
                        (this.#listeners.get(event) || []).forEach(fn => fn(evt));
                    }
                }, delay);
            });
        }

        set onmessage(fn) { this.#handler = fn; }

        addEventListener(event, fn) {
            if (!this.#listeners.has(event)) this.#listeners.set(event, []);
            this.#listeners.get(event).push(fn);
        }

        close() {
            this.#active = false;
            console.log("  [SSE] Connection closed");
        }
    }

    const es = new MockEventSource('/api/metrics/stream');

    es.onmessage = ({ data }) => {
        const metric = JSON.parse(data);
        console.log(\`  [SSE] Metric:\${
metric.metric} =\${
metric.value}%\`);
    };

    es.addEventListener('alert', ({ data }) => {
        const alert = JSON.parse(data);
        console.log(\`  [SSE] ⚠️  Alert [\${
alert.severity}]:\${
alert.msg}\`);
    });

    es.addEventListener('connected', ({ data }) => {
        const info = JSON.parse(data);
        console.log(\`  [SSE] 👥\${
info.clientCount} clients connected\`);
        setTimeout(() => es.close(), 10);
    });
}, 200);

// ─── URL AND SEARCHPARAMS ─────────────────────────────
setTimeout(() => {
    console.log("\n=== URL and URLSearchParams ===");

    const baseUrl = new URL('https://api.example.com/search');
    baseUrl.searchParams.set('q', 'javascript closures');
    baseUrl.searchParams.set('page', '1');
    baseUrl.searchParams.set('limit', '20');
    baseUrl.searchParams.append('tag', 'javascript');
    baseUrl.searchParams.append('tag', 'programming');

    console.log("  Full URL:", baseUrl.toString());
    console.log("  hostname:", baseUrl.hostname);
    console.log("  pathname:", baseUrl.pathname);
    console.log("  search:", baseUrl.search);
    console.log("  q:", baseUrl.searchParams.get('q'));
    console.log("  tags:", baseUrl.searchParams.getAll('tag'));
    console.log("  has 'page':", baseUrl.searchParams.has('page'));

    // Build URLs dynamically:
    function buildApiUrl(endpoint, params = {}) {
        const url = new URL(endpoint, 'https://api.example.com');
        Object.entries(params).forEach(([key, value]) => {
            if (Array.isArray(value)) {
                value.forEach(v => url.searchParams.append(key, v));
            } else if (value !== null && value !== undefined) {
                url.searchParams.set(key, String(value));
            }
        });
        return url.toString();
    }

    const userUrl = buildApiUrl('/users', {
        page:   1,
        limit:  10,
        role:   'admin',
        active: true,
        tags:   ['js', 'react'],
    });
    console.log("  Built URL:", userUrl);
}, 400);

// ─── FETCH INTERCEPTOR PATTERN ────────────────────────
setTimeout(() => {
    console.log("\n=== Fetch Interceptor Pattern ===");

    class HttpClient {
        #baseUrl;
        #defaultHeaders;
        #requestInterceptors  = [];
        #responseInterceptors = [];

        constructor(baseUrl, defaultHeaders = {}) {
            this.#baseUrl = baseUrl;
            this.#defaultHeaders = defaultHeaders;
        }

        addRequestInterceptor(fn) {
            this.#requestInterceptors.push(fn);
            return this;
        }

        addResponseInterceptor(fn) {
            this.#responseInterceptors.push(fn);
            return this;
        }

        async fetch(path, options = {}) {
            let config = {
                url:     this.#baseUrl + path,
                headers: { ...this.#defaultHeaders, ...options.headers },
                ...options,
            };

            // Apply request interceptors:
            for (const interceptor of this.#requestInterceptors) {
                config = await interceptor(config);
            }

            console.log(\`  →\${
config.method || 'GET'}\${
config.url}\`);

            // Simulate fetch response:
            let response = {
                ok:     true,
                status: 200,
                json:   async () => ({ success: true, url: config.url, headers: config.headers }),
            };

            // Apply response interceptors:
            for (const interceptor of this.#responseInterceptors) {
                response = await interceptor(response, config);
            }

            return response.json();
        }

        get(path, params = {}) {
            const url = params ? `\${path}?\${new URLSearchParams(params)}` : path;
            return this.fetch(url, { method: 'GET' });
        }
    }

    const client = new HttpClient('https://api.example.com')
        .addRequestInterceptor(async (config) => {
            config.headers['Authorization'] = 'Bearer token-abc123';
            config.headers['X-Request-ID'] = Math.random().toString(36).slice(2);
            config.startTime = Date.now();
            return config;
        })
        .addResponseInterceptor(async (response, config) => {
            console.log(\`  ←\${
response.status} in\${
Date.now() - config.startTime}ms\`);
            return response;
        });

    (async () => {
        const result1 = await client.get('/users', { page: 1, limit: 10 });
        console.log("  Response headers:", Object.keys(result1.headers).join(', '));

        const result2 = await client.get('/products', { category: 'electronics' });
        console.log("  Response url:", result2.url);
    })();
}, 600);

📝 KEY POINTS:
✅ WebSockets provide full-duplex communication — both sides can send at any time
✅ ws.send() sends data; ws.onmessage handles incoming; ws.onopen confirms connection
✅ SSE (EventSource) is one-way server-to-client — simpler than WebSockets for feeds
✅ SSE automatically reconnects after disconnection; WebSockets require manual reconnect
✅ URL and URLSearchParams handle URL building correctly — use instead of string concatenation
✅ The Beacon API sends data reliably even during page unload
✅ Request/response interceptors centralize auth headers, logging, and error handling
✅ Exponential backoff (100ms, 200ms, 400ms...) prevents hammering a failing server
✅ HTTP/2 multiplexing allows multiple parallel requests on one connection automatically
❌ Don't use WebSockets for simple request-response — fetch() is simpler and sufficient
❌ WebSocket connections have no CORS restrictions — secure your server endpoint properly
❌ Don't concatenate URL parameters as strings — use URLSearchParams for proper encoding
❌ Always handle WebSocket reconnection — connections drop and need to be re-established
""",
  quiz: [
    Quiz(question: 'When should you use WebSockets instead of fetch()?', options: [
      QuizOption(text: 'When you need real-time bidirectional communication — both client and server send messages at any time (chat, games, live dashboards)', correct: true),
      QuizOption(text: 'When you need to fetch large files — WebSockets are faster than HTTP for downloads', correct: false),
      QuizOption(text: 'For any API that returns JSON — WebSockets are always more efficient', correct: false),
      QuizOption(text: 'When you need to make more than 6 simultaneous requests', correct: false),
    ]),
    Quiz(question: 'What is the key difference between WebSockets and Server-Sent Events?', options: [
      QuizOption(text: 'WebSockets are bidirectional; SSE is one-way (server to client only) — SSE is simpler for live feeds where the client only listens', correct: true),
      QuizOption(text: 'WebSockets use UDP; SSE uses TCP — WebSockets are faster but less reliable', correct: false),
      QuizOption(text: 'SSE supports binary data; WebSockets only support text', correct: false),
      QuizOption(text: 'WebSockets work only in Node.js; SSE only works in the browser', correct: false),
    ]),
    Quiz(question: 'Why should you use URLSearchParams instead of string concatenation for URL building?', options: [
      QuizOption(text: 'URLSearchParams properly encodes special characters and handles edge cases — concatenation breaks with spaces, &, =, and other special chars', correct: true),
      QuizOption(text: 'URLSearchParams is faster because it uses a compiled native implementation', correct: false),
      QuizOption(text: 'String concatenation is not valid for URLs in modern browsers', correct: false),
      QuizOption(text: 'URLSearchParams automatically validates that the URL is reachable before building it', correct: false),
    ]),
  ],
);
