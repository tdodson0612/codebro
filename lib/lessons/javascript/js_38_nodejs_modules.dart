import '../../models/lesson.dart';
import '../../models/quiz.dart';

final jsLesson38 = Lesson(
  language: 'JavaScript',
  title: 'Node.js Built-in Modules: fs, path, http',
  content: """
🎯 METAPHOR:
Node.js built-in modules are like the tools that came
in the box when you bought the computer. The fs module
is the filing cabinet — read, write, create, delete
files and folders. The path module is the GPS for file
locations — it knows how to combine directory segments,
find extensions, and translate between OS formats (Linux
forward slashes vs Windows backslashes). The http module
is the telephone — it lets your Node program talk to
the world, receiving incoming calls (HTTP requests) and
making outgoing ones. These three modules cover the core
of what most server-side programs need to do.

📖 EXPLANATION:
Node.js includes many built-in modules. The three most
essential for server development are fs, path, and http.

─────────────────────────────────────
fs MODULE — File System:
─────────────────────────────────────
  const fs = require('fs');                    // callbacks
  const fs = require('fs/promises');           // Promises ✅
  import fs from 'fs/promises';                // ESM

  // READ:
  fs.readFile('file.txt', 'utf8')              // → string
  fs.readFile('file.txt')                      // → Buffer
  fs.readFileSync('file.txt', 'utf8')          // sync version

  // WRITE:
  fs.writeFile('file.txt', 'content')         // overwrite
  fs.appendFile('file.txt', 'more\n')         // append
  fs.writeFile('file.txt', data, { flag: 'a' }) // append

  // DIRECTORY:
  fs.mkdir('folder', { recursive: true })
  fs.readdir('.')                              // → string[]
  fs.rmdir('folder')
  fs.rm('folder', { recursive: true })        // Node 14+

  // FILE INFO:
  fs.stat('file.txt')                         // → Stats object
  stats.isFile()
  stats.isDirectory()
  stats.size                                  // bytes
  stats.mtime                                 // last modified Date
  fs.exists('file.txt')                       // deprecated
  fs.access('file.txt', fs.constants.R_OK)    // check access

  // COPY/RENAME/DELETE:
  fs.copyFile('src.txt', 'dst.txt')
  fs.rename('old.txt', 'new.txt')
  fs.unlink('file.txt')                       // delete file

  // WATCH:
  fs.watch('./src', { recursive: true }, (event, filename) => {
      console.log(event, filename);
  });

─────────────────────────────────────
path MODULE — File Paths:
─────────────────────────────────────
  const path = require('path');

  path.join('/usr', 'local', 'bin')       // '/usr/local/bin'
  path.resolve('./config.json')           // absolute path
  path.basename('/usr/local/bin/node')    // 'node'
  path.basename('app.min.js', '.js')      // 'app.min'
  path.dirname('/usr/local/bin/node')     // '/usr/local/bin'
  path.extname('index.html')             // '.html'
  path.parse('/usr/local/bin/node.js')
  // { root, dir, base, ext, name }
  path.format({ dir: '/home', name: 'app', ext: '.js' })
  // '/home/app.js'

  path.sep                               // '/' or '\\\\'
  path.delimiter                         // ':' or ';'
  path.isAbsolute('/usr/local')          // true
  path.relative('/usr', '/usr/local/bin') // 'local/bin'

─────────────────────────────────────
http MODULE — HTTP Server and Client:
─────────────────────────────────────
  const http = require('http');

  // Create server:
  const server = http.createServer((req, res) => {
      res.writeHead(200, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify({ message: 'Hello!' }));
  });
  server.listen(3000, () => console.log('Listening'));

  // Request object (req):
  req.method         // 'GET', 'POST', etc.
  req.url            // '/api/users?page=1'
  req.headers        // { 'content-type': 'application/json' }

  // Response object (res):
  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/html');
  res.writeHead(200, headers);     // set status + headers at once
  res.write('partial content');    // stream body
  res.end('final content');        // finish response

  // HTTP client (use fetch instead in Node 18+):
  const req = http.get('http://example.com', (res) => {
      let data = '';
      res.on('data', chunk => data += chunk);
      res.on('end',  () => console.log(data));
  });

─────────────────────────────────────
url MODULE — URL parsing:
─────────────────────────────────────
  const { URL } = require('url');

  const url = new URL('https://example.com/path?a=1&b=2');
  url.hostname     // 'example.com'
  url.pathname     // '/path'
  url.search       // '?a=1&b=2'
  url.searchParams.get('a')   // '1'
  url.searchParams.getAll('a') // ['1']
  url.searchParams.set('c', '3')
  url.toString()   // full URL string

─────────────────────────────────────
POPULAR NODE PATTERNS:
─────────────────────────────────────
  // Read JSON config:
  const config = JSON.parse(await fs.readFile('./config.json', 'utf8'));

  // Write JSON:
  await fs.writeFile('./data.json', JSON.stringify(data, null, 2));

  // Ensure directory exists:
  await fs.mkdir('./logs', { recursive: true });

  // Walk directory recursively:
  async function* walk(dir) {
      for (const entry of await fs.readdir(dir, { withFileTypes: true })) {
          const full = path.join(dir, entry.name);
          if (entry.isDirectory()) yield* walk(full);
          else yield full;
      }
  }

💻 CODE:
const path = require('path');
const { EventEmitter } = require('events');

// ─── PATH MODULE ──────────────────────────────────────
console.log("=== path module ===");

// Join:
console.log("  join:", path.join('/usr', 'local', 'bin', 'node'));
console.log("  join:", path.join('src', 'utils', 'math.js'));

// Parse and components:
const filePath = '/home/terry/projects/app/src/index.js';
const parsed = path.parse(filePath);
console.log("  parse:", parsed);
console.log("  basename:", path.basename(filePath));
console.log("  dirname: ", path.dirname(filePath));
console.log("  extname: ", path.extname(filePath));
console.log("  name:    ", path.basename(filePath, path.extname(filePath)));

// Format:
console.log("  format:", path.format({
    dir: '/home/terry',
    name: 'config',
    ext: '.json'
}));

// Relative:
const from = '/home/terry/projects/app';
const to   = '/home/terry/projects/lib/utils.js';
console.log("  relative:", path.relative(from, to));

// Platform info:
console.log("  sep:      ", JSON.stringify(path.sep));
console.log("  delimiter:", JSON.stringify(path.delimiter));
console.log("  isAbsolute('/usr'):", path.isAbsolute('/usr'));
console.log("  isAbsolute('src'):", path.isAbsolute('src'));

// ─── fs MODULE SIMULATION ─────────────────────────────
console.log("\n=== fs module (simulated) ===");

// Simulate fs/promises API:
const virtualFS = new Map();

const fs = {
    async writeFile(path, data) {
        virtualFS.set(path, typeof data === 'string' ? data : JSON.stringify(data, null, 2));
        console.log(\`  writeFile: \${path} (\${virtualFS.get(path).length} bytes)\`);
    },
    async readFile(path, encoding) {
        if (!virtualFS.has(path)) throw new Error(\`ENOENT: no such file: \${path}\`);
        const data = virtualFS.get(path);
        return encoding === 'utf8' ? data : Buffer.from(data);
    },
    async appendFile(path, data) {
        const existing = virtualFS.get(path) || '';
        virtualFS.set(path, existing + data);
    },
    async unlink(path) {
        if (!virtualFS.has(path)) throw new Error(\`ENOENT: \${path}\`);
        virtualFS.delete(path);
    },
    async readdir(dir) {
        return [...virtualFS.keys()]
            .filter(k => k.startsWith(dir + '/'))
            .map(k => k.slice(dir.length + 1).split('/')[0]);
    },
    async stat(path) {
        if (!virtualFS.has(path)) throw new Error(\`ENOENT: \${path}\`);
        const content = virtualFS.get(path);
        return {
            size: content.length,
            mtime: new Date(),
            isFile:      () => true,
            isDirectory: () => false,
        };
    },
    async mkdir(path, opts) {
        console.log(\`  mkdir: \${path} (recursive=\${opts?.recursive})\`);
    },
    async copyFile(src, dest) {
        if (!virtualFS.has(src)) throw new Error(\`ENOENT: \${src}\`);
        virtualFS.set(dest, virtualFS.get(src));
        console.log(\`  copyFile: \${src} → \${dest}\`);
    },
};

async function demoFS() {
    // Write files:
    await fs.writeFile('/tmp/hello.txt', 'Hello, World!\n');
    await fs.writeFile('/tmp/data.json', JSON.stringify({
        users: [
            { id: 1, name: 'Alice', email: 'alice@example.com' },
            { id: 2, name: 'Bob',   email: 'bob@example.com' },
        ],
        version: '1.0',
    }, null, 2));

    // Read files:
    const text = await fs.readFile('/tmp/hello.txt', 'utf8');
    console.log("  readFile text:", text.trim());

    const json = JSON.parse(await fs.readFile('/tmp/data.json', 'utf8'));
    console.log("  JSON users:", json.users.map(u => u.name));

    // Append:
    await fs.appendFile('/tmp/hello.txt', 'Appended line\n');
    const appended = await fs.readFile('/tmp/hello.txt', 'utf8');
    console.log("  After append:", appended.trim().split('\n'));

    // Stat:
    const stats = await fs.stat('/tmp/data.json');
    console.log("  stat size:", stats.size, "bytes");
    console.log("  isFile:", stats.isFile());

    // Copy:
    await fs.copyFile('/tmp/data.json', '/tmp/data-backup.json');

    // Delete:
    await fs.unlink('/tmp/hello.txt');
    try {
        await fs.readFile('/tmp/hello.txt', 'utf8');
    } catch (e) {
        console.log("  After unlink:", e.message);
    }

    // Mkdir:
    await fs.mkdir('/tmp/logs', { recursive: true });
}

// ─── HTTP SERVER SIMULATION ───────────────────────────
console.log("\n=== http module (simulated router) ===");

class HttpSimulator extends EventEmitter {
    #routes = new Map();

    route(method, path, handler) {
        this.#routes.set(\`\${method}:\${path}\`, handler);
        return this;
    }

    get(path, handler)    { return this.route('GET', path, handler); }
    post(path, handler)   { return this.route('POST', path, handler); }
    put(path, handler)    { return this.route('PUT', path, handler); }
    delete(path, handler) { return this.route('DELETE', path, handler); }

    async request(method, url, body = null) {
        const parsed = new URL(url, 'http://localhost');
        const key = \`\${method}:\${parsed.pathname}\`;
        const handler = this.#routes.get(key);

        const req = {
            method,
            url: parsed.pathname,
            query: Object.fromEntries(parsed.searchParams),
            body,
            headers: { 'content-type': 'application/json' }
        };

        let statusCode = 200;
        let headers    = {};
        let responseBody;

        const res = {
            statusCode: 200,
            writeHead(code, h) { statusCode = code; headers = { ...headers, ...h }; },
            json(data) { responseBody = JSON.stringify(data); },
            send(data) { responseBody = data; },
            status(code) { statusCode = code; return this; },
        };

        if (handler) {
            await handler(req, res);
        } else {
            statusCode = 404;
            responseBody = JSON.stringify({ error: 'Not Found' });
        }

        console.log(\`  \${method} \${parsed.pathname} → \${statusCode}\`);
        if (responseBody) {
            const display = responseBody.slice(0, 80) + (responseBody.length > 80 ? '...' : '');
            console.log(\`    Response: \${display}\`);
        }
        return { statusCode, body: responseBody };
    }
}

// Build a simple REST API:
const users = new Map([
    [1, { id: 1, name: 'Alice', email: 'alice@example.com' }],
    [2, { id: 2, name: 'Bob',   email: 'bob@example.com' }],
]);
let nextId = 3;

const app = new HttpSimulator();

app.get('/api/users', (req, res) => {
    res.json({ users: [...users.values()], count: users.size });
});

app.get('/api/users/:id', (req, res) => {
    const id = parseInt(req.query.id || req.url.split('/').pop());
    const user = users.get(id);
    if (!user) return res.status(404).json({ error: 'Not found' });
    res.json(user);
});

app.post('/api/users', (req, res) => {
    const user = { id: nextId++, ...req.body };
    users.set(user.id, user);
    res.writeHead(201, {});
    res.json(user);
});

app.delete('/api/users/:id', (req, res) => {
    const id = parseInt(req.url.split('/').pop());
    users.delete(id);
    res.writeHead(204, {});
    res.send('');
});

async function runAPI() {
    await demoFS();

    console.log("\n  API Requests:");
    await app.request('GET', 'http://localhost/api/users');
    await app.request('GET', 'http://localhost/api/users/1');
    await app.request('POST', 'http://localhost/api/users', { name: 'Carol', email: 'carol@example.com' });
    await app.request('GET', 'http://localhost/api/users');
    await app.request('DELETE', 'http://localhost/api/users/2');
    await app.request('GET', 'http://localhost/api/users/99');
}

runAPI().catch(console.error);

📝 KEY POINTS:
✅ Prefer fs/promises (async) over the callback-based fs module
✅ path.join() creates OS-appropriate paths — don't concatenate paths with '/'
✅ path.resolve() converts relative paths to absolute ones based on cwd
✅ path.parse() gives all path components (root, dir, base, name, ext)
✅ fs.mkdir({ recursive: true }) creates parent directories as needed
✅ fs.rm({ recursive: true }) removes directories with content (Node 14+)
✅ Watch files/directories with fs.watch() for hot-reloading patterns
✅ URL class (built-in) parses URLs and their components cleanly
✅ In Node 18+ use the built-in fetch() instead of http.get() for HTTP requests
❌ Don't concatenate paths with string literals — use path.join() for cross-platform compatibility
❌ fs.readFileSync() blocks the event loop — use async versions in production
❌ Don't use deprecated fs.exists() — use fs.access() or try/catch readFile
❌ http.createServer() is low-level — use Express, Fastify, or Hono for real apps
""",
  quiz: [
    Quiz(question: 'Why should you use path.join() instead of string concatenation for file paths?', options: [
      QuizOption(text: 'path.join() handles OS-specific separators (/ vs \\\\) and normalizes double slashes correctly', correct: true),
      QuizOption(text: 'path.join() resolves relative paths to absolute paths automatically', correct: false),
      QuizOption(text: 'String concatenation doesn\'t work for paths longer than 256 characters', correct: false),
      QuizOption(text: 'path.join() is required to access files in Node.js — concatenation throws an error', correct: false),
    ]),
    Quiz(question: 'What is the difference between fs.readFile() and fs.readFileSync()?', options: [
      QuizOption(text: 'readFile() is async (non-blocking); readFileSync() blocks the event loop until complete', correct: true),
      QuizOption(text: 'readFileSync() is faster because it uses low-level OS system calls', correct: false),
      QuizOption(text: 'readFile() only works with text files; readFileSync() works with binary files', correct: false),
      QuizOption(text: 'They are identical — Sync is just an alias for the callback version', correct: false),
    ]),
    Quiz(question: 'What does fs.mkdir(path, { recursive: true }) do?', options: [
      QuizOption(text: 'Creates the directory and all missing parent directories without throwing if they already exist', correct: true),
      QuizOption(text: 'Creates the directory and all subdirectories found in a template', correct: false),
      QuizOption(text: 'Recursively copies files from another directory into the new one', correct: false),
      QuizOption(text: 'Creates the directory only if it doesn\'t already exist — throws if it does', correct: false),
    ]),
  ],
);
