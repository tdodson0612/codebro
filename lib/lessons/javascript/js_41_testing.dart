import '../../models/lesson.dart';
import '../../models/quiz.dart';

final jsLesson41 = Lesson(
  language: 'JavaScript',
  title: 'Testing JavaScript with Jest and Vitest',
  content: """
🎯 METAPHOR:
Tests are the safety harness for a skyscraper window
cleaner. The cleaner (your code) should be skilled enough
to work without falling — and usually is. But the harness
is there to catch unexpected problems: a gust of wind
(edge case), a slipped grip (refactoring bug), an
unexpected obstacle (new requirement). Without tests,
every change to your code risks silently breaking
something else. With tests, you can refactor fearlessly:
if all tests pass, nothing broke. The test suite is
the harness — it can't prevent all accidents, but it
ensures recoverable ones don't become catastrophic.

📖 EXPLANATION:
Jest is the most popular JS testing framework. Vitest
is the modern, faster alternative (works with Vite).
Both share nearly identical APIs.

─────────────────────────────────────
SETUP:
─────────────────────────────────────
  // Jest:
  npm install -D jest @types/jest
  // Add to package.json: "test": "jest"

  // Vitest (for Vite projects):
  npm install -D vitest
  // Add to package.json: "test": "vitest"

─────────────────────────────────────
TEST STRUCTURE:
─────────────────────────────────────
  // describe groups related tests:
  describe('Calculator', () => {
      test('adds two numbers', () => {
          expect(add(2, 3)).toBe(5);
      });

      it('throws on division by zero', () => {  // 'it' = 'test'
          expect(() => divide(1, 0)).toThrow('Division by zero');
      });
  });

─────────────────────────────────────
MATCHERS:
─────────────────────────────────────
  expect(value).toBe(exact)           // === equality
  expect(value).toEqual(deep)         // deep equality
  expect(value).toStrictEqual(deep)   // deep + type check
  expect(value).not.toBe(value)       // negation
  expect(value).toBeTruthy()
  expect(value).toBeFalsy()
  expect(value).toBeNull()
  expect(value).toBeUndefined()
  expect(value).toBeDefined()
  expect(value).toBeNaN()
  expect(num).toBeGreaterThan(n)
  expect(num).toBeLessThan(n)
  expect(num).toBeCloseTo(n, digits)  // float comparison
  expect(str).toMatch(/regex/)
  expect(str).toContain('substring')
  expect(arr).toContain(item)
  expect(arr).toHaveLength(n)
  expect(fn).toThrow()
  expect(fn).toThrow('message')
  expect(fn).toThrow(ErrorClass)
  expect(obj).toHaveProperty('key')
  expect(obj).toHaveProperty('key', value)
  expect(mock).toHaveBeenCalled()
  expect(mock).toHaveBeenCalledWith(args)
  expect(mock).toHaveBeenCalledTimes(n)

─────────────────────────────────────
ASYNC TESTING:
─────────────────────────────────────
  // async/await:
  test('fetches user', async () => {
      const user = await fetchUser(1);
      expect(user.name).toBe('Alice');
  });

  // resolves/rejects matchers:
  await expect(fetchUser(1)).resolves.toHaveProperty('name');
  await expect(fetchUser(-1)).rejects.toThrow('Not found');

─────────────────────────────────────
MOCKING:
─────────────────────────────────────
  // Mock a function:
  const mockFn = jest.fn();
  mockFn.mockReturnValue(42);
  mockFn.mockResolvedValue({ id: 1 });  // async

  // Mock a module:
  jest.mock('./api', () => ({
      fetchUser: jest.fn().mockResolvedValue({ id: 1, name: 'Alice' })
  }));

  // Spy on method:
  const spy = jest.spyOn(obj, 'method');
  expect(spy).toHaveBeenCalled();

─────────────────────────────────────
SETUP / TEARDOWN:
─────────────────────────────────────
  beforeAll(() => { /* once before all tests */ });
  afterAll(() =>  { /* once after all tests */ });
  beforeEach(() => { /* before each test */ });
  afterEach(() =>  { /* after each test */ });

─────────────────────────────────────
TEST ORGANIZATION:
─────────────────────────────────────
  describe.skip('skipped suite', () => { ... });
  test.skip('skipped test', () => { ... });
  test.only('focus on this', () => { ... });  // run only this
  test.todo('write this test');               // placeholder

─────────────────────────────────────
COVERAGE:
─────────────────────────────────────
  jest --coverage          // generate HTML coverage report
  vitest run --coverage    // same for vitest

  Reports: Statements, Branches, Functions, Lines

💻 CODE:
// ─── FUNCTIONS TO TEST ────────────────────────────────
function add(a, b) {
    if (typeof a !== 'number' || typeof b !== 'number') {
        throw new TypeError('Arguments must be numbers');
    }
    return a + b;
}

function divide(a, b) {
    if (b === 0) throw new Error('Division by zero');
    return a / b;
}

function capitalize(str) {
    if (typeof str !== 'string') throw new TypeError('Must be a string');
    if (!str) return '';
    return str.charAt(0).toUpperCase() + str.slice(1).toLowerCase();
}

function groupBy(arr, key) {
    return arr.reduce((acc, item) => {
        const k = typeof key === 'function' ? key(item) : item[key];
        if (!acc[k]) acc[k] = [];
        acc[k].push(item);
        return acc;
    }, {});
}

async function fetchUser(id) {
    if (id <= 0) throw new Error(\`Invalid ID: \${id}\`);
    // Simulate API call
    await new Promise(r => setTimeout(r, 10));
    if (id > 100) throw new Error('User not found');
    return { id, name: \`User\${id}\`, email: \`user\${id}@example.com\` };
}

// ─── MINI TEST RUNNER ─────────────────────────────────
// Real tests use jest or vitest. This simulates the API.

class TestRunner {
    #results = [];
    #current = 'global';

    describe(name, fn) {
        const prev = this.#current;
        this.#current = name;
        fn();
        this.#current = prev;
    }

    async test(name, fn) {
        const suite = this.#current;
        try {
            await fn();
            this.#results.push({ suite, name, status: 'pass' });
        } catch (e) {
            this.#results.push({ suite, name, status: 'fail', error: e.message });
        }
    }

    expect(received) {
        return {
            toBe:            (expected) => { if (received !== expected) throw new Error(\`Expected \${JSON.stringify(expected)}, got \${JSON.stringify(received)}\`); },
            toEqual:         (expected) => { if (JSON.stringify(received) !== JSON.stringify(expected)) throw new Error(\`Deep equal failed: \${JSON.stringify(received)} !== \${JSON.stringify(expected)}\`); },
            toThrow:         (msg) => {
                try { received(); throw new Error('Did not throw'); }
                catch (e) { if (msg && !e.message.includes(msg)) throw new Error(\`Threw "\${e.message}", expected to contain "\${msg}"\`); }
            },
            resolves:        { toHaveProperty: async (k) => { const v = await received; if (!(k in v)) throw new Error(\`Property "\${k}" missing\`); } },
            rejects:         { toThrow: async (msg) => { try { await received; throw new Error('Did not reject'); } catch(e) { if (msg && !e.message.includes(msg)) throw new Error(\`Rejected with "\${e.message}"\`); } } },
            toHaveLength:    (n) => { if (received.length !== n) throw new Error(\`Length \${received.length} !== \${n}\`); },
            toContain:       (item) => { if (!received.includes(item)) throw new Error(\`\${JSON.stringify(received)} does not contain \${JSON.stringify(item)}\`); },
            toBeGreaterThan: (n) => { if (!(received > n)) throw new Error(\`\${received} not > \${n}\`); },
            toBeTruthy:      () => { if (!received) throw new Error(\`Expected truthy, got \${received}\`); },
            not:             { toBe: (expected) => { if (received === expected) throw new Error(\`Expected not \${JSON.stringify(expected)}\`); } },
        };
    }

    printResults() {
        const pass = this.#results.filter(r => r.status === 'pass').length;
        const fail = this.#results.filter(r => r.status === 'fail').length;

        this.#results.forEach(r => {
            const icon = r.status === 'pass' ? '✅' : '❌';
            const msg  = r.status === 'fail' ? \` — \${r.error}\` : '';
            console.log(\`  \${icon} [\${r.suite}] \${r.name}\${msg}\`);
        });
        console.log(\`\n  Results: \${pass} passed, \${fail} failed out of \${this.#results.length} tests\`);
    }
}

const t = new TestRunner();

// ─── RUN TESTS ────────────────────────────────────────
(async () => {
    console.log("=== Running Tests ===\n");

    // add() tests
    t.describe('add()', () => {
        t.test('adds two positive numbers', () => {
            t.expect(add(2, 3)).toBe(5);
        });
        t.test('handles negative numbers', () => {
            t.expect(add(-1, -2)).toBe(-3);
            t.expect(add(-5, 10)).toBe(5);
        });
        t.test('adds decimals', () => {
            t.expect(add(0.1, 0.2)).toBeGreaterThan(0.29);
        });
        t.test('throws on non-numbers', () => {
            t.expect(() => add('a', 1)).toThrow('must be numbers');
        });
    });

    // divide() tests
    t.describe('divide()', () => {
        t.test('divides correctly', () => {
            t.expect(divide(10, 2)).toBe(5);
            t.expect(divide(7, 2)).toBe(3.5);
        });
        t.test('throws on zero denominator', () => {
            t.expect(() => divide(5, 0)).toThrow('Division by zero');
        });
    });

    // capitalize() tests
    t.describe('capitalize()', () => {
        t.test('capitalizes first letter', () => {
            t.expect(capitalize('hello')).toBe('Hello');
        });
        t.test('lowercases rest', () => {
            t.expect(capitalize('hELLO')).toBe('Hello');
        });
        t.test('handles empty string', () => {
            t.expect(capitalize('')).toBe('');
        });
        t.test('throws on non-string', () => {
            t.expect(() => capitalize(42)).toThrow('Must be a string');
        });
    });

    // groupBy() tests
    t.describe('groupBy()', () => {
        const items = [
            { type: 'fruit', name: 'apple' },
            { type: 'veg', name: 'carrot' },
            { type: 'fruit', name: 'banana' },
        ];
        t.test('groups by string key', async () => {
            const result = groupBy(items, 'type');
            t.expect(result.fruit).toHaveLength(2);
            t.expect(result.veg).toHaveLength(1);
        });
        t.test('groups by function', async () => {
            const nums = [1, 2, 3, 4, 5, 6];
            const result = groupBy(nums, n => n % 2 === 0 ? 'even' : 'odd');
            t.expect(result.even).toEqual([2, 4, 6]);
            t.expect(result.odd).toEqual([1, 3, 5]);
        });
    });

    // async tests
    t.describe('fetchUser()', () => {
        await t.test('resolves valid id', async () => {
            const user = await fetchUser(1);
            t.expect(user.id).toBe(1);
            t.expect(user.name).toBe('User1');
        });
        await t.test('rejects invalid id', async () => {
            await t.expect(fetchUser(-1)).rejects.toThrow('Invalid ID');
        });
        await t.test('rejects not found', async () => {
            await t.expect(fetchUser(999)).rejects.toThrow('not found');
        });
    });

    t.printResults();
})();

📝 KEY POINTS:
✅ describe() groups related tests; test() or it() defines a single test
✅ expect(actual).toBe(expected) for primitives; .toEqual() for deep object comparison
✅ Use async/await in test functions for async code — or return the promise
✅ .resolves and .rejects matchers test Promise outcomes cleanly
✅ jest.fn() creates mock functions; .mockReturnValue() / .mockResolvedValue() set return values
✅ beforeEach/afterEach run setup/cleanup before/after every test in the suite
✅ jest.mock('./module') replaces an entire module with mocked versions
✅ Run only failing tests during development with test.only() or --testNamePattern
✅ Aim for 80%+ coverage — focus on branches, not just lines
❌ Don't test implementation details — test observable behavior
❌ Don't use toBe() for objects or arrays — use toEqual() for deep comparison
❌ Don't forget to await async test helpers — silent failures look like passes
❌ Don't mock everything — integration tests with real dependencies catch more bugs
""",
  quiz: [
    Quiz(question: 'What is the difference between expect().toBe() and expect().toEqual()?', options: [
      QuizOption(text: 'toBe() uses === (reference equality); toEqual() does deep value comparison (works for objects and arrays)', correct: true),
      QuizOption(text: 'toEqual() is more strict — it also checks the prototype chain', correct: false),
      QuizOption(text: 'toBe() only works for primitives; toEqual() only works for objects', correct: false),
      QuizOption(text: 'They are identical — toEqual() is just a more readable alias for toBe()', correct: false),
    ]),
    Quiz(question: 'How do you test that an async function rejects with a specific error?', options: [
      QuizOption(text: 'await expect(asyncFn()).rejects.toThrow("error message")', correct: true),
      QuizOption(text: 'expect(asyncFn()).toThrow("error message") — async is handled automatically', correct: false),
      QuizOption(text: 'asyncFn().catch(e => expect(e.message).toBe("error")) without awaiting', correct: false),
      QuizOption(text: 'Use a try/catch inside the test — Jest doesn\'t support async matchers', correct: false),
    ]),
    Quiz(question: 'What does beforeEach() do in a Jest test suite?', options: [
      QuizOption(text: 'Runs the provided function before every individual test in the current describe block', correct: true),
      QuizOption(text: 'Runs once before all tests in the file — equivalent to beforeAll()', correct: false),
      QuizOption(text: 'Specifies setup code that only runs if the previous test passed', correct: false),
      QuizOption(text: 'Defines the order in which tests should run within the describe block', correct: false),
    ]),
  ],
);
