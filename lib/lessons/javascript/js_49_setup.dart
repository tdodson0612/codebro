import '../../models/lesson.dart';
import '../../models/quiz.dart';

final jsLesson49 = Lesson(
  language: 'JavaScript',
  title: 'Setting Up Your JavaScript Environment',
  content: """
🎯 METAPHOR:
Setting up a professional JavaScript development
environment is like outfitting a professional kitchen.
A home cook can manage with a basic knife and pan —
and you CAN write JavaScript in Notepad and run it in
the browser console. But a professional kitchen has
the right equipment for the job: a sharp chef's knife
(ESLint catching errors), precise scales (TypeScript
checking types), a powerful oven (Vite bundling and
hot-reloading), and a clean station (Prettier
auto-formatting). The food (your code) is the same
quality regardless, but the professional kitchen lets
you work faster, make fewer mistakes, and scale to
larger meals (bigger projects).

📖 EXPLANATION:
A modern JavaScript setup covers runtime, package
management, bundling, linting, formatting, and testing.

─────────────────────────────────────
STEP 1 — RUNTIME: Install Node.js
─────────────────────────────────────
  Download from: nodejs.org

  Recommended: use NVM (Node Version Manager) to
  manage multiple Node versions:

  # Install NVM:
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

  # Install and use Node 20 LTS:
  nvm install 20
  nvm use 20
  nvm alias default 20

  # Verify:
  node --version   # v20.x.x
  npm --version    # 10.x.x

─────────────────────────────────────
STEP 2 — EDITOR: Visual Studio Code
─────────────────────────────────────
  Download from: code.visualstudio.com

  Essential extensions:
  → ESLint         → real-time linting
  → Prettier       → code formatting
  → GitLens        → enhanced git features
  → Error Lens     → inline error display
  → TypeScript Hero→ TS imports & organizer
  → REST Client    → test HTTP requests
  → Thunder Client → API testing (Postman-like)

  settings.json key settings:
  {
    "editor.formatOnSave": true,
    "editor.defaultFormatter": "esbenp.prettier-vscode",
    "editor.codeActionsOnSave": {
      "source.fixAll.eslint": true
    }
  }

─────────────────────────────────────
STEP 3 — PROJECT SETUP
─────────────────────────────────────
  # Create a new project:
  mkdir my-project && cd my-project
  npm init -y

  # OR use a template (recommended):
  npm create vite@latest my-app -- --template vanilla
  npm create vite@latest my-app -- --template react
  npm create vite@latest my-app -- --template vue

  # Install core tools:
  npm install -D typescript tsx eslint prettier
  npm install -D @eslint/js eslint-config-prettier
  npx tsc --init       # create tsconfig.json

─────────────────────────────────────
STEP 4 — LINTING: ESLint
─────────────────────────────────────
  # eslint.config.js (flat config, ESLint 9+):
  import js from '@eslint/js';

  export default [
    js.configs.recommended,
    {
      rules: {
        'no-unused-vars':  'error',
        'no-console':      'warn',
        'prefer-const':    'error',
        'eqeqeq':          'error',    // always ===
        'no-var':          'error',    // never var
      }
    }
  ];

  # Run:
  npx eslint src/
  npx eslint src/ --fix   # auto-fix what it can

─────────────────────────────────────
STEP 5 — FORMATTING: Prettier
─────────────────────────────────────
  # .prettierrc:
  {
    "semi":        true,
    "singleQuote": true,
    "tabWidth":    2,
    "trailingComma": "es5",
    "printWidth":  100,
    "arrowParens": "avoid"
  }

  # Run:
  npx prettier --write src/
  npx prettier --check src/  # CI: fails if not formatted

─────────────────────────────────────
STEP 6 — BUNDLER: Vite
─────────────────────────────────────
  # Fastest dev experience:
  npm create vite@latest my-app

  # vite.config.js:
  import { defineConfig } from 'vite';

  export default defineConfig({
    build: {
      target: 'ES2022',
      outDir: 'dist',
    },
    server: {
      port: 3000,
      hmr: true,    // hot module replacement
    },
  });

  # Commands:
  npm run dev    # start dev server (hot reload)
  npm run build  # production build
  npm run preview# preview production build

─────────────────────────────────────
STEP 7 — TESTING: Vitest
─────────────────────────────────────
  npm install -D vitest @vitest/coverage-v8

  # package.json scripts:
  "test":     "vitest",
  "coverage": "vitest run --coverage"

  # vite.config.js (or vitest.config.ts):
  test: {
    globals: true,
    environment: 'jsdom',  // for DOM tests
    coverage: {
      reporter: ['text', 'html'],
      thresholds: { lines: 80 }
    }
  }

─────────────────────────────────────
STEP 8 — GIT HOOKS: Husky + lint-staged
─────────────────────────────────────
  # Run linting/formatting before every commit:
  npm install -D husky lint-staged
  npx husky init

  # .husky/pre-commit:
  npx lint-staged

  # package.json:
  "lint-staged": {
    "*.{js,ts}":   ["eslint --fix", "prettier --write"],
    "*.{json,md}": ["prettier --write"]
  }

─────────────────────────────────────
COMPLETE package.json SCRIPTS:
─────────────────────────────────────
  "scripts": {
    "dev":       "vite",
    "build":     "tsc && vite build",
    "preview":   "vite preview",
    "test":      "vitest",
    "coverage":  "vitest run --coverage",
    "lint":      "eslint src/",
    "lint:fix":  "eslint src/ --fix",
    "format":    "prettier --write src/",
    "typecheck": "tsc --noEmit",
    "prepare":   "husky"
  }

─────────────────────────────────────
ENVIRONMENT VARIABLES:
─────────────────────────────────────
  # .env (never commit secrets!):
  VITE_API_URL=https://api.example.com
  VITE_APP_NAME=MyApp

  # Access in code (Vite):
  import.meta.env.VITE_API_URL

  # .env.local — override for local dev (gitignored)
  # .env.production — production values
  # .env.test — test environment values

─────────────────────────────────────
DEBUGGING IN VS CODE:
─────────────────────────────────────
  // .vscode/launch.json:
  {
    "configurations": [{
      "type": "node",
      "request": "launch",
      "name": "Debug",
      "runtimeExecutable": "tsx",
      "args": ["\${workspaceFolder}/src/index.ts"],
      "console": "integratedTerminal"
    }]
  }

  Browser debugging:
  → Chrome: F12 → Sources → set breakpoints
  → VS Code: Debugger for Chrome extension

💻 CODE:
console.log("=== Development Environment Reference ===\n");

const setup = {
    runtime: {
        tool: "Node.js 20 LTS",
        install: "nvm install 20 && nvm use 20",
        verify:  "node --version && npm --version",
    },
    editor: {
        tool: "Visual Studio Code",
        extensions: ["ESLint", "Prettier", "GitLens", "Error Lens"],
        keySettings: ["editor.formatOnSave: true"],
    },
    linting: {
        tool: "ESLint 9 (flat config)",
        install: "npm install -D eslint @eslint/js",
        run:     "npx eslint src/ --fix",
        config:  "eslint.config.js",
    },
    formatting: {
        tool: "Prettier",
        install: "npm install -D prettier",
        run:     "npx prettier --write src/",
        config:  ".prettierrc",
    },
    bundler: {
        tool: "Vite",
        create: "npm create vite@latest my-app",
        dev:    "npm run dev",
        build:  "npm run build",
    },
    testing: {
        tool: "Vitest",
        install: "npm install -D vitest",
        run:     "npm test",
        coverage: "vitest run --coverage",
    },
    gitHooks: {
        tool: "Husky + lint-staged",
        install: "npm install -D husky lint-staged && npx husky init",
        effect: "Runs lint + format on every commit",
    },
};

// Print the setup guide:
Object.entries(setup).forEach(([category, info]) => {
    console.log(\`=== \${category.toUpperCase()} ===\`);
    Object.entries(info).forEach(([key, value]) => {
        if (Array.isArray(value)) {
            console.log(\`  \${key.padEnd(12)}: \${value.join(', ')}\`);
        } else {
            console.log(\`  \${key.padEnd(12)}: \${value}\`);
        }
    });
    console.log();
});

// Project template:
console.log("=== Recommended Project Structure ===\n");
const structure = \`
my-project/
├── src/
│   ├── index.ts          # entry point
│   ├── api/              # API clients
│   ├── components/       # UI components
│   ├── utils/            # utilities
│   └── types/            # TypeScript types
├── tests/
│   └── *.test.ts         # test files
├── public/               # static assets
├── .env                  # environment (gitignored)
├── .env.example          # template for env vars
├── .gitignore
├── .prettierrc
├── eslint.config.js
├── tsconfig.json
├── vite.config.ts
└── package.json
\`;
console.log(structure);

// Checklist:
console.log("=== New Project Checklist ===\n");
const checklist = [
    "[ ] Node.js LTS installed (via nvm)",
    "[ ] VS Code with ESLint + Prettier extensions",
    "[ ] npm init -y (or npm create vite@latest)",
    "[ ] TypeScript configured (tsconfig.json)",
    "[ ] ESLint configured (eslint.config.js)",
    "[ ] Prettier configured (.prettierrc)",
    "[ ] Vitest for testing",
    "[ ] Husky pre-commit hooks",
    "[ ] .env.example committed, .env gitignored",
    "[ ] README.md with setup instructions",
    "[ ] CI/CD pipeline (GitHub Actions)",
];
checklist.forEach(item => console.log("  " + item));

📝 KEY POINTS:
✅ Use NVM to manage multiple Node.js versions — switch per project
✅ VS Code + ESLint + Prettier is the standard modern JS development setup
✅ Vite is the recommended bundler/dev server for new projects — much faster than Webpack
✅ Vitest shares Vite's configuration — zero-config testing for Vite projects
✅ Husky + lint-staged ensures code quality on every commit automatically
✅ Always commit .env.example with placeholder values — never commit actual .env secrets
✅ Prettier format-on-save eliminates all manual formatting decisions
✅ eslint --fix auto-corrects many linting issues; some require manual fixes
✅ TypeScript strict mode catches the most bugs — enable it from day one
❌ Don't commit node_modules — add to .gitignore
❌ Don't put secrets in code or .env files committed to version control
❌ Don't skip testing setup — establishing it early is much easier than retrofitting
❌ Don't configure everything manually — use starter templates (create-vite, create-next-app)
""",
  quiz: [
    Quiz(question: 'What is Vite and why is it preferred over Webpack for new projects?', options: [
      QuizOption(text: 'Vite uses native ES modules for instant dev server start and HMR — dramatically faster than Webpack\'s bundle-first approach', correct: true),
      QuizOption(text: 'Vite is Webpack\'s official successor and replaces it completely', correct: false),
      QuizOption(text: 'Vite only works with Vue.js — for React you still need Webpack', correct: false),
      QuizOption(text: 'Vite is faster because it skips the TypeScript compilation step', correct: false),
    ]),
    Quiz(question: 'What does Husky + lint-staged do for a JavaScript project?', options: [
      QuizOption(text: 'Runs linting and formatting on staged files before every commit — preventing bad code from entering the repository', correct: true),
      QuizOption(text: 'Automatically deploys the project whenever code is committed', correct: false),
      QuizOption(text: 'Runs the full test suite before each push to the remote repository', correct: false),
      QuizOption(text: 'Compresses and optimizes assets before committing to reduce repo size', correct: false),
    ]),
    Quiz(question: 'Why should you never commit your .env file to version control?', options: [
      QuizOption(text: 'It contains secrets (API keys, passwords, tokens) that anyone with access to the repo could steal', correct: true),
      QuizOption(text: '.env files use a format that Git cannot track correctly — changes won\'t be recorded', correct: false),
      QuizOption(text: 'Environment variables are automatically loaded from the OS — .env files are only for local development', correct: false),
      QuizOption(text: 'Committing .env breaks the deployment pipeline by overriding production values', correct: false),
    ]),
  ],
);
