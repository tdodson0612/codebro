import '../../models/lesson.dart';
import '../../models/quiz.dart';

final jsLesson36 = Lesson(
  language: 'JavaScript',
  title: 'Web Workers',
  content: """
🎯 METAPHOR:
The main JavaScript thread is the head chef — they handle
everything the customer sees: taking orders, plating dishes,
managing the front of house. You absolutely cannot have the
head chef disappear into the back for 30 seconds to crunch
numbers — the whole restaurant stops. Web Workers are the
sous chefs in the back kitchen: they work independently
on heavy tasks (chopping a thousand vegetables, calculating
complex sauces) and communicate with the head chef through
a window (message passing). The head chef stays responsive
to customers while the sous chef works. They can't share
the same workspace directly — everything moves through
the window.

📖 EXPLANATION:
Web Workers run JavaScript in a separate thread, enabling
true parallelism without blocking the main (UI) thread.

─────────────────────────────────────
THREE TYPES OF WORKERS:
─────────────────────────────────────
  Worker            → general purpose, not shared
  SharedWorker      → shared between multiple tabs/windows
  ServiceWorker     → intercepts network requests, offline

─────────────────────────────────────
CREATING A DEDICATED WORKER:
─────────────────────────────────────
  // main.js:
  const worker = new Worker('./worker.js');

  // Send message TO worker:
  worker.postMessage({ type: 'compute', data: [1,2,3] });

  // Receive message FROM worker:
  worker.onmessage = (event) => {
      console.log('Result:', event.data);
  };

  // Handle worker errors:
  worker.onerror = (error) => {
      console.error('Worker error:', error.message);
  };

  // Terminate the worker:
  worker.terminate();

  // worker.js:
  self.onmessage = (event) => {
      const { type, data } = event.data;
      if (type === 'compute') {
          const result = heavyComputation(data);
          self.postMessage({ type: 'result', data: result });
      }
  };

─────────────────────────────────────
WHAT WORKERS CAN ACCESS:
─────────────────────────────────────
  ✅ All ES6+ JavaScript features
  ✅ fetch() — HTTP requests
  ✅ WebSockets
  ✅ IndexedDB
  ✅ Crypto API (SubtleCrypto)
  ✅ Performance API
  ✅ setTimeout, setInterval, clearTimeout
  ✅ FileReader
  ✅ XMLHttpRequest
  ✅ SharedArrayBuffer (with COOP/COEP headers)
  ✅ Importing scripts: importScripts('./lib.js')
  ✅ ES Modules: new Worker('./w.js', { type: 'module' })

  ❌ DOM (document, window)
  ❌ localStorage/sessionStorage (IndexedDB ok)
  ❌ alert(), confirm()
  ❌ parent frame's scope

─────────────────────────────────────
TRANSFERABLE OBJECTS — zero copy:
─────────────────────────────────────
  // Normally postMessage COPIES data (structured clone):
  worker.postMessage(largeArray);          // COPIES — slow

  // Transferable: TRANSFERS ownership — no copy, instant:
  worker.postMessage(buffer, [buffer]);    // TRANSFERS — fast
  // After transfer, buffer is neutered (unusable in sender)!

  Transferable types:
  → ArrayBuffer
  → MessagePort
  → ReadableStream, WritableStream, TransformStream
  → ImageBitmap
  → OffscreenCanvas

─────────────────────────────────────
SharedArrayBuffer — shared memory:
─────────────────────────────────────
  // Share memory between main thread and workers:
  const shared = new SharedArrayBuffer(1024);
  const arr    = new Int32Array(shared);

  // Pass to worker:
  worker.postMessage({ shared });

  // In worker:
  const arr = new Int32Array(event.data.shared);
  // Both share the SAME memory — use Atomics for sync!

  Atomics.load(arr, 0)          // thread-safe read
  Atomics.store(arr, 0, 42)     // thread-safe write
  Atomics.add(arr, 0, 1)        // thread-safe increment
  Atomics.compareExchange(arr, 0, expected, desired)
  Atomics.wait(arr, 0, 0)       // block until value changes
  Atomics.notify(arr, 0, 1)     // wake waiting thread

─────────────────────────────────────
MODULE WORKER (modern):
─────────────────────────────────────
  // worker.js can use ES module imports:
  const worker = new Worker('./worker.js', { type: 'module' });

  // worker.js:
  import { heavyCompute } from './compute.js';
  self.onmessage = (e) => self.postMessage(heavyCompute(e.data));

─────────────────────────────────────
COMLINK — easy worker communication:
─────────────────────────────────────
  // Comlink wraps workers in a Proxy for clean API:
  // main.js:
  const worker = wrap(new Worker('./worker.js'));
  const result = await worker.expensiveCalc(data);

  // worker.js:
  expose({ expensiveCalc: (data) => compute(data) });

─────────────────────────────────────
WHEN TO USE WORKERS:
─────────────────────────────────────
  ✅ Heavy computation: image processing, ML inference
  ✅ Large data parsing: CSV, XML, JSON with 100k+ rows
  ✅ Real-time analysis: audio FFT, physics simulation
  ✅ Compression/decompression: zip, gzip, brotli
  ✅ Crypto: hashing, encryption, key generation
  ✅ Database operations: complex IndexedDB queries
  ❌ Simple operations — overhead isn't worth it
  ❌ Frequent small messages — postMessage overhead adds up

💻 CODE:
// ─── WORKER SIMULATION ────────────────────────────────
// Real workers need separate files. This simulates the
// message-passing pattern with the same API.

class SimulatedWorker {
    #onmessage = null;
    #handler   = null;
    #errhandler = null;

    constructor(workerFn) {
        // The "worker" is a function that runs in simulation
        const self = {
            postMessage: (data) => {
                // worker posts → main receives
                if (this.#onmessage) {
                    setTimeout(() => this.#onmessage({ data }), 0);
                }
            },
            onmessage: null,
        };
        workerFn(self);
        this.#handler = self;
    }

    postMessage(data) {
        // main posts → worker receives
        if (this.#handler.onmessage) {
            setTimeout(() => this.#handler.onmessage({ data }), 0);
        }
    }

    set onmessage(fn) { this.#onmessage = fn; }
    set onerror(fn)   { this.#errhandler = fn; }
    terminate()       { this.#handler = null; this.#onmessage = null; }
}

// ─── COMPUTATION WORKER ───────────────────────────────
console.log("=== Computation Worker ===");

const computeWorker = new SimulatedWorker((self) => {
    self.onmessage = ({ data: { type, payload } }) => {
        let result;
        switch (type) {
            case 'PRIME_COUNT': {
                // Count primes up to N
                function isPrime(n) {
                    if (n < 2) return false;
                    for (let i = 2; i <= Math.sqrt(n); i++) if (n % i === 0) return false;
                    return true;
                }
                let count = 0;
                for (let i = 2; i <= payload; i++) if (isPrime(i)) count++;
                result = { type: 'PRIME_COUNT_RESULT', count, upTo: payload };
                break;
            }
            case 'FIBONACCI': {
                function fib(n) {
                    const dp = [0, 1];
                    for (let i = 2; i <= n; i++) dp[i] = dp[i-1] + dp[i-2];
                    return dp[n];
                }
                result = { type: 'FIBONACCI_RESULT', n: payload, value: fib(payload) };
                break;
            }
            case 'SORT': {
                const sorted = [...payload].sort((a, b) => a - b);
                result = { type: 'SORT_RESULT', sorted };
                break;
            }
        }
        self.postMessage(result);
    };
});

// Send tasks to the worker:
const tasks = [
    { type: 'PRIME_COUNT', payload: 10000 },
    { type: 'FIBONACCI',   payload: 50 },
    { type: 'SORT',        payload: Array.from({ length: 10 }, () => Math.floor(Math.random() * 100)) },
];

computeWorker.onmessage = ({ data }) => {
    switch (data.type) {
        case 'PRIME_COUNT_RESULT':
            console.log(\`  Primes up to\${
data.upTo}:\${
data.count}\`);
            break;
        case 'FIBONACCI_RESULT':
            console.log(\`  fib(\${
data.n}) =\${
data.value}\`);
            break;
        case 'SORT_RESULT':
            console.log(\`  Sorted: [\${
data.sorted}]\`);
            break;
    }
};

tasks.forEach(task => computeWorker.postMessage(task));

// ─── IMAGE PROCESSING WORKER ──────────────────────────
setTimeout(() => {
    console.log("\n=== Image Processing Worker ===");

    const imageWorker = new SimulatedWorker((self) => {
        // Simulated pixel processing operations
        function grayscale(pixels) {
            const result = new Array(pixels.length);
            for (let i = 0; i < pixels.length; i += 4) {
                const gray = Math.round(0.299 * pixels[i] + 0.587 * pixels[i+1] + 0.114 * pixels[i+2]);
                result[i] = result[i+1] = result[i+2] = gray;
                result[i+3] = pixels[i+3];
            }
            return result;
        }

        function brighten(pixels, amount) {
            return pixels.map((v, i) => (i + 1) % 4 === 0 ? v : Math.min(255, v + amount));
        }

        function invert(pixels) {
            return pixels.map((v, i) => (i + 1) % 4 === 0 ? v : 255 - v);
        }

        self.onmessage = ({ data: { operation, pixels, params } }) => {
            let result;
            const start = Date.now();

            switch (operation) {
                case 'grayscale': result = grayscale(pixels); break;
                case 'brighten':  result = brighten(pixels, params.amount); break;
                case 'invert':    result = invert(pixels); break;
            }

            self.postMessage({
                operation,
                pixels: result,
                processingTime: Date.now() - start
            });
        };
    });

    // Simulate a small image (4x4 = 16 pixels, 64 RGBA values):
    const testPixels = Array.from({ length: 64 }, (_, i) => {
        const ch = i % 4;
        const px = Math.floor(i / 4);
        if (ch === 3) return 255;  // alpha
        return (px * 17) % 256;   // varied values
    });

    imageWorker.onmessage = ({ data }) => {
        console.log(\` \${
data.operation}: first 8 values = [\${
data.pixels.slice(0, 8).join(', ')}]\`);
        console.log(\`  Processing time:\${
data.processingTime}ms\`);
    };

    ['grayscale', 'invert'].forEach(op => {
        imageWorker.postMessage({
            operation: op,
            pixels: [...testPixels],
            params: { amount: 30 }
        });
    });

    imageWorker.terminate();
}, 100);

// ─── WORKER POOL PATTERN ──────────────────────────────
setTimeout(() => {
    console.log("\n=== Worker Pool Pattern ===");

    class WorkerPool {
        #workers = [];
        #queue   = [];
        #busy    = new Set();

        constructor(size, workerFn) {
            for (let i = 0; i < size; i++) {
                const worker = new SimulatedWorker(workerFn);
                const id     = i;
                worker.onmessage = ({ data }) => {
                    const resolve = this.#busy.get(id);
                    this.#busy.delete(id);
                    if (resolve) resolve(data);
                    this.#processQueue();
                };
                this.#workers.push({ worker, id, busy: false });
            }
        }

        #processQueue() {
            if (this.#queue.length === 0) return;
            const idle = this.#workers.find(w => !this.#busy.has(w.id));
            if (!idle) return;

            const { task, resolve } = this.#queue.shift();
            this.#busy.set(idle.id, resolve);
            idle.worker.postMessage(task);
        }

        run(task) {
            return new Promise(resolve => {
                this.#queue.push({ task, resolve });
                this.#processQueue();
            });
        }
    }

    // Create a pool of "workers":
    const pool = new WorkerPool(3, (self) => {
        self.onmessage = ({ data: { n } }) => {
            // Simulate heavy work:
            let result = 0;
            for (let i = 0; i <= n; i++) result += i;
            self.postMessage({ n, result });
        };
    });

    // Process 6 tasks with pool of 3:
    const tasks = [100, 200, 300, 400, 500, 600];
    Promise.all(tasks.map(n => pool.run({ n }))).then(results => {
        console.log("  All pool results:");
        results.forEach(r => console.log(\`    sum(0..\${
r.n}) =\${
r.result}\`));
    });

}, 200);

// ─── REFERENCE ────────────────────────────────────────
setTimeout(() => {
    console.log("\n=== Web Worker Quick Reference ===");
    const ref = [
        ["Create worker",    "const w = new Worker('./worker.js')"],
        ["Module worker",    "new Worker('./w.js', { type: 'module' })"],
        ["Send to worker",   "worker.postMessage(data)"],
        ["Receive in main",  "worker.onmessage = ({data}) => ..."],
        ["Send from worker", "self.postMessage(result)"],
        ["Receive in worker","self.onmessage = ({data}) => ..."],
        ["Transfer buffer",  "worker.postMessage(buf, [buf])"],
        ["Terminate",        "worker.terminate()"],
        ["Shared memory",    "new SharedArrayBuffer(bytes)"],
        ["Atomic ops",       "Atomics.add/load/store/wait/notify"],
    ];
    ref.forEach(([desc, code]) => console.log(\` \${
desc.padEnd(18)}:\${
code}\`));
}, 300);

📝 KEY POINTS:
✅ Web Workers run in a separate thread — heavy computation doesn't block the UI
✅ Communication is via postMessage() and onmessage — no shared JS scope
✅ Workers can access fetch, WebSockets, IndexedDB, crypto, but NOT the DOM
✅ postMessage() copies data using structured clone — use Transferable for zero-copy
✅ Transferring an ArrayBuffer neusters it in the sender — it becomes unusable
✅ SharedArrayBuffer enables true shared memory — use Atomics for thread-safe access
✅ Module workers (type:'module') support ES module imports
✅ Worker pools improve throughput when you have many tasks and fixed CPU cores
✅ Comlink library makes workers feel like regular async function calls
❌ Don't use workers for trivial tasks — postMessage has overhead
❌ Workers have no access to DOM, localStorage, window, or alert()
❌ After transferring an ArrayBuffer, it cannot be used in the original thread
❌ SharedArrayBuffer requires Cross-Origin-Opener-Policy and Cross-Origin-Embedder-Policy headers
""",
  quiz: [
    Quiz(question: 'What is the main advantage of using a Web Worker?', options: [
      QuizOption(text: 'Heavy computation runs in a separate thread — the UI stays responsive and doesn\'t freeze', correct: true),
      QuizOption(text: 'Workers share memory directly with the main thread for faster data access', correct: false),
      QuizOption(text: 'Workers have access to the DOM so they can update the UI in parallel', correct: false),
      QuizOption(text: 'Workers bypass the single-threaded event loop and run truly asynchronously', correct: false),
    ]),
    Quiz(question: 'What makes Transferable objects different from normal postMessage data?', options: [
      QuizOption(text: 'Transferables transfer ownership (zero-copy) to the receiver — the sender can no longer use them', correct: true),
      QuizOption(text: 'Transferables are automatically shared between threads with no copying or transfer', correct: false),
      QuizOption(text: 'Transferables are encrypted during transfer for security', correct: false),
      QuizOption(text: 'Transferables allow circular references that structured clone cannot handle', correct: false),
    ]),
    Quiz(question: 'Which of these APIs can Web Workers NOT access?', options: [
      QuizOption(text: 'The DOM (document, window) — workers are isolated from the UI thread\'s scope', correct: true),
      QuizOption(text: 'fetch() — network requests are not allowed in workers', correct: false),
      QuizOption(text: 'IndexedDB — database access requires the main thread', correct: false),
      QuizOption(text: 'setTimeout — timers are only available on the main thread', correct: false),
    ]),
  ],
);
