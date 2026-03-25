import '../../models/lesson.dart';
import '../../models/quiz.dart';

final jsLesson31 = Lesson(
  language: 'JavaScript',
  title: 'Internationalization (Intl API)',
  content: """
🎯 METAPHOR:
The Intl API is like a professional translator who also
understands local culture. Not just language, but CONTEXT.
"1,234.56" in the US means one thousand two hundred
thirty-four point five six. The SAME number in Germany
is written "1.234,56". A French person writing a date
says "15 janvier 2024", not "January 15, 2024". The Intl
API handles all of this automatically — you say "format
this number for this locale" and it produces exactly what
a native speaker would write. No hardcoding, no
if(locale === 'de') spaghetti — just locale-aware output.

📖 EXPLANATION:
The Intl object is JavaScript's built-in Internationalization
API for locale-sensitive formatting of numbers, dates,
relative times, lists, and more.

─────────────────────────────────────
LOCALE IDENTIFIERS:
─────────────────────────────────────
  "en"         → English (any region)
  "en-US"      → English (United States)
  "en-GB"      → English (United Kingdom)
  "fr"         → French
  "fr-FR"      → French (France)
  "fr-CA"      → French (Canada)
  "de-DE"      → German (Germany)
  "ja-JP"      → Japanese (Japan)
  "zh-CN"      → Chinese Simplified (China)
  "ar-SA"      → Arabic (Saudi Arabia)
  "hi-IN"      → Hindi (India)

  Intl.supportedValuesOf('calendar')  → supported calendars
  Intl.supportedValuesOf('currency')  → supported currencies

─────────────────────────────────────
Intl.NumberFormat:
─────────────────────────────────────
  new Intl.NumberFormat(locale, options).format(number)

  Options:
  style:    'decimal' | 'currency' | 'percent' | 'unit'
  currency: 'USD' | 'EUR' | 'GBP' | 'JPY' | ...
  currencyDisplay: 'symbol' | 'code' | 'name'
  minimumFractionDigits: n
  maximumFractionDigits: n
  useGrouping: true/false
  notation: 'standard' | 'scientific' | 'engineering' | 'compact'
  unit: 'kilometer' | 'liter' | 'celsius' | ...
  unitDisplay: 'short' | 'long' | 'narrow'

─────────────────────────────────────
Intl.DateTimeFormat:
─────────────────────────────────────
  new Intl.DateTimeFormat(locale, options).format(date)

  Options (all optional):
  dateStyle: 'full' | 'long' | 'medium' | 'short'
  timeStyle: 'full' | 'long' | 'medium' | 'short'
  year:    'numeric' | '2-digit'
  month:   'numeric' | '2-digit' | 'long' | 'short' | 'narrow'
  day:     'numeric' | '2-digit'
  weekday: 'long' | 'short' | 'narrow'
  hour, minute, second
  timeZone: 'America/New_York' | 'Europe/London' | 'UTC' | ...
  hour12: true | false

─────────────────────────────────────
Intl.RelativeTimeFormat:
─────────────────────────────────────
  new Intl.RelativeTimeFormat(locale, { numeric: 'auto' })
      .format(-3, 'day')   // "3 days ago"
      .format(2, 'week')   // "in 2 weeks"
      .format(-1, 'day')   // "yesterday" (with numeric: 'auto')
      .format(0,  'day')   // "today"
      .format(1,  'day')   // "tomorrow"

─────────────────────────────────────
Intl.ListFormat:
─────────────────────────────────────
  new Intl.ListFormat('en', { style: 'long', type: 'conjunction' })
      .format(['Alice', 'Bob', 'Carol'])
  // "Alice, Bob, and Carol"

  new Intl.ListFormat('fr', { type: 'conjunction' })
      .format(['Alice', 'Bob', 'Carol'])
  // "Alice, Bob et Carol"

─────────────────────────────────────
Intl.Collator — locale-aware sorting:
─────────────────────────────────────
  const collator = new Intl.Collator('de');
  ['ä', 'z', 'a'].sort(collator.compare)
  // ['a', 'ä', 'z']  — German alphabetical order

─────────────────────────────────────
Intl.PluralRules — pluralization:
─────────────────────────────────────
  const pr = new Intl.PluralRules('en');
  pr.select(0)   // "other" → "0 items"
  pr.select(1)   // "one"   → "1 item"
  pr.select(2)   // "other" → "2 items"

  // Arabic has 6 plural forms!
  const arPR = new Intl.PluralRules('ar');
  arPR.select(0)   // "zero"
  arPR.select(1)   // "one"
  arPR.select(2)   // "two"
  arPR.select(5)   // "few"
  arPR.select(11)  // "many"
  arPR.select(100) // "other"

─────────────────────────────────────
Intl.Segmenter — text segmentation:
─────────────────────────────────────
  // Split text into words/sentences/graphemes properly:
  const segmenter = new Intl.Segmenter('en', { granularity: 'word' });
  const words = [...segmenter.segment("Hello world!")];
  // [{segment:'Hello',...}, {segment:' ',...}, {segment:'world',...}]

  // Useful for: proper word counting, text selection in editors

💻 CODE:
// ─── NUMBER FORMAT ────────────────────────────────────
console.log("=== Intl.NumberFormat ===");

const amount = 1234567.89;
const locales = ['en-US', 'en-GB', 'de-DE', 'fr-FR', 'ja-JP', 'ar-SA'];

console.log("  Decimal formatting:");
locales.forEach(locale => {
    const formatted = new Intl.NumberFormat(locale).format(amount);
    console.log(\`    ${
locale.padEnd(8)}: ${
formatted}\`);
});

console.log("\n  Currency formatting:");
const currencies = [
    ['en-US', 'USD'], ['en-GB', 'GBP'], ['de-DE', 'EUR'],
    ['ja-JP', 'JPY'], ['fr-FR', 'EUR']
];
currencies.forEach(([locale, currency]) => {
    const formatted = new Intl.NumberFormat(locale, {
        style: 'currency', currency
    }).format(amount);
    console.log(\`    ${
locale.padEnd(8)} ${
currency}: ${
formatted}\`);
});

console.log("\n  Compact notation:");
[0, 999, 1200, 999000, 1200000, 1500000000].forEach(n => {
    const formatted = new Intl.NumberFormat('en-US', {
        notation: 'compact', maximumFractionDigits: 1
    }).format(n);
    console.log(\`    ${
String(n).padStart(12)}: ${
formatted}\`);
});

console.log("\n  Unit formatting:");
const units = [
    [42.5, 'kilometer', 'en-US'],
    [42.5, 'kilometer', 'de-DE'],
    [72,   'celsius',   'en-US'],
    [72,   'fahrenheit','en-US'],
    [2.5,  'liter',     'fr-FR'],
];
units.forEach(([n, unit, locale]) => {
    const formatted = new Intl.NumberFormat(locale, {
        style: 'unit', unit, unitDisplay: 'long'
    }).format(n);
    console.log(\`    ${
formatted}\`);
});

// ─── DATE FORMAT ──────────────────────────────────────
console.log("\n=== Intl.DateTimeFormat ===");

const date = new Date("2024-06-15T14:30:00Z");

const dateFormats = [
    ['en-US', { dateStyle: 'full' }],
    ['en-GB', { dateStyle: 'long' }],
    ['de-DE', { dateStyle: 'medium' }],
    ['ja-JP', { dateStyle: 'long' }],
    ['fr-FR', { dateStyle: 'long' }],
    ['ar-SA', { dateStyle: 'long' }],
];
dateFormats.forEach(([locale, opts]) => {
    const formatted = new Intl.DateTimeFormat(locale, opts).format(date);
    console.log(\`  ${
locale.padEnd(8)}: ${
formatted}\`);
});

console.log("\n  Custom formats:");
const custom = [
    [{ weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' }, 'en-US'],
    [{ month: 'short', day: 'numeric', hour: '2-digit', minute: '2-digit' }, 'en-US'],
    [{ year: 'numeric', month: '2-digit', day: '2-digit' }, 'zh-CN'],
];
custom.forEach(([opts, locale]) => {
    console.log(\`  ${
new Intl.DateTimeFormat(locale, opts).format(date)}\`);
});

// formatToParts for individual components:
const parts = new Intl.DateTimeFormat('en-US', { dateStyle: 'long' }).formatToParts(date);
console.log("  Parts:", parts.map(p => \`${
p.type}:${
p.value}\`).join(', '));

// ─── RELATIVE TIME ────────────────────────────────────
console.log("\n=== Intl.RelativeTimeFormat ===");

const rtf = new Intl.RelativeTimeFormat('en', { numeric: 'auto' });
const rtfEs = new Intl.RelativeTimeFormat('es', { numeric: 'auto' });

const relTimes = [
    [-1, 'day'], [0, 'day'], [1, 'day'],
    [-3, 'day'], [7, 'day'],
    [-2, 'month'], [1, 'year'],
    [-1, 'hour'], [30, 'minute'],
];
relTimes.forEach(([n, unit]) => {
    console.log(\`  en: ${
rtf.format(n, unit).padEnd(20)} | es: ${
rtfEs.format(n, unit)}\`);
});

// Build a "time ago" function:
function timeAgo(date, locale = 'en') {
    const rtf  = new Intl.RelativeTimeFormat(locale, { numeric: 'auto' });
    const now  = Date.now();
    const diff = date.getTime() - now;
    const abs  = Math.abs(diff);

    const units = [
        [60 * 1000,       'second', 1000],
        [3600 * 1000,     'minute', 60 * 1000],
        [86400 * 1000,    'hour',   3600 * 1000],
        [604800 * 1000,   'day',    86400 * 1000],
        [2592000 * 1000,  'week',   604800 * 1000],
        [31536000 * 1000, 'month',  2592000 * 1000],
        [Infinity,        'year',   31536000 * 1000],
    ];

    for (const [threshold, unit, divisor] of units) {
        if (abs < threshold) {
            return rtf.format(Math.round(diff / divisor), unit);
        }
    }
}

const past   = new Date(Date.now() - 3 * 86400000);  // 3 days ago
const future = new Date(Date.now() + 7 * 86400000);  // 7 days from now
console.log(\`  timeAgo(3 days ago): ${
timeAgo(past)}\`);
console.log(\`  timeAgo(7 days from now): ${
timeAgo(future)}\`);

// ─── LIST FORMAT ──────────────────────────────────────
console.log("\n=== Intl.ListFormat ===");

const items = ['Alice', 'Bob', 'Carol', 'Dave'];
const listFormats = [
    ['en', 'conjunction'],  // Alice, Bob, Carol, and Dave
    ['en', 'disjunction'],  // Alice, Bob, Carol, or Dave
    ['fr', 'conjunction'],  // Alice, Bob, Carol et Dave
    ['de', 'conjunction'],
    ['ja', 'conjunction'],
];
listFormats.forEach(([locale, type]) => {
    const formatted = new Intl.ListFormat(locale, { type }).format(items);
    console.log(\`  ${
locale.padEnd(4)} ${
type.padEnd(14)}: ${
formatted}\`);
});

// ─── PLURAL RULES ─────────────────────────────────────
console.log("\n=== Intl.PluralRules ===");

function pluralize(n, forms, locale = 'en') {
    const rule = new Intl.PluralRules(locale).select(n);
    return forms[rule] || forms.other;
}

// English: {one: '_ item', other: '_ items'}
const enForms = { one: '# item', other: '# items' };
[0, 1, 2, 5, 100].forEach(n => {
    const text = pluralize(n, enForms).replace('#', n);
    console.log(\`  en: ${
n} → ${
text}\`);
});

// ─── COLLATION ────────────────────────────────────────
console.log("\n=== Intl.Collator (locale-aware sort) ===");

const names = ['Ångström', 'Zebra', 'äpfel', 'Apple', 'über', 'zoo'];

console.log("  Default (Unicode):", [...names].sort());
console.log("  German (de):      ", [...names].sort(new Intl.Collator('de').compare));
console.log("  Swedish (sv):     ", [...names].sort(new Intl.Collator('sv').compare));

📝 KEY POINTS:
✅ Intl.NumberFormat formats numbers, currencies, percentages, and units locale-appropriately
✅ Intl.DateTimeFormat formats dates and times with locale, timezone, and style options
✅ Intl.RelativeTimeFormat gives "3 days ago" / "in 2 weeks" in any language
✅ Intl.ListFormat joins lists naturally: "Alice, Bob, and Carol" vs "Alice, Bob, or Carol"
✅ Intl.PluralRules handles the plural forms of every language (Arabic has 6!)
✅ Intl.Collator provides locale-aware string sorting — ä sorts differently in German vs English
✅ formatToParts() gives individual parts of a formatted date/number for custom styling
✅ All Intl constructors accept a locale string (e.g. "en-US", "de-DE") and an options object
❌ Don't format numbers or dates with manual string operations — use Intl
❌ Don't assume decimal separator is "." — it's "," in German, French, and many other locales
❌ Intl.Segmenter is not available in all browsers yet — check compatibility
❌ Don't hardcode plural rules (1 item, N items) — languages have complex plural forms
""",
  quiz: [
    Quiz(question: 'What does Intl.RelativeTimeFormat with { numeric: "auto" } provide?', options: [
      QuizOption(text: 'Human-friendly strings like "yesterday", "today", "tomorrow" instead of "-1 day", "0 days", "1 day"', correct: true),
      QuizOption(text: 'Automatic detection of the best time unit based on the magnitude', correct: false),
      QuizOption(text: 'Automatic locale detection from the browser settings', correct: false),
      QuizOption(text: 'Numeric precision control for relative time values', correct: false),
    ]),
    Quiz(question: 'Why should you use Intl.NumberFormat instead of hardcoded number formatting?', options: [
      QuizOption(text: 'Different locales use different decimal/thousand separators — Intl handles all cases correctly', correct: true),
      QuizOption(text: 'Intl.NumberFormat is faster than manual string formatting', correct: false),
      QuizOption(text: 'Number formatting requires special permissions in browsers', correct: false),
      QuizOption(text: 'Hardcoded formatting only works for numbers less than 1 million', correct: false),
    ]),
    Quiz(question: 'What does Intl.PluralRules.select() return?', options: [
      QuizOption(text: 'A plural category string like "one", "other", "few", "many" — used to pick the correct translation form', correct: true),
      QuizOption(text: 'The plural form of the number as a formatted string', correct: false),
      QuizOption(text: 'The grammatical gender of the number in the given locale', correct: false),
      QuizOption(text: 'A boolean — true if the number requires plural form, false for singular', correct: false),
    ]),
  ],
);
