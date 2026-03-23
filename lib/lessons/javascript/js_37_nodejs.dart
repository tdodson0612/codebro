import '../../models/lesson.dart';
import '../../models/quiz.dart';

final jsLesson37 = Lesson(
  language: 'JavaScript',
  title: 'Node.js Fundamentals',
  content: """
🎯 METAPHOR:
Node.js is JavaScript that escaped the browser and
learned to talk to the whole computer. Before Node.js
(2009), JavaScript was trapped inside browsers like a
pet in a cage — it could play with the DOM but couldn't
touch files, databases, or network ports. Ryan Dahl
took Chrome's V8 engine, plugged it into C++ bindings
for file systems, networking, and OS calls, and said
"now your JavaScript can run a web server, read files,
and do EVERYTHING a server-side language can do."
Node.js is not a language — it's a runtime environment
that lets JavaScript run outside browsers.

📖 EXPLANATION:
Node.js is a JavaScript runtime built on Chrome's V8
engine. It uses an event-driven, non-blocking I/O model.

─────────────────────────────────────
WHAT MAKES NODE DIFFERENT:
─────────────────────────────────────
  Browser JS:
  → Access to DOM, window, document
  → Sandboxed — no file system, no raw sockets
  → Multiple tabs = multiple instances
  → APIs: fetch, localStorage, requestAnimationFrame

  Node.js:
  → No DOM, no window
  → Access to: file system, network, OS, databases
  → Single process with event loop
  → APIs: fs, path, http, crypto, process, child_process

─────────────────────────────────────
GLOBAL OBJECTS IN NODE:
─────────────────────────────────────
  process          → info about the Node process
  __filename       → current file path (CommonJS)
  __dirname        → current directory (CommonJS)
  require()        → import CommonJS module (CJS)
  module.exports   → export CommonJS module (CJS)
  Buffer           → raw binary data (Node-specific)
  global           → global scope (like window in browser)

  process.argv     → command-line arguments
  process.env      → environment variables
  process.cwd()    → current working directory
  process.exit(0)  → exit with code 0 (success)
  process.exit(1)  → exit with code 1 (failure)
  process.pid      → process ID
  process.version  → Node.js version
  process.platform → 'linux', 'darwin', 'win32'
  process.memoryUsage()  → heap/rss/external bytes
  process.hrtime()       → high-res time (benchmarking)

─────────────────────────────────────
EVENTS MODULE — EventEmitter:
─────────────────────────────────────
  const { EventEmitter } = require('events');

  class Server extends EventEmitter {
      start() { this.emit('listening', { port: 8080 }); }
  }

  const server = new Server();
  server.on('listening', ({ port }) => console.log(\`Listening on \${port}\`));
  server.start();

─────────────────────────────────────
MODULES — CommonJS vs ESM:
─────────────────────────────────────
  CommonJS (default in Node):
  const fs = require('fs');
  module.exports = { myFunction };

  ESM (modern):
  import fs from 'fs';
  export function myFunction() {}

  Enable ESM:
  → package.json: { "type": "module" }
  → Use .mjs extension
  → --experimental-vm-modules flag

─────────────────────────────────────
THE NODE.JS EVENT LOOP (extra phases):
─────────────────────────────────────
  Node.js adds phases on top of the browser event loop:

  1. Timers:          setTimeout / setInterval callbacks
  2. Pending callbacks: I/O errors, some sys callbacks
  3. Idle/Prepare:    internal
  4. Poll:            wait for I/O, execute callbacks
  5. Check:           setImmediate() callbacks
  6. Close:           close events (socket.close)

  Special queues (run before each phase):
  → process.nextTick() — highest priority, before any I/O
  → Promise microtasks — after nextTick

  Order: nextTick > Promise microtasks > setImmediate > setTimeout

─────────────────────────────────────
BUFFERS — raw binary data:
─────────────────────────────────────
  Buffer.from('hello')              // from string (UTF-8)
  Buffer.from('hello', 'base64')   // from base64 string
  Buffer.from([0x48, 0x65, 0x6C]) // from byte array
  Buffer.alloc(10)                  // 10 zero bytes
  Buffer.alloc(10, 0xff)           // 10 bytes, all 0xff

  buf.toString()         // to UTF-8 string
  buf.toString('base64') // to base64 string
  buf.toString('hex')    // to hex string
  buf.length             // byte count
  buf[0]                 // first byte

─────────────────────────────────────
STREAMS — for large data:
─────────────────────────────────────
  Four types:
  Readable  → source of data (fs.createReadStream)
  Writable  → destination (fs.createWriteStream)
  Duplex    → both readable and writable (net.Socket)
  Transform → modify data as it passes through (zlib)

  // Pipe (chain streams):
  fs.createReadStream('input.txt')
    .pipe(zlib.createGzip())
    .pipe(fs.createWriteStream('output.gz'));

  // Modern: for await of (async iteration):
  const readable = fs.createReadStream('./file.txt', { encoding: 'utf8' });
  for await (const chunk of readable) {
      process.stdout.write(chunk);
  }

─────────────────────────────────────
ERROR HANDLING IN NODE:
─────────────────────────────────────
  process.on('uncaughtException', (err) => {
      console.error('Uncaught:', err);
      process.exit(1);
  });

  process.on('unhandledRejection', (reason, promise) => {
      console.error('Unhandled rejection:', reason);
      process.exit(1);
  });

  process.on('SIGTERM', () => {
      // Graceful shutdown
      server.close(() => process.exit(0));
  });

💻 CODE:
// ─── PROCESS INFO ─────────────────────────────────────
console.log("=== process object ===");
console.log("  version:  ", process.version);
console.log("  platform: ", process.platform);
console.log("  arch:     ", process.arch);
console.log("  pid:      ", process.pid);
console.log("  cwd:      ", process.cwd());
console.log("  argv:     ", process.argv.slice(0, 3));

// Environment variables:
process.env.MY_VAR = "hello";
console.log("  MY_VAR:   ", process.env.MY_VAR);

// Memory usage:
const mem = process.memoryUsage();
console.log("  heapUsed: ", Math.round(mem.heapUsed / 1024 / 1024) + "MB");
console.log("  heapTotal:", Math.round(mem.heapTotal / 1024 / 1024) + "MB");
console.log("  rss:      ", Math.round(mem.rss / 1024 / 1024) + "MB");

// ─── EVENTEMITTER ─────────────────────────────────────
console.log("\n=== EventEmitter ===");

const { EventEmitter } = require('events');

class HttpServer extends EventEmitter {
    #port;
    #running = false;

    constructor(port) {
        super();
        this.#port = port;
    }

    start() {
        if (this.#running) return this.emit('error', new Error("Already running"));
        this.#running = true;
        this.emit('listening', { port: this.#port, host: 'localhost' });
        return this;
    }

    stop() {
        if (!this.#running) return;
        this.#running = false;
        this.emit('close');
        return this;
    }

    simulateRequest(method, path) {
        if (!this.#running) return;
        this.emit('request', {
            method, path,
            timestamp: new Date().toISOString()
        });
    }
}

const server = new HttpServer(8080);

server.on('listening', ({ port, host }) => {
    console.log(\`  ✅ Server listening on \${host}:\${port}\`);
});

server.on('request', ({ method, path, timestamp }) => {
    console.log(\`  📨 \${method} \${path} at \${timestamp}\`);
});

server.on('close', () => {
    console.log("  ❌ Server stopped");
});

server.on('error', (err) => {
    console.log(\`  ⚠️  Error: \${err.message}\`);
});

server.start();
server.simulateRequest('GET', '/api/users');
server.simulateRequest('POST', '/api/users');
server.simulateRequest('GET', '/health');
server.stop();
server.start();  // error — already... wait, stopped. Start again.

// ─── BUFFERS ──────────────────────────────────────────
console.log("\n=== Buffer ===");

const buf1 = Buffer.from('Hello, Node.js!');
const buf2 = Buffer.from([0x48, 0x65, 0x6C, 0x6C, 0x6F]);
const buf3 = Buffer.alloc(8, 0);

console.log("  buf1.toString():  ", buf1.toString());
console.log("  buf1.toString('hex'):", buf1.toString('hex').slice(0, 20) + "...");
console.log("  buf1.toString('base64'):", buf1.toString('base64'));
console.log("  buf1.length:     ", buf1.length);
console.log("  buf1[0]:         ", buf1[0], "(H =", 0x48, ")");
console.log("  buf2.toString(): ", buf2.toString());
console.log("  buf3:            ", buf3);

// Buffer manipulation:
const concat = Buffer.concat([buf2, Buffer.from(', World!')]);
console.log("  concat:         ", concat.toString());

// ─── NODE EVENT LOOP ORDER ────────────────────────────
console.log("\n=== Node.js Event Loop Order ===");

setTimeout(() => console.log("  4. setTimeout"), 0);
setImmediate(() => console.log("  3. setImmediate"));
process.nextTick(() => console.log("  1. process.nextTick"));
Promise.resolve().then(() => console.log("  2. Promise microtask"));
console.log("  0. Synchronous");

// ─── STREAMS SIMULATION ───────────────────────────────
setTimeout(() => {
    console.log("\n=== Streams Simulation ===");

    const { Readable, Transform, Writable } = require('stream');

    // Readable source:
    const source = new Readable({
        read() {}
    });

    // Transform (uppercase):
    const upper = new Transform({
        transform(chunk, encoding, callback) {
            this.push(chunk.toString().toUpperCase());
            callback();
        }
    });

    // Writable sink:
    const chunks = [];
    const sink = new Writable({
        write(chunk, encoding, callback) {
            chunks.push(chunk.toString());
            callback();
        }
    });

    sink.on('finish', () => {
        console.log("  Processed chunks:", chunks);
    });

    // Connect the pipeline:
    source.pipe(upper).pipe(sink);

    // Push data:
    ['hello ', 'world ', 'from ', 'streams!'].forEach(s => {
        source.push(s);
    });
    source.push(null);  // end the stream
}, 100);

// ─── PROCESS.NEXTTICK ─────────────────────────────────
setTimeout(() => {
    console.log("\n=== process.nextTick ===");
    console.log("  nextTick runs before I/O callbacks and setImmediate");
    console.log("  Use sparingly — can starve I/O if overused");

    // Common pattern: make synchronous APIs async-looking
    function asyncSetProperty(obj, key, value, callback) {
        obj[key] = value;
        process.nextTick(callback, null, value);
    }

    const target = {};
    asyncSetProperty(target, 'name', 'Alice', (err, val) => {
        if (err) return console.error(err);
        console.log(\`  Property set to: \${val}\`);
        console.log(\`  Object: \${JSON.stringify(target)}\`);
    });
}, 200);

📝 KEY POINTS:
✅ Node.js is a JavaScript runtime — not a framework or language — built on V8
✅ process object provides: env vars, argv, cwd, pid, version, platform, exit()
✅ EventEmitter is the backbone of Node.js — streams, servers, and more extend it
✅ Buffer handles binary data — use Buffer.from/alloc and toString() for conversion
✅ process.nextTick() runs before I/O callbacks and before setImmediate — highest priority
✅ Order: nextTick > Promise microtasks > I/O callbacks > setImmediate > setTimeout
✅ Streams handle large data efficiently — pipe chains transform data chunk by chunk
✅ process.env provides environment variables — the standard for Node.js configuration
✅ CommonJS (require/module.exports) is default in Node; ESM works with "type":"module"
❌ Don't use process.nextTick() in loops — it can starve the I/O phase
❌ Streams are not auto-paused — call read() or use pipe() to consume them
❌ Buffer.concat() creates a new Buffer — don't use it in tight loops; use a list and concat once
❌ process.exit() exits immediately — no callbacks run after it, no graceful shutdown
""",
  quiz: [
    Quiz(question: 'What is Node.js?', options: [
      QuizOption(text: 'A JavaScript runtime built on Chrome\'s V8 engine that runs JavaScript outside the browser', correct: true),
      QuizOption(text: 'A JavaScript framework for building web applications', correct: false),
      QuizOption(text: 'A new programming language that extends JavaScript for servers', correct: false),
      QuizOption(text: 'A package manager for JavaScript projects', correct: false),
    ]),
    Quiz(question: 'What is the execution priority order in Node.js?', options: [
      QuizOption(text: 'process.nextTick → Promise microtasks → setImmediate → setTimeout', correct: true),
      QuizOption(text: 'setTimeout → setImmediate → Promise microtasks → process.nextTick', correct: false),
      QuizOption(text: 'Promise microtasks → process.nextTick → setTimeout → setImmediate', correct: false),
      QuizOption(text: 'All have the same priority — Node.js uses a fair queue', correct: false),
    ]),
    Quiz(question: 'What is a Node.js Buffer used for?', options: [
      QuizOption(text: 'Handling raw binary data — like file bytes, network packets, and crypto operations', correct: true),
      QuizOption(text: 'Buffering console.log output to reduce I/O calls', correct: false),
      QuizOption(text: 'A performance optimization for storing frequently accessed strings', correct: false),
      QuizOption(text: 'Queuing incoming HTTP requests before they reach the handler', correct: false),
    ]),
  ],
);
