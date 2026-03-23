import '../../models/lesson.dart';
import '../../models/quiz.dart';

final jsLesson39 = Lesson(
  language: 'JavaScript',
  title: 'npm and package.json',
  content: """
🎯 METAPHOR:
npm (Node Package Manager) is like the world's largest
library and its automated delivery service combined.
The library has over 2 million books (packages) written
by developers worldwide. package.json is your reading
list — it says "this project needs these specific books
at these specific editions." When you share your project,
you just share the reading list (package.json), not the
books themselves (node_modules). Anyone who gets your
list can run one command (npm install) and the delivery
service fetches the exact same books. The lockfile
(package-lock.json) is the receipt — it remembers every
sub-book each book needed, ensuring everyone gets the
exact same library, down to every sub-dependency.

📖 EXPLANATION:
npm is the default package manager for Node.js.
It manages project dependencies, scripts, and publishing.

─────────────────────────────────────
package.json — the project manifest:
─────────────────────────────────────
  {
    "name": "my-app",
    "version": "1.0.0",
    "description": "My awesome app",
    "main": "index.js",            // entry point
    "type": "module",              // "module" = ESM, "commonjs" = CJS
    "scripts": {
      "start":  "node src/index.js",
      "dev":    "nodemon src/index.js",
      "test":   "jest",
      "build":  "tsc",
      "lint":   "eslint src/"
    },
    "dependencies": {
      "express":  "^4.18.2",       // ^ = compatible minor updates
      "axios":    "~1.5.0"         // ~ = compatible patch updates only
    },
    "devDependencies": {
      "jest":       "^29.0.0",
      "typescript": "^5.0.0",
      "nodemon":    "^3.0.0"
    },
    "engines": {
      "node": ">=18.0.0"
    },
    "license": "MIT"
  }

─────────────────────────────────────
VERSION RANGES:
─────────────────────────────────────
  "1.2.3"    → exactly 1.2.3
  "^1.2.3"   → >=1.2.3 <2.0.0 (compatible)
  "~1.2.3"   → >=1.2.3 <1.3.0 (patch updates)
  ">=1.2.3"  → any version >= 1.2.3
  "*"        → any version (avoid!)
  "latest"   → whatever's current (avoid in prod!)

─────────────────────────────────────
ESSENTIAL npm COMMANDS:
─────────────────────────────────────
  npm init                    → create package.json interactively
  npm init -y                 → with all defaults

  npm install                 → install all dependencies
  npm install express         → add to dependencies
  npm install -D jest         → add to devDependencies
  npm install -g typescript   → install globally
  npm install express@4.18.2  → specific version
  npm install express@latest  → latest version

  npm uninstall express
  npm update                  → update all to latest allowed
  npm update express

  npm run start               → run "start" script
  npm run test                → run "test" script
  npm run dev                 → run "dev" script
  npm test                    → shorthand for test
  npm start                   → shorthand for start

  npm ls                      → list installed packages
  npm ls --depth=0            → top-level only
  npm outdated                → check for updates
  npm audit                   → check for vulnerabilities
  npm audit fix               → auto-fix vulnerabilities
  npm cache clean --force     → clear npm cache

  npm publish                 → publish to npm registry
  npm version patch           → bump patch version
  npm version minor           → bump minor version
  npm version major           → bump major version

─────────────────────────────────────
package-lock.json:
─────────────────────────────────────
  → Auto-generated; NEVER manually edit
  → Records EXACT versions of all deps (including transitive)
  → Ensures reproducible installs across machines
  → Commit to version control (for apps, not libraries)
  → npm ci uses lockfile exclusively (faster in CI/CD)

─────────────────────────────────────
.npmrc — npm configuration:
─────────────────────────────────────
  # Project-level .npmrc:
  engine-strict=true           # enforce "engines" field
  save-exact=true              # save exact versions

  # Private registry:
  @mycompany:registry=https://registry.mycompany.com

─────────────────────────────────────
ALTERNATIVE PACKAGE MANAGERS:
─────────────────────────────────────
  yarn    → Facebook's alternative, faster, workspaces
  pnpm    → disk-efficient (hard links), strict resolution
  bun     → all-in-one: runtime + bundler + package manager

  pnpm commands match npm closely:
  pnpm install, pnpm add, pnpm remove, pnpm run

─────────────────────────────────────
USEFUL PACKAGES BY CATEGORY:
─────────────────────────────────────
  Web frameworks:    express, fastify, hono, koa
  Validation:        zod, joi, yup, class-validator
  HTTP client:       axios, got, node-fetch, ky
  Database:          prisma, drizzle, mongoose, pg
  Auth:              jsonwebtoken, passport, lucia
  Testing:           jest, vitest, mocha, supertest
  Utilities:         lodash, ramda, date-fns, dayjs
  Env config:        dotenv, envalid, zod-env
  CLI:               commander, yargs, inquirer, chalk
  Build:             vite, esbuild, rollup, webpack
  TypeScript:        typescript, ts-node, tsx
  Linting:           eslint, prettier
  Logging:           winston, pino, bunyan

─────────────────────────────────────
MONOREPOS WITH WORKSPACES:
─────────────────────────────────────
  // root package.json:
  {
    "workspaces": ["packages/*", "apps/*"]
  }

  packages/
    ├── ui/           package.json (name: "@myco/ui")
    └── utils/        package.json (name: "@myco/utils")
  apps/
    └── web/          package.json, uses @myco/ui

  npm install        // installs all workspaces
  npm run build -w packages/ui  // run in specific workspace

💻 CODE:
// ─── PACKAGE.JSON ANATOMY ─────────────────────────────
console.log("=== package.json Structure ===");

const examplePackageJson = {
    name: "@mycompany/api-server",
    version: "2.3.1",
    description: "REST API server for the platform",
    type: "module",
    main: "dist/index.js",
    types: "dist/index.d.ts",

    scripts: {
        "start":       "node dist/index.js",
        "dev":         "tsx --watch src/index.ts",
        "build":       "tsc --project tsconfig.json",
        "test":        "vitest run",
        "test:watch":  "vitest",
        "test:coverage":"vitest run --coverage",
        "lint":        "eslint src/ --ext .ts",
        "format":      "prettier --write src/",
        "typecheck":   "tsc --noEmit",
        "prepare":     "npm run build",
    },

    dependencies: {
        "fastify":     "^4.24.3",
        "zod":         "^3.22.4",
        "@prisma/client": "^5.5.2",
        "pino":        "^8.16.1",
    },

    devDependencies: {
        "typescript":  "^5.2.2",
        "vitest":      "^0.34.6",
        "prisma":      "^5.5.2",
        "tsx":         "^3.14.0",
        "eslint":      "^8.51.0",
    },

    engines: {
        node: ">=18.0.0",
    },

    license: "MIT",
    private: true,
};

console.log("  Name:    ", examplePackageJson.name);
console.log("  Version: ", examplePackageJson.version);
console.log("  Scripts: ", Object.keys(examplePackageJson.scripts).join(', '));
console.log("  Deps:    ", Object.keys(examplePackageJson.dependencies).join(', '));
console.log("  DevDeps: ", Object.keys(examplePackageJson.devDependencies).join(', '));

// ─── VERSION RANGES ───────────────────────────────────
console.log("\n=== Version Range Semantics ===");

function explainRange(range) {
    if (range.startsWith('^')) return \`Compatible: >= \${range.slice(1)}, < next major\`;
    if (range.startsWith('~')) return \`Patch only: >= \${range.slice(1)}, < next minor\`;
    if (range.startsWith('>=')) return \`At least: \${range}\`;
    if (range === '*') return 'Any version (dangerous!)';
    return \`Exact: \${range}\`;
}

const ranges = ['^4.18.2', '~1.5.0', '>=3.0.0', '5.2.0', '*', 'latest'];
ranges.forEach(r => console.log(\`  \${r.padEnd(12)}: \${explainRange(r)}\`));

// ─── SCRIPT RUNNER ────────────────────────────────────
console.log("\n=== npm Scripts ===");

const scripts = {
    start:    () => console.log("  [start] node dist/index.js"),
    dev:      () => console.log("  [dev]   tsx --watch src/index.ts"),
    build:    () => {
        console.log("  [build] tsc --project tsconfig.json");
        return { success: true, files: 24, time: "3.2s" };
    },
    test:     () => {
        console.log("  [test]  vitest run");
        return { passed: 47, failed: 0, total: 47, time: "1.8s" };
    },
    lint:     () => {
        console.log("  [lint]  eslint src/ --ext .ts");
        return { errors: 0, warnings: 2 };
    },
};

// Simulate: npm run build
const buildResult = scripts.build();
console.log(\`  → Build: \${buildResult.files} files compiled in \${buildResult.time}\`);

// Simulate: npm test
const testResult = scripts.test();
console.log(\`  → Tests: \${testResult.passed}/\${testResult.total} passed in \${testResult.time}\`);

// Simulate: npm run lint
const lintResult = scripts.lint();
console.log(\`  → Lint: \${lintResult.errors} errors, \${lintResult.warnings} warnings\`);

// ─── DEPENDENCY MANAGEMENT SIMULATION ────────────────
console.log("\n=== Dependency Analysis ===");

function analyzeDependencies(pkg) {
    const deps    = Object.entries(pkg.dependencies || {});
    const devDeps = Object.entries(pkg.devDependencies || {});

    console.log("  Production dependencies:");
    deps.forEach(([name, ver]) => {
        console.log(\`    \${name.padEnd(20)} \${ver}\`);
    });

    console.log("  Dev dependencies:");
    devDeps.forEach(([name, ver]) => {
        console.log(\`    \${name.padEnd(20)} \${ver}\`);
    });

    console.log(\`  Total: \${deps.length} prod, \${devDeps.length} dev\`);
}

analyzeDependencies(examplePackageJson);

// ─── PRACTICAL: Environment Config Pattern ────────────
console.log("\n=== Environment Configuration Pattern ===");

// Using .env file (dotenv package pattern):
const mockEnv = {
    NODE_ENV:    'development',
    PORT:        '3000',
    DATABASE_URL:'postgresql://user:pass@localhost:5432/mydb',
    JWT_SECRET:  'development-secret-key',
    LOG_LEVEL:   'debug',
};

// Validate and type env (zod-like):
function parseEnv(env) {
    const required = ['NODE_ENV', 'PORT', 'DATABASE_URL', 'JWT_SECRET'];
    const missing = required.filter(k => !env[k]);

    if (missing.length > 0) {
        throw new Error(\`Missing required env vars: \${missing.join(', ')}\`);
    }

    return {
        nodeEnv:     env.NODE_ENV,
        port:        parseInt(env.PORT),
        databaseUrl: env.DATABASE_URL,
        jwtSecret:   env.JWT_SECRET,
        logLevel:    env.LOG_LEVEL || 'info',
        isDev:       env.NODE_ENV === 'development',
        isProd:      env.NODE_ENV === 'production',
    };
}

const config = parseEnv(mockEnv);
console.log("  NODE_ENV:", config.nodeEnv);
console.log("  PORT:    ", config.port);
console.log("  isDev:   ", config.isDev);
console.log("  logLevel:", config.logLevel);
console.log("  DB URL (masked):", config.databaseUrl.replace(/:([^@:]+)@/, ':***@'));

// ─── COMMON npm COMMANDS REFERENCE ────────────────────
console.log("\n=== Essential npm Commands ===");

const commands = [
    ["npm init -y",          "Create package.json with defaults"],
    ["npm install",          "Install all dependencies"],
    ["npm install express",  "Add runtime dependency"],
    ["npm install -D jest",  "Add dev dependency"],
    ["npm run dev",          "Run 'dev' script"],
    ["npm test",             "Run 'test' script"],
    ["npm run build",        "Run 'build' script"],
    ["npm outdated",         "Check for outdated packages"],
    ["npm audit",            "Check for vulnerabilities"],
    ["npm audit fix",        "Auto-fix vulnerabilities"],
    ["npm ci",               "Clean install (CI/CD)"],
    ["npm version patch",    "Bump 1.0.0 → 1.0.1"],
    ["npm version minor",    "Bump 1.0.0 → 1.1.0"],
    ["npm version major",    "Bump 1.0.0 → 2.0.0"],
    ["npm publish",          "Publish to npm registry"],
];

commands.forEach(([cmd, desc]) => {
    console.log(\`  \${cmd.padEnd(28)}: \${desc}\`);
});

📝 KEY POINTS:
✅ package.json is the project manifest — name, version, scripts, dependencies
✅ "dependencies" are runtime; "devDependencies" are for development only
✅ ^ (caret) allows compatible minor/patch updates; ~ (tilde) allows patch updates only
✅ package-lock.json records exact versions — always commit it for applications
✅ npm ci uses the lockfile exclusively — faster and more reliable for CI/CD
✅ npm run <script> executes any script; npm start and npm test are shortcuts
✅ Use process.env for configuration — load from .env with the dotenv package
✅ npm audit checks for known security vulnerabilities in dependencies
✅ pnpm is a faster, disk-efficient alternative to npm worth knowing
❌ Don't commit node_modules — add it to .gitignore
❌ Don't use * or latest in dependencies — breaks reproducibility
❌ Don't manually edit package-lock.json — let npm manage it
❌ Don't install dev dependencies in production — use npm ci --omit=dev
""",
  quiz: [
    Quiz(question: 'What is the difference between ^ and ~ in package version ranges?', options: [
      QuizOption(text: '^ allows compatible minor and patch updates (1.2.3 → <2.0.0); ~ allows only patch updates (1.2.3 → <1.3.0)', correct: true),
      QuizOption(text: '^ requires an exact version; ~ allows any version with the same major number', correct: false),
      QuizOption(text: '~ is for stable releases; ^ is for pre-release and beta versions', correct: false),
      QuizOption(text: 'They are identical — npm treats them the same way', correct: false),
    ]),
    Quiz(question: 'What does npm ci do differently than npm install?', options: [
      QuizOption(text: 'npm ci uses only the lockfile — installing exact versions without modifying it, faster for CI/CD pipelines', correct: true),
      QuizOption(text: 'npm ci only installs production dependencies, skipping devDependencies', correct: false),
      QuizOption(text: 'npm ci installs packages without creating a node_modules folder', correct: false),
      QuizOption(text: 'npm ci validates that packages pass security audits before installing', correct: false),
    ]),
    Quiz(question: 'Why should you commit package-lock.json to version control for an application?', options: [
      QuizOption(text: 'It records exact versions of all dependencies — ensuring everyone and every environment gets identical packages', correct: true),
      QuizOption(text: 'package-lock.json is required by npm to install packages at all', correct: false),
      QuizOption(text: 'It contains the source code of all dependencies for offline use', correct: false),
      QuizOption(text: 'npm will refuse to publish the package without package-lock.json in the repository', correct: false),
    ]),
  ],
);
