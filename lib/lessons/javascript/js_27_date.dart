import '../../models/lesson.dart';
import '../../models/quiz.dart';

final jsLesson27 = Lesson(
  language: 'JavaScript',
  title: 'Date and Temporal API',
  content: """
🎯 METAPHOR:
JavaScript's Date is like an old analog clock that only
shows UTC time but displays in whatever time zone you're
in — inconsistently, depending on the environment. It
was designed in 10 days in 1995 and it shows: months
are 0-indexed, dates are mutable, and time zones are
treacherous. The Temporal API (Stage 3, coming to browsers)
is the Swiss precision atomic clock replacement: immutable,
unambiguous, time-zone-aware, with a clean modern API.
Until Temporal is universally available, we use Date with
careful practices — or the temporal-polyfill package.

📖 EXPLANATION:
The Date object is JavaScript's built-in for date/time.
The Temporal API (Stage 3 proposal) will replace it.

─────────────────────────────────────
CREATING DATES:
─────────────────────────────────────
  new Date()                  → now
  new Date(timestamp)         → from milliseconds since epoch
  new Date("2024-01-15")      → from ISO string
  new Date(2024, 0, 15)       → Jan 15, 2024 (month is 0-indexed!)
  new Date(2024, 0, 15, 14, 30, 0)  → with time
  Date.now()                  → current timestamp (ms)

─────────────────────────────────────
GETTING VALUES:
─────────────────────────────────────
  d.getFullYear()     → 4-digit year
  d.getMonth()        → 0-11 (⚠️ 0=Jan, 11=Dec)
  d.getDate()         → 1-31 (day of month)
  d.getDay()          → 0-6 (0=Sunday, 6=Saturday)
  d.getHours()        → 0-23
  d.getMinutes()      → 0-59
  d.getSeconds()      → 0-59
  d.getMilliseconds() → 0-999
  d.getTime()         → ms since epoch (Unix timestamp * 1000)

  // UTC versions:
  d.getUTCFullYear(), d.getUTCMonth(), d.getUTCDate()...

─────────────────────────────────────
SETTING VALUES (mutations!):
─────────────────────────────────────
  d.setFullYear(2025)
  d.setMonth(5)        // June (0-indexed)
  d.setDate(15)        // day of month
  d.setHours(14)
  d.setMinutes(30)
  // etc. — all mutate the Date object

─────────────────────────────────────
FORMATTING:
─────────────────────────────────────
  d.toISOString()         → "2024-01-15T14:30:00.000Z"
  d.toLocaleDateString()  → locale-specific (e.g. "1/15/2024")
  d.toLocaleTimeString()  → locale-specific time
  d.toLocaleString()      → date + time
  d.toString()            → full string with timezone
  d.toDateString()        → "Mon Jan 15 2024"
  d.toTimeString()        → "14:30:00 GMT+0000"
  d.toUTCString()         → "Mon, 15 Jan 2024 14:30:00 GMT"

  // Intl.DateTimeFormat for proper formatting:
  new Intl.DateTimeFormat('en-US', {
      year: 'numeric', month: 'long', day: 'numeric'
  }).format(d)
  // → "January 15, 2024"

─────────────────────────────────────
DATE ARITHMETIC:
─────────────────────────────────────
  // Add days:
  const tomorrow = new Date(Date.now() + 24 * 60 * 60 * 1000);

  // Difference in days:
  const diff = (date2 - date1) / (1000 * 60 * 60 * 24);

  // Compare:
  date1 < date2   // compare as numbers (timestamps)
  date1.getTime() === date2.getTime()  // equality

─────────────────────────────────────
THE TEMPORAL API (Stage 3, use polyfill):
─────────────────────────────────────
  import { Temporal } from '@js-temporal/polyfill';

  // All Temporal objects are IMMUTABLE
  const today    = Temporal.Now.plainDateISO();
  const now      = Temporal.Now.zonedDateTimeISO();

  // Types:
  Temporal.PlainDate       → date only (no time)
  Temporal.PlainTime       → time only (no date)
  Temporal.PlainDateTime   → date + time (no timezone)
  Temporal.ZonedDateTime   → date + time + timezone
  Temporal.Instant         → machine timestamp
  Temporal.Duration        → amount of time
  Temporal.PlainYearMonth  → year-month only
  Temporal.PlainMonthDay   → month-day (anniversary)

  // Arithmetic (returns new objects):
  today.add({ days: 7 })
  today.subtract({ months: 1 })
  today.until(futureDate)   // duration
  today.with({ year: 2025 })

─────────────────────────────────────
COMMON DATE PATTERNS:
─────────────────────────────────────
  // Months are 0-indexed — ALWAYS use constants:
  const MONTHS = ['Jan','Feb','Mar','Apr','May','Jun',
                  'Jul','Aug','Sep','Oct','Nov','Dec'];

  // Parse ISO date safely:
  function parseDate(str) {
      const [y, m, d] = str.split('-').map(Number);
      return new Date(y, m - 1, d);  // m-1 for 0-index
  }

  // Format date:
  function formatDate(date) {
      return date.toLocaleDateString('en-GB', {
          day: '2-digit', month: 'short', year: 'numeric'
      });
  }

💻 CODE:
// ─── DATE CREATION ────────────────────────────────────
console.log("=== Creating Dates ===");

const now      = new Date();
const epoch    = new Date(0);          // Jan 1, 1970
const iso      = new Date("2024-06-15T14:30:00Z");
const ymd      = new Date(2024, 5, 15);  // June 15 (month 5!)
const withTime = new Date(2024, 5, 15, 14, 30, 0);

console.log("  Now:       ", now.toISOString());
console.log("  Epoch:     ", epoch.toISOString());
console.log("  From ISO:  ", iso.toISOString());
console.log("  From Y/M/D:", ymd.toDateString());  // June not May ✅

// getMonth() pitfall:
const d = new Date(2024, 0, 15);  // January
console.log("  getMonth():", d.getMonth(), "(0 = January)");
console.log("  getDate(): ", d.getDate());
console.log("  getDay():  ", d.getDay(), "(0 = Sunday)");

// ─── READING DATE VALUES ──────────────────────────────
console.log("\n=== Reading Values ===");

const target = new Date("2024-06-15T14:30:45.123Z");
console.log("  getFullYear(): ", target.getFullYear());
console.log("  getMonth():    ", target.getMonth(), "→ June is 5");
console.log("  getDate():     ", target.getDate());
console.log("  getHours():    ", target.getUTCHours(), "(UTC)");
console.log("  getMinutes():  ", target.getUTCMinutes(), "(UTC)");
console.log("  getTime():     ", target.getTime(), "ms since epoch");
console.log("  Date.now():    ", Date.now());

// ─── FORMATTING ───────────────────────────────────────
console.log("\n=== Formatting ===");

const date = new Date("2024-06-15T14:30:00Z");
console.log("  toISOString():  ", date.toISOString());
console.log("  toDateString(): ", date.toDateString());
console.log("  toUTCString():  ", date.toUTCString());

// Intl.DateTimeFormat (correct way):
const formats = [
    [{ dateStyle: 'short' },  'en-US'],
    [{ dateStyle: 'long' },   'en-US'],
    [{ dateStyle: 'full' },   'en-GB'],
    [{ dateStyle: 'long' },   'fr-FR'],
    [{ dateStyle: 'long' },   'ja-JP'],
    [{ timeStyle: 'short' },  'en-US'],
    [{ dateStyle: 'medium', timeStyle: 'short' }, 'en-US'],
];

formats.forEach(([opts, locale]) => {
    const formatted = new Intl.DateTimeFormat(locale, opts).format(date);
    console.log(` \${locale}\${JSON.stringify(opts).slice(0,30)}:\${formatted}`);
});

// ─── DATE ARITHMETIC ──────────────────────────────────
console.log("\n=== Date Arithmetic ===");

function addDays(date, n) {
    return new Date(date.getTime() + n * 86400000);
}
function addMonths(date, n) {
    const d = new Date(date);
    d.setMonth(d.getMonth() + n);
    return d;
}
function daysDiff(a, b) {
    return Math.round((b - a) / 86400000);
}
function isLeapYear(year) {
    return (year % 4 === 0 && year % 100 !== 0) || year % 400 === 0;
}

const today = new Date("2024-01-15");
const nextWeek  = addDays(today, 7);
const lastMonth = addMonths(today, -1);
const birthday  = new Date("2024-06-15");

console.log("  Today:      ", today.toDateString());
console.log("  +7 days:    ", nextWeek.toDateString());
console.log("  -1 month:   ", lastMonth.toDateString());
console.log("  Days to birthday:", daysDiff(today, birthday));
console.log("  2024 is leap year:", isLeapYear(2024));
console.log("  2023 is leap year:", isLeapYear(2023));

// ─── COMPARISON ───────────────────────────────────────
console.log("\n=== Comparing Dates ===");

const d1 = new Date("2024-01-01");
const d2 = new Date("2024-06-15");
const d3 = new Date("2024-01-01");

console.log("  d1 < d2:", d1 < d2);                         // true
console.log("  d1 === d3:", d1 === d3);                      // false (different refs)
console.log("  d1.getTime() === d3.getTime():", d1.getTime() === d3.getTime()); // true ✅

// Sort dates:
const dates = [
    new Date("2024-03-15"),
    new Date("2024-01-01"),
    new Date("2024-12-31"),
    new Date("2024-06-15"),
];
dates.sort((a, b) => a - b);
console.log("  Sorted:", dates.map(d => d.toDateString()));

// ─── UTILITIES ────────────────────────────────────────
console.log("\n=== Useful Date Utilities ===");

function startOfDay(date) {
    const d = new Date(date);
    d.setHours(0, 0, 0, 0);
    return d;
}

function endOfDay(date) {
    const d = new Date(date);
    d.setHours(23, 59, 59, 999);
    return d;
}

function startOfMonth(date) {
    return new Date(date.getFullYear(), date.getMonth(), 1);
}

function endOfMonth(date) {
    return new Date(date.getFullYear(), date.getMonth() + 1, 0);
}

function isSameDay(a, b) {
    return a.toDateString() === b.toDateString();
}

function isWeekend(date) {
    const day = date.getDay();
    return day === 0 || day === 6;
}

const sample = new Date("2024-06-15T14:30:00");
console.log("  startOfDay:", startOfDay(sample).toISOString());
console.log("  endOfDay:  ", endOfDay(sample).toISOString());
console.log("  startOfMonth:", startOfMonth(sample).toDateString());
console.log("  endOfMonth:  ", endOfMonth(sample).toDateString());
console.log("  isSameDay(today, today):", isSameDay(sample, sample));
console.log("  isWeekend(June 15, 2024):", isWeekend(sample));  // Saturday

// ─── TEMPORAL API PREVIEW ─────────────────────────────
console.log("\n=== Temporal API (coming soon) ===");
console.log("  The Temporal API (Stage 3) will provide:");
console.log("  ✅ Temporal.PlainDate — date without time");
console.log("  ✅ Temporal.ZonedDateTime — with proper timezone");
console.log("  ✅ Temporal.Duration — precise duration arithmetic");
console.log("  ✅ All immutable — no more mutation bugs");
console.log("  ✅ Months are 1-indexed (January = 1, not 0)");
console.log("  ✅ Available via: @js-temporal/polyfill");
console.log("");
console.log("  Example (when available):");
console.log('  const d = Temporal.PlainDate.from("2024-06-15")');
console.log("  d.add({ days: 7 })           // returns NEW date");
console.log("  d.month  // 6 (not 5!)");
console.log("  d.until(other).days         // clean duration");

📝 KEY POINTS:
✅ new Date() creates a mutable date — use Date.now() for just the timestamp
✅ Months are 0-indexed (0=Jan, 11=Dec) — always account for this
✅ getDay() returns 0-6 where 0=Sunday, not Monday
✅ Use Intl.DateTimeFormat for locale-aware formatting — not toLocaleDateString() alone
✅ Compare dates with < > or .getTime() equality — === compares references
✅ Date arithmetic: add milliseconds (1 day = 86400000ms) or use setDate/setMonth
✅ startOfDay/endOfDay patterns are useful for date range queries
✅ The Temporal API (Stage 3) fixes all Date issues — use @js-temporal/polyfill today
✅ Use toISOString() for serialization — it always gives UTC ISO 8601
❌ new Date(2024, 5, 15) is June 15 not May 15 — months are 0-based
❌ date1 === date2 always false for two Date objects — use .getTime() for equality
❌ Date objects are mutable — setDate() etc. modify in place — clone before mutating
❌ Date has no concept of "date only" — always carries a time component (midnight)
""",
  quiz: [
    Quiz(question: 'What does new Date(2024, 0, 15) create?', options: [
      QuizOption(text: 'January 15, 2024 — month 0 is January in the Date constructor', correct: true),
      QuizOption(text: 'February 15, 2024 — month 0 is a placeholder and the first real month is 1', correct: false),
      QuizOption(text: 'December 15, 2024 — month indexing wraps around', correct: false),
      QuizOption(text: 'It throws a RangeError — month 0 is invalid', correct: false),
    ]),
    Quiz(question: 'How do you correctly compare two Date objects for equality?', options: [
      QuizOption(text: 'date1.getTime() === date2.getTime() — comparing their numeric timestamps', correct: true),
      QuizOption(text: 'date1 === date2 — the equality operator compares their values', correct: false),
      QuizOption(text: 'date1.equals(date2) — the Date class has an equals() method', correct: false),
      QuizOption(text: 'date1.toString() === date2.toString() — string comparison', correct: false),
    ]),
    Quiz(question: 'What is the main improvement of the Temporal API over the Date object?', options: [
      QuizOption(text: 'Temporal objects are immutable, months are 1-indexed, and it has proper timezone support', correct: true),
      QuizOption(text: 'Temporal is faster than Date because it uses native optimizations', correct: false),
      QuizOption(text: 'Temporal replaces Date entirely and Date will be removed from JavaScript', correct: false),
      QuizOption(text: 'Temporal only adds timezone support — everything else is identical to Date', correct: false),
    ]),
  ],
);
