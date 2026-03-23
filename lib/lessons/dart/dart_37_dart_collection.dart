import '../../models/lesson.dart';
import '../../models/quiz.dart';

final dartLesson37 = Lesson(
  language: 'Dart',
  title: 'dart:collection',
  content: '''
🎯 METAPHOR:
dart:collection is like the professional kitchen tool shop.
The standard kitchen (dart:core) has knives, pans, and a stove.
But serious chefs need specialized equipment: a mandoline
slicer (SplayTreeMap for sorted lookups), a squeeze bottle
with precise flow control (Queue for FIFO/LIFO operations),
a pastry comb (LinkedHashMap for insertion-ordered iteration).
These tools aren't needed for every recipe, but when you need
them, using the right tool makes the difference between
professional results and amateur approximations.

📖 EXPLANATION:
dart:collection provides specialized collection classes
beyond the core List, Map, and Set. These give precise
control over ordering, access patterns, and performance
characteristics.

─────────────────────────────────────
📦 KEY CLASSES
─────────────────────────────────────
Queue<T>           → double-ended queue (O(1) both ends)
LinkedHashMap<K,V> → insertion-order-preserving map (DEFAULT!)
HashMap<K,V>       → unordered map (slightly faster)
SplayTreeMap<K,V>  → sorted map (O(log n) operations)
LinkedHashSet<T>   → insertion-order-preserving set
HashSet<T>         → unordered set (faster contains)
SplayTreeSet<T>    → sorted set

MapBase            → base class for custom maps
ListBase           → base class for custom lists
SetBase            → base class for custom sets
IterableBase       → base class for custom iterables

UnmodifiableListView → read-only view of a list
UnmodifiableMapView  → read-only view of a map
UnmodifiableSetView  → read-only view of a set

─────────────────────────────────────
🔑 QUEUE — O(1) BOTH ENDS
─────────────────────────────────────
Queue is a double-ended queue (deque).
O(1) add/remove at BOTH front and back.

List.insert(0, item)  → O(n) — shifts all elements!
Queue.addFirst(item)  → O(1) — no shifting needed!

Use Queue for:
  • BFS (breadth-first search)
  • Job queues
  • Undo/redo stacks
  • Sliding window algorithms

─────────────────────────────────────
🗺️  MAP TYPES COMPARED
─────────────────────────────────────
HashMap:       fastest, unordered, O(1) average
LinkedHashMap: insertion order, O(1), slightly slower (DEFAULT in Dart!)
SplayTreeMap:  sorted by key, O(log n), best for range queries

─────────────────────────────────────
📋 CUSTOM COLLECTION BASE CLASSES
─────────────────────────────────────
Extend MapBase, ListBase, SetBase to create custom
collections with minimal boilerplate. Only implement
the key methods; all others are derived automatically.

💻 CODE:
import 'dart:collection';

void main() {
  // ── QUEUE ──────────────────────
  final queue = Queue<int>();

  // Add to back (like List.add)
  queue.addLast(1);
  queue.addLast(2);
  queue.addLast(3);

  // Add to front (O(1)!)
  queue.addFirst(0);
  queue.addFirst(-1);

  print(queue);   // {-1, 0, 1, 2, 3}
  print(queue.first);  // -1
  print(queue.last);   // 3

  // Remove from front (FIFO)
  print(queue.removeFirst());  // -1
  print(queue.removeFirst());  // 0
  print(queue);   // {1, 2, 3}

  // Remove from back (LIFO)
  print(queue.removeLast());   // 3
  print(queue);   // {1, 2}

  // From iterable
  final q2 = Queue.from([10, 20, 30, 40]);
  print(q2.length);  // 4

  // BFS with Queue
  print('\nBFS order:');
  bfs({'A': ['B', 'C'], 'B': ['D', 'E'], 'C': ['F']}, 'A');

  // ── LINKEDHASHMAP ──────────────
  // Note: Dart's default {} literal creates a LinkedHashMap!
  final linked = LinkedHashMap<String, int>();
  linked['banana'] = 2;
  linked['apple']  = 1;
  linked['cherry'] = 3;

  // Iterates in INSERTION order
  print('\nLinkedHashMap insertion order:');
  linked.forEach((k, v) => print('  \$k: \$v'));
  // banana: 2, apple: 1, cherry: 3

  // Regular {} also preserves order (it's LinkedHashMap):
  final regular = {'z': 26, 'a': 1, 'm': 13};
  print(regular.keys.toList());  // [z, a, m] — insertion order!

  // ── HASHMAP ────────────────────
  // Faster but unordered — good when you only do lookups
  final fast = HashMap<String, int>();
  fast['c'] = 3;
  fast['a'] = 1;
  fast['b'] = 2;

  // Order not guaranteed
  print('\nHashMap (no order guarantee):');
  fast.forEach((k, v) => print('  \$k: \$v'));

  // Performance: use when iteration order doesn't matter
  print(fast.containsKey('b'));   // true, O(1)

  // ── SPLAYTREEMAP ───────────────
  // Sorted by key — O(log n) operations
  final sorted = SplayTreeMap<String, int>();
  sorted['banana'] = 2;
  sorted['apple']  = 1;
  sorted['cherry'] = 3;
  sorted['date']   = 4;

  print('\nSplayTreeMap (sorted):');
  sorted.forEach((k, v) => print('  \$k: \$v'));
  // apple: 1, banana: 2, cherry: 3, date: 4

  // Range queries!
  final range = sorted.submap('b', 'c');  // keys from b to c
  // Note: submap takes fromKey, toKey
  print(sorted.firstKey());   // apple
  print(sorted.lastKey());    // date

  // Custom sort order
  final byLength = SplayTreeMap<String, int>((a, b) => a.length.compareTo(b.length));
  byLength['banana'] = 2;
  byLength['hi'] = 0;
  byLength['cherry'] = 3;
  byLength['yo'] = 0;
  print('\nSorted by key length:');
  byLength.forEach((k, v) => print('  \$k'));
  // hi, yo, banana, cherry

  // ── LINKEDHASHSET ──────────────
  final lhSet = LinkedHashSet<String>();
  lhSet.add('banana');
  lhSet.add('apple');
  lhSet.add('cherry');
  lhSet.add('apple');   // duplicate — ignored but order preserved!

  print('\nLinkedHashSet:');
  print(lhSet.toList());   // [banana, apple, cherry]

  // ── HASHSET ────────────────────
  // Faster contains() — no order
  final hSet = HashSet<int>.from([3, 1, 4, 1, 5, 9, 2, 6, 5]);
  print('\nHashSet (no order):');
  print(hSet.contains(5));   // true, O(1)
  // Order not guaranteed

  // ── SPLAYTREESET ───────────────
  final treeSet = SplayTreeSet<int>.from([5, 3, 8, 1, 9, 2]);
  print('\nSplayTreeSet (sorted):');
  print(treeSet.toList());   // [1, 2, 3, 5, 8, 9]
  print(treeSet.first);      // 1
  print(treeSet.last);       // 9

  // ── UNMODIFIABLE VIEWS ─────────
  final mutableList = [1, 2, 3, 4, 5];
  final readOnly = UnmodifiableListView(mutableList);

  print('\nUnmodifiable list:');
  print(readOnly[2]);          // 3 — reading ✅
  try {
    readOnly.add(6);           // ❌ throws
  } catch (e) {
    print('Caught: \$e');
  }

  // But underlying list can still change!
  mutableList.add(6);
  print(readOnly.length);   // 6 — reflects changes

  // ── CUSTOM LIST ────────────────
  final bounded = BoundedList<int>(maxSize: 3);
  bounded.add(1);
  bounded.add(2);
  bounded.add(3);
  print(bounded);    // [1, 2, 3]
  bounded.add(4);    // removes oldest!
  print(bounded);    // [2, 3, 4]

  // ── LRUCACHE ───────────────────
  final cache = LRUCache<String, String>(capacity: 3);
  cache['a'] = 'Apple';
  cache['b'] = 'Banana';
  cache['c'] = 'Cherry';
  print(cache['a']);    // Apple — accessed, moves to end
  cache['d'] = 'Date'; // evicts 'b' (least recently used)
  print(cache.containsKey('b'));  // false — evicted!
  print(cache.containsKey('a'));  // true — recently accessed
}

// BFS using Queue
void bfs(Map<String, List<String>> graph, String start) {
  final visited = <String>{};
  final queue = Queue<String>();
  queue.addLast(start);

  while (queue.isNotEmpty) {
    final node = queue.removeFirst();
    if (visited.contains(node)) continue;
    visited.add(node);
    print('  Visited: \$node');

    for (final neighbor in graph[node] ?? []) {
      if (!visited.contains(neighbor)) {
        queue.addLast(neighbor);
      }
    }
  }
}

// Custom collection using ListBase
class BoundedList<T> extends ListBase<T> {
  final int maxSize;
  final List<T> _inner = [];

  BoundedList({required this.maxSize});

  @override
  int get length => _inner.length;

  @override
  set length(int n) => _inner.length = n;

  @override
  T operator [](int index) => _inner[index];

  @override
  void operator []=(int index, T value) => _inner[index] = value;

  @override
  void add(T element) {
    if (_inner.length >= maxSize) _inner.removeAt(0);
    _inner.add(element);
  }
}

// LRU Cache using LinkedHashMap
class LRUCache<K, V> {
  final int capacity;
  final LinkedHashMap<K, V> _map = LinkedHashMap();

  LRUCache({required this.capacity});

  V? operator [](K key) {
    if (!_map.containsKey(key)) return null;
    // Move to end (most recently used)
    final value = _map.remove(key)!;
    _map[key] = value;
    return value;
  }

  void operator []=(K key, V value) {
    if (_map.containsKey(key)) _map.remove(key);
    else if (_map.length >= capacity) _map.remove(_map.keys.first);
    _map[key] = value;
  }

  bool containsKey(K key) => _map.containsKey(key);
}

📝 KEY POINTS:
✅ Queue provides O(1) add/remove at BOTH ends — use for BFS, job queues
✅ Dart's default {} map IS a LinkedHashMap — insertion order preserved!
✅ HashMap is faster for pure lookup (no iteration order needed)
✅ SplayTreeMap automatically keeps keys sorted — use for range queries
✅ LinkedHashSet preserves insertion order; HashSet is faster for contains
✅ SplayTreeSet keeps elements sorted with O(log n) operations
✅ UnmodifiableListView creates a read-only window into a list
✅ Extend ListBase/MapBase/SetBase for custom collections with minimal code
❌ List.insert(0, item) is O(n) — use Queue.addFirst() for O(1)
❌ SplayTreeMap operations are O(log n), not O(1) like HashMap
❌ UnmodifiableListView reflects changes to the underlying list!
''',
  quiz: [
    Quiz(question: 'Why is Queue preferred over List when adding elements to the front?', options: [
      QuizOption(text: 'Queue uses less memory than List', correct: false),
      QuizOption(text: 'Queue.addFirst() is O(1); List.insert(0, item) is O(n) because it shifts all elements', correct: true),
      QuizOption(text: 'Queue is thread-safe; List is not', correct: false),
      QuizOption(text: 'Queue supports null elements; List does not', correct: false),
    ]),
    Quiz(question: 'What type does the Dart {} map literal actually create?', options: [
      QuizOption(text: 'HashMap — fastest unordered map', correct: false),
      QuizOption(text: 'LinkedHashMap — preserves insertion order', correct: true),
      QuizOption(text: 'SplayTreeMap — sorted by key', correct: false),
      QuizOption(text: 'A generic Map<K,V> with no specific implementation', correct: false),
    ]),
    Quiz(question: 'When should you use SplayTreeMap instead of HashMap?', options: [
      QuizOption(text: 'When you need faster lookups', correct: false),
      QuizOption(text: 'When keys must be sorted or you need range queries like "all keys between A and B"', correct: true),
      QuizOption(text: 'When map size is very large', correct: false),
      QuizOption(text: 'When values are nullable', correct: false),
    ]),
  ],
);
