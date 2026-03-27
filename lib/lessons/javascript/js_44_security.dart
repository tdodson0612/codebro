import '../../models/lesson.dart';
import '../../models/quiz.dart';

final jsLesson44 = Lesson(
  language: 'JavaScript',
  title: 'JavaScript Security Best Practices',
  content: """
🎯 METAPHOR:
Security in JavaScript is like building a bank vault
inside a glass building. The vault (your server/logic)
is impenetrable — but if the building's glass walls
(the browser) can be broken by a malicious visitor,
they can watch you open the vault. XSS is someone
sneaking a tiny camera into your glass building —
they don't break the vault, they just observe you.
CSRF is someone tricking you into walking into the vault
and opening it yourself, without realising it. SQL
injection is someone writing instructions on a piece
of paper that looks like a normal form but actually
commands your vault to open. Defense is layered:
don't trust input, escape output, validate on the
server, use security headers.

📖 EXPLANATION:
The most important JavaScript security vulnerabilities
and how to defend against them.

─────────────────────────────────────
XSS — CROSS-SITE SCRIPTING:
─────────────────────────────────────
  XSS: attacker injects malicious scripts into pages
  viewed by other users.

  // ❌ VULNERABLE — renders raw HTML:
  el.innerHTML = userInput;
  // If userInput = '<script>stealCookies()</script>'
  // The script executes!

  // ✅ SAFE — treats as text:
  el.textContent = userInput;

  // ✅ SAFE — sanitize before innerHTML:
  import DOMPurify from 'dompurify';
  el.innerHTML = DOMPurify.sanitize(userInput);

  Three types of XSS:
  → Stored: script saved to DB, served to all users
  → Reflected: script in URL, reflected back in response
  → DOM-based: client-side JS writes untrusted data to DOM

─────────────────────────────────────
CSP — CONTENT SECURITY POLICY:
─────────────────────────────────────
  // HTTP header telling browser what scripts to trust:
  Content-Security-Policy:
    default-src 'self';
    script-src 'self' 'nonce-{random}';
    style-src 'self' https://fonts.googleapis.com;
    img-src 'self' data: https:;
    connect-src 'self' https://api.example.com;

  // Or as meta tag (limited — can't prevent all attacks):
  <meta http-equiv="Content-Security-Policy"
        content="default-src 'self'; script-src 'self'">

  CSP prevents XSS by blocking inline scripts and
  scripts from untrusted origins.

─────────────────────────────────────
CSRF — CROSS-SITE REQUEST FORGERY:
─────────────────────────────────────
  CSRF: tricks authenticated users into making unwanted
  requests to another site.

  Defense:
  → CSRF tokens: include a secret token in each form
  → SameSite cookies: SameSite=Strict or Lax
  → Check Origin/Referer headers
  → Use POST for state-changing operations

  // SameSite cookie:
  Set-Cookie: session=abc; SameSite=Strict; Secure; HttpOnly

─────────────────────────────────────
INJECTION — SQL / COMMAND:
─────────────────────────────────────
  // ❌ SQL INJECTION VULNERABLE:
  const query = \`SELECT * FROM users WHERE name = '\${
input}'\`;
  // If input = "'; DROP TABLE users; --"
  // → entire table dropped!

  // ✅ PARAMETERIZED QUERIES:
  db.query('SELECT * FROM users WHERE name = ?', [input]);

  // ❌ OS COMMAND INJECTION:
  exec('ls ' + userInput);     // dangerous!

  // ✅ SAFE — validate and use allowlist:
  const allowed = ['ls', 'pwd', 'date'];
  if (allowed.includes(command)) exec(command);

─────────────────────────────────────
SECURE HEADERS:
─────────────────────────────────────
  X-Content-Type-Options: nosniff
  X-Frame-Options: DENY                    // prevent clickjacking
  X-XSS-Protection: 1; mode=block         // legacy browsers
  Strict-Transport-Security: max-age=31536000; includeSubDomains
  Referrer-Policy: strict-origin-when-cross-origin
  Permissions-Policy: camera=(), microphone=()

─────────────────────────────────────
INPUT VALIDATION:
─────────────────────────────────────
  // Always validate on SERVER (client-side is UX only):
  // ❌ Client-side only:
  if (!email.includes('@')) return;   // bypass by disabling JS!

  // ✅ Server-side validation (Node.js example):
  function validateUser(data) {
      const errors = [];
      if (!data.email?.match(/^[^\\s@]+@[^\\s@]+\\.[^\\s@]+\$/))
          errors.push('Invalid email');
      if (!data.password || data.password.length < 8)
          errors.push('Password must be 8+ chars');
      return errors;
  }

─────────────────────────────────────
AUTHENTICATION BEST PRACTICES:
─────────────────────────────────────
  ✅ Never store passwords in plain text
  ✅ Use bcrypt/argon2 for password hashing
  ✅ JWT: short expiry, verify signature, HTTPS only
  ✅ Rate limit login attempts
  ✅ Invalidate sessions on logout
  ✅ 2FA for sensitive operations
  ❌ Never log passwords or tokens
  ❌ Never put secrets in frontend code

─────────────────────────────────────
DEPENDENCY SECURITY:
─────────────────────────────────────
  npm audit                   // check for known vulnerabilities
  npm audit fix               // auto-fix
  npm update                  // update dependencies
  Use Snyk / Dependabot for automated monitoring

─────────────────────────────────────
eval() AND FRIENDS — NEVER USE:
─────────────────────────────────────
  eval(userInput)              // executes arbitrary code!
  new Function(userInput)      // same risk
  setTimeout(string, ms)       // eval in disguise
  document.write(userInput)    // XSS risk

💻 CODE:
// ─── XSS PREVENTION ───────────────────────────────────
console.log("=== XSS Prevention ===");

// HTML escaping function (DOMPurify does this properly in browsers):
function escapeHtml(str) {
    const chars = { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' };
    return String(str).replace(/[&<>"']/g, c => chars[c]);
}

const maliciousInputs = [
    '<script>alert("XSS")</script>',
    '<img src="x" onerror="stealCookies()">',
    'javascript:void(document.cookie)',
    '<svg onload="evil()">',
    'Normal safe text',
    '5 < 10 & 3 > 1',
];

console.log("  Escaping dangerous HTML:");
maliciousInputs.forEach(input => {
    const escaped = escapeHtml(input);
    console.log(\`  Input:  \${
input.slice(0, 50)}\`);
    console.log(\`  Escaped:\${
escaped.slice(0, 60)}\`);
    console.log();
});

// ─── INPUT VALIDATION ─────────────────────────────────
console.log("=== Input Validation ===");

class Validator {
    #rules = {};

    field(name) {
        const rules = [];
        this.#rules[name] = rules;

        const builder = {
            required: (msg = \`\${
name} is required\`) => {
                rules.push(v => (v !== null && v !== undefined && v !== '') || msg);
                return builder;
            },
            string: (msg = \`\${
name} must be a string\`) => {
                rules.push(v => typeof v === 'string' || msg);
                return builder;
            },
            min: (n, msg = \`\${
name} must be at least\${
n} chars\`) => {
                rules.push(v => !v || v.length >= n || msg);
                return builder;
            },
            max: (n, msg = \`\${
name} must be at most\${
n} chars\`) => {
                rules.push(v => !v || v.length <= n || msg);
                return builder;
            },
            pattern: (re, msg = \`\${
name} format invalid\`) => {
                rules.push(v => !v || re.test(v) || msg);
                return builder;
            },
            number: (msg = \`\${
name} must be a number\`) => {
                rules.push(v => v === undefined || v === null || typeof v === 'number' || msg);
                return builder;
            },
            range: (min, max, msg = \`\${
name} must be between\${
min} and\${
max}\`) => {
                rules.push(v => v === undefined || (v >= min && v <= max) || msg);
                return builder;
            },
        };
        return builder;
    }

    validate(data) {
        const errors = {};
        for (const [name, rules] of Object.entries(this.#rules)) {
            for (const rule of rules) {
                const result = rule(data[name]);
                if (typeof result === 'string') {
                    if (!errors[name]) errors[name] = [];
                    errors[name].push(result);
                }
            }
        }
        return { valid: Object.keys(errors).length === 0, errors };
    }
}

const userValidator = new Validator();
userValidator.field('name').required().string().min(2).max(50);
userValidator.field('email').required().pattern(/^[^\\s@]+@[^\\s@]+\\.[^\\s@]+\$/, 'Invalid email');
userValidator.field('age').number().range(0, 150, 'Age must be 0-150');
userValidator.field('password').required().min(8, 'Password must be 8+ characters');

const testUsers = [
    { name: 'Alice', email: 'alice@example.com', age: 28, password: 'Secure123!' },
    { name: 'B',     email: 'not-an-email',      age: 200, password: 'weak' },
    { name: '',      email: '',                   age: -1,  password: '' },
];

testUsers.forEach((user, i) => {
    const { valid, errors } = userValidator.validate(user);
    console.log(\`  Test\${
i + 1}:\${
valid ? '✅ valid' : '❌ invalid'}\`);
    if (!valid) {
        Object.entries(errors).forEach(([field, errs]) => {
            errs.forEach(err => console.log(\`    [\${
field}]\${
err}\`));
        });
    }
});

// ─── CSRF TOKEN SIMULATION ────────────────────────────
console.log("\n=== CSRF Token Pattern ===");

function generateToken(length = 32) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    let token = '';
    for (let i = 0; i < length; i++) {
        token += chars[Math.floor(Math.random() * chars.length)];
    }
    return token;
}

// Server-side CSRF token store (in production: use session store):
const csrfTokens = new Map();

function createSession(userId) {
    const token = generateToken();
    csrfTokens.set(userId, token);
    return token;
}

function validateCsrfToken(userId, submittedToken) {
    const expected = csrfTokens.get(userId);
    if (!expected || expected !== submittedToken) {
        throw new Error('Invalid CSRF token — possible CSRF attack!');
    }
    return true;
}

const sessionToken = createSession('user-42');
console.log(\`  Generated CSRF token:\${
sessionToken.slice(0, 16)}...\`);

// Legitimate request (has token):
try {
    validateCsrfToken('user-42', sessionToken);
    console.log("  ✅ Legitimate request: valid CSRF token");
} catch (e) {
    console.log(\`  ❌\${
e.message}\`);
}

// Forged request (no/wrong token):
try {
    validateCsrfToken('user-42', 'forged-token-here');
    console.log("  ✅ Forged request passed! (should not happen)");
} catch (e) {
    console.log(\`  ❌ Forged request blocked:\${
e.message}\`);
}

// ─── RATE LIMITING ────────────────────────────────────
console.log("\n=== Rate Limiting ===");

class RateLimiter {
    #windows = new Map();
    #limit;
    #windowMs;

    constructor(limit, windowMs) {
        this.#limit    = limit;
        this.#windowMs = windowMs;
    }

    check(key) {
        const now = Date.now();
        const window = this.#windows.get(key) || { count: 0, resetAt: now + this.#windowMs };

        if (now > window.resetAt) {
            window.count   = 0;
            window.resetAt = now + this.#windowMs;
        }

        window.count++;
        this.#windows.set(key, window);

        if (window.count > this.#limit) {
            const waitMs = window.resetAt - now;
            throw new Error(\`Rate limit exceeded. Try again in\${
Math.ceil(waitMs/1000)}s\`);
        }

        return { remaining: this.#limit - window.count, resetAt: window.resetAt };
    }
}

// Max 3 login attempts per minute:
const loginLimiter = new RateLimiter(3, 60000);

const attempts = ['alice', 'alice', 'alice', 'alice', 'alice'];
attempts.forEach((user, i) => {
    try {
        const info = loginLimiter.check(\`login:\${
user}\`);
        console.log(\`  Attempt\${
i+1}: ✅ Allowed (remaining:\${
info.remaining})\`);
    } catch (e) {
        console.log(\`  Attempt\${
i+1}: ❌ Blocked —\${
e.message}\`);
    }
});

// ─── SECURITY HEADERS REFERENCE ───────────────────────
console.log("\n=== Security Headers Cheatsheet ===");
const headers = [
    ["Content-Security-Policy",       "Restrict allowed content sources — prevents XSS"],
    ["X-Content-Type-Options: nosniff","Prevent MIME type sniffing attacks"],
    ["X-Frame-Options: DENY",          "Prevent clickjacking via iframes"],
    ["Strict-Transport-Security",       "Force HTTPS for future visits"],
    ["Referrer-Policy",                "Control referrer information sent"],
    ["Permissions-Policy",             "Restrict browser feature access"],
    ["Set-Cookie: SameSite=Strict",    "Prevent CSRF via cookie theft"],
    ["Set-Cookie: HttpOnly",           "Prevent JS access to cookies"],
    ["Set-Cookie: Secure",             "Cookies only over HTTPS"],
];
headers.forEach(([header, desc]) => {
    console.log(\` \${
header.slice(0, 35).padEnd(36)}:\${
desc}\`);
});

📝 KEY POINTS:
✅ Never use innerHTML with user input — use textContent or DOMPurify to sanitize
✅ Content Security Policy (CSP) prevents XSS by restricting script sources
✅ CSRF tokens validate that form submissions originate from your own site
✅ Always validate input on the server — client-side validation is bypassed easily
✅ Use parameterized queries for database operations — never string interpolation
✅ Rate limit authentication endpoints to prevent brute force attacks
✅ Set HttpOnly, Secure, and SameSite on all authentication cookies
✅ Run npm audit regularly and keep dependencies updated
✅ Never put secrets (API keys, passwords) in frontend JavaScript
❌ Never use eval() with user input — arbitrary code execution vulnerability
❌ Don't trust any client-provided data — validate and sanitize everything server-side
❌ Don't log passwords, tokens, or other sensitive data — even in error messages
❌ Don't use Math.random() for security-critical values — use crypto.getRandomValues()
""",
  quiz: [
    Quiz(question: 'What is a Cross-Site Scripting (XSS) attack?', options: [
      QuizOption(text: 'An attacker injects malicious scripts into a page viewed by other users — stealing data or hijacking sessions', correct: true),
      QuizOption(text: 'An attacker tricks an authenticated user into making an unwanted request to another site', correct: false),
      QuizOption(text: 'An attacker intercepts network requests between the user and the server', correct: false),
      QuizOption(text: 'An attacker overloads the server with requests until it crashes', correct: false),
    ]),
    Quiz(question: 'Why is textContent safer than innerHTML for displaying user data?', options: [
      QuizOption(text: 'textContent inserts text as literal characters — HTML tags are not parsed, so scripts cannot execute', correct: true),
      QuizOption(text: 'textContent automatically encrypts the text before displaying it', correct: false),
      QuizOption(text: 'textContent validates the content against a whitelist before rendering', correct: false),
      QuizOption(text: 'innerHTML is faster which encourages developers to use it less carefully', correct: false),
    ]),
    Quiz(question: 'What does the HttpOnly cookie flag prevent?', options: [
      QuizOption(text: 'JavaScript access to the cookie — prevents XSS attacks from stealing session tokens via document.cookie', correct: true),
      QuizOption(text: 'The cookie from being sent over HTTP — only HTTPS connections can access it', correct: false),
      QuizOption(text: 'The server from setting the cookie — it can only be set by client-side JavaScript', correct: false),
      QuizOption(text: 'The cookie from being included in cross-origin requests — prevents CSRF', correct: false),
    ]),
  ],
);
