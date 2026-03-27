import '../../models/lesson.dart';
import '../../models/quiz.dart';

final jsLesson25 = Lesson(
  language: 'JavaScript',
  title: 'Regular Expressions',
  content: """
🎯 METAPHOR:
A regular expression is like a metal cookie cutter for
text. The cutter has a very specific shape — "digits,
then a dash, then four digits" — and you drag it through
a string of text. Wherever the shape fits exactly,
you've found a match. You can use the cutter to TEST
if a pattern exists, EXTRACT the matching pieces,
REPLACE the match with something else, or SPLIT the
text wherever the cutter fits. The cutter is the regex
pattern. The text is the dough. The result depends on
which operation you choose.

📖 EXPLANATION:
Regular expressions (regex) are patterns for matching
text. In JavaScript they're a built-in primitive type.

─────────────────────────────────────
CREATING REGEX:
─────────────────────────────────────
  const re1 = /pattern/flags;          // literal (preferred)
  const re2 = new RegExp('pattern', 'flags');  // constructor

  // Constructor useful for dynamic patterns:
  const word = "hello";
  const re = new RegExp(\`\\\\b\${word}\\\\b\`, 'gi');

─────────────────────────────────────
FLAGS:
─────────────────────────────────────
  g  → global — find ALL matches (not just first)
  i  → case insensitive
  m  → multiline — ^ and\$ match line start/end
  s  → dotAll — . matches newline too
  u  → unicode — full unicode support
  y  → sticky — match only at lastIndex
  d  → indices — include match start/end indices

  /hello/gi  → global, case-insensitive

─────────────────────────────────────
CHARACTER CLASSES:
─────────────────────────────────────
  .         → any char except newline
  \\d        → digit [0-9]
  \\D        → non-digit
  \\w        → word char [a-zA-Z0-9_]
  \\W        → non-word char
  \\s        → whitespace
  \\S        → non-whitespace
  [abc]     → a, b, or c
  [^abc]    → NOT a, b, or c
  [a-z]     → a through z

  Unicode:
  \\p{Letter}   → any Unicode letter (with /u flag)
  \\p{Decimal_Number} → decimal number

─────────────────────────────────────
QUANTIFIERS:
─────────────────────────────────────
  *         → 0 or more (greedy)
  +         → 1 or more (greedy)
  ?         → 0 or 1
  {n}       → exactly n
  {n,}      → n or more
  {n,m}     → between n and m
  *?        → 0 or more (lazy)
  +?        → 1 or more (lazy)

─────────────────────────────────────
ANCHORS:
─────────────────────────────────────
  ^         → start of string/line
  \$         → end of string/line
  \\b        → word boundary
  \\B        → non-word boundary
  (?=...)   → lookahead: followed by
  (?!...)   → negative lookahead
  (?<=...)  → lookbehind: preceded by
  (?<!...)  → negative lookbehind

─────────────────────────────────────
GROUPS:
─────────────────────────────────────
  (abc)       → capturing group
  (?:abc)     → non-capturing group
  (?<name>...) → named capturing group
  a|b         → alternation (a or b)

─────────────────────────────────────
JAVASCRIPT REGEX METHODS:
─────────────────────────────────────
  // RegExp methods:
  re.test(str)        → boolean
  re.exec(str)        → match array or null

  // String methods:
  str.match(re)       → array of matches (or null)
  str.matchAll(re)    → iterator of ALL matches (g flag)
  str.search(re)      → index of first match (-1 if none)
  str.replace(re, s)  → replace first/all
  str.replaceAll(s,s) → replace all (string, no flag needed)
  str.split(re)       → split by pattern

─────────────────────────────────────
NAMED GROUPS (ES2018):
─────────────────────────────────────
  const re = /(?<year>\\d{4})-(?<month>\\d{2})-(?<day>\\d{2})/;
  const match = "2024-01-15".match(re);
  match.groups.year   // "2024"
  match.groups.month  // "01"
  match.groups.day    // "15"

  // In replace:
  "2024-01-15".replace(re, '\$<day>/\$<month>/\$<year>')
  // "15/01/2024"

─────────────────────────────────────
COMMON PATTERNS:
─────────────────────────────────────
  Email:     /^[^\\s@]+@[^\\s@]+\\.[^\\s@]+\$/
  URL:       /https?:\\/\\/[\\w.-]+(?:\\.[\\w.-]+)+[\\w./?=#&%-]*/
  Phone:     /^\\+?\\d{1,3}[-\\s.]?\\(?\\d{3}\\)?[-\\s.]?\\d{3}[-\\s.]?\\d{4}\$/
  Hex color: /^#?([0-9A-Fa-f]{6}|[0-9A-Fa-f]{3})\$/
  ISO date:  /\\d{4}-\\d{2}-\\d{2}/
  Slug:      /^[a-z0-9]+(?:-[a-z0-9]+)*\$/

💻 CODE:
// ─── BASICS ───────────────────────────────────────────
console.log("=== Regex Basics ===");

const text = "The quick brown fox jumps over the lazy dog";

console.log("  test 'fox':", /fox/.test(text));           // true
console.log("  test 'cat':", /cat/.test(text));           // false
console.log("  search:    ", text.search(/fox/));          // 16
console.log("  match:     ", text.match(/\\w+/));          // first word
console.log("  match all: ", text.match(/\\b\\w{4}\\b/g)); // all 4-letter words

// ─── FLAGS ────────────────────────────────────────────
console.log("\\n=== Flags ===");

const sentence = "Hello hello HELLO World world WORLD";
console.log("  /hello/:",  sentence.match(/hello/));         // one
console.log("  /hello/g:", sentence.match(/hello/g));        // only lowercase
console.log("  /hello/gi:",sentence.match(/hello/gi));       // all case variants
console.log("  /^hello/m:",
    "hello\\nworld".match(/^hello/m)?.toString()); // multiline

// ─── CHARACTER CLASSES ────────────────────────────────
console.log("\\n=== Character Classes ===");

const mixed = "abc123 def456 !@# ghi789";
console.log("  \\d+:", mixed.match(/\\d+/g));      // all numbers
console.log("  \\w+:", mixed.match(/\\w+/g));      // all words
console.log("  \\D+:", mixed.match(/\\D+/g));      // non-digit sequences
console.log("  [aeiou]:", mixed.match(/[aeiou]/g)); // vowels

// ─── GROUPS ───────────────────────────────────────────
console.log("\\n=== Capturing Groups ===");

// Numbered groups:
const dateStr = "Today is 2024-01-15 and tomorrow is 2024-01-16";
const dateRegex = /(\\d{4})-(\\d{2})-(\\d{2})/g;

for (const match of dateStr.matchAll(dateRegex)) {
    const [full, year, month, day] = match;
    console.log(\`  Found:\${
full} → Y:\${
year} M:\${
month} D:\${
day} (at index\${
match.index})\`);
}

// Named groups:
const emailRegex = /(?<user>[^\\s@]+)@(?<domain>[^\\s@.]+)\\.(?<tld>[^\\s@]+)/;
const email = "terry@example.com";
const emailMatch = email.match(emailRegex);
console.log("  Email:", emailMatch.groups);

// ─── REPLACE ──────────────────────────────────────────
console.log("\\n=== Replace ===");

const phrase = "foo bar foo baz foo";
console.log("  replace first:", phrase.replace("foo", "qux"));
console.log("  replace all:  ", phrase.replace(/foo/g, "qux"));

// Replace with function:
const prices = "Item: \$10, Discount: \$2, Total: \$8";
const inflated = prices.replace(/\\\$(\d+)/g, (match, amount) =>
    \`\$\${
parseInt(amount) * 1.1}\`);
console.log("  Inflated prices:", inflated);

// Reformat date:
const iso = "2024-01-15";
const formatted = iso.replace(
    /(?<y>\\d{4})-(?<m>\\d{2})-(?<d>\\d{2})/,
    '\$<d>/\$<m>/\$<y>'
);
console.log("  Reformatted:", formatted);

// ─── SPLIT ────────────────────────────────────────────
console.log("\\n=== Split ===");

const csv = "Alice  ,  Bob,Carol,   Dave  ";
const names = csv.split(/\\s*,\\s*/).map(s => s.trim());
console.log("  CSV split:", names);

const text2 = "one1two2three3four";
console.log("  Split on digit:", text2.split(/\\d/));

// ─── LOOKAHEAD / LOOKBEHIND ───────────────────────────
console.log("\\n=== Lookahead / Lookbehind ===");

// Lookahead: word followed by "ing":
const ing = "running, walking, talks, jumping, sits";
const present = ing.match(/\\w+(?=ing)/g);
console.log("  Before -ing:", present);

// Negative lookahead: word NOT followed by "ing":
const notIng = ing.match(/\\b\\w+\\b(?!ing)/g);
console.log("  NOT before -ing:", notIng);

// Lookbehind: digits preceded by \$:
const money = "Price: \$100, code: 200, tax: \$15";
const amounts = money.match(/(?<=\\\$)\\d+/g);
console.log("  Dollar amounts:", amounts);

// ─── PRACTICAL EXAMPLES ───────────────────────────────
console.log("\\n=== Practical Patterns ===");

function validate(pattern, value, name) {
    const result = pattern.test(value);
    console.log(\` \${
name}: '\${
value}' →\${
result ? '✅' : '❌'}\`);
    return result;
}

const EMAIL_RE   = /^[^\\s@]+@[^\\s@]+\\.[^\\s@]{2,}\$/;
const PHONE_RE   = /^\\+?\\d{1,3}[-\\s.]?\\(?\\d{3}\\)?[-\\s.]?\\d{3,4}[-\\s.]?\\d{4}\$/;
const SLUG_RE    = /^[a-z0-9]+(?:-[a-z0-9]+)*\$/;
const HEX_RE     = /^#?([0-9A-Fa-f]{6}|[0-9A-Fa-f]{3})\$/;
const STRONG_PW  = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@\$!%*?&])[A-Za-z\\d@\$!%*?&]{8,}\$/;

validate(EMAIL_RE, "terry@example.com", "Email");
validate(EMAIL_RE, "not-an-email", "Email");
validate(SLUG_RE,  "my-awesome-page", "Slug");
validate(SLUG_RE,  "My Awesome Page!", "Slug");
validate(HEX_RE,   "#FF5733", "Hex color");
validate(HEX_RE,   "ZZZZZZ", "Hex color");
validate(STRONG_PW,"MyP@ss1!", "Password");
validate(STRONG_PW,"weak", "Password");

// Slugify function:
const slugify = str => str
    .toLowerCase()
    .trim()
    .replace(/[^\\w\\s-]/g, '')
    .replace(/[\\s_-]+/g, '-')
    .replace(/^-+|-+\$/g, '');

const titles = ["  Hello, World!  ", "ES6+ Features & Syntax", "Node.js 101"];
titles.forEach(t => console.log(\`  slugify: "\${t}" → "\${slugify(t)}"\`));


📝 KEY POINTS:
✅ Regex literals /pattern/flags are preferred over new RegExp() for static patterns
✅ g flag finds ALL matches; without it, only the first is found
✅ Use str.matchAll(re) with g flag for an iterator of ALL matches with groups
✅ Named groups (?<name>...) make patterns self-documenting
✅ Lookahead (?=...) and lookbehind (?<=...) match without consuming characters
✅ String.replace() with a function callback gives full control over replacements
✅ Test regex patterns at regex101.com — it explains them visually
✅ Use non-capturing groups (?:...) when you don't need the group's value
❌ Greedy quantifiers (.+) grab as much as possible — use lazy (.+?) to grab minimum
❌ Don't forget to escape special chars in RegExp() constructor strings: \\\\d not \\d
❌ Reusing a regex with g flag across multiple calls changes lastIndex — can cause bugs
❌ Complex nested quantifiers can cause catastrophic backtracking — keep patterns simple
""",
  quiz: [
    Quiz(question: 'What is the difference between /hello/ and /hello/g?', options: [
      QuizOption(text: '/hello/ finds only the first match; /hello/g finds ALL matches in the string', correct: true),
      QuizOption(text: '/hello/g is case-insensitive; /hello/ is case-sensitive', correct: false),
      QuizOption(text: '/hello/g matches at the global scope; /hello/ only matches locally', correct: false),
      QuizOption(text: 'They are identical — the g flag has no effect on string.match()', correct: false),
    ]),
    Quiz(question: 'What do named capturing groups (?<name>...) provide?', options: [
      QuizOption(text: 'Access to match values by name (match.groups.name) and named backreferences in replacements (\$<name>)', correct: true),
      QuizOption(text: 'A way to name the entire regex pattern for reuse in other expressions', correct: false),
      QuizOption(text: 'They make the group optional — the name is used as a default if no match', correct: false),
      QuizOption(text: 'Named groups replace numbered groups — you cannot mix them', correct: false),
    ]),
    Quiz(question: 'What does the lookahead (?=...) assertion do?', options: [
      QuizOption(text: 'It asserts that the pattern is followed by something without including it in the match', correct: true),
      QuizOption(text: 'It looks ahead in the string and captures all remaining characters', correct: false),
      QuizOption(text: 'It matches the start of the string like the ^ anchor', correct: false),
      QuizOption(text: 'It makes the preceding quantifier non-greedy (lazy)', correct: false),
    ]),
  ],
);
