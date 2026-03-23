import '../../models/lesson.dart';
import '../../models/quiz.dart';

final dartLesson12 = Lesson(
  language: 'Dart',
  title: 'Maps & Sets',
  content: '''
🎯 METAPHOR:
A Map is like a dictionary — you look up a word (key)
to find its definition (value). Keys are unique: there's
only one entry for "apple." The dictionary doesn't care
what page the word is on (no index) — you find things
by the word itself. A Set is like a club's guest list:
each person (value) appears exactly once. If you try to
add the same person twice, they're still only on the list
once. Sets excel at membership checks (is Alice invited?),
deduplication, and set operations like union and intersection.

📖 EXPLANATION:
Map<K, V> is Dart's key-value collection (hash map by default).
Set<T> is Dart's unordered collection of unique values.
Both are generic, null-safe, and have rich APIs.

─────────────────────────────────────
🗺️  MAP
─────────────────────────────────────
Creating:
  var map = {'key': 'value'};          // inferred
  Map<String, int> ages = {};          // empty
  Map<String, int> ages = {'Alice': 30, 'Bob': 25};

Accessing:
  map['key']              → value or null if missing
  map['key'] ?? default   → with fallback
  map.containsKey('key')  → bool
  map.containsValue(val)  → bool

Modifying:
  map['key'] = value      → add or update
  map.remove('key')       → returns removed value
  map.putIfAbsent('k', () => v) → add only if absent
  map.update('k', (old) => new) → update existing
  map.updateAll((k, v) => ...)  → update all values

Iterating:
  map.keys         → Iterable<K>
  map.values       → Iterable<V>
  map.entries      → Iterable<MapEntry<K,V>>

─────────────────────────────────────
🔵 SET
─────────────────────────────────────
Creating:
  var set = {1, 2, 3};               // Set<int>
  Set<String> names = {};            // empty set (not Map!)
  var empty = <String>{};            // empty typed set

Adding / Removing:
  set.add(item)            → true if added (false if existed)
  set.addAll(iterable)     → add all
  set.remove(item)         → true if removed
  set.clear()              → remove all

Set operations:
  a.union(b)               → all elements from both
  a.intersection(b)        → only in both
  a.difference(b)          → in a but not in b
  a.containsAll(b)         → all of b is in a?
  a.isSubsetOf(b)          → all of a is in b?

─────────────────────────────────────
⚡ MAP vs SET LITERAL AMBIGUITY
─────────────────────────────────────
{}  by itself → Map<dynamic, dynamic> (empty map!)
Use <String>{} or {} typed as Set<String> for empty set.

─────────────────────────────────────
🔢 LINKED MAP & SORTED MAP
─────────────────────────────────────
dart:collection:
  LinkedHashMap  → preserves insertion order (default)
  HashMap        → faster, random order
  SplayTreeMap   → sorted by key

💻 CODE:
import 'dart:collection';

void main() {
  // ── CREATING MAPS ─────────────
  var map1 = {'name': 'Alice', 'age': '30'};  // Map<String,String>
  Map<String, int> scores = {
    'Alice': 92,
    'Bob': 78,
    'Carol': 95,
  };
  var empty = <String, int>{};   // empty map

  print(map1);          // {name: Alice, age: 30}
  print(scores);        // {Alice: 92, Bob: 78, Carol: 95}
  print(scores.length); // 3

  // ── ACCESSING ─────────────────
  print(scores['Alice']);        // 92
  print(scores['Dave']);         // null (missing key)
  print(scores['Dave'] ?? 0);   // 0 (with default)

  // containsKey / containsValue
  print(scores.containsKey('Bob'));    // true
  print(scores.containsValue(100));   // false
  print(scores.containsValue(92));    // true

  // keys, values, entries
  print(scores.keys.toList());    // [Alice, Bob, Carol]
  print(scores.values.toList());  // [92, 78, 95]

  for (final entry in scores.entries) {
    print('\${entry.key}: \${entry.value}');
  }
  // Alice: 92  Bob: 78  Carol: 95

  // Destructured entry
  for (final MapEntry(:key, :value) in scores.entries) {
    print('\$key scored \$value');
  }

  // ── MODIFYING ─────────────────
  var ages = <String, int>{};
  ages['Alice'] = 30;         // add
  ages['Bob'] = 25;           // add
  ages['Alice'] = 31;         // update (overwrites)
  print(ages);   // {Alice: 31, Bob: 25}

  // putIfAbsent — only adds if key doesn't exist
  ages.putIfAbsent('Carol', () => 35);
  ages.putIfAbsent('Alice', () => 99);  // NOT added — Alice exists
  print(ages);   // {Alice: 31, Bob: 25, Carol: 35}

  // update — update existing value (throws if key missing)
  ages.update('Alice', (old) => old + 1);
  print(ages['Alice']);  // 32

  // update with ifAbsent — add or update
  ages.update('Dave', (old) => old + 1, ifAbsent: () => 0);
  print(ages['Dave']);   // 0

  // remove
  int? removed = ages.remove('Dave');
  print(removed);   // 0
  print(ages.containsKey('Dave'));  // false

  // removeWhere
  ages.removeWhere((key, value) => value < 30);
  print(ages);   // {Alice: 32, Carol: 35}

  // updateAll
  ages.updateAll((key, value) => value + 100);
  print(ages);   // {Alice: 132, Carol: 135}

  // ── TRANSFORMATION ────────────
  // map the map!
  var squared = scores.map(
    (key, value) => MapEntry(key, value * value),
  );
  print(squared);  // {Alice: 8464, Bob: 6084, Carol: 9025}

  // Convert to list of records
  var list = scores.entries
      .map((e) => (name: e.key, score: e.value))
      .toList();
  print(list[0].name);   // Alice

  // from list
  var names = ['Alice', 'Bob', 'Carol'];
  var nameIndex = Map.fromEntries(
    names.indexed.map((entry) => MapEntry(entry.\$2, entry.\$1)),
  );
  print(nameIndex);  // {Alice: 0, Bob: 1, Carol: 2}

  // ── SETS ──────────────────────
  var set1 = {1, 2, 3, 4, 5};         // Set<int>
  var set2 = <String>{'apple', 'banana', 'cherry'};
  var emptySet = <int>{};             // empty set (NOT map!)

  print(set1);          // {1, 2, 3, 4, 5}
  print(set1.length);   // 5

  // Duplicates are ignored!
  var dedup = {1, 2, 2, 3, 3, 3};
  print(dedup);  // {1, 2, 3}

  // Convert list to set (removes duplicates)
  var withDupes = [1, 2, 2, 3, 3, 3, 4];
  var unique = withDupes.toSet();
  print(unique);  // {1, 2, 3, 4}

  // ── SET OPERATIONS ────────────
  var a = {1, 2, 3, 4, 5};
  var b = {3, 4, 5, 6, 7};

  print(a.union(b));           // {1, 2, 3, 4, 5, 6, 7}
  print(a.intersection(b));    // {3, 4, 5}
  print(a.difference(b));      // {1, 2}
  print(b.difference(a));      // {6, 7}

  // Contains checks
  print(a.contains(3));        // true
  print(a.containsAll({1, 2})); // true
  print({1, 2}.isSubsetOf(a)); // ??? — not built-in

  // ── SET MODIFICATION ──────────
  var fruits = <String>{'apple', 'banana'};
  bool added = fruits.add('cherry');    // true — was added
  bool again = fruits.add('apple');     // false — already there
  print(added, again);
  print(fruits);  // {apple, banana, cherry}

  fruits.addAll({'date', 'elderberry'});
  fruits.remove('banana');
  print(fruits);  // {apple, cherry, date, elderberry}

  // ── LINKED HASH MAP ───────────
  var linked = LinkedHashMap<String, int>();
  linked['c'] = 3;
  linked['a'] = 1;
  linked['b'] = 2;
  print(linked.keys.toList());  // [c, a, b] — insertion order!

  // ── SORTED MAP ────────────────
  var sorted = SplayTreeMap<String, int>();
  sorted['banana'] = 2;
  sorted['apple'] = 1;
  sorted['cherry'] = 3;
  print(sorted.keys.toList());  // [apple, banana, cherry] — sorted!

  // ── COLLECTION IF IN MAP ───────
  bool isAdmin = true;
  var config = {
    'theme': 'dark',
    'language': 'en',
    if (isAdmin) 'adminPanel': 'enabled',
    if (isAdmin) ...{'users': 'manage', 'settings': 'full'},
  };
  print(config);
}

📝 KEY POINTS:
✅ Map<K,V> is a key-value collection; Set<T> is unique unordered values
✅ Map access with [] returns null for missing keys — use ?? for defaults
✅ putIfAbsent only inserts if the key doesn't already exist
✅ Set automatically deduplicates — adding a duplicate is silently ignored
✅ Union, intersection, and difference are first-class Set operations
✅ {} alone creates an empty Map, NOT an empty Set — use <Type>{} for Set
✅ Collection if/spread works in map and set literals too
✅ LinkedHashMap preserves insertion order (Dart's default HashMap does too)
❌ Don't assume map['key'] is non-null without a null check or ??
❌ {} creates a Map — to create an empty Set write <String>{} with a type
❌ Sets are unordered — don't rely on iteration order (use LinkedHashSet if needed)
''',
  quiz: [
    Quiz(question: 'What does {} create in Dart if no type is specified?', options: [
      QuizOption(text: 'An empty Set<dynamic>', correct: false),
      QuizOption(text: 'An empty Map<dynamic, dynamic>', correct: true),
      QuizOption(text: 'A compile error — ambiguous syntax', correct: false),
      QuizOption(text: 'An empty List', correct: false),
    ]),
    Quiz(question: 'What does Set A intersection B return?', options: [
      QuizOption(text: 'All elements from A and B combined', correct: false),
      QuizOption(text: 'Only elements that exist in both A and B', correct: true),
      QuizOption(text: 'Elements in A but not in B', correct: false),
      QuizOption(text: 'The number of elements in common', correct: false),
    ]),
    Quiz(question: 'What does map.putIfAbsent("key", () => 42) do if "key" already exists?', options: [
      QuizOption(text: 'Replaces the existing value with 42', correct: false),
      QuizOption(text: 'Does nothing — the key already exists, so the existing value is kept', correct: true),
      QuizOption(text: 'Throws a StateError', correct: false),
      QuizOption(text: 'Adds a duplicate entry', correct: false),
    ]),
  ],
);
