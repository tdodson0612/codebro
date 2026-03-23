import '../../models/lesson.dart';
import '../../models/quiz.dart';

final dartLesson11 = Lesson(
  language: 'Dart',
  title: 'Lists',
  content: '''
🎯 METAPHOR:
A Dart List is like a numbered train with carriages.
Each carriage (element) has a seat number (index) starting
at 0. You can add carriages to the end, remove specific
carriages, or rearrange them. The train knows its length.
A fixed-length list is like a train with locked carriages
— you can change what's IN a carriage but not add or remove
carriages. A growable list is the default: hitch new
carriages on whenever you need them.

📖 EXPLANATION:
List<T> is Dart's ordered, indexable collection.
Like arrays in other languages, but with powerful built-in
methods. Lists are zero-indexed, generic, and can be
growable (default) or fixed-length.

─────────────────────────────────────
📐 CREATING LISTS
─────────────────────────────────────
var list = [1, 2, 3];              // List<int> inferred
List<String> names = ['Alice', 'Bob'];
var empty = <int>[];               // empty typed list
var filled = List.filled(3, 0);    // [0, 0, 0] fixed-length
var generated = List.generate(5, (i) => i * 2); // [0,2,4,6,8]

─────────────────────────────────────
🔑 KEY PROPERTIES
─────────────────────────────────────
list.length          → number of elements
list.isEmpty         → true if empty
list.isNotEmpty      → true if not empty
list.first           → first element (throws if empty)
list.last            → last element (throws if empty)
list.reversed        → iterable in reverse order
list.single          → if exactly 1 element (throws otherwise)

─────────────────────────────────────
📝 ACCESSING ELEMENTS
─────────────────────────────────────
list[0]              → first element
list[list.length-1]  → last element (or list.last)
list.elementAt(i)    → same as list[i]
list.indexOf(item)   → index of item (-1 if not found)
list.contains(item)  → true if item is in list

─────────────────────────────────────
➕ ADDING & REMOVING
─────────────────────────────────────
list.add(item)           → add to end
list.addAll([a, b, c])   → add all elements
list.insert(i, item)     → insert at index
list.insertAll(i, list)  → insert all at index
list.remove(item)        → remove first occurrence
list.removeAt(i)         → remove element at index
list.removeLast()        → remove and return last
list.removeWhere(pred)   → remove all where predicate true
list.clear()             → remove all elements

─────────────────────────────────────
🔄 SORTING & REORDERING
─────────────────────────────────────
list.sort()                   → natural order (in place)
list.sort((a, b) => ...)     → custom comparator
list.shuffle()                → random order (in place)
list.reversed.toList()        → new reversed list

─────────────────────────────────────
✂️  SUBSETS
─────────────────────────────────────
list.sublist(start)           → from start to end
list.sublist(start, end)      → from start to end (exclusive)
list.take(n).toList()         → first n elements
list.skip(n).toList()         → skip first n elements
list.where(pred).toList()     → filtered elements

─────────────────────────────────────
🔀 TRANSFORMATION
─────────────────────────────────────
list.map((e) => ...).toList() → transform each element
list.expand((e) => ...).toList() → flatMap
list.fold(init, (acc, e) => ...) → accumulate
list.reduce((acc, e) => ...)     → reduce (no init)
list.join(', ')                  → join to String

─────────────────────────────────────
🏗️  SPREAD IN LIST LITERALS
─────────────────────────────────────
var combined = [...list1, ...list2];
var safe = [...list1, ...?nullableList];

// Collection if (Dart)
var result = [
  'always',
  if (condition) 'conditional',
  if (other) 'other' else 'fallback',
];

// Collection for (Dart)
var squares = [
  for (var i = 1; i <= 5; i++) i * i
];  // [1, 4, 9, 16, 25]

💻 CODE:
void main() {
  // ── CREATING LISTS ────────────
  var nums = [1, 2, 3, 4, 5];            // List<int>
  List<String> names = ['Alice', 'Bob', 'Carol'];
  var empty = <double>[];                 // empty List<double>
  var zeros = List.filled(5, 0);         // [0, 0, 0, 0, 0]
  var squares = List.generate(6, (i) => i * i); // [0,1,4,9,16,25]
  var chars = List.generate(5, (i) => String.fromCharCode(65 + i));
  // [A, B, C, D, E]

  print(nums);     // [1, 2, 3, 4, 5]
  print(names);    // [Alice, Bob, Carol]
  print(squares);  // [0, 1, 4, 9, 16, 25]
  print(chars);    // [A, B, C, D, E]

  // ── ACCESSING ─────────────────
  print(names[0]);       // Alice
  print(names.first);    // Alice
  print(names.last);     // Carol
  print(names.length);   // 3
  print(names.isEmpty);  // false

  // Safe access with null check
  String? first = nums.isNotEmpty ? nums.first.toString() : null;

  // ── ADDING & REMOVING ─────────
  var fruits = ['apple', 'banana'];
  fruits.add('cherry');
  print(fruits);   // [apple, banana, cherry]

  fruits.addAll(['date', 'elderberry']);
  print(fruits);   // [apple, banana, cherry, date, elderberry]

  fruits.insert(1, 'avocado');
  print(fruits);   // [apple, avocado, banana, cherry, date, elderberry]

  fruits.remove('avocado');
  print(fruits);   // [apple, banana, cherry, date, elderberry]

  fruits.removeAt(0);
  print(fruits);   // [banana, cherry, date, elderberry]

  String last = fruits.removeLast();
  print(last);     // elderberry
  print(fruits);   // [banana, cherry, date]

  fruits.removeWhere((f) => f.startsWith('c'));
  print(fruits);   // [banana, date]

  fruits.clear();
  print(fruits);   // []

  // ── SORTING ───────────────────
  var numbers = [3, 1, 4, 1, 5, 9, 2, 6];
  numbers.sort();           // sorts in place
  print(numbers);  // [1, 1, 2, 3, 4, 5, 6, 9]

  numbers.sort((a, b) => b.compareTo(a));  // descending
  print(numbers);  // [9, 6, 5, 4, 3, 2, 1, 1]

  var words = ['banana', 'apple', 'cherry', 'date'];
  words.sort((a, b) => a.length.compareTo(b.length));  // by length
  print(words);  // [date, apple, banana, cherry]

  // ── SEARCHING ─────────────────
  var list = [10, 20, 30, 40, 50];
  print(list.contains(30));        // true
  print(list.indexOf(30));         // 2
  print(list.indexOf(99));         // -1 (not found)
  print(list.indexWhere((n) => n > 25));  // 2
  print(list.lastIndexWhere((n) => n < 40)); // 2

  // ── SUBLIST & SLICING ─────────
  var all = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
  print(all.sublist(3));      // [3, 4, 5, 6, 7, 8, 9]
  print(all.sublist(3, 7));   // [3, 4, 5, 6]
  print(all.take(3).toList()); // [0, 1, 2]
  print(all.skip(7).toList()); // [7, 8, 9]

  // ── TRANSFORMATION ────────────
  var data = [1, 2, 3, 4, 5];

  var doubled = data.map((n) => n * 2).toList();
  print(doubled);  // [2, 4, 6, 8, 10]

  var evens = data.where((n) => n.isEven).toList();
  print(evens);    // [2, 4]

  // expand (flatMap)
  var nested = [[1,2], [3,4], [5,6]];
  var flat = nested.expand((e) => e).toList();
  print(flat);     // [1, 2, 3, 4, 5, 6]

  var sum = data.reduce((a, b) => a + b);
  print(sum);      // 15

  var product = data.fold(1, (acc, n) => acc * n);
  print(product);  // 120

  print(data.join(', '));  // 1, 2, 3, 4, 5

  // ── COLLECTION IF & FOR ────────
  bool includeAdmin = true;
  var menu = [
    'Home',
    'Profile',
    if (includeAdmin) 'Admin Panel',
    if (includeAdmin) ...[  // spread + collection if
      'Users',
      'Settings',
    ],
  ];
  print(menu);  // [Home, Profile, Admin Panel, Users, Settings]

  var table = [
    for (var i = 1; i <= 5; i++)
      for (var j = 1; j <= 5; j++)
        i * j,
  ];
  print(table.length);  // 25 (5x5 multiplication table flattened)

  // ── SPREAD OPERATOR ───────────
  var a = [1, 2, 3];
  var b = [4, 5, 6];
  var merged = [...a, 0, ...b];
  print(merged);   // [1, 2, 3, 0, 4, 5, 6]

  List<int>? maybe;
  var safe = [...a, ...?maybe];  // null-safe spread
  print(safe);     // [1, 2, 3]

  // ── CONST & FIXED-LENGTH ──────
  const constList = [1, 2, 3];   // compile-time, fully immutable
  // constList.add(4);  // ❌ Error

  var fixedList = List.filled(5, 0, growable: false);
  fixedList[0] = 99;       // ✅ can change elements
  // fixedList.add(1);     // ❌ Error: fixed length

  // ── LIST.OF / UNMODIFIABLE ─────
  var original = [1, 2, 3];
  var copy = List.of(original);     // growable copy
  var unmod = List.unmodifiable(original);  // view that can't be modified
  // unmod.add(4);  // ❌ UnsupportedError
}

📝 KEY POINTS:
✅ List<T> is zero-indexed, ordered, and generic
✅ Use List.generate() for programmatically created lists
✅ Collection if/for inside list literals for inline conditional/loop elements
✅ Spread ... merges lists; ...? handles nullable lists safely
✅ .sort() modifies in place; pass a comparator for custom order
✅ .where() filters (returns Iterable); .map() transforms (returns Iterable)
✅ Always call .toList() after lazy operations to materialize the result
✅ List.unmodifiable() creates a view that throws on modification attempts
❌ Don't use list[i] without bounds checking — throws RangeError
❌ .add() on a fixed-length list throws UnsupportedError
❌ const list cannot be modified at all — not even elements
''',
  quiz: [
    Quiz(question: 'What does List.generate(5, (i) => i * i) produce?', options: [
      QuizOption(text: '[1, 4, 9, 16, 25]', correct: false),
      QuizOption(text: '[0, 1, 4, 9, 16]', correct: true),
      QuizOption(text: '[5, 5, 5, 5, 5]', correct: false),
      QuizOption(text: '[0, 1, 2, 3, 4]', correct: false),
    ]),
    Quiz(question: 'What is a "collection if" in Dart?', options: [
      QuizOption(text: 'Checking if a list is null', correct: false),
      QuizOption(text: 'An if expression inside a list literal that conditionally includes elements', correct: true),
      QuizOption(text: 'A method to filter a list', correct: false),
      QuizOption(text: 'A way to collect if statements', correct: false),
    ]),
    Quiz(question: 'What is the difference between .map() and .where() on a List?', options: [
      QuizOption(text: '.map() filters elements; .where() transforms them', correct: false),
      QuizOption(text: '.map() transforms each element; .where() filters elements by a predicate', correct: true),
      QuizOption(text: 'They are the same — just different names', correct: false),
      QuizOption(text: '.where() is only for strings; .map() works on any type', correct: false),
    ]),
  ],
);
