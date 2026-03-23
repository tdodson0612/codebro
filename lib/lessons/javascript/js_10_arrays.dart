import '../../models/lesson.dart';
import '../../models/quiz.dart';

final jsLesson10 = Lesson(
  language: 'JavaScript',
  title: 'Arrays: Creation, Methods, and Patterns',
  content: """
🎯 METAPHOR:
A JavaScript array is like a Swiss Army knife — one tool
that does dozens of things. It's a list, a stack, a queue,
a set of data to transform. The methods are the different
blades: slice cuts out a piece, splice modifies in place,
map transforms every item, filter selects some, reduce
collapses everything into one value. The key insight is
that most array operations RETURN NEW arrays — they don't
modify the original. This immutable-friendly style (map,
filter, reduce, slice) is the modern way to work with
arrays, as opposed to the mutating methods (push, pop,
sort, splice, reverse) that modify in place.

📖 EXPLANATION:

─────────────────────────────────────
CREATING ARRAYS:
─────────────────────────────────────
  []                     → empty array literal
  [1, 2, 3]              → array literal
  new Array(5)           → [,,,,] — 5 empty slots (avoid!)
  new Array(1, 2, 3)     → [1, 2, 3]
  Array.from("hello")    → ['h','e','l','l','o']
  Array.from({length:5}, (_,i) => i)  → [0,1,2,3,4]
  Array.of(3)            → [3] (vs new Array(3) which makes holes)
  [...iterable]          → spread into array

─────────────────────────────────────
ACCESSING:
─────────────────────────────────────
  arr[0]                → first element
  arr[arr.length - 1]   → last element (old way)
  arr.at(-1)            → last element (modern)
  arr.at(-2)            → second to last

─────────────────────────────────────
MUTATING METHODS (modify in place):
─────────────────────────────────────
  arr.push(a, b)      → add to end, returns new length
  arr.pop()           → remove and return last item
  arr.unshift(a)      → add to beginning, returns new length
  arr.shift()         → remove and return first item
  arr.splice(i, n, ...items) → remove n at index i, optionally insert
  arr.sort(compareFn) → sort in place (default: lexicographic!)
  arr.reverse()       → reverse in place
  arr.fill(val, start, end) → fill range with value
  arr.copyWithin(target, start, end) → copy portion within

─────────────────────────────────────
NON-MUTATING METHODS (return new array):
─────────────────────────────────────
  arr.map(fn)          → transform each element
  arr.filter(fn)       → keep matching elements
  arr.reduce(fn, init) → accumulate to single value
  arr.reduceRight(fn)  → reduce from right
  arr.slice(start, end)→ extract portion
  arr.concat(...arrs)  → combine arrays
  arr.flat(depth)      → flatten nested arrays
  arr.flatMap(fn)      → map then flatten one level
  arr.toReversed()     → ES2023: reverse without mutation
  arr.toSorted(fn)     → ES2023: sort without mutation
  arr.toSpliced(i,n,...items) → ES2023: splice without mutation
  arr.with(index, val) → ES2023: replace at index without mutation

─────────────────────────────────────
SEARCHING:
─────────────────────────────────────
  arr.indexOf(val)      → first index (-1 if not found)
  arr.lastIndexOf(val)  → last index
  arr.includes(val)     → boolean
  arr.find(fn)          → first matching element
  arr.findIndex(fn)     → index of first match
  arr.findLast(fn)      → ES2023: last matching element
  arr.findLastIndex(fn) → ES2023: index of last match

─────────────────────────────────────
TESTING:
─────────────────────────────────────
  arr.some(fn)         → true if any element matches
  arr.every(fn)        → true if all elements match

─────────────────────────────────────
CONVERTING:
─────────────────────────────────────
  arr.join(separator)  → string
  arr.toString()       → comma-separated string
  arr.entries()        → iterator of [index, value]
  arr.keys()           → iterator of indices
  arr.values()         → iterator of values

─────────────────────────────────────
STATIC METHODS:
─────────────────────────────────────
  Array.isArray(val)   → true if val is an array
  Array.from(iterable, mapFn) → create from iterable
  Array.of(...items)   → create from arguments

─────────────────────────────────────
DESTRUCTURING AND SPREAD:
─────────────────────────────────────
  const [a, b, c] = [1, 2, 3];
  const [first, ...rest] = [1, 2, 3, 4, 5];
  const combined = [...arr1, ...arr2];
  const copy = [...arr];  // shallow copy

─────────────────────────────────────
SORTING — THE GOTCHA:
─────────────────────────────────────
  [10, 9, 2, 1, 100].sort()
  → [1, 10, 100, 2, 9]  ← lexicographic! Wrong!

  // Numeric sort:
  [10, 9, 2, 1, 100].sort((a, b) => a - b)
  → [1, 2, 9, 10, 100] ✅

  // Sort objects:
  users.sort((a, b) => a.age - b.age)

💻 CODE:
// ─── CREATION ─────────────────────────────────────────
console.log("=== Array Creation ===");
const empty  = [];
const nums   = [1, 2, 3, 4, 5];
const mixed  = [1, "two", true, null, { x: 3 }];
const range  = Array.from({ length: 10 }, (_, i) => i + 1); // [1..10]
const chars  = Array.from("hello");                          // ['h','e','l','l','o']
const copy   = [...nums];  // shallow copy

console.log(range);    // [1,2,3,4,5,6,7,8,9,10]
console.log(chars);    // ['h','e','l','l','o']

// ─── ACCESS ───────────────────────────────────────────
console.log("\n=== Accessing Elements ===");
const fruits = ["apple", "banana", "cherry", "date", "elderberry"];
console.log(fruits[0]);         // "apple"
console.log(fruits.at(-1));     // "elderberry" ← last
console.log(fruits.at(-2));     // "date"
console.log(fruits.length);     // 5

// ─── MUTATING METHODS ─────────────────────────────────
console.log("\n=== Mutating Methods ===");
const stack = [1, 2, 3];
stack.push(4, 5);         // [1,2,3,4,5]
stack.pop();              // returns 5 → [1,2,3,4]
stack.unshift(0);         // [0,1,2,3,4]
stack.shift();            // returns 0 → [1,2,3,4]
console.log("Stack:", stack);

// splice — the Swiss Army method
const colors = ["red", "green", "blue", "yellow"];
const removed = colors.splice(1, 2, "purple", "pink");
console.log("After splice:", colors);   // ["red","purple","pink","yellow"]
console.log("Removed:", removed);        // ["green","blue"]

// Sort — ALWAYS provide comparator for numbers!
const unsorted = [10, 9, 2, 1, 100, 20];
console.log([...unsorted].sort());           // [1,10,100,2,20,9] ← wrong!
console.log([...unsorted].sort((a,b) => a-b)); // [1,2,9,10,20,100] ✅

// ─── NON-MUTATING METHODS ─────────────────────────────
console.log("\n=== Non-Mutating Methods ===");
const scores = [85, 92, 78, 96, 65, 88];

// map — transform
const doubled = scores.map(n => n * 2);
console.log("Doubled:", doubled);

// filter — select
const passing = scores.filter(n => n >= 80);
console.log("Passing:", passing);

// reduce — accumulate
const total = scores.reduce((sum, n) => sum + n, 0);
const avg = total / scores.length;
console.log("Average:", avg.toFixed(1));

// slice — extract (non-mutating)
console.log("Top 3:", [...scores].sort((a,b) => b-a).slice(0, 3));

// flat and flatMap
const nested = [[1, 2], [3, 4], [5, [6, 7]]];
console.log(nested.flat());      // [1,2,3,4,5,[6,7]]
console.log(nested.flat(2));     // [1,2,3,4,5,6,7]

const sentences = ["hello world", "foo bar"];
const words = sentences.flatMap(s => s.split(" "));
console.log(words);  // ["hello","world","foo","bar"]

// ─── SEARCHING ────────────────────────────────────────
console.log("\n=== Searching ===");
const people = [
  { name: "Alice", age: 28 },
  { name: "Bob",   age: 17 },
  { name: "Carol", age: 32 },
  { name: "Dave",  age: 15 },
];

console.log(people.find(p => p.age >= 18));       // Alice
console.log(people.findIndex(p => p.age >= 18));  // 0
console.log(people.some(p => p.age < 18));         // true
console.log(people.every(p => p.age > 10));        // true
console.log(scores.includes(96));                  // true

// ─── ES2023 IMMUTABLE METHODS ─────────────────────────
console.log("\n=== ES2023 Immutable Methods ===");
const original = [3, 1, 4, 1, 5, 9];
console.log("Original:", original);
console.log("toSorted:", original.toSorted((a,b) => a-b));
console.log("toReversed:", original.toReversed());
console.log("with(2, 99):", original.with(2, 99));
console.log("Original still:", original);  // unchanged!

// ─── DESTRUCTURING ────────────────────────────────────
console.log("\n=== Destructuring ===");
const [first, second, ...rest] = [1, 2, 3, 4, 5];
console.log(first, second, rest);   // 1 2 [3,4,5]

const [,, third] = [10, 20, 30, 40];  // skip with commas
console.log(third);  // 30

// Swap variables:
let x = 1, y = 2;
[x, y] = [y, x];
console.log(x, y);  // 2 1

// ─── PRACTICAL PATTERNS ───────────────────────────────
console.log("\n=== Practical Patterns ===");

// Group by
const groupBy = (arr, key) =>
  arr.reduce((groups, item) => {
    const group = item[key];
    groups[group] = groups[group] ?? [];
    groups[group].push(item);
    return groups;
  }, {});

const employees = [
  { name: "Alice", dept: "Engineering" },
  { name: "Bob",   dept: "Marketing" },
  { name: "Carol", dept: "Engineering" },
  { name: "Dave",  dept: "Marketing" },
];
console.log(groupBy(employees, "dept"));

// Unique values
const dupes = [1, 2, 2, 3, 3, 3, 4];
console.log([...new Set(dupes)]);  // [1,2,3,4]

// Chunk array
const chunk = (arr, size) =>
  Array.from({ length: Math.ceil(arr.length / size) },
    (_, i) => arr.slice(i * size, i * size + size));
console.log(chunk([1,2,3,4,5,6,7], 3)); // [[1,2,3],[4,5,6],[7]]

// Zip two arrays
const zip = (a, b) => a.map((item, i) => [item, b[i]]);
console.log(zip(["a","b","c"], [1, 2, 3]));

📝 KEY POINTS:
✅ arr.at(-1) is the modern way to get the last element (negative indices)
✅ map/filter/reduce/slice return NEW arrays — they don't modify the original
✅ push/pop/splice/sort/reverse MUTATE the array — copy first if you need the original
✅ ALWAYS provide a compare function to sort() for numbers — default sort is lexicographic
✅ Array.from({length: n}, fn) creates arrays with a mapping function
✅ flat() flattens nested arrays; flatMap() maps then flattens one level
✅ toSorted, toReversed, toSpliced, with (ES2023) are non-mutating versions
✅ [...new Set(arr)] removes duplicates using Set
❌ new Array(5) creates a sparse array with 5 holes — use Array.from or fill instead
❌ sort() without a comparator sorts lexicographically: [10, 9, 2] → [10, 2, 9]
❌ indexOf and includes use strict equality (===) — can't find NaN
""",
  quiz: [
    Quiz(
      question: 'What does [10, 9, 2, 1, 100].sort() produce and why is it surprising?',
      options: [
        QuizOption(text: '[1, 10, 100, 2, 9] — sort() converts to strings and sorts lexicographically by default', correct: true),
        QuizOption(text: '[1, 2, 9, 10, 100] — sort() sorts numerically by default', correct: false),
        QuizOption(text: 'It throws an error — sort() requires a comparison function', correct: false),
        QuizOption(text: '[100, 10, 9, 2, 1] — sort() defaults to descending order', correct: false),
      ],
    ),
    Quiz(
      question: 'What is the difference between arr.slice() and arr.splice()?',
      options: [
        QuizOption(text: 'slice() returns a portion without modifying the original; splice() modifies the array in place and can also insert elements', correct: true),
        QuizOption(text: 'slice() removes elements; splice() extracts elements', correct: false),
        QuizOption(text: 'They are identical — splice is just a typo variation of slice', correct: false),
        QuizOption(text: 'slice() works on strings; splice() only works on arrays', correct: false),
      ],
    ),
    Quiz(
      question: 'What does arr.flatMap(fn) do differently from arr.map(fn).flat()?',
      options: [
        QuizOption(text: 'They produce the same result, but flatMap() is more efficient — it maps and flattens in one pass', correct: true),
        QuizOption(text: 'flatMap() flattens at all depths; .map().flat() only flattens one level', correct: false),
        QuizOption(text: 'flatMap() works on nested arrays; .map().flat() only works on flat arrays', correct: false),
        QuizOption(text: 'flatMap() is an older method; .map().flat() is the modern replacement', correct: false),
      ],
    ),
  ],
);
